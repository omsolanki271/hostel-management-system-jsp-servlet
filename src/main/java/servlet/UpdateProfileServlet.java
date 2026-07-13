package servlet;

import model.Student;
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
import java.sql.Timestamp;

@WebServlet("/student/update-profile")
public class UpdateProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null || !"user".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/student/login.jsp");
            return;
        }

        int studentId = (Integer) session.getAttribute("user");
        Student student = null;

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            String query = "SELECT * FROM userregistration WHERE id = ?";
            ps = conn.prepareStatement(query);
            ps.setInt(1, studentId);
            rs = ps.executeQuery();
            if (rs.next()) {
                student = new Student();
                student.setId(rs.getInt("id"));
                student.setRegNo(rs.getString("regNo"));
                student.setFirstName(rs.getString("firstName"));
                student.setMiddleName(rs.getString("middleName"));
                student.setLastName(rs.getString("lastName"));
                student.setGender(rs.getString("gender"));
                student.setContactNo(rs.getLong("contactNo"));
                student.setEmail(rs.getString("email"));
                student.setPassword(rs.getString("password"));
                student.setRegDate(rs.getTimestamp("regDate"));
                student.setUpdationDate(rs.getString("updationDate"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }

        if (student == null) {
            response.sendRedirect(request.getContextPath() + "/student/logout");
            return;
        }

        request.setAttribute("student", student);
        request.getRequestDispatcher("/student/edit-profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null || !"user".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/student/login.jsp");
            return;
        }

        int studentId = (Integer) session.getAttribute("user");
        String firstName = request.getParameter("fname");
        String middleName = request.getParameter("mname");
        String lastName = request.getParameter("lname");
        String gender = request.getParameter("gender");
        String contactStr = request.getParameter("contact");

        if (firstName == null || lastName == null || gender == null || contactStr == null ||
            firstName.trim().isEmpty() || lastName.trim().isEmpty() || contactStr.trim().isEmpty()) {
            
            request.setAttribute("error", "Error: All fields marked with * are required.");
            // Re-fetch current student data to show on validation failure
            doGet(request, response);
            return;
        }

        long contact = 0;
        try {
            contact = Long.parseLong(contactStr.trim());
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Error: Invalid Contact Number.");
            doGet(request, response);
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;
        boolean updated = false;

        try {
            conn = DBConnection.getConnection();
            String query = "UPDATE userregistration SET firstName = ?, middleName = ?, lastName = ?, gender = ?, contactNo = ?, updationDate = ? WHERE id = ?";
            ps = conn.prepareStatement(query);
            ps.setString(1, firstName.trim());
            ps.setString(2, middleName != null ? middleName.trim() : "");
            ps.setString(3, lastName.trim());
            ps.setString(4, gender.trim());
            ps.setLong(5, contact);
            
            Timestamp now = new Timestamp(System.currentTimeMillis());
            ps.setString(6, now.toString());
            ps.setInt(7, studentId);
            
            updated = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }

        if (updated) {
            session.setAttribute("studentName", firstName.trim() + " " + lastName.trim());
            response.sendRedirect(request.getContextPath() + "/student/profile?success=1");
        } else {
            request.setAttribute("error", "Error: Profile update failed. Try again.");
            doGet(request, response);
        }
    }
}
