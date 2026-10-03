package model;

import java.util.Date;

public class Voucher {
    private String maVoucher;
    private String tenVoucher;
    private int loaiGiam;       // 0: giảm tiền cố định, 1: giảm theo %
    private int giaTriGiam;
    private Integer giamToiDa;  // chỉ áp dụng khi loaiGiam = 1
    private int donToiThieu;
    private int soLuong;
    private int daSuDung;
    private Date ngayBatDau;
    private Date ngayKetThuc;
    private int trangThai;      // 1: bật, 0: tắt
    private Date ngayTao;

    public Voucher() {
    }

    public String getMaVoucher() { return maVoucher; }
    public void setMaVoucher(String maVoucher) { this.maVoucher = maVoucher; }
    public String getTenVoucher() { return tenVoucher; }
    public void setTenVoucher(String tenVoucher) { this.tenVoucher = tenVoucher; }
    public int getLoaiGiam() { return loaiGiam; }
    public void setLoaiGiam(int loaiGiam) { this.loaiGiam = loaiGiam; }
    public int getGiaTriGiam() { return giaTriGiam; }
    public void setGiaTriGiam(int giaTriGiam) { this.giaTriGiam = giaTriGiam; }
    public Integer getGiamToiDa() { return giamToiDa; }
    public void setGiamToiDa(Integer giamToiDa) { this.giamToiDa = giamToiDa; }
    public int getDonToiThieu() { return donToiThieu; }
    public void setDonToiThieu(int donToiThieu) { this.donToiThieu = donToiThieu; }
    public int getSoLuong() { return soLuong; }
    public void setSoLuong(int soLuong) { this.soLuong = soLuong; }
    public int getDaSuDung() { return daSuDung; }
    public void setDaSuDung(int daSuDung) { this.daSuDung = daSuDung; }
    public Date getNgayBatDau() { return ngayBatDau; }
    public void setNgayBatDau(Date ngayBatDau) { this.ngayBatDau = ngayBatDau; }
    public Date getNgayKetThuc() { return ngayKetThuc; }
    public void setNgayKetThuc(Date ngayKetThuc) { this.ngayKetThuc = ngayKetThuc; }
    public int getTrangThai() { return trangThai; }
    public void setTrangThai(int trangThai) { this.trangThai = trangThai; }
    public Date getNgayTao() { return ngayTao; }
    public void setNgayTao(Date ngayTao) { this.ngayTao = ngayTao; }

    /** Số lượt còn lại */
    public int getConLai() { return Math.max(0, soLuong - daSuDung); }

    /**
     * Tình trạng hiển thị cho admin:
     * "off" = đang tắt, "upcoming" = chưa tới ngày, "expired" = hết hạn,
     * "soldout" = hết lượt, "active" = đang áp dụng.
     */
    public String getTinhTrang() {
        if (trangThai == 0) return "off";
        Date now = new Date();
        java.util.Calendar c = java.util.Calendar.getInstance();
        if (ngayKetThuc != null) {
            c.setTime(ngayKetThuc);
            c.add(java.util.Calendar.DATE, 1); // hết hạn sau ngày kết thúc
            if (now.after(c.getTime())) return "expired";
        }
        if (ngayBatDau != null && now.before(ngayBatDau)) return "upcoming";
        if (getConLai() <= 0) return "soldout";
        return "active";
    }

    /** Tiêu đề mô tả mức giảm, VD: "Giảm 10% (tối đa 300.000đ)" */
    public String getMoTaGiam() {
        java.text.NumberFormat nf = java.text.NumberFormat.getInstance(java.util.Locale.forLanguageTag("vi-VN"));
        if (loaiGiam == 1) {
            String s = "Giảm " + giaTriGiam + "%";
            if (giamToiDa != null && giamToiDa > 0) s += " (tối đa " + nf.format(giamToiDa) + "đ)";
            return s;
        }
        return "Giảm " + nf.format(giaTriGiam) + "đ";
    }
}
