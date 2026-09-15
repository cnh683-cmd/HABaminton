package controller.User;

import dal.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

@WebServlet(name = "LoginServlet", urlPatterns = {"/loginServlet"})
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        UserDAO dao = new UserDAO();
        User loginUser = dao.checkLogin(email, password); // Check DB
        
        if (loginUser != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", loginUser);
            
            // KIỂM TRA ROLE ĐỂ PHÂN LUỒNG
            if (loginUser.getRole() == 1) {
                response.sendRedirect("admin-orders"); // Admin vào trang quản lý
            } else {
                response.sendRedirect("index.jsp"); // Khách hàng về trang chủ
            }
        } else {
            // Đăng nhập sai: Truyền biến error và giữ nguyên trang login
            request.setAttribute("error", "Email hoặc mật khẩu không đúng!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}