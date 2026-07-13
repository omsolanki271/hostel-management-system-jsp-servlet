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

@WebServlet("/admin/manage-leaves")
public class AdminManageLeavesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String idStr = request.getParameter("id");

        if (action != null && idStr != null) {
            Connection conn = null;
            PreparedStatement ps = null;
            try {
                int leaveId = Integer.parseInt(idStr.trim());
                String status = null;
                String remarks = null;

                if ("approve".equalsIgnoreCase(action)) {
                    status = "Approved";
                    remarks = "Approved by Admin";
                } else if ("reject".equalsIgnoreCase(action)) {
                    status = "Rejected";
                    remarks = "Rejected by Admin";
                }

                if (status != null) {
                    conn = DBConnection.getConnection();
                    String updateQuery = "UPDATE leave_applications SET status = ?, remarks = ? WHERE id = ?";
                    ps = conn.prepareStatement(updateQuery);
                    ps.setString(1, status);
                    ps.setString(2, remarks);
                    ps.setInt(3, leaveId);
                    ps.executeUpdate();
                    
                    response.sendRedirect(request.getContextPath() + "/admin/manage-leaves?success=Leave+has+been+" + status);
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try { if (ps != null) ps.close(); } catch (SQLException e) {}
                try { if (conn != null) conn.close(); } catch (SQLException e) {}
            }
        }

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Map<String, Object>> leaves = new ArrayList<>();

        try {
            conn = DBConnection.getConnection();
            String selectQuery = "SELECT l.id, l.student_id, l.from_date, l.to_date, l.reason, l.status, l.remarks, l.applied_on, u.regNo " +
                                 "FROM leave_applications l " +
                                 "LEFT JOIN userregistration u ON l.student_id = u.id " +
                                 "ORDER BY l.applied_on DESC";
            ps = conn.prepareStatement(selectQuery);
            rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> leave = new HashMap<>();
                leave.put("id", rs.getInt("id"));
                leave.put("student_id", rs.getInt("student_id"));
                leave.put("regno", rs.getString("regNo"));
                leave.put("from_date", rs.getDate("from_date"));
                leave.put("to_date", rs.getDate("to_date"));
                leave.put("reason", rs.getString("reason"));
                leave.put("status", rs.getString("status"));
                leave.put("remarks", rs.getString("remarks"));
                leave.put("applied_on", rs.getTimestamp("applied_on"));
                leaves.add(leave);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: Database error: " + e.getMessage());
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }

        request.setAttribute("leaves", leaves);
        request.getRequestDispatcher("/admin/manage-leaves.jsp").forward(request, response);
    }
}
