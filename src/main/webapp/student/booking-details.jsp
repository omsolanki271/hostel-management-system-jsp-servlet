<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setAttribute("activeMenu", "myRoom");
    %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="java.util.Map" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user") == null || !"user".equals(sess.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    // Auto-load details if booking attribute is missing
    if (request.getAttribute("booking") == null && request.getAttribute("error") == null) {
        response.sendRedirect(request.getContextPath() + "/student/booking-details");
        return;
    }

    Map<String, Object> booking = (Map<String, Object>) request.getAttribute("booking");
    String name = (String) sess.getAttribute("studentName");
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>My Booking Details | Hostel System</title>

    <!-- Custom CSS from PHP project -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        .room-box {
            width: 95%;
            margin: 20px auto;
            background: #fff;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

        h2 {
            color: #F97316;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        table td,
        table th {
            padding: 12px;
            border: 1px solid #ddd;
            vertical-align: top;
            color: #334155;
        }

        table th {
            background: #f1f1f1;
            text-align: left;
            font-weight: bold;
        }

        .section-title {
            background: #F97316;
            color: #fff;
            padding: 10px;
            font-size: 18px;
            margin-top: 20px;
            border-radius: 6px;
            font-weight: bold;
        }

        .print-btn {
            float: right;
            background: #F97316;
            color: white;
            padding: 8px 16px;
            border-radius: 6px;
            cursor: pointer;
            border: none;
            font-weight: bold;
        }
        
        .print-btn:hover {
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
    </style>

    <script>
        function printDetails() {
            var divContents = document.getElementById("printArea").innerHTML;
            // Remove the print button from print output
            var printWindow = window.open('', '', 'height=800,width=900');
            printWindow.document.write('<html><head><title>Print Room Details</title>');
            printWindow.document.write('<style>table {width:100%; border-collapse:collapse;} table td, table th {padding:12px; border:1px solid #ddd; vertical-align:top;} table th {background:#f1f1f1; text-align:left;} .section-title {background:#F97316; color:#fff; padding:10px; font-size:18px; margin-top:20px; border-radius:6px; font-weight:bold;} h2 {color:#F97316;} .print-btn {display:none;}</style>');
            printWindow.document.write('</head><body>');
            printWindow.document.write(divContents);
            printWindow.document.write('</body></html>');
            printWindow.document.close();
            printWindow.print();
        }
    </script>
</head>

<body>

        <!-- Header -->
    <%
        boolean isBooked = (booking != null);
        request.setAttribute("isBooked", isBooked);
    %>
    <%@ include file="/common/student-header.jsp" %>

    <!-- Main Container -->
    <div class="dashboard-container" style="padding-top: 20px;">
        
        <%
            String success = request.getParameter("success");
            if (success != null) {
        %>
            <div class="alert-box alert-success"><%= success %></div>
        <% } %>

        <% if (booking == null) { %>
            <div class="room-box">
                <h2>My Room Details</h2>
                <p style="color:red; font-weight:bold;">You have not booked any hostel room yet.</p>
                <p style="margin-top: 15px;">
                    <a href="${pageContext.request.contextPath}/student/available-rooms" class="print-btn" style="float:none; display:inline-block;">Book Room Now</a>
                </p>
            </div>
        <% } else { %>
            
            <div class="room-box" id="printArea">
                <h2>My Room Details</h2>

                <button class="print-btn" onclick="printDetails()">Print</button>

                <!-- ROOM INFO -->
                <div class="section-title">Room Related Info</div>

                <table>
                    <tr>
                        <th>Registration No</th>
                        <td><%= booking.get("regno") %></td>
                        <th>Apply Date</th>
                        <td colspan="3"><%= booking.get("postingDate") %></td>
                    </tr>

                    <tr>
                        <th>Room No</th>
                        <td><%= booking.get("roomno") %></td>
                        <th>Seater</th>
                        <td><%= booking.get("seater") %> Seater</td>
                        <th>Fees (PM)</th>
                        <td><%= booking.get("feespm") %></td>
                    </tr>

                    <tr>
                        <th>Food Status</th>
                        <td><%= ((Integer) booking.get("foodstatus") == 1) ? "With Food" : "Without Food" %></td>
                        <th>Stay From</th>
                        <td><%= booking.get("stayfrom") %></td>
                        <th>Duration</th>
                        <td><%= booking.get("duration") %> Month(s)</td>
                    </tr>

                    <tr>
                        <th>Hostel Fee</th>
                        <td><%= request.getAttribute("hostelFee") %></td>
                        <th>Food Fee</th>
                        <td colspan="3">
                            <%= request.getAttribute("foodFee") %>
                            <% if ((Integer) booking.get("foodstatus") == 0) { %>
                                <span style="color:red;">(Booked without food)</span>
                            <% } %>
                        </td>
                    </tr>

                    <tr>
                        <th>Total Fee</th>
                        <td colspan="5" style="font-weight:bold; color: #f97316; font-size: 16px;"><%= request.getAttribute("totalFee") %></td>
                    </tr>
                </table>

                <!-- PERSONAL INFO -->
                <div class="section-title">Personal Info</div>

                <table>
                    <tr>
                        <th>Full Name</th>
                        <td><%= booking.get("firstName") %> <%= booking.get("middleName") != null ? booking.get("middleName") : "" %> <%= booking.get("lastName") %></td>
                        <th>Email</th>
                        <td><%= booking.get("emailid") %></td>
                        <th>Contact</th>
                        <td><%= booking.get("contactno") %></td>
                    </tr>

                    <tr>
                        <th>Gender</th>
                        <td><%= booking.get("gender") %></td>
                        <th>Course</th>
                        <td><%= booking.get("course") %></td>
                        <th>Emergency Contact</th>
                        <td><%= booking.get("egycontactno") %></td>
                    </tr>

                    <tr>
                        <th>Guardian Name</th>
                        <td><%= booking.get("guardianName") %></td>
                        <th>Relation</th>
                        <td><%= booking.get("guardianRelation") %></td>
                        <th>Guardian Contact</th>
                        <td><%= booking.get("guardianContactno") %></td>
                    </tr>
                </table>

                <!-- ADDRESS INFO -->
                <div class="section-title">Address Details</div>

                <table>
                    <tr>
                        <th>Correspondence Address</th>
                        <td colspan="2">
                            <%= booking.get("corresAddress") %><br>
                            <%= booking.get("corresCIty") %> - <%= booking.get("corresPincode") %><br>
                            <%= booking.get("corresState") %>
                        </td>

                        <th>Permanent Address</th>
                        <td colspan="2">
                            <%= booking.get("pmntAddress") %><br>
                            <%= booking.get("pmntCity") %> - <%= booking.get("pmntPincode") %><br>
                            <%= booking.get("pmnatetState") %>
                        </td>
                    </tr>
                </table>
            </div>
            
        <% } %>
    </div>

        <!-- Footer -->
    <%@ include file="/common/student-footer.jsp" %>

</body>

</html>
