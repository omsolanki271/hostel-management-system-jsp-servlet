<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setAttribute("activeMenu", "manageCourses");
%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="java.util.Map" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("admin") == null || !"admin".equals(sess.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Auto-load details if missing
    if (request.getAttribute("course") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/manage-courses");
        return;
    }

    Map<String, Object> course = (Map<String, Object>) request.getAttribute("course");
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Edit Course | Admin Panel</title>

    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
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

        <h2 class="page-title">Edit Course</h2>

        <div class="form-box">

            <%
                String error = (String) request.getAttribute("error");
                if (error != null) {
            %>
                <div class="alert-box alert-error"><%= error %></div>
            <% } %>

            <form method="POST" action="<%= request.getContextPath() %>/admin/edit-course?id=<%= course.get("id") %>">

                <label for="cc">Course Code *</label>
                <input type="text" name="cc" id="cc" value="<%= course.get("course_code") %>" required>

                <label for="cns">Course Name (Short) *</label>
                <input type="text" name="cns" id="cns" value="<%= course.get("course_sn") %>" required>

                <label for="cnf">Course Name (Full) *</label>
                <input type="text" name="cnf" id="cnf" value="<%= course.get("course_fn") %>" required>

                <button type="submit" class="btn-submit">Update Course</button>

            </form>

        </div>

    </div>

    <!-- Footer -->
    <%@ include file="/common/admin-footer.jsp" %>

</body>

</html>
