 
package com.gestionframeword.madific.control;

import com.gestionframeword.madific.model.Maquinaria;
import com.gestionframeword.madific.model.MaquinariaDB;
import com.gestionframeword.madific.model.Procedimiento;
import com.gestionframeword.madific.model.ProcedimientoDB;
import com.gestionframeword.madific.model.User;
import com.gestionframeword.madific.model.UserDB;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
 
public class dashboard_servlet extends HttpServlet
{
 
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect("login_jsp.jsp");
            return;
        }

        try 
        {
            String access = (String) session.getAttribute("currentAccess");
            String role = (String) session.getAttribute("currentRole");

            List<Procedimiento> listaProcedimientos = ProcedimientoDB.GetAllProcedures();
            List<Maquinaria> ListaMaquinarias = MaquinariaDB.GetAllMaquinarias();
            List<User> listaUsuarios = UserDB.getAllUsers();
            int totalUsuarios = UserDB.getTotalUsers();
            int totalProcedures = listaProcedimientos.size();
            int usuarios24horas = UserDB.getUsuariosRecientes();

            request.setAttribute("listaProcedimientos", listaProcedimientos);
            request.setAttribute("totalUsuarios", totalUsuarios); 
            request.setAttribute("totalProcedimientos", totalProcedures);
            request.setAttribute("usuariosConectados24h", usuarios24horas); 
            request.setAttribute("ListaMaquinarias", ListaMaquinarias);
            request.setAttribute("maquinasActivas", ListaMaquinarias.stream().filter(e -> e.getStatus().equalsIgnoreCase("Activo")).count());
            request.setAttribute("listaUsuarios", listaUsuarios);

            request.getRequestDispatcher((String) session.getAttribute("dash")).forward(request, response);
            
            return;

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al cargar el panel de administración.");
        }
    }
    
 
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
