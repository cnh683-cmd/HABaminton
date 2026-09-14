package controller;

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
        
        // Lấy lại đơn hàng đang "treo" trong Session
        Order pendingOrder = (Order) request.getSession().getAttribute("pendingOrder");
        
        if (pendingOrder != null) {
            if ("0".equals(resultCode)) {
                // THANH TOÁN THÀNH CÔNG: Cập nhật trạng thái và Lưu vào Database
                pendingOrder.setTrangThai(2); 
                OrderDAO dao = new OrderDAO();
                dao.insertOrder(pendingOrder);
            } else {
                // HỦY THANH TOÁN: Giữ trạng thái 1 để hiển thị lỗi (KHÔNG LƯU VÀO DATABASE)
                pendingOrder.setTrangThai(1); 
            }
            
            // Đẩy sang giao diện và xóa session treo
            request.setAttribute("order", pendingOrder);
            request.getSession().removeAttribute("pendingOrder");
        }
        
        request.getRequestDispatcher("payment-result.jsp").forward(request, response);
    }
}