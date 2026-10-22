package com.gestionframeword.madific.model;

import com.gestionframeword.madific.model.User.UserBuilder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
 
public class UserDB
{
    public static int add(User user)
    {
        String sql = "INSERT INTO users(user_name, user_email, user_pass, user_role, user_age)"
                     + "VALUES(?,?,?,?,?)";
        
        try
        {
            Connection conn = DBConnection.getInstance().CreateConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            
            //
            pstmt.setString(1, user.getName());
            pstmt.setString(2, user.getEmail());
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
    
    public static User GetUser(String email)
    {
        String sql = "SELECT user_name, user_pass, user_id, user_role FROM users WHERE user_email = ?";
        try 
        {
            Connection conn = DBConnection.getInstance().CreateConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            
            pstmt.setString(1, email);
            
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
            ub.setRole(UserRole.valueOf(rs.getString("user_role")));
            
            return ub.getUser();
        }
        catch (Exception e)
        {
            return null;
        }
    }
}
