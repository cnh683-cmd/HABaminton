package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import model.SanPham;

public class SanPhamDAO extends DBContext {

    public List<SanPham> getAllSanPham() {
        List<SanPham> list = new ArrayList<>();
        String sql = "SELECT * FROM SANPHAM";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(new SanPham(
                        rs.getInt("MaSP"), rs.getString("TenSP"), rs.getDouble("GiaGoc"),
                        rs.getDouble("GiaBan"), rs.getString("HinhAnh"), rs.getInt("MaDM"),
                        rs.getInt("MaTH"), rs.getBoolean("SanPhamMoi"), rs.getBoolean("BanChay"),
                        rs.getString("NgayTao"), rs.getString("MoTa")
                ));
            }
        } catch (Exception e) {
            System.out.println("Lỗi getAllSanPham: " + e.getMessage());
        }
        return list;
    }

    public List<SanPham> getFilteredProducts(String maDM, String brandId, String sort, String keyword, Double minPrice, Double maxPrice) {
        List<SanPham> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM SANPHAM WHERE MaDM = ? AND ISNULL(TrangThai, 1) = 1");
        
        Integer parsedBrandId = null;
        if (brandId != null && !brandId.trim().isEmpty()) {
            try {
                parsedBrandId = Integer.parseInt(brandId);
                sql.append(" AND MaTH = ?");
            } catch (NumberFormatException ignored) {}
        }
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND TenSP LIKE ?");
        }
        if (minPrice != null) {
            sql.append(" AND GiaBan >= ?");
        }
        if (maxPrice != null) {
            sql.append(" AND GiaBan <= ?");
        }
        
        if (sort != null) {
            switch (sort) {
                case "newest": sql.append(" ORDER BY MaSP DESC"); break;
                case "price_asc": sql.append(" ORDER BY GiaBan ASC"); break;
                case "price_desc": sql.append(" ORDER BY GiaBan DESC"); break;
                default: sql.append(" ORDER BY MaSP ASC"); break; 
            }
        } else {
            sql.append(" ORDER BY MaSP ASC");
        }

        try {
            PreparedStatement st = connection.prepareStatement(sql.toString());
            int index = 1;
            st.setString(index++, maDM);
            
            if (parsedBrandId != null) {
                st.setInt(index++, parsedBrandId);
            }
            if (keyword != null && !keyword.trim().isEmpty()) {
                st.setString(index++, "%" + keyword.trim() + "%");
            }
            if (minPrice != null) {
                st.setDouble(index++, minPrice);
            }
            if (maxPrice != null) {
                st.setDouble(index++, maxPrice);
            }
            
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(new SanPham(
                        rs.getInt("MaSP"), rs.getString("TenSP"), rs.getDouble("GiaGoc"),
                        rs.getDouble("GiaBan"), rs.getString("HinhAnh"), rs.getInt("MaDM"),
                        rs.getInt("MaTH"), rs.getBoolean("SanPhamMoi"), rs.getBoolean("BanChay"),
                        rs.getString("NgayTao"), rs.getString("MoTa")
                ));
            }
        } catch (Exception e) {
            System.out.println("Lỗi getFilteredProducts: " + e.getMessage());
        }
        return list;
    }

    public SanPham getProductById(String id) {
        String sql = "SELECT * FROM SANPHAM WHERE MaSP = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new SanPham(
                        rs.getInt("MaSP"), rs.getString("TenSP"), rs.getDouble("GiaGoc"),
                        rs.getDouble("GiaBan"), rs.getString("HinhAnh"), rs.getInt("MaDM"),
                        rs.getInt("MaTH"), rs.getBoolean("SanPhamMoi"), rs.getBoolean("BanChay"),
                        rs.getString("NgayTao"), rs.getString("MoTa")
                );
            }
        } catch (Exception e) {
            System.out.println("Lỗi getProductById: " + e.getMessage());
        }
        return null;
    }

    public List<SanPham> getRelatedProducts(int maDM, int currentProductId) {
        List<SanPham> list = new ArrayList<>();
        String sql = "SELECT TOP 10 * FROM SANPHAM WHERE MaDM = ? AND MaSP != ? AND ISNULL(TrangThai, 1) = 1 ORDER BY NEWID()";  
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, maDM);
            st.setInt(2, currentProductId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(new SanPham(
                        rs.getInt("MaSP"), rs.getString("TenSP"), rs.getDouble("GiaGoc"),
                        rs.getDouble("GiaBan"), rs.getString("HinhAnh"), rs.getInt("MaDM"),
                        rs.getInt("MaTH"), rs.getBoolean("SanPhamMoi"), rs.getBoolean("BanChay"),
                        rs.getString("NgayTao"), rs.getString("MoTa")
                ));
            }
        } catch (Exception e) {
            System.out.println("Lỗi getRelatedProducts: " + e.getMessage());
        }
        return list;
    }

    // ======================================================================
    // CÁC HÀM DÀNH CHO QUẢN TRỊ VIÊN (ADMIN) - QUẢN LÝ SẢN PHẨM
    // ======================================================================

    /** Đọc đầy đủ 1 dòng SANPHAM (kể cả các cột mới thêm) */
    private SanPham mapFull(ResultSet rs) throws Exception {
        SanPham sp = new SanPham(
                rs.getInt("MaSP"), rs.getString("TenSP"), rs.getDouble("GiaGoc"),
                rs.getDouble("GiaBan"), rs.getString("HinhAnh"), rs.getInt("MaDM"),
                rs.getInt("MaTH"), rs.getBoolean("SanPhamMoi"), rs.getBoolean("BanChay"),
                rs.getString("NgayTao"), rs.getString("MoTa")
        );
        try { sp.setXuatXu(rs.getString("XuatXu")); } catch (Exception ignored) {}
        try { sp.setThongSo(rs.getString("ThongSo")); } catch (Exception ignored) {}
        try { sp.setSoLuong(rs.getInt("SoLuong")); } catch (Exception ignored) {}
        try {
            // TrangThai NULL (dữ liệu cũ) được hiểu là đang bán
            Object tt = rs.getObject("TrangThai");
            sp.setTrangThai(tt == null ? 1 : rs.getInt("TrangThai"));
        } catch (Exception ignored) {}
        try { sp.setDaBan(rs.getInt("DaBan")); } catch (Exception ignored) {}
        return sp;
    }

    /** Danh sách sản phẩm cho admin, có lọc theo từ khóa / danh mục / thương hiệu / trạng thái / tồn kho */
    public List<SanPham> searchAdminProducts(String keyword, String maDM, String maTH, String status, String stock, String sort) {
        List<SanPham> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT s.*, ISNULL(b.DaBan, 0) AS DaBan FROM SANPHAM s "
              + "LEFT JOIN (SELECT TRY_CAST(c.MaSP AS INT) AS MaSP, SUM(c.SoLuong) AS DaBan "
              + "           FROM ChiTietDonHang c JOIN DonHang d ON c.MaDonHang = d.MaDonHang "
              + "           WHERE d.TrangThai <> 0 GROUP BY TRY_CAST(c.MaSP AS INT)) b ON b.MaSP = s.MaSP "
              + "WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (s.TenSP LIKE ? OR CAST(s.MaSP AS VARCHAR(20)) = ?) ");
            params.add("%" + keyword.trim() + "%");
            params.add(keyword.trim());
        }
        if (maDM != null && !maDM.isEmpty() && !"all".equals(maDM)) {
            sql.append(" AND s.MaDM = ? ");
            params.add(Integer.parseInt(maDM));
        }
        if (maTH != null && !maTH.isEmpty() && !"all".equals(maTH)) {
            sql.append(" AND s.MaTH = ? ");
            params.add(Integer.parseInt(maTH));
        }
        if (status != null && !status.isEmpty() && !"all".equals(status)) {
            sql.append(" AND ISNULL(s.TrangThai, 1) = ? ");
            params.add(Integer.parseInt(status));
        }
        if ("low".equals(stock)) {
            sql.append(" AND s.SoLuong > 0 AND s.SoLuong < 5 ");
        } else if ("out".equals(stock)) {
            sql.append(" AND s.SoLuong <= 0 ");
        }

        if (sort == null) sort = "";
        switch (sort) {
            case "price_asc":  sql.append(" ORDER BY s.GiaBan ASC"); break;
            case "price_desc": sql.append(" ORDER BY s.GiaBan DESC"); break;
            case "stock_asc":  sql.append(" ORDER BY s.SoLuong ASC"); break;
            case "best":       sql.append(" ORDER BY DaBan DESC"); break;
            case "oldest":     sql.append(" ORDER BY s.MaSP ASC"); break;
            default:           sql.append(" ORDER BY s.MaSP DESC"); break;
        }

        try {
            PreparedStatement st = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) st.setObject(i + 1, params.get(i));
            ResultSet rs = st.executeQuery();
            while (rs.next()) list.add(mapFull(rs));
        } catch (Exception e) {
            System.out.println("Lỗi searchAdminProducts: " + e.getMessage());
        }
        return list;
    }

    public SanPham getProductFullById(int maSP) {
        String sql = "SELECT * FROM SANPHAM WHERE MaSP = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, maSP);
            ResultSet rs = st.executeQuery();
            if (rs.next()) return mapFull(rs);
        } catch (Exception e) {
            System.out.println("Lỗi getProductFullById: " + e.getMessage());
        }
        return null;
    }

    public boolean insertProduct(SanPham sp) {
        String sql = "INSERT INTO SANPHAM (TenSP, GiaGoc, GiaBan, HinhAnh, MaDM, MaTH, SanPhamMoi, BanChay, NgayTao, MoTa, XuatXu, ThongSo, SoLuong, TrangThai) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), ?, ?, ?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, sp.getTenSP());
            st.setDouble(2, sp.getGiaGoc());
            st.setDouble(3, sp.getGiaBan());
            st.setString(4, sp.getHinhAnh());
            st.setInt(5, sp.getMaDM());
            st.setInt(6, sp.getMaTH());
            st.setBoolean(7, sp.isSanPhamMoi());
            st.setBoolean(8, sp.isBanChay());
            st.setString(9, sp.getMoTa());
            st.setString(10, sp.getXuatXu());
            st.setString(11, sp.getThongSo());
            st.setInt(12, sp.getSoLuong());
            st.setInt(13, sp.getTrangThai());
            return st.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Lỗi insertProduct: " + e.getMessage());
        }
        return false;
    }

    public boolean updateProduct(SanPham sp) {
        String sql = "UPDATE SANPHAM SET TenSP = ?, GiaGoc = ?, GiaBan = ?, HinhAnh = ?, MaDM = ?, MaTH = ?, SanPhamMoi = ?, BanChay = ?, "
                   + "MoTa = ?, XuatXu = ?, ThongSo = ?, SoLuong = ?, TrangThai = ? WHERE MaSP = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, sp.getTenSP());
            st.setDouble(2, sp.getGiaGoc());
            st.setDouble(3, sp.getGiaBan());
            st.setString(4, sp.getHinhAnh());
            st.setInt(5, sp.getMaDM());
            st.setInt(6, sp.getMaTH());
            st.setBoolean(7, sp.isSanPhamMoi());
            st.setBoolean(8, sp.isBanChay());
            st.setString(9, sp.getMoTa());
            st.setString(10, sp.getXuatXu());
            st.setString(11, sp.getThongSo());
            st.setInt(12, sp.getSoLuong());
            st.setInt(13, sp.getTrangThai());
            st.setInt(14, sp.getMaSP());
            return st.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Lỗi updateProduct: " + e.getMessage());
        }
        return false;
    }

    public boolean updateProductStatus(int maSP, int trangThai) {
        String sql = "UPDATE SANPHAM SET TrangThai = ? WHERE MaSP = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, trangThai);
            st.setInt(2, maSP);
            return st.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Lỗi updateProductStatus: " + e.getMessage());
        }
        return false;
    }

    public boolean updateStock(int maSP, int soLuong) {
        String sql = "UPDATE SANPHAM SET SoLuong = ? WHERE MaSP = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, Math.max(0, soLuong));
            st.setInt(2, maSP);
            return st.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Lỗi updateStock: " + e.getMessage());
        }
        return false;
    }

    /**
     * Xóa sản phẩm. Nếu sản phẩm đã có đánh giá / dữ liệu ràng buộc khóa ngoại
     * thì không thể xóa cứng -> trả về false để servlet chuyển sang "ngừng bán".
     */
    public boolean deleteProduct(int maSP) {
        String sql = "DELETE FROM SANPHAM WHERE MaSP = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, maSP);
            return st.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Lỗi deleteProduct (có thể do ràng buộc khóa ngoại): " + e.getMessage());
        }
        return false;
    }

    /** Trừ tồn kho khi có đơn hàng mới (không cho âm) */
    public void decreaseStock(String maSP, int qty) {
        String sql = "UPDATE SANPHAM SET SoLuong = CASE WHEN SoLuong - ? < 0 THEN 0 ELSE SoLuong - ? END WHERE MaSP = TRY_CAST(? AS INT)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, qty);
            st.setInt(2, qty);
            st.setString(3, maSP);
            st.executeUpdate();
        } catch (Exception e) {
            System.out.println("Lỗi decreaseStock: " + e.getMessage());
        }
    }

    // ------------------- DANH MỤC & THƯƠNG HIỆU -------------------
    // Ưu tiên đọc từ bảng DANHMUC / THUONGHIEU nếu CSDL có, nếu không dùng danh sách mặc định
    // (khớp với menu trong header.jsp).

    public Map<Integer, String> getCategoryMap() {
        Map<Integer, String> map = readLookup("SELECT MaDM AS Ma, TenDM AS Ten FROM DANHMUC ORDER BY MaDM");
        if (!map.isEmpty()) return map;
        map.put(1, "Vợt cầu lông");
        map.put(2, "Giày cầu lông");
        map.put(3, "Áo cầu lông");
        map.put(4, "Quần cầu lông");
        map.put(5, "Váy cầu lông");
        map.put(6, "Túi vợt cầu lông");
        map.put(7, "Balo cầu lông");
        map.put(8, "Túi đựng giày");
        map.put(9, "Phụ kiện");
        return map;
    }

    public Map<Integer, String> getBrandMap() {
        Map<Integer, String> map = readLookup("SELECT MaTH AS Ma, TenTH AS Ten FROM THUONGHIEU ORDER BY MaTH");
        if (!map.isEmpty()) return map;
        String[] names = {"Yonex", "Victor", "Lining", "VS", "Mizuno", "Kawasaki", "VNB", "Kamito", "Victec", "Donex Pro", "SFD", "Flypower"};
        for (int i = 0; i < names.length; i++) map.put(i + 1, names[i]);
        return map;
    }

    private Map<Integer, String> readLookup(String sql) {
        Map<Integer, String> map = new LinkedHashMap<>();
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) map.put(rs.getInt("Ma"), rs.getString("Ten"));
        } catch (Exception ignored) {
            // Bảng không tồn tại -> dùng dữ liệu mặc định
        }
        return map;
    }
}
