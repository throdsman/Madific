 
package com.gestionframeword.madific.control;

import com.gestionframeword.madific.model.Procedimiento;
import com.gestionframeword.madific.model.ProcedimientoDB;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;
 
public class registrar_procedimiento_servlet extends HttpServlet
{
 
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        request.setCharacterEncoding("UTF-8");

        // 1. Recoger los parámetros enviados desde el formulario JSP
        String nombre = request.getParameter("nombre");
        String tipoProcedimiento = request.getParameter("tipoProcedimiento");
        String descripcion = request.getParameter("descripcion");
        String strMaquinas = request.getParameter("listaMaquinas");
        String strAcciones = request.getParameter("listaAcciones");

        // 2. Transformar los strings separados por comas en List<Integer>
        List<Integer> maquinasList = parsearArrayAIntList(strMaquinas);
        List<Integer> accionesList = parsearArrayAIntList(strAcciones);

        // 3. Construir el objeto Procedimiento utilizando el Builder Fluent/Lazy
        Procedimiento nuevoProcedimiento = new Procedimiento.ProcedimientoBuilder()
                .setName(nombre)
                .setTipo(tipoProcedimiento)
                .setDesc(descripcion)
                .setSecuencia(maquinasList) // Ajusta el nombre del setter según tu clase Builder
                .setAcciones(accionesList) // Ajusta el nombre del setter según tu clase Builder
                .build(); // O .GetProcedimiento()

        // 4. Guardar en la base de datos a través de tu clase DAO (que recibe el objeto)
        boolean registrado = ProcedimientoDB.addProcedimiento(nuevoProcedimiento) > 0;

        // 5. Redireccionar según el resultado
        if (registrado) {
            // Redirige de vuelta al servlet principal del dashboard para que recargue las listas
            response.sendRedirect(request.getContextPath() + "/dashboard"); // O tu ruta del dashboard
        } else {
            // Manejo básico de error (puedes redirigir con un parámetro de error)
            response.sendRedirect(request.getContextPath() + "/dashboard?error=registro_fallido");
        }
    }
    
    private List<Integer> parsearArrayAIntList(String texto) 
    {
        List<Integer> lista = new ArrayList<>();
        if (texto != null && !texto.trim().isEmpty()) {
            // Separa por comas
            String[] tokens = texto.split(",");
            for (String token : tokens) {
                try {
                    // Limpia espacios en blanco y convierte a entero
                    lista.add(Integer.parseInt(token.trim()));
                } catch (NumberFormatException e) {
                    System.out.println("Advertencia: No se pudo convertir a entero el valor: " + token);
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
