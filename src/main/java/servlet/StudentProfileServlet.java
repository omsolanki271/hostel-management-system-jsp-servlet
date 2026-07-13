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

@WebServlet("/student/profile")
public class StudentProfileServlet extends HttpServlet {
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
        request.getRequestDispatcher("/student/profile.jsp").forward(request, response);
    }
}
