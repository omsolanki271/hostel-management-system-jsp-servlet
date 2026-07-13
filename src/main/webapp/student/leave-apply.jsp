<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setAttribute("activeMenu", "applyLeave");
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
    <title>Apply for Leave | Hostel System</title>
    <!-- Custom CSS from PHP project -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/leave.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

        <!-- Header -->
    <% request.setAttribute("isBooked", isBooked); %>
    <%@ include file="/common/student-header.jsp" %>

    <div class="leave-container" style="padding-top: 30px;">
        <div class="leave-box">
            <a href="${pageContext.request.contextPath}/student/dashboard.jsp" class="back-btn">
                <i class="fa fa-arrow-left"></i> Back to Dashboard
            </a>

            <h2 class="leave-title" style="font-size: 24px; margin-top: 10px;">Apply for Leave</h2>
            <p class="leave-sub">Submit a leave request with proper reason</p>

            <%
                String error = (String) request.getAttribute("error");
                if (error != null) {
            %>
                <div style="background-color: #fee2e2; border-left: 4px solid #ef4444; padding: 10px; margin-bottom: 15px; color: #991b1b; border-radius: 4px; font-weight: bold; font-size: 14px;">
                    <%= error %>
                </div>
            <% } %>

            <!-- Leave Form -->
            <form action="${pageContext.request.contextPath}/student/leave-apply" method="POST">
                <label style="font-weight: bold; display: block; margin-bottom: 6px; color: #475569;">From Date *</label>
                <input type="date" name="from_date" required>

                <label style="font-weight: bold; display: block; margin-bottom: 6px; color: #475569;">To Date *</label>
                <input type="date" name="to_date" required>

                <label style="font-weight: bold; display: block; margin-bottom: 6px; color: #475569;">Reason *</label>
                <textarea name="reason" rows="4" required style="width: 100%; padding: 12px; border-radius: 8px; border: 1px solid #ddd; margin-bottom: 15px; box-sizing: border-box; resize: vertical;"></textarea>

                <button type="submit" class="full-btn">
                    Submit Leave
                </button>
            </form>
        </div>
    </div>

        <!-- Footer -->
    <%@ include file="/common/student-footer.jsp" %>
</body>
</html>
