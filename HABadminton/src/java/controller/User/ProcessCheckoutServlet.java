package controller.User;

import dal.OrderDAO;
import model.Order;
import model.OrderDetail;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ProcessCheckoutServlet", urlPatterns = {"/processCheckout"})
public class ProcessCheckoutServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String fullName = lastName + " " + firstName; 
        
        String phone = request.getParameter("phone");
        String address = request.getParameter("address") + ", " 
                       + request.getParameter("district") + ", " 
                       + request.getParameter("city");
        
        String paymentMethod = request.getParameter("paymentMethod");
        String note = request.getParameter("note");
        
        String[] productIds = request.getParameterValues("productId");
        String[] productNames = request.getParameterValues("productName");
        String[] productQtys = request.getParameterValues("productQty");
        String[] productPrices = request.getParameterValues("productPrice");
        String[] productImages = request.getParameterValues("productImage"); 
        String voucherCode = request.getParameter("voucherCode");            

        List<OrderDetail> chiTietList = new ArrayList<>();
        if (productNames != null) {
            for (int i = 0; i < productNames.length; i++) {
                String name = productNames[i];
                int qty = Integer.parseInt(productQtys[i]);
                int price = Integer.parseInt(productPrices[i]);
                String image = (productImages != null && productImages.length > i) ? productImages[i] : "";
                
                OrderDetail detail = new OrderDetail(name, qty, price);
                detail.setHinhAnh(image);
                
                if (productIds != null && productIds.length > i) {
                    detail.setMaSP(productIds[i]);
                }
                
                chiTietList.add(detail);
            }
        }
        
        int totalAmount = 0;
        try {
            String totalStr = request.getParameter("totalAmount");
            if (totalStr != null && !totalStr.isEmpty()) {
                totalAmount = Integer.parseInt(totalStr);
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

        String maDonHang = "HAB-" + java.util.UUID.randomUUID().toString().substring(0, 6).toUpperCase();

        Order order = new Order();
        order.setMaDonHang(maDonHang);
        order.setTenNguoiNhan(fullName);
        order.setSdt(phone);
        order.setDiaChi(address);
        order.setTongTien(totalAmount);
        order.setPhuongThucThanhToan(paymentMethod);
        order.setTrangThai(1); 
        order.setChiTietList(chiTietList); 
        order.setMaVoucher(voucherCode);
        order.setGhiChu(note);
        
        String email = request.getParameter("email");
        model.User user = (model.User) request.getSession().getAttribute("user");
        
        if (email != null && !email.trim().isEmpty()) {
            order.setEmailKhachHang(email);
        } else if (user != null) {
            order.setEmailKhachHang(user.getEmail());
        } else {
            order.setEmailKhachHang(null);
        }

        if ("MOMO".equals(paymentMethod)) {
            request.getSession().setAttribute("pendingOrder", order);
            request.getRequestDispatcher("/momo-payment").forward(request, response);
            return;
        }

        OrderDAO dao = new OrderDAO();
        dao.insertOrder(order);
        
        request.setAttribute("isSuccess", true);
        request.setAttribute("order", order);
        request.getRequestDispatcher("payment-result.jsp").forward(request, response);
    }
}