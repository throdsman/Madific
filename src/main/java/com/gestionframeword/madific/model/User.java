package com.gestionframeword.madific.model;
 
public class User
{
    private String name;
    private String pass;
    private String email;
    private UserRole role;
    private int age;
    private int id;

    public int getAge()
    {
        return age;
    }

    private User(String name, String pass, String email, UserRole role, int id, int age)
    {
        this.name = name;
        this.pass = pass;
        this.email = email;
        this.role = role;
        this.id = id;
        this.age = age;
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

    public int getId()
    {
        return id;
    }
    
    public String toACommaValueStd()
    {
        return "User{";
    }
    
    public static class UserBuilder
    {
        private String name;
        private String pass;
        private String email;
        private UserRole role;
        private int age;
        private int id;
        
        public User getUser()
        {
            return new User(name, pass, email, role, id, age);
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
