package controller.Admin;

import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

/**
 * Chặn mọi truy cập vào khu vực quản trị nếu chưa đăng nhập bằng tài khoản Admin (Role = 1).
 */
@WebFilter(filterName = "AdminFilter", urlPatterns = {
    "/admin/*",
    "/admin-dashboard",
    "/admin-orders",
    "/update-order",
    "/admin-products",
    "/admin-product-action",
    "/admin-customers",
    "/admin-vouchers",
    "/admin-voucher-action",
    "/admin-reviews"
})
public class AdminFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || user.getRole() != 1) {
            // Yêu cầu AJAX (fetch) -> trả mã lỗi thay vì chuyển trang
            String requestedWith = request.getHeader("X-Requested-With");
            if ("XMLHttpRequest".equals(requestedWith)) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().write("forbidden");
                return;
            }
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Không cho trình duyệt cache trang admin (tránh bấm Back sau khi đăng xuất vẫn xem được)
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        chain.doFilter(req, res);
    }

    @Override
    public void destroy() {
    }
}
