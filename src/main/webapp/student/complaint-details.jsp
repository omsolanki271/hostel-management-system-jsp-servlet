<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setAttribute("activeMenu", "myComplaints");
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
    
    // Auto-load details if missing
    if (request.getAttribute("complaint") == null) {
        response.sendRedirect(request.getContextPath() + "/student/my-complaints");
        return;
    }

    Map<String, Object> complaint = (Map<String, Object>) request.getAttribute("complaint");
    List<Map<String, Object>> history = (List<Map<String, Object>>) request.getAttribute("history");
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
    <title>Complaint Details | Hostel System</title>

    <!-- Custom CSS from PHP project -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        .details-box {
            background: #fff;
            padding: 20px;
            border-radius: 12px;
            margin-top: 20px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        }

        .details-box h3 {
            margin-bottom: 15px;
            color: #f97316;
            border-bottom: 2px solid #fff3e6;
            padding-bottom: 8px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 12px;
        }

        table th,
        table td {
            border: 1px solid #eee;
            padding: 10px;
            font-size: 14px;
            color: #334155;
            text-align: left;
        }

        table th {
            background: #fafafa;
            font-weight: bold;
            width: 25%;
        }

        .history-table th {
            background: #f97316;
            color: white;
            width: auto;
        }

        .back-link {
            display: inline-block;
            margin-bottom: 15px;
            color: #f97316;
            text-decoration: none;
            font-weight: bold;
        }
        
        .back-link:hover {
            color: #ea580c;
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
    </style>
</head>

<body>

        <!-- Header -->
    <% request.setAttribute("isBooked", isBooked); %>
    <%@ include file="/common/student-header.jsp" %>

    <!-- Main Container -->
    <div class="dashboard-container" style="padding-top: 20px;">
        
        <a href="${pageContext.request.contextPath}/student/my-complaints" class="back-link">
            <i class="fa fa-arrow-left"></i> Back to Complaints List
        </a>

        <h2 class="dashboard-title">Complaint #<%= complaint.get("ComplainNumber") %> Details</h2>
        <p class="dashboard-subtitle">Track status and review history logs</p>

        <!-- Complaint Info Box -->
        <div class="details-box">
            <h3>Complaint Information</h3>
            <table>
                <tr>
                    <th>Complaint Number</th>
                    <td>#<%= complaint.get("ComplainNumber") %></td>
                    <th>Registration Date</th>
                    <td><%= complaint.get("registrationDate") %></td>
                </tr>
                <tr>
                    <th>Complaint Type</th>
                    <td><%= complaint.get("complaintType") %></td>
                    <th>Attached File</th>
                    <td>
                        <%
                            String doc = (String) complaint.get("complaintDoc");
                            if (doc != null && !doc.trim().isEmpty()) {
                        %>
                            <a href="${pageContext.request.contextPath}/uploads/complaints/<%= doc %>" target="_blank">
                                <i class="fa fa-file"></i> View File
                            </a>
                        <% } else { %>
                            NA
                        <% } %>
                    </td>
                </tr>
                <tr>
                    <th>Complaint Details</th>
                    <td colspan="3" style="white-space: pre-line;"><%= complaint.get("complaintDetails") %></td>
                </tr>
                <tr>
                    <th>Current Status</th>
                    <td colspan="3">
                        <%
                            String status = (String) complaint.get("complaintStatus");
                            if (status == null || status.trim().isEmpty()) status = "Pending";

                            String statusClass = "status-pending";
                            if ("In Process".equalsIgnoreCase(status)) {
                                statusClass = "status-process";
                            } else if ("Closed".equalsIgnoreCase(status)) {
                                statusClass = "status-closed";
                            }
                        %>
                        <span class="status-badge <%= statusClass %>">
                            <%= status %>
                        </span>
                    </td>
                </tr>
            </table>
        </div>

        <!-- Complaint History Box -->
        <div class="details-box">
            <h3>Complaint History & Remarks</h3>
            <table class="history-table">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Remarks / Action Details</th>
                        <th>Status Changed To</th>
                        <th>Posting Date</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        if (history == null || history.isEmpty()) {
                    %>
                        <tr>
                            <td colspan="4" style="text-align: center; color: #777;">No history logs found. Complaint has not been processed yet.</td>
                        </tr>
                    <%
                        } else {
                            int count = 1;
                            for (Map<String, Object> r : history) {
                    %>
                        <tr>
                            <td><%= count++ %></td>
                            <td style="white-space: pre-line;"><%= r.get("complaintRemark") %></td>
                            <td>
                                <%
                                    String histStatus = (String) r.get("compalintStatus");
                                    String histClass = "status-pending";
                                    if ("In Process".equalsIgnoreCase(histStatus)) {
                                        histClass = "status-process";
                                    } else if ("Closed".equalsIgnoreCase(histStatus)) {
                                        histClass = "status-closed";
                                    }
                                %>
                                <span class="status-badge <%= histClass %>">
                                    <%= histStatus %>
                                </span>
                            </td>
                            <td><%= r.get("postingDate") %></td>
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
