



package appgiaovan.Entity;


import java.sql.Date;

public class TK_DonHang {
    private Date ngay;
    private int tongSoDonHang;
    private int soLuongDaGiao;
    private int soLuongThatBai;
    private int soLuongDaHuy;

    public TK_DonHang() {
    }

    public TK_DonHang(Date ngay, int tongSoDonHang, int soLuongDaGiao, int soLuongThatBai, int soLuongDaHuy) {
        this.ngay = ngay;
        this.tongSoDonHang = tongSoDonHang;
        this.soLuongDaGiao = soLuongDaGiao;
        this.soLuongThatBai = soLuongThatBai;
        this.soLuongDaHuy = soLuongDaHuy;
    }

    public Date getNgay() {
        return ngay;
    }

    public void setNgay(Date ngay) {
        this.ngay = ngay;
    }

    public int getTongSoDonHang() {
        return tongSoDonHang;
    }

    public void setTongSoDonHang(int tongSoDonHang) {
        this.tongSoDonHang = tongSoDonHang;
    }

    public int getSoLuongDaGiao() {
        return soLuongDaGiao;
    }

    public void setSoLuongDaGiao(int soLuongDaGiao) {
        this.soLuongDaGiao = soLuongDaGiao;
    }

    public int getSoLuongThatBai() {
        return soLuongThatBai;
    }

    public void setSoLuongThatBai(int soLuongThatBai) {
        this.soLuongThatBai = soLuongThatBai;
    }

    public int getSoLuongDaHuy() {
        return soLuongDaHuy;
    }

    public void setSoLuongDaHuy(int soLuongDaHuy) {
        this.soLuongDaHuy = soLuongDaHuy;
    }
}
