package servlet;

import util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/student/register")
public class StudentRegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String regNo = request.getParameter("regno");
        String firstName = request.getParameter("fname");
        String middleName = request.getParameter("mname");
        String lastName = request.getParameter("lname");
        String gender = request.getParameter("gender");
        String contactStr = request.getParameter("contact");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String cpassword = request.getParameter("cpassword");

        // Basic Validations
        if (regNo == null || firstName == null || lastName == null || gender == null || 
            contactStr == null || email == null || password == null || cpassword == null ||
            regNo.trim().isEmpty() || firstName.trim().isEmpty() || lastName.trim().isEmpty() ||
            contactStr.trim().isEmpty() || email.trim().isEmpty() || password.isEmpty()) {
            
            request.setAttribute("error", "Error: All fields marked with * are required.");
            request.getRequestDispatcher("/student/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(cpassword)) {
            request.setAttribute("error", "Error: Password and Confirm Password do not match.");
            request.getRequestDispatcher("/student/register.jsp").forward(request, response);
            return;
        }

        long contact = 0;
        try {
            contact = Long.parseLong(contactStr.trim());
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Error: Invalid Contact Number.");
            request.getRequestDispatcher("/student/register.jsp").forward(request, response);
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        boolean regNoExists = false;
        boolean emailExists = false;

        try {
            conn = DBConnection.getConnection();
            
            // Check RegNo
            String checkRegQuery = "SELECT COUNT(*) FROM userregistration WHERE regNo = ?";
            ps = conn.prepareStatement(checkRegQuery);
            ps.setString(1, regNo.trim());
            rs = ps.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                regNoExists = true;
            }
            rs.close();
            ps.close();

            // Check Email
            String checkEmailQuery = "SELECT COUNT(*) FROM userregistration WHERE email = ?";
            ps = conn.prepareStatement(checkEmailQuery);
            ps.setString(1, email.trim());
            rs = ps.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                emailExists = true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
        }

        if (regNoExists) {
            request.setAttribute("error", "Error: Registration Number already exists.");
            request.getRequestDispatcher("/student/register.jsp").forward(request, response);
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
            return;
        }

        if (emailExists) {
            request.setAttribute("error", "Error: Email already registered.");
            request.getRequestDispatcher("/student/register.jsp").forward(request, response);
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
            return;
        }

        boolean registered = false;
        try {
            String insertQuery = "INSERT INTO userregistration (regNo, firstName, middleName, lastName, gender, contactNo, email, password) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(insertQuery);
            ps.setString(1, regNo.trim());
            ps.setString(2, firstName.trim());
            ps.setString(3, middleName != null ? middleName.trim() : "");
            ps.setString(4, lastName.trim());
            ps.setString(5, gender.trim());
            ps.setLong(6, contact);
            ps.setString(7, email.trim());
            ps.setString(8, password); // plain text
            
            registered = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }

        if (registered) {
            response.sendRedirect(request.getContextPath() + "/student/login.jsp?registered=1");
        } else {
            request.setAttribute("error", "Error: Registration failed. Something went wrong. Try again.");
            request.getRequestDispatcher("/student/register.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/student/register.jsp");
    }
}
