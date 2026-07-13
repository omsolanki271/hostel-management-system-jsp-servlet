package servlet;

import util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/all-complaints")
public class AdminAllComplaintsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("admin") == null || !"admin".equals(session.getAttribute("role"))) {
			response.sendRedirect(request.getContextPath() + "/login.jsp");
			return;
		}

		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		List<Map<String, Object>> complaints = new ArrayList<>();

		try {
			conn = DBConnection.getConnection();
			String selectQuery = "SELECT id, ComplainNumber, complaintType, complaintStatus, registrationDate FROM complaints ORDER BY id DESC";
			ps = conn.prepareStatement(selectQuery);
			rs = ps.executeQuery();
			while (rs.next()) {
				Map<String, Object> complaint = new HashMap<>();
				complaint.put("id", rs.getInt("id"));
				complaint.put("ComplainNumber", rs.getInt("ComplainNumber"));
				complaint.put("complaintType", rs.getString("complaintType"));
				complaint.put("complaintStatus", rs.getString("complaintStatus"));
				complaint.put("registrationDate", rs.getString("registrationDate"));
				complaints.add(complaint);
			}
		} catch (SQLException e) {
			e.printStackTrace();
			request.setAttribute("error", "Error: Database error: " + e.getMessage());
		} finally {
			try {
				if (rs != null)
					rs.close();
			} catch (SQLException e) {
			}
			try {
				if (ps != null)
					ps.close();
			} catch (SQLException e) {
			}
			try {
				if (conn != null)
					conn.close();
			} catch (SQLException e) {
			}
		}

		request.setAttribute("complaints", complaints);
		request.getRequestDispatcher("/admin/all-complaints.jsp").forward(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}
}
