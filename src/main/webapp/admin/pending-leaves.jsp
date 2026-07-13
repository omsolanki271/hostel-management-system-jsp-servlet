<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setAttribute("activeMenu", "pendingLeaves");
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
    List<Map<String, Object>> leaves = (List<Map<String, Object>>) request.getAttribute("leaves");
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Pending Leave Applications | Admin Panel</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
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
            padding: 10px;
            border: 1px solid #eee;
            font-size: 14px;
            text-align: left;
        }

        table th {
            background: #f97316;
            color: #fff;
            font-weight: bold;
        }

        table tr:hover {
            background: #fff3e6;
        }

        .btn-approve {
            background: #16a34a;
            color: #fff;
            padding: 6px 12px;
            border-radius: 6px;
            text-decoration: none;
            display: inline-block;
            font-weight: bold;
            font-size: 13px;
        }
        
        .btn-approve:hover {
            background: #15803d;
        }

        .btn-reject {
            background: #dc2626;
            color: #fff;
            padding: 6px 12px;
            border-radius: 6px;
            text-decoration: none;
            display: inline-block;
            font-weight: bold;
            font-size: 13px;
        }
        
        .btn-reject:hover {
            background: #b91c1c;
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

        <h2 class="page-title">Pending Leave Applications</h2>

        <div class="table-box">

            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Student ID / RegNo</th>
                        <th>From</th>
                        <th>To</th>
                        <th>Reason</th>
                        <th>Status</th>
                        <th>Remarks</th>
                        <th>Applied On</th>
                        <th>Action</th>
                    </tr>
                </thead>

                <tbody>
                    <%
                        if (leaves == null || leaves.isEmpty()) {
                    %>
                        <tr>
                            <td colspan="9" style="text-align: center; color: #777;">No pending leave applications found.</td>
                        </tr>
                    <%
                        } else {
                            int count = 1;
                            for (Map<String, Object> row : leaves) {
                                String regNoVal = (String) row.get("regno");
                                if (regNoVal == null) {
                                    regNoVal = "ID: " + row.get("student_id");
                                }
                                
                                String remarks = (String) row.get("remarks");
                                if (remarks == null || remarks.trim().isEmpty()) {
                                    remarks = "-";
                                }
                    %>
                        <tr>
                            <td><%= count++ %></td>
                            <td><%= regNoVal %></td>
                            <td><%= row.get("from_date") %></td>
                            <td><%= row.get("to_date") %></td>
                            <td style="white-space: pre-wrap;"><%= row.get("reason") %></td>
                            <td><b><%= row.get("status") %></b></td>
                            <td><%= remarks %></td>
                            <td><%= row.get("applied_on") %></td>

                            <td>
                                <a href="${pageContext.request.contextPath}/admin/manage-leaves?action=approve&id=<%= row.get("id") %>"
                                   class="btn-approve">
                                    Approve
                                </a>

                                <a href="${pageContext.request.contextPath}/admin/manage-leaves?action=reject&id=<%= row.get("id") %>"
                                   class="btn-reject" style="margin-left:6px;">
                                    Reject
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
