<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setAttribute("activeMenu", "manageRooms");
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
    
    // Auto-load servlet if rooms attribute is missing
    if (request.getAttribute("rooms") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/manage-rooms");
        return;
    }

    List<Map<String, Object>> rooms = (List<Map<String, Object>>) request.getAttribute("rooms");
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Manage Rooms | Admin</title>

    <!-- CSS from PHP reference project -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        .table-box {
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            margin-top: 20px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        table th {
            background: #f97316;
            color: white;
            padding: 12px;
            font-size: 15px;
            text-align: left;
        }

        table td {
            padding: 10px;
            border-bottom: 1px solid #eee;
            color: #334155;
        }

        table tr:hover {
            background: #fff3e6;
        }

        .action-icons a {
            margin-right: 10px;
            font-size: 18px;
            color: #f97316;
            text-decoration: none;
        }

        .action-icons a:hover {
            color: #d65b09;
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

        <h2 class="page-title">Manage Rooms</h2>

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

        <div class="table-box">
            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Seater</th>
                        <th>Room No.</th>
                        <th>Fee (PM)</th>
                        <th>Posting Date</th>
                        <th>Action</th>
                    </tr>
                </thead>

                <tbody>
                    <%
                        if (rooms == null || rooms.isEmpty()) {
                    %>
                        <tr>
                            <td colspan="6" style="text-align: center; color: #777;">No rooms found.</td>
                        </tr>
                    <%
                        } else {
                            int count = 1;
                            for (Map<String, Object> room : rooms) {
                    %>
                        <tr>
                            <td><%= count++ %></td>
                            <td><%= room.get("seater") %> Seater</td>
                            <td><%= room.get("room_no") %></td>
                            <td><%= room.get("fees") %></td>
                            <td><%= room.get("posting_date") %></td>

                            <td class="action-icons">
                                <a href="${pageContext.request.contextPath}/admin/edit-room?id=<%= room.get("id") %>">
                                    <i class="fa fa-edit" title="Edit Room"></i>
                                </a>

                                <a href="${pageContext.request.contextPath}/admin/manage-rooms?del=<%= room.get("id") %>"
                                   onclick="return confirm('Are you sure you want to delete this room?');">
                                    <i class="fa fa-trash" title="Delete Room"></i>
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
