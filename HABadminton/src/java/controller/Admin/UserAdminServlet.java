package controller.Admin;

import dal.UserDAO;
import model.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * QUẢN LÝ TÀI KHOẢN
 *  GET  : danh sách tài khoản + bộ lọc
 *  POST : add / update (submit form) | toggle / role / reset / delete (AJAX)
 */
@WebServlet(name = "UserAdminServlet", urlPatterns = {"/admin-customers"})
public class UserAdminServlet extends HttpServlet {

    private static final String DEFAULT_PASSWORD = "123456";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        String role = request.getParameter("role");
        String status = request.getParameter("status");

        UserDAO dao = new UserDAO();
        List<User> listUsers = dao.searchUsers(keyword, role, status);

        List<User> all = dao.searchUsers(null, null, null);
        int countCustomer = 0, countAdmin = 0, countLocked = 0;
        for (User u : all) {
            if (u.getRole() == 1) countAdmin++; else countCustomer++;
            if (u.getTrangThai() == 0) countLocked++;
        }

        request.setAttribute("listUsers", listUsers);
        request.setAttribute("countAll", all.size());
        request.setAttribute("countCustomer", countCustomer);
        request.setAttribute("countAdmin", countAdmin);
        request.setAttribute("countLocked", countLocked);
        request.setAttribute("defaultPassword", DEFAULT_PASSWORD);

        request.getRequestDispatcher("admin/admin-users.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        User me = (User) session.getAttribute("user");
        UserDAO dao = new UserDAO();

        // ------------------ FORM THÊM / SỬA ------------------
        if ("add".equals(action) || "update".equals(action)) {
            User u = new User();
            u.setEmail(trim(request.getParameter("email")));
            u.setHoTen(trim(request.getParameter("hoTen")));
            u.setSdt(trim(request.getParameter("sdt")));
            u.setDiaChi(trim(request.getParameter("diaChi")));
            u.setQuanHuyen(trim(request.getParameter("quanHuyen")));
            u.setTinhThanh(trim(request.getParameter("tinhThanh")));
            u.setRole("1".equals(request.getParameter("role")) ? 1 : 0);

            if (u.getHoTen() == null || u.getHoTen().isEmpty()) {
                session.setAttribute("msgError", "Họ tên không được để trống!");
            } else if (u.getSdt() != null && !u.getSdt().isEmpty() && !u.getSdt().matches("0\\d{9,10}")) {
                session.setAttribute("msgError", "Số điện thoại không hợp lệ!");
            } else if ("add".equals(action)) {
                String password = request.getParameter("matKhau");
                if (u.getEmail() == null || !u.getEmail().matches("^[\\w.+-]+@[\\w-]+(\\.[\\w-]+)+$")) {
                    session.setAttribute("msgError", "Email không hợp lệ!");
                } else if (dao.emailExists(u.getEmail())) {
                    session.setAttribute("msgError", "Email " + u.getEmail() + " đã được đăng ký!");
                } else if (password == null || password.length() < 6) {
                    session.setAttribute("msgError", "Mật khẩu phải có ít nhất 6 ký tự!");
                } else if (dao.insertUserByAdmin(u, password)) {
                    session.setAttribute("msgSuccess", "Đã tạo tài khoản " + u.getEmail() + "!");
                } else {
                    session.setAttribute("msgError", "Không thể tạo tài khoản!");
                }
            } else {
                // Không cho admin tự hạ quyền của chính mình
                if (me != null && me.getEmail().equalsIgnoreCase(u.getEmail())) u.setRole(1);
                if (dao.updateUserByAdmin(u)) {
                    session.setAttribute("msgSuccess", "Đã cập nhật tài khoản " + u.getEmail() + "!");
                } else {
                    session.setAttribute("msgError", "Cập nhật tài khoản thất bại!");
                }
            }
            response.sendRedirect("admin-customers");
            return;
        }

        // ------------------ THAO TÁC AJAX ------------------
        String email = request.getParameter("email");
        String result = "fail";
        if (email != null && me != null && me.getEmail().equalsIgnoreCase(email)
                && ("toggle".equals(action) || "role".equals(action) || "delete".equals(action))) {
            result = "self"; // không thao tác lên chính tài khoản đang đăng nhập
        } else {
            try {
                switch (action == null ? "" : action) {
                    case "toggle":
                        if (dao.updateUserStatus(email, Integer.parseInt(request.getParameter("status")))) result = "success";
                        break;
                    case "role":
                        if (dao.updateUserRole(email, Integer.parseInt(request.getParameter("role")))) result = "success";
                        break;
                    case "reset":
                        if (dao.resetPassword(email, DEFAULT_PASSWORD)) result = "success";
                        break;
                    case "delete":
                        if (dao.deleteUser(email)) result = "success";
                        else if (dao.updateUserStatus(email, 0)) result = "locked"; // có dữ liệu liên quan -> khóa thay vì xóa
                        break;
                    default:
                        break;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.setContentType("text/plain;charset=UTF-8");
        response.getWriter().write(result);
    }

    private String trim(String s) {
        return s == null ? null : s.trim();
    }
}
