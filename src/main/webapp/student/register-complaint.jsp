<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setAttribute("activeMenu", "fileComplaint");
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
    <title>Register Complaint | Hostel System</title>

    <!-- Custom CSS from PHP project -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        .form-box {
            background: #fff;
            padding: 25px;
            border-radius: 10px;
            max-width: 600px;
            margin-top: 20px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }

        label {
            font-weight: 600;
            color: #334155;
            display: block;
            margin-bottom: 8px;
            margin-top: 15px;
        }

        input[type="file"],
        select,
        textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
            color: #334155;
        }

        textarea {
            resize: vertical;
            height: 120px;
        }

        .submit-btn {
            background: #f97316;
            color: #fff;
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 15px;
            font-weight: 700;
            margin-top: 20px;
            width: 100%;
            transition: background 0.3s;
        }
        
        .submit-btn:hover {
            background: #ea580c;
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
    <% request.setAttribute("isBooked", isBooked); %>
    <%@ include file="/common/student-header.jsp" %>

    <!-- Main Container -->
    <div class="dashboard-container" style="padding-top: 20px;">
        <h2 class="dashboard-title">Register a Complaint</h2>
        <p class="dashboard-subtitle">Tell us what issue you are facing in the hostel</p>

        <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
            <div class="alert-box alert-error"><%= error %></div>
        <% } %>

        <div class="form-box">
            <form method="POST" action="${pageContext.request.contextPath}/student/register-complaint" enctype="multipart/form-data">

                <label for="ctype">Complaint Type *</label>
                <select name="ctype" id="ctype" required>
                    <option value="" disabled selected>Select Complaint Type</option>
                    <option value="Food Related">Food Related</option>
                    <option value="Room Related">Room Related</option>
                    <option value="Fee Related">Fee Related</option>
                    <option value="Electrical">Electrical</option>
                    <option value="Plumbing">Plumbing</option>
                    <option value="Discipline">Discipline</option>
                    <option value="Other">Other</option>
                </select>

                <label for="cdetails">Explain Your Complaint *</label>
                <textarea name="cdetails" id="cdetails" required placeholder="Describe the issue in detail..."></textarea>

                <label for="cfile">Upload Attachment (Optional, PDF/Image only)</label>
                <input type="file" name="cfile" id="cfile">

                <button type="submit" class="submit-btn">Submit Complaint</button>

            </form>
        </div>
    </div>

        <!-- Footer -->
    <%@ include file="/common/student-footer.jsp" %>

</body>

</html>
