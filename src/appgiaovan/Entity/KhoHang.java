/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package appgiaovan.Entity;

public class KhoHang {
    private int idKho;
    private String tenKho;
    private int idQuanLy;
    private int slHangToiDa;
    private int slHangTon;
    private String diaChi;

    // Constructors
    public KhoHang() {}

    public KhoHang(int idKho, String tenKho, int slHangToiDa, int slHangTon, String diaChi) {
        this.idKho = idKho;
        this.tenKho = tenKho;
        this.slHangToiDa = slHangToiDa;
        this.slHangTon = slHangTon;
        this.diaChi = diaChi;
    }

    public int getIdKho() { return idKho; }
    public void setIdKho(int idKho) { this.idKho = idKho; }

    public String getTenKho() { return tenKho; }
    public void setTenKho(String tenKho) { this.tenKho = tenKho; }

    public int getIdQuanLy() { return idQuanLy; }
    public void setIdQuanLy(int idQuanLy) { this.idQuanLy = idQuanLy; }

    public int getSlHangToiDa() { return slHangToiDa; }
    public void setSlHangToiDa(int slHangToiDa) { this.slHangToiDa = slHangToiDa; }

    public int getSlHangTon() { return slHangTon; }
    public void setSlHangTon(int slHangTon) { this.slHangTon = slHangTon; }

    public String getDiaChi() { return diaChi; }
    public void setDiaChi(String diaChi) { this.diaChi = diaChi; }
    
    @Override
    public String toString() {
        return tenKho; 
    }

}

