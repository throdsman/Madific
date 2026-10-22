 
package listener;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class AppInitializerListener implements ServletContextListener
{
    @Override
    public void contextInitialized(ServletContextEvent sce) 
    {
        
        System.out.println("==================================================");
        System.out.println("¡La aplicación Madific se ha iniciado con éxito, Ricardo!");
        System.out.println("==================================================");
        
        
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) 
    {
        
        System.out.println("La aplicación Madific se está deteniendo...");
    }  
}
