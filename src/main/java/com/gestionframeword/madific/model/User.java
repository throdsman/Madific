package com.gestionframeword.madific.model;
 
public class User
{
    private String name;
    private String pass;
    private String email;
    private UserRole role;
    private String access;
    private int age;
    private int id;
    private String nombres;
    private String apellidos;
    private String dni;

    public User(String name, String pass, String email, UserRole role, String access, int age, int id, String nombres, String apellidos, String dni)
    {
        this.name = name;
        this.pass = pass;
        this.email = email;
        this.role = role;
        this.access = access;
        this.age = age;
        this.id = id;
        this.nombres = nombres;
        this.apellidos = apellidos;
        this.dni = dni;
    }
  
    public String getName()
    {
        return name;
    }

    public String getPass()
    {
        return pass;
    }

    public String getEmail()
    {
        return email;
    }

    public UserRole getRole()
    {
        return role;
    }

    public String getAccess()
    {
        return access;
    }

    public int getAge()
    {
        return age;
    }

    public int getId()
    {
        return id;
    }

    public String getNombres()
    {
        return nombres;
    }

    public String getApellidos()
    {
        return apellidos;
    }

    public String getDni()
    {
        return dni;
    }

    @Override
    public String toString()
    {
        return "User{" + "name=" + name + ", pass=" + pass + ", email=" + email + ", role=" + role + ", access=" + access + ", age=" + age + ", id=" + id + '}';
    }
 
    public static class UserBuilder
    {
        private String name;
        private String pass;
        private String email;
        private UserRole role;
        private String access;
        private int age;
        private int id; 
        private String nombres;
        private String apellidos;
        private String dni;
        
        public User getUser()
        {
            return new User(name, pass, email, role, access, age, id, nombres, apellidos, dni);
        }

        public void setDni(String dni)
        {
            this.dni = dni;
        }
        
        public void setNombres(String nombres)
        {
            this.nombres = nombres;
        }

        public void setApellidos(String apellidos)
        {
            this.apellidos = apellidos;
        } 
        
        public void setAccess(String access)
        {
            this.access = access;
        }

        public void setName(String name)
        {
            this.name = name;
        }

        public void setAge(int age)
        {
            this.age = age;
        }

        public void setPass(String pass)
        {
            this.pass = pass;
        }

        public void setEmail(String email)
        {
            this.email = email;
        }

        public void setRole(UserRole role)
        {
            this.role = role;
        }

        public void setId(int id)
        {
            this.id = id;
        }
    }
}
