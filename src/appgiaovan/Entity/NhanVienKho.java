/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package appgiaovan.Entity;

/**
 *
 * @author pc
 */

public class NhanVienKho extends NguoiDung {
    private String DiaChi;
    private Integer ID_Kho;
    private int ID_QuanLy;
    private double MucLuong;

    public NhanVienKho() {}

    public String getDiaChi() {
        return DiaChi;
    }

    public void setDiaChi(String DiaChi) {
        this.DiaChi = DiaChi;
    }

    public Integer getID_Kho() {
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

    public double getMucLuong() {
        return MucLuong;
    }

    public void setMucLuong(double MucLuong) {
        this.MucLuong = MucLuong;
    }
}