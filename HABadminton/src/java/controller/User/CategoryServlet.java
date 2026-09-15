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

@WebServlet(name = "CategoryServlet", urlPatterns = {"/category"})
public class CategoryServlet extends HttpServlet {

        @Override
        protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            response.setContentType("text/html;charset=UTF-8");
            request.setCharacterEncoding("UTF-8");

            String id = request.getParameter("id") == null ? "1" : request.getParameter("id");
            String brandId = request.getParameter("brandId");
            String sort = request.getParameter("sort");
            String keyword = request.getParameter("keyword");

            String priceRange = request.getParameter("priceRange");
            String minPriceStr = request.getParameter("minPrice");
            String maxPriceStr = request.getParameter("maxPrice");

            Double minPrice = null;
            Double maxPrice = null;

            try {
                if (priceRange != null && !priceRange.isEmpty()) {
                    String[] parts = priceRange.split("-");
                    minPrice = Double.parseDouble(parts[0]);
                    maxPrice = Double.parseDouble(parts[1]);
                } else {
                    if (minPriceStr != null && !minPriceStr.trim().isEmpty()) minPrice = Double.parseDouble(minPriceStr);
                    if (maxPriceStr != null && !maxPriceStr.trim().isEmpty()) maxPrice = Double.parseDouble(maxPriceStr);
                }
            } catch (Exception e) {}
            
            request.setAttribute("syncMinPrice", minPrice != null ? String.valueOf(minPrice.longValue()) : "0");
            request.setAttribute("syncMaxPrice", maxPrice != null ? String.valueOf(maxPrice.longValue()) : "10000000");

            // 1. Logic tạo tên danh mục động
            String categoryName = "";
            switch (id) {
                case "1": categoryName = "Vợt"; break;
                case "2": categoryName = "Giày"; break;
                case "3": categoryName = "Áo"; break;
                case "4": categoryName = "Quần"; break;
                case "5": categoryName = "Váy"; break;
                case "6": categoryName = "Túi vợt"; break;
                case "7": categoryName = "Balo"; break;
                case "8": categoryName = "Túi đựng giày"; break;
                case "9": categoryName = "Phụ kiện"; break;
                default: categoryName = "Sản phẩm"; break;
            }

            // 2. Logic tạo tên hãng động
            String brandName = "";
            if (brandId != null && !brandId.isEmpty()) {
                switch (brandId) {
                    case "1": brandName = "Yonex"; break;
                    case "2": brandName = "Victor"; break;
                    case "3": brandName = "Lining"; break;
                    case "4": brandName = "VS"; break;
                    case "5": brandName = "Mizuno"; break;
                    case "6": brandName = "Kawasaki"; break;
                    case "7": brandName = "VNB"; break;
                    case "8": brandName = "Kamito"; break;
                    case "9": brandName = "Victec"; break;
                    case "10": brandName = "Donex Pro"; break;
                    case "11": brandName = "SFD"; break;
                    case "12": brandName = "Flypower"; break;
                }
            }

            // 3. Ghép chuỗi tiêu đề và gửi sang JSP
            String pageTitle = "";
            if (brandName.isEmpty()) {
                pageTitle = "Toàn bộ sản phẩm " + categoryName.toLowerCase();
            } else {
                pageTitle = "Dòng " + categoryName.toLowerCase() + " " + brandName;
            }

            if (id.equals("9")) pageTitle = "Toàn bộ phụ kiện cầu lông"; 

            // Viết hoa chữ cái đầu tiên
            pageTitle = pageTitle.substring(0, 1).toUpperCase() + pageTitle.substring(1);
            request.setAttribute("pageTitle", pageTitle);
            
            SanPhamDAO dao = new SanPhamDAO();
            List<SanPham> list = dao.getFilteredProducts(id, brandId, sort, keyword, minPrice, maxPrice);

            request.setAttribute("listSP", list);
            request.getRequestDispatcher("category.jsp").forward(request, response);
        }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}