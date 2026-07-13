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

@WebServlet("/admin/manage-rooms")
public class ManageRoomsServlet extends HttpServlet {
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

        // Handle deletion if 'del' parameter is provided
        String delIdStr = request.getParameter("del");
        if (delIdStr != null && !delIdStr.trim().isEmpty()) {
            int delId = 0;
            try {
                delId = Integer.parseInt(delIdStr.trim());
                conn = DBConnection.getConnection();
                String deleteQuery = "DELETE FROM rooms WHERE id = ?";
                ps = conn.prepareStatement(deleteQuery);
                ps.setInt(1, delId);
                int deleted = ps.executeUpdate();
                ps.close();

                if (deleted > 0) {
                    request.setAttribute("success", "Success: Room deleted successfully.");
                } else {
                    request.setAttribute("error", "Error: Room deletion failed. Room may not exist.");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Error: Invalid room ID format.");
            } catch (SQLException e) {
                e.printStackTrace();
                request.setAttribute("error", "Error: Database error: " + e.getMessage());
            } finally {
                try { if (ps != null) ps.close(); } catch (SQLException e) {}
                try { if (conn != null) conn.close(); } catch (SQLException e) {}
            }
        }

        // Query all rooms
        List<Map<String, Object>> rooms = new ArrayList<>();
        try {
            conn = DBConnection.getConnection();
            String selectQuery = "SELECT id, seater, room_no, fees, posting_date FROM rooms ORDER BY id DESC";
            ps = conn.prepareStatement(selectQuery);
            rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> room = new HashMap<>();
                room.put("id", rs.getInt("id"));
                room.put("seater", rs.getInt("seater"));
                room.put("room_no", rs.getInt("room_no"));
                room.put("fees", rs.getInt("fees"));
                room.put("posting_date", rs.getString("posting_date"));
                rooms.add(room);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: Database error: " + e.getMessage());
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }

        request.setAttribute("rooms", rooms);
        request.getRequestDispatcher("/admin/manage-rooms.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
