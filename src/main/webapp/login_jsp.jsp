<%-- 
    Document   : login_jsp
    Created on : 22 oct. 2026, 2:30:46 a. m.
    Author     : Luis
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
    <% 
        String conn = String.valueOf(request.getAttribute("connection")); 
        String successParam = request.getParameter("success");
    %>
        <h1>Status: <%= successParam %></h1> 
        <form action="login_servlet" method="POST">
            <button type="submit" class="btn-submit">Confirmar Status</button>
        </form>
    </body>
</html>
