<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setAttribute("activeMenu", "closedComplaints");
%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("admin") == null || !"admin".equals(sess.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    // Auto-load details if missing
    if (request.getAttribute("complaints") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/closed-complaints");
        return;
    }

    List<Map<String, Object>> complaints = (List<Map<String, Object>>) request.getAttribute("complaints");
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Closed Complaints | Admin Panel</title>

    <!-- CSS from PHP reference project -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        .table-box {
            background: #fff;
            padding: 20px;
            border-radius: 12px;
            margin-top: 20px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 12px;
        }

        table th, table td {
            border: 1px solid #eee;
            padding: 10px;
            font-size: 14px;
            color: #334155;
        }

        table th {
            background: #16a34a; /* Green table header matching PHP */
            color: #fff;
            font-weight: bold;
        }

        table tr:hover {
            background: #fff3e6;
        }

        .view-icon {
            color: #3b82f6;
            font-size: 18px;
            cursor: pointer;
        }
        
        .top-action-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .search-btn {
            background: #475569;
            color: white;
            padding: 8px 16px;
            text-decoration: none;
            border-radius: 6px;
            font-weight: bold;
            font-size: 14px;
        }
        .search-btn:hover {
            background: #334155;
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

        <div class="top-action-bar">
            <h2 class="page-title">Closed Complaints</h2>
            <a href="${pageContext.request.contextPath}/admin/search-complaint" class="search-btn"><i class="fa fa-search"></i> Search Complaints</a>
        </div>

        <div class="table-box">
            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Complaint No</th>
                        <th>Type</th>
                        <th>Status</th>
                        <th>Registered Date</th>
                        <th>Action</th>
                    </tr>
                </thead>

                <tbody>
                    <%
                        if (complaints == null || complaints.isEmpty()) {
                    %>
                        <tr>
                            <td colspan="6" style="text-align: center; color: #777;">No closed complaints found.</td>
                        </tr>
                    <%
                        } else {
                            int count = 1;
                            for (Map<String, Object> c : complaints) {
                    %>
                        <tr>
                            <td><%= count++ %></td>
                            <td><strong>#<%= c.get("ComplainNumber") %></strong></td>
                            <td><%= c.get("complaintType") %></td>
                            <td>
                                <span style="color:#22c55e; font-weight:bold;">Closed</span>
                            </td>
                            <td><%= c.get("registrationDate") %></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/admin/complaint-details?cid=<%= c.get("id") %>" title="View Details">
                                    <i class="fa fa-eye view-icon"></i>
                                </a>
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
    <%@ include file="/common/admin-footer.jsp" %>

</body>

</html>
