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

@WebServlet("/student/booking-details")
public class BookingDetailsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null || !"user".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String regNo = (String) session.getAttribute("regNo");
        String studentEmail = (String) session.getAttribute("studentEmail");

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Map<String, Object> booking = null;

        try {
            conn = DBConnection.getConnection();
            String selectQuery = "SELECT * FROM registration WHERE regno = ? OR emailid = ? LIMIT 1";
            ps = conn.prepareStatement(selectQuery);
            ps.setString(1, regNo);
            ps.setString(2, studentEmail);
            rs = ps.executeQuery();
            if (rs.next()) {
                booking = new HashMap<>();
                booking.put("id", rs.getInt("id"));
                booking.put("roomno", rs.getInt("roomno"));
                booking.put("seater", rs.getInt("seater"));
                booking.put("feespm", rs.getInt("feespm"));
                booking.put("foodstatus", rs.getInt("foodstatus"));
                booking.put("stayfrom", rs.getString("stayfrom"));
                booking.put("duration", rs.getInt("duration"));
                booking.put("course", rs.getString("course"));
                booking.put("regno", rs.getString("regno"));
                booking.put("firstName", rs.getString("firstName"));
                booking.put("middleName", rs.getString("middleName"));
                booking.put("lastName", rs.getString("lastName"));
                booking.put("gender", rs.getString("gender"));
                booking.put("contactno", rs.getString("contactno"));
                booking.put("emailid", rs.getString("emailid"));
                booking.put("egycontactno", rs.getString("egycontactno"));
                booking.put("guardianName", rs.getString("guardianName"));
                booking.put("guardianRelation", rs.getString("guardianRelation"));
                booking.put("guardianContactno", rs.getString("guardianContactno"));
                booking.put("corresAddress", rs.getString("corresAddress"));
                booking.put("corresCIty", rs.getString("corresCIty"));
                booking.put("corresState", rs.getString("corresState"));
                booking.put("corresPincode", rs.getInt("corresPincode"));
                booking.put("pmntAddress", rs.getString("pmntAddress"));
                booking.put("pmntCity", rs.getString("pmntCity"));
                booking.put("pmnatetState", rs.getString("pmnatetState"));
                booking.put("pmntPincode", rs.getInt("pmntPincode"));
                booking.put("postingDate", rs.getString("postingDate"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: Database error: " + e.getMessage());
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }

        if (booking != null) {
            int duration = (Integer) booking.get("duration");
            int feespm = (Integer) booking.get("feespm");
            int foodstatus = (Integer) booking.get("foodstatus");

            int hostelFee = duration * feespm;
            int foodFee = (foodstatus == 1) ? (duration * 2000) : 0;
            int totalFee = hostelFee + foodFee;

            request.setAttribute("booking", booking);
            request.setAttribute("hostelFee", hostelFee);
            request.setAttribute("foodFee", foodFee);
            request.setAttribute("totalFee", totalFee);
        }

        request.getRequestDispatcher("/student/booking-details.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
