<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
request.setAttribute("activeMenu", "changePassword");
%>
<%@ page import="javax.servlet.http.HttpSession"%>
<%@ page import="java.sql.*"%>
<%@ page import="util.DBConnection"%>
<%
HttpSession sess = request.getSession(false);
if (sess == null || sess.getAttribute("user") == null || !"user".equals(sess.getAttribute("role"))) {
	response.sendRedirect(request.getContextPath() + "/login.jsp");
	return;
}
String name = (String) sess.getAttribute("studentName");
int studentId = (Integer) sess.getAttribute("user");

// Fetch last updated password date & booking status using JDBC
String lastUpdatedDate = null;
boolean isBooked = false;
String regNo = (String) sess.getAttribute("regNo");
String studentEmail = (String) sess.getAttribute("studentEmail");
Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;
try {
	conn = DBConnection.getConnection();
	ps = conn.prepareStatement("SELECT updationDate FROM userregistration WHERE id = ?");
	ps.setInt(1, studentId);
	rs = ps.executeQuery();
	if (rs.next()) {
		lastUpdatedDate = rs.getString("updationDate");
	}

	// Check booking status
	ps.close();
	ps = conn.prepareStatement("SELECT id FROM registration WHERE regno = ? OR emailid = ? LIMIT 1");
	ps.setString(1, regNo);
	ps.setString(2, studentEmail);
	rs.close();
	rs = ps.executeQuery();
	if (rs.next()) {
		isBooked = true;
	}
} catch (Exception e) {
	e.printStackTrace();
} finally {
	try {
		if (rs != null)
	rs.close();
	} catch (Exception e) {
	}
	try {
		if (ps != null)
	ps.close();
	} catch (Exception e) {
	}
	try {
		if (conn != null)
	conn.close();
	} catch (Exception e) {
	}
}
%>
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<title>Change Password | Hostel System</title>
<!-- Custom CSS from PHP project -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/user.css">
<!-- Font Awesome -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
.pwd-container {
	max-width: 500px;
	margin: 20px 0;
	background: #fff;
	padding: 25px;
	border-radius: 12px;
	box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
}

.pwd-container h2 {
	color: #F97316;
	margin-bottom: 10px;
}

.pwd-container label {
	font-weight: 600;
	color: #334155;
	display: block;
	margin-top: 10px;
}

.pwd-container input {
	width: 95%;
	padding: 12px;
	margin-top: 6px;
	border-radius: 8px;
	border: 1px solid #ddd;
	margin-bottom: 15px;
}

.msg-box {
	padding: 10px;
	margin-bottom: 15px;
	font-weight: bold;
	border-radius: 6px;
}

.msg-error {
	background-color: #f8d7da;
	color: #721c24;
	border: 1px solid #f5c6cb;
}

.msg-success {
	background-color: #d4edda;
	color: #155724;
	border: 1px solid #c3e6cb;
}

.btn-primary {
	background: #F97316;
	color: white;
	padding: 12px 18px;
	border: none;
	border-radius: 8px;
	font-size: 16px;
	cursor: pointer;
	font-weight: 600;
	transition: 0.3s;
}

.btn-primary:hover {
	background: #EA580C;
}

.full-btn {
	width: 100%;
	text-align: center;
}
</style>
</head>

<body>

	<!-- Header -->
	<% request.setAttribute("isBooked", isBooked); %>
    <%@ include file="/common/student-header.jsp" %>

	<div class="pwd-container">
		<h2>
			<i class="fa fa-lock"></i> Change Password
		</h2>

		<%
		if (lastUpdatedDate != null && !lastUpdatedDate.isEmpty()) {
		%>
		<p>
			<small>Last updated: <%=lastUpdatedDate%></small>
		</p>
		<%
		}
		%>

		<%
		String error = (String) request.getAttribute("error");
		String success = (String) request.getAttribute("success");
		if (error != null) {
		%>
		<div class="msg-box msg-error"><%=error%></div>
		<%
		}
		%>

		<%
		if (success != null) {
		%>
		<div class="msg-box msg-success"><%=success%></div>
		<%
		}
		%>

		<form method="POST"
			action="${pageContext.request.contextPath}/student/change-password">
			<label for="oldpassword">Old Password</label> <input type="password"
				name="oldpassword" id="oldpassword" required
				placeholder="Enter Current Password"> <label
				for="newpassword">New Password</label> <input type="password"
				name="newpassword" id="newpassword" required
				placeholder="Enter New Password"> <label for="cpassword">Confirm
				Password</label> <input type="password" name="cpassword" id="cpassword"
				required placeholder="Confirm New Password">

			<button type="submit" class="btn-primary full-btn">Update
				Password</button>
		</form>
	</div>

	<!-- Footer -->
	<%@ include file="/common/student-footer.jsp"%>

</body>

</html>
