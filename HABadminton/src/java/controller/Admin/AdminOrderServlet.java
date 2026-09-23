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
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "AdminOrderServlet", urlPatterns = {"/admin-orders"})
public class AdminOrderServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        OrderDAO dao = new OrderDAO();
        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        
        // 1. XỬ LÝ LỆNH CẬP NHẬT TRẠNG THÁI (UPDATE STATUS)
        if ("updateStatus".equals(action)) {
            String id = request.getParameter("id");
            String statusStr = request.getParameter("status");
            
            try {
                int newStatus = Integer.parseInt(statusStr);
                // GỌI HÀM CẬP NHẬT DATABASE Ở ĐÂY
                boolean isUpdated = dao.updateOrderStatus(id, newStatus); 
                
                if (isUpdated) {
                    // Trả về mã 200 OK cho Fetch API biết là thành công
                    response.setStatus(HttpServletResponse.SC_OK);
                    response.getWriter().write("success");
                } else {
                    // Trả về lỗi 500 nếu update thất bại
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    response.getWriter().write("error");
                }
            } catch (Exception e) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                e.printStackTrace();
            }
            return; // Dừng luồng ở đây, không render lại trang JSP
        }
        
        // 2. XỬ LÝ LỆNH XÓA (DELETE)
        if ("delete".equals(action)) {
            String id = request.getParameter("id");
            
            try {
                boolean isDeleted = dao.deleteOrder(id); 
                
                if (isDeleted) {
                    session.setAttribute("msgSuccess", "Đã xóa vĩnh viễn đơn hàng #" + id + " thành công!");
                } else {
                    session.setAttribute("msgError", "Không thể xóa đơn hàng #" + id + ". Vui lòng thử lại!");
                }
            } catch (Exception e) {
                session.setAttribute("msgError", "Hệ thống gặp lỗi khi xóa dữ liệu!");
                e.printStackTrace();
            }
            
            response.sendRedirect("admin-orders");
            return;
        }

        // 3. XỬ LÝ HIỂN THỊ DANH SÁCH MẶC ĐỊNH
        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");
        
        List<Order> listOrders = dao.searchAdminOrders(keyword, status);
        
        request.setAttribute("listOrders", listOrders);
        request.setAttribute("keyword", keyword);
        request.setAttribute("status", status);
        
        request.getRequestDispatcher("admin/admin-orders.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}