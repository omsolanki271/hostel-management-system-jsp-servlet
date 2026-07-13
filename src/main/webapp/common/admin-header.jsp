<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String adminHeaderName = (String) session.getAttribute("adminName");
    if (adminHeaderName == null) {
        adminHeaderName = "Admin";
    }
%>
    <!-- Header matching PHP admin header -->
    <header class="admin-header">
        <div class="header-left">
            <h2 class="admin-logo">
                <img src="<%= request.getContextPath() %>/images/logo.jpg" class="brand-logo" alt="logo"> 
                Hostel Management
            </h2>
        </div>

        <div class="admin-profile">
            <img src="<%= request.getContextPath() %>/images/review_img/student2.jpg" class="admin-avatar" alt="avatar">
            <span class="admin-name"><%= adminHeaderName %></span>
            <i class="fa fa-angle-down"></i>

            <ul class="admin-menu">
                <li><a href="<%= request.getContextPath() %>/admin/change-password.jsp"><i class="fa fa-key"></i> Password</a></li>
                <li><a href="<%= request.getContextPath() %>/admin/logout"><i class="fa fa-power-off"></i> Logout</a></li>
            </ul>
        </div>
    </header>
