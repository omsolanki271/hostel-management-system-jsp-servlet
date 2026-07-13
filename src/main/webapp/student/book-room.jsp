<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setAttribute("activeMenu", "bookRoom");
    %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="model.Student" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user") == null || !"user".equals(sess.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    // Auto-load details if attributes are missing
    if (request.getAttribute("student") == null) {
        response.sendRedirect(request.getContextPath() + "/student/book-room");
        return;
    }

    Student student = (Student) request.getAttribute("student");
    List<Map<String, Object>> rooms = (List<Map<String, Object>>) request.getAttribute("rooms");
    List<Map<String, Object>> courses = (List<Map<String, Object>>) request.getAttribute("courses");
    List<Map<String, Object>> states = (List<Map<String, Object>>) request.getAttribute("states");
    String name = (String) sess.getAttribute("studentName");
    String selectedRoom = request.getParameter("room");
    String regNo = (String) sess.getAttribute("regNo");
    String studentEmail = (String) sess.getAttribute("studentEmail");

    // Check if already registered
    boolean isBooked = false;
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
        conn = DBConnection.getConnection();
        ps = conn.prepareStatement("SELECT id FROM registration WHERE regno = ? OR emailid = ? LIMIT 1");
        ps.setString(1, regNo);
        ps.setString(2, studentEmail);
        rs = ps.executeQuery();
        if (rs.next()) {
            isBooked = true;
        }
    } catch(Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch(Exception e){}
        try { if (ps != null) ps.close(); } catch(Exception e){}
        try { if (conn != null) conn.close(); } catch(Exception e){}
    }
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Student Registration | Hostel System</title>

    <!-- Custom CSS from PHP project -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        .form-box {
            background: #fff;
            padding: 25px;
            border-radius: 10px;
            max-width: 1000px;
            margin-top: 20px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }

        .section {
            color: #f97316;
            font-weight: 700;
            margin: 25px 0 12px;
            font-size: 1.1rem;
            border-bottom: 2px solid #f97316;
            padding-bottom: 5px;
        }

        .row {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 15px;
            margin-bottom: 15px;
        }

        .row2 {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
            margin-bottom: 15px;
        }

        input,
        select,
        textarea {
            width: 100%;
            padding: 9px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
            color: #334155;
        }

        textarea {
            resize: vertical;
            height: 80px;
            margin-bottom: 15px;
        }

        label {
            font-weight: 600;
            color: #334155;
            display: block;
            margin-bottom: 5px;
        }

        .radio-group {
            display: flex;
            gap: 20px;
            margin: 10px 0 15px;
            align-items: center;
        }
        
        .radio-group input {
            width: auto;
            margin-right: 5px;
        }

        .submit-btn {
            background: #f97316;
            color: #fff;
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 15px;
            font-weight: 700;
            transition: background 0.3s;
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
        
        .alert-error {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #f87171;
        }
    </style>
</head>

<body>

        <!-- Header -->
    <% request.setAttribute("isBooked", isBooked); %>
    <%@ include file="/common/student-header.jsp" %>

    <!-- Main Container -->
    <div class="dashboard-container" style="padding-top: 20px;">
        <h2 class="dashboard-title">Student Registration</h2>
        <p class="dashboard-subtitle">Apply for hostel room and services</p>

        <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
            <div class="alert-box alert-error"><%= error %></div>
        <% } %>

        <div class="form-box">
            <form method="POST" action="${pageContext.request.contextPath}/student/book-room">

                <div class="section">Room Information</div>
                
                <div class="row">
                    <div>
                        <label for="room">Select Room *</label>
                        <select name="room" id="room" onchange="loadRoomDetails(this)" required>
                            <option value="">Select Room</option>
                            <%
                                for (Map<String, Object> r : rooms) {
                                    boolean isSelected = selectedRoom != null && selectedRoom.equals(String.valueOf(r.get("room_no")));
                            %>
                                <option value="<%= r.get("room_no") %>" 
                                        data-seater="<%= r.get("seater") %>" 
                                        data-fees="<%= r.get("fees") %>"
                                        <%= isSelected ? "selected" : "" %>>
                                    Room No <%= r.get("room_no") %>
                                </option>
                            <% } %>
                        </select>
                    </div>

                    <div>
                        <label for="seater">Seater (Capacity)</label>
                        <input name="seater" id="seater" placeholder="Seater" readonly style="background: #f1f5f9; cursor: not-allowed;">
                    </div>

                    <div>
                        <label for="fpm">Fees Per Month (PM)</label>
                        <input name="fpm" id="fpm" placeholder="Fees Per Month" readonly style="background: #f1f5f9; cursor: not-allowed;">
                    </div>
                </div>

                <div class="row2">
                    <div>
                        <label>Food Status *</label>
                        <div class="radio-group">
                            <label style="font-weight: normal; margin-bottom: 0;">
                                <input type="radio" name="foodstatus" value="0" checked> Without Food
                            </label>
                            <label style="font-weight: normal; margin-bottom: 0;">
                                <input type="radio" name="foodstatus" value="1"> With Food (+2000 per month)
                            </label>
                        </div>
                    </div>

                    <div>
                        <label for="stayf">Stay From (Start Date) *</label>
                        <input type="date" name="stayf" id="stayf" required>
                    </div>
                </div>

                <div class="row">
                    <div>
                        <label for="duration">Duration (Months) *</label>
                        <select name="duration" id="duration" required>
                            <% for (int i = 1; i <= 12; i++) { %>
                                <option value="<%= i %>"><%= i %> Month(s)</option>
                            <% } %>
                        </select>
                    </div>
                </div>

                <div class="section">Personal Information</div>
                
                <div class="row">
                    <div>
                        <label for="regno">Registration Number (RegNo) *</label>
                        <input name="regno" id="regno" value="<%= student.getRegNo() %>" readonly style="background: #f1f5f9; cursor: not-allowed;">
                    </div>

                    <div>
                        <label for="fname">First Name *</label>
                        <input name="fname" id="fname" value="<%= student.getFirstName() %>" readonly style="background: #f1f5f9; cursor: not-allowed;">
                    </div>

                    <div>
                        <label for="mname">Middle Name</label>
                        <input name="mname" id="mname" value="<%= student.getMiddleName() != null ? student.getMiddleName() : "" %>" readonly style="background: #f1f5f9; cursor: not-allowed;">
                    </div>
                </div>

                <div class="row">
                    <div>
                        <label for="lname">Last Name *</label>
                        <input name="lname" id="lname" value="<%= student.getLastName() %>" readonly style="background: #f1f5f9; cursor: not-allowed;">
                    </div>

                    <div>
                        <label for="gender">Gender *</label>
                        <input name="gender" id="gender" value="<%= student.getGender() %>" readonly style="background: #f1f5f9; cursor: not-allowed;">
                    </div>

                    <div>
                        <label for="contact">Contact Number *</label>
                        <input name="contact" id="contact" value="<%= student.getContactNo() %>" readonly style="background: #f1f5f9; cursor: not-allowed;">
                    </div>
                </div>

                <div class="row2">
                    <div>
                        <label for="email">Email *</label>
                        <input name="email" id="email" value="<%= student.getEmail() %>" readonly style="background: #f1f5f9; cursor: not-allowed;">
                    </div>

                    <div>
                        <label for="course">Select Course *</label>
                        <select name="course" id="course" required>
                            <option value="">Select Course</option>
                            <% for (Map<String, Object> c : courses) { %>
                                <option value="<%= c.get("course_fn") %>">
                                    <%= c.get("course_fn") %> (<%= c.get("course_sn") %>)
                                </option>
                            <% } %>
                        </select>
                    </div>
                </div>

                <div class="section">Guardian & Emergency Contact</div>
                
                <div class="row">
                    <div>
                        <label for="gname">Guardian Name *</label>
                        <input name="gname" id="gname" required placeholder="Enter Guardian Name">
                    </div>

                    <div>
                        <label for="grelation">Guardian Relation *</label>
                        <input name="grelation" id="grelation" required placeholder="Relation with Guardian">
                    </div>

                    <div>
                        <label for="gcontact">Guardian Contact No *</label>
                        <input name="gcontact" id="gcontact" required placeholder="Enter Guardian Contact No">
                    </div>
                </div>

                <div class="row2">
                    <div>
                        <label for="econtact">Emergency Contact No *</label>
                        <input name="econtact" id="econtact" required placeholder="Enter Emergency Contact No">
                    </div>
                </div>

                <div class="section">Correspondence Address</div>
                
                <label for="address">Address *</label>
                <textarea name="address" id="address" required placeholder="Enter Correspondence Address"></textarea>
                
                <div class="row">
                    <div>
                        <label for="city">City *</label>
                        <input name="city" id="city" required placeholder="Enter City">
                    </div>

                    <div>
                        <label for="state">State *</label>
                        <select name="state" id="state" required>
                            <option value="">Select State</option>
                            <% for (Map<String, Object> s : states) { %>
                                <option value="<%= s.get("State") %>"><%= s.get("State") %></option>
                            <% } %>
                        </select>
                    </div>

                    <div>
                        <label for="pincode">Pincode *</label>
                        <input type="number" name="pincode" id="pincode" required placeholder="Enter Pincode">
                    </div>
                </div>

                <div class="radio-group" style="margin: 15px 0;">
                    <label style="font-weight: bold; margin-bottom: 0;">
                        <input type="checkbox" id="sameaddr" onchange="copyCorrespondenceAddress()"> Correspondence Address same as Permanent Address
                    </label>
                </div>

                <div class="section">Permanent Address</div>
                
                <label for="paddress">Address *</label>
                <textarea name="paddress" id="paddress" required placeholder="Enter Permanent Address"></textarea>
                
                <div class="row">
                    <div>
                        <label for="pcity">City *</label>
                        <input name="pcity" id="pcity" required placeholder="Enter City">
                    </div>

                    <div>
                        <label for="pstate">State *</label>
                        <select name="pstate" id="pstate" required>
                            <option value="">Select State</option>
                            <% for (Map<String, Object> s : states) { %>
                                <option value="<%= s.get("State") %>"><%= s.get("State") %></option>
                            <% } %>
                        </select>
                    </div>

                    <div>
                        <label for="ppincode">Pincode *</label>
                        <input type="number" name="ppincode" id="ppincode" required placeholder="Enter Pincode">
                    </div>
                </div>

                <br>
                <button type="submit" class="submit-btn">Register Student & Book</button>

            </form>
        </div>
    </div>

    <script>
    function loadRoomDetails(selectElement) {
        const selectedOption = selectElement.options[selectElement.selectedIndex];
        if (selectedOption && selectedOption.value !== "") {
            const seater = selectedOption.getAttribute("data-seater") || "";
            const fees = selectedOption.getAttribute("data-fees") || "";
            document.getElementById("seater").value = seater;
            document.getElementById("fpm").value = fees;
        } else {
            document.getElementById("seater").value = "";
            document.getElementById("fpm").value = "";
        }
    }

    function copyCorrespondenceAddress() {
        const sameAddrCheckbox = document.getElementById("sameaddr");
        if (sameAddrCheckbox.checked) {
            document.getElementById("paddress").value = document.getElementById("address").value;
            document.getElementById("pcity").value = document.getElementById("city").value;
            document.getElementById("pstate").value = document.getElementById("state").value;
            document.getElementById("ppincode").value = document.getElementById("pincode").value;
        }
    }

    // Auto load room details if selected by available rooms params
    window.onload = function() {
        const roomSelect = document.getElementById("room");
        if (roomSelect) {
            loadRoomDetails(roomSelect);
        }
    };
    </script>

    <!-- Footer -->
    <%@ include file="/common/student-footer.jsp" %>

</body>

</html>
