package model;

import java.util.Date;

public class Review {
    private int maDG;
    private String maSP;
    private String emailKhachHang;
    private String tenKhachHang;
    private int soSao;
    private String noiDung;
    private String phanHoiAdmin;
    private Date ngayDG;
    private int trangThai;
    private boolean anDanh;
    private int soLuotThich;
    private String hinhAnh;
    private String video;
    private String tenSP;
    private String hinhAnhSP;
    private String maDonHang;
    private String avatar;

    public Review() {
    }

    public int getMaDG() { return maDG; }
    public void setMaDG(int maDG) { this.maDG = maDG; }

    public String getMaSP() { return maSP; }
    public void setMaSP(String maSP) { this.maSP = maSP; }

    public String getEmailKhachHang() { return emailKhachHang; }
    public void setEmailKhachHang(String emailKhachHang) { this.emailKhachHang = emailKhachHang; }

    public String getTenKhachHang() { return tenKhachHang; }
    public void setTenKhachHang(String tenKhachHang) { this.tenKhachHang = tenKhachHang; }

    public int getSoSao() { return soSao; }
    public void setSoSao(int soSao) { this.soSao = soSao; }

    public String getNoiDung() { return noiDung; }
    public void setNoiDung(String noiDung) { this.noiDung = noiDung; }

    public String getPhanHoiAdmin() { return phanHoiAdmin; }
    public void setPhanHoiAdmin(String phanHoiAdmin) { this.phanHoiAdmin = phanHoiAdmin; }

    public Date getNgayDG() { return ngayDG; }
    public void setNgayDG(Date ngayDG) { this.ngayDG = ngayDG; }

    public int getTrangThai() { return trangThai; }
    public void setTrangThai(int trangThai) { this.trangThai = trangThai; }

    public boolean isAnDanh() { return anDanh; }
    public void setAnDanh(boolean anDanh) { this.anDanh = anDanh; }

    public int getSoLuotThich() { return soLuotThich; }
    public void setSoLuotThich(int soLuotThich) { this.soLuotThich = soLuotThich; }
    
    public String getHinhAnh() { return hinhAnh; }
    public void setHinhAnh(String hinhAnh) { this.hinhAnh = hinhAnh; }

    public String getVideo() { return video; }
    public void setVideo(String video) { this.video = video; }
    
    public String getTenSP() {
        return tenSP;
    }

    public void setTenSP(String tenSP) {
        this.tenSP = tenSP;
    }

    public String getHinhAnhSP() {
        return hinhAnhSP;
    }

    public void setHinhAnhSP(String hinhAnhSP) {
        this.hinhAnhSP = hinhAnhSP;
    }
    
    public String getMaDonHang() {
        return maDonHang;
    }

    public void setMaDonHang(String maDonHang) {
        this.maDonHang = maDonHang;
    }
    
    public String getAvatar() { return avatar; }
    public void setAvatar(String avatar) { this.avatar = avatar; }
}