package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Voucher;

public class VoucherDAO extends DBContext {

    /** Lỗi SQL gần nhất (để hiển thị cho admin biết chính xác nguyên nhân) */
    private String lastError;
    public String getLastError() { return lastError == null ? "không rõ" : lastError.replaceAll("[\\r\\n]+", " "); }

    public boolean hasError() { return lastError != null; }

    private static volatile boolean schemaChecked = false;

    public VoucherDAO() {
        super();
        if (!schemaChecked) ensureSchema();
    }

    /**
     * Tự tạo bảng VOUCHER nếu chưa có; nếu CSDL đã có sẵn bảng VOUCHER (cấu trúc khác)
     * thì bổ sung các cột còn thiếu mà trang Quản lý giảm giá cần dùng.
     */
    private synchronized void ensureSchema() {
        if (schemaChecked || connection == null) return;
        String[] sqls = {
            "IF OBJECT_ID('dbo.VOUCHER','U') IS NULL CREATE TABLE dbo.VOUCHER ("
                + "MaVoucher VARCHAR(50) NOT NULL PRIMARY KEY, TenVoucher NVARCHAR(200) NULL, "
                + "LoaiGiam INT NOT NULL DEFAULT 0, GiaTriGiam INT NOT NULL DEFAULT 0, GiamToiDa INT NULL, "
                + "DonToiThieu INT NOT NULL DEFAULT 0, SoLuong INT NOT NULL DEFAULT 100, DaSuDung INT NOT NULL DEFAULT 0, "
                + "NgayBatDau DATE NULL, NgayKetThuc DATE NULL, TrangThai INT NOT NULL DEFAULT 1, NgayTao DATETIME NULL DEFAULT GETDATE())",
            addCol("MaVoucher", "VARCHAR(50) NULL"),
            addCol("TenVoucher", "NVARCHAR(200) NULL"),
            addCol("LoaiGiam", "INT NOT NULL DEFAULT 0"),
            addCol("GiaTriGiam", "INT NOT NULL DEFAULT 0"),
            addCol("GiamToiDa", "INT NULL"),
            addCol("DonToiThieu", "INT NOT NULL DEFAULT 0"),
            addCol("SoLuong", "INT NOT NULL DEFAULT 100"),
            addCol("DaSuDung", "INT NOT NULL DEFAULT 0"),
            addCol("NgayBatDau", "DATE NULL"),
            addCol("NgayKetThuc", "DATE NULL"),
            addCol("TrangThai", "INT NOT NULL DEFAULT 1"),
            addCol("NgayTao", "DATETIME NULL DEFAULT GETDATE()")
        };
        for (String sql : sqls) {
            try {
                connection.prepareStatement(sql).executeUpdate();
            } catch (Exception e) {
                System.out.println("VoucherDAO.ensureSchema: " + e.getMessage());
            }
        }
        healForeignColumns();
        schemaChecked = true;
    }

    /** Tên cột khóa chính riêng của bảng VOUCHER cũ (kiểu chữ, không tự tăng) nếu khác MaVoucher */
    private static volatile String pkAlias = null;

    /**
     * Bảng VOUCHER có sẵn có thể có các cột bắt buộc (NOT NULL, không có giá trị mặc định)
     * mà trang này không điền -> gán giá trị mặc định cho các cột đó để INSERT không bị lỗi.
     */
    private void healForeignColumns() {
        java.util.Set<String> mine = new java.util.HashSet<>(java.util.Arrays.asList(
            "mavoucher", "tenvoucher", "loaigiam", "giatrigiam", "giamtoida", "dontoithieu",
            "soluong", "dasudung", "ngaybatdau", "ngayketthuc", "trangthai", "ngaytao"));
        // Cột khóa chính
        try {
            String sqlPk = "SELECT c.name, c.is_identity, ty.name AS typ FROM sys.indexes i "
                + "JOIN sys.index_columns ic ON ic.object_id = i.object_id AND ic.index_id = i.index_id "
                + "JOIN sys.columns c ON c.object_id = ic.object_id AND c.column_id = ic.column_id "
                + "JOIN sys.types ty ON ty.user_type_id = c.user_type_id "
                + "WHERE i.is_primary_key = 1 AND i.object_id = OBJECT_ID('dbo.VOUCHER')";
            ResultSet rs = connection.prepareStatement(sqlPk).executeQuery();
            java.util.List<String[]> pk = new ArrayList<>();
            while (rs.next()) pk.add(new String[]{rs.getString("name"), rs.getString("is_identity"), rs.getString("typ")});
            if (pk.size() == 1 && !pk.get(0)[0].equalsIgnoreCase("MaVoucher")
                    && !"1".equals(pk.get(0)[1]) && !"true".equalsIgnoreCase(pk.get(0)[1])
                    && pk.get(0)[2].toLowerCase().contains("char")) {
                pkAlias = pk.get(0)[0];
                mine.add(pkAlias.toLowerCase());
            }
        } catch (Exception e) {
            System.out.println("VoucherDAO PK check: " + e.getMessage());
        }
        // Cột NOT NULL không có mặc định -> thêm DEFAULT
        try {
            String sqlCols = "SELECT c.name, ty.name AS typ FROM sys.columns c "
                + "JOIN sys.types ty ON ty.user_type_id = c.user_type_id "
                + "WHERE c.object_id = OBJECT_ID('dbo.VOUCHER') AND c.is_nullable = 0 AND c.is_identity = 0 "
                + "AND c.is_computed = 0 AND c.default_object_id = 0";
            ResultSet rs = connection.prepareStatement(sqlCols).executeQuery();
            java.util.List<String[]> cols = new ArrayList<>();
            while (rs.next()) cols.add(new String[]{rs.getString("name"), rs.getString("typ").toLowerCase()});
            for (String[] c : cols) {
                if (mine.contains(c[0].toLowerCase())) continue;
                String def;
                if (c[1].contains("char") || c[1].contains("text")) def = "''";
                else if (c[1].contains("date") || c[1].contains("time")) def = "GETDATE()";
                else if (c[1].equals("bit")) def = "1";
                else def = "0";
                try {
                    connection.prepareStatement("ALTER TABLE dbo.VOUCHER ADD DEFAULT " + def + " FOR [" + c[0] + "]").executeUpdate();
                } catch (Exception e) {
                    System.out.println("VoucherDAO default for " + c[0] + ": " + e.getMessage());
                }
            }
        } catch (Exception e) {
            System.out.println("VoucherDAO column check: " + e.getMessage());
        }
    }

    private static String addCol(String col, String def) {
        return "IF COL_LENGTH('dbo.VOUCHER','" + col + "') IS NULL ALTER TABLE dbo.VOUCHER ADD " + col + " " + def;
    }

    private Voucher map(ResultSet rs) throws Exception {
        Voucher v = new Voucher();
        v.setMaVoucher(rs.getString("MaVoucher"));
        try { v.setTenVoucher(rs.getString("TenVoucher")); } catch (Exception ignored) {}
        try { v.setLoaiGiam(rs.getInt("LoaiGiam")); } catch (Exception ignored) {}
        try { v.setGiaTriGiam(rs.getInt("GiaTriGiam")); } catch (Exception ignored) {}
        try { int max = rs.getInt("GiamToiDa"); v.setGiamToiDa(rs.wasNull() ? null : max); } catch (Exception ignored) {}
        try { v.setDonToiThieu(rs.getInt("DonToiThieu")); } catch (Exception ignored) {}
        try { v.setSoLuong(rs.getInt("SoLuong")); } catch (Exception ignored) {}
        try { v.setDaSuDung(rs.getInt("DaSuDung")); } catch (Exception ignored) {}
        try { v.setNgayBatDau(rs.getDate("NgayBatDau")); } catch (Exception ignored) {}
        try { v.setNgayKetThuc(rs.getDate("NgayKetThuc")); } catch (Exception ignored) {}
        try { Object tt = rs.getObject("TrangThai"); v.setTrangThai(tt == null ? 1 : rs.getInt("TrangThai")); } catch (Exception ignored) {}
        try { v.setNgayTao(rs.getTimestamp("NgayTao")); } catch (Exception ignored) {}
        if (v.getTenVoucher() == null || v.getTenVoucher().isEmpty()) v.setTenVoucher(v.getMoTaGiam());
        return v;
    }

    /** Danh sách voucher cho admin có bộ lọc: status = all | active | upcoming | expired | soldout | off */
    public List<Voucher> searchVouchers(String keyword, String type, String status) {
        List<Voucher> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM VOUCHER WHERE 1=1 ");
        List<Object> params = new ArrayList<>();
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (MaVoucher LIKE ? OR TenVoucher LIKE ?) ");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw); params.add(kw);
        }
        if (type != null && !type.isEmpty() && !"all".equals(type)) {
            sql.append(" AND LoaiGiam = ? ");
            params.add(Integer.parseInt(type));
        }
        sql.append(" ORDER BY NgayTao DESC");
        try {
            PreparedStatement st = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) st.setObject(i + 1, params.get(i));
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Voucher v;
                try { v = map(rs); } catch (Exception rowErr) { lastError = rowErr.getMessage(); continue; }
                if (v.getMaVoucher() == null) continue; // dòng cũ không có mã
                if (status == null || status.isEmpty() || "all".equals(status) || status.equals(v.getTinhTrang())) {
                    list.add(v);
                }
            }
        } catch (Exception e) {
            lastError = e.getMessage(); System.out.println("Lỗi searchVouchers: " + e.getMessage());
        }
        return list;
    }

    public List<Voucher> getAllVouchers() {
        return searchVouchers(null, null, null);
    }

    /** Voucher khách hàng có thể dùng ngay lúc này (dùng cho trang thanh toán) */
    public List<Voucher> getAvailableVouchers() {
        List<Voucher> list = new ArrayList<>();
        String sql = "SELECT * FROM VOUCHER WHERE TrangThai = 1 AND DaSuDung < SoLuong "
                   + "AND CAST(GETDATE() AS DATE) BETWEEN NgayBatDau AND NgayKetThuc ORDER BY DonToiThieu ASC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) list.add(map(rs));
        } catch (Exception e) {
            System.out.println("Lỗi getAvailableVouchers: " + e.getMessage());
        }
        return list;
    }

    public Voucher getVoucherByCode(String code) {
        String sql = "SELECT * FROM VOUCHER WHERE MaVoucher = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, code);
            ResultSet rs = st.executeQuery();
            if (rs.next()) return map(rs);
        } catch (Exception e) {
            System.out.println("Lỗi getVoucherByCode: " + e.getMessage());
        }
        return null;
    }

    public boolean insertVoucher(Voucher v) {
        String extraCol = pkAlias != null ? ", [" + pkAlias + "]" : "";
        String extraVal = pkAlias != null ? ", ?" : "";
        String sql = "INSERT INTO VOUCHER (MaVoucher, TenVoucher, LoaiGiam, GiaTriGiam, GiamToiDa, DonToiThieu, SoLuong, DaSuDung, NgayBatDau, NgayKetThuc, TrangThai, NgayTao" + extraCol + ") "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, 0, ?, ?, ?, GETDATE()" + extraVal + ")";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, v.getMaVoucher());
            st.setString(2, v.getTenVoucher());
            st.setInt(3, v.getLoaiGiam());
            st.setInt(4, v.getGiaTriGiam());
            if (v.getGiamToiDa() == null) st.setNull(5, java.sql.Types.INTEGER); else st.setInt(5, v.getGiamToiDa());
            st.setInt(6, v.getDonToiThieu());
            st.setInt(7, v.getSoLuong());
            st.setDate(8, new java.sql.Date(v.getNgayBatDau().getTime()));
            st.setDate(9, new java.sql.Date(v.getNgayKetThuc().getTime()));
            st.setInt(10, v.getTrangThai());
            if (pkAlias != null) st.setString(11, v.getMaVoucher());
            return st.executeUpdate() > 0;
        } catch (Exception e) {
            lastError = e.getMessage(); System.out.println("Lỗi insertVoucher: " + e.getMessage());
        }
        return false;
    }

    public boolean updateVoucher(Voucher v) {
        String sql = "UPDATE VOUCHER SET TenVoucher = ?, LoaiGiam = ?, GiaTriGiam = ?, GiamToiDa = ?, DonToiThieu = ?, SoLuong = ?, "
                   + "NgayBatDau = ?, NgayKetThuc = ?, TrangThai = ? WHERE MaVoucher = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, v.getTenVoucher());
            st.setInt(2, v.getLoaiGiam());
            st.setInt(3, v.getGiaTriGiam());
            if (v.getGiamToiDa() == null) st.setNull(4, java.sql.Types.INTEGER); else st.setInt(4, v.getGiamToiDa());
            st.setInt(5, v.getDonToiThieu());
            st.setInt(6, v.getSoLuong());
            st.setDate(7, new java.sql.Date(v.getNgayBatDau().getTime()));
            st.setDate(8, new java.sql.Date(v.getNgayKetThuc().getTime()));
            st.setInt(9, v.getTrangThai());
            st.setString(10, v.getMaVoucher());
            return st.executeUpdate() > 0;
        } catch (Exception e) {
            lastError = e.getMessage(); System.out.println("Lỗi updateVoucher: " + e.getMessage());
        }
        return false;
    }

    public boolean updateStatus(String code, int status) {
        String sql = "UPDATE VOUCHER SET TrangThai = ? WHERE MaVoucher = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, status);
            st.setString(2, code);
            return st.executeUpdate() > 0;
        } catch (Exception e) {
            lastError = e.getMessage(); System.out.println("Lỗi updateStatus voucher: " + e.getMessage());
        }
        return false;
    }

    public boolean deleteVoucher(String code) {
        String sql = "DELETE FROM VOUCHER WHERE MaVoucher = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, code);
            return st.executeUpdate() > 0;
        } catch (Exception e) {
            lastError = e.getMessage(); System.out.println("Lỗi deleteVoucher: " + e.getMessage());
        }
        return false;
    }

    /** Số đơn hàng đã dùng mã (tính từ bảng DonHang) */
    public int countOrdersUsingVoucher(String code) {
        String sql = "SELECT COUNT(*) FROM DonHang WHERE MaVoucher = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, code);
            ResultSet rs = st.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            System.out.println("Lỗi countOrdersUsingVoucher: " + e.getMessage());
        }
        return 0;
    }
    
    public void increaseVoucherUsage(String code) {
        String sql = "UPDATE VOUCHER SET DaSuDung = DaSuDung + 1 WHERE MaVoucher = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, code);
            st.executeUpdate();
        } catch (Exception e) {
            System.out.println("Lỗi tăng lượt dùng voucher: " + e.getMessage());
        }
    }
    
    /** Hoàn lại lượt dùng voucher khi đơn hàng bị hủy (không để số âm) */
    public void decreaseVoucherUsage(String code) {
        String sql = "UPDATE VOUCHER SET DaSuDung = CASE WHEN DaSuDung - 1 < 0 THEN 0 ELSE DaSuDung - 1 END WHERE MaVoucher = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, code);
            st.executeUpdate();
        } catch (Exception e) {
            System.out.println("Lỗi hoàn lượt dùng voucher: " + e.getMessage());
        }
    }
}