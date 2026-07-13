<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("admin") == null || !"admin".equals(sess.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    // Safety check - if accessed directly, redirect to the servlet
    if (request.getAttribute("totalStudents") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        return;
    }

    String adminName = (String) sess.getAttribute("adminName");
    int totalStudents = (Integer) request.getAttribute("totalStudents");
    int totalRooms = (Integer) request.getAttribute("totalRooms");
    int totalCourses = (Integer) request.getAttribute("totalCourses");
    int newComplaints = (Integer) request.getAttribute("newComplaints");
    int inProcess = (Integer) request.getAttribute("inProcess");
    int closedComplaints = (Integer) request.getAttribute("closedComplaints");
    int pendingLeaves = (Integer) request.getAttribute("pendingLeaves");
    int approvedLeaves = (Integer) request.getAttribute("approvedLeaves");
    int rejectedLeaves = (Integer) request.getAttribute("rejectedLeaves");
    int totalFeedback = (Integer) request.getAttribute("totalFeedback");
    int totalNotices = (Integer) request.getAttribute("totalNotices");
    List<Map<String, Object>> recentLeaves = (List<Map<String, Object>>) request.getAttribute("recentLeaves");
    
    request.setAttribute("activeMenu", "dashboard");
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard | Hostel System</title>

    <!-- CSS from PHP reference project -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>

<body>

    <!-- Header -->
    <%@ include file="/common/admin-header.jsp" %>

    <!-- Sidebar -->
    <%@ include file="/common/admin-sidebar.jsp" %>

    <!-- Main Content area matching PHP admin-content -->
    <div class="admin-content">

        <h2 class="page-title">Dashboard</h2>

        <div class="dashboard-row">

            <div class="dashboard-card">
                <i class="fa fa-users card-icon"></i>
                <div class="card-title">Total Students</div>
                <div class="card-number"><%= totalStudents %></div>
                <a href="${pageContext.request.contextPath}/admin/manage-students" class="card-link">Manage Students →</a>
            </div>

            <div class="dashboard-card">
                <i class="fa fa-door-open card-icon"></i>
                <div class="card-title">Total Rooms</div>
                <div class="card-number"><%= totalRooms %></div>
                <a href="${pageContext.request.contextPath}/admin/manage-rooms" class="card-link">Manage Rooms →</a>
            </div>

            <div class="dashboard-card">
                <i class="fa fa-book card-icon"></i>
                <div class="card-title">Total Courses</div>
                <div class="card-number"><%= totalCourses %></div>
                <a href="${pageContext.request.contextPath}/admin/manage-courses" class="card-link">Manage Courses →</a>
            </div>

            <div class="dashboard-card">
                <i class="fa fa-bell card-icon"></i>
                <div class="card-title">New Complaints</div>
                <div class="card-number"><%= newComplaints %></div>
                <a href="${pageContext.request.contextPath}/admin/new-complaints" class="card-link">View New →</a>
            </div>

            <div class="dashboard-card">
                <i class="fa fa-spinner card-icon"></i>
                <div class="card-title">In Process</div>
                <div class="card-number"><%= inProcess %></div>
                <a href="${pageContext.request.contextPath}/admin/inprocess-complaints" class="card-link">View In Process →</a>
            </div>

            <div class="dashboard-card">
                <i class="fa fa-check card-icon"></i>
                <div class="card-title">Closed Complaints</div>
                <div class="card-number"><%= closedComplaints %></div>
                <a href="${pageContext.request.contextPath}/admin/closed-complaints" class="card-link">View Closed →</a>
            </div>

            <!-- Pending Leaves -->
            <div class="dashboard-card">
                <i class="fa fa-hourglass-half card-icon"></i>
                <div class="card-title">Pending Leaves</div>
                <div class="card-number"><%= pendingLeaves %></div>
                <a href="${pageContext.request.contextPath}/admin/pending-leaves" class="card-link">View Pending →</a>
            </div>

            <!-- Approved Leaves -->
            <div class="dashboard-card">
                <i class="fa fa-check-circle card-icon"></i>
                <div class="card-title">Approved Leaves</div>
                <div class="card-number"><%= approvedLeaves %></div>
                <a href="${pageContext.request.contextPath}/admin/approved-leaves" class="card-link">View Approved →</a>
            </div>

            <!-- Rejected Leaves -->
            <div class="dashboard-card">
                <i class="fa fa-times-circle card-icon"></i>
                <div class="card-title">Rejected Leaves</div>
                <div class="card-number"><%= rejectedLeaves %></div>
                <a href="${pageContext.request.contextPath}/admin/rejected-leaves" class="card-link">View Rejected →</a>
            </div>

           <%-- 

            <div class="dashboard-card">
                <i class="fa fa-bell card-icon"></i>
                <div class="card-title">Notices</div>
                <div class="card-number"><%= totalNotices %></div>
                <a href="#" class="card-link">Manage Notices →</a>
            </div> --%>
        </div>

        <!-- RECENT PENDING LEAVES TABLE matching PHP -->
        <h2 class="page-title" style="margin-top:25px;">Recent Pending Leaves</h2>

        <div class="recent-table">
            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Student ID</th>
                        <th>From</th>
                        <th>To</th>
                        <th>Reason</th>
                        <th>Applied On</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        if (recentLeaves == null || recentLeaves.isEmpty()) {
                    %>
                        <tr>
                            <td colspan="7" style="text-align: center; color: #777;">No pending leave applications found.</td>
                        </tr>
                    <%
                        } else {
                            int count = 1;
                            for (Map<String, Object> leave : recentLeaves) {
                    %>
                        <tr>
                            <td><%= count++ %></td>
                            <td><%= leave.get("student_id") %></td>
                            <td><%= leave.get("from_date") %></td>
                            <td><%= leave.get("to_date") %></td>
                            <td><%= leave.get("reason") %></td>
                            <td><%= leave.get("applied_on") %></td>
                            <td>
                                <a class="btn-approve" href="#">Approve</a>
                                <a class="btn-reject" href="#">Reject</a>
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
