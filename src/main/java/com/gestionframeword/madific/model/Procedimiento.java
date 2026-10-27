package com.gestionframeword.madific.model;
 
import java.util.List;

public class Procedimiento
{
    private int id;
    private String name;
    private String desc;
    private String tipo;
    private List<Integer> secuencia;
    private List<Integer> acciones;

    public Procedimiento(int id, String name, String desc, String tipo, List<Integer> secuencia, List<Integer> acciones)
    {
        this.id = id;
        this.name = name;
        this.desc = desc;
        this.tipo = tipo;
        this.secuencia = secuencia;
        this.acciones = acciones;
    }
    
    public int getId()
    {
        return id;
    }

    public String getName()
    {
        return name;
    }

    public String getDesc()
    {
        return desc;
    }

    public String getTipo()
    {
        return tipo;
    }

    public List<Integer> getSecuencia()
    {
        return secuencia;
    }

    public List<Integer> getAcciones()
    {
        return acciones;
    }
    
    public static class ProcedimientoBuilder
    {
        private int id;
        private String name;
        private String desc;
        private String tipo;
        private List<Integer> secuencia;
        private List<Integer> acciones;
        
        public ProcedimientoBuilder setId(int id) {
            this.id = id;
            return this;
        }

        public ProcedimientoBuilder setName(String name) {
            this.name = name;
            return this;
        }

        public ProcedimientoBuilder setDesc(String desc) {
            this.desc = desc;
            return this;
        }

        public ProcedimientoBuilder setTipo(String tipo) {
            this.tipo = tipo;
            return this;
        }

        public ProcedimientoBuilder setSecuencia(List<Integer> secuencia) {
            this.secuencia = secuencia;
            return this;
        }

        public ProcedimientoBuilder setAcciones(List<Integer> acciones) {
            this.acciones = acciones;
            return this;
        }

        // Método final para instanciar y retornar el objeto Procedimiento
        public Procedimiento build() {
            return new Procedimiento(id, name, desc, tipo, secuencia, acciones);
        }

        // Alternativa compatible con tu nomenclatura original[cite: 7]
        public Procedimiento GetProcedimiento() {
            return build();
        }
    }
}
