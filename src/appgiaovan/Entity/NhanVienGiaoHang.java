/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package appgiaovan.Entity;

/**
 *
 * @author pc
 */

public class NhanVienGiaoHang extends NguoiDung {
    private String DiaChi;
    private int ID_Kho;
    private int ID_QuanLy;
    private int DiemDanhGia;

    public NhanVienGiaoHang() {}

    public String getDiaChi() {
        return DiaChi;
    }

    public void setDiaChi(String DiaChi) {
        this.DiaChi = DiaChi;
    }

    public int getID_Kho() {
        return ID_Kho;
    }

    public void setID_Kho(int ID_Kho) {
        this.ID_Kho = ID_Kho;
    }

    public int getID_QuanLy() {
        return ID_QuanLy;
    }

    public void setID_QuanLy(int ID_QuanLy) {
        this.ID_QuanLy = ID_QuanLy;
    }

    public int getDiemDanhGia() {
        return DiemDanhGia;
    }

    public void setDiemDanhGia(int DiemDanhGia) {
        this.DiemDanhGia = DiemDanhGia;
    }
     @Override
    public String toString() {
        return HoTen; 
    }
}

