/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package appgiaovan.Entity;


import java.sql.Date;

public class TK_DanhGia {
    private Date ngay;
    private int tongLuotDanhGia;
    private int soLuong1Sao;
    private int soLuong2Sao;
    private int soLuong3Sao;
    private int soLuong4Sao;
    private int soLuong5Sao;

    public TK_DanhGia() {
    }

    public TK_DanhGia(Date ngay, int tongLuotDanhGia, int soLuong1Sao, int soLuong2Sao,
                      int soLuong3Sao, int soLuong4Sao, int soLuong5Sao) {
        this.ngay = ngay;
        this.tongLuotDanhGia = tongLuotDanhGia;
        this.soLuong1Sao = soLuong1Sao;
        this.soLuong2Sao = soLuong2Sao;
        this.soLuong3Sao = soLuong3Sao;
        this.soLuong4Sao = soLuong4Sao;
        this.soLuong5Sao = soLuong5Sao;
    }

    public Date getNgay() {
        return ngay;
    }

    public void setNgay(Date ngay) {
        this.ngay = ngay;
    }

    public int getTongLuotDanhGia() {
        return tongLuotDanhGia;
    }

    public void setTongLuotDanhGia(int tongLuotDanhGia) {
        this.tongLuotDanhGia = tongLuotDanhGia;
    }

    public int getSoLuong1Sao() {
        return soLuong1Sao;
    }

    public void setSoLuong1Sao(int soLuong1Sao) {
        this.soLuong1Sao = soLuong1Sao;
    }

    public int getSoLuong2Sao() {
        return soLuong2Sao;
    }

    public void setSoLuong2Sao(int soLuong2Sao) {
        this.soLuong2Sao = soLuong2Sao;
    }

    public int getSoLuong3Sao() {
        return soLuong3Sao;
    }

    public void setSoLuong3Sao(int soLuong3Sao) {
        this.soLuong3Sao = soLuong3Sao;
    }

    public int getSoLuong4Sao() {
        return soLuong4Sao;
    }

    public void setSoLuong4Sao(int soLuong4Sao) {
        this.soLuong4Sao = soLuong4Sao;
    }

    public int getSoLuong5Sao() {
        return soLuong5Sao;
    }

    public void setSoLuong5Sao(int soLuong5Sao) {
        this.soLuong5Sao = soLuong5Sao;
    }
}
