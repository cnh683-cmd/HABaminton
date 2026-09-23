package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Order;
import model.OrderDetail;

public class OrderDAO extends DBContext {
    
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
                od.setHinhAnh(rs.getString("HinhAnh")); 
                od.setMaSP(rs.getString("MaSP")); 
                
                list.add(od);
            }
        } catch(Exception e) { 
            e.printStackTrace(); 
        }
        return list;
    }

    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        // SỬ DỤNG LEFT JOIN ĐỂ LẤY THÊM AVATAR TỪ BẢNG TAIKHOAN
        String sql = "SELECT d.*, t.Avatar FROM DonHang d LEFT JOIN TAIKHOAN t ON d.EmailKhachHang = t.Email ORDER BY NgayDat DESC";
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
                // GÁN AVATAR CHO ĐƠN HÀNG
                order.setAvatar(rs.getString("Avatar"));
                order.setChiTietList(getOrderDetails(order.getMaDonHang()));
                
                list.add(order); 
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Order getOrderById(String maDonHang) {
        String sql = "SELECT d.*, t.Avatar FROM DonHang d LEFT JOIN TAIKHOAN t ON d.EmailKhachHang = t.Email WHERE d.MaDonHang = ?";
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
                order.setLyDoHuy(rs.getString("LyDoHuy"));
                order.setGhiChu(rs.getString("GhiChu")); 
                order.setAvatar(rs.getString("Avatar"));
                order.setChiTietList(getOrderDetails(order.getMaDonHang()));
                
                return order;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Order> getOrdersByEmail(String email) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT d.*, t.Avatar FROM DonHang d LEFT JOIN TAIKHOAN t ON d.EmailKhachHang = t.Email WHERE d.EmailKhachHang = ? ORDER BY NgayDat DESC";
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
                order.setLyDoHuy(rs.getString("LyDoHuy"));
                order.setGhiChu(rs.getString("GhiChu"));
                order.setUserDaXem(rs.getInt("UserDaXem"));
                order.setAvatar(rs.getString("Avatar"));
                order.setChiTietList(getOrderDetails(order.getMaDonHang()));
                
                list.add(order);
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return list;
    }
    
    public void insertOrder(Order order) {
        String sql = "INSERT INTO DonHang (MaDonHang, TenNguoiNhan, SDT, DiaChi, TongTien, PhuongThucThanhToan, TrangThai, NgayDat, EmailKhachHang, MaVoucher, GhiChu) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE(), ?, ?, ?)";
        try {
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
            st.setString(10, order.getGhiChu()); 
            st.executeUpdate();
            
            if (order.getChiTietList() != null && !order.getChiTietList().isEmpty()) {
                String sqlDetail = "INSERT INTO ChiTietDonHang (MaDonHang, MaSP, TenSP, SoLuong, GiaMua, HinhAnh) VALUES (?, ?, ?, ?, ?, ?)";
                PreparedStatement stDetail = connection.prepareStatement(sqlDetail);
                for (OrderDetail item : order.getChiTietList()) {
                    stDetail.setString(1, order.getMaDonHang());
                    stDetail.setString(2, item.getMaSP());
                    stDetail.setString(3, item.getTenSP());
                    stDetail.setInt(4, item.getSoLuong());
                    stDetail.setInt(5, item.getGiaMua());
                    stDetail.setString(6, item.getHinhAnh()); 
                    stDetail.executeUpdate();
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public boolean updateOrderStatus(String maDonHang, int trangThai) {
        String sql = "";
        
        switch (trangThai) {
            case 2: // Đang giao
                sql = "UPDATE DonHang SET TrangThai = ?, NgayTiepNhan = GETDATE(), UserDaXem = 0 WHERE MaDonHang = ?";
                break;
            case 3: // Hoàn thành
                sql = "UPDATE DonHang SET TrangThai = ?, NgayGiaoVan = GETDATE(), UserDaXem = 0 WHERE MaDonHang = ?";
                break;
            case 4: // Đã tiếp nhận
                sql = "UPDATE DonHang SET TrangThai = ?, NgayNhanHang = GETDATE(), UserDaXem = 0 WHERE MaDonHang = ?";
                break;
            default: // Các trạng thái khác (Chờ xử lý, Đã hủy)
                sql = "UPDATE DonHang SET TrangThai = ?, UserDaXem = 0 WHERE MaDonHang = ?";
                break;
        }
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, trangThai);
            st.setString(2, maDonHang);
            int row = st.executeUpdate();
            return row > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public List<Order> searchAdminOrders(String keyword, String status) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT d.*, t.Avatar FROM DonHang d LEFT JOIN TAIKHOAN t ON d.EmailKhachHang = t.Email WHERE 1=1 ";
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND (d.MaDonHang LIKE ? OR d.TenNguoiNhan LIKE ? OR d.SDT LIKE ?) ";
        }
        if (status != null && !status.isEmpty() && !status.equals("all")) {
            sql += " AND d.TrangThai = ? ";
        }
        sql += " ORDER BY d.NgayDat DESC";
        
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
                order.setLyDoHuy(rs.getString("LyDoHuy"));
                order.setAvatar(rs.getString("Avatar"));
                order.setChiTietList(getOrderDetails(order.getMaDonHang()));
                
                list.add(order);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

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

    public void markUserAsRead(String maDonHang) {
        String sql = "UPDATE DonHang SET UserDaXem = 1 WHERE MaDonHang = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, maDonHang);
            st.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public void cancelOrder(String maDonHang, String lyDoHuy) {
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