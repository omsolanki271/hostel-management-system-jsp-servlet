<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess != null) {
        if (sess.getAttribute("admin") != null) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
            return;
        } else if (sess.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/student/dashboard.jsp");
            return;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Login | Hostel Management System</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        /* forgot pass word link */
        .forgot-link {
            text-align: right;
            margin-top: -10px;
            margin-bottom: 10px;
        }

        .forgot-link a {
            font-size: 14px;
            color: #f97316;
            text-decoration: none;
        }

        .forgot-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>

<body class="login-body">

    <div class="login-box">

        <!-- BACK TO HOME BUTTON INSIDE BOX -->
        <a href="${pageContext.request.contextPath}/index.jsp" class="back-inside">
            <i class="fa fa-arrow-left"></i> Back to Home
        </a>

        <h2 class="login-title">Login to Hostel System</h2>

        <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
            <div style="background-color: #f8d7da; color: #721c24; padding: 10px; border-radius: 6px; font-size: 14px; margin-bottom: 15px; border: 1px solid #f5c6cb;">
                <%= error %>
            </div>
        <% } %>

        <%
            String registered = request.getParameter("registered");
            if ("1".equals(registered)) {
        %>
            <div style="background-color: #d4edda; color: #155724; padding: 10px; border-radius: 6px; font-size: 14px; margin-bottom: 15px; border: 1px solid #c3e6cb;">
                Success: Registration Successful! Please login.
            </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/login" method="POST">

            <!-- ROLE -->
            <div class="form-group">
                <label>Select Role</label>
                <select name="role" required>
                    <option value="" disabled selected>Select Role</option>
                    <option value="user">User Login</option>
                    <option value="admin">Admin Login</option>
                </select>
            </div>

            <!-- USERNAME -->
            <div class="form-group">
                <label>Email / Reg No / Username</label>
                <input type="text" name="username" required placeholder="Enter Email, RegNo, or Username">
            </div>

            <!-- PASSWORD -->
            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" required placeholder="Enter Password">
            </div>

            <!-- SUBMIT BUTTON -->
            <button type="submit" class="full-btn">Login</button>

        </form>

    </div>

</body>

</html>
