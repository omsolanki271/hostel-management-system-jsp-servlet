<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setAttribute("activeMenu", "rejectedLeaves");
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
    <title>Rejected Leave Applications | Admin Panel</title>

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
            background: #dc2626;
            color: #fff;
            font-weight: bold;
        }

        table tr:hover {
            background: #fee2e2;
        }

        .text-danger {
            color: #dc2626;
            font-weight: bold;
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

        <h2 class="page-title">Rejected Leave Applications</h2>

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
                    </tr>
                </thead>

                <tbody>
                    <%
                        if (leaves == null || leaves.isEmpty()) {
                    %>
                        <tr>
                            <td colspan="8" style="text-align: center; color: #777;">No rejected leave applications found.</td>
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
                            <td class="text-danger"><%= row.get("status") %></td>
                            <td><%= remarks %></td>
                            <td><%= row.get("applied_on") %></td>
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
