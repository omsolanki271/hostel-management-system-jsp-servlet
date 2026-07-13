<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setAttribute("activeMenu", "manageRooms");
%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="java.util.Map" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("admin") == null || !"admin".equals(sess.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    // Auto-load details if room is missing
    if (request.getAttribute("room") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/manage-rooms");
        return;
    }

    Map<String, Object> room = (Map<String, Object>) request.getAttribute("room");
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Edit Room | Admin Panel</title>

    <!-- CSS from PHP reference project -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        .form-box {
            background: #ffffff;
            padding: 25px;
            border-radius: 10px;
            width: 70%;
            margin: auto;
            margin-top: 25px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }

        .form-box label {
            font-weight: bold;
            margin-bottom: 6px;
            display: block;
            color: #334155;
        }

        .form-box input, 
        .form-box select {
            width: 100%;
            padding: 10px;
            margin-bottom: 18px;
            border-radius: 6px;
            border: 1px solid #ccc;
            font-size: 15px;
        }

        .save-btn {
            background: #f97316;
            border: none;
            padding: 12px 18px;
            color: #fff;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            margin-top: 10px;
            font-weight: 600;
        }

        .save-btn:hover {
            background: #ea580c;
        }

        .note {
            color: #888;
            font-size: 12px;
            margin-top: -12px;
            margin-bottom: 15px;
            display: block;
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

        <h2 class="page-title">Edit Room</h2>

        <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
            <div class="alert-box alert-error"><%= error %></div>
        <% } %>

        <div class="form-box">
            <form method="POST" action="${pageContext.request.contextPath}/admin/edit-room">
                
                <!-- Hidden inputs -->
                <input type="hidden" name="id" value="<%= room.get("id") %>">

                <label for="seater">Seater</label>
                <input type="number" name="seater" id="seater" value="<%= room.get("seater") %>" required>

                <label>Room Number</label>
                <input type="text" value="<%= room.get("room_no") %>" disabled style="background: #f1f5f9; cursor: not-allowed;">
                <span class="note">Room number cannot be changed.</span>

                <label for="fees">Fees (Per Month)</label>
                <input type="number" name="fees" id="fees" value="<%= room.get("fees") %>" required>

                <button type="submit" class="save-btn">Update Room</button>

            </form>
        </div>

    </div>

        <!-- Footer -->
    <%@ include file="/common/admin-footer.jsp" %>

</body>

</html>
