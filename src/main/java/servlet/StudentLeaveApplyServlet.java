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
import java.sql.SQLException;

@WebServlet("/student/leave-apply")
public class StudentLeaveApplyServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null || !"user".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        request.getRequestDispatcher("/student/leave-apply.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null || !"user".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("user");
        String fromStr = request.getParameter("from_date");
        String toStr = request.getParameter("to_date");
        String reason = request.getParameter("reason");

        if (fromStr == null || toStr == null || reason == null || 
            fromStr.trim().isEmpty() || toStr.trim().isEmpty() || reason.trim().isEmpty()) {
            
            request.setAttribute("error", "Error: All fields are required.");
            request.getRequestDispatcher("/student/leave-apply.jsp").forward(request, response);
            return;
        }

        Date fromDate = null;
        Date toDate = null;

        try {
            fromDate = Date.valueOf(fromStr.trim());
            toDate = Date.valueOf(toStr.trim());
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Error: Invalid date format.");
            request.getRequestDispatcher("/student/leave-apply.jsp").forward(request, response);
            return;
        }

        if (fromDate.after(toDate)) {
            request.setAttribute("error", "Error: From Date cannot be greater than To Date.");
            request.getRequestDispatcher("/student/leave-apply.jsp").forward(request, response);
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;
        boolean success = false;

        try {
            conn = DBConnection.getConnection();
            String insertQuery = "INSERT INTO leave_applications (student_id, from_date, to_date, reason, status) " +
                                 "VALUES (?, ?, ?, ?, 'Pending')";
            ps = conn.prepareStatement(insertQuery);
            ps.setInt(1, userId);
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
            response.sendRedirect(request.getContextPath() + "/student/my-leaves?success=Leave+request+submitted+successfully!");
        } else {
            request.getRequestDispatcher("/student/leave-apply.jsp").forward(request, response);
        }
    }
}
