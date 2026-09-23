package controller.User;

import dal.SanPhamDAO;
import dal.ReviewDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.SanPham;
import model.Review;

@WebServlet(name = "DetailServlet", urlPatterns = {"/detail"})
public class DetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String id = request.getParameter("id");
        SanPhamDAO dao = new SanPhamDAO();
        
        SanPham p = dao.getProductById(id);
        
        if (p == null) {
            response.sendRedirect("category?id=1"); 
            return;
        }

        List<SanPham> relatedList = dao.getRelatedProducts(p.getMaDM(), p.getMaSP());

        request.setAttribute("detail", p);
        request.setAttribute("relatedProducts", relatedList);
        
        if (p.getGiaGoc() > p.getGiaBan()) {
            double discount = ((p.getGiaGoc() - p.getGiaBan()) / p.getGiaGoc()) * 100;
            request.setAttribute("discountPercent", Math.round(discount));
        }
        
        ReviewDAO reviewDAO = new ReviewDAO();
        List<Review> listReview = reviewDAO.getReviewsByProduct(id);
        
        int tongSoDanhGia = listReview.size();
        int sao5 = 0, sao4 = 0, sao3 = 0, sao2 = 0, sao1 = 0;
        double sumSao = 0;
        
        for (Review r : listReview) {
            sumSao += r.getSoSao();
            switch (r.getSoSao()) {
                case 5: sao5++; break;
                case 4: sao4++; break;
                case 3: sao3++; break;
                case 2: sao2++; break;
                case 1: sao1++; break;
            }
        }
        
        double diemTrungBinh = 0.0;
        if (tongSoDanhGia > 0) {
            diemTrungBinh = Math.round((sumSao / tongSoDanhGia) * 10.0) / 10.0;
        }

        request.setAttribute("listReview", listReview);
        request.setAttribute("tongSoDanhGia", tongSoDanhGia);
        request.setAttribute("sao5", sao5);
        request.setAttribute("sao4", sao4);
        request.setAttribute("sao3", sao3);
        request.setAttribute("sao2", sao2);
        request.setAttribute("sao1", sao1);
        request.setAttribute("diemTrungBinh", diemTrungBinh);
        
        request.getRequestDispatcher("detail.jsp").forward(request, response);
    }
}