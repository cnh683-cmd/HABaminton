package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Order;
import model.OrderDetail;

public class OrderDAO extends DBContext {
    
    // Lấy danh sách sản phẩm của 1 đơn hàng (BỔ SUNG LẤY ẢNH)
    public List<OrderDetail> getOrderDetails(String maDonHang) {
        List<OrderDetail> list = new ArrayList<>();
        String sql = "SELECT * FROM ChiTietDonHang WHERE MaDonHang = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, maDonHang);
            ResultSet rs = st.executeQuery();
            while(rs.next()) {
                OrderDetail od = new OrderDetail(
                    rs.getString("TenSP"),
                    rs.getInt("SoLuong"),
                    rs.getInt("GiaMua")
                );
                od.setHinhAnh(rs.getString("HinhAnh")); // Bốc ảnh từ CSDL
                list.add(od);
            }
        } catch(Exception e) { 
            e.printStackTrace(); 
        }
        return list;
    }

   // Lấy toàn bộ đơn hàng (BỔ SUNG LẤY VOUCHER)
    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM DonHang ORDER BY NgayDat DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Order order = new Order(
                    rs.getString("MaDonHang"),
                    rs.getString("TenNguoiNhan"),
                    rs.getString("SDT"),
                    rs.getString("DiaChi"),
                    rs.getInt("TongTien"),
                    rs.getString("PhuongThucThanhToan"),
                    rs.getInt("TrangThai"),
                    rs.getTimestamp("NgayDat"),
                    rs.getTimestamp("NgayTiepNhan"),
                    rs.getTimestamp("NgayGiaoVan"),
                    rs.getTimestamp("NgayNhanHang")
                );
                order.setEmailKhachHang(rs.getString("EmailKhachHang"));
                order.setMaVoucher(rs.getString("MaVoucher"));
                order.setLyDoHuy(rs.getString("LyDoHuy"));
                
                order.setGhiChu(rs.getString("GhiChu")); 
                
                order.setChiTietList(getOrderDetails(order.getMaDonHang()));
                
                list.add(order); 
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy chi tiết 1 đơn hàng theo Mã (BỔ SUNG LẤY VOUCHER)
    public Order getOrderById(String maDonHang) {
        String sql = "SELECT * FROM DonHang WHERE MaDonHang = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, maDonHang);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                Order order = new Order(
                    rs.getString("MaDonHang"),
                    rs.getString("TenNguoiNhan"),
                    rs.getString("SDT"),
                    rs.getString("DiaChi"),
                    rs.getInt("TongTien"),
                    rs.getString("PhuongThucThanhToan"),
                    rs.getInt("TrangThai"),
                    rs.getTimestamp("NgayDat"),
                    rs.getTimestamp("NgayTiepNhan"),
                    rs.getTimestamp("NgayGiaoVan"),
                    rs.getTimestamp("NgayNhanHang")
                );
                order.setEmailKhachHang(rs.getString("EmailKhachHang"));
                order.setMaVoucher(rs.getString("MaVoucher"));
                order.setChiTietList(getOrderDetails(order.getMaDonHang()));
                order.setLyDoHuy(rs.getString("LyDoHuy"));
                
                // ĐÃ FIX: Lấy Ghi chú từ Database ra
                order.setGhiChu(rs.getString("GhiChu")); 
                
                return order;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Hàm lấy danh sách đơn hàng theo Email người dùng (BỔ SUNG LẤY VOUCHER)
    public List<Order> getOrdersByEmail(String email) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM DonHang WHERE EmailKhachHang = ? ORDER BY NgayDat DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, email);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Order order = new Order(
                    rs.getString("MaDonHang"), rs.getString("TenNguoiNhan"), rs.getString("SDT"),
                    rs.getString("DiaChi"), rs.getInt("TongTien"), rs.getString("PhuongThucThanhToan"),
                    rs.getInt("TrangThai"), rs.getTimestamp("NgayDat"), rs.getTimestamp("NgayTiepNhan"),
                    rs.getTimestamp("NgayGiaoVan"), rs.getTimestamp("NgayNhanHang")
                );
                order.setEmailKhachHang(rs.getString("EmailKhachHang"));
                order.setMaVoucher(rs.getString("MaVoucher"));
                order.setChiTietList(getOrderDetails(order.getMaDonHang()));
                order.setGhiChu(rs.getString("GhiChu"));
                order.setUserDaXem(rs.getInt("UserDaXem"));
                order.setLyDoHuy(rs.getString("LyDoHuy"));
                list.add(order);
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return list;
    }
    
    // Thêm đơn hàng mới và sản phẩm vào Database (BỔ SUNG LƯU GHI CHÚ)
    public void insertOrder(Order order) {
        // ĐÃ FIX: Thêm cột GhiChu vào câu lệnh INSERT và thêm 1 dấu ? vào VALUES
        String sql = "INSERT INTO DonHang (MaDonHang, TenNguoiNhan, SDT, DiaChi, TongTien, PhuongThucThanhToan, TrangThai, NgayDat, EmailKhachHang, MaVoucher, GhiChu) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE(), ?, ?, ?)";
        try {
            // 1. Lưu thông tin chung đơn hàng
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, order.getMaDonHang());
            st.setString(2, order.getTenNguoiNhan());
            st.setString(3, order.getSdt());
            st.setString(4, order.getDiaChi());
            st.setInt(5, order.getTongTien());
            st.setString(6, order.getPhuongThucThanhToan());
            st.setInt(7, order.getTrangThai());
            st.setString(8, order.getEmailKhachHang());
            st.setString(9, order.getMaVoucher()); 
            
            // ĐÃ FIX: Bổ sung tham số thứ 10 để lưu Ghi Chú
            st.setString(10, order.getGhiChu()); 
            
            st.executeUpdate();
            
            // 2. Lưu chi tiết sản phẩm
            if (order.getChiTietList() != null && !order.getChiTietList().isEmpty()) {
                String sqlDetail = "INSERT INTO ChiTietDonHang (MaDonHang, TenSP, SoLuong, GiaMua, HinhAnh) VALUES (?, ?, ?, ?, ?)";
                PreparedStatement stDetail = connection.prepareStatement(sqlDetail);
                for (OrderDetail item : order.getChiTietList()) {
                    stDetail.setString(1, order.getMaDonHang());
                    stDetail.setString(2, item.getTenSP());
                    stDetail.setInt(3, item.getSoLuong());
                    stDetail.setInt(4, item.getGiaMua());
                    stDetail.setString(5, item.getHinhAnh()); 
                    stDetail.executeUpdate();
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    // Cập nhật trạng thái đơn hàng và kích hoạt lại thông báo cho Khách hàng
    public void updateOrderStatus(String maDonHang, int trangThai) {
        String sql = "";
        
        // Bổ sung "UserDaXem = 0" vào tất cả các câu lệnh UPDATE
        switch (trangThai) {
            case 2: // Đã tiếp nhận
                sql = "UPDATE DonHang SET TrangThai = ?, NgayTiepNhan = GETDATE(), UserDaXem = 0 WHERE MaDonHang = ?";
                break;
            case 3: // Đang giao hàng
                sql = "UPDATE DonHang SET TrangThai = ?, NgayGiaoVan = GETDATE(), UserDaXem = 0 WHERE MaDonHang = ?";
                break;
            case 4: // Đã giao hàng
                sql = "UPDATE DonHang SET TrangThai = ?, NgayNhanHang = GETDATE(), UserDaXem = 0 WHERE MaDonHang = ?";
                break;
            default: // Trạng thái 1 (Chờ xác nhận) hoặc 0 (Đã hủy)
                sql = "UPDATE DonHang SET TrangThai = ?, UserDaXem = 0 WHERE MaDonHang = ?";
                break;
        }
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, trangThai);
            st.setString(2, maDonHang);
            st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    // Tìm kiếm và lọc đơn hàng Admin
    public List<Order> searchAdminOrders(String keyword, String status) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM DonHang WHERE 1=1 ";
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND (MaDonHang LIKE ? OR TenNguoiNhan LIKE ? OR SDT LIKE ?) ";
        }
        if (status != null && !status.isEmpty() && !status.equals("all")) {
            sql += " AND TrangThai = ? ";
        }
        sql += " ORDER BY NgayDat DESC";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            int paramIndex = 1;
            
            if (keyword != null && !keyword.trim().isEmpty()) {
                String searchKey = "%" + keyword + "%";
                st.setString(paramIndex++, searchKey);
                st.setString(paramIndex++, searchKey);
                st.setString(paramIndex++, searchKey);
            }
            if (status != null && !status.isEmpty() && !status.equals("all")) {
                st.setInt(paramIndex++, Integer.parseInt(status));
            }
            
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Order order = new Order(
                    rs.getString("MaDonHang"), rs.getString("TenNguoiNhan"), rs.getString("SDT"),
                    rs.getString("DiaChi"), rs.getInt("TongTien"), rs.getString("PhuongThucThanhToan"),
                    rs.getInt("TrangThai"), rs.getTimestamp("NgayDat"), rs.getTimestamp("NgayTiepNhan"),
                    rs.getTimestamp("NgayGiaoVan"), rs.getTimestamp("NgayNhanHang")
                );
                order.setMaVoucher(rs.getString("MaVoucher"));
                order.setGhiChu(rs.getString("GhiChu"));
                order.setChiTietList(getOrderDetails(order.getMaDonHang()));
                order.setLyDoHuy(rs.getString("LyDoHuy"));
                list.add(order);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // Xóa đơn hàng (Xóa chi tiết trước, xóa đơn sau)
    public boolean deleteOrder(String maDonHang) {
        try {
            PreparedStatement st1 = connection.prepareStatement("DELETE FROM ChiTietDonHang WHERE MaDonHang = ?");
            st1.setString(1, maDonHang);
            st1.executeUpdate();
            
            PreparedStatement st2 = connection.prepareStatement("DELETE FROM DonHang WHERE MaDonHang = ?");
            st2.setString(1, maDonHang);
            return st2.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }
    // Đánh dấu người dùng đã xem đơn hàng
    public void markUserAsRead(String maDonHang) {
        String sql = "UPDATE DonHang SET UserDaXem = 1 WHERE MaDonHang = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, maDonHang);
            st.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
    // Hàm hủy đơn hàng kèm lý do
    public void cancelOrder(String maDonHang, String lyDoHuy) {
        // Cập nhật TrangThai = 0 (Đã hủy), lưu lý do, và bật UserDaXem = 0 để báo chấm đỏ cho khách
        String sql = "UPDATE DonHang SET TrangThai = 0, LyDoHuy = ?, UserDaXem = 0 WHERE MaDonHang = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, lyDoHuy);
            st.setString(2, maDonHang);
            st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}