package model;

public class OrderDetail {
    private String tenSP;
    private int soLuong;
    private int giaMua;
    private String hinhAnh; // Bổ sung biến lưu ảnh

    public OrderDetail() {
    }

    public OrderDetail(String tenSP, int soLuong, int giaMua) {
        this.tenSP = tenSP;
        this.soLuong = soLuong;
        this.giaMua = giaMua;
    }

    public String getTenSP() { return tenSP; }
    public void setTenSP(String tenSP) { this.tenSP = tenSP; }
    public int getSoLuong() { return soLuong; }
    public void setSoLuong(int soLuong) { this.soLuong = soLuong; }
    public int getGiaMua() { return giaMua; }
    public void setGiaMua(int giaMua) { this.giaMua = giaMua; }
    
    // Getter và Setter cho hinhAnh
    public String getHinhAnh() { return hinhAnh; }
    public void setHinhAnh(String hinhAnh) { this.hinhAnh = hinhAnh; }
}