package controller.User;

import dal.UserDAO;
import model.User;
import java.io.IOException;
import java.io.File;
import java.nio.file.Paths;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

// BẮT BUỘC CÓ: Khai báo để Servlet hiểu được form multipart/form-data (Cho phép up file)
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // Kích thước nạp bộ nhớ: 2MB
    maxFileSize = 1024 * 1024 * 10,      // Kích thước file tối đa: 10MB
    maxRequestSize = 1024 * 1024 * 50    // Tổng request: 50MB
)
@WebServlet(name = "UpdateProfileServlet", urlPatterns = {"/UpdateProfileServlet"})
public class UpdateProfileServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Đảm bảo tiếng Việt không bị lỗi font
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 1. LẤY DỮ LIỆU TEXT TỪ FORM (Bây giờ đã đọc được bình thường)
        String ho = request.getParameter("ho");
        String ten = request.getParameter("ten");
        String hoTen = (ho != null ? ho.trim() : "") + " " + (ten != null ? ten.trim() : "");
        
        String sdt = request.getParameter("sdt");
        String diaChi = request.getParameter("diaChi");
        String quanHuyen = request.getParameter("quanHuyen");
        String tinhThanh = request.getParameter("tinhThanh");
        
        // 2. XỬ LÝ LƯU FILE ẢNH ĐẠI DIỆN VÀO THƯ MỤC DỰ ÁN
        String avatarPath = currentUser.getAvatar(); // Mặc định giữ nguyên ảnh cũ nếu không đổi
        try {
            Part part = request.getPart("avatarFile");
            if (part != null && part.getSize() > 0) {
                // Lấy đường dẫn thực tế của dự án trên ổ cứng
                String realPath = request.getServletContext().getRealPath("/uploads");
                File uploadDir = new File(realPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdir(); // Tự động tạo thư mục uploads nếu chưa có
                }
                
                // Tránh lỗi tên file tiếng Việt hoặc trùng tên
                String fileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                String finalFileName = System.currentTimeMillis() + "_" + fileName; 
                
                // Lưu file vào ổ cứng
                part.write(realPath + File.separator + finalFileName);
                
                // Đường dẫn để lưu vào Database
                avatarPath = "uploads/" + finalFileName;
            }
        } catch (Exception e) {
            System.out.println("Lỗi lưu ảnh đại diện: " + e.getMessage());
        }

        // 3. CẬP NHẬT THÔNG TIN VÀO OBJECT
        currentUser.setHoTen(hoTen.trim());
        currentUser.setSdt(sdt);
        currentUser.setDiaChi(diaChi);
        currentUser.setQuanHuyen(quanHuyen);
        currentUser.setTinhThanh(tinhThanh);
        currentUser.setAvatar(avatarPath); // Cập nhật đường dẫn ảnh mới

        // 4. LƯU XUỐNG DATABASE
        UserDAO dao = new UserDAO();
        dao.updateProfile(currentUser);

        // 5. CẬP NHẬT LẠI SESSION VÀ CHUYỂN HƯỚNG
        session.setAttribute("user", currentUser); // Cực kỳ quan trọng để giao diện ăn theo data mới
        session.setAttribute("msgSuccess", "Cập nhật hồ sơ thành công!");
        
        response.sendRedirect("profile.jsp");
    }
}