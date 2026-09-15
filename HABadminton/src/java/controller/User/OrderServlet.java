package controller.User;

import dal.OrderDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Order;
import model.User;

@WebServlet(name = "OrderServlet", urlPatterns = {"/orders"})
public class OrderServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Bắt buộc đăng nhập
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Lấy danh sách đơn hàng theo email
        OrderDAO dao = new OrderDAO();
        List<Order> userOrders = dao.getOrdersByEmail(user.getEmail());
        
        // SỬA Ở ĐÂY: Đổi "orders" thành "listOrders" để khớp với orders.jsp
        request.setAttribute("listOrders", userOrders);
        request.getRequestDispatcher("orders.jsp").forward(request, response);
    }
}