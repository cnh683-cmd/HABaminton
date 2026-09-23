package controller.User;

import dal.OrderDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "CancelOrderServlet", urlPatterns = {"/cancel-order"})
public class CancelOrderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String id = request.getParameter("id");
        String reason = request.getParameter("reason");
        String from = request.getParameter("from");
        
        if (id != null && reason != null) {
            OrderDAO dao = new OrderDAO();
            dao.cancelOrder(id, reason);
        }
        
        if ("admin".equals(from)) {
            response.sendRedirect("admin-orders");
        } else {
            response.sendRedirect("order-detail?id=" + id); 
        }
    }
}