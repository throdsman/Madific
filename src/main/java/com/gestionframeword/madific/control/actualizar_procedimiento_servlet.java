 
package com.gestionframeword.madific.control;

import com.gestionframeword.madific.model.Procedimiento;
import com.gestionframeword.madific.model.ProcedimientoDB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
 
public class actualizar_procedimiento_servlet extends HttpServlet
{ 
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        request.setCharacterEncoding("UTF-8");

        try {
            // 1. Recoger los parámetros del formulario de edición
            int id = Integer.parseInt(request.getParameter("id"));
            String nombre = request.getParameter("nombre");
            String tipo = request.getParameter("tipo");
            String descripcion = request.getParameter("descripcion");
            String strSecuencia = request.getParameter("secuencia");
            String strAcciones = request.getParameter("acciones");

            // 2. Transformar los textos separados por comas en List<Integer>
            List<Integer> secuenciaList = parsearArrayAIntList(strSecuencia);
            List<Integer> accionesList = parsearArrayAIntList(strAcciones);

            // 3. Construir el objeto Procedimiento utilizando el Builder lazy/fluido
            Procedimiento procedimientoModificado = new Procedimiento.ProcedimientoBuilder()
                    .setId(id) // Asegúrate de incluir el ID en tu Builder o clase
                    .setName(nombre)
                    .setTipo(tipo)
                    .setDesc(descripcion)
                    .setSecuencia(secuenciaList) // Ajusta al nombre del setter de tu entidad
                    .setAcciones(accionesList)
                    .build();

            // 4. Ejecutar la actualización en la base de datos mediante el DAO
            boolean actualizado = ProcedimientoDB.updateProcedimiento(procedimientoModificado);

            // 5. Redireccionar al dashboard manteniendo activa la pestaña de procedimientos
            if (actualizado) {
                response.sendRedirect(request.getContextPath() + "/dashboard?tab=procedimientos");
            } else {
                response.sendRedirect(request.getContextPath() + "/dashboard?tab=procedimientos&error=update_failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/dashboard?tab=procedimientos&error=exception");
        }
    }
    
    private List<Integer> parsearArrayAIntList(String texto) {
        List<Integer> lista = new ArrayList<>();
        if (texto != null && !texto.trim().isEmpty()) {
            String[] tokens = texto.split(",");
            for (String token : tokens) {
                try {
                    lista.add(Integer.parseInt(token.trim()));
                } catch (NumberFormatException e) {
                    System.out.println("Advertencia: No se pudo parsear a entero el valor: " + token);
                }
            }
        }
        return lista;
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
