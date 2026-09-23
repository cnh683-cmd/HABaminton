package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
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
}