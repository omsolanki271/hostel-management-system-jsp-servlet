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

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
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
        try {
            conn = DBConnection.getConnection();

            request.setAttribute("totalStudents", getCount(conn, "SELECT COUNT(*) FROM userregistration"));
            request.setAttribute("totalRooms", getCount(conn, "SELECT COUNT(*) FROM rooms"));
            request.setAttribute("totalCourses", getCount(conn, "SELECT COUNT(*) FROM courses"));
            request.setAttribute("newComplaints", getCount(conn, "SELECT COUNT(*) FROM complaints WHERE complaintStatus='Pending' OR complaintStatus IS NULL OR complaintStatus = ''"));
            request.setAttribute("inProcess", getCount(conn, "SELECT COUNT(*) FROM complaints WHERE complaintStatus='In Process'"));
            request.setAttribute("closedComplaints", getCount(conn, "SELECT COUNT(*) FROM complaints WHERE complaintStatus='Closed'"));
            request.setAttribute("pendingLeaves", getCount(conn, "SELECT COUNT(*) FROM leave_applications WHERE status='Pending'"));
            request.setAttribute("approvedLeaves", getCount(conn, "SELECT COUNT(*) FROM leave_applications WHERE status='Approved'"));
            request.setAttribute("rejectedLeaves", getCount(conn, "SELECT COUNT(*) FROM leave_applications WHERE status='Rejected'"));
            request.setAttribute("totalFeedback", getCount(conn, "SELECT COUNT(*) FROM feedback"));
            request.setAttribute("totalNotices", getCount(conn, "SELECT COUNT(*) FROM noticeboard"));

            // Fetch recent pending leaves
            List<Map<String, Object>> leaves = new ArrayList<>();
            PreparedStatement ps = null;
            ResultSet rs = null;
            try {
                String query = "SELECT id, student_id, from_date, to_date, reason, applied_on FROM leave_applications WHERE status='Pending' ORDER BY applied_on DESC LIMIT 5";
                ps = conn.prepareStatement(query);
                rs = ps.executeQuery();
                while (rs.next()) {
                    Map<String, Object> leave = new HashMap<>();
                    leave.put("id", rs.getInt("id"));
                    leave.put("student_id", rs.getString("student_id"));
                    leave.put("from_date", rs.getString("from_date"));
                    leave.put("to_date", rs.getString("to_date"));
                    leave.put("reason", rs.getString("reason"));
                    leave.put("applied_on", rs.getString("applied_on"));
                    leaves.add(leave);
                }
            } catch (SQLException e) {
                // table might not exist
                System.err.println("Note: leave_applications table error: " + e.getMessage());
            } finally {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
            }
            request.setAttribute("recentLeaves", leaves);

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }

        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }

    private int getCount(Connection conn, String sql) {
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            // Table or column might not exist yet, print notice and return 0
            System.err.println("Note: Count query failed (" + sql + "): " + e.getMessage());
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
        }
        return 0;
    }
}
