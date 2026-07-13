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

@WebServlet("/student/login")
public class StudentLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String usernameOrEmailOrReg = request.getParameter("username");
        String password = request.getParameter("password");

        if (usernameOrEmailOrReg == null || password == null || 
            usernameOrEmailOrReg.trim().isEmpty() || password.isEmpty()) {
            
            request.setAttribute("error", "Error: Username (Email/RegNo) and Password are required.");
            request.getRequestDispatcher("/student/login.jsp").forward(request, response);
            return;
        }

        Student student = null;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            String query = "SELECT * FROM userregistration WHERE (email = ? OR regNo = ?) AND password = ?";
            ps = conn.prepareStatement(query);
            ps.setString(1, usernameOrEmailOrReg.trim());
            ps.setString(2, usernameOrEmailOrReg.trim());
            ps.setString(3, password);
            
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

        if (student != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", student.getId());
            session.setAttribute("role", "user");
            session.setAttribute("studentName", student.getFirstName() + " " + student.getLastName());
            session.setAttribute("regNo", student.getRegNo());
            session.setAttribute("studentEmail", student.getEmail());

            response.sendRedirect(request.getContextPath() + "/student/dashboard.jsp");
        } else {
            request.setAttribute("error", "Error: Invalid login credentials. Please try again.");
            request.getRequestDispatcher("/student/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/student/login.jsp");
    }
}
