<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setAttribute("activeMenu", "manageStudents");
%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="java.util.Map" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("admin") == null || !"admin".equals(sess.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    // Auto-load details if student details are missing
    if (request.getAttribute("student") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/manage-students");
        return;
    }

    Map<String, Object> student = (Map<String, Object>) request.getAttribute("student");
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Student Details | Admin Panel</title>

    <!-- CSS from PHP reference project -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        .details-box {
            background: #fff;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            margin-top: 20px;
        }

        .section-title {
            background: #f97316;
            color: white;
            padding: 10px 14px;
            border-radius: 5px;
            margin: 20px 0 10px;
            font-size: 16px;
            font-weight: bold;
        }

        table.details-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }

        table.details-table th,
        table.details-table td {
            border: 1px solid #eee;
            padding: 10px;
            font-size: 14px;
            text-align: left;
            color: #334155;
        }

        table.details-table th {
            background: #fafafa;
            width: 25%;
            font-weight: bold;
        }

        .print-btn {
            float: right;
            margin-bottom: 10px;
            background: #f97316;
            color: white;
            padding: 8px 14px;
            border-radius: 6px;
            cursor: pointer;
            border: none;
            font-weight: bold;
            font-size: 14px;
        }
        
        .print-btn:hover {
            background: #ea580c;
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

        <h2 class="page-title">Student Details</h2>

        <button class="print-btn" onclick="printPage()">
            <i class="fa fa-print"></i> Print
        </button>

        <div id="printArea">
            <div class="details-box">

                <!-- ROOM INFORMATION -->
                <div class="section-title">Room Information</div>

                <table class="details-table">
                    <tr>
                        <th>Registration No</th>
                        <td><%= student.get("regno") %></td>
                        <th>Apply Date</th>
                        <td><%= student.get("postingDate") %></td>
                    </tr>

                    <tr>
                        <th>Room No</th>
                        <td><%= student.get("roomno") %></td>
                        <th>Seater</th>
                        <td><%= student.get("seater") %> Seater</td>
                    </tr>

                    <tr>
                        <th>Fees (Per Month)</th>
                        <td><%= student.get("feespm") %></td>
                        <th>Stay From</th>
                        <td><%= student.get("stayfrom") %></td>
                    </tr>

                    <tr>
                        <th>Food Status</th>
                        <td><%= ((Integer) student.get("foodstatus") == 1) ? "With Food" : "Without Food" %></td>
                        <th>Duration (Months)</th>
                        <td><%= student.get("duration") %></td>
                    </tr>

                    <tr>
                        <th>Hostel Fee Total</th>
                        <td><%= request.getAttribute("hostelFee") %></td>
                        <th>Food Fee Total</th>
                        <td><%= request.getAttribute("foodFee") %></td>
                    </tr>

                    <tr>
                        <th>Total Amount</th>
                        <td colspan="3" style="font-weight:bold; color:#f97316; font-size:16px;">
                            <%= request.getAttribute("totalFee") %>
                        </td>
                    </tr>
                </table>

                <!-- PERSONAL DETAILS -->
                <div class="section-title">Personal Information</div>

                <table class="details-table">
                    <tr>
                        <th>Full Name</th>
                        <td><%= student.get("firstName") %> <%= student.get("middleName") != null ? student.get("middleName") : "" %> <%= student.get("lastName") %></td>
                        <th>Email</th>
                        <td><%= student.get("emailid") %></td>
                    </tr>

                    <tr>
                        <th>Contact No</th>
                        <td><%= student.get("contactno") %></td>
                        <th>Gender</th>
                        <td><%= student.get("gender") %></td>
                    </tr>

                    <tr>
                        <th>Course</th>
                        <td><%= student.get("course") %></td>
                        <th>Emergency Contact</th>
                        <td><%= student.get("egycontactno") %></td>
                    </tr>
                </table>

                <!-- GUARDIAN DETAILS -->
                <div class="section-title">Guardian Details</div>

                <table class="details-table">
                    <tr>
                        <th>Guardian Name</th>
                        <td><%= student.get("guardianName") %></td>
                        <th>Relation</th>
                        <td><%= student.get("guardianRelation") %></td>
                    </tr>

                    <tr>
                        <th>Guardian Contact</th>
                        <td colspan="3"><%= student.get("guardianContactno") %></td>
                    </tr>
                </table>

                <!-- ADDRESS -->
                <div class="section-title">Addresses</div>

                <table class="details-table">
                    <tr>
                        <th>Correspondence Address</th>
                        <td colspan="3">
                            <%= student.get("corresAddress") %><br>
                            <%= student.get("corresCIty") %> - <%= student.get("corresPincode") %><br>
                            <%= student.get("corresState") %>
                        </td>
                    </tr>

                    <tr>
                        <th>Permanent Address</th>
                        <td colspan="3">
                            <%= student.get("pmntAddress") %><br>
                            <%= student.get("pmntCity") %> - <%= student.get("pmntPincode") %><br>
                            <%= student.get("pmnatetState") %>
                        </td>
                    </tr>
                </table>

            </div>
        </div>

    </div>

        <!-- Footer -->
    <%@ include file="/common/admin-footer.jsp" %>

</body>

</html>
