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

@WebServlet(name = "UpdateProfileServlet", urlPatterns = {"/updateProfileServlet"})
public class UpdateProfileServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser != null) {
            // Cập nhật thông tin mới vào Object User
            currentUser.setHoTen(request.getParameter("hoTen"));
            currentUser.setSdt(request.getParameter("sdt"));
            currentUser.setDiaChi(request.getParameter("diaChi"));
            currentUser.setQuanHuyen(request.getParameter("quanHuyen"));
            currentUser.setTinhThanh(request.getParameter("tinhThanh"));
            
            // Lưu xuống SQL Server
            UserDAO dao = new UserDAO();
            dao.updateProfile(currentUser);
            
            // Cập nhật lại Session
            session.setAttribute("user", currentUser);
        }
        response.sendRedirect("profile.jsp");
    }
}