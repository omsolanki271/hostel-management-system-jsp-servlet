<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setAttribute("activeMenu", "manageCourses");
%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("admin") == null || !"admin".equals(sess.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    // Auto-load servlet if courses is missing
    if (request.getAttribute("courses") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/manage-courses");
        return;
    }

    List<Map<String, Object>> courses = (List<Map<String, Object>>) request.getAttribute("courses");
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Manage Courses | Admin Panel</title>

    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        .table-box {
            background: #fff;
            padding: 20px;
            border-radius: 12px;
            margin-top: 20px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 12px;
        }

        table th,
        table td {
            border: 1px solid #eee;
            padding: 12px;
            font-size: 14px;
            color: #334155;
            text-align: left;
        }

        table th {
            background: #f97316;
            color: white;
            font-weight: bold;
        }

        tr:hover {
            background: #fafafa;
        }

        .action-icons a {
            margin-right: 12px;
            text-decoration: none;
            font-size: 16px;
        }

        .edit-icon {
            color: #3b82f6;
        }

        .delete-icon {
            color: #ef4444;
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

        <h2 class="page-title">Manage Courses</h2>

        <%
            String success = request.getParameter("success");
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

        <div class="table-box">
            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Course Code</th>
                        <th>Short Name</th>
                        <th>Full Name</th>
                        <th>Reg Date</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        if (courses == null || courses.isEmpty()) {
                    %>
                        <tr>
                            <td colspan="6" style="text-align: center; color: #777;">No courses found.</td>
                        </tr>
                    <%
                        } else {
                            int count = 1;
                            for (Map<String, Object> c : courses) {
                    %>
                        <tr>
                            <td><%= count++ %></td>
                            <td><%= c.get("course_code") %></td>
                            <td><%= c.get("course_sn") %></td>
                            <td><%= c.get("course_fn") %></td>
                            <td><%= c.get("posting_date") %></td>
                            <td class="action-icons">
                                <a href="<%= request.getContextPath() %>/admin/edit-course?id=<%= c.get("id") %>" title="Edit">
                                    <i class="fa fa-edit edit-icon"></i>
                                </a>
                                <a href="<%= request.getContextPath() %>/admin/manage-courses?del=<%= c.get("id") %>" 
                                   onclick="return confirm('Do you really want to delete this course?');" title="Delete">
                                    <i class="fa fa-trash delete-icon"></i>
                                </a>
                            </td>
                        </tr>
                    <%
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>

    </div>

    <!-- Footer -->
    <%@ include file="/common/admin-footer.jsp" %>

</body>

</html>
