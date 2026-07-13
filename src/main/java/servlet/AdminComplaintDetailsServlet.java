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

@WebServlet("/admin/complaint-details")
public class AdminComplaintDetailsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String cidStr = request.getParameter("cid");
        if (cidStr == null || cidStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/all-complaints");
            return;
        }

        int cid = 0;
        try {
            cid = Integer.parseInt(cidStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/all-complaints");
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Map<String, Object> complaint = null;
        Map<String, Object> student = null;
        List<Map<String, Object>> history = new ArrayList<>();

        try {
            conn = DBConnection.getConnection();

            // Fetch Complaint details
            String complaintQuery = "SELECT id, ComplainNumber, userId, complaintType, complaintDetails, complaintDoc, complaintStatus, registrationDate " +
                                     "FROM complaints WHERE id = ? LIMIT 1";
            ps = conn.prepareStatement(complaintQuery);
            ps.setInt(1, cid);
            rs = ps.executeQuery();
            if (rs.next()) {
                complaint = new HashMap<>();
                complaint.put("id", rs.getInt("id"));
                complaint.put("ComplainNumber", rs.getInt("ComplainNumber"));
                complaint.put("userId", rs.getInt("userId"));
                complaint.put("complaintType", rs.getString("complaintType"));
                complaint.put("complaintDetails", rs.getString("complaintDetails"));
                complaint.put("complaintDoc", rs.getString("complaintDoc"));
                complaint.put("complaintStatus", rs.getString("complaintStatus"));
                complaint.put("registrationDate", rs.getString("registrationDate"));
            }
            rs.close();
            ps.close();

            if (complaint != null) {
                int studentUserId = (Integer) complaint.get("userId");
                
                // Fetch Student Profile
                String studentQuery = "SELECT firstName, middleName, lastName, email, contactNo FROM userregistration WHERE id = ?";
                ps = conn.prepareStatement(studentQuery);
                ps.setInt(1, studentUserId);
                rs = ps.executeQuery();
                if (rs.next()) {
                    student = new HashMap<>();
                    student.put("name", rs.getString("firstName") + " " + 
                                         (rs.getString("middleName") != null ? rs.getString("middleName") + " " : "") + 
                                         rs.getString("lastName"));
                    student.put("email", rs.getString("email"));
                    student.put("contactNo", rs.getString("contactNo"));
                }
                rs.close();
                ps.close();

                // Fetch History log
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
            response.sendRedirect(request.getContextPath() + "/admin/all-complaints");
            return;
        }

        request.setAttribute("complaint", complaint);
        request.setAttribute("student", student);
        request.setAttribute("history", history);
        request.getRequestDispatcher("/admin/complaint-details.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String cidStr = request.getParameter("cid");
        String cstatus = request.getParameter("cstatus");
        String remark = request.getParameter("remark");

        if (cidStr == null || cstatus == null || remark == null ||
            cidStr.trim().isEmpty() || cstatus.trim().isEmpty() || remark.trim().isEmpty()) {
            
            request.setAttribute("error", "Error: Status and Remark comments are required.");
            doGet(request, response);
            return;
        }

        int cid = 0;
        try {
            cid = Integer.parseInt(cidStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/all-complaints");
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;
        boolean updated = false;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Transactions to keep consistency

            // 1. Insert history remark
            String insertHistory = "INSERT INTO complainthistory (complaintid, compalintStatus, complaintRemark) VALUES (?, ?, ?)";
            ps = conn.prepareStatement(insertHistory);
            ps.setInt(1, cid);
            ps.setString(2, cstatus.trim());
            ps.setString(3, remark.trim());
            ps.executeUpdate();
            ps.close();

            // 2. Update status in complaints
            String updateComplaint = "UPDATE complaints SET complaintStatus = ? WHERE id = ?";
            ps = conn.prepareStatement(updateComplaint);
            ps.setString(1, cstatus.trim());
            ps.setInt(2, cid);
            ps.executeUpdate();
            
            conn.commit();
            updated = true;
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException rollbackEx) {}
            }
            e.printStackTrace();
            request.setAttribute("error", "Error: Database error: " + e.getMessage());
        } finally {
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }

        if (updated) {
            response.sendRedirect(request.getContextPath() + "/admin/complaint-details?cid=" + cid + "&success=Complaint+Updated+Successfully.");
        } else {
            doGet(request, response);
        }
    }
}
