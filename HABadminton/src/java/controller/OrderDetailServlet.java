package controller;

import dal.OrderDAO;
import model.Order;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "OrderDetailServlet", urlPatterns = {"/order-detail"})
public class OrderDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Lấy mã đơn hàng từ URL (ví dụ: ?id=WEB-123456)
        String maDonHang = request.getParameter("id");
        
        if (maDonHang != null && !maDonHang.isEmpty()) {
            OrderDAO dao = new OrderDAO();
            Order order = dao.getOrderById(maDonHang); // Hàm này đã bao gồm list sản phẩm
            
            if (order != null) {
                // Đẩy object "order" sang JSP
                request.setAttribute("order", order);
                request.getRequestDispatcher("order-detail.jsp").forward(request, response);
                return;
            }
        }
        
        // Nếu URL thiếu ID hoặc mã đơn sai, đá về trang danh sách
        response.sendRedirect("orders");
    }
}