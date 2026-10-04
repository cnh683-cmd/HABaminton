package controller.User;

import dal.OrderDAO;
import model.Order;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "MoMoReturnServlet", urlPatterns = {"/momo-return"})
public class MoMoReturnServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String resultCode = request.getParameter("resultCode");
        System.out.println(">>> MOMO TRẢ KẾT QUẢ VỀ: " + resultCode);
        
        Order pendingOrder = (Order) request.getSession().getAttribute("pendingOrder");
        
        if (pendingOrder != null) {
            if ("0".equals(resultCode)) {
                System.out.println(">>> ĐÃ VÀO NHÁNH THÀNH CÔNG");
                pendingOrder.setTrangThai(1); 
                OrderDAO dao = new OrderDAO();
                dao.insertOrder(pendingOrder);
                
                // --- 1. TRỪ SỐ LƯỢNG TỒN KHO SẢN PHẨM ---
                if (pendingOrder.getChiTietList() != null) {
                    dal.SanPhamDAO spDao = new dal.SanPhamDAO();
                    for (model.OrderDetail item : pendingOrder.getChiTietList()) {
                        try {
                            if (item.getMaSP() != null) {
                                spDao.decreaseStock(item.getMaSP(), item.getSoLuong());
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                }

                // --- 2. TĂNG LƯỢT SỬ DỤNG VOUCHER ---
                if (pendingOrder.getMaVoucher() != null && !pendingOrder.getMaVoucher().trim().isEmpty()) {
                    new dal.VoucherDAO().increaseVoucherUsage(pendingOrder.getMaVoucher());
                }
                
                request.setAttribute("isSuccess", true); 
                request.setAttribute("success_string", "true");
            } else {
            System.out.println(">>> LỖI: KHÔNG TÌM THẤY PENDING ORDER TRONG SESSION");
            request.setAttribute("isSuccess", false);
        }
        
        request.getRequestDispatcher("payment-result.jsp").forward(request, response);
    }
}
}