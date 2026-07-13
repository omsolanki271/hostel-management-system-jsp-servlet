<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setAttribute("activeMenu", "manageStudents");
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
    
    // Auto-load servlet if students attribute is missing
    if (request.getAttribute("students") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/manage-students");
        return;
    }

    List<Map<String, Object>> students = (List<Map<String, Object>>) request.getAttribute("students");
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Manage Students | Admin Panel</title>

    <!-- CSS from PHP reference project -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        .table-box {
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            margin-top: 20px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 12px;
        }

        table th, table td {
            border: 1px solid #eee;
            padding: 10px;
            text-align: left;
            font-size: 14px;
            color: #334155;
        }

        table th {
            background: #f97316;
            color: white;
            font-weight: bold;
        }

        table tr:hover {
            background: #fff3e6;
        }

        .action-icons i {
            font-size: 18px;
            margin-right: 10px;
            cursor: pointer;
        }

        .view-icon { color: #3b82f6; }
        .delete-icon { color: #ef4444; }
        
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
        
        .top-action-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .search-btn {
            background: #475569;
            color: white;
            padding: 8px 16px;
            text-decoration: none;
            border-radius: 6px;
            font-weight: bold;
            font-size: 14px;
        }
        .search-btn:hover {
            background: #334155;
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

        <div class="top-action-bar">
            <h2 class="page-title">Manage Registered Students</h2>
            <a href="${pageContext.request.contextPath}/admin/search-student" class="search-btn"><i class="fa fa-search"></i> Search Students</a>
        </div>

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
                        <th>Sno.</th>
                        <th>Name</th>
                        <th>Reg No</th>
                        <th>Contact</th>
                        <th>Room No</th>
                        <th>Seater</th>
                        <th>Staying From</th>
                        <th>Action</th>
                    </tr>
                </thead>

                <tbody>
                    <%
                        if (students == null || students.isEmpty()) {
                    %>
                        <tr>
                            <td colspan="8" style="text-align: center; color: #777;">No registered students found.</td>
                        </tr>
                    <%
                        } else {
                            int count = 1;
                            for (Map<String, Object> student : students) {
                    %>
                        <tr>
                            <td><%= count++ %></td>
                            <td><%= student.get("name") %></td>
                            <td><%= student.get("regno") %></td>
                            <td><%= student.get("contactno") %></td>
                            <td><%= student.get("roomno") %></td>
                            <td><%= student.get("seater") %> Seater</td>
                            <td><%= student.get("stayfrom") %></td>
                            
                            <td class="action-icons">
                                <a href="${pageContext.request.contextPath}/admin/student-details?regno=<%= student.get("regno") %>">
                                    <i class="fa fa-eye view-icon" title="View Details"></i>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/delete-registration?id=<%= student.get("id") %>" 
                                   onclick="return confirm('Do you want to delete this student registration?');">
                                    <i class="fa fa-trash delete-icon" title="Delete Registration"></i>
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
