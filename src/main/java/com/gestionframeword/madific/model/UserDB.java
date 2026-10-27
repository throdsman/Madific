package com.gestionframeword.madific.model;

import com.gestionframeword.madific.model.User.UserBuilder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
 
public class UserDB
{
    public static int getTotalUsers()
    {
        System.out.println("Entrando a obtener el total de usuarios desde la BD...");
        int totalUsuarios = 0;
        
        String sql = "SELECT COUNT(*) FROM users";

        try (Connection conn = DBConnection.getInstance().CreateConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) 
        {
 
            if (rs.next()) {
                totalUsuarios = rs.getInt(1);  
            }

            System.out.println("Total de usuarios obtenido con éxito: " + totalUsuarios);
            return totalUsuarios;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return totalUsuarios;
    }
    
    public static List<User> getAllUsers()        
    {
        System.out.println("Entrando a la lista de usuarios desde la BD...");
       List<User> users = new ArrayList<>();
        
        String sql = "SELECT * FROM users";

        String sql2 = "SELECT * FROM personaldata WHERE user_id = ?";
        String sql3 = "SELECT * FROM emails WHERE personal_data_id = ?";
        String sql4 = "SELECT * FROM access WHERE access_id = ?";
        String sql5 = "SELECT * FROM roles WHERE role_id = ?";
        
        try (Connection conn = DBConnection.getInstance().CreateConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) 
        {
   
            while (rs.next())
            {
                // 2
                PreparedStatement dataPS = conn.prepareStatement(sql2);

                dataPS.setInt(1, rs.getInt("user_id"));

                ResultSet dataRS = dataPS.executeQuery();

                dataRS.next();

                // 3
                PreparedStatement emailPS = conn.prepareStatement(sql3);

                emailPS.setInt(1, dataRS.getInt("data_id"));

                ResultSet emailRS = emailPS.executeQuery();

                emailRS.next();

                // 4
                PreparedStatement accessPS = conn.prepareStatement(sql4);

                accessPS.setInt(1, rs.getInt("access_id"));

                ResultSet accessRS = accessPS.executeQuery();

                accessRS.next();

                // 5
                PreparedStatement rolePS = conn.prepareStatement(sql5);

                rolePS.setInt(1, rs.getInt("role_id"));

                ResultSet roleRS = rolePS.executeQuery();

                roleRS.next();
                
                UserBuilder ub = new UserBuilder();
                
                ub.setName(rs.getString("user_name"));
                ub.setEmail(emailRS.getString("email"));
                ub.setAccess(accessRS.getString("access_name"));
                ub.setRole(UserRole.valueOf(roleRS.getString("role_name")));
                
                users.add(ub.getUser()); 
            } 
            
            return users;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return users;
    }
    
    public static int add(User user)
    {
        String sql = "INSERT INTO users(user_name, user_pass, user_role, user_age)"
                     + "VALUES(?,?,?,?)";
        
        try
        {
            Connection conn = DBConnection.getInstance().CreateConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            
            //
            pstmt.setString(1, user.getName());
            //pstmt.setString(2, user.getEmail());
            pstmt.setString(3, user.getPass());
            pstmt.setString(4, user.getRole().name()); 
            pstmt.setInt(5, user.getAge());
            // if it were to be a loop, just batch it and repeat
            
            int insertedRow = pstmt.executeUpdate();
            if (insertedRow > 0)
            {
                var rs = pstmt.getGeneratedKeys();
                if (rs.next())
                {
                    return rs.getInt(1);
                }
            }
            
        }
        catch (Exception e)
        {
            System.out.println(e + "!!!!!!!!!!!!!!!!!!!!");
        }
                
        return -1;
    }
    
    public static boolean updateLastJoined(User user)
    {
        String sql = "UPDATE users SET user_last_access = ? WHERE user_id = ?";
        
        try
        {
            System.out.println("Tratando de actualizar la fecha: " + user.toString());
            
            Connection conn = DBConnection.getInstance().CreateConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql);
            
            //
            pstmt.setObject(1, java.time.LocalDate.now());
            pstmt.setInt(2, user.getId()); 
            
            int insertedRow = pstmt.executeUpdate();
            
            return insertedRow > 0; 
        }
        catch (Exception e)
        {
            e.printStackTrace(); 
            return false;
        } 
    }
    
    public static boolean DoesUserExist(String email)
    {
        String sql = "SELECT user_name FROM users WHERE user_email = ?";
        try 
        {
            Connection conn = DBConnection.getInstance().CreateConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            
            pstmt.setString(1, email);
            
            ResultSet rs = pstmt.executeQuery();
            
            return rs.next();
        }
        catch (Exception e)
        {
            return false;
        }
    }
    
    public static int getUsuariosRecientes() 
    {
        System.out.println("Calculando usuarios conectados en las últimas 24 horas...");
        int usuariosActivos = 0;

        // Consulta SQL optimizada para tipo DATE en PostgreSQL
        // Compara si la fecha del último acceso es mayor o igual a ayer / hoy
        String sql = "SELECT COUNT(*) FROM users WHERE user_last_access >= CURRENT_DATE - INTERVAL '1 day'";

        try (Connection conn = DBConnection.getInstance().CreateConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                usuariosActivos = rs.getInt(1); // Obtiene el resultado del COUNT(*)
            }

            System.out.println("Usuarios activos en las últimas 24 horas: " + usuariosActivos);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return usuariosActivos;
    }
    
    public static User GetUser(String email)
    {
        
        System.out.println("Entrando a Get User!!!!");
        try 
        {
            Connection conn = DBConnection.getInstance().CreateConnection();
             
        // rescatar el personal_data_id from emails
            String emailQuery = "SELECT personal_data_id FROM emails WHERE email = ?";
            var emailPS = conn.prepareStatement(emailQuery, Statement.NO_GENERATED_KEYS);
            
            emailPS.setString(1, email.trim());
            
            ResultSet emailResponse = emailPS.executeQuery();
             
            if (!emailResponse.next())
            {
                System.out.println("email does not EXIST!!!!!");
                return null;
            }
             
            int personal_data_id = emailResponse.getInt("personal_data_id");
            
        // rescatar el user_id from personaldata
            String personalQuery = "SELECT user_id FROM personaldata WHERE data_id = ?";
            
            var dataPS = conn.prepareStatement(personalQuery);
            
            dataPS.setInt(1, personal_data_id);
            
            ResultSet personalResponse = dataPS.executeQuery();
             
            if (!personalResponse.next())
            {
                System.out.println("data does not EXIST!!!!!");
                return null;
            } 
            
            int user_id = personalResponse.getInt("user_id");
             
            
        // rescatar rol_id from usuarios
        // rescatar access_id from usuarios
            String sql = "SELECT user_name, user_pass, role_id, access_id, user_id FROM users WHERE user_id = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            
            pstmt.setInt(1, user_id);
            
            ResultSet rs = pstmt.executeQuery();
            
            UserBuilder ub = new UserBuilder();
            
            if (!rs.next())
            {
                System.out.println("User does not EXIST!!!!!");
                return null;
            }
             
            ub.setEmail(email);
            ub.setId(rs.getInt("user_id"));
            ub.setName(rs.getString("user_name"));
            ub.setPass(rs.getString("user_pass"));
             
            // Role obtain
            int role_id = rs.getInt("role_id");
            String roleQuery = "SELECT role_name FROM roles WHERE role_id = ?";
            
            PreparedStatement rolePS = conn.prepareStatement(roleQuery, Statement.RETURN_GENERATED_KEYS);
            
            rolePS.setInt(1, role_id);
            
            ResultSet roleRS = rolePS.executeQuery();
            
            roleRS.next();
            
            ub.setRole(UserRole.valueOf(roleRS.getString("role_name")));
            
            // Access obtain
            int access_id = rs.getInt("access_id");
            String accessQuery = "SELECT access_name FROM access WHERE access_id = ?";
            
            PreparedStatement accessPS = conn.prepareStatement(accessQuery, Statement.RETURN_GENERATED_KEYS);
            
            accessPS.setInt(1, access_id);
            
            ResultSet accessRS = accessPS.executeQuery();
            
            accessRS.next();
            
            ub.setAccess(accessRS.getString("access_name"));
            
            var user = ub.getUser();
            
            System.out.println(user.toString());
            
            return user;
        }
        catch (Exception e)
        {
            System.out.println(e);
            return null;
        }
    } 

    private static int accessToInt(String acc)
    {
        acc = acc.toLowerCase();
        if (acc.compareTo("none") == 0)
        {
            return 1;
        }
        else if (acc.compareTo("low") == 0)
        {
            return 2;
        }
        else if (acc.compareTo("medium") == 0)
        {
            return 3;
        }
        else if (acc.compareTo("high") == 0)
        {
            return 4;
        }
        else if (acc.compareTo("admin") == 0)
        {
            return 5;
        }
        
        return 0;
    }
    
    public static boolean registrarUsuarioCompleto(User u) throws ClassNotFoundException
    {
        String sqlUser = "INSERT INTO users (user_name, user_pass, access_id, role_id, user_age) VALUES (?, ?, ?, ?, ?)";
        String sqlData = "INSERT INTO personaldata (data_first_name, data_last_name, data_dni, user_id) VALUES (?, ?, ?, ?)";
        String sqlEmail = "INSERT INTO emails (email, personal_data_id) VALUES (?, ?)";

        Connection conn = null;
        try {
            conn = DBConnection.getInstance().CreateConnection();
            conn.setAutoCommit(false); // Paso crítico: deshabilitar autocommit para la transacción

            int userId = 0;
            int personalDataId = 0;

            // 1. Insertar en la tabla USERS y recuperar el user_id autogenerado
            try (PreparedStatement psUser = conn.prepareStatement(sqlUser, Statement.RETURN_GENERATED_KEYS)) {
                psUser.setString(1, u.getName());
                psUser.setString(2, u.getPass()); // Recuerda aplicar hashing si tu sistema lo requiere
                psUser.setInt(3, accessToInt( u.getAccess() )); 
                psUser.setInt(4, u.getRole().ordinal() + 1);
                psUser.setInt(5, u.getAge());

                psUser.executeUpdate();

                try (ResultSet rs = psUser.getGeneratedKeys()) {
                    if (rs.next()) {
                        userId = rs.getInt(1); // Obtenemos el ID de users
                    } else {
                        throw new SQLException("Error al obtener el ID generado para el usuario.");
                    }
                }
            }

            // 2. Insertar en PERSONALDATA vinculando el user_id y recuperar el ID de datos[cite: 17]
            try (PreparedStatement psData = conn.prepareStatement(sqlData, Statement.RETURN_GENERATED_KEYS)) {
                psData.setString(1, u.getNombres());
                psData.setString(2, u.getApellidos());
                psData.setString(3, u.getDni());
                psData.setInt(4, userId); // FK hacia users

                psData.executeUpdate();

                try (ResultSet rs = psData.getGeneratedKeys()) {
                    if (rs.next()) {
                        personalDataId = rs.getInt(1); // Obtenemos el personal_data_id
                    } else {
                        throw new SQLException("Error al obtener el ID generado para personaldata.");
                    }
                }
            }

            // 3. Insertar en EMAILS vinculando el personal_data_id[cite: 17]
            try (PreparedStatement psEmail = conn.prepareStatement(sqlEmail)) {
                psEmail.setString(1, u.getEmail());
                psEmail.setInt(2, personalDataId); // FK hacia personaldata

                psEmail.executeUpdate();
            }

            // Si todo sale bien, confirmamos la transacción
            conn.commit();
            return true;

        } catch (SQLException e) {
            // Si ocurre algún error en el proceso, revertimos todos los cambios
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return false;
        } finally {
            // Restaurar y cerrar la conexión de forma segura
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
