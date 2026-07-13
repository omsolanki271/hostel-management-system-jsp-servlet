<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String studentHeaderName = (String) session.getAttribute("studentName");
    if (studentHeaderName == null) {
        studentHeaderName = "Student";
    }
    
    Boolean isBookedObj = (Boolean) request.getAttribute("isBooked");
    boolean headerIsBooked = (isBookedObj != null && isBookedObj);
    
    String activeMenu = (String) request.getAttribute("activeMenu");
    if (activeMenu == null) activeMenu = "";
    
    boolean isDashboard = "dashboard".equals(activeMenu);
    boolean isBookRoom = "bookRoom".equals(activeMenu);
    boolean isMyRoom = "myRoom".equals(activeMenu);
    boolean isFileComplaint = "fileComplaint".equals(activeMenu);
    boolean isMyComplaints = "myComplaints".equals(activeMenu);
    boolean isApplyLeave = "applyLeave".equals(activeMenu);
    boolean isMyLeaves = "myLeaves".equals(activeMenu);
%>
    <!-- Header matching PHP user header -->
    <header class="user-header">
        <div class="user-nav">
            <div class="header-left">
                <h2 class="logo-text">
                    <img src="<%= request.getContextPath() %>/images/logo.jpg" class="brand-logo" alt="logo"> 
                    Hostel System
                </h2>
                <nav class="main-nav-links">
                    <a href="<%= request.getContextPath() %>/student/dashboard.jsp" <%= isDashboard ? "style=\"color: #f97316;\"" : "" %>>Dashboard</a>
                    <% if (headerIsBooked) { %>
                        <a href="<%= request.getContextPath() %>/student/booking-details" <%= isMyRoom ? "style=\"color: #f97316;\"" : "" %>>My Room</a>
                        <a href="<%= request.getContextPath() %>/student/register-complaint" <%= isFileComplaint ? "style=\"color: #f97316;\"" : "" %>>File Complaint</a>
                        <a href="<%= request.getContextPath() %>/student/my-complaints" <%= isMyComplaints ? "style=\"color: #f97316;\"" : "" %>>My Complaints</a>
                        <a href="<%= request.getContextPath() %>/student/leave-apply" <%= isApplyLeave ? "style=\"color: #f97316;\"" : "" %>>Apply Leave</a>
                        <a href="<%= request.getContextPath() %>/student/my-leaves" <%= isMyLeaves ? "style=\"color: #f97316;\"" : "" %>>My Leaves</a>
                    <% } else { %>
                        <a href="<%= request.getContextPath() %>/student/available-rooms" <%= isBookRoom ? "style=\"color: #f97316;\"" : "" %>>Book Room</a>
                    <% } %>
                </nav>
            </div>

            <div class="header-right">
                <div class="profile-dropdown">
                    <button class="profile-btn">
                        <img src="<%= request.getContextPath() %>/images/review_img/student2.jpg" class="profile-img" alt="avatar">
                        <%= studentHeaderName %> 
                        <i class="fa fa-angle-down"></i>
                    </button>

                    <ul class="dropdown-menu">
                        <li><a href="<%= request.getContextPath() %>/student/profile"><i class="fa fa-user"></i> My Account</a></li>
                        <li><a href="<%= request.getContextPath() %>/student/change-password.jsp"><i class="fa fa-key"></i> Change Password</a></li>
                        <li><a href="<%= request.getContextPath() %>/student/logout"><i class="fa fa-power-off"></i> Logout</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </header>
