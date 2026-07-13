<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setAttribute("activeMenu", "myComplaints");
    %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.io.File" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user") == null || !"user".equals(sess.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    // Auto-load details if missing
    if (request.getAttribute("complaints") == null) {
        response.sendRedirect(request.getContextPath() + "/student/my-complaints");
        return;
    }

    List<Map<String, Object>> complaints = (List<Map<String, Object>>) request.getAttribute("complaints");
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
    <title>My Complaints | Hostel System</title>

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

        .status-badge {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
            display: inline-block;
        }

        .status-pending {
            background-color: #fee2e2;
            color: #ef4444;
        }

        .status-process {
            background-color: #ffedd5;
            color: #f97316;
        }

        .status-closed {
            background-color: #dcfce7;
            color: #22c55e;
        }

        .action-btn {
            background: #f97316;
            color: white;
            padding: 6px 12px;
            text-decoration: none;
            border-radius: 6px;
            font-weight: bold;
            font-size: 13px;
            margin-right: 5px;
            display: inline-block;
        }

        .action-btn:hover {
            background: #ea580c;
        }

        .file-btn {
            background: #475569;
        }

        .file-btn:hover {
            background: #334155;
        }

        .no-file {
            font-size: 12px;
            color: #64748b;
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
    </style>
</head>

<body>

        <!-- Header -->
    <% request.setAttribute("isBooked", isBooked); %>
    <%@ include file="/common/student-header.jsp" %>

    <!-- Main Container -->
    <div class="dashboard-container" style="padding-top: 20px;">
        <h2 class="dashboard-title">My Complaints</h2>
        <p class="dashboard-subtitle">History and status of complaints filed by you</p>

        <%
            String success = request.getParameter("success");
            if (success != null) {
        %>
            <div class="alert-box alert-success"><%= success %></div>
        <% } %>

        <div class="table-box">
            <table>
                <thead>
                    <tr>
                        <th>Sno.</th>
                        <th>Complaint Number</th>
                        <th>Complaint Type</th>
                        <th>Complaint Status</th>
                        <th>Complaint Reg. Date</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        if (complaints == null || complaints.isEmpty()) {
                    %>
                        <tr>
                            <td colspan="6" style="text-align: center; color: #777;">No complaints found.</td>
                        </tr>
                    <%
                        } else {
                            int count = 1;
                            for (Map<String, Object> c : complaints) {
                                String status = (String) c.get("complaintStatus");
                                if (status == null || status.trim().isEmpty()) {
                                    status = "Pending";
                                }
                                
                                String statusClass = "status-pending";
                                if ("In Process".equalsIgnoreCase(status)) {
                                    statusClass = "status-process";
                                } else if ("Closed".equalsIgnoreCase(status)) {
                                    statusClass = "status-closed";
                                }

                                String doc = (String) c.get("complaintDoc");
                    %>
                        <tr>
                            <td><%= count++ %></td>
                            <td><strong>#<%= c.get("ComplainNumber") %></strong></td>
                            <td><%= c.get("complaintType") %></td>
                            <td>
                                <span class="status-badge <%= statusClass %>">
                                    <%= status %>
                                </span>
                            </td>
                            <td><%= c.get("registrationDate") %></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/student/complaint-details?cid=<%= c.get("id") %>" class="action-btn" title="View Details">
                                    <i class="fa fa-eye"></i> View
                                </a>
                                <%
                                    if (doc != null && !doc.trim().isEmpty()) {
                                %>
                                    <a href="${pageContext.request.contextPath}/uploads/complaints/<%= doc %>" target="_blank" class="action-btn file-btn" title="View File">
                                        <i class="fa fa-file"></i> File
                                    </a>
                                <% } else { %>
                                    <span class="no-file">No File</span>
                                <% } %>
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
