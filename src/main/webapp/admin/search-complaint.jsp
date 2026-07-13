<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setAttribute("activeMenu", "allComplaints");
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

    List<Map<String, Object>> complaints = (List<Map<String, Object>>) request.getAttribute("complaints");
    boolean searched = request.getAttribute("searched") != null;
    String searchQuery = request.getParameter("searchQuery");
    if (searchQuery == null) searchQuery = "";
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Search Complaints | Admin Panel</title>

    <!-- CSS from PHP reference project -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        .search-box {
            background: #fff;
            padding: 25px;
            border-radius: 8px;
            margin-top: 20px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }

        .search-box label {
            font-weight: bold;
            margin-bottom: 8px;
            display: block;
            color: #334155;
        }

        .search-row {
            display: flex;
            gap: 15px;
        }

        .search-row input {
            flex: 1;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 15px;
        }

        .search-btn {
            background: #f97316;
            border: none;
            padding: 10px 24px;
            color: #fff;
            border-radius: 6px;
            cursor: pointer;
            font-size: 15px;
            font-weight: bold;
        }
        
        .search-btn:hover {
            background: #ea580c;
        }

        .table-box {
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            margin-top: 25px;
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
            text-align: left;
            font-size: 14px;
            color: #334155;
        }

        table th {
            background: #f97316;
            color: white;
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
    <%@ include file="/common/admin-header.jsp" %>

    <!-- Sidebar -->
    <%@ include file="/common/admin-sidebar.jsp" %>

    <!-- Main Content Area -->
    <div class="admin-content">

        <h2 class="page-title">Search Complaints</h2>

        <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
            <div class="alert-box alert-error"><%= error %></div>
        <% } %>

        <div class="search-box">
            <form method="GET" action="${pageContext.request.contextPath}/admin/search-complaint">
                <label for="searchQuery">Search Complaint by Number, Type, Status, or Description</label>
                <div class="search-row">
                    <input type="text" name="searchQuery" id="searchQuery" value="<%= searchQuery %>" required placeholder="Enter search criteria...">
                    <button type="submit" class="search-btn"><i class="fa fa-search"></i> Search</button>
                </div>
            </form>
        </div>

        <% if (searched) { %>
            <div class="table-box">
                <h3>Search Results for: "<%= searchQuery %>"</h3>
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
                                <td colspan="6" style="text-align: center; color: #777;">No matches found.</td>
                            </tr>
                        <%
                            } else {
                                int count = 1;
                                for (Map<String, Object> c : complaints) {
                                    String status = (String) c.get("complaintStatus");
                        %>
                            <tr>
                                <td><%= count++ %></td>
                                <td><strong>#<%= c.get("ComplainNumber") %></strong></td>
                                <td><%= c.get("complaintType") %></td>
                                <td>
                                    <% if (status == null || status.trim().isEmpty() || "New".equalsIgnoreCase(status) || "Pending".equalsIgnoreCase(status)) { %>
                                        <span style="color:#ef4444; font-weight:bold;">New</span>
                                    <% } else if ("In Process".equalsIgnoreCase(status)) { %>
                                        <span style="color:#f97316; font-weight:bold;">In Process</span>
                                    <% } else { %>
                                        <span style="color:#22c55e; font-weight:bold;">Closed</span>
                                    <% } %>
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
        <% } %>

    </div>

        <!-- Footer -->
    <%@ include file="/common/admin-footer.jsp" %>

</body>

</html>
