<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Create Account | Research Portal</title>
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
            min-height: 100vh;
            width: 100vw;
        }

        /* Left Side: Registration Form */
        .register-side {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 3rem;
            background: #ffffff;
            z-index: 10;
            overflow-y: auto;
        }

        .register-wrapper {
            width: 100%;
            max-width: 420px;
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
            margin-bottom: 1.5rem;
        }

        /* Form Elements */
        .form-row {
            display: flex;
            gap: 1rem;
        }

        .form-group {
            margin-bottom: 1.15rem;
            flex: 1;
        }

        .form-group label {
            display: block;
            font-size: 0.8125rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: #475569;
            margin-bottom: 0.4rem;
        }

        .form-control {
            width: 100%;
            padding: 0.7rem 0.9rem;
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
            margin-top: 0.5rem;
            transition: background-color 0.2s;
        }

        .btn-submit:hover {
            background-color: #1e293b;
        }

        /* Back to Login Secondary Button */
        .btn-secondary {
            display: block;
            width: 100%;
            padding: 0.75rem;
            font-size: 0.95rem;
            font-weight: 600;
            text-align: center;
            color: #475569;
            background-color: #f1f5f9;
            border: 1px solid #cbd5e1;
            border-radius: 6px;
            text-decoration: none;
            margin-top: 0.75rem;
            transition: background-color 0.2s, border-color 0.2s;
        }

        .btn-secondary:hover {
            background-color: #e2e8f0;
            border-color: #94a3b8;
        }

        /* Footer Link */
        .auth-footer {
            margin-top: 1.5rem;
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

        /* Message Banners (Java Integration Points) */
        .alert-error {
            background-color: #fef2f2;
            border: 1px solid #fca5a5;
            color: #991b1b;
            padding: 0.75rem 1rem;
            border-radius: 6px;
            font-size: 0.875rem;
            margin-bottom: 1.25rem;
        }

        .alert-success {
            background-color: #f0fdf4;
            border: 1px solid #86efac;
            color: #166534;
            padding: 0.75rem 1rem;
            border-radius: 6px;
            font-size: 0.875rem;
            margin-bottom: 1.25rem;
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

        /* Responsive Breakpoint */
        @media (max-width: 900px) {
            .portal-container {
                flex-direction: column;
            }
            .visual-side {
                display: none;
            }
        }
    </style>
</head>
<body>

    <div class="portal-container">
        
        <!-- LEFT PANEL: REGISTRATION FORM -->
        <div class="register-side">
            <div class="register-wrapper">
                
                <div class="brand-header">
                    <h2>Create Account</h2>
                    <p>Register your credentials to gain institutional access.</p>
                </div>

                <!-- JAVA INTEGRATION: Dynamic Alerts for Error or Success messages -->
                <% 
                    String errorMsg = (String) request.getAttribute("errorMessage");
                    String successParam = request.getParameter("success");

                    if (errorMsg != null && !errorMsg.isEmpty()) { 
                %>
                    <div class="alert-error">
                        <%= errorMsg %>
                    </div>
                <% 
                    } else if (successParam != null && successParam.equals("true")) { 
                %>
                    <div class="alert-success">
                        Account registered successfully! You can now sign in.
                    </div>
                <% } %>

                <!-- SERVLET CONNECTION: Submits registration details via POST to RegisterServlet -->
                <form action="register_servlet" method="POST">
                    
                    <div class="form-group">
                        <label for="fullName">Full Name</label>
                        <input type="name" id="name" name="name" class="form-control" required autofocus placeholder="Dr. Alex Morgan">
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="email">Email Address</label>
                            <input type="email" id="email" name="email" class="form-control" required placeholder="researcher@institution.edu">
                        </div>

                        <div class="form-group" style="max-width: 100px;">
                            <label for="age">Age</label>
                            <input type="number" id="age" name="age" class="form-control" min="18" max="120" required placeholder="28">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" id="password" name="password" class="form-control" required placeholder="••••••••••••">
                    </div>

                    <div class="form-group">
                        <label for="confirmPassword">Confirm Password</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" required placeholder="••••••••••••">
                    </div>

                    <button type="submit" class="btn-submit">Register Account</button>
                    
                    <!-- Back to Login Button -->
                    <a href="RegisterToLogin" class="btn-secondary">Return to Sign In</a>
                </form>

                <div class="auth-footer">
                    Already registered? 
                    <a href="GoBackLogin">Sign in here</a>
                </div>

            </div>
        </div>

        <!-- RIGHT PANEL: SCIENTIFIC / LAB RESEARCH VISUAL -->
        <div class="visual-side">
            <div class="visual-caption">
                <h1>Join the Research Network</h1>
                <p>Gain access to collaborative laboratory databases, dataset repositories, and analytical workbench tools.</p>
            </div>
        </div>

    </div>

</body>
</html>