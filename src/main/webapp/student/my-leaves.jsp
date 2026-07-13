<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setAttribute("activeMenu", "myLeaves");
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

    List<Map<String, Object>> leaves = (List<Map<String, Object>>) request.getAttribute("leaves");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Leave Applications | Hostel System</title>
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
        <h2 class="leave-title">My Leave Applications</h2>

        <%
            String successMsg = request.getParameter("success");
            if (successMsg != null) {
        %>
            <div style="background-color: #d1fae5; border-left: 4px solid #10b981; padding: 10px; margin-bottom: 20px; color: #065f46; border-radius: 4px; font-weight: bold; font-size: 14px;">
                <%= successMsg %>
            </div>
        <% } %>

        <div class="leave-table-wrapper">
            <%
                if (leaves == null || leaves.isEmpty()) {
            %>
                <div class="no-leave">You have not applied for any leave yet.</div>
            <%
                } else {
            %>
                <table class="leave-table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>From Date</th>
                            <th>To Date</th>
                            <th>Reason</th>
                            <th>Status</th>
                            <th>Remarks</th>
                            <th>Applied On</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            int i = 1;
                            for (Map<String, Object> leave : leaves) {
                                String status = (String) leave.get("status");
                                String badgeClass = "pending";
                                if ("Approved".equalsIgnoreCase(status)) {
                                    badgeClass = "approved";
                                } else if ("Rejected".equalsIgnoreCase(status)) {
                                    badgeClass = "rejected";
                                }
                                
                                String remarks = (String) leave.get("remarks");
                                if (remarks == null || remarks.trim().isEmpty()) {
                                    remarks = "-";
                                }
                        %>
                            <tr>
                                <td><%= i++ %></td>
                                <td><%= leave.get("from_date") %></td>
                                <td><%= leave.get("to_date") %></td>
                                <td style="white-space: pre-wrap;"><%= leave.get("reason") %></td>
                                <td>
                                    <span class="status-badge <%= badgeClass %>">
                                        <%= status %>
                                    </span>
                                </td>
                                <td><%= remarks %></td>
                                <td><%= leave.get("applied_on") %></td>
                            </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            <%
                }
            %>
        </div>
    </div>

        <!-- Footer -->
    <%@ include file="/common/student-footer.jsp" %>
</body>
</html>
