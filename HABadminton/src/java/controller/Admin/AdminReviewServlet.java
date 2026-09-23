package controller.Admin;

import dal.ReviewDAO;
import model.Review;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminReviewServlet", urlPatterns = {"/admin-reviews"})
public class AdminReviewServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Nhận tham số tìm kiếm và bộ lọc
        String keyword = request.getParameter("keyword");
        String starParam = request.getParameter("star");
        String statusParam = request.getParameter("status");
        
        ReviewDAO rDao = new ReviewDAO();
        // Lấy danh sách kết hợp từ khóa tìm kiếm
        List<Review> listReviews = rDao.getAllReviewsForAdmin(keyword, starParam, statusParam); 
        
        request.setAttribute("listReviews", listReviews);
        request.getRequestDispatcher("admin/admin-reviews.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String idStr = request.getParameter("id");
        ReviewDAO rDao = new ReviewDAO();
        
        try {
            int reviewId = Integer.parseInt(idStr);
            
            if ("reply".equals(action)) {
                String text = request.getParameter("text");
                boolean check = rDao.updateAdminReply(reviewId, text);
                if (check) response.getWriter().print("success");
                else response.getWriter().print("fail");
                
            } else if ("toggle".equals(action)) {
                // Nhận trạng thái mới của con mắt
                int newStatus = Integer.parseInt(request.getParameter("status"));
                boolean check = rDao.updateVisibility(reviewId, newStatus);
                if (check) response.getWriter().print("success");
                else response.getWriter().print("fail");

            } else if ("delete".equals(action)) {
                boolean check = rDao.deleteReview(reviewId);
                if (check) response.getWriter().print("success");
                else response.getWriter().print("fail");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().print("error");
        }
    }
}