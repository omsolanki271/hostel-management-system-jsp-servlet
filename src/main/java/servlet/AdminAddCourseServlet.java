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
import java.sql.SQLException;

@WebServlet("/admin/add-course")
public class AdminAddCourseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        request.getRequestDispatcher("/admin/add-courses.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String coursecode = request.getParameter("cc");
        String shortname = request.getParameter("cns");
        String fullname = request.getParameter("cnf");

        if (coursecode == null || shortname == null || fullname == null ||
            coursecode.trim().isEmpty() || shortname.trim().isEmpty() || fullname.trim().isEmpty()) {
            
            request.setAttribute("error", "Error: Please fill all fields!");
            doGet(request, response);
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;
        boolean added = false;

        try {
            conn = DBConnection.getConnection();
            String query = "INSERT INTO courses (course_code, course_sn, course_fn) VALUES (?, ?, ?)";
            ps = conn.prepareStatement(query);
            ps.setString(1, coursecode.trim());
            ps.setString(2, shortname.trim());
            ps.setString(3, fullname.trim());
            
            int result = ps.executeUpdate();
            if (result > 0) {
                added = true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: Database error: " + e.getMessage());
        } finally {
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }

        if (added) {
            request.setAttribute("success", "Success: Course added successfully!");
        } else {
            if (request.getAttribute("error") == null) {
                request.setAttribute("error", "Error: Failed to add course.");
            }
        }

        doGet(request, response);
    }
}
