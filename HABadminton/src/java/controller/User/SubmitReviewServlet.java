package controller.User;

import dal.ReviewDAO;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.User;

@WebServlet(name = "SubmitReviewServlet", urlPatterns = {"/submitReview"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 50, maxRequestSize = 1024 * 1024 * 100)
public class SubmitReviewServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        String maDonHang = request.getParameter("maDonHang");
        String maSP = request.getParameter("maSP");
        String soSaoStr = request.getParameter("soSao");
        String noiDung = request.getParameter("noiDung");
        boolean anDanh = "1".equals(request.getParameter("anDanh"));
        
        if (maSP == null || maSP.trim().isEmpty()) {
            session.setAttribute("msgError", "Lỗi: Không tìm thấy mã sản phẩm!");
            response.sendRedirect("order-detail?id=" + maDonHang);
            return;
        }

        int soSao = 5;
        try { soSao = Integer.parseInt(soSaoStr); } catch (Exception e) { }

        String realPath = request.getServletContext().getRealPath("");
        String imagePath = uploadFile(request.getPart("imageFile"), realPath);
        String videoPath = uploadFile(request.getPart("videoFile"), realPath);

        ReviewDAO dao = new ReviewDAO();
        boolean isSuccess = dao.insertReview(maSP, user.getEmail(), soSao, noiDung, anDanh, imagePath, videoPath);

        if (isSuccess) {
            session.setAttribute("msgSuccess", "Cảm ơn bạn đã gửi đánh giá sản phẩm!");
        } else {
            session.setAttribute("msgError", "Có lỗi xảy ra, vui lòng thử lại sau.");
        }
        response.sendRedirect("order-detail?id=" + maDonHang);
    }

    // HÀM HỖ TRỢ LƯU FILE VÀO THƯ MỤC UPLOADS
    private String uploadFile(Part part, String realPath) throws IOException {
        if (part == null || part.getSize() == 0) return null;
        String fileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
        if (fileName.isEmpty()) return null;
        
        String uploadDir = realPath + File.separator + "uploads";
        File dir = new File(uploadDir);
        if (!dir.exists()) dir.mkdir();
        
        String newFileName = System.currentTimeMillis() + "_" + fileName;
        part.write(uploadDir + File.separator + newFileName);
        
        return "uploads/" + newFileName;
    }
}