 
package com.gestionframeword.madific.control;

import com.gestionframeword.madific.model.PasswordModifier;
import com.gestionframeword.madific.model.User;
import com.gestionframeword.madific.model.User.UserBuilder;
import com.gestionframeword.madific.model.UserDB;
import com.gestionframeword.madific.model.UserRole;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
 
public class crear_usuario_ad_servlet extends HttpServlet
{ 
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        // Asegurar codificación UTF-8
        request.setCharacterEncoding("UTF-8");

        try 
        {
            // 1. Recoger los parámetros del formulario de creación
            String primerNombre = request.getParameter("primerNombre");
            String apellido = request.getParameter("apellido");
            String dni = request.getParameter("dni");
            String email = request.getParameter("email");
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String nivelAcceso = request.getParameter("nivelAcceso");
            String role = request.getParameter("role");

            // 2. Construir el objeto usando Userbuilder (no lazy)
            UserBuilder ub = new UserBuilder();

            ub.setName(username);
            ub.setNombres(primerNombre);
            ub.setApellidos(apellido);
            ub.setPass(PasswordModifier.SecurePassword(password));
            ub.setDni(dni);
            ub.setAccess(nivelAcceso);
            ub.setRole(UserRole.valueOf(role));
            ub.setEmail(email);
            ub.setAge(18);

            User nuevoUsuario = ub.getUser();

            // 3. Ejecutar la inserción transaccional secuencial en el DAO
            boolean registrado = UserDB.registrarUsuarioCompleto(nuevoUsuario);

            // 4. Redireccionar al dashboard manteniendo activa la pestaña de usuarios (?tab=usuarios)
            if (registrado) {
                response.sendRedirect(request.getContextPath() + "/dashboard?tab=usuarios");
            } else {
                response.sendRedirect(request.getContextPath() + "/dashboard?tab=usuarios&error=registro_fallido");
            }

        } catch (Exception e) 
        {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/dashboard?tab=usuarios&error=exception");
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
