<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setAttribute("activeMenu", "dashboard");
    %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user") == null || !"user".equals(sess.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    String name = (String) sess.getAttribute("studentName");
    String regNo = (String) sess.getAttribute("regNo");
    Integer studentId = (Integer) sess.getAttribute("user");
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
    <title>User Dashboard | Hostel System</title>

    <!-- Custom CSS from PHP project -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>

<body>

        <!-- Header -->
    <% request.setAttribute("isBooked", isBooked); %>
    <%@ include file="/common/student-header.jsp" %>

    <!-- Main Container matching PHP udashboard -->
    <div class="dashboard-container" style="padding-top: 30px;">
        <h2 class="dashboard-title">Dashboard</h2>
        <p class="dashboard-subtitle">Quick access to all your hostel services</p>

        <% if (!isBooked) { %>
            <!-- Informative banner for new student -->
            <div style="background-color: #FFF4E5; border-left: 4px solid #F97316; padding: 12px; border-radius: 6px; margin: 10px 0 25px 0; color: #6b4f28;">
                <i class="fa fa-exclamation-circle"></i>
                Before booking a hostel room, you must see your <strong>Hostel Registration Number (RegNo)</strong> from <strong>your Profile.</strong> Booking without a valid RegNo is not accepted.
            </div>
        <% } else { %>
            <!-- Success banner for booked student -->
            <div style="background-color: #ECFDF5; border-left: 4px solid #10B981; padding: 12px; border-radius: 6px; margin: 10px 0 25px 0; color: #065F46;">
                <i class="fa fa-check-circle"></i>
                <strong>Your hostel room is successfully booked.</strong> You can now access all hostel services below.
            </div>
        <% } %>

        <div class="dashboard-grid">

            <!-- My Profile Card -->
            <a href="${pageContext.request.contextPath}/student/profile" class="dash-card">
                <div class="icon-box"><i class="fa fa-user"></i></div>
                <h3>My Profile</h3>
                <p>View your complete profile</p>
            </a>

            <% if (!isBooked) { %>
                <!-- Book Hostel Card -->
                <a href="${pageContext.request.contextPath}/student/available-rooms" class="dash-card">
                    <div class="icon-box"><i class="fa fa-building"></i></div>
                    <h3>Book Hostel</h3>
                    <p>Apply for hostel admission</p>
                </a>
            <% } else { %>
                <!-- My Room Card -->
                <a href="${pageContext.request.contextPath}/student/booking-details" class="dash-card">
                    <div class="icon-box"><i class="fa fa-bed"></i></div>
                    <h3>My Room</h3>
                    <p>View room details & status</p>
                </a>
            <% } %>

            <!-- Update Account Card -->
            <a href="${pageContext.request.contextPath}/student/update-profile" class="dash-card">
                <div class="icon-box"><i class="fa fa-edit"></i></div>
                <h3>Update Account</h3>
                <p>Modify your contact details</p>
            </a>

            <!-- Change Password Card -->
            <a href="${pageContext.request.contextPath}/student/change-password.jsp" class="dash-card">
                <div class="icon-box"><i class="fa fa-lock"></i></div>
                <h3>Change Password</h3>
                <p>Modify your password credentials</p>
            </a>

            <% if (isBooked) { %>
                <!-- File Complaint Card -->
                <a href="${pageContext.request.contextPath}/student/register-complaint" class="dash-card">
                    <div class="icon-box"><i class="fa fa-circle-exclamation"></i></div>
                    <h3>File Complaint</h3>
                    <p>Register a new complaint</p>
                </a>

                <!-- My Complaints Card -->
                <a href="${pageContext.request.contextPath}/student/my-complaints" class="dash-card">
                    <div class="icon-box"><i class="fa fa-list"></i></div>
                    <h3>My Complaints</h3>
                    <p>Track your submitted complaints</p>
                </a>

                <!-- Apply Leave Card -->
                <a href="${pageContext.request.contextPath}/student/leave-apply" class="dash-card">
                    <div class="icon-box"><i class="fa fa-calendar-plus"></i></div>
                    <h3>Apply Leave</h3>
                    <p>Submit a new leave application</p>
                </a>

                <!-- My Leaves Card -->
                <a href="${pageContext.request.contextPath}/student/my-leaves" class="dash-card">
                    <div class="icon-box"><i class="fa fa-calendar-check"></i></div>
                    <h3>My Leaves</h3>
                    <p>View your leave history</p>
                </a>
            <% } %>

        </div>
    </div>

        <!-- Footer -->
    <%@ include file="/common/student-footer.jsp" %>

</body>

</html>
