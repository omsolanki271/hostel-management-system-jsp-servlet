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
    
    // Auto-load details if missing
    if (request.getAttribute("complaint") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/all-complaints");
        return;
    }

    Map<String, Object> complaint = (Map<String, Object>) request.getAttribute("complaint");
    Map<String, Object> student = (Map<String, Object>) request.getAttribute("student");
    List<Map<String, Object>> history = (List<Map<String, Object>>) request.getAttribute("history");
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Complaint Details | Admin Panel</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
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

        .action-btn {
            background: #3b82f6;
            color: #fff;
            padding: 8px 16px;
            border-radius: 6px;
            cursor: pointer;
            margin-top: 20px;
            display: inline-block;
            border: none;
            font-weight: bold;
            font-size: 14px;
        }
        
        .action-btn:hover {
            background: #2563eb;
        }

        .modal-box {
            background: #fff;
            width: 420px;
            padding: 20px;
            border-radius: 14px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            display: none;
            z-index: 30;
        }

        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.45);
            z-index: 20;
            display: none;
        }

        .close-modal {
            float: right;
            font-size: 22px;
            cursor: pointer;
            color: #64748b;
        }
        
        .close-modal:hover {
            color: #ef4444;
        }

        textarea,
        select {
            width: 100%;
            padding: 10px;
            border-radius: 6px;
            border: 1px solid #ccc;
            margin-top: 10px;
            font-size: 14px;
            color: #334155;
        }

        .submit-btn {
            background: #f97316;
            border: none;
            padding: 10px 18px;
            color: #fff;
            cursor: pointer;
            border-radius: 6px;
            margin-top: 15px;
            font-weight: bold;
            width: 100%;
            font-size: 15px;
        }
        
        .submit-btn:hover {
            background: #ea580c;
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

        <h2 class="page-title">Complaint #<%= complaint.get("ComplainNumber") %> Details</h2>

        <%
            String success = request.getParameter("success");
            String error = (String) request.getAttribute("error");
            if (success != null) {
        %>
            <div class="alert-box alert-success"><%= success %></div>
        <% } %>

        <%
            if (error != null) {
        %>
            <div class="alert-box alert-error"><%= error %></div>
        <% } %>

        <div class="details-box">
            <h3>Student & Complaint Details</h3>
            <table>
                <tr>
                    <th>Complaint Number</th>
                    <td>#<%= complaint.get("ComplainNumber") %></td>
                    <th>Registration Date</th>
                    <td><%= complaint.get("registrationDate") %></td>
                </tr>

                <% if (student != null) { %>
                    <tr>
                        <th>Student Name</th>
                        <td><%= student.get("name") %></td>
                        <th>Contact / Email</th>
                        <td><%= student.get("contactNo") %> / <%= student.get("email") %></td>
                    </tr>
                <% } %>

                <tr>
                    <th>Complaint Type</th>
                    <td><%= complaint.get("complaintType") %></td>
                    <th>Attachment File</th>
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
                        %>
                        <% if (status == null || status.trim().isEmpty() || "New".equalsIgnoreCase(status) || "Pending".equalsIgnoreCase(status)) { %>
                            <span style="color:#ef4444; font-weight:bold;">New</span>
                        <% } else if ("In Process".equalsIgnoreCase(status)) { %>
                            <span style="color:#f97316; font-weight:bold;">In Process</span>
                        <% } else { %>
                            <span style="color:#22c55e; font-weight:bold;">Closed</span>
                        <% } %>
                    </td>
                </tr>
            </table>
        </div>

        <!-- History details log -->
        <div class="details-box">
            <h3>Complaint Action History</h3>
            <table class="history-table">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Remarks</th>
                        <th>Status</th>
                        <th>Date</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        if (history == null || history.isEmpty()) {
                    %>
                        <tr>
                            <td colspan="4" style="text-align: center; color: #777;">No history logs found.</td>
                        </tr>
                    <%
                        } else {
                            int count = 1;
                            for (Map<String, Object> r : history) {
                    %>
                        <tr>
                            <td><%= count++ %></td>
                            <td style="white-space: pre-line;"><%= r.get("complaintRemark") %></td>
                            <td><%= r.get("compalintStatus") %></td>
                            <td><%= r.get("postingDate") %></td>
                        </tr>
                    <%
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>

        <% if (!"Closed".equalsIgnoreCase(status)) { %>
            <button class="action-btn" id="openModal"><i class="fa fa-edit"></i> Take Action</button>
        <% } %>

    </div>

    <!-- Modal -->
    <div class="modal-overlay" id="modalOverlay"></div>

    <div class="modal-box" id="modalBox">
        <span class="close-modal" id="closeModal">&times;</span>
        <h3>Update Complaint</h3>
        <form method="POST" action="<%= request.getContextPath() %>/admin/complaint-details?cid=<%= complaint.get("id") %>">
            <select name="cstatus" required>
                <option value="">Select Status</option>
                <option value="In Process">In Process</option>
                <option value="Closed">Closed</option>
            </select>
            <textarea name="remark" placeholder="Enter remark..." rows="4" required></textarea>
            <button type="submit" name="submit" class="submit-btn">Submit</button>
        </form>
    </div>

    <script>
        const modal = document.getElementById("modalBox");
        const overlay = document.getElementById("modalOverlay");
        const openBtn = document.getElementById("openModal");
        const closeBtn = document.getElementById("closeModal");

        if (openBtn) {
            openBtn.onclick = () => {
                modal.style.display = "block";
                overlay.style.display = "block";
            };
        }

        if (closeBtn) {
            closeBtn.onclick = () => {
                modal.style.display = "none";
                overlay.style.display = "none";
            };
        }

        if (overlay) {
            overlay.onclick = () => {
                modal.style.display = "none";
                overlay.style.display = "none";
            };
        }
    </script>

    <!-- Footer -->
    <%@ include file="/common/admin-footer.jsp" %>

</body>

</html>
