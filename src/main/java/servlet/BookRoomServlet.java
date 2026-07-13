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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/student/book-room")
public class BookRoomServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null || !"user".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int studentId = (Integer) session.getAttribute("user");
        Student student = null;
        List<Map<String, Object>> rooms = new ArrayList<>();
        List<Map<String, Object>> courses = new ArrayList<>();
        List<Map<String, Object>> states = new ArrayList<>();

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();

            // 1. Fetch student info
            String studentQuery = "SELECT id, regNo, firstName, middleName, lastName, gender, contactNo, email FROM userregistration WHERE id = ?";
            ps = conn.prepareStatement(studentQuery);
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
            }
            rs.close();
            ps.close();

            // 2. Fetch rooms
            String roomsQuery = "SELECT id, room_no, seater, fees FROM rooms ORDER BY room_no ASC";
            ps = conn.prepareStatement(roomsQuery);
            rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> room = new HashMap<>();
                room.put("id", rs.getInt("id"));
                room.put("room_no", rs.getInt("room_no"));
                room.put("seater", rs.getInt("seater"));
                room.put("fees", rs.getInt("fees"));
                rooms.add(room);
            }
            rs.close();
            ps.close();

            // 3. Fetch courses
            String coursesQuery = "SELECT id, course_code, course_sn, course_fn FROM courses ORDER BY course_fn ASC";
            ps = conn.prepareStatement(coursesQuery);
            rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> course = new HashMap<>();
                course.put("id", rs.getInt("id"));
                course.put("course_code", rs.getString("course_code"));
                course.put("course_sn", rs.getString("course_sn"));
                course.put("course_fn", rs.getString("course_fn"));
                courses.add(course);
            }
            rs.close();
            ps.close();

            // 4. Fetch states
            String statesQuery = "SELECT id, State FROM states ORDER BY State ASC";
            ps = conn.prepareStatement(statesQuery);
            rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> state = new HashMap<>();
                state.put("id", rs.getInt("id"));
                state.put("State", rs.getString("State"));
                states.add(state);
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
            response.sendRedirect(request.getContextPath() + "/student/logout");
            return;
        }

        request.setAttribute("student", student);
        request.setAttribute("rooms", rooms);
        request.setAttribute("courses", courses);
        request.setAttribute("states", states);
        request.getRequestDispatcher("/student/book-room.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null || !"user".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Gather Room Info
        String roomnoStr = request.getParameter("room");
        String seaterStr = request.getParameter("seater");
        String feespmStr = request.getParameter("fpm");
        String foodstatusStr = request.getParameter("foodstatus");
        String stayfrom = request.getParameter("stayf");
        String durationStr = request.getParameter("duration");

        // Personal Info
        String course = request.getParameter("course");
        String regno = request.getParameter("regno");
        String fname = request.getParameter("fname");
        String mname = request.getParameter("mname");
        String lname = request.getParameter("lname");
        String gender = request.getParameter("gender");
        String contact = request.getParameter("contact");
        String email = request.getParameter("email");

        // Guardian/Emergency
        String econtact = request.getParameter("econtact");
        String gname = request.getParameter("gname");
        String grelation = request.getParameter("grelation");
        String gcontact = request.getParameter("gcontact");

        // Addresses
        String corresAddress = request.getParameter("address");
        String corresCIty = request.getParameter("city");
        String corresState = request.getParameter("state");
        String corresPincodeStr = request.getParameter("pincode");

        String pmntAddress = request.getParameter("paddress");
        String pmntCity = request.getParameter("pcity");
        String pmnatetState = request.getParameter("pstate");
        String pmntPincodeStr = request.getParameter("ppincode");

        // Validation
        if (roomnoStr == null || seaterStr == null || feespmStr == null || foodstatusStr == null ||
            stayfrom == null || durationStr == null || course == null || regno == null ||
            fname == null || lname == null || gender == null || contact == null || email == null ||
            econtact == null || gname == null || grelation == null || gcontact == null ||
            corresAddress == null || corresCIty == null || corresState == null || corresPincodeStr == null ||
            pmntAddress == null || pmntCity == null || pmnatetState == null || pmntPincodeStr == null ||
            roomnoStr.trim().isEmpty() || stayfrom.trim().isEmpty() || course.trim().isEmpty() ||
            regno.trim().isEmpty() || fname.trim().isEmpty() || lname.trim().isEmpty() ||
            gender.trim().isEmpty() || contact.trim().isEmpty() || email.trim().isEmpty() ||
            econtact.trim().isEmpty() || gname.trim().isEmpty() || grelation.trim().isEmpty() || gcontact.trim().isEmpty() ||
            corresAddress.trim().isEmpty() || corresCIty.trim().isEmpty() || corresState.trim().isEmpty() || corresPincodeStr.trim().isEmpty() ||
            pmntAddress.trim().isEmpty() || pmntCity.trim().isEmpty() || pmnatetState.trim().isEmpty() || pmntPincodeStr.trim().isEmpty()) {
            
            request.setAttribute("error", "Error: Please fill all mandatory fields.");
            doGet(request, response);
            return;
        }

        int roomno = 0;
        int seater = 0;
        int feespm = 0;
        int foodstatus = 0;
        int duration = 0;
        int corresPincode = 0;
        int pmntPincode = 0;

        try {
            roomno = Integer.parseInt(roomnoStr.trim());
            // Sanitize inputs to extract only digits for safety
            String seaterClean = seaterStr.replaceAll("[^0-9]", "").trim();
            seater = Integer.parseInt(seaterClean);
            String feespmClean = feespmStr.replaceAll("[^0-9]", "").trim();
            feespm = Integer.parseInt(feespmClean);
            foodstatus = Integer.parseInt(foodstatusStr.trim());
            duration = Integer.parseInt(durationStr.trim());
            corresPincode = Integer.parseInt(corresPincodeStr.trim());
            pmntPincode = Integer.parseInt(pmntPincodeStr.trim());
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Error: Numeric inputs, Seater, Fees, Duration, and Pincodes must be valid integers.");
            doGet(request, response);
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        boolean alreadyRegistered = false;

        try {
            conn = DBConnection.getConnection();

            // Duplicate registration checks (by RegNo or Email)
            String checkQuery = "SELECT id FROM registration WHERE regno = ? OR emailid = ? LIMIT 1";
            ps = conn.prepareStatement(checkQuery);
            ps.setString(1, regno.trim());
            ps.setString(2, email.trim());
            rs = ps.executeQuery();
            if (rs.next()) {
                alreadyRegistered = true;
            }
            rs.close();
            ps.close();

            if (alreadyRegistered) {
                request.setAttribute("error", "Error: Student already registered");
                doGet(request, response);
                return;
            }

            // Insert registration record
            String insertQuery = "INSERT INTO registration (" +
                    "roomno, seater, feespm, foodstatus, stayfrom, duration, course, regno, " +
                    "firstName, middleName, lastName, gender, contactno, emailid, " +
                    "egycontactno, guardianName, guardianRelation, guardianContactno, " +
                    "corresAddress, corresCIty, corresState, corresPincode, " +
                    "pmntAddress, pmntCity, pmnatetState, pmntPincode" +
                    ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            
            ps = conn.prepareStatement(insertQuery);
            ps.setInt(1, roomno);
            ps.setInt(2, seater);
            ps.setInt(3, feespm);
            ps.setInt(4, foodstatus);
            ps.setString(5, stayfrom.trim());
            ps.setInt(6, duration);
            ps.setString(7, course.trim());
            ps.setString(8, regno.trim());
            ps.setString(9, fname.trim());
            ps.setString(10, mname != null ? mname.trim() : "");
            ps.setString(11, lname.trim());
            ps.setString(12, gender.trim());
            ps.setString(13, contact.trim());
            ps.setString(14, email.trim());
            ps.setString(15, econtact.trim());
            ps.setString(16, gname.trim());
            ps.setString(17, grelation.trim());
            ps.setString(18, gcontact.trim());
            ps.setString(19, corresAddress.trim());
            ps.setString(20, corresCIty.trim());
            ps.setString(21, corresState.trim());
            ps.setInt(22, corresPincode);
            ps.setString(23, pmntAddress.trim());
            ps.setString(24, pmntCity.trim());
            ps.setString(25, pmnatetState.trim());
            ps.setInt(26, pmntPincode);

            int inserted = ps.executeUpdate();
            if (inserted > 0) {
                response.sendRedirect(request.getContextPath() + "/student/booking-details?success=Success:+Room+booked+successfully.");
                return;
            } else {
                request.setAttribute("error", "Error: Registration submission failed. Try again.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: Database error: " + e.getMessage());
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }

        doGet(request, response);
    }
}
