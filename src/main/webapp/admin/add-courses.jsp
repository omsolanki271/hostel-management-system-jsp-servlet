<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setAttribute("activeMenu", "addCourse");
%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("admin") == null || !"admin".equals(sess.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Add Course | Admin Panel</title>

    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        /* Form styling matching rooms form */
        .form-box {
            background: #fff;
            padding: 25px;
            border-radius: 12px;
            width: 70%;
            margin: 20px auto;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }

        .form-box label {
            display: block;
            margin-bottom: 6px;
            font-weight: bold;
            color: #334155;
        }

        .form-box input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
            margin-bottom: 18px;
            font-size: 14px;
            color: #334155;
        }

        .btn-submit {
            width: 100%;
            background: #f97316;
            border: none;
            padding: 12px;
            border-radius: 6px;
            color: #fff;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
        }

        .btn-submit:hover {
            background: #ea580c;
        }

        .alert-box {
            margin-bottom: 15px;
            padding: 12px;
            border-radius: 6px;
            font-weight: bold;
            font-size: 15px;
        }

        .alert-success {
            background: #d1fae5;
            color: #065f46;
            border: 1px solid #10b981;
        }

        .alert-error {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #f87171;
        }
    </style>
</head>

<body>

    <!-- Header -->
    <%@ include file="/common/admin-header.jsp" %>

    <!-- Sidebar -->
    <%@ include file="/common/admin-sidebar.jsp" %>

    <!-- Main Content Area -->
    <div class="admin-content">

        <h2 class="page-title">Add New Course</h2>

        <div class="form-box">

            <%
                String success = (String) request.getAttribute("success");
                String error = (String) request.getAttribute("error");
                if (success != null) {
            %>
                <div class="alert-box alert-success"><%= success %></div>
            <% } %>

            <%
                if (error != null) {
            %>
                <div class="alert-box alert-error"><%= error %></div>
            <% } %>

            <form method="POST" action="<%= request.getContextPath() %>/admin/add-course">

                <label for="cc">Course Code *</label>
                <input type="text" name="cc" id="cc" placeholder="Enter course code" required>

                <label for="cns">Course Name (Short) *</label>
                <input type="text" name="cns" id="cns" placeholder="Enter short name" required>

                <label for="cnf">Course Name (Full) *</label>
                <input type="text" name="cnf" id="cnf" placeholder="Enter full name" required>

                <button type="submit" class="btn-submit">Add Course</button>

            </form>

        </div>

    </div>

    <!-- Footer -->
    <%@ include file="/common/admin-footer.jsp" %>

</body>

</html>
