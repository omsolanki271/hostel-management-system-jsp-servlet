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

@WebServlet("/admin/student-details")
public class StudentDetailsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String regNo = request.getParameter("regno");
        if (regNo == null || regNo.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-students");
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Map<String, Object> student = null;

        try {
            conn = DBConnection.getConnection();
            String selectQuery = "SELECT * FROM registration WHERE regno = ? LIMIT 1";
            ps = conn.prepareStatement(selectQuery);
            ps.setString(1, regNo.trim());
            rs = ps.executeQuery();
            if (rs.next()) {
                student = new HashMap<>();
                student.put("id", rs.getInt("id"));
                student.put("roomno", rs.getInt("roomno"));
                student.put("seater", rs.getInt("seater"));
                student.put("feespm", rs.getInt("feespm"));
                student.put("foodstatus", rs.getInt("foodstatus"));
                student.put("stayfrom", rs.getString("stayfrom"));
                student.put("duration", rs.getInt("duration"));
                student.put("course", rs.getString("course"));
                student.put("regno", rs.getString("regno"));
                student.put("firstName", rs.getString("firstName"));
                student.put("middleName", rs.getString("middleName"));
                student.put("lastName", rs.getString("lastName"));
                student.put("gender", rs.getString("gender"));
                student.put("contactno", rs.getString("contactno"));
                student.put("emailid", rs.getString("emailid"));
                student.put("egycontactno", rs.getString("egycontactno"));
                student.put("guardianName", rs.getString("guardianName"));
                student.put("guardianRelation", rs.getString("guardianRelation"));
                student.put("guardianContactno", rs.getString("guardianContactno"));
                student.put("corresAddress", rs.getString("corresAddress"));
                student.put("corresCIty", rs.getString("corresCIty"));
                student.put("corresState", rs.getString("corresState"));
                student.put("corresPincode", rs.getInt("corresPincode"));
                student.put("pmntAddress", rs.getString("pmntAddress"));
                student.put("pmntCity", rs.getString("pmntCity"));
                student.put("pmnatetState", rs.getString("pmnatetState"));
                student.put("pmntPincode", rs.getInt("pmntPincode"));
                student.put("postingDate", rs.getString("postingDate"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: Database error: " + e.getMessage());
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }

        if (student == null) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-students");
            return;
        }

        int duration = (Integer) student.get("duration");
        int feespm = (Integer) student.get("feespm");
        int foodstatus = (Integer) student.get("foodstatus");

        int hostelFee = duration * feespm;
        int foodFee = (foodstatus == 1) ? (duration * 2000) : 0;
        int totalFee = hostelFee + foodFee;

        request.setAttribute("student", student);
        request.setAttribute("hostelFee", hostelFee);
        request.setAttribute("foodFee", foodFee);
        request.setAttribute("totalFee", totalFee);

        request.getRequestDispatcher("/admin/student-details.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
