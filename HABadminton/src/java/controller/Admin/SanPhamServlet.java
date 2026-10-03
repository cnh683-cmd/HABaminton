package controller.Admin;

import dal.SanPhamDAO;
import model.SanPham;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * QUẢN LÝ SẢN PHẨM - hiển thị danh sách + bộ lọc.
 * Các thao tác thêm / sửa / xóa / ẩn hiện / cập nhật kho xử lý ở ProductActionServlet.
 */
@WebServlet(name = "SanPhamServlet", urlPatterns = {"/admin-products"})
public class SanPhamServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        String maDM = request.getParameter("category");
        String maTH = request.getParameter("brand");
        String status = request.getParameter("status");
        String stock = request.getParameter("stock");
        String sort = request.getParameter("sort");

        SanPhamDAO dao = new SanPhamDAO();
        List<SanPham> listProducts;
        try {
            listProducts = dao.searchAdminProducts(keyword, maDM, maTH, status, stock, sort);
        } catch (NumberFormatException e) {
            listProducts = dao.searchAdminProducts(keyword, null, null, null, stock, sort);
        }

        // Số liệu thẻ thống kê (tính trên toàn bộ sản phẩm, không phụ thuộc bộ lọc)
        List<SanPham> all = dao.searchAdminProducts(null, null, null, null, null, null);
        int countActive = 0, countHidden = 0, countLow = 0, countOut = 0;
        for (SanPham sp : all) {
            if (sp.getTrangThai() == 1) countActive++; else countHidden++;
            if (sp.getSoLuong() <= 0) countOut++;
            else if (sp.getSoLuong() < 5) countLow++;
        }

        request.setAttribute("listProducts", listProducts);
        request.setAttribute("countAll", all.size());
        request.setAttribute("countActive", countActive);
        request.setAttribute("countHidden", countHidden);
        request.setAttribute("countLow", countLow);
        request.setAttribute("countOut", countOut);
        request.setAttribute("catMap", dao.getCategoryMap());
        request.setAttribute("brandMap", dao.getBrandMap());

        request.getRequestDispatcher("admin/admin-products.jsp").forward(request, response);
    }
}
