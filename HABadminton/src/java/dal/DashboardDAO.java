package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import model.Order;

/**
 * DAO phục vụ trang THỐNG KÊ / TỔNG QUAN.
 * Quy ước: doanh thu KHÔNG tính các đơn đã hủy (TrangThai = 0).
 * Các tham số from / to có dạng yyyy-MM-dd, để null nếu không lọc theo khoảng ngày.
 */
public class DashboardDAO extends DBContext {

    // ---------------------------------------------------------------- helpers
    private void appendRange(StringBuilder sql, List<Object> params, String alias, String from, String to) {
        String col = (alias == null ? "" : alias + ".") + "NgayDat";
        if (from != null && !from.isEmpty()) {
            sql.append(" AND ").append(col).append(" >= ? ");
            params.add(java.sql.Date.valueOf(from));
        }
        if (to != null && !to.isEmpty()) {
            sql.append(" AND ").append(col).append(" < DATEADD(DAY, 1, ?) ");
            params.add(java.sql.Date.valueOf(to));
        }
    }

    private PreparedStatement prepare(String sql, List<Object> params) throws Exception {
        PreparedStatement st = connection.prepareStatement(sql);
        for (int i = 0; i < params.size(); i++) st.setObject(i + 1, params.get(i));
        return st;
    }

    private double scalarDouble(String sql, List<Object> params) {
        try {
            ResultSet rs = prepare(sql, params).executeQuery();
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) { System.out.println("Lỗi thống kê: " + e.getMessage()); }
        return 0;
    }

    private int scalarInt(String sql, List<Object> params) {
        try {
            ResultSet rs = prepare(sql, params).executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { System.out.println("Lỗi thống kê: " + e.getMessage()); }
        return 0;
    }

    // ---------------------------------------------------------------- KPI

    // 1. Tổng doanh thu tháng hiện tại (không tính đơn hủy)
    public double getMonthlyRevenue() {
        return scalarDouble("SELECT ISNULL(SUM(CAST(TongTien AS BIGINT)), 0) FROM DONHANG WHERE TrangThai <> 0 "
                + "AND MONTH(NgayDat) = MONTH(GETDATE()) AND YEAR(NgayDat) = YEAR(GETDATE())", new ArrayList<>());
    }

    // 1b. Doanh thu tháng trước (để tính % tăng trưởng)
    public double getLastMonthRevenue() {
        return scalarDouble("SELECT ISNULL(SUM(CAST(TongTien AS BIGINT)), 0) FROM DONHANG WHERE TrangThai <> 0 "
                + "AND MONTH(NgayDat) = MONTH(DATEADD(MONTH, -1, GETDATE())) AND YEAR(NgayDat) = YEAR(DATEADD(MONTH, -1, GETDATE()))",
                new ArrayList<>());
    }

    // 1c. Doanh thu trong khoảng ngày
    public double getRevenue(String from, String to) {
        StringBuilder sql = new StringBuilder("SELECT ISNULL(SUM(CAST(TongTien AS BIGINT)), 0) FROM DONHANG WHERE TrangThai <> 0 ");
        List<Object> p = new ArrayList<>();
        appendRange(sql, p, null, from, to);
        return scalarDouble(sql.toString(), p);
    }

    // 1d. Tổng số đơn trong khoảng ngày (tính cả đơn hủy)
    public int getOrderCount(String from, String to) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM DONHANG WHERE 1=1 ");
        List<Object> p = new ArrayList<>();
        appendRange(sql, p, null, from, to);
        return scalarInt(sql.toString(), p);
    }

    // 1e. Tổng số sản phẩm đã bán trong khoảng ngày
    public int getSoldQuantity(String from, String to) {
        StringBuilder sql = new StringBuilder("SELECT ISNULL(SUM(c.SoLuong), 0) FROM ChiTietDonHang c "
                + "JOIN DONHANG d ON c.MaDonHang = d.MaDonHang WHERE d.TrangThai <> 0 ");
        List<Object> p = new ArrayList<>();
        appendRange(sql, p, "d", from, to);
        return scalarInt(sql.toString(), p);
    }

    // 2. Số đơn chờ xác nhận (TrangThai = 1)
    public int getPendingOrdersCount() {
        return scalarInt("SELECT COUNT(*) FROM DONHANG WHERE TrangThai = 1", new ArrayList<>());
    }

    // 3. Tổng số khách hàng
    public int getTotalUsers() {
        return scalarInt("SELECT COUNT(*) FROM TAIKHOAN WHERE Role = 0", new ArrayList<>());
    }

    // 3b. Khách hàng mới trong tháng
    public int getNewUsersThisMonth() {
        // Cột NgayTao có thể chưa có trong CSDL -> trả về 0
        return scalarInt("IF COL_LENGTH('TAIKHOAN','NgayTao') IS NOT NULL "
                + "EXEC('SELECT COUNT(*) FROM TAIKHOAN WHERE Role = 0 AND MONTH(NgayTao) = MONTH(GETDATE()) AND YEAR(NgayTao) = YEAR(GETDATE())') "
                + "ELSE SELECT 0", new ArrayList<>());
    }

    // 3c. Tổng số sản phẩm đang bán
    public int getTotalProducts() {
        return scalarInt("SELECT COUNT(*) FROM SANPHAM WHERE ISNULL(TrangThai, 1) = 1", new ArrayList<>());
    }

    // 4. Số sản phẩm sắp hết hàng (Tồn kho dưới 5)
    public int getLowStockCount() {
        return scalarInt("SELECT COUNT(*) FROM SANPHAM WHERE SoLuong < 5 AND ISNULL(TrangThai, 1) = 1", new ArrayList<>());
    }

    // 4b. Voucher đang hoạt động
    public int getActiveVoucherCount() {
        return scalarInt("SELECT COUNT(*) FROM VOUCHER WHERE TrangThai = 1 AND DaSuDung < SoLuong "
                + "AND CAST(GETDATE() AS DATE) BETWEEN NgayBatDau AND NgayKetThuc", new ArrayList<>());
    }

    // ---------------------------------------------------------------- BIỂU ĐỒ

    // 5. Doanh thu 12 tháng của 1 năm (không tính đơn hủy)
    public List<Double> getRevenueByMonth(int year) {
        Double[] months = new Double[]{0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
        String sql = "SELECT MONTH(NgayDat) AS Thang, SUM(CAST(TongTien AS BIGINT)) AS DoanhThu FROM DONHANG "
                   + "WHERE YEAR(NgayDat) = ? AND TrangThai <> 0 GROUP BY MONTH(NgayDat)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, year);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                months[rs.getInt("Thang") - 1] = rs.getDouble("DoanhThu");
            }
        } catch (Exception e) { System.out.println("Lỗi getRevenueByMonth: " + e); }
        return Arrays.asList(months);
    }

    // 5b. Số đơn hàng theo 12 tháng
    public List<Integer> getOrderCountByMonth(int year) {
        Integer[] months = new Integer[]{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
        String sql = "SELECT MONTH(NgayDat) AS Thang, COUNT(*) AS SoDon FROM DONHANG WHERE YEAR(NgayDat) = ? GROUP BY MONTH(NgayDat)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, year);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                months[rs.getInt("Thang") - 1] = rs.getInt("SoDon");
            }
        } catch (Exception e) { System.out.println("Lỗi getOrderCountByMonth: " + e); }
        return Arrays.asList(months);
    }

    // 5c. Các năm có đơn hàng (cho ô chọn năm)
    public List<Integer> getOrderYears() {
        List<Integer> years = new ArrayList<>();
        try {
            ResultSet rs = connection.prepareStatement("SELECT DISTINCT YEAR(NgayDat) AS Nam FROM DONHANG ORDER BY Nam DESC").executeQuery();
            while (rs.next()) years.add(rs.getInt("Nam"));
        } catch (Exception e) { System.out.println("Lỗi getOrderYears: " + e); }
        int current = java.time.Year.now().getValue();
        if (!years.contains(current)) years.add(0, current);
        return years;
    }

    // 6. Số đơn theo trạng thái (key: 1,4,2,3,0)
    public Map<Integer, Integer> getOrderStatusCounts(String from, String to) {
        Map<Integer, Integer> map = new LinkedHashMap<>();
        map.put(1, 0); map.put(4, 0); map.put(2, 0); map.put(3, 0); map.put(0, 0);
        StringBuilder sql = new StringBuilder("SELECT TrangThai, COUNT(*) AS SoDon FROM DONHANG WHERE 1=1 ");
        List<Object> p = new ArrayList<>();
        appendRange(sql, p, null, from, to);
        sql.append(" GROUP BY TrangThai");
        try {
            ResultSet rs = prepare(sql.toString(), p).executeQuery();
            while (rs.next()) map.put(rs.getInt("TrangThai"), rs.getInt("SoDon"));
        } catch (Exception e) { System.out.println("Lỗi getOrderStatusCounts: " + e); }
        return map;
    }

    // 6b. Số đơn theo phương thức thanh toán (không tính đơn hủy): Map<"COD"/"MOMO"/..., SoDon>
    public Map<String, Integer> getPaymentMethodCounts(String from, String to) {
        Map<String, Integer> map = new LinkedHashMap<>();
        StringBuilder sql = new StringBuilder("SELECT UPPER(ISNULL(NULLIF(LTRIM(RTRIM(PhuongThucThanhToan)), ''), N'KHÁC')) AS PT, COUNT(*) AS SoDon "
                + "FROM DONHANG WHERE TrangThai <> 0 ");
        List<Object> p = new ArrayList<>();
        appendRange(sql, p, null, from, to);
        sql.append(" GROUP BY UPPER(ISNULL(NULLIF(LTRIM(RTRIM(PhuongThucThanhToan)), ''), N'KHÁC')) ORDER BY SoDon DESC");
        try {
            ResultSet rs = prepare(sql.toString(), p).executeQuery();
            while (rs.next()) map.put(rs.getString("PT"), rs.getInt("SoDon"));
        } catch (Exception e) { System.out.println("Lỗi getPaymentMethodCounts: " + e); }
        return map;
    }

    // 7. Top sản phẩm bán chạy: mỗi phần tử là Map {maSP, tenSP, hinhAnh, soLuong, doanhThu}
    public List<Map<String, Object>> getTopProducts(int limit, String from, String to) {
        List<Map<String, Object>> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT TOP (" + Math.max(1, limit) + ") c.MaSP, MAX(s.TenSP) AS TenSP, MAX(s.HinhAnh) AS HinhAnh, "
                + "SUM(c.SoLuong) AS SoLuong, SUM(CAST(c.SoLuong AS BIGINT) * c.GiaMua) AS DoanhThu "
                + "FROM ChiTietDonHang c JOIN DONHANG d ON c.MaDonHang = d.MaDonHang "
                + "LEFT JOIN SANPHAM s ON s.MaSP = c.MaSP WHERE d.TrangThai <> 0 ");
        List<Object> p = new ArrayList<>();
        appendRange(sql, p, "d", from, to);
        sql.append(" GROUP BY c.MaSP ORDER BY SoLuong DESC");
        try {
            ResultSet rs = prepare(sql.toString(), p).executeQuery();
            while (rs.next()) {
                Map<String, Object> m = new LinkedHashMap<>();
                m.put("maSP", rs.getString("MaSP"));
                if (rs.getString("TenSP") == null) {
                    m.put("tenSP", "Sản phẩm #" + rs.getString("MaSP") + " (đã xóa)");
                }
                m.putIfAbsent("tenSP", rs.getString("TenSP"));
                m.put("hinhAnh", rs.getString("HinhAnh"));
                m.put("soLuong", rs.getInt("SoLuong"));
                m.put("doanhThu", rs.getLong("DoanhThu"));
                list.add(m);
            }
        } catch (Exception e) { System.out.println("Lỗi getTopProducts: " + e); }
        return list;
    }

    // 8. Doanh thu theo danh mục: Map<MaDM, DoanhThu>
    public Map<Integer, Long> getRevenueByCategory(String from, String to) {
        Map<Integer, Long> map = new LinkedHashMap<>();
        StringBuilder sql = new StringBuilder("SELECT s.MaDM, SUM(CAST(c.SoLuong AS BIGINT) * c.GiaMua) AS DoanhThu "
                + "FROM ChiTietDonHang c JOIN DONHANG d ON c.MaDonHang = d.MaDonHang "
                + "JOIN SANPHAM s ON s.MaSP = TRY_CAST(c.MaSP AS INT) WHERE d.TrangThai <> 0 ");
        List<Object> p = new ArrayList<>();
        appendRange(sql, p, "d", from, to);
        sql.append(" GROUP BY s.MaDM ORDER BY DoanhThu DESC");
        try {
            ResultSet rs = prepare(sql.toString(), p).executeQuery();
            while (rs.next()) map.put(rs.getInt("MaDM"), rs.getLong("DoanhThu"));
        } catch (Exception e) { System.out.println("Lỗi getRevenueByCategory: " + e); }
        return map;
    }

    // 9. Top khách hàng chi tiêu nhiều nhất: Map {email, hoTen, avatar, soDon, tongTien}
    public List<Map<String, Object>> getTopCustomers(int limit, String from, String to) {
        List<Map<String, Object>> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT TOP (" + Math.max(1, limit) + ") d.EmailKhachHang, MAX(ISNULL(t.HoTen, d.TenNguoiNhan)) AS HoTen, "
                + "MAX(t.Avatar) AS Avatar, COUNT(*) AS SoDon, SUM(CAST(d.TongTien AS BIGINT)) AS TongTien "
                + "FROM DONHANG d LEFT JOIN TAIKHOAN t ON t.Email = d.EmailKhachHang "
                + "WHERE d.TrangThai <> 0 AND d.EmailKhachHang IS NOT NULL ");
        List<Object> p = new ArrayList<>();
        appendRange(sql, p, "d", from, to);
        sql.append(" GROUP BY d.EmailKhachHang ORDER BY TongTien DESC");
        try {
            ResultSet rs = prepare(sql.toString(), p).executeQuery();
            while (rs.next()) {
                Map<String, Object> m = new LinkedHashMap<>();
                m.put("email", rs.getString("EmailKhachHang"));
                m.put("hoTen", rs.getString("HoTen"));
                m.put("avatar", rs.getString("Avatar"));
                m.put("soDon", rs.getInt("SoDon"));
                m.put("tongTien", rs.getLong("TongTien"));
                list.add(m);
            }
        } catch (Exception e) { System.out.println("Lỗi getTopCustomers: " + e); }
        return list;
    }

    // 10. Lấy 5 đơn hàng mới nhất
    public List<Order> getRecentOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT TOP 6 * FROM DONHANG ORDER BY NgayDat DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Order o = new Order();
                o.setMaDonHang(rs.getString("MaDonHang"));
                o.setTenNguoiNhan(rs.getString("TenNguoiNhan"));
                o.setTongTien(rs.getInt("TongTien"));
                o.setTrangThai(rs.getInt("TrangThai"));
                o.setNgayDat(rs.getTimestamp("NgayDat"));
                o.setPhuongThucThanhToan(rs.getString("PhuongThucThanhToan"));
                list.add(o);
            }
        } catch (Exception e) { System.out.println("Lỗi getRecentOrders: " + e); }
        return list;
    }
}