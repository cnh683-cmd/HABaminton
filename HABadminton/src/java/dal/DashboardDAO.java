package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import model.Order;
import model.SanPham;

public class DashboardDAO extends DBContext {

    // 1. Tổng doanh thu tháng hiện tại
    public double getMonthlyRevenue() {
        String sql = "SELECT SUM(TongTien) AS Total FROM DONHANG WHERE MONTH(NgayDat) = MONTH(GETDATE()) AND YEAR(NgayDat) = YEAR(GETDATE())";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            if (rs.next()) return rs.getDouble("Total");
        } catch (Exception e) { System.out.println("Lỗi getMonthlyRevenue: " + e); }
        return 0;
    }

    // 2. Số đơn chờ xác nhận (Giả sử TrangThai = 1 là chờ xử lý)
    public int getPendingOrdersCount() {
        String sql = "SELECT COUNT(*) AS Count FROM DONHANG WHERE TrangThai = 1";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            if (rs.next()) return rs.getInt("Count");
        } catch (Exception e) { System.out.println("Lỗi getPendingOrdersCount: " + e); }
        return 0;
    }

    // 3. Tổng số khách hàng
    public int getTotalUsers() {
        String sql = "SELECT COUNT(*) AS Count FROM TAIKHOAN WHERE Role = 0";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            if (rs.next()) return rs.getInt("Count");
        } catch (Exception e) { System.out.println("Lỗi getTotalUsers: " + e); }
        return 0;
    }

    // 4. Số sản phẩm sắp hết hàng (Tồn kho dưới 5)
    public int getLowStockCount() {
        String sql = "SELECT COUNT(*) AS Count FROM SANPHAM WHERE SoLuong < 5 AND TrangThai = 1";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            if (rs.next()) return rs.getInt("Count");
        } catch (Exception e) { System.out.println("Lỗi getLowStockCount: " + e); }
        return 0;
    }

    // 5. Doanh thu 12 tháng của 1 năm (Dùng để vẽ biểu đồ)
    public List<Double> getRevenueByMonth(int year) {
        // Khởi tạo mảng 12 tháng với giá trị 0
        Double[] months = new Double[]{0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
        String sql = "SELECT MONTH(NgayDat) AS Thang, SUM(TongTien) AS DoanhThu FROM DONHANG "
                   + "WHERE YEAR(NgayDat) = ? GROUP BY MONTH(NgayDat)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, year);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                int monthIndex = rs.getInt("Thang") - 1; // Index mảng từ 0-11
                months[monthIndex] = rs.getDouble("DoanhThu");
            }
        } catch (Exception e) { System.out.println("Lỗi getRevenueByMonth: " + e); }
        return Arrays.asList(months);
    }

    // 6. Lấy 5 đơn hàng mới nhất
    public List<Order> getRecentOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT TOP 5 * FROM DONHANG ORDER BY NgayDat DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Order o = new Order();
                o.setMaDonHang(rs.getString("MaDonHang"));
                o.setTenNguoiNhan(rs.getString("TenNguoiNhan"));
                o.setTongTien(rs.getInt("TongTien"));
                o.setTrangThai(rs.getInt("TrangThai"));
                // Giả định order của bạn có hàm setNgayDat
                list.add(o);
            }
        } catch (Exception e) { System.out.println("Lỗi getRecentOrders: " + e); }
        return list;
    }
}