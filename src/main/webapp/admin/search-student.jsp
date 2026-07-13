<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setAttribute("activeMenu", "manageStudents");
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

    List<Map<String, Object>> students = (List<Map<String, Object>>) request.getAttribute("students");
    boolean searched = request.getAttribute("searched") != null;
    String searchQuery = request.getParameter("searchQuery");
    if (searchQuery == null) searchQuery = "";
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Search Students | Admin Panel</title>

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

        .action-icons i {
            font-size: 18px;
            margin-right: 10px;
            cursor: pointer;
        }

        .view-icon { color: #3b82f6; }
        .delete-icon { color: #ef4444; }

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

        <h2 class="page-title">Search Students</h2>

        <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
            <div class="alert-box alert-error"><%= error %></div>
        <% } %>

        <div class="search-box">
            <form method="GET" action="${pageContext.request.contextPath}/admin/search-student">
                <label for="searchQuery">Search Student by Name, RegNo, or Email</label>
                <div class="search-row">
                    <input type="text" name="searchQuery" id="searchQuery" value="<%= searchQuery %>" required placeholder="Enter student name, registration number, or email...">
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
                            <th>Sno.</th>
                            <th>Name</th>
                            <th>Reg No</th>
                            <th>Contact</th>
                            <th>Room No</th>
                            <th>Seater</th>
                            <th>Staying From</th>
                            <th>Action</th>
                        </tr>
                    </thead>

                    <tbody>
                        <%
                            if (students == null || students.isEmpty()) {
                        %>
                            <tr>
                                <td colspan="8" style="text-align: center; color: #777;">No matches found.</td>
                            </tr>
                        <%
                            } else {
                                int count = 1;
                                for (Map<String, Object> student : students) {
                        %>
                            <tr>
                                <td><%= count++ %></td>
                                <td><%= student.get("name") %></td>
                                <td><%= student.get("regno") %></td>
                                <td><%= student.get("contactno") %></td>
                                <td><%= student.get("roomno") %></td>
                                <td><%= student.get("seater") %> Seater</td>
                                <td><%= student.get("stayfrom") %></td>
                                
                                <td class="action-icons">
                                    <a href="${pageContext.request.contextPath}/admin/student-details?regno=<%= student.get("regno") %>">
                                        <i class="fa fa-eye view-icon" title="View Details"></i>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/delete-registration?id=<%= student.get("id") %>" 
                                       onclick="return confirm('Do you want to delete this student registration?');">
                                        <i class="fa fa-trash delete-icon" title="Delete Registration"></i>
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
