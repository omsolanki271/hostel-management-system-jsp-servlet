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

@WebServlet("/admin/add-room")
public class AddRoomServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("admin") == null || !"admin".equals(session.getAttribute("role"))) {
			response.sendRedirect(request.getContextPath() + "/login.jsp");
			return;
		}

		String seaterStr = request.getParameter("seater");
		String roomNoStr = request.getParameter("rmno");
		String feesStr = request.getParameter("fee");

		if (seaterStr == null || roomNoStr == null || feesStr == null || seaterStr.trim().isEmpty()
				|| roomNoStr.trim().isEmpty() || feesStr.trim().isEmpty()) {

			request.setAttribute("error", "Error: Seater, Room Number, and Fee are required.");
			request.getRequestDispatcher("/admin/add-room.jsp").forward(request, response);
			return;
		}

		int seater = 0;
		int roomNo = 0;
		int fees = 0;

		try {
			seater = Integer.parseInt(seaterStr.trim());
			roomNo = Integer.parseInt(roomNoStr.trim());
			fees = Integer.parseInt(feesStr.trim());
		} catch (NumberFormatException e) {
			request.setAttribute("error", "Error: Seater, Room Number, and Fee must be numeric values.");
			request.getRequestDispatcher("/admin/add-room.jsp").forward(request, response);
			return;
		}

		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean roomExists = false;

		try {
			conn = DBConnection.getConnection();

			// Check if room number already exists
			String checkQuery = "SELECT id FROM rooms WHERE room_no = ? LIMIT 1";
			ps = conn.prepareStatement(checkQuery);
			ps.setInt(1, roomNo);
			rs = ps.executeQuery();
			if (rs.next()) {
				roomExists = true;
			}
			rs.close();
			ps.close();

			if (roomExists) {
				request.setAttribute("error", "Error: Room already exists.");
				request.getRequestDispatcher("/admin/add-room.jsp").forward(request, response);
				return;
			}

			// Insert new room
			String insertQuery = "INSERT INTO rooms (seater, room_no, fees) VALUES (?, ?, ?)";
			ps = conn.prepareStatement(insertQuery);
			ps.setInt(1, seater);
			ps.setInt(2, roomNo);
			ps.setInt(3, fees);

			int inserted = ps.executeUpdate();
			if (inserted > 0) {
				request.setAttribute("success", "Success: Room added successfully.");
			} else {
				request.setAttribute("error", "Error: Room creation failed. Try again.");
			}

		} catch (SQLException e) {
			e.printStackTrace();
			request.setAttribute("error", "Error: Database error: " + e.getMessage());
		} finally {
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

		request.getRequestDispatcher("/admin/add-room.jsp").forward(request, response);
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("admin") == null || !"admin".equals(session.getAttribute("role"))) {
			response.sendRedirect(request.getContextPath() + "/login.jsp");
			return;
		}
		request.getRequestDispatcher("/admin/add-room.jsp").forward(request, response);
	}
}
