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
import java.util.HashMap;
import java.util.Map;

@WebServlet("/admin/edit-course")
public class AdminEditCourseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-courses");
            return;
        }

        int id = 0;
        try {
            id = Integer.parseInt(idStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-courses");
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Map<String, Object> course = null;

        try {
            conn = DBConnection.getConnection();
            String query = "SELECT id, course_code, course_sn, course_fn FROM courses WHERE id = ? LIMIT 1";
            ps = conn.prepareStatement(query);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                course = new HashMap<>();
                course.put("id", rs.getInt("id"));
                course.put("course_code", rs.getString("course_code"));
                course.put("course_sn", rs.getString("course_sn"));
                course.put("course_fn", rs.getString("course_fn"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: Database error: " + e.getMessage());
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }

        if (course == null) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-courses");
            return;
        }

        request.setAttribute("course", course);
        request.getRequestDispatcher("/admin/edit-course.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String idStr = request.getParameter("id");
        String code = request.getParameter("cc");
        String shortname = request.getParameter("cns");
        String fullname = request.getParameter("cnf");

        if (idStr == null || code == null || shortname == null || fullname == null ||
            idStr.trim().isEmpty() || code.trim().isEmpty() || shortname.trim().isEmpty() || fullname.trim().isEmpty()) {
            
            request.setAttribute("error", "Error: Please fill all fields!");
            doGet(request, response);
            return;
        }

        int id = 0;
        try {
            id = Integer.parseInt(idStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-courses");
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;
        boolean updated = false;

        try {
            conn = DBConnection.getConnection();
            String query = "UPDATE courses SET course_code = ?, course_sn = ?, course_fn = ? WHERE id = ?";
            ps = conn.prepareStatement(query);
            ps.setString(1, code.trim());
            ps.setString(2, shortname.trim());
            ps.setString(3, fullname.trim());
            ps.setInt(4, id);
            
            int result = ps.executeUpdate();
            if (result > 0) {
                updated = true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: Database error: " + e.getMessage());
        } finally {
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }

        if (updated) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-courses?success=Course+updated+successfully!");
        } else {
            if (request.getAttribute("error") == null) {
                request.setAttribute("error", "Error: Failed to update course.");
            }
            doGet(request, response);
        }
    }
}
