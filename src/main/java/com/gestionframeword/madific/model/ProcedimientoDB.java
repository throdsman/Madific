 
package com.gestionframeword.madific.model;
 
import com.gestionframeword.madific.model.Procedimiento.ProcedimientoBuilder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class ProcedimientoDB
{
    public static int addProcedimiento(Procedimiento proc)
    {
        String sql = "INSERT INTO procedimientos(procedimiento_name, procedimiento_desc, tipo_id, procedimiento_secuencia, procedimiento_acciones)"
                     + "VALUES(?,?,?,?,?)";
        
        try
        {
            Connection conn = DBConnection.getInstance().CreateConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            
            java.sql.Array sqlMaquinas = conn.createArrayOf("integer", proc.getSecuencia().toArray());
            java.sql.Array sqlAcciones = conn.createArrayOf("integer", proc.getAcciones().toArray());
            
            //
            pstmt.setString(1, proc.getName());
            pstmt.setString(2, proc.getDesc());
            pstmt.setInt(3, Integer.valueOf(proc.getTipo()));
            pstmt.setObject(4, sqlMaquinas); 
            pstmt.setObject(5, sqlAcciones);  
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
    
   public static List<Procedimiento> GetAllProcedures()
    {
        List<Procedimiento> listaProcedimientos = new ArrayList<>();
        System.out.println("Entrando a Get Procedure!!!!");
        
        String sql = "SELECT procedimiento_id, procedimiento_name, procedimiento_desc, tipo_id, procedimiento_secuencia, procedimiento_acciones, user_id"
                    + " FROM procedimientos";
        
        try (Connection conn = DBConnection.getInstance().CreateConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery())
        {
            while (rs.next()) 
            {
                // Suponiendo que conviertes las cadenas o arreglos de la BD a List<Integer>
                List<Integer> secuenciaList = parsearArrayAIntList(rs.getString("procedimiento_secuencia"));
                List<Integer> accionesList = parsearArrayAIntList(rs.getString("procedimiento_acciones"));

                Procedimiento procedimiento = new ProcedimientoBuilder()
                        .setId(rs.getInt("procedimiento_id"))
                        .setName(rs.getString("procedimiento_name"))
                        .setDesc(rs.getString("procedimiento_desc"))
                        .setTipo(rs.getString("tipo_id"))
                        .setSecuencia(secuenciaList)
                        .setAcciones(accionesList)
                        .build(); // o .GetProcedimiento();

                listaProcedimientos.add(procedimiento);
            }
        }
        catch (Exception e)
        {
            System.out.println(e);
            return null;
        }
        
        return listaProcedimientos;
    }  
   
   private static List<Integer> parsearArrayAIntList(String texto) 
   {
        List<Integer> lista = new ArrayList<>();

        // Validar que el texto no sea nulo o esté vacío
        if (texto == null || texto.trim().isEmpty()) {
            return lista;
        }

        // Limpiar llaves de PostgreSQL ({ y }) por si el campo se recupera como cadena con ese formato
        String limpio = texto.replace("{", "").replace("}", "").trim();

        if (limpio.isEmpty()) {
            return lista;
        }

        // Separar los valores utilizando la coma como delimitador
        String[] partes = limpio.split(",");

        for (String parte : partes) {
            try {
                // Quitar espacios en blanco y convertir a entero
                int valor = Integer.parseInt(parte.trim());
                lista.add(valor);
            } catch (NumberFormatException e) {
                System.err.println("Advertencia: No se pudo convertir a entero el valor: '" + parte + "'");
            }
        }

        return lista;
    }

    public static boolean updateProcedimiento(Procedimiento proc) throws SQLException, ClassNotFoundException
    {
        String sql = "UPDATE procedimientos SET " +
                 "procedimiento_name = ?, " +
                 "procedimiento_desc = ?, " +
                 "tipo_id = ?, " +
                 "procedimiento_secuencia = ?, " +
                 "procedimiento_acciones = ? " +
                 "WHERE procedimiento_id = ?";  

        try (Connection conn = DBConnection.getInstance().CreateConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql)) {

           pstmt.setString(1, proc.getName());
           pstmt.setString(2, proc.getDesc());
           pstmt.setInt(3, Integer.valueOf(proc.getTipo())); // Cambiar a setInt si tu tipo_id en la BD es numérico

           // Convertir las List<Integer> a java.sql.Array compatibles con PostgreSQL
           java.sql.Array sqlSecuencia = conn.createArrayOf("integer", proc.getSecuencia().toArray());
           java.sql.Array sqlAcciones = conn.createArrayOf("integer", proc.getAcciones().toArray());

           pstmt.setArray(4, sqlSecuencia);
           pstmt.setArray(5, sqlAcciones);
           pstmt.setInt(6, proc.getId());

           int filasAfectadas = pstmt.executeUpdate();
           return filasAfectadas > 0;

       } catch (SQLException e) {
           e.printStackTrace();
           return false;
       }
    }
}
