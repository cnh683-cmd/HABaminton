package model;

import java.util.Date;
import java.util.List;

public class Order {
    private String maDonHang;
    private String tenNguoiNhan;
    private String sdt;
    private String diaChi;
    private int tongTien;
    private String phuongThucThanhToan;
    private int trangThai;
    private Date ngayDat;
    private Date ngayTiepNhan;
    private Date ngayGiaoVan;
    private Date ngayNhanHang;
    private List<OrderDetail> chiTietList;
    private String emailKhachHang; 
    private String maVoucher;
    private String ghiChu;
    private int userDaXem;
    private String lyDoHuy;
    private String avatar;

    public Order() {
    }

    public Order(String maDonHang, String tenNguoiNhan, String sdt, String diaChi, int tongTien, String phuongThucThanhToan, int trangThai, Date ngayDat, Date ngayTiepNhan, Date ngayGiaoVan, Date ngayNhanHang) {
        this.maDonHang = maDonHang;
        this.tenNguoiNhan = tenNguoiNhan;
        this.sdt = sdt;
        this.diaChi = diaChi;
        this.tongTien = tongTien;
        this.phuongThucThanhToan = phuongThucThanhToan;
        this.trangThai = trangThai;
        this.ngayDat = ngayDat;
        this.ngayTiepNhan = ngayTiepNhan;
        this.ngayGiaoVan = ngayGiaoVan;
        this.ngayNhanHang = ngayNhanHang;
    }

    public List<OrderDetail> getChiTietList() { return chiTietList; }
    public void setChiTietList(List<OrderDetail> chiTietList) { this.chiTietList = chiTietList; }
    public String getMaDonHang() { return maDonHang; }
    public void setMaDonHang(String maDonHang) { this.maDonHang = maDonHang; }
    public String getTenNguoiNhan() { return tenNguoiNhan; }
    public void setTenNguoiNhan(String tenNguoiNhan) { this.tenNguoiNhan = tenNguoiNhan; }
    public String getSdt() { return sdt; }
    public void setSdt(String sdt) { this.sdt = sdt; }
    public String getDiaChi() { return diaChi; }
    public void setDiaChi(String diaChi) { this.diaChi = diaChi; }
    public int getTongTien() { return tongTien; }
    public void setTongTien(int tongTien) { this.tongTien = tongTien; }
    public String getPhuongThucThanhToan() { return phuongThucThanhToan; }
    public void setPhuongThucThanhToan(String phuongThucThanhToan) { this.phuongThucThanhToan = phuongThucThanhToan; }
    public int getTrangThai() { return trangThai; }
    public void setTrangThai(int trangThai) { this.trangThai = trangThai; }
    public Date getNgayDat() { return ngayDat; }
    public void setNgayDat(Date ngayDat) { this.ngayDat = ngayDat; }
    public Date getNgayTiepNhan() { return ngayTiepNhan; }
    public void setNgayTiepNhan(Date ngayTiepNhan) { this.ngayTiepNhan = ngayTiepNhan; }
    public Date getNgayGiaoVan() { return ngayGiaoVan; }
    public void setNgayGiaoVan(Date ngayGiaoVan) { this.ngayGiaoVan = ngayGiaoVan; }
    public Date getNgayNhanHang() { return ngayNhanHang; }
    public void setNgayNhanHang(Date ngayNhanHang) { this.ngayNhanHang = ngayNhanHang; }
    public String getEmailKhachHang() { return emailKhachHang; }
    public void setEmailKhachHang(String emailKhachHang) { this.emailKhachHang = emailKhachHang; }
    public String getMaVoucher() { return maVoucher; }
    public void setMaVoucher(String maVoucher) { this.maVoucher = maVoucher; }
    public String getGhiChu() { return ghiChu; }
    public void setGhiChu(String ghiChu) { this.ghiChu = ghiChu; }
    public int getUserDaXem() { return userDaXem; }
    public void setUserDaXem(int userDaXem) { this.userDaXem = userDaXem; }
    public String getLyDoHuy() { return lyDoHuy; }
    public void setLyDoHuy(String lyDoHuy) { this.lyDoHuy = lyDoHuy; }
    public String getAvatar() { return avatar; }
    public void setAvatar(String avatar) { this.avatar = avatar; }
}