 
package com.gestionframeword.madific.control;

import com.gestionframeword.madific.model.DBConnection;
import com.gestionframeword.madific.model.NetworkResponseEnum;
import com.gestionframeword.madific.model.PasswordModifier;
import com.gestionframeword.madific.model.User.UserBuilder;
import com.gestionframeword.madific.model.UserDB;
import com.gestionframeword.madific.model.UserRole;
import java.io.IOException; 
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.sql.Statement;
 
public class register_servlet extends HttpServlet
{
 
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
         NetworkResponseEnum state = NetworkResponseEnum.none;
        
        try
        { 
            Connection conn = DBConnection.getInstance().CreateConnection();
 
            Statement statement = conn.createStatement();
             
            String email = request.getParameter("email").replaceAll("\\s+", "");
             
            if (UserDB.DoesUserExist(email))
            {
                state = NetworkResponseEnum.AlreadySignin;
            }
            else
            {
                state = NetworkResponseEnum.RegisterValid;
            }
              
            switch (state)
            {
                case AlreadySignin:
                {
                    request.setAttribute("errorMessage", "Email already registered");
                    request.getRequestDispatcher("register.jsp").forward(request, response);
                    break;
                }
                case RegisterValid:
                {
                    UserBuilder ub = new UserBuilder();
                    
                    ub.setName(request.getParameter("name"));
                    ub.setEmail(email);
                    ub.setId(0);
                    ub.setPass(PasswordModifier.SecurePassword(request.getParameter("password")));
                    ub.setRole(UserRole.Practicante); // every new user is a practicante
                    ub.setAge(Integer.valueOf(request.getParameter("age")));
                    
                    System.out.println( UserDB.add(ub.getUser()) + " row inserted!!!!!!!!!!!!!!!!!!!!!!");
                    
                    response.sendRedirect("register.jsp?success=true");
                    break;
                }
            }
            return;
        }
        catch (Exception e)
        {
            System.out.println(e);
            System.out.println("Connection NO!!!!!!!!!!!!!!!!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo()
    {
        return "Short description";
    }// </editor-fold>

}
