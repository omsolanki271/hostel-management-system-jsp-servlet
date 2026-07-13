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

@WebServlet("/student/change-password")
public class ChangePasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null || !"user".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/student/login.jsp");
            return;
        }

        int studentId = (Integer) session.getAttribute("user");
        String oldPassword = request.getParameter("oldpassword");
        String newPassword = request.getParameter("newpassword");
        String confirmPassword = request.getParameter("cpassword");

        if (oldPassword == null || newPassword == null || confirmPassword == null ||
            oldPassword.isEmpty() || newPassword.isEmpty() || confirmPassword.isEmpty()) {
            
            request.setAttribute("error", "Error: All fields are required.");
            request.getRequestDispatcher("/student/change-password.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Error: New password and Confirm password do not match.");
            request.getRequestDispatcher("/student/change-password.jsp").forward(request, response);
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String currentDbPassword = null;

        try {
            conn = DBConnection.getConnection();
            String selectQuery = "SELECT password FROM userregistration WHERE id = ?";
            ps = conn.prepareStatement(selectQuery);
            ps.setInt(1, studentId);
            rs = ps.executeQuery();
            if (rs.next()) {
                currentDbPassword = rs.getString("password");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
        }

        if (currentDbPassword == null) {
            request.setAttribute("error", "Error: Account not found.");
            request.getRequestDispatcher("/student/change-password.jsp").forward(request, response);
            return;
        }

        // Validate current password (plain text match)
        if (!currentDbPassword.equals(oldPassword)) {
            request.setAttribute("error", "Error: Current password is incorrect.");
            request.getRequestDispatcher("/student/change-password.jsp").forward(request, response);
            return;
        }

        boolean changed = false;
        try {
            String updateQuery = "UPDATE userregistration SET password = ? WHERE id = ?";
            ps = conn.prepareStatement(updateQuery);
            ps.setString(1, newPassword);
            ps.setInt(2, studentId);
            
            changed = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }

        if (changed) {
            request.setAttribute("success", "Success: Password updated successfully.");
            request.getRequestDispatcher("/student/change-password.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Error: Password update failed. Try again.");
            request.getRequestDispatcher("/student/change-password.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/student/change-password.jsp");
    }
}
