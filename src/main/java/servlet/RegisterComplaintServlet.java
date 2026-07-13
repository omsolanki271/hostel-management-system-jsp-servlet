package servlet;

import util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Random;
import java.util.UUID;

@WebServlet("/student/register-complaint")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,      // 1 MB
        maxFileSize = 1024 * 1024 * 5,         // 5 MB
        maxRequestSize = 1024 * 1024 * 5 * 5   // 25 MB
)
public class RegisterComplaintServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null || !"user".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        request.getRequestDispatcher("/student/register-complaint.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null || !"user".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("user");
        String ctype = request.getParameter("ctype");
        String cdetails = request.getParameter("cdetails");

        if (ctype == null || cdetails == null || ctype.trim().isEmpty() || cdetails.trim().isEmpty()) {
            request.setAttribute("error", "Error: Complaint type and explanation details are required.");
            request.getRequestDispatcher("/student/register-complaint.jsp").forward(request, response);
            return;
        }

        // Generate 9 digit complaint number
        int cnumber = 100000000 + new Random().nextInt(900000000);
        String fileName = "";

        // File upload process
        try {
            Part filePart = request.getPart("cfile");
            if (filePart != null && filePart.getSize() > 0) {
                String submittedFileName = filePart.getSubmittedFileName();
                if (submittedFileName != null && !submittedFileName.trim().isEmpty()) {
                    String ext = "";
                    int lastDot = submittedFileName.lastIndexOf('.');
                    if (lastDot >= 0) {
                        ext = submittedFileName.substring(lastDot).toLowerCase();
                    }

                    // Validate extension
                    if (ext.equals(".jpg") || ext.equals(".jpeg") || ext.equals(".png") || ext.equals(".gif") || ext.equals(".pdf")) {
                        fileName = UUID.randomUUID().toString() + ext;
                        
                        String uploadPath = request.getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "complaints";
                        File uploadDir = new File(uploadPath);
                        if (!uploadDir.exists()) {
                            uploadDir.mkdirs();
                        }
                        
                        filePart.write(uploadPath + File.separator + fileName);
                    } else {
                        request.setAttribute("error", "Error: Only JPG, JPEG, PNG, GIF, and PDF file types are allowed.");
                        request.getRequestDispatcher("/student/register-complaint.jsp").forward(request, response);
                        return;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error processing file upload: " + e.getMessage());
            request.getRequestDispatcher("/student/register-complaint.jsp").forward(request, response);
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;
        boolean success = false;

        try {
            conn = DBConnection.getConnection();
            String insertQuery = "INSERT INTO complaints (ComplainNumber, userId, complaintType, complaintDetails, complaintDoc) " +
                                 "VALUES (?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(insertQuery);
            ps.setInt(1, cnumber);
            ps.setInt(2, userId);
            ps.setString(3, ctype.trim());
            ps.setString(4, cdetails.trim());
            ps.setString(5, fileName);

            success = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: Database error: " + e.getMessage());
        } finally {
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }

        if (success) {
            response.sendRedirect(request.getContextPath() + "/student/my-complaints?success=Complaint+Registered+Successfully.+Complaint+No:+" + cnumber);
        } else {
            request.getRequestDispatcher("/student/register-complaint.jsp").forward(request, response);
        }
    }
}
