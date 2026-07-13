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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/manage-courses")
public class AdminManageCoursesServlet extends HttpServlet {
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

        // Handle delete operation if requested
        String delIdStr = request.getParameter("del");
        if (delIdStr != null && !delIdStr.trim().isEmpty()) {
            int delId = 0;
            try {
                delId = Integer.parseInt(delIdStr.trim());
            } catch (NumberFormatException e) {
                // invalid id
            }

            if (delId > 0) {
                try {
                    conn = DBConnection.getConnection();
                    String deleteQuery = "DELETE FROM courses WHERE id = ?";
                    ps = conn.prepareStatement(deleteQuery);
                    ps.setInt(1, delId);
                    ps.executeUpdate();
                    
                    response.sendRedirect(request.getContextPath() + "/admin/manage-courses?success=Course+deleted+successfully!");
                    return;
                } catch (SQLException e) {
                    e.printStackTrace();
                    request.setAttribute("error", "Error: Database delete failed: " + e.getMessage());
                } finally {
                    try { if (ps != null) ps.close(); } catch (SQLException e) {}
                    try { if (conn != null) conn.close(); } catch (SQLException e) {}
                }
            }
        }

        // Fetch courses list
        List<Map<String, Object>> courses = new ArrayList<>();
        try {
            conn = DBConnection.getConnection();
            String selectQuery = "SELECT id, course_code, course_sn, course_fn, posting_date FROM courses ORDER BY id DESC";
            ps = conn.prepareStatement(selectQuery);
            rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> course = new HashMap<>();
                course.put("id", rs.getInt("id"));
                course.put("course_code", rs.getString("course_code"));
                course.put("course_sn", rs.getString("course_sn"));
                course.put("course_fn", rs.getString("course_fn"));
                course.put("posting_date", rs.getString("posting_date"));
                courses.add(course);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: Database error: " + e.getMessage());
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }

        request.setAttribute("courses", courses);
        request.getRequestDispatcher("/admin/manage-courses.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
