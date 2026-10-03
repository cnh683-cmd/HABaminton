package controller.Admin;

import dal.VoucherDAO;
import model.Voucher;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * QUẢN LÝ GIẢM GIÁ (VOUCHER) - hiển thị danh sách + bộ lọc.
 * Thao tác thêm / sửa / xóa / bật tắt nằm ở VoucherActionServlet.
 */
@WebServlet(name = "VoucherAdminServlet", urlPatterns = {"/admin-vouchers"})
public class VoucherAdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        String type = request.getParameter("type");
        String status = request.getParameter("status");

        VoucherDAO dao = new VoucherDAO();
        List<Voucher> listVouchers = dao.searchVouchers(keyword, type, status);
        if (dao.hasError()) request.setAttribute("dbError", dao.getLastError());

        // Thẻ thống kê trên toàn bộ voucher
        List<Voucher> all = dao.getAllVouchers();
        int active = 0, upcoming = 0, expired = 0, off = 0, totalUsed = 0;
        for (Voucher v : all) {
            switch (v.getTinhTrang()) {
                case "active": active++; break;
                case "upcoming": upcoming++; break;
                case "off": off++; break;
                default: expired++; break; // expired + soldout
            }
            totalUsed += v.getDaSuDung();
        }

        request.setAttribute("listVouchers", listVouchers);
        request.setAttribute("countAll", all.size());
        request.setAttribute("countActive", active);
        request.setAttribute("countUpcoming", upcoming);
        request.setAttribute("countExpired", expired);
        request.setAttribute("countOff", off);
        request.setAttribute("totalUsed", totalUsed);

        request.getRequestDispatcher("admin/admin-vouchers.jsp").forward(request, response);
    }
}