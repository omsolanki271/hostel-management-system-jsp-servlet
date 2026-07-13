<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setAttribute("activeMenu", "leaveApply");
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
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Add Leave Application | Admin Panel</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        .form-box {
            background: #fff;
            padding: 25px;
            border-radius: 12px;
            margin-top: 20px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            max-width: 700px;
        }

        .form-group {
            margin-bottom: 18px;
        }

        .form-group label {
            font-weight: 600;
            display: block;
            margin-bottom: 6px;
            color: #334155;
        }

        .form-control {
            width: 100%;
            padding: 10px;
            border-radius: 6px;
            border: 1px solid #ccc;
            font-size: 14px;
            box-sizing: border-box;
        }

        textarea.form-control {
            resize: vertical;
        }

        .submit-btn {
            background: #f97316;
            border: none;
            padding: 10px 22px;
            color: #fff;
            border-radius: 6px;
            cursor: pointer;
            font-size: 15px;
            font-weight: bold;
        }
        
        .submit-btn:hover {
            background: #ea580c;
        }

        .back-btn {
            background: #6b7280;
            padding: 10px 20px;
            color: white;
            border-radius: 6px;
            margin-left: 10px;
            text-decoration: none;
            font-size: 15px;
            font-weight: bold;
            display: inline-block;
        }
        
        .back-btn:hover {
            background: #4b5563;
        }

        .alert {
            padding: 10px 15px;
            margin-bottom: 15px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: bold;
        }

        .alert-success {
            background: #d1fae5;
            color: #065f46;
            border: 1px solid #10b981;
        }

        .alert-danger {
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

        <h2 class="page-title">Add Student Leave Application</h2>

        <div class="form-box">

            <%
                String success = request.getParameter("success");
                String error = (String) request.getAttribute("error");
                if (success != null) {
            %>
                <div class="alert alert-success"><%= success %></div>
            <% } %>

            <%
                if (error != null) {
            %>
                <div class="alert alert-danger"><%= error %></div>
            <% } %>

            <form method="POST" action="${pageContext.request.contextPath}/admin/leave-application">

                <div class="form-group">
                    <label for="student_id">Select Student</label>
                    <select name="student_id" id="student_id" class="form-control" required>
                        <option value="">-- Select Student --</option>
                        <%
                            if (students != null) {
                                for (Map<String, Object> std : students) {
                        %>
                            <option value="<%= std.get("id") %>">
                                <%= std.get("firstName") %> <%= std.get("lastName") %> (<%= std.get("regno") %>)
                            </option>
                        <%
                                }
                            }
                        %>
                    </select>
                </div>

                <div class="form-group">
                    <label for="from_date">From Date</label>
                    <input type="date" name="from_date" id="from_date" class="form-control" required>
                </div>

                <div class="form-group">
                    <label for="to_date">To Date</label>
                    <input type="date" name="to_date" id="to_date" class="form-control" required>
                </div>

                <div class="form-group">
                    <label for="reason">Reason</label>
                    <textarea name="reason" id="reason" class="form-control" rows="4" required></textarea>
                </div>

                <button type="submit" class="submit-btn">
                    <i class="fa fa-plus"></i> Submit
                </button>

                <a href="${pageContext.request.contextPath}/admin/manage-leaves" class="back-btn">Back</a>

            </form>

        </div>

    </div>

        <!-- Footer -->
    <%@ include file="/common/admin-footer.jsp" %>

</body>

</html>
