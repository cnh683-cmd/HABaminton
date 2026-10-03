package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.User;

public class UserDAO extends DBContext {
    
    public boolean registerUser(String fullname, String email, String password) {
        String sql = "INSERT INTO TAIKHOAN (HoTen, Email, MatKhau) VALUES (?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, fullname);
            st.setString(2, email);
            st.setString(3, password);
            st.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public User checkLogin(String email, String password) {
        String sql = "SELECT * FROM TAIKHOAN WHERE Email = ? AND MatKhau = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, email);
            st.setString(2, password);
            ResultSet rs = st.executeQuery();
            
            if (rs.next()) {
                User user = new User(
                    rs.getString("HoTen"),
                    rs.getString("Email"),
                    rs.getString("SDT"),
                    rs.getString("DiaChi"),
                    rs.getString("QuanHuyen"),
                    rs.getString("TinhThanh")
                );
                
                user.setRole(rs.getInt("Role")); 
                
                // BỔ SUNG: LẤY ẢNH ĐẠI DIỆN TỪ DATABASE GÁN VÀO USER
                user.setAvatar(rs.getString("Avatar")); 
                
                // BỔ SUNG: TRẠNG THÁI TÀI KHOẢN (1: hoạt động, 0: bị khóa)
                try {
                    // TrangThai NULL (dữ liệu cũ) được hiểu là đang hoạt động
                    Object tt = rs.getObject("TrangThai");
                    user.setTrangThai(tt == null ? 1 : rs.getInt("TrangThai"));
                } catch (Exception ignored) {}
                
                return user;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void updateProfile(User user) {
        // BỔ SUNG: THÊM 'Avatar = ?' VÀO CÂU LỆNH SQL
        String sql = "UPDATE TAIKHOAN SET HoTen = ?, SDT = ?, DiaChi = ?, QuanHuyen = ?, TinhThanh = ?, Avatar = ? WHERE Email = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, user.getHoTen());
            st.setString(2, user.getSdt());
            st.setString(3, user.getDiaChi());
            st.setString(4, user.getQuanHuyen());
            st.setString(5, user.getTinhThanh());
            
            // BỔ SUNG: TRUYỀN DỮ LIỆU AVATAR VÀO SQL
            st.setString(6, user.getAvatar());
            st.setString(7, user.getEmail()); // Email bị đẩy xuống vị trí số 7
            
            st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ======================================================================
    // CÁC HÀM DÀNH CHO QUẢN TRỊ VIÊN (ADMIN) - QUẢN LÝ TÀI KHOẢN
    // ======================================================================

    private User mapUser(ResultSet rs) throws Exception {
        User u = new User(
            rs.getString("HoTen"), rs.getString("Email"), rs.getString("SDT"),
            rs.getString("DiaChi"), rs.getString("QuanHuyen"), rs.getString("TinhThanh")
        );
        u.setRole(rs.getInt("Role"));
        u.setAvatar(rs.getString("Avatar"));
        try {
            Object tt = rs.getObject("TrangThai");
            u.setTrangThai(tt == null ? 1 : rs.getInt("TrangThai"));
        } catch (Exception ignored) {}
        try { u.setNgayTao(rs.getTimestamp("NgayTao")); } catch (Exception ignored) {}
        try { u.setSoDonHang(rs.getInt("SoDonHang")); } catch (Exception ignored) {}
        try { u.setTongChiTieu(rs.getLong("TongChiTieu")); } catch (Exception ignored) {}
        return u;
    }

    /** Danh sách tài khoản kèm số đơn & tổng chi tiêu (không tính đơn hủy) */
    public List<User> searchUsers(String keyword, String role, String status) {
        List<User> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
              "SELECT t.*, ISNULL(d.SoDonHang, 0) AS SoDonHang, ISNULL(d.TongChiTieu, 0) AS TongChiTieu "
            + "FROM TAIKHOAN t "
            + "LEFT JOIN (SELECT EmailKhachHang, COUNT(*) AS SoDonHang, "
            + "                  SUM(CASE WHEN TrangThai <> 0 THEN CAST(TongTien AS BIGINT) ELSE 0 END) AS TongChiTieu "
            + "           FROM DonHang GROUP BY EmailKhachHang) d ON d.EmailKhachHang = t.Email "
            + "WHERE 1=1 ");
        List<Object> params = new ArrayList<>();
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (t.HoTen LIKE ? OR t.Email LIKE ? OR t.SDT LIKE ?) ");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw); params.add(kw); params.add(kw);
        }
        if (role != null && !role.isEmpty() && !"all".equals(role)) {
            sql.append(" AND t.Role = ? ");
            params.add(Integer.parseInt(role));
        }
        if (status != null && !status.isEmpty() && !"all".equals(status)) {
            sql.append(" AND ISNULL(t.TrangThai, 1) = ? ");
            params.add(Integer.parseInt(status));
        }
        sql.append(" ORDER BY t.Role DESC, t.HoTen ASC");
        try {
            PreparedStatement st = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) st.setObject(i + 1, params.get(i));
            ResultSet rs = st.executeQuery();
            while (rs.next()) list.add(mapUser(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public User getUserByEmail(String email) {
        String sql = "SELECT * FROM TAIKHOAN WHERE Email = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, email);
            ResultSet rs = st.executeQuery();
            if (rs.next()) return mapUser(rs);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean emailExists(String email) {
        return getUserByEmail(email) != null;
    }

    /** Admin tạo tài khoản mới (khách hàng hoặc quản trị viên) */
    public boolean insertUserByAdmin(User u, String password) {
        String sql = "INSERT INTO TAIKHOAN (HoTen, Email, MatKhau, SDT, DiaChi, Role, TrangThai) VALUES (?, ?, ?, ?, ?, ?, 1)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, u.getHoTen());
            st.setString(2, u.getEmail());
            st.setString(3, password);
            st.setString(4, u.getSdt());
            st.setString(5, u.getDiaChi());
            st.setInt(6, u.getRole());
            return st.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Admin cập nhật thông tin cơ bản */
    public boolean updateUserByAdmin(User u) {
        String sql = "UPDATE TAIKHOAN SET HoTen = ?, SDT = ?, DiaChi = ?, QuanHuyen = ?, TinhThanh = ?, Role = ? WHERE Email = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, u.getHoTen());
            st.setString(2, u.getSdt());
            st.setString(3, u.getDiaChi());
            st.setString(4, u.getQuanHuyen());
            st.setString(5, u.getTinhThanh());
            st.setInt(6, u.getRole());
            st.setString(7, u.getEmail());
            return st.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateUserStatus(String email, int trangThai) {
        return executeSimple("UPDATE TAIKHOAN SET TrangThai = ? WHERE Email = ?", trangThai, email);
    }

    public boolean updateUserRole(String email, int role) {
        return executeSimple("UPDATE TAIKHOAN SET Role = ? WHERE Email = ?", role, email);
    }

    public boolean resetPassword(String email, String newPassword) {
        String sql = "UPDATE TAIKHOAN SET MatKhau = ? WHERE Email = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, newPassword);
            st.setString(2, email);
            return st.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Xóa tài khoản. Trả về false nếu bị ràng buộc dữ liệu (đã có đánh giá, ...) */
    public boolean deleteUser(String email) {
        String sql = "DELETE FROM TAIKHOAN WHERE Email = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, email);
            return st.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Lỗi deleteUser (có thể do ràng buộc khóa ngoại): " + e.getMessage());
        }
        return false;
    }

    private boolean executeSimple(String sql, int value, String email) {
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, value);
            st.setString(2, email);
            return st.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
