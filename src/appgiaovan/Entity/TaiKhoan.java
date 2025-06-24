/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package appgiaovan.Entity;

/**
 *
 * @author ASUS
 */
import java.util.*;

public class TaiKhoan {
    private Integer idTaiKhoan;
    private Date ngayTao;
    private String tenTaiKhoan;
    private String matKhauMaHoa;
    private String vaiTro;
    private Integer trangThaiXoa;
    private String tenNguoiDung;
    
    public TaiKhoan(Integer idTaiKhoan, String vaiTro) {
        this.idTaiKhoan = idTaiKhoan;
        this.vaiTro = vaiTro;
    }

    public TaiKhoan() {
    }

    public String getTenNguoiDung(){
        return tenNguoiDung;
    }
    
    public void setTenNguoiDung(String name){
        this.tenNguoiDung = name;
    }
    
    public Integer getIdTaiKhoan() {
        return idTaiKhoan;
    }

    public void setIdTaiKhoan(Integer idTaiKhoan) {
        this.idTaiKhoan = idTaiKhoan;
    }

    public Date getNgayTao() {
        return ngayTao;
    }

    public void setNgayTao(Date ngayTao) {
        this.ngayTao = ngayTao;
    }

    public String getTenTaiKhoan() {
        return tenTaiKhoan;
    }

    public void setTenTaiKhoan(String tenTaiKhoan) {
        this.tenTaiKhoan = tenTaiKhoan;
    }

    public String getMatKhauMaHoa() {
        return matKhauMaHoa;
    }

    public void setMatKhauMaHoa(String matKhauMaHoa) {
        this.matKhauMaHoa = matKhauMaHoa;
    }

    public String getVaiTro() {
        return vaiTro;
    }

    public void setVaiTro(String vaiTro) {
        this.vaiTro = vaiTro;
    }

    public Integer getTrangThaiXoa() {
        return trangThaiXoa;
    }

    public void setTrangThaiXoa(Integer trangThaiXoa) {
        this.trangThaiXoa = trangThaiXoa;
    }
    public static void main(String[] args){
        System.out.println("nothing here");
    }
}
