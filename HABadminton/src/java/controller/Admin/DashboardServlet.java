package controller.Admin;

import dal.DashboardDAO;
import dal.SanPhamDAO;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Trang TỔNG QUAN / THỐNG KÊ.
 * Tham số: year (năm của biểu đồ theo tháng), from / to (yyyy-MM-dd, lọc khoảng ngày cho các số liệu còn lại).
 */
@WebServlet(name = "DashboardServlet", urlPatterns = {"/admin-dashboard"})
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        DashboardDAO dao = new DashboardDAO();

        int year = java.time.Year.now().getValue();
        try {
            if (request.getParameter("year") != null) year = Integer.parseInt(request.getParameter("year"));
        } catch (NumberFormatException ignored) {}

        String from = validDate(request.getParameter("from"));
        String to = validDate(request.getParameter("to"));

        // ---- Thẻ KPI ----
        double monthRevenue = dao.getMonthlyRevenue();
        double lastMonthRevenue = dao.getLastMonthRevenue();
        Double growth = null;
        if (lastMonthRevenue > 0) growth = (monthRevenue - lastMonthRevenue) * 100.0 / lastMonthRevenue;

        request.setAttribute("monthRevenue", monthRevenue);
        request.setAttribute("growth", growth);
        request.setAttribute("rangeRevenue", dao.getRevenue(from, to));
        request.setAttribute("rangeOrders", dao.getOrderCount(from, to));
        request.setAttribute("soldQuantity", dao.getSoldQuantity(from, to));
        request.setAttribute("pendingOrders", dao.getPendingOrdersCount());
        request.setAttribute("totalUsers", dao.getTotalUsers());
        request.setAttribute("newUsers", dao.getNewUsersThisMonth());
        request.setAttribute("totalProducts", dao.getTotalProducts());
        request.setAttribute("lowStock", dao.getLowStockCount());
        request.setAttribute("activeVouchers", dao.getActiveVoucherCount());

        // ---- Biểu đồ doanh thu & số đơn theo tháng ----
        List<Double> revenueByMonth = dao.getRevenueByMonth(year);
        List<Integer> ordersByMonth = dao.getOrderCountByMonth(year);
        double yearRevenue = 0;
        for (Double d : revenueByMonth) yearRevenue += d;
        request.setAttribute("yearRevenue", yearRevenue);
        request.setAttribute("revenueJson", toJsonNumbers(revenueByMonth));
        request.setAttribute("ordersJson", toJsonNumbers(ordersByMonth));

        // ---- Trạng thái đơn ----
        Map<Integer, Integer> statusCounts = dao.getOrderStatusCounts(from, to);
        request.setAttribute("statusCounts", statusCounts);
        request.setAttribute("statusJson", "[" + statusCounts.get(1) + "," + statusCounts.get(4) + ","
                + statusCounts.get(2) + "," + statusCounts.get(3) + "," + statusCounts.get(0) + "]");

        // ---- Doanh thu theo danh mục ----
        Map<Integer, String> catMap = new SanPhamDAO().getCategoryMap();
        Map<Integer, Long> catRevenue = dao.getRevenueByCategory(from, to);
        StringBuilder catLabels = new StringBuilder("[");
        StringBuilder catValues = new StringBuilder("[");
        boolean first = true;
        for (Map.Entry<Integer, Long> e : catRevenue.entrySet()) {
            if (!first) { catLabels.append(","); catValues.append(","); }
            String name = catMap.getOrDefault(e.getKey(), "Danh mục " + e.getKey());
            catLabels.append("\"").append(name.replace("\"", "\\\"")).append("\"");
            catValues.append(e.getValue());
            first = false;
        }
        request.setAttribute("catLabelsJson", catLabels.append("]").toString());
        request.setAttribute("catValuesJson", catValues.append("]").toString());

        // ---- Phương thức thanh toán (biểu đồ tròn) ----
        Map<String, Integer> pay = dao.getPaymentMethodCounts(from, to);
        StringBuilder payLabels = new StringBuilder("[");
        StringBuilder payValues = new StringBuilder("[");
        boolean firstPay = true;
        for (Map.Entry<String, Integer> e : pay.entrySet()) {
            if (!firstPay) { payLabels.append(","); payValues.append(","); }
            String name = e.getKey();
            if ("COD".equals(name)) name = "Tiền mặt (COD)";
            else if ("MOMO".equals(name)) name = "Ví MoMo";
            payLabels.append("\"").append(name.replace("\"", "\\\"")).append("\"");
            payValues.append(e.getValue());
            firstPay = false;
        }
        request.setAttribute("payLabelsJson", payLabels.append("]").toString());
        request.setAttribute("payValuesJson", payValues.append("]").toString());

        // ---- Bảng xếp hạng ----
        request.setAttribute("topProducts", dao.getTopProducts(5, from, to));
        request.setAttribute("topCustomers", dao.getTopCustomers(5, from, to));
        request.setAttribute("recentOrders", dao.getRecentOrders());

        request.setAttribute("years", dao.getOrderYears());
        request.setAttribute("year", year);
        request.setAttribute("from", from);
        request.setAttribute("to", to);

        request.getRequestDispatcher("admin/admin-dashboard.jsp").forward(request, response);
    }

    private String validDate(String s) {
        if (s == null || s.trim().isEmpty()) return null;
        try {
            java.time.LocalDate.parse(s.trim());
            return s.trim();
        } catch (Exception e) {
            return null;
        }
    }

    private String toJsonNumbers(List<? extends Number> list) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < list.size(); i++) {
            if (i > 0) sb.append(",");
            Number n = list.get(i);
            sb.append(n == null ? 0 : (n instanceof Double ? String.valueOf(Math.round(n.doubleValue())) : n.toString()));
        }
        return sb.append("]").toString();
    }
}