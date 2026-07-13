<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess != null && sess.getAttribute("user") != null) {
        response.sendRedirect(request.getContextPath() + "/student/dashboard.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>User Registration | Hostel System</title>

    <!-- REGISTER CSS from PHP reference -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/register.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>

<body>

    <div class="register-container">
        <div class="register-box">

            <div>
                <a href="${pageContext.request.contextPath}/index.jsp" class="back-inside">
                    <i class="fa fa-arrow-left"></i><span> Back to Home</span>
                </a>
            </div>

            <h1 style="margin-top: 15px;">Create Student Account</h1>
            <p class="sub">Join our Hostel System <strong style="color: red;">(Take Reg No from Hostel)</strong></p>

            <%
                String error = (String) request.getAttribute("error");
                if (error != null) {
            %>
                <div class="reg-alert">
                    <%= error %>
                </div>
            <% } %>

            <form method="POST" action="${pageContext.request.contextPath}/student/register" class="reg-form">

                <label for="regno">Registration Number *</label>
                <input type="text" name="regno" id="regno" required>

                <label for="fname">First Name *</label>
                <input type="text" name="fname" id="fname" required>

                <label for="mname">Middle Name</label>
                <input type="text" name="mname" id="mname">

                <label for="lname">Last Name *</label>
                <input type="text" name="lname" id="lname" required>

                <label for="gender">Gender *</label>
                <select name="gender" id="gender" required>
                    <option value="" selected disabled>Select Gender</option>
                    <option value="male">male</option>
                    <option value="female">female</option>
                    <option value="others">others</option>
                </select>

                <label for="contact">Contact Number *</label>
                <input type="text" name="contact" id="contact" maxlength="10" required>

                <label for="email">Email *</label>
                <input type="email" name="email" id="email" required>

                <label for="password">Password *</label>
                <input type="password" name="password" id="password" required>

                <label for="cpassword">Confirm Password *</label>
                <input type="password" name="cpassword" id="cpassword" required>

                <button type="submit" class="full-btn" style="margin-top:15px;">
                    Register
                </button>
            </form>

            <p class="login-link">
                Already have an account?
                <a href="${pageContext.request.contextPath}/login.jsp">Login</a>
            </p>
        </div>
    </div>

    <!-- Simple footer aligned to user footer -->
    <footer class="user-footer" style="background: #FFF7ED; padding: 15px; text-align: center; color: #475569; border-top: 2px solid #F97316;">
        <p>© 2026 Hostel Management System — User Panel</p>
    </footer>

</body>

</html>
