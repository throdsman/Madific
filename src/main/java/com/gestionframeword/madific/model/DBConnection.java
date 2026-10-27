 
package com.gestionframeword.madific.model;
 
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection
{
    private static DBConnection instance;
    
    private String url;
    private String username;
    private String pass;
    
    
    private DBConnection()
    {
        url =  System.getenv("ENV_URL");
        username =  System.getenv("ENV_USER");
        pass =  System.getenv("ENV_PASS");
    }
    
    public static DBConnection getInstance()
    {
        if (instance == null)
        {
            instance = new DBConnection();
        }
        
        return instance;
    }
    
    public Connection CreateConnection() throws SQLException, ClassNotFoundException
    {
        Class.forName("org.postgresql.Driver");
        
        return DriverManager.getConnection(this.url, this.username, this.pass);
    }
}
