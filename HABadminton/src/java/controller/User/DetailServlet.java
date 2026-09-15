package controller.User;

import dal.SanPhamDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.SanPham;

@WebServlet(name = "DetailServlet", urlPatterns = {"/detail"})
public class DetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String id = request.getParameter("id");
        SanPhamDAO dao = new SanPhamDAO();
        
        SanPham p = dao.getProductById(id);
        
        // Nếu nhập bậy ID không có thật -> đá về trang danh mục
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
        
        request.getRequestDispatcher("detail.jsp").forward(request, response);
    }
}