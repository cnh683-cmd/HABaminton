package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.User;

public class UserDAO extends DBContext {
    
    // Đăng ký tài khoản mới
    public boolean registerUser(String fullname, String email, String password) {
        String sql = "INSERT INTO NguoiDung (HoTen, Email, MatKhau) VALUES (?, ?, ?)";
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

    // Kiểm tra đăng nhập
    public User checkLogin(String email, String password) {
        String sql = "SELECT * FROM NguoiDung WHERE Email = ? AND MatKhau = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, email);
            st.setString(2, password);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new User(
                    rs.getString("HoTen"),
                    rs.getString("Email"),
                    rs.getString("SDT"),
                    rs.getString("DiaChi"),
                    rs.getString("QuanHuyen"),
                    rs.getString("TinhThanh")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null; // Sai tài khoản hoặc mật khẩu
    }

    // Cập nhật hồ sơ cá nhân
    public void updateProfile(User user) {
        String sql = "UPDATE NguoiDung SET HoTen = ?, SDT = ?, DiaChi = ?, QuanHuyen = ?, TinhThanh = ? WHERE Email = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, user.getHoTen());
            st.setString(2, user.getSdt());
            st.setString(3, user.getDiaChi());
            st.setString(4, user.getQuanHuyen());
            st.setString(5, user.getTinhThanh());
            st.setString(6, user.getEmail());
            st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}