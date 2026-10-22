<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Session security check & data extraction
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("currentUser") == null) {
        response.sendRedirect("login_jsp.jsp");
        return;
    }
    String userName = (String) userSession.getAttribute("currentUser");
    String userRole = (String) userSession.getAttribute("currentRole");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Dashboard | Research Portal</title>
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
        }

        body {
            background-color: #f8fafc;
            color: #1e293b;
        }

        /* Top Navigation Bar */
        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background-color: #ffffff;
            padding: 1rem 2rem;
            border-bottom: 1px solid #e2e8f0;
            position: relative;
        }

        .nav-brand {
            font-weight: 700;
            font-size: 1.15rem;
            color: #0f172a;
        }

        /* Profile Dropdown Container */
        .profile-menu-container {
            position: relative;
        }

        .profile-icon-btn {
            background: #0f172a;
            color: #ffffff;
            border: none;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: background-color 0.2s;
        }

        .profile-icon-btn:hover {
            background-color: #1e293b;
        }

        /* Inline Dropdown Box */
        .dropdown-options {
            display: none;
            position: absolute;
            right: 0;
            top: 50px;
            background: #ffffff;
            min-width: 180px;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -4px rgba(0, 0, 0, 0.1);
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            z-index: 100;
        }

        .dropdown-options.active {
            display: block;
        }

        .dropdown-options a {
            display: block;
            padding: 0.75rem 1rem;
            font-size: 0.875rem;
            color: #334155;
            text-decoration: none;
            border-bottom: 1px solid #f1f5f9;
            transition: background 0.15s;
        }

        .dropdown-options a:last-child {
            border-bottom: none;
            color: #dc2626; /* Highlight logout red */
        }

        .dropdown-options a:hover {
            background-color: #f8fafc;
        }

        /* Main Dashboard Body */
        .dashboard-content {
            max-width: 1000px;
            margin: 3rem auto;
            padding: 0 1.5rem;
        }

        .welcome-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            padding: 2.5rem;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.05);
        }

        .welcome-card h1 {
            font-size: 1.75rem;
            color: #0f172a;
            margin-bottom: 0.5rem;
        }

        .welcome-card p {
            color: #64748b;
            font-size: 1rem;
            margin-bottom: 1.5rem;
        }

        .badge {
            display: inline-block;
            background-color: #eff6ff;
            color: #1d4ed8;
            padding: 0.35rem 0.75rem;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            border-radius: 9999px;
            border: 1px solid #bfdbfe;
        }
    </style>
</head>
<body>

    <!-- Top Navigation Bar -->
    <div class="navbar">
        <div class="nav-brand">Research Portal Workspace</div>
        
        <!-- Corner Profile Icon with Dropdown -->
        <div class="profile-menu-container">
            <button class="profile-icon-btn" onclick="toggleDropdown()" title="Account Menu">
                <!-- Displays first letter of user's name as an avatar icon -->
                <%= userName != null && !userName.isEmpty() ? userName.substring(0, 1).toUpperCase() : "U" %>
            </button>
            
            <!-- Expanding Option List (No external JSP needed) -->
            <div id="dropdownMenu" class="dropdown-options">
                <a href="#profile">Profile Details</a>
                <a href="#config">System Configuration</a>
                <a href="logout_servlet">Log Out</a>
            </div>
        </div>
    </div>

    <!-- Dashboard Content Area -->
    <div class="dashboard-content">
        <div class="welcome-card">
            <h1>Welcome back, <%= userName %></h1>
            <p>You are successfully authenticated into the institutional network.</p>
            <div>
                <span class="badge">Role: <%= userRole %></span>
            </div>
        </div>
    </div>

    <!-- Minimal Inline JavaScript for Dropdown Toggle -->
    <script>
        function toggleDropdown() {
            const menu = document.getElementById('dropdownMenu');
            menu.classList.toggle('active');
        }

        // Close dropdown if user clicks anywhere outside of it
        window.onclick = function(event) {
            if (!event.target.matches('.profile-icon-btn')) {
                const dropdowns = document.getElementsByClassName("dropdown-options");
                for (let i = 0; i < dropdowns.length; i++) {
                    let openDropdown = dropdowns[i];
                    if (openDropdown.classList.contains('active')) {
                        openDropdown.classList.remove('active');
                    }
                }
            }
        }
    </script>

</body>
</html>