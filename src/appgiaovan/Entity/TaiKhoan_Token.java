/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package appgiaovan.Entity;

/**
 *
 * @author ASUS
 */
import java.security.Timestamp;
public class TaiKhoan_Token {
    private Integer idToken;
    private Integer idTaiKhoan;
    private Integer giaTriToken;
    private Timestamp thoiGianHetHan;
    private Timestamp thoiGianCapPhat;
    private Integer biThuHoi;

    public Integer getIdToken() {
        return idToken;
    }

    public void setIdToken(Integer idToken) {
        this.idToken = idToken;
    }

    public Integer getIdTaiKhoan() {
        return idTaiKhoan;
    }

    public void setIdTaiKhoan(Integer idTaiKhoan) {
        this.idTaiKhoan = idTaiKhoan;
    }

    public Integer getGiaTriToken() {
        return giaTriToken;
    }

    public void setGiaTriToken(Integer giaTriToken) {
        this.giaTriToken = giaTriToken;
    }

    public Timestamp getThoiGianHetHan() {
        return thoiGianHetHan;
    }

    public void setThoiGianHetHan(Timestamp thoiGianHetHan) {
        this.thoiGianHetHan = thoiGianHetHan;
    }

    public Timestamp getThoiGianCapPhat() {
        return thoiGianCapPhat;
    }

    public void setThoiGianCapPhat(Timestamp thoiGianCapPhat) {
        this.thoiGianCapPhat = thoiGianCapPhat;
    }

    public Integer getBiThuHoi() {
        return biThuHoi;
    }

    public void setBiThuHoi(Integer biThuHoi) {
        this.biThuHoi = biThuHoi;
    }
    
}
