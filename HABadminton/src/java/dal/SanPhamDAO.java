package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
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
        StringBuilder sql = new StringBuilder("SELECT * FROM SANPHAM WHERE MaDM = ?");
        
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
        String sql = "SELECT TOP 10 * FROM SANPHAM WHERE MaDM = ? AND MaSP != ? ORDER BY NEWID()";  
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
}