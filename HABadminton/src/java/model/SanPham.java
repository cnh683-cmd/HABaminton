package model;

public class SanPham {
    private int maSP;
    private String tenSP;
    private double giaGoc;
    private double giaBan;
    private String hinhAnh;
    private int maDM;
    private int maTH;
    private boolean sanPhamMoi;
    private boolean banChay;
    private String ngayTao;
    private String moTa;
    private String xuatXu;
    private String thongSo;

    public SanPham() {
    }

    public SanPham(int maSP, String tenSP, double giaGoc, double giaBan, String hinhAnh, int maDM, int maTH, boolean sanPhamMoi, boolean banChay, String ngayTao, String moTa) {
        this.maSP = maSP;
        this.tenSP = tenSP;
        this.giaGoc = giaGoc;
        this.giaBan = giaBan;
        this.hinhAnh = hinhAnh;
        this.maDM = maDM;
        this.maTH = maTH;
        this.sanPhamMoi = sanPhamMoi;
        this.banChay = banChay;
        this.ngayTao = ngayTao;
        this.moTa = moTa;
    }

    public SanPham(int maSP, String tenSP, double giaGoc, double giaBan, String hinhAnh, int maDM, int maTH, boolean sanPhamMoi, boolean banChay, String ngayTao, String moTa, String xuatXu, String thongSo) {
        this.maSP = maSP;
        this.tenSP = tenSP;
        this.giaGoc = giaGoc;
        this.giaBan = giaBan;
        this.hinhAnh = hinhAnh;
        this.maDM = maDM;
        this.maTH = maTH;
        this.sanPhamMoi = sanPhamMoi;
        this.banChay = banChay;
        this.ngayTao = ngayTao;
        this.moTa = moTa;
        this.xuatXu = xuatXu;
        this.thongSo = thongSo;
    }
    

    public int getMaSP() { return maSP; }
    public void setMaSP(int maSP) { this.maSP = maSP; }

    public String getTenSP() { return tenSP; }
    public void setTenSP(String tenSP) { this.tenSP = tenSP; }

    public double getGiaGoc() { return giaGoc; }
    public void setGiaGoc(double giaGoc) { this.giaGoc = giaGoc; }

    public double getGiaBan() { return giaBan; }
    public void setGiaBan(double giaBan) { this.giaBan = giaBan; }

    public String getHinhAnh() { return hinhAnh; }
    public void setHinhAnh(String hinhAnh) { this.hinhAnh = hinhAnh; }

    public int getMaDM() { return maDM; }
    public void setMaDM(int maDM) { this.maDM = maDM; }

    public int getMaTH() { return maTH; }
    public void setMaTH(int maTH) { this.maTH = maTH; }

    public boolean isSanPhamMoi() { return sanPhamMoi; }
    public void setSanPhamMoi(boolean sanPhamMoi) { this.sanPhamMoi = sanPhamMoi; }

    public boolean isBanChay() { return banChay; }
    public void setBanChay(boolean banChay) { this.banChay = banChay; }

    public String getNgayTao() { return ngayTao; }
    public void setNgayTao(String ngayTao) { this.ngayTao = ngayTao; }

    public String getMoTa() { return moTa; }
    public void setMoTa(String moTa) { this.moTa = moTa; }

    public String getXuatXu() { return xuatXu; }
    public void setXuatXu(String xuatXu) { this.xuatXu = xuatXu; }

    public String getThongSo() { return thongSo; }
    public void setThongSo(String thongSo) { this.thongSo = thongSo; }
}