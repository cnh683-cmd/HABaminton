package model;

public class User {
    private String hoTen;
    private String email;
    private String sdt;
    private String diaChi;
    private String quanHuyen;
    private String tinhThanh;
    private int role;

    public User() {
    }

    public User(String hoTen, String email, String sdt, String diaChi, String quanHuyen, String tinhThanh) {
        this.hoTen = hoTen;
        this.email = email;
        this.sdt = sdt;
        this.diaChi = diaChi;
        this.quanHuyen = quanHuyen;
        this.tinhThanh = tinhThanh;
    }

    public String getHoTen() { return hoTen; }
    public void setHoTen(String hoTen) { this.hoTen = hoTen; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getSdt() { return sdt; }
    public void setSdt(String sdt) { this.sdt = sdt; }
    public String getDiaChi() { return diaChi; }
    public void setDiaChi(String diaChi) { this.diaChi = diaChi; }
    public String getQuanHuyen() { return quanHuyen; }
    public void setQuanHuyen(String quanHuyen) { this.quanHuyen = quanHuyen; }
    public String getTinhThanh() { return tinhThanh; }
    public void setTinhThanh(String tinhThanh) { this.tinhThanh = tinhThanh; }
    public int getRole() { return role; }
    public void setRole(int role) { this.role = role; }
}