<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setAttribute("activeMenu", "bookRoom");
    %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user") == null || !"user".equals(sess.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    // Auto-load servlet if rooms attribute is missing
    if (request.getAttribute("rooms") == null) {
        response.sendRedirect(request.getContextPath() + "/student/available-rooms");
        return;
    }

    List<Map<String, Object>> rooms = (List<Map<String, Object>>) request.getAttribute("rooms");
    String name = (String) sess.getAttribute("studentName");
    String regNo = (String) sess.getAttribute("regNo");
    String studentEmail = (String) sess.getAttribute("studentEmail");

    // Check if already registered
    boolean isBooked = false;
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
        conn = DBConnection.getConnection();
        ps = conn.prepareStatement("SELECT id FROM registration WHERE regno = ? OR emailid = ? LIMIT 1");
        ps.setString(1, regNo);
        ps.setString(2, studentEmail);
        rs = ps.executeQuery();
        if (rs.next()) {
            isBooked = true;
        }
    } catch(Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch(Exception e){}
        try { if (ps != null) ps.close(); } catch(Exception e){}
        try { if (conn != null) conn.close(); } catch(Exception e){}
    }
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Available Rooms | Hostel System</title>

    <!-- Custom CSS from PHP project -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user.css">
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

        .btn-book {
            background: #f97316;
            color: white;
            padding: 6px 12px;
            text-decoration: none;
            border-radius: 6px;
            font-weight: bold;
            font-size: 13px;
        }

        .btn-book:hover {
            background: #ea580c;
        }
    </style>
</head>

<body>

        <!-- Header -->
    <% request.setAttribute("isBooked", isBooked); %>
    <%@ include file="/common/student-header.jsp" %>

    <!-- Main Container -->
    <div class="dashboard-container" style="padding-top: 30px;">
        <h2 class="dashboard-title">Available Rooms</h2>
        <p class="dashboard-subtitle">List of rooms available for booking in the hostel</p>

        <div class="table-box">
            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Room No</th>
                        <th>Seater Capacity</th>
                        <th>Fee (Per Month)</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        if (rooms == null || rooms.isEmpty()) {
                    %>
                        <tr>
                            <td colspan="5" style="text-align: center; color: #777;">No rooms found.</td>
                        </tr>
                    <%
                        } else {
                            int count = 1;
                            for (Map<String, Object> room : rooms) {
                    %>
                        <tr>
                            <td><%= count++ %></td>
                            <td><strong>Room <%= room.get("room_no") %></strong></td>
                            <td><%= room.get("seater") %> Seater</td>
                            <td><%= room.get("fees") %></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/student/book-room?room=<%= room.get("room_no") %>" class="btn-book">Book Room</a>
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
    <%@ include file="/common/student-footer.jsp" %>

</body>

</html>
