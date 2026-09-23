package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Review;

public class ReviewDAO extends DBContext {
    
    // 1. Thêm đánh giá mới (Giao diện User)
    public boolean insertReview(String maSP, String email, int soSao, String noiDung, boolean anDanh, String hinhAnh, String video) {
        String sql = "INSERT INTO DanhGia (MaSP, EmailKhachHang, SoSao, NoiDung, AnDanh, SoLuotThich, TrangThai, NgayDG, HinhAnh, Video) "
                   + "VALUES (?, ?, ?, ?, ?, 0, 1, GETDATE(), ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, maSP);
            st.setString(2, email);
            st.setInt(3, soSao);
            st.setString(4, noiDung);
            st.setBoolean(5, anDanh);
            st.setString(6, hinhAnh);
            st.setString(7, video);
            return st.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // 2. Lấy danh sách đánh giá của 1 sản phẩm (Giao diện User)
   public List<Review> getReviewsByProduct(String maSP) {
        List<Review> list = new ArrayList<>();
        // THÊM t.Avatar VÀO CÂU LỆNH SQL
        String sql = "SELECT d.*, t.HoTen AS TenKhachHang, t.Avatar "
                   + "FROM DanhGia d "
                   + "JOIN TAIKHOAN t ON d.EmailKhachHang = t.Email "
                   + "WHERE d.MaSP = ? AND d.TrangThai = 1 "
                   + "ORDER BY d.NgayDG DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, maSP);
            ResultSet rs = st.executeQuery();
            while(rs.next()) {
                Review r = new Review();
                r.setMaDG(rs.getInt("MaDG"));
                r.setMaSP(rs.getString("MaSP"));
                r.setEmailKhachHang(rs.getString("EmailKhachHang"));
                r.setTenKhachHang(rs.getString("TenKhachHang"));
                r.setSoSao(rs.getInt("SoSao"));
                r.setNoiDung(rs.getString("NoiDung"));
                r.setPhanHoiAdmin(rs.getString("PhanHoiAdmin"));
                r.setNgayDG(rs.getTimestamp("NgayDG"));
                r.setTrangThai(rs.getInt("TrangThai"));
                r.setAnDanh(rs.getBoolean("AnDanh"));
                r.setSoLuotThich(rs.getInt("SoLuotThich"));
                r.setHinhAnh(rs.getString("HinhAnh"));
                r.setVideo(rs.getString("Video"));
                
                // GÁN AVATAR VÀO OBJECT
                r.setAvatar(rs.getString("Avatar"));
                
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ======================================================================
    // CÁC HÀM DÀNH CHO QUẢN TRỊ VIÊN (ADMIN)
    // ======================================================================

    // 3. Lấy tất cả đánh giá kèm bộ lọc (Giao diện Admin)
    public List<Review> getAllReviewsForAdmin(String keyword, String star, String status) {
        List<Review> list = new ArrayList<>();
        // THÊM t.Avatar VÀO CÂU SELECT VÀ JOIN VỚI TAIKHOAN
        String sql = "SELECT d.*, t.HoTen AS TenKhachHang, t.Avatar, s.TenSP, s.HinhAnh AS HinhAnhSP "
                   + "FROM DanhGia d "
                   + "JOIN TAIKHOAN t ON d.EmailKhachHang = t.Email "
                   + "JOIN SanPham s ON d.MaSP = s.MaSP "
                   + "WHERE 1=1 ";
        
        // Lọc Keyword
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND (t.HoTen LIKE ? OR s.TenSP LIKE ? OR d.NoiDung LIKE ?) ";
        }
        
        if (star != null && !star.equals("all")) {
            sql += " AND d.SoSao = " + star;
        }
        
        if (status != null && !status.equals("all")) {
            if (status.equals("replied")) {
                sql += " AND d.PhanHoiAdmin IS NOT NULL AND DATALENGTH(d.PhanHoiAdmin) > 0 ";
            } else if (status.equals("unreplied")) {
                sql += " AND (d.PhanHoiAdmin IS NULL OR DATALENGTH(d.PhanHoiAdmin) = 0) ";
            }
        }
        sql += " ORDER BY d.NgayDG DESC";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            int paramIndex = 1;
            
            // Nếu có keyword thì set tham số
            if (keyword != null && !keyword.trim().isEmpty()) {
                String kw = "%" + keyword.trim() + "%";
                st.setString(paramIndex++, kw);
                st.setString(paramIndex++, kw);
                st.setString(paramIndex++, kw);
            }
            
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Review r = new Review();
                r.setMaDG(rs.getInt("MaDG"));
                r.setMaSP(rs.getString("MaSP"));
                r.setEmailKhachHang(rs.getString("EmailKhachHang"));
                r.setTenKhachHang(rs.getString("TenKhachHang"));
                r.setSoSao(rs.getInt("SoSao"));
                r.setNoiDung(rs.getString("NoiDung"));
                r.setPhanHoiAdmin(rs.getString("PhanHoiAdmin"));
                r.setNgayDG(rs.getTimestamp("NgayDG"));
                r.setTrangThai(rs.getInt("TrangThai"));
                r.setAnDanh(rs.getBoolean("AnDanh"));
                r.setHinhAnh(rs.getString("HinhAnh"));
                r.setVideo(rs.getString("Video"));
                
                // NẠP THÊM AVATAR CHO REVIEW
                try { r.setAvatar(rs.getString("Avatar")); } catch (Exception ignored) {}
                
                try { r.setTenSP(rs.getString("TenSP")); } catch (Exception ignored) {}
                try { r.setHinhAnhSP(rs.getString("HinhAnhSP")); } catch (Exception ignored) {}
                
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Hàm lưu phản hồi
    public boolean updateAdminReply(int reviewId, String replyText) {
        String sql = "UPDATE DanhGia SET PhanHoiAdmin = ? WHERE MaDG = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, replyText);
            st.setInt(2, reviewId);
            return st.executeUpdate() > 0;
        } catch (Exception e) {}
        return false;
    }

    // Hàm Đổi trạng thái Ẩn/Hiện (Cho nút Con Mắt)
    public boolean updateVisibility(int reviewId, int status) {
        String sql = "UPDATE DanhGia SET TrangThai = ? WHERE MaDG = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, status);
            st.setInt(2, reviewId);
            return st.executeUpdate() > 0;
        } catch (Exception e) {}
        return false;
    }

    // Hàm Xóa đánh giá vĩnh viễn
    public boolean deleteReview(int reviewId) {
        String sql = "DELETE FROM DanhGia WHERE MaDG = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, reviewId);
            return st.executeUpdate() > 0;
        } catch (Exception e) {}
        return false;
    }
}