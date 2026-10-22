<%-- 
    Document   : index
    Created on : 17 oct. 2026, 1:32:14 p. m.
    Author     : Luis
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Sign In | Research Portal</title>
    <style>
        /* Base Reset & Formal Typography */
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
        }

        body, html {
            height: 100%;
            background-color: #f8fafc;
            color: #1e293b;
        }

        /* Split-Screen Layout */
        .portal-container {
            display: flex;
            height: 100vh;
            width: 100vw;
        }

        /* Left Side: Login Form */
        .login-side {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 3rem;
            background: #ffffff;
            z-index: 10;
        }

        .login-wrapper {
            width: 100%;
            max-width: 380px;
        }

        .brand-header h2 {
            font-size: 1.75rem;
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 0.5rem;
        }

        .brand-header p {
            font-size: 0.875rem;
            color: #64748b;
            margin-bottom: 2rem;
        }

        /* Form Elements */
        .form-group {
            margin-bottom: 1.25rem;
        }

        .form-group label {
            display: block;
            font-size: 0.8125rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: #475569;
            margin-bottom: 0.5rem;
        }

        .form-control {
            width: 100%;
            padding: 0.75rem 1rem;
            font-size: 0.95rem;
            border: 1px solid #cbd5e1;
            border-radius: 6px;
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        .form-control:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        /* Action Row (Forgot Password) */
        .form-actions {
            display: flex;
            justify-content: flex-end;
            margin-bottom: 1.5rem;
        }

        .form-actions a {
            font-size: 0.875rem;
            color: #2563eb;
            text-decoration: none;
        }

        .form-actions a:hover {
            text-decoration: underline;
        }

        /* Submit Button */
        .btn-submit {
            width: 100%;
            padding: 0.75rem;
            font-size: 1rem;
            font-weight: 600;
            color: #ffffff;
            background-color: #0f172a;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            transition: background-color 0.2s;
        }

        .btn-submit:hover {
            background-color: #1e293b;
        }

        /* Footer Links (Create Account) */
        .auth-footer {
            margin-top: 2rem;
            text-align: center;
            font-size: 0.875rem;
            color: #64748b;
        }

        .auth-footer a {
            color: #2563eb;
            text-decoration: none;
            font-weight: 500;
        }

        .auth-footer a:hover {
            text-decoration: underline;
        }

        /* Error Message Banner (Java Integration Point) */
        .alert-error {
            background-color: #fef2f2;
            border: 1px solid #fca5a5;
            color: #991b1b;
            padding: 0.75rem 1rem;
            border-radius: 6px;
            font-size: 0.875rem;
            margin-bottom: 1.5rem;
        }

        /* Right Side: Scientific / Lab Visual Panel */
        .visual-side {
            flex: 1.2;
            position: relative;
            background: linear-gradient(rgba(15, 23, 42, 0.4), rgba(15, 23, 42, 0.7)), 
                        url('https://images.unsplash.com/photo-1532094349884-543bc11b234d?auto=format&fit=crop&w=1920&q=80') no-repeat center center;
            background-size: cover;
            display: flex;
            flex-direction: column;
            justify-content: flex-end;
            padding: 4rem;
            color: #ffffff;
        }

        .visual-caption h1 {
            font-size: 2.25rem;
            font-weight: 700;
            margin-bottom: 1rem;
            line-height: 1.2;
        }

        .visual-caption p {
            font-size: 1rem;
            color: #cbd5e1;
            max-width: 500px;
            line-height: 1.5;
        }

        /* Responsive Breakpoint for Mobile Screens */
        @media (max-width: 900px) {
            .portal-container {
                flex-direction: column;
            }
            .visual-side {
                display: none; /* Hide visual panel on small mobile screens */
            }
        }
    </style>
</head>
<body>

    <div class="portal-container">
        
        <!-- LEFT PANEL: LOGIN FORM -->
        <div class="login-side">
            <div class="login-wrapper">
                
                <div class="brand-header">
                    <h2>Welcome Back</h2>
                    <p>Please enter your credentials to access the system.</p>
                </div>

                <!-- JAVA INTEGRATION: Error Banner Displayed if Servlet sets request attribute 'errorMessage' -->
                <% 
                    String errorMsg = (String) request.getAttribute("errorMessage");
                    if (errorMsg != null && !errorMsg.isEmpty()) { 
                %>
                    <div class="alert-error">
                        <%= errorMsg %>
                    </div>
                <% } %>

                <% 
                    // Grab the saved email if it was sent back from the servlet
                    String savedEmail = (request.getAttribute("email") != null) 
                                        ? (String) request.getAttribute("email") 
                                        : "";
                %>
                
                <!-- SERVLET CONNECTION: Submits credentials via POST to your LoginServlet -->
                <form action="login_servlet" method="POST">
                    
                    <div class="form-group">
                        <label for="email">Email Address</label>
                        <input type="email" id="email" name="email" class="form-control" required autofocus placeholder="researcher@institution.edu" value="<%= savedEmail %>">
                    </div>

                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" id="password" name="password" class="form-control" required placeholder="••••••••••••">
                    </div>

                    <div class="form-actions">
                        <!-- FUTURE SERVLET CONNECTION: Link to Forgot Password Servlet / Page -->
                        <a href="forgotpass_servlet">Forgot password?</a>
                    </div>

                    <button type="submit" class="btn-submit">Sign In</button>
                </form>

                <div class="auth-footer">
                    Don't have an institutional account? 
                    <!-- SERVLET CONNECTION: Link to Registration Servlet / Page -->
                    <a href="LoginToRegister_servlet">Create account</a>
                </div>

            </div>
        </div>

        <!-- RIGHT PANEL: SCIENTIFIC / LAB RESEARCH VISUAL -->
        <div class="visual-side">
            <div class="visual-caption">
                <h1>Advanced Research Data Portal</h1>
                <p>Secure, centralized access for institutional laboratory records, data analysis pipelines, and collaborative scientific publications.</p>
            </div>
        </div>

    </div>

</body>
</html>