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
        
        // Bắt buộc cấu hình UTF-8 để nhận Lý do hủy tiếng Việt không bị lỗi font
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        OrderDAO dao = new OrderDAO();
        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        
        // 1. XỬ LÝ LỆNH CẬP NHẬT TRẠNG THÁI VÀ HỦY ĐƠN
        if ("updateStatus".equals(action)) {
            String id = request.getParameter("id");
            String statusStr = request.getParameter("status");
            
            try {
                int newStatus = Integer.parseInt(statusStr);
                boolean isSuccess = false;
                
                // NẾU TRẠNG THÁI = 0 (HỦY ĐƠN) -> GỌI HÀM cancelOrder KÈM LÝ DO
                if (newStatus == 0) {
                    String reason = request.getParameter("reason");
                    if (reason == null || reason.trim().isEmpty()) {
                        reason = "Hệ thống / Admin đã hủy đơn hàng";
                    }
                    dao.cancelOrder(id, reason);
                    isSuccess = true; 
                } 
                // NẾU LÀ CÁC TRẠNG THÁI KHÁC -> CẬP NHẬT BÌNH THƯỜNG
                else {
                    isSuccess = dao.updateOrderStatus(id, newStatus); 
                }
                
                if (isSuccess) {
                    response.setStatus(HttpServletResponse.SC_OK);
                    response.getWriter().write("success");
                } else {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    response.getWriter().write("error");
                }
            } catch (Exception e) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                e.printStackTrace();
            }
            return; // Trả dữ liệu về cho Fetch API, không load lại trang
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