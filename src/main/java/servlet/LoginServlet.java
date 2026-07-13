package servlet;

import model.Admin;
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

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String role = request.getParameter("role");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (role == null || username == null || password == null ||
            role.isEmpty() || username.trim().isEmpty() || password.isEmpty()) {
            request.setAttribute("error", "Error: Role, Username, and Password are required.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();

            if ("admin".equals(role)) {
                String query = "SELECT * FROM admin WHERE (username = ? OR email = ?) AND password = ?";
                ps = conn.prepareStatement(query);
                ps.setString(1, username.trim());
                ps.setString(2, username.trim());
                ps.setString(3, password);
                rs = ps.executeQuery();
                if (rs.next()) {
                    HttpSession session = request.getSession();
                    session.setAttribute("admin", rs.getInt("id"));
                    session.setAttribute("role", "admin");
                    session.setAttribute("adminName", rs.getString("username"));
                    session.setAttribute("adminEmail", rs.getString("email"));

                    response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
                    return;
                }
            } else if ("user".equals(role)) {
                String query = "SELECT * FROM userregistration WHERE (email = ? OR regNo = ?) AND password = ?";
                ps = conn.prepareStatement(query);
                ps.setString(1, username.trim());
                ps.setString(2, username.trim());
                ps.setString(3, password);
                rs = ps.executeQuery();
                if (rs.next()) {
                    HttpSession session = request.getSession();
                    session.setAttribute("user", rs.getInt("id"));
                    session.setAttribute("role", "user");
                    session.setAttribute("studentName", rs.getString("firstName") + " " + rs.getString("lastName"));
                    session.setAttribute("regNo", rs.getString("regNo"));
                    session.setAttribute("studentEmail", rs.getString("email"));

                    response.sendRedirect(request.getContextPath() + "/student/dashboard.jsp");
                    return;
                }
            }

            // If we are here, authentication failed
            request.setAttribute("error", "Error: Invalid credentials. Please try again.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: Database error: " + e.getMessage());
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}
