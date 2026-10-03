package controller.User;

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
 * Mở trang thanh toán, nạp danh sách voucher đang áp dụng từ CSDL
 * (trước đây danh sách voucher bị viết cứng trong checkout.jsp).
 */
@WebServlet(name = "CheckoutServlet", urlPatterns = {"/checkout"})
public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Voucher> vouchers = new VoucherDAO().getAvailableVouchers();
        request.setAttribute("vouchers", vouchers);
        request.setAttribute("vouchersLoaded", true);
        request.getRequestDispatcher("checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
