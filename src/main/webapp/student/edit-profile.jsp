<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setAttribute("activeMenu", "profile");
    %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="model.Student" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user") == null || !"user".equals(sess.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    Student student = (Student) request.getAttribute("student");
    if (student == null) {
        response.sendRedirect(request.getContextPath() + "/student/update-profile");
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
    <title>Edit Profile | Hostel System</title>
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>

<body>

        <!-- Header -->
    <% request.setAttribute("isBooked", isBooked); %>
    <%@ include file="/common/student-header.jsp" %>

    <!-- Main Container matching PHP my-profile -->
    <div class="dashboard-container" style="padding-top: 20px;">
        <div class="profile-wrapper">
            <div class="profile-card">
                
                <!-- HEADER AREA -->
                <div class="profile-head">
                    <div>
                        <h1 class="profile-name">
                            <%= student.getFirstName() %> <%= student.getLastName() %>
                        </h1>
                        <p class="profile-sub">Manage your personal information</p>
                    </div>

                    <div class="profile-meta">
                        <div class="profile-reg">
                            Reg No: <strong><%= student.getRegNo() %></strong>
                        </div>
                        <div class="profile-upd">
                            Last Update: 
                            <strong>
                                <%= student.getUpdationDate() != null ? student.getUpdationDate() : "Not updated yet" %>
                            </strong>
                        </div>
                    </div>
                </div>

                <%
                    String error = (String) request.getAttribute("error");
                    if (error != null) {
                %>
                    <div style="background-color: #f8d7da; color: #721c24; padding: 10px; border-radius: 6px; font-size: 14px; margin-bottom: 15px; border: 1px solid #f5c6cb;">
                        <%= error %>
                    </div>
                <% } %>

                <!-- Profile Form -->
                <form method="POST" action="${pageContext.request.contextPath}/student/update-profile" class="profile-form">
                    <div class="form-grid">
                        
                        <!-- LEFT SIDE FIELDS -->
                        <div class="form-col">
                            <label>First Name *</label>
                            <input type="text" name="fname" value="<%= student.getFirstName() %>" required>

                            <label>Middle Name</label>
                            <input type="text" name="mname" value="<%= student.getMiddleName() != null ? student.getMiddleName() : "" %>">

                            <label>Last Name *</label>
                            <input type="text" name="lname" value="<%= student.getLastName() %>" required>
                        </div>

                        <!-- RIGHT SIDE FIELDS -->
                        <div class="form-col">
                            <label>Gender *</label>
                            <select name="gender" required>
                                <option value="male" <%= "male".equals(student.getGender()) ? "selected" : "" %>>Male</option>
                                <option value="female" <%= "female".equals(student.getGender()) ? "selected" : "" %>>Female</option>
                                <option value="others" <%= "others".equals(student.getGender()) ? "selected" : "" %>>Others</option>
                            </select>

                            <label>Contact No *</label>
                            <input type="text" name="contact" maxlength="15" value="<%= student.getContactNo() %>" required>

                            <label>Email Address (read only)</label>
                            <input type="email" value="<%= student.getEmail() %>" readonly style="background-color: #f9f9f9; border-color: #eee; cursor: not-allowed;">
                        </div>

                    </div>

                    <!-- ACTION BUTTONS -->
                    <div class="form-actions" style="gap: 15px; margin-top: 20px;">
                        <button type="submit" class="btn btn-primary">
                            Update Profile
                        </button>
                        <a href="${pageContext.request.contextPath}/student/profile" class="btn btn-primary" style="background-color: #475569; text-decoration: none; display: inline-block; text-align: center; line-height: 20px; height: 40px; padding: 10px 20px;">
                            Cancel
                        </a>
                    </div>
                </form>

            </div>
        </div>
    </div>

        <!-- Footer -->
    <%@ include file="/common/student-footer.jsp" %>

</body>

</html>
