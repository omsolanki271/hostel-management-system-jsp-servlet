<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String activeMenu = (String) request.getAttribute("activeMenu");
    if (activeMenu == null) activeMenu = "";

    boolean isDashboard = "dashboard".equals(activeMenu);
    
    boolean isAddRoom = "addRoom".equals(activeMenu);
    boolean isManageRooms = "manageRooms".equals(activeMenu);
    boolean isRoomsOpen = isAddRoom || isManageRooms;
    
    boolean isAddCourse = "addCourse".equals(activeMenu);
    boolean isManageCourses = "manageCourses".equals(activeMenu);
    boolean isCoursesOpen = isAddCourse || isManageCourses;
    
    boolean isLeaveApply = "leaveApply".equals(activeMenu);
    boolean isManageLeaves = "manageLeaves".equals(activeMenu);
    boolean isApprovedLeaves = "approvedLeaves".equals(activeMenu);
    boolean isRejectedLeaves = "rejectedLeaves".equals(activeMenu);
    boolean isPendingLeaves = "pendingLeaves".equals(activeMenu);
    boolean isLeavesOpen = isLeaveApply || isManageLeaves || isApprovedLeaves || isRejectedLeaves || isPendingLeaves;
    
    boolean isManageStudents = "manageStudents".equals(activeMenu);
    
    boolean isNewComplaints = "newComplaints".equals(activeMenu);
    boolean isInprocessComplaints = "inprocessComplaints".equals(activeMenu);
    boolean isClosedComplaints = "closedComplaints".equals(activeMenu);
    boolean isAllComplaints = "allComplaints".equals(activeMenu);
    boolean isComplaintsOpen = isNewComplaints || isInprocessComplaints || isClosedComplaints || isAllComplaints;
    
    boolean isChangePassword = "changePassword".equals(activeMenu);
%>
    <!-- Sidebar matching PHP admin sidebar -->
    <aside class="admin-sidebar">
        <div class="sidebar-title">MAIN</div>
        <ul class="sidebar-menu">
            <!-- Dashboard -->
            <li>
                <a href="<%= request.getContextPath() %>/admin/dashboard" <%= isDashboard ? "style=\"background: #f97316; color: #fff;\"" : "" %>>
                    <i class="fa-solid fa-gauge"></i> Dashboard
                </a>
            </li>

            <!-- Courses -->
            <li>
                <a class="dropdown-btn" <%= isCoursesOpen ? "style=\"background: #f97316; color: #fff;\"" : "" %>>
                    <i class="fa-solid fa-book"></i> Courses
                    <i class="fa-solid fa-angle-right drop-icon <%= isCoursesOpen ? "rotate" : "" %>"></i>
                </a>
                <ul class="submenu <%= isCoursesOpen ? "open" : "" %>" style="<%= isCoursesOpen ? "display: block;" : "" %>">
                    <li><a href="<%= request.getContextPath() %>/admin/add-course" <%= isAddCourse ? "style=\"background: #fff4e8; color: #f97316;\"" : "" %>>Add Course</a></li>
                    <li><a href="<%= request.getContextPath() %>/admin/manage-courses" <%= isManageCourses ? "style=\"background: #fff4e8; color: #f97316;\"" : "" %>>Manage Courses</a></li>
                </ul>
            </li>

            <!-- Rooms -->
            <li>
                <a class="dropdown-btn" <%= isRoomsOpen ? "style=\"background: #f97316; color: #fff;\"" : "" %>>
                    <i class="fa-solid fa-bed"></i> Rooms
                    <i class="fa-solid fa-angle-right drop-icon <%= isRoomsOpen ? "rotate" : "" %>"></i>
                </a>
                <ul class="submenu <%= isRoomsOpen ? "open" : "" %>" style="<%= isRoomsOpen ? "display: block;" : "" %>">
                    <li><a href="<%= request.getContextPath() %>/admin/add-room" <%= isAddRoom ? "style=\"background: #fff4e8; color: #f97316;\"" : "" %>>Add Room</a></li>
                    <li><a href="<%= request.getContextPath() %>/admin/manage-rooms" <%= isManageRooms ? "style=\"background: #fff4e8; color: #f97316;\"" : "" %>>Manage Rooms</a></li>
                </ul>
            </li>

            <!-- Leave Management -->
            <li>
                <a class="dropdown-btn" <%= isLeavesOpen ? "style=\"background: #f97316; color: #fff;\"" : "" %>>
                    <i class="fa-solid fa-calendar-check"></i> Leave Management
                    <i class="fa-solid fa-angle-right drop-icon <%= isLeavesOpen ? "rotate" : "" %>"></i>
                </a>
                <ul class="submenu <%= isLeavesOpen ? "open" : "" %>" style="<%= isLeavesOpen ? "display: block;" : "" %>">
                    <li><a href="<%= request.getContextPath() %>/admin/leave-application" <%= isLeaveApply ? "style=\"background: #fff4e8; color: #f97316;\"" : "" %>>Student Leave</a></li>
                    <li><a href="<%= request.getContextPath() %>/admin/manage-leaves" <%= isManageLeaves ? "style=\"background: #fff4e8; color: #f97316;\"" : "" %>>Manage Leaves</a></li>
                    <li><a href="<%= request.getContextPath() %>/admin/approved-leaves" <%= isApprovedLeaves ? "style=\"background: #fff4e8; color: #f97316;\"" : "" %>>Approved</a></li>
                    <li><a href="<%= request.getContextPath() %>/admin/rejected-leaves" <%= isRejectedLeaves ? "style=\"background: #fff4e8; color: #f97316;\"" : "" %>>Rejected</a></li>
                    <li><a href="<%= request.getContextPath() %>/admin/pending-leaves" <%= isPendingLeaves ? "style=\"background: #fff4e8; color: #f97316;\"" : "" %>>Pending</a></li>
                </ul>
            </li>

            <!-- Manage Students -->
            <li>
                <a href="<%= request.getContextPath() %>/admin/manage-students" <%= isManageStudents ? "style=\"background: #f97316; color: #fff;\"" : "" %>>
                    <i class="fa-solid fa-users"></i> Manage Students
                </a>
            </li>

            <!-- Manage Complaints -->
            <li>
                <a class="dropdown-btn" <%= isComplaintsOpen ? "style=\"background: #f97316; color: #fff;\"" : "" %>>
                    <i class="fa-solid fa-comments"></i> Complaints
                    <i class="fa-solid fa-angle-right drop-icon <%= isComplaintsOpen ? "rotate" : "" %>"></i>
                </a>
                <ul class="submenu <%= isComplaintsOpen ? "open" : "" %>" style="<%= isComplaintsOpen ? "display: block;" : "" %>">
                    <li><a href="<%= request.getContextPath() %>/admin/new-complaints" <%= isNewComplaints ? "style=\"color: #f97316; font-weight: bold;\"" : "" %>>New</a></li>
                    <li><a href="<%= request.getContextPath() %>/admin/inprocess-complaints" <%= isInprocessComplaints ? "style=\"color: #f97316; font-weight: bold;\"" : "" %>>In Process</a></li>
                    <li><a href="<%= request.getContextPath() %>/admin/closed-complaints" <%= isClosedComplaints ? "style=\"color: #f97316; font-weight: bold;\"" : "" %>>Closed</a></li>
                    <li><a href="<%= request.getContextPath() %>/admin/all-complaints" <%= isAllComplaints ? "style=\"color: #f97316; font-weight: bold;\"" : "" %>>All</a></li>
                </ul>
            </li>

            <!-- Security Change Password -->
            <li>
                <a href="<%= request.getContextPath() %>/admin/change-password.jsp" <%= isChangePassword ? "style=\"background: #f97316; color: #fff;\"" : "" %>>
                    <i class="fa-solid fa-key"></i> Change Password
                </a>
            </li>

            <!-- Logout -->
            <li>
                <a href="<%= request.getContextPath() %>/admin/logout" style="color: #dc2626;">
                    <i class="fa-solid fa-power-off"></i> Log Out
                </a>
            </li>
        </ul>
    </aside>
