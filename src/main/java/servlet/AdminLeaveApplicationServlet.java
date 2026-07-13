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
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/leave-application")
public class AdminLeaveApplicationServlet extends HttpServlet {
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
        List<Map<String, Object>> students = new ArrayList<>();

        try {
            conn = DBConnection.getConnection();
            String query = "SELECT id, firstName, lastName, regNo FROM userregistration ORDER BY firstName ASC";
            ps = conn.prepareStatement(query);
            rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> student = new HashMap<>();
                student.put("id", rs.getInt("id"));
                student.put("firstName", rs.getString("firstName"));
                student.put("lastName", rs.getString("lastName"));
                student.put("regno", rs.getString("regNo"));
                students.add(student);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: Database error: " + e.getMessage());
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }

        request.setAttribute("students", students);
        request.getRequestDispatcher("/admin/leave-application.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String studentIdStr = request.getParameter("student_id");
        String fromStr = request.getParameter("from_date");
        String toStr = request.getParameter("to_date");
        String reason = request.getParameter("reason");

        if (studentIdStr == null || fromStr == null || toStr == null || reason == null || 
            studentIdStr.trim().isEmpty() || fromStr.trim().isEmpty() || toStr.trim().isEmpty() || reason.trim().isEmpty()) {
            
            request.setAttribute("error", "Error: All fields are required.");
            doGet(request, response);
            return;
        }

        int studentId = 0;
        Date fromDate = null;
        Date toDate = null;

        try {
            studentId = Integer.parseInt(studentIdStr.trim());
            fromDate = Date.valueOf(fromStr.trim());
            toDate = Date.valueOf(toStr.trim());
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Error: Invalid input or date format.");
            doGet(request, response);
            return;
        }

        if (fromDate.after(toDate)) {
            request.setAttribute("error", "Error: From Date cannot be greater than To Date.");
            doGet(request, response);
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;
        boolean success = false;

        try {
            conn = DBConnection.getConnection();
            String query = "INSERT INTO leave_applications (student_id, from_date, to_date, reason, status, remarks) " +
                           "VALUES (?, ?, ?, ?, 'Pending', 'Created by Admin')";
            ps = conn.prepareStatement(query);
            ps.setInt(1, studentId);
            ps.setDate(2, fromDate);
            ps.setDate(3, toDate);
            ps.setString(4, reason.trim());

            success = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: Database error: " + e.getMessage());
        } finally {
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }

        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-leaves?success=Leave+application+added+successfully!");
        } else {
            doGet(request, response);
        }
    }
}
