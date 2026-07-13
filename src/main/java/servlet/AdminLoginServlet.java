package servlet;

import model.Admin;
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

@WebServlet("/admin/login")
public class AdminLoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String usernameOrEmail = request.getParameter("username");
		String password = request.getParameter("password");

		if (usernameOrEmail == null || password == null || usernameOrEmail.trim().isEmpty() || password.isEmpty()) {

			request.setAttribute("error", "Error: Username and Password are required.");
			request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
			return;
		}

		Admin admin = null;
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;

		try {
			conn = DBConnection.getConnection();
			String query = "SELECT * FROM admin WHERE (username = ? OR email = ?) AND password = ?";
			ps = conn.prepareStatement(query);
			ps.setString(1, usernameOrEmail.trim());
			ps.setString(2, usernameOrEmail.trim());
			ps.setString(3, password);

			rs = ps.executeQuery();
			if (rs.next()) {
				admin = new Admin();
				admin.setId(rs.getInt("id"));
				admin.setUsername(rs.getString("username"));
				admin.setEmail(rs.getString("email"));
				admin.setPassword(rs.getString("password"));
				admin.setRegDate(rs.getTimestamp("reg_date"));
				admin.setUpdationDate(rs.getString("updation_date"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
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

		if (admin != null) {
			HttpSession session = request.getSession();
			session.setAttribute("admin", admin.getId());
			session.setAttribute("role", "admin");
			session.setAttribute("adminName", admin.getUsername());
			session.setAttribute("adminEmail", admin.getEmail());

			response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
		} else {
			request.setAttribute("error", "Error: Invalid Admin credentials. Please try again.");
			request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
		}
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
	}
}
