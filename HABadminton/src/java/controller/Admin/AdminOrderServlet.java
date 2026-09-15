package controller.Admin;

import dal.OrderDAO;
import model.Order;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminOrderServlet", urlPatterns = {"/admin-orders"})
public class AdminOrderServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");
        
        OrderDAO dao = new OrderDAO();
        List<Order> listOrders = dao.searchAdminOrders(keyword, status);
        
        request.setAttribute("listOrders", listOrders);
        request.setAttribute("keyword", keyword);
        request.setAttribute("status", status);
        
        request.getRequestDispatcher("admin/admin-orders.jsp").forward(request, response);
    }
}