 
package com.gestionframeword.madific.control;

import com.gestionframeword.madific.model.Maquinaria;
import com.gestionframeword.madific.model.MaquinariaDB;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
 
public class actualizar_maquinaria_servlet extends HttpServlet
{ 
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        request.setCharacterEncoding("UTF-8"); 
        try {
            // 1. Recoger los parámetros enviados desde el modal
            String nombre = request.getParameter("maquina_name"); // Campo readonly (identificador)
            String descripcion = request.getParameter("maquina_dir");
            String estado = request.getParameter("maquina_estado");

            // 2. Construir el objeto Maquinaria utilizando el Builder fluido
            Maquinaria maquinariaModificada = new Maquinaria.MaquinariaBuilder()
                    .setName(nombre)
                    .setDir(descripcion)   // Mapea la descripción a setDir según tu modelo
                    .setStatus(estado)
                    .build();
 
            boolean actualizado = MaquinariaDB.actualizarMaquinaria(maquinariaModificada);
 
            if (actualizado) {
                response.sendRedirect(request.getContextPath() + "/dashboard?tab=maquinas");
            } else {
                response.sendRedirect(request.getContextPath() + "/dashboard?tab=maquinas&error=update_failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/dashboard?tab=maquinas&error=exception");
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
