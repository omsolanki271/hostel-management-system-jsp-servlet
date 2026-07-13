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
import java.util.HashMap;
import java.util.Map;

@WebServlet("/admin/edit-room")
public class EditRoomServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-rooms");
            return;
        }

        int id = 0;
        try {
            id = Integer.parseInt(idStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-rooms");
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Map<String, Object> room = null;

        try {
            conn = DBConnection.getConnection();
            String selectQuery = "SELECT id, seater, room_no, fees FROM rooms WHERE id = ?";
            ps = conn.prepareStatement(selectQuery);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                room = new HashMap<>();
                room.put("id", rs.getInt("id"));
                room.put("seater", rs.getInt("seater"));
                room.put("room_no", rs.getInt("room_no"));
                room.put("fees", rs.getInt("fees"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: Database error: " + e.getMessage());
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }

        if (room == null) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-rooms");
            return;
        }

        request.setAttribute("room", room);
        request.getRequestDispatcher("/admin/edit-room.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String idStr = request.getParameter("id");
        String seaterStr = request.getParameter("seater");
        String feesStr = request.getParameter("fees");

        if (idStr == null || seaterStr == null || feesStr == null ||
            idStr.trim().isEmpty() || seaterStr.trim().isEmpty() || feesStr.trim().isEmpty()) {
            
            request.setAttribute("error", "Error: Seater and Fees are required.");
            doGet(request, response);
            return;
        }

        int id = 0;
        int seater = 0;
        int fees = 0;

        try {
            id = Integer.parseInt(idStr.trim());
            seater = Integer.parseInt(seaterStr.trim());
            fees = Integer.parseInt(feesStr.trim());
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Error: Seater and Fees must be numeric values.");
            doGet(request, response);
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;
        boolean updated = false;

        try {
            conn = DBConnection.getConnection();
            String updateQuery = "UPDATE rooms SET seater = ?, fees = ? WHERE id = ?";
            ps = conn.prepareStatement(updateQuery);
            ps.setInt(1, seater);
            ps.setInt(2, fees);
            ps.setInt(3, id);
            
            updated = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: Database error: " + e.getMessage());
        } finally {
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }

        if (updated) {
            // Redirect to manage rooms with success parameter
            response.sendRedirect(request.getContextPath() + "/admin/manage-rooms?success=Success:+Room+updated+successfully.");
        } else {
            request.setAttribute("error", "Error: Room update failed. Try again.");
            doGet(request, response);
        }
    }
}
