<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setAttribute("activeMenu", "addRoom");
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
    <title>Create Room | Admin</title>

    <!-- CSS from PHP reference project -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        .form-box {
            background: #fff;
            padding: 25px;
            border-radius: 8px;
            margin-top: 20px;
            width: 70%;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }

        .form-box label {
            font-weight: bold;
            margin-bottom: 5px;
            display: block;
            color: #334155;
        }

        .form-box input,
        .form-box select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 6px;
            margin-bottom: 15px;
            font-size: 15px;
        }

        .btn-submit {
            background: #f97316;
            border: none;
            padding: 12px 20px;
            color: #fff;
            border-radius: 6px;
            cursor: pointer;
            font-size: 15px;
            font-weight: 600;
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

        <h2 class="page-title">Add New Room</h2>

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

        <div class="form-box">
            <form method="POST" action="${pageContext.request.contextPath}/admin/add-room">

                <label for="seater">Select Seater</label>
                <select name="seater" id="seater" required>
                    <option value="" disabled selected>Select Seater</option>
                    <option value="1">Single Seater</option>
                    <option value="2">Two Seater</option>
                    <option value="3">Three Seater</option>
                    <option value="4">Four Seater</option>
                    <option value="5">Five Seater</option>
                </select>

                <label for="rmno">Room Number</label>
                <input type="number" name="rmno" id="rmno" required placeholder="Enter room number">

                <label for="fee">Fee (Per Student)</label>
                <input type="number" name="fee" id="fee" required placeholder="Enter fee amount">

                <button type="submit" class="btn-submit">Create Room</button>

            </form>
        </div>

    </div>

        <!-- Footer -->
    <%@ include file="/common/admin-footer.jsp" %>

</body>

</html>
