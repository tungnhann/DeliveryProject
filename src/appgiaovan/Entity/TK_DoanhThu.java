/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package appgiaovan.Entity;



import java.sql.Date;

public class TK_DoanhThu {
    private Date ngay;
    private double tongTien;

    public TK_DoanhThu() {
    }

    public TK_DoanhThu(Date ngay, double tongTien) {
        this.ngay = ngay;
        this.tongTien = tongTien;
    }

    public Date getNgay() {
        return ngay;
    }

    public void setNgay(Date ngay) {
        this.ngay = ngay;
    }

    public double getTongTien() {
        return tongTien;
    }

    public void setTongTien(double tongTien) {
        this.tongTien = tongTien;
    }
}
