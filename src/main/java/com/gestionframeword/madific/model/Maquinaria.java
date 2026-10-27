 
package com.gestionframeword.madific.model;
 
public class Maquinaria
{
    private String name;
    private String dir;
    private String status;

    public Maquinaria(String name, String dir, String status)
    {
        this.name = name;
        this.dir = dir;
        this.status = status;
    }

    public String getName()
    {
        return name;
    }

    public String getDir()
    {
        return dir;
    }

    public String getStatus()
    {
        return status;
    }
    
    public static class MaquinariaBuilder 
    {
        private String name;
        private String dir;
        private String status;

        public MaquinariaBuilder setName(String name) {
            this.name = name;
            return this; // Retorna el builder para permitir encadenamiento
        }

        public MaquinariaBuilder setDir(String dir) {
            this.dir = dir;
            return this;
        }

        public MaquinariaBuilder setStatus(String status) {
            this.status = status;
            return this;
        }

        // Método estándar para construir el objeto
        public Maquinaria build() {
            return new Maquinaria(name, dir, status);
        }

        // Método alternativo compatible con tu nomenclatura previa
        public Maquinaria GetMaquinaria() {
            return build();
        }
    }
}
