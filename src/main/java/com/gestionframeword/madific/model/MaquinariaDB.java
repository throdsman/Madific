 
package com.gestionframeword.madific.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
 
public class MaquinariaDB
{

    public static List<Maquinaria> GetAllMaquinarias()
    { 
        System.out.println("Entrando a obtener todas las maquinarias desde la BD...");
        List<Maquinaria> listaMaquinarias = new ArrayList<>();

        // Consulta SQL utilizando los nombres reales de las columnas en la tabla 'maquinas'
        String sql = "SELECT maquina_name, maquina_dir, maquina_estado FROM maquinas";

        try (Connection conn = DBConnection.getInstance().CreateConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            // Recorremos cada registro devuelto por PostgreSQL
            while (rs.next()) {

                // Construcción del objeto utilizando el Builder estático fluido
                Maquinaria maquinaria = new Maquinaria.MaquinariaBuilder()
                        .setName(rs.getString("maquina_name"))
                        .setDir(rs.getString("maquina_dir"))       // Mapea la descripción a la propiedad dir
                        .setStatus(rs.getString("maquina_estado"))  // Mapea el estado
                        .build(); // O .GetMaquinaria();

                // Agregamos el objeto a la lista
                listaMaquinarias.add(maquinaria);
            }

            System.out.println("Maquinarias rescatadas con éxito. Total: " + listaMaquinarias.size());

        } catch (Exception e) {
            e.printStackTrace();
        }

        return listaMaquinarias;
    }

    public static boolean actualizarMaquinaria(Maquinaria maq) throws SQLException, ClassNotFoundException
    {
        String sql = "UPDATE maquinas SET maquina_dir = ?, maquina_estado = ? WHERE maquina_name = ?";

        try (Connection conn = DBConnection.getInstance().CreateConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, maq.getDir());    
            pstmt.setString(2, maq.getStatus());  
            pstmt.setString(3, maq.getName());   

            int filasAfectadas = pstmt.executeUpdate();

            // Retorna true solo si se afectó al menos un registro (si hubo cambios válidos)
            return filasAfectadas > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
}
