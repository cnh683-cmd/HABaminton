package controller.Admin;

import dal.OrderDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "UpdateOrderServlet", urlPatterns = {"/update-order"})
public class UpdateOrderServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String id = request.getParameter("id");
        OrderDAO dao = new OrderDAO();
        
        if ("updateStatus".equals(action)) {
            int status = Integer.parseInt(request.getParameter("status"));
            dao.updateOrderStatus(id, status);
            response.getWriter().write("success");
        } 
        else if ("delete".equals(action)) {
            if(dao.deleteOrder(id)) {
                response.getWriter().write("success");
            } else {
                response.getWriter().write("error");
            }
        }
    }
}