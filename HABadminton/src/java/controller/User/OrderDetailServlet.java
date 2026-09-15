package controller.User;

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
        
        String maDonHang = request.getParameter("id");
        
        if (maDonHang != null && !maDonHang.isEmpty()) {
            OrderDAO dao = new OrderDAO();
            
            dao.markUserAsRead(maDonHang);
            
            Order order = dao.getOrderById(maDonHang);
            
            if (order != null) {
                request.setAttribute("order", order);
                request.getRequestDispatcher("order-detail.jsp").forward(request, response);
                return;
            }
        }
        
        response.sendRedirect("orders");
    }
}