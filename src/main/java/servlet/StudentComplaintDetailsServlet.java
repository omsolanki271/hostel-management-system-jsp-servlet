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

@WebServlet("/student/complaint-details")
public class StudentComplaintDetailsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null || !"user".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("user");
        String cidStr = request.getParameter("cid");
        if (cidStr == null || cidStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/student/my-complaints");
            return;
        }

        int cid = 0;
        try {
            cid = Integer.parseInt(cidStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/student/my-complaints");
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Map<String, Object> complaint = null;
        List<Map<String, Object>> history = new ArrayList<>();

        try {
            conn = DBConnection.getConnection();

            // Fetch Complaint
            String complaintQuery = "SELECT id, ComplainNumber, complaintType, complaintDetails, complaintDoc, complaintStatus, registrationDate " +
                                     "FROM complaints WHERE id = ? AND userId = ? LIMIT 1";
            ps = conn.prepareStatement(complaintQuery);
            ps.setInt(1, cid);
            ps.setInt(2, userId);
            rs = ps.executeQuery();
            if (rs.next()) {
                complaint = new HashMap<>();
                complaint.put("id", rs.getInt("id"));
                complaint.put("ComplainNumber", rs.getInt("ComplainNumber"));
                complaint.put("complaintType", rs.getString("complaintType"));
                complaint.put("complaintDetails", rs.getString("complaintDetails"));
                complaint.put("complaintDoc", rs.getString("complaintDoc"));
                complaint.put("complaintStatus", rs.getString("complaintStatus"));
                complaint.put("registrationDate", rs.getString("registrationDate"));
            }
            rs.close();
            ps.close();

            if (complaint != null) {
                // Fetch History
                String historyQuery = "SELECT compalintStatus, complaintRemark, postingDate FROM complainthistory WHERE complaintid = ? ORDER BY id DESC";
                ps = conn.prepareStatement(historyQuery);
                ps.setInt(1, cid);
                rs = ps.executeQuery();
                while (rs.next()) {
                    Map<String, Object> record = new HashMap<>();
                    record.put("compalintStatus", rs.getString("compalintStatus"));
                    record.put("complaintRemark", rs.getString("complaintRemark"));
                    record.put("postingDate", rs.getString("postingDate"));
                    history.add(record);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: Database error: " + e.getMessage());
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }

        if (complaint == null) {
            response.sendRedirect(request.getContextPath() + "/student/my-complaints");
            return;
        }

        request.setAttribute("complaint", complaint);
        request.setAttribute("history", history);
        request.getRequestDispatcher("/student/complaint-details.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
