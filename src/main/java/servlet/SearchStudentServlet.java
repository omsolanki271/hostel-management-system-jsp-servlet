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

@WebServlet("/admin/search-student")
public class SearchStudentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String searchVal = request.getParameter("searchQuery");
        List<Map<String, Object>> students = new ArrayList<>();

        if (searchVal != null && !searchVal.trim().isEmpty()) {
            searchVal = searchVal.trim();
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            try {
                conn = DBConnection.getConnection();
                String searchQuery = "SELECT id, regno, firstName, middleName, lastName, contactno, roomno, seater, stayfrom " +
                        "FROM registration WHERE regno LIKE ? OR firstName LIKE ? OR lastName LIKE ? OR emailid LIKE ?";
                ps = conn.prepareStatement(searchQuery);
                String match = "%" + searchVal + "%";
                ps.setString(1, match);
                ps.setString(2, match);
                ps.setString(3, match);
                ps.setString(4, match);

                rs = ps.executeQuery();
                while (rs.next()) {
                    Map<String, Object> student = new HashMap<>();
                    student.put("id", rs.getInt("id"));
                    student.put("regno", rs.getString("regno"));
                    student.put("name", rs.getString("firstName") + " " + 
                                         (rs.getString("middleName") != null ? rs.getString("middleName") + " " : "") + 
                                         rs.getString("lastName"));
                    student.put("contactno", rs.getString("contactno"));
                    student.put("roomno", rs.getInt("roomno"));
                    student.put("seater", rs.getInt("seater"));
                    student.put("stayfrom", rs.getString("stayfrom"));
                    students.add(student);
                }
            } catch (SQLException e) {
                e.printStackTrace();
                request.setAttribute("error", "Error: Database error: " + e.getMessage());
            } finally {
                try { if (rs != null) rs.close(); } catch (SQLException e) {}
                try { if (ps != null) ps.close(); } catch (SQLException e) {}
                try { if (conn != null) conn.close(); } catch (SQLException e) {}
            }
            request.setAttribute("searched", true);
        }

        request.setAttribute("students", students);
        request.getRequestDispatcher("/admin/search-student.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
