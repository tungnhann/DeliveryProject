alter session set "_ORACLE_SCRIPT"=true;
Create user DoAnGiaoVan IDENTIFIED BY Admin123;
GRANT DBA to DoAnGiaoVan;

-- Bảng Kho Hàng
CREATE TABLE KhoHang (
  ID_Kho NUMBER CONSTRAINT PK_KhoHang PRIMARY KEY,
  TenKho NVARCHAR2(100) NOT NULL,
  SLHangToiDa NUMBER NOT NULL,
  SLHangTon NUMBER,
  DiaChi NVARCHAR2(255) NOT NULL

);
-- Bảng Tài Khoản
CREATE TABLE TaiKhoan (
  ID_TaiKhoan NUMBER CONSTRAINT PK_TaiKhoan PRIMARY KEY,
  NgayTao DATE DEFAULT SYSTIMESTAMP,
  TenTaiKhoan NVARCHAR2(100) CONSTRAINT UQ_TaiKhoan_Ten UNIQUE NOT NULL,
  MatKhauMaHoa NVARCHAR2(255) NOT NULL,
  VaiTro VARCHAR2(4),
  TrangThaiXoa NUMBER DEFAULT 0
);
-- Bảng Khách Hàng
CREATE TABLE KhachHang (
  ID_KhachHang NUMBER CONSTRAINT PK_KhachHang PRIMARY KEY,
  ID_TaiKhoan NUMBER NOT NULL,
  HoTen NVARCHAR2(100) NOT NULL,
  SDT CHAR(10) CONSTRAINT UQ_KhachHang_SDT UNIQUE,
  Email VARCHAR2(100) CONSTRAINT UQ_KhachHang_Email UNIQUE,
  CCCD CHAR(12) CONSTRAINT UQ_KhachHang_CCCD UNIQUE,
  NgaySinh DATE,
  GioiTinh NVARCHAR2(3),
  CONSTRAINT FK_KhachHang_TaiKhoan FOREIGN KEY(ID_TaiKhoan)
	  REFERENCES TaiKhoan(ID_TaiKhoan)
);

-- Bảng Quản Lý
CREATE TABLE QuanLy (
  ID_QuanLy NUMBER CONSTRAINT PK_QuanLy PRIMARY KEY,
  ID_TaiKhoan NUMBER NOT NULL,
  ID_Kho NUMBER NOT NULL,
  HoTen NVARCHAR2(100) NOT NULL,
  SDT CHAR(10) CONSTRAINT UQ_QuanLy_SDT UNIQUE NOT NULL,
  Email NVARCHAR2(100) CONSTRAINT UQ_QuanLy_Email UNIQUE NOT NULL,
  CCCD CHAR(12) CONSTRAINT UQ_QuanLy_CCCD UNIQUE NOT NULL,
  NgaySinh DATE NOT NULL,
  GioiTinh NVARCHAR2(3) NOT NULL,
  DiaChi NVARCHAR2(255) NOT NULL,
  MucLuong NUMBER,
  CONSTRAINT FK_KhoHang_QuanLy FOREIGN KEY (ID_Kho)
    REFERENCES KhoHang(ID_Kho),
  CONSTRAINT FK_QuanLy_TaiKhoan FOREIGN KEY(ID_TaiKhoan)
	  REFERENCES TaiKhoan(ID_TaiKhoan)
);

-- Bảng Nhân Viên Kho
CREATE TABLE NhanVienKho (
  ID_NhanVien NUMBER CONSTRAINT PK_NhanVienKho PRIMARY KEY,
  ID_TaiKhoan NUMBER NOT NULL,
  HoTen NVARCHAR2(100) NOT NULL,
  SDT CHAR(10) CONSTRAINT UQ_NVK_SDT UNIQUE,
  Email NVARCHAR2(100) CONSTRAINT UQ_NVK_Email UNIQUE,
  CCCD CHAR(12) CONSTRAINT UQ_NVK_CCCD UNIQUE,
  NgaySinh DATE,
  GioiTinh NVARCHAR2(3),
  DiaChi NVARCHAR2(255),
  ID_Kho NUMBER NOT NULL,
  ID_QuanLy NUMBER NOT NULL,
  MucLuong NUMBER,
  CONSTRAINT FK_NVK_KhoHang FOREIGN KEY (ID_Kho)
    REFERENCES KhoHang(ID_Kho),
  CONSTRAINT FK_NVK_QuanLy FOREIGN KEY (ID_QuanLy)
    REFERENCES QuanLy(ID_QuanLy),
  CONSTRAINT FK_NVK_TaiKhoan FOREIGN KEY(ID_TaiKhoan)
	  REFERENCES TaiKhoan(ID_TaiKhoan)
);

-- Bảng Nhân Viên Giao Hàng
CREATE TABLE NhanVienGiaoHang (
  ID_NVGiaoHang NUMBER CONSTRAINT PK_NhanVienGiaoHang PRIMARY KEY,
  ID_TaiKhoan NUMBER NOT NULL,
  HoTen NVARCHAR2(100) NOT NULL,
  SDT CHAR(10) CONSTRAINT UQ_NVG_SDT UNIQUE,
  Email NVARCHAR2(100) CONSTRAINT UQ_NVG_Email UNIQUE,
  CCCD CHAR(12) CONSTRAINT UQ_NVG_CCCD UNIQUE,
  NgaySinh DATE,
  GioiTinh NVARCHAR2(3),
  DiaChi NVARCHAR2(255),
  ID_Kho NUMBER NOT NULL,
  ID_QuanLy NUMBER NOT NULL,
  DiemDanhGia NUMBER DEFAULT 5,
  CONSTRAINT FK_NVG_KhoHang FOREIGN KEY (ID_Kho)
    REFERENCES KhoHang(ID_Kho),
  CONSTRAINT FK_NVG_QuanLy FOREIGN KEY (ID_QuanLy)
    REFERENCES QuanLy(ID_QuanLy),
  CONSTRAINT FK_NVG_TaiKhoan FOREIGN KEY(ID_TaiKhoan)
	  REFERENCES TaiKhoan(ID_TaiKhoan)
);
-- Bảng Đơn Hàng
CREATE TABLE DonHang (
  ID_DonHang NUMBER CONSTRAINT PK_DonHang PRIMARY KEY,
  ID_KhachHang NUMBER,
  ID_NVGiaoHang NUMBER,
  SDTNguoiGui CHAR(10),
  SDTNguoiNhan CHAR(10),
  ID_KhoTiepNhan NUMBER,
  TenNguoiGui NVARCHAR2(100) NOT NULL,
  TenNguoiNhan NVARCHAR2(100) NOT NULL,
  DiaChiNhan NVARCHAR2(255) NOT NULL,
  TienCOD NUMBER,
  Phi NUMBER,
  ThoiGianNhan DATE,
  ThoiGianTao DATE DEFAULT SYSTIMESTAMP,
  ThoiGianDuKien DATE,
  TrangThai NVARCHAR2(50) DEFAULT 'Đang xử lý',
  DichVu NVARCHAR2(50) NOT NULL,
  LoaiHangHoa NVARCHAR2(50) NOT NULL,
  CONSTRAINT FK_DonHang_NVGiaoHang FOREIGN KEY (ID_NVGiaoHang)
    REFERENCES NhanVienGiaoHang(ID_NVGiaoHang),
  CONSTRAINT FK_DonHang_KhoHang FOREIGN KEY (ID_KhoTiepNhan)
    REFERENCES KhoHang(ID_Kho)
);

-- Bảng Gói Hàng
CREATE TABLE GoiHang (
  ID_GoiHang NUMBER CONSTRAINT PK_GoiHang PRIMARY KEY,
  ID_KhoHangGui NUMBER NOT NULL,
  ID_KhoHangDen NUMBER NOT NULL,
  NgayGui DATE DEFAULT SYSTIMESTAMP,
  ID_NhanVien NUMBER NOT NULL,
  SoLuong NUMBER NOT NULL,
  TrangThai NVARCHAR2(50) DEFAULT 'Đang chuyển kho',
  CONSTRAINT FK_GoiHang_KhoGui FOREIGN KEY (ID_KhoHangGui)
    REFERENCES KhoHang(ID_Kho),
  CONSTRAINT FK_GoiHang_KhoDen FOREIGN KEY (ID_KhoHangDen)
    REFERENCES KhoHang(ID_Kho),
  CONSTRAINT FK_GoiHang_NhanVienKho FOREIGN KEY (ID_NhanVien)
    REFERENCES NhanVienKho(ID_NhanVien)
);

-- Bảng Chi Tiết Gói Hàng
CREATE TABLE ChiTietGoiHang (
  ID_DonHang NUMBER,
  ID_GoiHang NUMBER,
  CONSTRAINT PK_ChiTietGoiHang PRIMARY KEY (ID_DonHang, ID_GoiHang),
  CONSTRAINT FK_CTGoiHang_DonHang FOREIGN KEY (ID_DonHang)
    REFERENCES DonHang(ID_DonHang),
  CONSTRAINT FK_CTGoiHang_GoiHang FOREIGN KEY (ID_GoiHang)
    REFERENCES GoiHang(ID_GoiHang)
);
-- Bảng Đánh Giá
CREATE TABLE DanhGia (
  ID_DanhGia NUMBER CONSTRAINT PK_DanhGia PRIMARY KEY,
  ID_DonHang NUMBER CONSTRAINT UQ_DG UNIQUE NOT NULL,
  ID_KhachHang NUMBER,
  NoiDungDanhGia NVARCHAR2(500),
  DiemDanhGia NUMBER NOT NULL,
  NgayTao DATE DEFAULT SYSTIMESTAMP,
  CONSTRAINT FK_DanhGia_DonHang FOREIGN KEY (ID_DonHang)
    REFERENCES DonHang(ID_DonHang),
  CONSTRAINT FK_DanhGia_KhachHang FOREIGN KEY (ID_KhachHang)
    REFERENCES KhachHang(ID_KhachHang)
);

-- Bảng Báo Cáo Giao Hàng
CREATE TABLE BaoCaoGiaoHang (
  ID_BaoCaoGiaoHang NUMBER CONSTRAINT PK_BaoCaoGiaoHang PRIMARY KEY,
  ID_NVGiaoHang NUMBER NOT NULL,
  TongDonHangDaGiao NUMBER NOT NULL,
  TongTienCOD NUMBER DEFAULT 0,
  NgayKhoiTao DATE DEFAULT SYSTIMESTAMP,
  TongDHGiaoThatBai NUMBER NOT NULL,
  CONSTRAINT FK_BCGiaoHang_Shipper FOREIGN KEY (ID_NVGiaoHang)
    REFERENCES NhanVienGiaoHang(ID_NVGiaoHang)
);

-- Bảng Báo Cáo Kho
CREATE TABLE BaoCaoKho (
  ID_BaoCaoKho NUMBER CONSTRAINT PK_BaoCaoKho PRIMARY KEY,
  ID_NhanVien NUMBER NOT NULL,
  KyBaoCao DATE NOT NULL,
  NgayTaoBaoCao DATE NOT NULL,
  SoGoiHangNhap NUMBER DEFAULT 0,
  SoGoiHangXuat NUMBER DEFAULT 0,
  CONSTRAINT FK_BCKho_NhanVien FOREIGN KEY (ID_NhanVien)
    REFERENCES NhanVienKho(ID_NhanVien)
);

-- Bảng Quyền
CREATE TABLE QUYEN (
  ID_QUYEN NUMBER CONSTRAINT PK_Quyen PRIMARY KEY,
  TENQUYEN NVARCHAR2(20),
  QUYENTHEM NUMBER,
  QUYENSUA NUMBER,
  QUYENXOA NUMBER,
  QUYENXEM NUMBER
);

-- Bảng Phân Quyền Tài Khoản
CREATE TABLE TaiKhoan_PhanQuyen (
  ID_TaiKhoan NUMBER,
  ID_Quyen NUMBER,
  NgayTao DATE,
  TrangThaiXoa NUMBER DEFAULT 0,
  CONSTRAINT PK_TaiKhoan_PhanQuyen PRIMARY KEY (ID_TaiKhoan, ID_Quyen),
  CONSTRAINT FK_PhanQuyen_TaiKhoan FOREIGN KEY (ID_TaiKhoan)
    REFERENCES TaiKhoan(ID_TaiKhoan),
  CONSTRAINT FK_PhanQuyen_Quyen FOREIGN KEY (ID_Quyen)
    REFERENCES QUYEN(ID_QUYEN)
);

-- Bảng Token của Tài Khoản
CREATE TABLE TaiKhoan_Token (
  ID_Token NUMBER CONSTRAINT PK_TaiKhoan_Token PRIMARY KEY,
  ID_TaiKhoan NUMBER,
  GiaTriToken NUMBER,
  ThoiGianHetHan DATE,
  ThoiGianCapPhat DATE,
  BiThuHoi NUMBER,
  CONSTRAINT FK_Token_TaiKhoan FOREIGN KEY (ID_TaiKhoan)
    REFERENCES TaiKhoan(ID_TaiKhoan)
);

CREATE SEQUENCE seq_KhachHang START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_QuanLy START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_KhoHang START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_NhanVienKho START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_NhanVienGiaoHang START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_DonHang START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_GoiHang START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_DanhGia START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_BaoCaoGiaoHang START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_BaoCaoKho START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_TaiKhoan START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_Quyen START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_Token START WITH 1 INCREMENT BY 1;
COMMIT;

---check
-- DonHang
ALTER TABLE DonHang
  ADD CONSTRAINT chk_DonHang_TienCOD
    CHECK (TienCOD >= 0);

ALTER TABLE DonHang
  ADD CONSTRAINT chk_DonHang_Phi
    CHECK (Phi >= 0);

ALTER TABLE DonHang
  ADD CONSTRAINT chk_DonHang_TrangThai
    CHECK (TrangThai IN ('Đang xử lý', 'Đang vận chuyển', 'Đang giao', 'Đã giao', 'Giao thất bại', 'Hủy'));

ALTER TABLE DonHang
  ADD CONSTRAINT chk_DonHang_DichVu
    CHECK (DichVu IN ('Nhanh', 'Tiết kiệm', 'Hỏa tốc'));

ALTER TABLE DonHang
  ADD CONSTRAINT chk_DonHang_LoaiHangHoa
    CHECK (LoaiHangHoa IN ('Tài liệu', 'Bình thường', 'Cồng kềnh'));

-- KhoHang
ALTER TABLE KhoHang
  ADD CONSTRAINT chk_KhoHang_SLHangTon
    CHECK (SLHangTon <= SLHangToiDa);

-- TaiKhoan
ALTER TABLE TaiKhoan
  ADD CONSTRAINT chk_TaiKhoan_TrangThaiXoa
    CHECK (TrangThaiXoa IN (0, 1));

-- KhachHang
ALTER TABLE KhachHang
  ADD CONSTRAINT chk_KhachHang_GioiTinh
    CHECK (GioiTinh IN ('Nam', 'Nữ'));

-- QuanLy
ALTER TABLE QuanLy
  ADD CONSTRAINT chk_QuanLy_GioiTinh
    CHECK (GioiTinh IN ('Nam', 'Nữ'));

ALTER TABLE QuanLy
  ADD CONSTRAINT chk_QuanLy_MucLuong
    CHECK (MucLuong >= 0);

-- NhanVienKho
ALTER TABLE NhanVienKho
  ADD CONSTRAINT chk_NVK_GioiTinh
    CHECK (GioiTinh IN ('Nam', 'Nữ'));

ALTER TABLE NhanVienKho
  ADD CONSTRAINT chk_NVK_MucLuong
    CHECK (MucLuong >= 0);

-- NhanVienGiaoHang
ALTER TABLE NhanVienGiaoHang
  ADD CONSTRAINT chk_NVG_GioiTinh
    CHECK (GioiTinh IN ('Nam', 'Nữ'));

ALTER TABLE NhanVienGiaoHang
  ADD CONSTRAINT chk_NVG_DanhGia
    CHECK (DiemDanhGia BETWEEN 1 AND 5);

-- GoiHang
ALTER TABLE GoiHang
  ADD CONSTRAINT chk_GoiHang_SoLuong
    CHECK (SoLuong >= 1);

ALTER TABLE GoiHang
  ADD CONSTRAINT chk_GoiHang_TrangThai
    CHECK (TrangThai IN ('Đang chuyển kho', 'Hoàn thành'));

-- DanhGia
ALTER TABLE DanhGia
  ADD CONSTRAINT chk_DanhGia_Diem
    CHECK (DiemDanhGia BETWEEN 1 AND 5);

-- BaoCaoGiaoHang
ALTER TABLE BaoCaoGiaoHang
  ADD CONSTRAINT chk_BCGH_TongTienCOD
    CHECK (TongTienCOD >= 0);

-- BangQuyen
ALTER TABLE QUYEN
  ADD CONSTRAINT chk_BangQuyen_QuyenThem
    CHECK (QuyenThem IN (0, 1));

ALTER TABLE QUYEN
  ADD CONSTRAINT chk_BangQuyen_QuyenSua
    CHECK (QuyenSua IN (0, 1));

ALTER TABLE QUYEN
  ADD CONSTRAINT chk_BangQuyen_QuyenXoa
    CHECK (QuyenXoa IN (0, 1));

ALTER TABLE QUYEN
  ADD CONSTRAINT chk_BangQuyen_QuyenXem
    CHECK (QuyenXem IN (0, 1));

-- TaiKhoan_PhanQuyen
ALTER TABLE TaiKhoan_PhanQuyen
  ADD CONSTRAINT chk_TKPhanQuyen_TrangThaiXoa
    CHECK (TrangThaiXoa IN (0, 1));

-- TaiKhoan_Token
ALTER TABLE TaiKhoan_Token
  ADD CONSTRAINT chk_TKToken_BiThuHoi
    CHECK (BiThuHoi IN (0, 1));

--- function
-- tinh tong doanh thu
CREATE OR REPLACE FUNCTION TongDoanhThu (
  p_thang IN NUMBER,
  p_nam   IN NUMBER
) RETURN NUMBER
IS
  v_tongdoanhthu NUMBER := 0;
BEGIN
  SELECT SUM(Phi) INTO v_tongdoanhthu
  FROM DonHang
  WHERE EXTRACT(MONTH FROM ThoiGianTao) = p_thang
    AND EXTRACT(YEAR FROM ThoiGianTao) = p_nam;

  RETURN v_tongdoanhthu;
END;
/
--- tính số lượng đơn hàng mà khách hàng đó đã đặt giao thành công trong 1 năm
CREATE OR REPLACE FUNCTION SoLuongDHGiaoTC (
    p_ID_KhachHang IN NUMBER,
    p_Nam IN NUMBER
) RETURN NUMBER
IS
    v_SoLuong NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_SoLuong
    FROM DonHang
    WHERE ID_KhachHang = p_ID_KhachHang
      AND TrangThai = 'Đã giao'
      AND EXTRACT(YEAR FROM ThoiGianTao) = p_Nam;

    RETURN v_SoLuong;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 0;
END;
/
-- tinh tong doanh thu theo ngay cua moi kho
CREATE OR REPLACE FUNCTION TinhDoanhThuTheoNgay(
    p_ngay DATE,
    p_id_kho NUMBER
) RETURN NUMBER IS
    v_doanhthu NUMBER;
BEGIN
    SELECT NVL(SUM(Phi + NVL(TienCOD * 0.5/100, 0)), 0)
    INTO v_doanhthu
    FROM DonHang
    WHERE TRUNC(ThoiGianTao) = TRUNC(p_ngay)
      AND ID_KhoTiepNhan = p_id_kho
      AND TrangThai = 'Đang vận chuyể';

    RETURN v_doanhthu;
END;
/

--- tinh tong sô luong don hang theo trang thai cua kho moi ngay
CREATE OR REPLACE FUNCTION DemDonHangTheoTrangThai(
    p_ngay DATE,
    p_id_kho NUMBER,
    p_trang_thai NVARCHAR2
) RETURN NUMBER IS
    v_soluong NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_soluong
    FROM DonHang
    WHERE TRUNC(ThoiGianTao) = TRUNC(p_ngay)
      AND ID_KhoTiepNhan = p_id_kho
      AND TrangThai = p_trang_thai;

    RETURN v_soluong;
END;
/

--thong ke diem danh gia cua tung kho, moi ngay
CREATE OR REPLACE FUNCTION ThongKeSoLuongDanhGia(
    p_id_kho NUMBER,
    p_ngay DATE,
    p_diem NUMBER
) RETURN NUMBER IS
    v_soluong NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_soluong
    FROM DanhGia dg
    JOIN DonHang dh ON dg.ID_DonHang = dh.ID_DonHang
    JOIN NhanVienGiaoHang nvgh ON dh.ID_NVGiaoHang = nvgh.ID_NVGiaoHang
    WHERE TRUNC(dg.NgayTao) = TRUNC(p_ngay)
      AND dg.DiemDanhGia = p_diem
      AND nvgh.ID_Kho = p_id_kho;

    RETURN v_soluong;
END;
/


--Tính phí dịch vụ
CREATE OR REPLACE FUNCTION TinhPhi (
    p_DichVu IN NVARCHAR2,
    p_LoaiHangHoa IN NVARCHAR2
) RETURN NUMBER
AS
    v_PhiDichVu NUMBER := 0;
    v_PhiLoaiHang NUMBER := 0;
BEGIN
    -- Tính phí dịch vụ
    IF LOWER(p_DichVu) = 'tiết kiệm' THEN
        v_PhiDichVu := 10000;
    ELSIF LOWER(p_DichVu) = 'nhanh' THEN
        v_PhiDichVu := 15000;
    ELSIF LOWER(p_DichVu) = 'hỏa tốc' THEN
        v_PhiDichVu := 30000;
    ELSE
        v_PhiDichVu := 0;
    END IF;

    -- Tính phí loại hàng
    IF LOWER(p_LoaiHangHoa) = 'bình thường' THEN
        v_PhiLoaiHang := 25000;
    ELSIF LOWER(p_LoaiHangHoa) = 'dễ vỡ' THEN
        v_PhiLoaiHang := 30000;
    ELSIF LOWER(p_LoaiHangHoa) = 'cồng kềnh' THEN
        v_PhiLoaiHang := 50000;
    ELSE
        v_PhiLoaiHang := 0;
    END IF;

    RETURN v_PhiDichVu + v_PhiLoaiHang;
END;
/

-- Tính doanh thu theo tháng (gồm COD + Phí của đơn hàng)
CREATE OR REPLACE FUNCTION TinhDoanhThuTheoThang (
  p_thang IN NUMBER,
  p_nam   IN NUMBER
) RETURN NUMBER
IS
  v_doanhthu NUMBER := 0;
BEGIN
  SELECT SUM(TienCOD + Phi)
  INTO v_doanhthu
  FROM DonHang
  WHERE TrangThai = 'Đã giao'
    AND EXTRACT(MONTH FROM ThoiGianNhan) = p_thang
    AND EXTRACT(YEAR FROM ThoiGianNhan) = p_nam;

  RETURN v_doanhthu;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Lỗi tính doanh thu: ' || SQLERRM);
    RETURN -1;
END;
/
-- Tính số lượng đơn hàng theo tháng, năm và kho
CREATE OR REPLACE FUNCTION DemSoDonHangTheoThangVaKho (
  p_thang IN NUMBER,
  p_nam   IN NUMBER,
  p_id_kho IN NUMBER
) RETURN NUMBER
IS
  v_sodon NUMBER := 0;
BEGIN
  SELECT COUNT(*)
  INTO v_sodon
  FROM DonHang
  WHERE EXTRACT(MONTH FROM ThoiGianNhan) = p_thang
    AND EXTRACT(YEAR FROM ThoiGianNhan) = p_nam
    AND ID_KhoTiepNhan = p_id_kho;

  RETURN v_sodon;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Lỗi đếm đơn hàng: ' || SQLERRM);
    RETURN -1;
END;
/
---Tính tổng đơn hàng theo trạng thái
CREATE OR REPLACE FUNCTION TongDonHangTheoTrangThai(
  p_trangthai IN NVARCHAR2
) RETURN NUMBER IS
  v_soluong NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_soluong
  FROM DonHang
  WHERE TrangThai = p_trangthai;

  RETURN v_soluong;
END;
/

--- thêm tài khoản
--- function
---thêm nhân viên kho(thêm tài khoản rồi thêm nhân viên)
CREATE OR REPLACE FUNCTION TaoTaiKhoan_Func (
    p_TenTaiKhoan   IN TaiKhoan.TenTaiKhoan%TYPE,
    p_MatKhauMaHoa  IN TaiKhoan.MatKhauMaHoa%TYPE
)
RETURN NUMBER
IS
    v_ID TaiKhoan.ID_TaiKhoan%TYPE;
BEGIN
    v_ID := SEQ_TAIKHOAN.NEXTVAL;
    INSERT INTO TaiKhoan (ID_TaiKhoan, NgayTao, TenTaiKhoan, MatKhauMaHoa, TrangThaiXoa)
    VALUES (v_ID, SYSDATE, p_TenTaiKhoan, p_MatKhauMaHoa, 0);
    RETURN v_ID;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        -- noinspection SqlMissingReturn
        RAISE_APPLICATION_ERROR(-20011,'Tên tài khoản đã tồn tại.');
    WHEN OTHERS THEN
        -- noinspection SqlMissingReturn
        RAISE_APPLICATION_ERROR(-20012,'Lỗi tạo tài khoả');
END TaoTaiKhoan_Func;
/
-- func rieng cho KH
CREATE OR REPLACE FUNCTION TaoTaiKhoanKH_Func (
    p_TenTaiKhoan   IN TaiKhoan.TenTaiKhoan%TYPE,
    p_MatKhauMaHoa  IN TaiKhoan.MatKhauMaHoa%TYPE
)
RETURN NUMBER
IS
    v_ID TaiKhoan.ID_TaiKhoan%TYPE;
BEGIN
    v_ID := SEQ_TAIKHOAN.NEXTVAL;
    INSERT INTO TaiKhoan (ID_TaiKhoan, NgayTao, TenTaiKhoan, MatKhauMaHoa,VaiTro, TrangThaiXoa)
    VALUES (v_ID, SYSDATE, p_TenTaiKhoan, p_MatKhauMaHoa,'KH',0);
    RETURN v_ID;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        -- noinspection SqlMissingReturn
        RAISE_APPLICATION_ERROR(-20011,'Tên tài khoản đã tồn tại.');
    WHEN OTHERS THEN
        -- noinspection SqlMissingReturn
        RAISE_APPLICATION_ERROR(-20012,'Lỗi tạo tài khoả');
END TaoTaiKhoanKH_Func;
/
CREATE OR REPLACE FUNCTION TaoTaiKhoanNVGH_Func (
    p_TenTaiKhoan   IN TaiKhoan.TenTaiKhoan%TYPE,
    p_MatKhauMaHoa  IN TaiKhoan.MatKhauMaHoa%TYPE
)
RETURN NUMBER
IS
    v_ID TaiKhoan.ID_TaiKhoan%TYPE;
BEGIN
    v_ID := SEQ_TAIKHOAN.NEXTVAL;
    INSERT INTO TaiKhoan (ID_TaiKhoan, NgayTao, TenTaiKhoan, MatKhauMaHoa,VaiTro, TrangThaiXoa)
    VALUES (v_ID, SYSDATE, p_TenTaiKhoan, p_MatKhauMaHoa,'NVGH',0);
    RETURN v_ID;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        -- noinspection SqlMissingReturn
        RAISE_APPLICATION_ERROR(-20081,'Tên tài khoản đã tồn tại.');
    WHEN OTHERS THEN
        -- noinspection SqlMissingReturn
        RAISE_APPLICATION_ERROR(-20082,'Lỗi tạo tài khoả');
END TaoTaiKhoanNVGH_Func;
/
---SELECT * FROM TAIKHOAN t;
CREATE OR REPLACE FUNCTION TaoTaiKhoanNVK_Func (
    p_TenTaiKhoan   IN TaiKhoan.TenTaiKhoan%TYPE,
    p_MatKhauMaHoa  IN TaiKhoan.MatKhauMaHoa%TYPE
)
RETURN NUMBER
IS
    v_ID TaiKhoan.ID_TaiKhoan%TYPE;
BEGIN
    v_ID := SEQ_TAIKHOAN.NEXTVAL;
    INSERT INTO TaiKhoan (ID_TaiKhoan, NgayTao, TenTaiKhoan, MatKhauMaHoa,VaiTro, TrangThaiXoa)
    VALUES (v_ID, SYSDATE, p_TenTaiKhoan, p_MatKhauMaHoa,'NVK',0);
    RETURN v_ID;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        -- noinspection SqlMissingReturn
        RAISE_APPLICATION_ERROR(-20071,'Tên tài khoản đã tồn tại.');
    WHEN OTHERS THEN
        -- noinspection SqlMissingReturn
        RAISE_APPLICATION_ERROR(-20072,'Lỗi tạo tài khoả');
END TaoTaiKhoanNVK_Func;
/


---procedure
---procedure
--- thêm đơn hàng
CREATE OR REPLACE PROCEDURE ThemDonHang (
    p_ID_KhachHang      IN DonHang.ID_KhachHang%TYPE DEFAULT NULL,
    p_SDTNguoiGui       IN DonHang.SDTNguoiGui%TYPE,
    p_SDTNguoiNhan      IN DonHang.SDTNguoiNhan%TYPE,
    p_ID_KhoTiepNhan    IN DonHang.ID_KhoTiepNhan%TYPE,
    p_TenNguoiGui       IN DonHang.TenNguoiGui%TYPE,
    p_TenNguoiNhan      IN DonHang.TenNguoiNhan%TYPE,
    p_DiaChiNhan        IN DonHang.DiaChiNhan%TYPE,
    p_TienCOD           IN DonHang.TienCOD%TYPE DEFAULT NULL,
    p_DichVu            IN DonHang.DichVu%TYPE,
    p_LoaiHangHoa       IN DonHang.LoaiHangHoa%TYPE,
    p_iddonhang         OUT DonHang.ID_DonHang%type
)
AS
    v_Phi NUMBER;
BEGIN
    -- Gọi function tính phí
    v_Phi := TinhPhi(p_DichVu, p_LoaiHangHoa);
    p_iddonhang := seq_DonHang.NEXTVAL;
    INSERT INTO DonHang (
        ID_DonHang, ID_KhachHang, ID_NVGiaoHang, SDTNguoiGui, SDTNguoiNhan,
        ID_KhoTiepNhan, TenNguoiGui, TenNguoiNhan, DiaChiNhan,
        TienCOD, Phi, ThoiGianNhan, ThoiGianTao, ThoiGianDuKien,
        DichVu, LoaiHangHoa
    )
    VALUES (
        p_iddonhang, p_ID_KhachHang, NULL, p_SDTNguoiGui, p_SDTNguoiNhan,
        p_ID_KhoTiepNhan, p_TenNguoiGui, p_TenNguoiNhan, p_DiaChiNhan,
        p_TienCOD, v_Phi, NULL , SYSTIMESTAMP, NULL,
        p_DichVu, p_LoaiHangHoa
    );
    COMMIT;
END;
/
--- lấy thông tin khách hàng
CREATE OR REPLACE PROCEDURE LayThongTinKhachHang (
    p_ID_KhachHang IN KhachHang.ID_KhachHang%TYPE,
    p_HoTen OUT KhachHang.HoTen%TYPE,
    p_SDT OUT KhachHang.SDT%TYPE,
    p_Email OUT KhachHang.Email%TYPE,
    p_CCCD OUT KhachHang.CCCD%TYPE,
    p_NgaySinh OUT KhachHang.NgaySinh%TYPE,
    p_GioiTinh OUT KhachHang.GioiTinh%TYPE,
    p_ID_TaiKhoan OUT KhachHang.ID_TAIKHOAN%type
)
AS
BEGIN
    SELECT HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, ID_TaiKhoan
    INTO p_HoTen, p_SDT, p_Email, p_CCCD, p_NgaySinh, p_GioiTinh, p_ID_TaiKhoan
    FROM KhachHang
    WHERE ID_KhachHang = p_ID_KhachHang;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_HoTen := NULL;
        p_SDT := NULL;
        p_Email := NULL;
        p_CCCD := NULL;
        p_NgaySinh := NULL;
        p_GioiTinh := NULL;
END;
/

--- lấy thông tin đơn hàng (có thể tái sử dụng bằng cách thay đổi các tham số)
CREATE OR REPLACE PROCEDURE LayDonHang (
    p_ID_DonHang     IN  DonHang.ID_DonHang%TYPE DEFAULT NULL,
    p_ID_KhachHang   IN  DonHang.ID_KhachHang%TYPE DEFAULT NULL,
    p_TrangThai      IN  DonHang.TrangThai%TYPE DEFAULT NULL,
    p_LoaiHangHoa    IN  DonHang.LoaiHangHoa%TYPE DEFAULT NULL,
    p_DichVu         IN  DonHang.DichVu%TYPE DEFAULT NULL,

    p_TenNguoiGui    OUT DonHang.TenNguoiGui%TYPE,
    p_SDTNguoiGui    OUT DonHang.SDTNguoiGui%TYPE,
    p_TenNguoiNhan   OUT DonHang.TenNguoiNhan%TYPE,
    p_SDTNguoiNhan   OUT DonHang.SDTNguoiNhan%TYPE,
    p_DiaChiNhan     OUT DonHang.DiaChiNhan%TYPE,
    p_TienCOD        OUT DonHang.TienCOD%TYPE,
    p_Phi            OUT DonHang.Phi%TYPE,
    p_ThoiGianTao    OUT DonHang.ThoiGianTao%TYPE,
    p_TrangThai_Out  OUT DonHang.TrangThai%TYPE,
    p_DichVu_Out     OUT DonHang.DichVu%TYPE,
    p_LoaiHangHoa_Out OUT DonHang.LoaiHangHoa%TYPE
)
AS
BEGIN
    SELECT TenNguoiGui, SDTNguoiGui, TenNguoiNhan, SDTNguoiNhan,
           DiaChiNhan, TienCOD, Phi, ThoiGianTao, TrangThai, DichVu, LoaiHangHoa
    INTO   p_TenNguoiGui, p_SDTNguoiGui, p_TenNguoiNhan, p_SDTNguoiNhan,
           p_DiaChiNhan, p_TienCOD, p_Phi, p_ThoiGianTao, p_TrangThai_Out, p_DichVu_Out, p_LoaiHangHoa_Out
    FROM (
        SELECT * FROM DonHang
        WHERE (p_ID_DonHang IS NULL OR ID_DonHang = p_ID_DonHang)
          AND (p_ID_KhachHang IS NULL OR ID_KhachHang = p_ID_KhachHang)
          AND (p_TrangThai IS NULL OR TrangThai = p_TrangThai)
          AND (p_LoaiHangHoa IS NULL OR LoaiHangHoa = p_LoaiHangHoa)
          AND (p_DichVu IS NULL OR DichVu = p_DichVu)
    )
    WHERE ROWNUM = 1;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_TenNguoiGui := NULL;
        p_SDTNguoiGui := NULL;
        p_TenNguoiNhan := NULL;
        p_SDTNguoiNhan := NULL;
        p_DiaChiNhan := NULL;
        p_TienCOD := NULL;
        p_Phi := NULL;
        p_ThoiGianTao := NULL;
        p_TrangThai_Out := NULL;
        p_DichVu_Out := NULL;
        p_LoaiHangHoa_Out := NULL;
END;
/

--thêm báo cáo kho theo kỳ cho nhan vien kho
CREATE OR REPLACE PROCEDURE ThemBaoCaoKho (
  p_ID_NhanVien     IN NUMBER,
  p_KyBaoCao     IN DATE,
  p_SoGoiHangNhap   IN NUMBER DEFAULT 0,
  p_SoGoiHangXuat   IN NUMBER DEFAULT 0
) AS
BEGIN
  INSERT INTO BaoCaoKho (ID_BaoCaoKho, ID_NhanVien, KyBaoCao, SoGoiHangNhap, SoGoiHangXuat, NgayTaoBaoCao
  ) VALUES (
    seq_baocaokho.NEXTVAL,
    p_ID_NhanVien,
    p_KyBaoCao,
    NVL(p_SoGoiHangNhap, 0),
    NVL(p_SoGoiHangXuat, 0),
    SYSTIMESTAMP
  );

  COMMIT;
 END ThemBaoCaoKho;
/
--- tạo token khi đăng nhập
CREATE OR REPLACE PROCEDURE sp_TaoTokenChoTaiKhoan (
    p_ID_TaiKhoan IN NUMBER,
    p_ID_Token OUT NUMBER
) AS
    v_token NUMBER;
BEGIN
    -- Sinh token ngẫu nhiên
    v_token := TRUNC(DBMS_RANDOM.VALUE(1, 99999));
    p_ID_Token := seq_Token.NEXTVAL;
    -- Thêm token vào bảng
    INSERT INTO TaiKhoan_Token (
        ID_Token,
        ID_TaiKhoan,
        GiaTriToken,
        ThoiGianCapPhat,
        ThoiGianHetHan,
        BiThuHoi
    ) VALUES (
        p_ID_Token,
        p_ID_TaiKhoan,
        v_token,
        SYSTIMESTAMP,
        SYSTIMESTAMP + INTERVAL '1' HOUR ,
        0
    );
    commit;
END;
/

CREATE OR REPLACE PROCEDURE ThuHoiTokenChoTaiKhoan (
    p_ID_Token IN NUMBER
) AS
begin
    UPDATE TAIKHOAN_TOKEN
        SET BITHUHOI = 1
    WHERE ID_TOKEN = p_ID_Token;
    COMMIT ;
end;
/
---them danh gia
CREATE OR REPLACE PROCEDURE SP_ThemDanhGia (
  p_ID_DonHang      IN DanhGia.ID_DonHang%TYPE,
  p_NoiDungDanhGia  IN DanhGia.NoiDungDanhGia%TYPE,
  p_DiemDanhGia     IN DanhGia.DiemDanhGia%TYPE
)
AS
  v_ID_KhachHang   DanhGia.ID_KhachHang%TYPE;
BEGIN

  SELECT ID_KhachHang INTO v_ID_KhachHang
  FROM DonHang
  WHERE ID_DonHang = p_ID_DonHang;

  -- Thêm dánh giá vào b?ng DanhGia
  INSERT INTO DanhGia (
    ID_DanhGia,
    ID_DonHang,
    ID_KhachHang,
    NoiDungDanhGia,
    DiemDanhGia,
    NgayTao
  ) VALUES (
    SEQ_DanhGia.NEXTVAL,
    p_ID_DonHang,
    v_ID_KhachHang,
    p_NoiDungDanhGia,
    p_DiemDanhGia,
    SYSTIMESTAMP
  );

  COMMIT;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20001, 'Không tìm th?y don hàng v?i ID_DonHang = ' || p_ID_DonHang);
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20002, 'L?i khi thêm dánh giá: ' || SQLERRM);
END;
/
--call sp_TaoTokenChoTaiKhoan(5);
--thêm mới gói hàng và chi tiết gói hàng
--khởi tạo list chứa ds đơn hàng
-- Thêm gói hàng và chi tiết gói hàng, chỉnh trạng thái các đơn hàng khi đóng gói các đơn hàng
CREATE OR REPLACE TYPE DonHangList AS TABLE OF NUMBER;
/
CREATE OR REPLACE PROCEDURE ThemGoiHang (
  p_ID_KhoHangGui   IN NUMBER,
  p_ID_KhoHangDen   IN NUMBER,
  p_ID_NhanVien     IN NUMBER,
  p_DS_DonHang      IN DonHangList
)
AS
  v_ID_GoiHang NUMBER;
  v_SoLuong NUMBER;
BEGIN
  -- Kiểm tra số lượng phần tử trong danh sách
  v_SoLuong := p_DS_DonHang.COUNT;

  -- Sinh mã gói hàng mới
  v_ID_GoiHang := seq_goihang.NEXTVAL;

  -- Thêm gói hàng (sử dụng SYSDATE làm ngày gửi)
  INSERT INTO GoiHang (
    ID_GoiHang, ID_KhoHangGui, ID_KhoHangDen,
    NgayGui, ID_NhanVien, SoLuong
  ) VALUES (
    v_ID_GoiHang, p_ID_KhoHangGui, p_ID_KhoHangDen,
    SYSDATE, p_ID_NhanVien, v_SoLuong
  );

  -- Thêm chi tiết gói hàng
  FOR i IN 1 .. v_SoLuong LOOP
    INSERT INTO ChiTietGoiHang (
      ID_DonHang, ID_GoiHang
    ) VALUES (
      p_DS_DonHang(i), v_ID_GoiHang
    );
  END LOOP;

--Cập nhật các đơn hàng của gói hàng

UPDATE DonHang
  SET TrangThai = 'Đang vận chuyển'
  WHERE ID_DonHang IN (SELECT COLUMN_VALUE FROM TABLE(p_DS_DonHang));

  -- Commit toàn bộ
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Lỗi: ' || SQLERRM);
    RAISE;
END;
/

--- cập nhật thông tin đơn hàng
CREATE OR REPLACE PROCEDURE CapNhatDonHang (
  p_ID_DonHang        IN DonHang.ID_DonHang%TYPE,
  p_ID_KhachHang      IN DonHang.ID_KhachHang%TYPE,
  p_ID_NVGiaoHang     IN DonHang.ID_NVGiaoHang%TYPE,
  p_SDTNguoiGui       IN DonHang.SDTNguoiGui%TYPE,
  p_SDTNguoiNhan      IN DonHang.SDTNguoiNhan%TYPE,
  p_ID_KhoTiepNhan    IN DonHang.ID_KhoTiepNhan%TYPE,
  p_TenNguoiGui       IN DonHang.TenNguoiGui%TYPE,
  p_TenNguoiNhan      IN DonHang.TenNguoiNhan%TYPE,
  p_DiaChiNhan        IN DonHang.DiaChiNhan%TYPE,
  p_TienCOD           IN DonHang.TienCOD%TYPE,

  p_ThoiGianNhan      IN DonHang.ThoiGianNhan%TYPE,
  p_ThoiGianDuKien    IN DonHang.ThoiGianDuKien%TYPE,

  p_DichVu            IN DonHang.DichVu%TYPE,
  p_LoaiHangHoa       IN DonHang.LoaiHangHoa%TYPE
)
AS
BEGIN
  UPDATE DonHang
  SET
    ID_KhachHang     = p_ID_KhachHang,
    ID_NVGiaoHang    = p_ID_NVGiaoHang,
    SDTNguoiGui      = p_SDTNguoiGui,
    SDTNguoiNhan     = p_SDTNguoiNhan,
    ID_KhoTiepNhan   = p_ID_KhoTiepNhan,
    TenNguoiGui      = p_TenNguoiGui,
    TenNguoiNhan     = p_TenNguoiNhan,
    DiaChiNhan       = p_DiaChiNhan,
    TienCOD          = p_TienCOD,

    ThoiGianNhan     = p_ThoiGianNhan,
    ThoiGianDuKien   = p_ThoiGianDuKien,

    DichVu           = p_DichVu,
    LoaiHangHoa      = p_LoaiHangHoa
  WHERE ID_DonHang = p_ID_DonHang;

  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Lỗi khi cập nhật đơn hàng: ' || SQLERRM);
    RAISE;
END;
/

    ---lấy thông tin nv giao hang theo kho
CREATE OR REPLACE PROCEDURE LayDanhSachNVGiaoHangTheoKho (
    p_ID_Kho IN NhanVienGiaoHang.ID_Kho%TYPE,
    p_Cursor OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_Cursor FOR
    SELECT *
    FROM NhanVienGiaoHang
    WHERE ID_Kho = p_ID_Kho;
END;
/
--- Cập nhật trạng thái đơn hàng cho nv giao hàng
CREATE OR REPLACE PROCEDURE CapNhatTrangThaiDonHang (
    p_ID_DonHang IN NUMBER,
    p_TrangThai IN NVARCHAR2
)
AS
BEGIN

	IF(p_TrangThai = 'Đã giao' OR p_TrangThai = 'Giao thất bại') THEN
	  UPDATE DonHang
	  SET TrangThai = p_TrangThai
	  WHERE ID_DonHang = p_ID_DonHang;
	ELSE
		 RAISE_APPLICATION_ERROR(-20015, 'Cập nhật trạng thái đơn hàng thất bại.');
	END IF;

  COMMIT;
END;
/
--- lấy danh sách đơn hàng của user
---tao ref cur de chua 1 danh sach
CREATE OR REPLACE PACKAGE ds AS
    TYPE dsdh IS REF CURSOR;
END ds;
/
    ---viet procedure
CREATE OR REPLACE PROCEDURE LayDSDHCuaNVGH(
    p_id IN NUMBER,
    p_cursor OUT ds.dsdh
)
AS
BEGIN
    OPEN p_cursor FOR
        SELECT d.ID_DONHANG, d.TENNGUOINHAN, d.DIACHINHAN, d.SDTNGUOINHAN, d.TRANGTHAI,d.TIENCOD,d.THOIGIANTAO, d.SDTNGUOIGUI, d.TENNGUOIGUI, d.ID_KhoTiepNhan
        FROM DONHANG d
        JOIN NhanVienGiaoHang n on d.ID_NVGiaoHang = n.ID_NVGiaoHang
        WHERE n.ID_TAIKHOAN = p_id;
END;
/
--- thêm mới báo cáo giao hàng
CREATE OR REPLACE PROCEDURE ThemBaoCaoGiaoHang(
  p_ID_Tk  IN NUMBER,
  p_SlDaGiao        IN NUMBER,
  p_SlGiaoThatBai   IN NUMBER,
  p_COD             IN NUMBER
) IS
    p_idnv number;
BEGIN

    select n.ID_NVGIAOHANG into p_idnv
    from NhanVienGiaoHang n
        where n.ID_TAIKHOAN = p_ID_Tk;

  -- Thêm báo cáo giao hàng
  INSERT INTO BaoCaoGiaoHang(
    ID_BaoCaoGiaoHang,
    ID_NVGiaoHang,
    TongDonHangDaGiao,
    TongDHGiaoThatBai,
    TongTienCOD,
    NgayKhoiTao
  )
  VALUES (
    seq_BaoCaoGiaoHang.NEXTVAL,
    p_idnv,
    p_SlDaGiao,
    p_SlGiaoThatBai,
    p_COD,
    SYSTIMESTAMP
  );

  COMMIT;
END;
/
--- thêm quyền với mỗi vai trò
CREATE OR REPLACE PROCEDURE PhanQuyen(
    p_ID_TaiKhoan IN TaiKhoan.ID_TaiKhoan%TYPE,
    p_VaiTro      IN VARCHAR2
)
IS
    v_now DATE := SYSDATE;
BEGIN
    IF p_VaiTro = 'Nhân viên kho' THEN
        INSERT INTO TaiKhoan_PhanQuyen(ID_TaiKhoan, ID_Quyen, NGAYTAO) VALUES (p_ID_TaiKhoan, 2, v_now);
        INSERT INTO TaiKhoan_PhanQuyen(ID_TaiKhoan, ID_Quyen, NGAYTAO) VALUES (p_ID_TaiKhoan, 3, v_now);
        INSERT INTO TaiKhoan_PhanQuyen(ID_TaiKhoan, ID_Quyen, NGAYTAO) VALUES (p_ID_TaiKhoan, 6, v_now);
        INSERT INTO TaiKhoan_PhanQuyen(ID_TaiKhoan, ID_Quyen, NGAYTAO) VALUES (p_ID_TaiKhoan, 8, v_now);

    ELSIF p_VaiTro = 'Quản lý' THEN
        INSERT INTO TaiKhoan_PhanQuyen(ID_TaiKhoan, ID_Quyen, NGAYTAO) VALUES (p_ID_TaiKhoan, 3, v_now);
        INSERT INTO TaiKhoan_PhanQuyen(ID_TaiKhoan, ID_Quyen, NGAYTAO) VALUES (p_ID_TaiKhoan, 4, v_now);
        INSERT INTO TaiKhoan_PhanQuyen(ID_TaiKhoan, ID_Quyen, NGAYTAO) VALUES (p_ID_TaiKhoan, 7, v_now);
        INSERT INTO TaiKhoan_PhanQuyen(ID_TaiKhoan, ID_Quyen, NGAYTAO) VALUES (p_ID_TaiKhoan, 10, v_now);

    ELSIF p_VaiTro = 'Khách hàng' THEN
        INSERT INTO TaiKhoan_PhanQuyen(ID_TaiKhoan, ID_Quyen, NGAYTAO) VALUES (p_ID_TaiKhoan, 1, v_now);
        INSERT INTO TaiKhoan_PhanQuyen(ID_TaiKhoan, ID_Quyen, NGAYTAO) VALUES (p_ID_TaiKhoan, 3, v_now);

    ELSIF p_VaiTro = 'Nhân viên giao hàng' THEN
        INSERT INTO TaiKhoan_PhanQuyen(ID_TaiKhoan, ID_Quyen, NGAYTAO) VALUES (p_ID_TaiKhoan, 3, v_now);
        INSERT INTO TaiKhoan_PhanQuyen(ID_TaiKhoan, ID_Quyen, NGAYTAO) VALUES (p_ID_TaiKhoan, 5, v_now);
        INSERT INTO TaiKhoan_PhanQuyen(ID_TaiKhoan, ID_Quyen, NGAYTAO) VALUES (p_ID_TaiKhoan, 9, v_now);

    ELSE
        RAISE_APPLICATION_ERROR(-20031, 'Vai trò không hợp lệ hoặc chưa được định nghĩa.');
    END IF;
    COMMIT;
END;
/

--- thêm nhân viên kho ( thêm tài khoản trước )

CREATE OR REPLACE PROCEDURE ThemNhanVienKho (
    p_TenTaiKhoan  IN  TaiKhoan.TenTaiKhoan%TYPE,
    p_MatKhauMaHoa IN  TaiKhoan.MatKhauMaHoa%TYPE,
    p_HoTen        IN  NhanVienKho.HoTen%TYPE,
    p_SDT          IN  NhanVienKho.SDT%TYPE,
    p_Email        IN  NhanVienKho.Email%TYPE,
    p_CCCD         IN  NhanVienKho.CCCD%TYPE,
    p_NgaySinh     IN  NhanVienKho.NgaySinh%TYPE,
    p_GioiTinh     IN  NhanVienKho.GioiTinh%TYPE,
    p_DiaChi       IN  NhanVienKho.DiaChi%TYPE,
    p_ID_Kho       IN  NhanVienKho.ID_Kho%TYPE,
    p_ID_QuanLy    IN  NhanVienKho.ID_QuanLy%TYPE,
    p_MucLuong     IN  NhanVienKho.MucLuong%TYPE
) IS
    v_ID_TaiKhoan TaiKhoan.ID_TaiKhoan%TYPE;
    v_ID_NhanVien NhanVienKho.ID_NhanVien%TYPE;
BEGIN
    v_ID_TaiKhoan := TaoTaiKhoanNVK_Func(p_TenTaiKhoan, p_MatKhauMaHoa);
    v_ID_NhanVien := SEQ_NHANVIENKHO.NEXTVAL;
    INSERT INTO NhanVienKho (
      ID_NhanVien, ID_TaiKhoan, HoTen, SDT, Email, CCCD,
      NgaySinh, GioiTinh, DiaChi, ID_Kho, ID_QuanLy, MucLuong
    ) VALUES (
      v_ID_NhanVien, v_ID_TaiKhoan, p_HoTen, p_SDT, p_Email, p_CCCD,
      p_NgaySinh, p_GioiTinh, p_DiaChi, p_ID_Kho, p_ID_QuanLy, p_MucLuong
    );

    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20021,'Trùng SDT/Email/CCCD.');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20022,'Lỗi thêm NV kho: ');
END ThemNhanVienKho;
/
---SELECT * FROM TAIKHOAN t;
CREATE OR REPLACE FUNCTION TaoTaiKhoanNVK_Func (
    p_TenTaiKhoan   IN TaiKhoan.TenTaiKhoan%TYPE,
    p_MatKhauMaHoa  IN TaiKhoan.MatKhauMaHoa%TYPE
)
RETURN NUMBER
IS
    v_ID TaiKhoan.ID_TaiKhoan%TYPE;
BEGIN
    v_ID := SEQ_TAIKHOAN.NEXTVAL;
    INSERT INTO TaiKhoan (ID_TaiKhoan, NgayTao, TenTaiKhoan, MatKhauMaHoa,VaiTro, TrangThaiXoa)
    VALUES (v_ID, SYSDATE, p_TenTaiKhoan, p_MatKhauMaHoa,'NVK',0);
    RETURN v_ID;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        -- noinspection SqlMissingReturn
        RAISE_APPLICATION_ERROR(-20071,'Tên tài khoản đã tồn tại.');
    WHEN OTHERS THEN
        -- noinspection SqlMissingReturn
        RAISE_APPLICATION_ERROR(-20072,'Lỗi tạo tài khoản');
END TaoTaiKhoanNVK_Func;
/


---thêm nhân viên giao hàng (thêm tài khoản rồi thêm nhân viên)
CREATE OR REPLACE PROCEDURE ThemNhanVienGiaoHang (
    p_TenTaiKhoan  IN  TaiKhoan.TenTaiKhoan%TYPE,
    p_MatKhauMaHoa IN  TaiKhoan.MatKhauMaHoa%TYPE,
    p_HoTen        IN  NhanVienGiaoHang.HoTen%TYPE,
    p_SDT          IN  NhanVienGiaoHang.SDT%TYPE,
    p_Email        IN  NhanVienGiaoHang.Email%TYPE,
    p_CCCD         IN  NhanVienGiaoHang.CCCD%TYPE,
    p_NgaySinh     IN  NhanVienGiaoHang.NgaySinh%TYPE,
    p_GioiTinh     IN  NhanVienGiaoHang.GioiTinh%TYPE,
    p_DiaChi       IN  NhanVienGiaoHang.DiaChi%TYPE,
    p_ID_Kho       IN  NhanVienGiaoHang.ID_Kho%TYPE,
    p_ID_QuanLy    IN  NhanVienGiaoHang.ID_QuanLy%TYPE,
    p_DanhGia      IN  NhanVienGiaoHang.DiemDanhGia%TYPE
) IS
    v_ID_TaiKhoan    TaiKhoan.ID_TaiKhoan%TYPE;
    v_ID_NVGiaoHang  NhanVienGiaoHang.ID_NVGiaoHang%TYPE;
BEGIN
    v_ID_TaiKhoan   := TaoTaiKhoanNVGH_Func(p_TenTaiKhoan, p_MatKhauMaHoa);
    v_ID_NVGiaoHang := SEQ_NHANVIENGIAOHANG.NEXTVAL;

    INSERT INTO NhanVienGiaoHang (
      ID_NVGiaoHang, ID_TaiKhoan, HoTen, SDT, Email, CCCD,
      NgaySinh, GioiTinh, DiaChi, ID_Kho, ID_QuanLy, DiemDanhGia
    ) VALUES (
      v_ID_NVGiaoHang, v_ID_TaiKhoan, p_HoTen, p_SDT, p_Email, p_CCCD,
      p_NgaySinh, p_GioiTinh, p_DiaChi, p_ID_Kho, p_ID_QuanLy, p_DanhGia
    );
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20031,'Trùng SDT/Email/CCCD.');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20032,'Lỗi thêm NV giao.');
END ThemNhanVienGiaoHang;
/

---chỉnh trạng thái token khi đăng xuất
CREATE OR REPLACE PROCEDURE CapNhatToken (
    p_ID_TaiKhoan   IN TaiKhoan.ID_TaiKhoan%TYPE
)
AS

BEGIN
    -- 1. Kiểm tra tài khoản có tồn tại không
    DECLARE
        v_count NUMBER;
    BEGIN
        SELECT 1 INTO v_count
        FROM TaiKhoan
        WHERE ID_TaiKhoan = p_ID_TaiKhoan;

        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Tài khoản không tồn tại.');
        END IF;
    END;

    -- 2. Thu hồi các token cũ của tài khoản này
    UPDATE TaiKhoan_Token
    SET BiThuHoi = 1
    WHERE ID_TaiKhoan = p_ID_TaiKhoan
      AND BiThuHoi = 0;
    COMMIT;
END;
/
---thêm khách hàng (thêm tài khoản rồi thêm khách hàng)
CREATE OR REPLACE PROCEDURE ThemKhachHang (
    p_TenTaiKhoan   IN  TaiKhoan.TenTaiKhoan%TYPE,
    p_MatKhauMaHoa  IN  TaiKhoan.MatKhauMaHoa%TYPE,
    p_HoTen         IN  KhachHang.HoTen%TYPE,
    p_SDT           IN  KhachHang.SDT%TYPE,
    p_Email         IN  KhachHang.Email%TYPE,
    p_CCCD          IN  KhachHang.CCCD%TYPE,
    p_NgaySinh      IN  KhachHang.NgaySinh%TYPE,
    p_GioiTinh      IN  KhachHang.GioiTinh%TYPE
) IS
    v_ID_TaiKhoan   TaiKhoan.ID_TaiKhoan%TYPE;
    v_ID_KhachHang  KhachHang.ID_KhachHang%TYPE;
BEGIN
    v_ID_TaiKhoan := TAOTAIKHOANKH_FUNC(p_TenTaiKhoan, p_MatKhauMaHoa);
    v_ID_KhachHang := SEQ_KHACHHANG.NEXTVAL;

    INSERT INTO KhachHang (
        ID_KhachHang, ID_TaiKhoan, HoTen, SDT, Email, CCCD,
        NgaySinh, GioiTinh
    ) VALUES (
        v_ID_KhachHang, v_ID_TaiKhoan, p_HoTen, p_SDT,
        p_Email, p_CCCD, p_NgaySinh, p_GioiTinh
    );

    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20041, 'Lỗi trùng SDT, Email hoặc CCCD khách hàng.');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20042, 'Lỗi thêm khách hàng');
END ThemKhachHang;
/
---xóa tài khoản (chỉnh trạng thái xóa=true và chuyển toàn bộ thông tin khách hàng,nhân viên sang null và giữ lại ID )
CREATE OR REPLACE PROCEDURE XoaTaiKhoan (
    p_ID_TaiKhoan  IN TaiKhoan.ID_TaiKhoan%TYPE
) IS
BEGIN
    UPDATE TaiKhoan
       SET TrangThaiXoa = 1
     WHERE ID_TaiKhoan = p_ID_TaiKhoan;
    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20051, 'Không tìm thấy tài khoản '||p_ID_TaiKhoan);
    END IF;


    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20052, 'Lỗi xóa tài khoản: ' || SQLERRM);
END XoaTaiKhoan;
/


--- trigger
CREATE OR REPLACE TRIGGER TRG_CAPNHATDIEMDANHGIA_NVGH
FOR INSERT ON DANHGIA
COMPOUND TRIGGER

  TYPE IDDonHangList IS TABLE OF DANHGIA.ID_DonHang%TYPE;
  g_ID_DonHang_List IDDonHangList := IDDonHangList();

AFTER EACH ROW IS
BEGIN
  -- Lưu lại ID đơn hàng mới insert
  g_ID_DonHang_List.EXTEND;
  g_ID_DonHang_List(g_ID_DonHang_List.COUNT) := :NEW.ID_DonHang;
END AFTER EACH ROW;

AFTER STATEMENT IS
  v_ID_NVGiaoHang DONHANG.ID_NVGiaoHang%TYPE;
  v_avg_score NUMBER(3,1);
BEGIN
  FOR i IN 1 .. g_ID_DonHang_List.COUNT LOOP
    BEGIN
      -- Lấy ID nhân viên giao hàng từ đơn hàng
      SELECT ID_NVGiaoHang
        INTO v_ID_NVGiaoHang
        FROM DONHANG
        WHERE ID_DonHang = g_ID_DonHang_List(i);

      -- Tính điểm trung bình đánh giá, nếu không có đánh giá thì mặc định 5.0
      SELECT NVL(ROUND(AVG(DG.DiemDanhGia), 1), 5.0)
        INTO v_avg_score
        FROM DonHang DH
        JOIN DanhGia DG ON DH.ID_DonHang = DG.ID_DonHang
        WHERE DH.ID_NVGiaoHang = v_ID_NVGiaoHang;

      -- Cập nhật điểm trung bình đánh giá cho nhân viên giao hàng
      UPDATE NhanVienGiaoHang
        SET DiemDanhGia = v_avg_score
        WHERE ID_NVGiaoHang = v_ID_NVGiaoHang;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        NULL; -- xử lý nếu đơn hàng không tồn tại
    END;
  END LOOP;
END AFTER STATEMENT;
END TRG_CAPNHATDIEMDANHGIA_NVGH;
/

--- dam bao trang thai duoc thay doi theo trinh tu
CREATE OR REPLACE TRIGGER TRG_QLY_TRANGTHAI
BEFORE UPDATE ON DONHANG
FOR EACH ROW
DECLARE
    v_trangthai DONHANG.TRANGTHAI%TYPE;
BEGIN
    -- Chỉ kiểm tra khi trạng thái thực sự bị thay đổi
    IF :OLD.TrangThai != :NEW.TrangThai THEN
        v_trangthai := :OLD.TrangThai;

        IF v_trangthai = 'Đang xử lý' AND :NEW.TrangThai NOT IN ('Đang vận chuyển','Hủy') THEN
 
   RAISE_APPLICATION_ERROR(-20003, 'Lỗi trạng thái: "Đang xử lý" chỉ được chuyển sang "Đang vận chuyển" hoặc "Hủy".');
        ELSIF v_trangthai = 'Đang vận chuyển' AND :NEW.TrangThai <> 'Đang giao' THEN
 
   RAISE_APPLICATION_ERROR(-20004, 'Lỗi trạng thái: "Đang vận chuyển" chỉ được chuyển sang "Đang giao".');
        ELSIF v_trangthai = 'Đang giao' AND :NEW.TrangThai NOT IN ('Đã giao','Giao thất bại') THEN
 
   RAISE_APPLICATION_ERROR(-20004, 'Lỗi trạng thái: "Đang giao" chỉ được chuyển sang "Đã giao" hoặc "Giao thất bại".');
        ELSIF v_trangthai IN ('Đã giao','Hủy','Giao thất bại') THEN
 
   RAISE_APPLICATION_ERROR(-20005, 'Lỗi trạng thái: Đơn hàng đã ở "' || v_trangthai || '", không thể thay đổi thêm.');
        END IF;
    END IF;
END;

/

--- chi duoc danh gia khi don hang da giao
CREATE OR REPLACE TRIGGER trg_qly_danhgia
BEFORE INSERT OR UPDATE ON DANHGIA
FOR EACH ROW
DECLARE
    v_trangthai DONHANG.TrangThai%TYPE;
BEGIN

    SELECT TRANGTHAI INTO v_trangthai
        FROM DONHANG dh
        WHERE dh.ID_DonHang = :NEW.ID_DonHang;

    IF(v_trangthai <> 'Đã giao') THEN
 
 RAISE_APPLICATION_ERROR(-20007, 'Lỗi trạng thái: Không thể đánh giá đơn hàng chưa được giao.');
    END IF;

END;
/

---trigger
CREATE OR REPLACE TRIGGER TRG_CAPNHATVAKIEMTRADONHANG
BEFORE UPDATE OF ID_NVGIAOHANG ON DONHANG
FOR EACH ROW
DECLARE
    v_KhoNhanVien NUMBER;
    v_khonhan NUMBER;
BEGIN
    -- Kiểm tra nếu có gán id nhân viên giao hàng
    IF :NEW.ID_NVGIAOHANG IS NOT NULL THEN
        -- Lấy kho của nhân viên giao hàng
        BEGIN
 
   SELECT ID_Kho INTO v_KhoNhanVien
 
   FROM NhanVienGiaoHang
 
   WHERE ID_NVGiaoHang = :NEW.ID_NVGiaoHang;
        EXCEPTION
 
   WHEN NO_DATA_FOUND THEN
 
       RAISE_APPLICATION_ERROR(-20002, 'Không tìm thấy nhân viên giao hàng.');
        END;

        -- Lấy kho đang chứa đơn hàng (chỉ lấy 1 dòng)
        BEGIN
 
   SELECT ID_KHOHANGDEN INTO v_khonhan
 
   FROM (
 
       SELECT G.ID_KHOHANGDEN
 
       FROM GOIHANG G
 
       JOIN CHITIETGOIHANG C ON G.ID_GOIHANG = C.ID_GOIHANG
 
       WHERE C.ID_DONHANG = :NEW.ID_DONHANG
 
       AND ROWNUM = 1
 
   );
        EXCEPTION
 
   WHEN NO_DATA_FOUND THEN
 
       RAISE_APPLICATION_ERROR(-20003, 'Không tìm thấy gói hàng cho đơn hàng.');
        END;

        -- So sánh kho
        IF v_KhoNhanVien != v_khonhan THEN
 
   RAISE_APPLICATION_ERROR(-20001, 'Nhân viên giao hàng không thuộc kho tiếp nhận của đơn hàng.');
        ELSE
 
   -- Nếu đúng kho, cập nhật trạng thái là 'Đang giao'
 
   :NEW.TRANGTHAI := 'Đang giao';

 
   -- Cập nhật tồn kho (không cần COMMIT trong trigger)
 
   UPDATE KHOHANG
 
   SET SLHANGTON = SLHANGTON - 1
 
   WHERE ID_KHO = v_khonhan;
        END IF;
    END IF;
END;
/
CREATE OR REPLACE TRIGGER trg_CapNhatSoLuong_GoiHang
FOR INSERT OR UPDATE OR DELETE ON ChiTietGoiHang
COMPOUND TRIGGER

  --Tạo list chứa danh sách các í_donhang cần sửa
  TYPE IDList IS TABLE OF ChiTietGoiHang.ID_GoiHang%TYPE INDEX BY PLS_INTEGER;
  v_IDs IDList;
  v_Count PLS_INTEGER := 0;

  ---Xử lý các trường hợp trạng thái xảy ra
  AFTER EACH ROW IS
  BEGIN
    IF INSERTING OR UPDATING THEN
      v_Count := v_Count + 1;
      v_IDs(v_Count) := :NEW.ID_GoiHang;
    ELSIF DELETING THEN
      v_Count := v_Count + 1;
      v_IDs(v_Count) := :OLD.ID_GoiHang;
    END IF;
  END AFTER EACH ROW;

  ---Sau khi các trạng thái đã xảy ra thực hiện cập nhật SL
  AFTER STATEMENT IS
  BEGIN
    FOR i IN 1 .. v_Count LOOP
      BEGIN
        UPDATE GoiHang
        SET SoLuong = (
 
 SELECT COUNT(*) FROM ChiTietGoiHang
 
 WHERE ID_GoiHang = v_IDs(i)
        )
        WHERE ID_GoiHang = v_IDs(i);
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
 
 RAISE_APPLICATION_ERROR(-20004, 'Cập nhật gói hàng không thành công');

      END;
    END LOOP;
  END AFTER STATEMENT;

END trg_CapNhatSoLuong_GoiHang;
/
CREATE OR REPLACE TRIGGER trg_CapNhatSLHangTon_GoiHang
AFTER UPDATE OF TrangThai ON GoiHang
FOR EACH ROW
DECLARE
  v_SoLuong NUMBER := :NEW.SoLuong;
BEGIN
  IF :NEW.TrangThai = 'Đang chuyển kho' THEN
    -- Giảm hàng tồn của kho gửi khi vừa được xuất kho
    UPDATE KhoHang
    SET SLHangTon = SLHangTon - v_SoLuong
    WHERE ID_Kho = :NEW.ID_KhoHangGui;

  ELSIF :NEW.TrangThai = 'Hoàn thành' AND :OLD.TrangThai != 'Đang chuyển kho' THEN
    -- Tăng hàng tồn của kho nhận khi gói được nhập kho
    UPDATE KhoHang
    SET SLHangTon = SLHangTon + v_SoLuong
    WHERE ID_Kho = :NEW.ID_KhoHangDen;
  END IF;
END;
/

-- Khi tạo gói hàng, các đơn hàng thuộc gói hàng chuyển trạng thái đang vận chuyển và cập nhật số lượng tồn kho ở kho đầu và kho đích
CREATE OR REPLACE TRIGGER trg_TaoGoiHang
AFTER INSERT or update ON GoiHang
FOR EACH ROW
DECLARE
  CURSOR cur_DonHang IS
    SELECT ID_DonHang FROM ChiTietGoiHang WHERE ID_GoiHang = :NEW.ID_GoiHang;
BEGIN
  FOR dh IN cur_DonHang LOOP
    -- Cập nhật trạng thái đơn hàng
    UPDATE DonHang
    SET TrangThai = 'Đang vận chuyển'
    WHERE ID_DonHang = dh.ID_DonHang;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20005, 'Tạo gói hàng không thành công');
END;
/

CREATE OR REPLACE TRIGGER trg_CapNhatTonKho_GiaoThatBai
AFTER UPDATE OF TrangThai ON DonHang
FOR EACH ROW

DECLARE
    v_idkho number;
BEGIN
	IF(:NEW.TrangThai = 'Giao thất bại' AND :OLD.TrangThai != 'Đang giao') THEN

	    --- lay id_kho
        select n.ID_KHO into v_idkho
        from NHANVIENGIAOHANG n
        where :new.ID_NVGIAOHANG = n.ID_NVGIAOHANG;

        -- Lấy số lượng tồn kho hiện tại của kho tiếp nhận
        UPDATE KhoHang
        SET SLHangTon = SLHangTon + 1
        WHERE ID_Kho = v_idkho;

	END IF;

END;
/

-- RB B1.2: Mỗi shipper bị giới hạn tối đa 20 đơn hàng có thể nhận cùng lúc, nếu vượt quá, shipper không thể nhận thêm đơn hàng mới cho đến khi hoàn thành hoặc h
--hủy đơn cũ.
CREATE OR REPLACE TRIGGER trg_gioi_han_don_hang
FOR UPDATE ON DonHang
COMPOUND TRIGGER

    -- Tập hợp các ID_NVGiaoHang mới được gán trong transaction
    TYPE ShipperSet IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    shipper_ids ShipperSet;
    idx INTEGER := 0;

BEFORE EACH ROW IS
BEGIN
    -- Ghi nhận shipper mới được gán (chỉ khi là lần đầu)
    IF :NEW.ID_NVGiaoHang IS NOT NULL AND :OLD.ID_NVGiaoHang IS NULL THEN
        idx := idx + 1;
        shipper_ids(idx) := :NEW.ID_NVGiaoHang;
    END IF;
END BEFORE EACH ROW;

AFTER STATEMENT IS
    v_count NUMBER;
BEGIN
    -- Duyệt qua từng shipper được gán trong transaction
    FOR i IN 1 .. idx LOOP
        -- Kiểm tra số lượng đơn "Đang giao" của shipper đó
        SELECT COUNT(*) INTO v_count
        FROM DonHang
        WHERE ID_NVGiaoHang = shipper_ids(i)
 
 AND TrangThai = 'Đang giao';

        IF v_count > 20 THEN
 
   RAISE_APPLICATION_ERROR(-20004,
 
       'Shipper ID ' || shipper_ids(i) || ' đã nhận quá 20 đơn hàng đang giao.');
        END IF;
    END LOOP;
END AFTER STATEMENT;

END trg_gioi_han_don_hang;


/

--- chi duoc huy don hang khi trang thai la 'dang xu ly'
CREATE OR REPLACE TRIGGER trg_CheckHuyDon
  BEFORE UPDATE OF TrangThai
  ON DonHang
  FOR EACH ROW
BEGIN
  IF :NEW.TrangThai = 'Hủy' THEN
    IF :OLD.TrangThai != 'Đang xử lý' THEN
      RAISE_APPLICATION_ERROR(-20062, 'Chỉ được hủy khi đơn hàng đang xử lý. Hiện tại là: '||:OLD.TrangThai);
    END IF;
  END IF;
END trg_CheckHuyDon;
/
---thời gian nhận = systime khi trạng thái đơn hàng là “đã giao”
CREATE OR REPLACE TRIGGER trg_CapNhatThoiGianNhan
BEFORE UPDATE ON DonHang
FOR EACH ROW
BEGIN
  IF :NEW.TrangThai = 'Đã giao' AND (:OLD.TrangThai IS NULL OR :OLD.TrangThai != 'Đã giao') THEN
    :NEW.ThoiGianNhan := SYSTIMESTAMP;
  END IF;
END;
/

---Cập nhật số lượng tồn kho khi thêm đơn hàng
CREATE OR REPLACE TRIGGER TRG_CapNhatSLTon_KhiThemDonHang
AFTER INSERT ON DonHang
FOR EACH ROW
BEGIN
    UPDATE KhoHang
    SET SLHangTon = NVL(SLHangTon, 0) + 1
    WHERE ID_Kho = :NEW.ID_KhoTiepNhan;
END;
/

-- Chèn dữ liệu vào bảng KhoHang

INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Hà Nội', 1000, 0, 'Hà Nội, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'TP Hồ Chí Minh', 1500, 0, 'TP Hồ Chí Minh, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Đà Nẵng', 800, 0, 'Đà Nẵng, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Hải Phòng', 900, 0, 'Hải Phòng, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Cần Thơ', 700, 0, 'Cần Thơ, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'An Giang', 600, 0, 'An Giang, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Bà Rịa - Vũng Tàu', 750, 0, 'Bà Rịa - Vũng Tàu, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Bắc Giang', 550, 0, 'Bắc Giang, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Bắc Kạ', 400, 0, 'Bắc Kạn, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Bạc Liêu', 500, 0, 'Bạc Liêu, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Bắc Ninh', 650, 0, 'Bắc Ninh, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Bến Tre', 580, 0, 'Bến Tre, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Bình Định', 620, 0, 'Bình Định, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Bình Dương', 1200, 0, 'Bình Dương, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Bình Phước', 680, 0, 'Bình Phước, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Bình Thuậ', 700, 0, 'Bình Thuận, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Cà Mau', 530, 0, 'Cà Mau, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Cao Bằng', 450, 0, 'Cao Bằng, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Đắk Lắk', 800, 0, 'Đắk Lắk, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Đắk Nông', 500, 0, 'Đắk Nông, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Điện Biê', 380, 0, 'Điện Biên, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Đồng Nai', 1100, 0, 'Đồng Nai, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Đồng Tháp', 600, 0, 'Đồng Tháp, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Gia Lai', 750, 0, 'Gia Lai, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Hà Giang', 420, 0, 'Hà Giang, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Hà Nam', 580, 0, 'Hà Nam, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Hà Tĩnh', 650, 0, 'Hà Tĩnh, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Hải Dương', 700, 0, 'Hải Dương, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Hậu Giang', 520, 0, 'Hậu Giang, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Hòa Bình', 480, 0, 'Hòa Bình, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Hưng Yê', 630, 0, 'Hưng Yên, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Khánh Hòa', 850, 0, 'Khánh Hòa, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Kiên Giang', 720, 0, 'Kiên Giang, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Kon Tum', 470, 0, 'Kon Tum, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Lai Châu', 350, 0, 'Lai Châu, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Lâm Đồng', 800, 0, 'Lâm Đồng, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Lạng Sơ', 500, 0, 'Lạng Sơn, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Lào Cai', 550, 0, 'Lào Cai, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Long A', 900, 0, 'Long An, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Nam Định', 680, 0, 'Nam Định, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Nghệ A', 950, 0, 'Nghệ An, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Ninh Bình', 580, 0, 'Ninh Bình, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Ninh Thuậ', 520, 0, 'Ninh Thuận, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Phú Thọ', 600, 0, 'Phú Thọ, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Phú Yê', 650, 0, 'Phú Yên, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Quảng Bình', 700, 0, 'Quảng Bình, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Quảng Nam', 800, 0, 'Quảng Nam, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Quảng Ngãi', 750, 0, 'Quảng Ngãi, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Quảng Ninh', 1000, 0, 'Quảng Ninh, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Quảng Trị', 620, 0, 'Quảng Trị, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Sóc Trăng', 500, 0, 'Sóc Trăng, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Sơn La', 450, 0, 'Sơn La, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Tây Ninh', 700, 0, 'Tây Ninh, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Thái Bình', 680, 0, 'Thái Bình, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Thái Nguyê', 750, 0, 'Thái Nguyên, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Thanh Hóa', 1000, 0, 'Thanh Hóa, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Thừa Thiên Huế', 800, 0, 'Thừa Thiên Huế, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Tiền Giang', 700, 0, 'Tiền Giang, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Trà Vinh', 550, 0, 'Trà Vinh, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Tuyên Quang', 480, 0, 'Tuyên Quang, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Vĩnh Long', 570, 0, 'Vĩnh Long, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Vĩnh Phúc', 650, 0, 'Vĩnh Phúc, Việt Nam');
INSERT INTO KhoHang (ID_Kho, TenKho, SLHangToiDa, SLHangTon, DiaChi) VALUES (seq_KhoHang.NEXTVAL, 'Yên Bái', 500, 0, 'Yên Bái, Việt Nam');
COMMIT;

--- chen du lieu bang taikhoan, taikhoan cho quan ly
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin4', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin5', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin6', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin7', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin8', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin9', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin10', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin11', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin12', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin13', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin14', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin15', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin16', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin17', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin18', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin19', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin20', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin21', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin22', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin23', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin24', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin25', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin26', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin27', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin28', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin29', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin30', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin31', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin32', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin33', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin34', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin35', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin36', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin37', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin38', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin39', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin40', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin41', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin42', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin43', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin44', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin45', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin46', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin47', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin48', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin49', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin50', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin51', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin52', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin53', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin54', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin55', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin56', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin57', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin58', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin59', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin60', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin61', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin62', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
INSERT INTO TaiKhoan (ID_TaiKhoan, TenTaiKhoan, MatKhauMaHoa, VaiTro) VALUES (seq_TaiKhoan.NEXTVAL, 'admin63', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'QL');
COMMIT;

---chen du lieu cho bang quanly
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 1, 1, 'Nguyễn Văn A', '0901234567', 'nguyen.van.a.1@gmail.com', '001123456789', TO_DATE('15-05-1990', 'DD-MM-YYYY'), 'Nam', 'Phường Hàng Buồm, Quận Hoàn Kiếm, Hà Nội, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 2, 2, 'Trần Thị B', '0912345678', 'tran.thi.b.2@gmail.com', '002234567890', TO_DATE('22-08-1988', 'DD-MM-YYYY'), 'Nữ', 'Phường Bến Nghé, Quận 1, TP Hồ Chí Minh, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 3, 3, 'Lê Văn C', '0923456789', 'le.van.c.3@gmail.com', '003345678901', TO_DATE('10-11-1992', 'DD-MM-YYYY'), 'Nam', 'Quận Hải Châu, Đà Nẵng, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 4, 4, 'Phạm Thị D', '0934567890', 'pham.thi.d.4@gmail.com', '004456789012', TO_DATE('01-03-1985', 'DD-MM-YYYY'), 'Nữ', 'Quận Ngô Quyền, Hải Phòng, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 5, 5, 'Hoàng Văn E', '0945678901', 'hoang.van.e.5@gmail.com', '005567890123', TO_DATE('07-07-1995', 'DD-MM-YYYY'), 'Nam', 'Quận Ninh Kiều, Cần Thơ, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 6, 6, 'Võ Thị F', '0967890123', 'vo.thi.f.6@gmail.com', '006678901234', TO_DATE('14-02-1991', 'DD-MM-YYYY'), 'Nữ', 'Thành phố Long Xuyên, An Giang, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 7, 7, 'Đặng Văn G', '0978901234', 'dang.van.g.7@gmail.com', '007789012345', TO_DATE('25-10-1987', 'DD-MM-YYYY'), 'Nam', 'Thành phố Vũng Tàu, Bà Rịa - Vũng Tàu, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 8, 8, 'Bùi Thị H', '0989012345', 'bui.thi.h.8@gmail.com', '008890123456', TO_DATE('05-01-1993', 'DD-MM-YYYY'), 'Nữ', 'Thành phố Bắc Giang, Bắc Giang, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 9, 9, 'Đỗ Văn I', '0990123456', 'do.van.i.9@gmail.com', '009901234567', TO_DATE('18-04-1986', 'DD-MM-YYYY'), 'Nam', 'Thành phố Bắc Kạn, Bắc Kạn, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 10, 10, 'Nguyễn Thị K', '0812345678', 'nguyen.thi.k.10@gmail.com', '010012345678', TO_DATE('30-09-1994', 'DD-MM-YYYY'), 'Nữ', 'Thành phố Bạc Liêu, Bạc Liêu, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 11, 11, 'Trần Văn L', '0823456789', 'tran.van.l.11@gmail.com', '011123456789', TO_DATE('03-06-1989', 'DD-MM-YYYY'), 'Nam', 'Thành phố Bắc Ninh, Bắc Ninh, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 12, 12, 'Lê Thị M', '0834567890', 'le.thi.m.12@gmail.com', '012234567890', TO_DATE('12-12-1996', 'DD-MM-YYYY'), 'Nữ', 'Thành phố Bến Tre, Bến Tre, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 13, 13, 'Phạm Văn ', '0845678901', 'pham.van.n.13@gmail.com', '013345678901', TO_DATE('20-01-1984', 'DD-MM-YYYY'), 'Nam', 'Thành phố Quy Nhơn, Bình Định, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 14, 14, 'Hoàng Thị O', '0856789012', 'hoang.thi.o.14@gmail.com', '014456789012', TO_DATE('08-03-1990', 'DD-MM-YYYY'), 'Nữ', 'Thành phố Thủ Dầu Một, Bình Dương, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 15, 15, 'Võ Văn P', '0867890123', 'vo.van.p.15@gmail.com', '015567890123', TO_DATE('19-07-1982', 'DD-MM-YYYY'), 'Nam', 'Thành phố Đồng Xoài, Bình Phước, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 16, 16, 'Đặng Thị Q', '0878901234', 'dang.thi.q.16@gmail.com', '016678901234', TO_DATE('04-04-1997', 'DD-MM-YYYY'), 'Nữ', 'Thành phố Phan Thiết, Bình Thuận, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 17, 17, 'Bùi Văn R', '0889012345', 'bui.van.r.17@gmail.com', '017789012345', TO_DATE('09-09-1983', 'DD-MM-YYYY'), 'Nam', 'Thành phố Cà Mau, Cà Mau, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 18, 18, 'Đỗ Thị S', '0701234567', 'do.thi.s.18@gmail.com', '018890123456', TO_DATE('28-06-1998', 'DD-MM-YYYY'), 'Nữ', 'Thành phố Cao Bằng, Cao Bằng, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 19, 19, 'Nguyễn Văn T', '0712345678', 'nguyen.van.t.19@gmail.com', '019901234567', TO_DATE('03-11-1979', 'DD-MM-YYYY'), 'Nam', 'Thành phố Buôn Ma Thuột, Đắk Lắk, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 20, 20, 'Trần Thị U', '0723456789', 'tran.thi.u.20@gmail.com', '020012345678', TO_DATE('20-05-1991', 'DD-MM-YYYY'), 'Nữ', 'Thành phố Gia Nghĩa, Đắk Nông, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 21, 21, 'Lê Văn V', '0734567890', 'le.van.v.21@gmail.com', '021123456789', TO_DATE('01-12-1980', 'DD-MM-YYYY'), 'Nam', 'Thành phố Điện Biên Phủ, Điện Biên, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 22, 22, 'Phạm Thị X', '0745678901', 'pham.thi.x.22@gmail.com', '022234567890', TO_DATE('17-08-1993', 'DD-MM-YYYY'), 'Nữ', 'Thành phố Biên Hòa, Đồng Nai, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 23, 23, 'Hoàng Văn Y', '0756789012', 'hoang.van.y.23@gmail.com', '023345678901', TO_DATE('09-02-1981', 'DD-MM-YYYY'), 'Nam', 'Thành phố Cao Lãnh, Đồng Tháp, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 24, 24, 'Võ Thị Z', '0767890123', 'vo.thi.z.24@gmail.com', '024456789012', TO_DATE('05-07-1996', 'DD-MM-YYYY'), 'Nữ', 'Thành phố Pleiku, Gia Lai, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 25, 25, 'Đặng Văn AA', '0778901234', 'dang.van.aa.25@gmail.com', '025567890123', TO_DATE('11-03-1987', 'DD-MM-YYYY'), 'Nam', 'Thành phố Hà Giang, Hà Giang, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 26, 26, 'Bùi Thị BB', '0789012345', 'bui.thi.bb.26@gmail.com', '026678901234', TO_DATE('29-10-1994', 'DD-MM-YYYY'), 'Nữ', 'Thành phố Phủ Lý, Hà Nam, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 27, 27, 'Đỗ Văn CC', '0790123456', 'do.van.cc.27@gmail.com', '027789012345', TO_DATE('01-01-1985', 'DD-MM-YYYY'), 'Nam', 'Thành phố Hà Tĩnh, Hà Tĩnh, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 28, 28, 'Nguyễn Thị DD', '0301234567', 'nguyen.thi.dd.28@gmail.com', '028890123456', TO_DATE('14-04-1990', 'DD-MM-YYYY'), 'Nữ', 'Thành phố Hải Dương, Hải Dương, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 29, 29, 'Trần Văn EE', '0312345678', 'tran.van.ee.29@gmail.com', '029901234567', TO_DATE('02-09-1988', 'DD-MM-YYYY'), 'Nam', 'Thành phố Vị Thanh, Hậu Giang, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 30, 30, 'Lê Thị FF', '0323456789', 'le.thi.ff.30@gmail.com', '030012345678', TO_DATE('25-06-1992', 'DD-MM-YYYY'), 'Nữ', 'Thành phố Hòa Bình, Hòa Bình, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 31, 31, 'Phạm Văn GG', '0334567890', 'pham.van.gg.31@gmail.com', '031123456789', TO_DATE('19-03-1986', 'DD-MM-YYYY'), 'Nam', 'Thành phố Hưng Yên, Hưng Yên, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 32, 32, 'Hoàng Thị HH', '0345678901', 'hoang.thi.hh.32@gmail.com', '032234567890', TO_DATE('08-11-1995', 'DD-MM-YYYY'), 'Nữ', 'Thành phố Nha Trang, Khánh Hòa, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 33, 33, 'Võ Văn II', '0356789012', 'vo.van.ii.33@gmail.com', '033345678901', TO_DATE('01-07-1983', 'DD-MM-YYYY'), 'Nam', 'Thành phố Rạch Giá, Kiên Giang, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 34, 34, 'Đặng Thị JJ', '0367890123', 'dang.thi.jj.34@gmail.com', '034456789012', TO_DATE('28-02-1997', 'DD-MM-YYYY'), 'Nữ', 'Thành phố Kon Tum, Kon Tum, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 35, 35, 'Bùi Văn KK', '0378901234', 'bui.van.kk.35@gmail.com', '035567890123', TO_DATE('05-05-1980', 'DD-MM-YYYY'), 'Nam', 'Thành phố Lai Châu, Lai Châu, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 36, 36, 'Đỗ Thị LL', '0389012345', 'do.thi.ll.36@gmail.com', '036678901234', TO_DATE('10-10-1991', 'DD-MM-YYYY'), 'Nữ', 'Thành phố Đà Lạt, Lâm Đồng, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 37, 37, 'Nguyễn Văn MM', '0390123456', 'nguyen.van.mm.37@gmail.com', '037789012345', TO_DATE('20-08-1984', 'DD-MM-YYYY'), 'Nam', 'Thành phố Lạng Sơn, Lạng Sơn, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 38, 38, 'Trần Thị ', '0501234567', 'tran.thi.nn.38@gmail.com', '038890123456', TO_DATE('31-01-1993', 'DD-MM-YYYY'), 'Nữ', 'Thành phố Lào Cai, Lào Cai, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 39, 39, 'Lê Văn OO', '0512345678', 'le.van.oo.39@gmail.com', '039901234567', TO_DATE('07-04-1989', 'DD-MM-YYYY'), 'Nam', 'Thành phố Tân An, Long An, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 40, 40, 'Phạm Thị PP', '0523456789', 'pham.thi.pp.40@gmail.com', '040012345678', TO_DATE('16-09-1996', 'DD-MM-YYYY'), 'Nữ', 'Thành phố Nam Định, Nam Định, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 41, 41, 'Hoàng Văn QQ', '0534567890', 'hoang.van.qq.41@gmail.com', '041123456789', TO_DATE('23-11-1982', 'DD-MM-YYYY'), 'Nam', 'Thành phố Vinh, Nghệ An, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 42, 42, 'Võ Thị RR', '0545678901', 'vo.thi.rr.42@gmail.com', '042234567890', TO_DATE('12-06-1990', 'DD-MM-YYYY'), 'Nữ', 'Thành phố Ninh Bình, Ninh Bình, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 43, 43, 'Đặng Văn SS', '0556789012', 'dang.van.ss.43@gmail.com', '043345678901', TO_DATE('08-01-1981', 'DD-MM-YYYY'), 'Nam', 'Thành phố Phan Rang - Tháp Chàm, Ninh Thuận, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 44, 44, 'Bùi Thị TT', '0567890123', 'bui.thi.tt.44@gmail.com', '044456789012', TO_DATE('03-03-1994', 'DD-MM-YYYY'), 'Nữ', 'Thành phố Việt Trì, Phú Thọ, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 45, 45, 'Đỗ Văn UU', '0578901234', 'do.van.uu.45@gmail.com', '045567890123', TO_DATE('27-07-1987', 'DD-MM-YYYY'), 'Nam', 'Thành phố Tuy Hòa, Phú Yên, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 46, 46, 'Nguyễn Thị VV', '0589012345', 'nguyen.thi.vv.46@gmail.com', '046678901234', TO_DATE('09-12-1998', 'DD-MM-YYYY'), 'Nữ', 'Thành phố Đồng Hới, Quảng Bình, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 47, 47, 'Trần Văn XX', '0590123456', 'tran.van.xx.47@gmail.com', '047789012345', TO_DATE('21-04-1985', 'DD-MM-YYYY'), 'Nam', 'Thành phố Tam Kỳ, Quảng Nam, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 48, 48, 'Lê Thị YY', '0700123456', 'le.thi.yy.48@gmail.com', '048890123456', TO_DATE('18-09-1990', 'DD-MM-YYYY'), 'Nữ', 'Thành phố Quảng Ngãi, Quảng Ngãi, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 49, 49, 'Phạm Văn ZZ', '0711234567', 'pham.van.zz.49@gmail.com', '049901234567', TO_DATE('06-02-1983', 'DD-MM-YYYY'), 'Nam', 'Thành phố Hạ Long, Quảng Ninh, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 50, 50, 'Hoàng Thị AAA', '0722345678', 'hoang.thi.aaa.50@gmail.com', '050012345678', TO_DATE('13-05-1996', 'DD-MM-YYYY'), 'Nữ', 'Thành phố Đông Hà, Quảng Trị, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 51, 51, 'Võ Văn BBB', '0733456789', 'vo.van.bbb.51@gmail.com', '051123456789', TO_DATE('04-10-1988', 'DD-MM-YYYY'), 'Nam', 'Thành phố Sóc Trăng, Sóc Trăng, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 52, 52, 'Đặng Thị CCC', '0744567890', 'dang.thi.ccc.52@gmail.com', '052234567890', TO_DATE('29-03-1991', 'DD-MM-YYYY'), 'Nữ', 'Thành phố Sơn La, Sơn La, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 53, 53, 'Bùi Văn DDD', '0755678901', 'bui.van.ddd.53@gmail.com', '053345678901', TO_DATE('01-06-1984', 'DD-MM-YYYY'), 'Nam', 'Thành phố Tây Ninh, Tây Ninh, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 54, 54, 'Đỗ Thị EEE', '0766789012', 'do.thi.eee.54@gmail.com', '054456789012', TO_DATE('17-01-1997', 'DD-MM-YYYY'), 'Nữ', 'Thành phố Thái Bình, Thái Bình, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 55, 55, 'Nguyễn Văn FFF', '0777890123', 'nguyen.van.fff.55@gmail.com', '055567890123', TO_DATE('08-08-1980', 'DD-MM-YYYY'), 'Nam', 'Thành phố Thái Nguyên, Thái Nguyên, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 56, 56, 'Trần Thị GGG', '0788901234', 'tran.thi.ggg.56@gmail.com', '056678901234', TO_DATE('22-11-1993', 'DD-MM-YYYY'), 'Nữ', 'Thành phố Thanh Hóa, Thanh Hóa, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 57, 57, 'Lê Văn HHH', '0799012345', 'le.van.hhh.57@gmail.com', '057789012345', TO_DATE('01-04-1986', 'DD-MM-YYYY'), 'Nam', 'Thành phố Huế, Thừa Thiên Huế, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 58, 58, 'Phạm Thị III', '0800123456', 'pham.thi.iii.58@gmail.com', '058890123456', TO_DATE('05-09-1995', 'DD-MM-YYYY'), 'Nữ', 'Thành phố Mỹ Tho, Tiền Giang, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 59, 59, 'Hoàng Văn JJJ', '0811234567', 'hoang.van.jjj.59@gmail.com', '059901234567', TO_DATE('11-12-1982', 'DD-MM-YYYY'), 'Nam', 'Thành phố Trà Vinh, Trà Vinh, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 60, 60, 'Võ Thị KKK', '0822345678', 'vo.thi.kkk.60@gmail.com', '060012345678', TO_DATE('20-07-1998', 'DD-MM-YYYY'), 'Nữ', 'Thành phố Tuyên Quang, Tuyên Quang, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 61, 61, 'Đặng Văn LLL', '0833456789', 'dang.van.lll.61@gmail.com', '061123456789', TO_DATE('09-03-1985', 'DD-MM-YYYY'), 'Nam', 'Thành phố Vĩnh Long, Vĩnh Long, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 62, 62, 'Bùi Thị MMM', '0844567890', 'bui.thi.mmm.62@gmail.com', '062234567890', TO_DATE('24-10-1990', 'DD-MM-YYYY'), 'Nữ', 'Thành phố Vĩnh Yên, Vĩnh Phúc, Việt Nam', 30000000);
INSERT INTO QuanLy (ID_QuanLy, ID_TaiKhoan, ID_Kho, HoTen, SDT, Email, CCCD, NgaySinh, GioiTinh, DiaChi, MucLuong) VALUES (seq_QuanLy.NEXTVAL, 63, 63, 'Đỗ Văn N', '0855678901', 'do.van.nnn.63@gmail.com', '063345678901', TO_DATE('18-05-1983', 'DD-MM-YYYY'), 'Nam', 'Thành phố Yên Bái, Yên Bái, Việt Nam', 30000000);
COMMIT;

CALL ThemNhanVienKho('nvk1_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho1_1', '0911000000', 'nvk1_1@mail.com', '120000000011', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 1, Số 1 Đường ABC, TP.HCM', 1, 1, 8200000);
CALL ThemNhanVienKho('nvk1_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho1_2', '0912000000', 'nvk1_2@mail.com', '120000000012', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 1, Số 2 Đường ABC, TP.HCM', 1, 1, 8400000);
CALL ThemNhanVienKho('nvk1_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho1_3', '0913000000', 'nvk1_3@mail.com', '120000000013', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 1, Số 3 Đường ABC, TP.HCM', 1, 1, 8600000);
CALL ThemNhanVienKho('nvk2_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho2_1', '0921000000', 'nvk2_1@mail.com', '120000000021', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 2, Số 1 Đường ABC, TP.HCM', 2, 2, 8200000);
CALL ThemNhanVienKho('nvk2_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho2_2', '0922000000', 'nvk2_2@mail.com', '120000000022', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 2, Số 2 Đường ABC, TP.HCM', 2, 2, 8400000);
CALL ThemNhanVienKho('nvk2_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho2_3', '0923000000', 'nvk2_3@mail.com', '120000000023', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 2, Số 3  ường ABC, TP.HCM', 2, 2, 8600000);
CALL ThemNhanVienKho('nvk3_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho3_1', '0931000000', 'nvk3_1@mail.com', '120000000031', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 3, Số 1 Đường ABC, TP.HCM', 3, 3, 8200000);
CALL ThemNhanVienKho('nvk3_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho3_2', '0932000000', 'nvk3_2@mail.com', '120000000032', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 3, Số 2 Đường ABC, TP.HCM', 3, 3, 8400000);
CALL ThemNhanVienKho('nvk3_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho3_3', '0933000000', 'nvk3_3@mail.com', '120000000033', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 3, Số 3 Đường ABC, TP.HCM', 3, 3, 8600000);
CALL ThemNhanVienKho('nvk4_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho4_1', '0941000000', 'nvk4_1@mail.com', '120000000041', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 4, Số 1 Đường ABC, TP.HCM', 4, 4, 8200000);
CALL ThemNhanVienKho('nvk4_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho4_2', '0942000000', 'nvk4_2@mail.com', '120000000042', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 4, Số 2 Đư  ng ABC, TP.HCM', 4, 4, 8400000);
CALL ThemNhanVienKho('nvk4_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho4_3', '0943000000', 'nvk4_3@mail.com', '120000000043', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 4, Số 3 Đường ABC, TP.HCM', 4, 4, 8600000);
CALL ThemNhanVienKho('nvk5_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho5_1', '0951000000', 'nvk5_1@mail.com', '120000000051', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 5, Số 1 Đường ABC, TP.HCM', 5, 5, 8200000);
CALL ThemNhanVienKho('nvk5_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho5_2', '0952000000', 'nvk5_2@mail.com', '120000000052', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 5, Số 2 Đường ABC, TP.HCM', 5, 5, 8400000);
CALL ThemNhanVienKho('nvk5_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho5_3', '0953000000', 'nvk5_3@mail.com', '120000000053', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 5, Số 3 Đường ABC, TP.HCM', 5, 5, 8600000);
CALL ThemNhanVienKho('nvk6_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho6_1', '0961000000', 'nvk6_1@mail.com', '120000000061', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 6, Số 1 Đường ABC, TP.HCM', 6, 6, 8200000);
CALL ThemNhanVienKho('nvk6_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho6_2', '0962000000', 'nvk6_2@mail.com', '120000000062', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 6, Số 2 Đường ABC, TP.HCM', 6, 6, 8400000);
CALL ThemNhanVienKho('nvk6_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho6_3', '0963000000', 'nvk6_3@mail.com', '120000000063', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 6, Số 3 Đường ABC, TP.HCM', 6, 6, 8600000);
CALL ThemNhanVienKho('nvk7_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho7_1', '0971000000', 'nvk7_1@mail.com', '120000000071', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 7, Số 1 Đường ABC, TP.HCM', 7, 7, 8200000);
CALL ThemNhanVienKho('nvk7_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho7_2', '0972000000', 'nvk7_2@mail.com', '120000000072', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 7, Số 2 Đường ABC, TP.HCM', 7, 7, 8400000);
CALL ThemNhanVienKho('nvk7_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho7_3', '0973000000', 'nvk7_3@mail.com', '120000000073', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 7, Số 3 Đường ABC, TP.HCM', 7, 7, 8600000);
CALL ThemNhanVienKho('nvk8_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho8_1', '0981000000', 'nvk8_1@mail.com', '120000000081', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 8, Số 1 Đường ABC, TP.HCM', 8, 8, 8200000);
CALL ThemNhanVienKho('nvk8_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho8_2', '0982000000', 'nvk8_2@mail.com', '120000000082', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 8, Số 2 Đường ABC, TP.HCM', 8, 8, 8400000);
CALL ThemNhanVienKho('nvk8_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho8_3', '0983000000', 'nvk8_3@mail.com', '120000000083', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 8, Số 3 Đường ABC, TP.HCM', 8, 8, 8600000);
CALL ThemNhanVienKho('nvk9_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho9_1', '0991000000', 'nvk9_1@mail.com', '120000000091', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 9, Số 1 Đường ABC, TP.HCM', 9, 9, 8200000);
CALL ThemNhanVienKho('nvk9_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho9_2', '0992000000', 'nvk9_2@mail.com', '120000000092', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 9, Số 2 Đường ABC, TP.HCM', 9, 9, 8400000);
CALL ThemNhanVienKho('nvk9_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho9_3', '0993000000', 'nvk9_3@mail.com', '120000000093', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 9, Số 3 Đường ABC, TP.HCM', 9, 9, 8600000);
CALL ThemNhanVienKho('nvk10_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho10_1', '0910100000', 'nvk10_1@mail.com', '120000000101', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 10, Số 1 Đường ABC, TP.HCM', 10, 10, 8200000);
CALL ThemNhanVienKho('nvk10_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho10_2', '0910200000', 'nvk10_2@mail.com', '120000000102', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 10, Số 2 Đường ABC, TP.HCM', 10, 10, 8400000);
CALL ThemNhanVienKho('nvk10_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho10_3', '0910300000', 'nvk10_3@mail.com', '120000000103', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 10, Số 3 Đường ABC, TP.HCM', 10, 10, 8600000);
CALL ThemNhanVienKho('nvk11_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho11_1', '0911100000', 'nvk11_1@mail.com', '120000000111', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 11, Số 1 Đường ABC, TP.HCM', 11, 11, 8200000);
CALL ThemNhanVienKho('nvk11_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho11_2', '0911200000', 'nvk11_2@mail.com', '120000000112', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 11, Số 2 Đường ABC, TP.HCM', 11, 11, 8400000);
CALL ThemNhanVienKho('nvk11_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho11_3', '0911300000', 'nvk11_3@mail.com', '120000000113', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 11, Số 3 Đường ABC, TP.HCM', 11, 11, 8600000);
CALL ThemNhanVienKho('nvk12_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho12_1', '0912100000', 'nvk12_1@mail.com', '120000000121', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 12, Số 1 Đường ABC, TP.HCM', 12, 12, 8200000);
CALL ThemNhanVienKho('nvk12_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho12_2', '0912200000', 'nvk12_2@mail.com', '120000000122', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 12, Số 2 Đường ABC, TP.HCM', 12, 12, 8400000);
CALL ThemNhanVienKho('nvk12_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho12_3', '0912300000', 'nvk12_3@mail.com', '120000000123', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 12, Số 3 Đường ABC, TP.HCM', 12, 12, 8600000);
CALL ThemNhanVienKho('nvk13_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho13_1', '0913100000', 'nvk13_1@mail.com', '120000000131', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 13, Số 1 Đường ABC, TP.HCM', 13, 13, 8200000);
CALL ThemNhanVienKho('nvk13_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho13_2', '0913200000', 'nvk13_2@mail.com', '120000000132', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 13, Số 2 Đường ABC, TP.HCM', 13, 13, 8400000);
CALL ThemNhanVienKho('nvk13_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho13_3', '0913300000', 'nvk13_3@mail.com', '120000000133', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 13, Số 3 Đ ờng ABC, TP.HCM', 13, 13, 8600000);
CALL ThemNhanVienKho('nvk14_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho14_1', '0914100000', 'nvk14_1@mail.com', '120000000141', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 14, Số 1 Đường ABC, TP.HCM', 14, 14, 8200000);
CALL ThemNhanVienKho('nvk14_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho14_2', '0914200000', 'nvk14_2@mail.com', '120000000142', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 14, Số 2 Đường ABC, TP.HCM', 14, 14, 8400000);
CALL ThemNhanVienKho('nvk14_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho14_3', '0914300000', 'nvk14_3@mail.com', '120000000143', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 14, Số 3 Đường ABC, TP.HCM', 14, 14, 8600000);
CALL ThemNhanVienKho('nvk15_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho15_1', '0915100000', 'nvk15_1@mail.com', '120000000151', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 15, Số 1 Đường ABC, TP.HCM', 15, 15, 8200000);
CALL ThemNhanVienKho('nvk15_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho15_2', '0915200000', 'nvk15_2@mail.com', '120000000152', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 15, Số 2 Đường ABC, TP.HCM', 15, 15, 8400000);
CALL ThemNhanVienKho('nvk15_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho15_3', '0915300000', 'nvk15_3@mail.com', '120000000153', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 15, Số 3 Đường ABC, TP.HCM', 15, 15, 8600000);
CALL ThemNhanVienKho('nvk16_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho16_1', '0916100000', 'nvk16_1@mail.com', '120000000161', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 16, Số 1 Đường ABC, TP.HCM', 16, 16, 8200000);
CALL ThemNhanVienKho('nvk16_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho16_2', '0916200000', 'nvk16_2@mail.com', '120000000162', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 16, Số 2 Đường ABC, TP.HCM', 16, 16, 8400000);
CALL ThemNhanVienKho('nvk16_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho16_3', '0916300000', 'nvk16_3@mail.com', '120000000163', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 16, Số 3 Đường ABC, TP.HCM', 16, 16, 8600000);
CALL ThemNhanVienKho('nvk17_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho17_1', '0917100000', 'nvk17_1@mail.com', '120000000171', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 17, Số 1 Đường ABC, TP.HCM', 17, 17, 8200000);
CALL ThemNhanVienKho('nvk17_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho17_2', '0917200000', 'nvk17_2@mail.com', '120000000172', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 17, Số 2 Đường ABC, TP.HCM', 17, 17, 8400000);
CALL ThemNhanVienKho('nvk17_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho17_3', '0917300000', 'nvk17_3@mail.com', '120000000173', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 17, Số 3 Đường ABC, TP.HCM', 17, 17, 8600000);
CALL ThemNhanVienKho('nvk18_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho18_1', '0918100000', 'nvk18_1@mail.com', '120000000181', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 18, Số 1 Đường ABC, TP.HCM', 18, 18, 8200000);
CALL ThemNhanVienKho('nvk18_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho18_2', '0918200000', 'nvk18_2@mail.com', '120000000182', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 18, Số 2 Đường ABC, TP.HCM', 18, 18, 8400000);
CALL ThemNhanVienKho('nvk18_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho18_3', '0918300000', 'nvk18_3@mail.com', '120000000183', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 18, Số 3 Đư ng ABC, TP.HCM', 18, 18, 8600000);
CALL ThemNhanVienKho('nvk19_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho19_1', '0919100000', 'nvk19_1@mail.com', '120000000191', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 19, Số 1 Đường ABC, TP.HCM', 19, 19, 8200000);
CALL ThemNhanVienKho('nvk19_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho19_2', '0919200000', 'nvk19_2@mail.com', '120000000192', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 19, Số 2 Đường ABC, TP.HCM', 19, 19, 8400000);
CALL ThemNhanVienKho('nvk19_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho19_3', '0919300000', 'nvk19_3@mail.com', '120000000193', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 19, Số 3 Đường ABC, TP.HCM', 19, 19, 8600000);
CALL ThemNhanVienKho('nvk20_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho20_1', '0920100000', 'nvk20_1@mail.com', '120000000201', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 20, Số 1 Đường ABC, TP.HCM', 20, 20, 8200000);
CALL ThemNhanVienKho('nvk20_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho20_2', '0920200000', 'nvk20_2@mail.com', '120000000202', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 20, Số 2 Đường ABC, TP.HCM', 20, 20, 8400000);
CALL ThemNhanVienKho('nvk20_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho20_3', '0920300000', 'nvk20_3@mail.com', '120000000203', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 20, Số 3 Đường ABC, TP.HCM', 20, 20, 8600000);
CALL ThemNhanVienKho('nvk21_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho21_1', '0921100000', 'nvk21_1@mail.com', '120000000211', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 21, Số 1  ường ABC, TP.HCM', 21, 21, 8200000);
CALL ThemNhanVienKho('nvk21_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho21_2', '0921200000', 'nvk21_2@mail.com', '120000000212', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 21, Số 2 Đường ABC, TP.HCM', 21, 21, 8400000);
CALL ThemNhanVienKho('nvk21_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho21_3', '0921300000', 'nvk21_3@mail.com', '120000000213', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 21, Số 3 Đường ABC, TP.HCM', 21, 21, 8600000);
CALL ThemNhanVienKho('nvk22_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho22_1', '0922100000', 'nvk22_1@mail.com', '120000000221', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 22, Số 1 Đường ABC, TP.HCM', 22, 22, 8200000);
CALL ThemNhanVienKho('nvk22_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho22_2', '0922200000', 'nvk22_2@mail.com', '120000000222', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 22, Số 2 Đường ABC, TP.HCM', 22, 22, 8400000);
CALL ThemNhanVienKho('nvk22_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho22_3', '0922300000', 'nvk22_3@mail.com', '120000000223', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 22, Số 3 Đường ABC, TP.HCM', 22, 22, 8600000);
CALL ThemNhanVienKho('nvk23_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho23_1', '0923100000', 'nvk23_1@mail.com', '120000000231', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 23, Số 1 Đường ABC, TP.HCM', 23, 23, 8200000);
CALL ThemNhanVienKho('nvk23_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho23_2', '0923200000', 'nvk23_2@mail.com', '120000000232', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 23, S  2 Đường ABC, TP.HCM', 23, 23, 8400000);
CALL ThemNhanVienKho('nvk23_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho23_3', '0923300000', 'nvk23_3@mail.com', '120000000233', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 23, Số 3 Đường ABC, TP.HCM', 23, 23, 8600000);
CALL ThemNhanVienKho('nvk24_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho24_1', '0924100000', 'nvk24_1@mail.com', '120000000241', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 24, Số 1 Đường ABC, TP.HCM', 24, 24, 8200000);
CALL ThemNhanVienKho('nvk24_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho24_2', '0924200000', 'nvk24_2@mail.com', '120000000242', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 24, Số 2 Đường ABC, TP.HCM', 24, 24, 8400000);
CALL ThemNhanVienKho('nvk24_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho24_3', '0924300000', 'nvk24_3@mail.com', '120000000243', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 24, Số 3 Đường ABC, TP.HCM', 24, 24, 8600000);
CALL ThemNhanVienKho('nvk25_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho25_1', '0925100000', 'nvk25_1@mail.com', '120000000251', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 25, Số 1 Đường ABC, TP.HCM', 25, 25, 8200000);
CALL ThemNhanVienKho('nvk25_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho25_2', '0925200000', 'nvk25_2@mail.com', '120000000252', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 25, Số 2 Đường ABC, TP.HCM', 25, 25, 8400000);
CALL ThemNhanVienKho('nvk25_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho25_3', '0925300000', 'nvk25_3@mail.com', '120000000253', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 25, Số 3 Đường ABC, TP.HCM', 25, 25, 8600000);
CALL ThemNhanVienKho('nvk26_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho26_1', '0926100000', 'nvk26_1@mail.com', '120000000261', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 26, Số 1 Đường ABC, TP.HCM', 26, 26, 8200000);
CALL ThemNhanVienKho('nvk26_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho26_2', '0926200000', 'nvk26_2@mail.com', '120000000262', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 26, Số 2 Đường ABC, TP.HCM', 26, 26, 8400000);
CALL ThemNhanVienKho('nvk26_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho26_3', '0926300000', 'nvk26_3@mail.com', '120000000263', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 26, Số 3 Đường ABC, TP.HCM', 26, 26, 8600000);
CALL ThemNhanVienKho('nvk27_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho27_1', '0927100000', 'nvk27_1@mail.com', '120000000271', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 27, Số 1 Đường ABC, TP.HCM', 27, 27, 8200000);
CALL ThemNhanVienKho('nvk27_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho27_2', '0927200000', 'nvk27_2@mail.com', '120000000272', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 27, Số 2 Đường ABC, TP.HCM', 27, 27, 8400000);
CALL ThemNhanVienKho('nvk27_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho27_3', '0927300000', 'nvk27_3@mail.com', '120000000273', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 27, Số 3 Đường ABC, TP.HCM', 27, 27, 8600000);
CALL ThemNhanVienKho('nvk28_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho28_1', '0928100000', 'nvk28_1@mail.com', '120000000281', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 28, Số 1 Đường ABC, TP.HCM', 28, 28, 8200000);
CALL ThemNhanVienKho('nvk28_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho28_2', '0928200000', 'nvk28_2@mail.com', '120000000282', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 28, Số 2 Đường ABC, TP.HCM', 28, 28, 8400000);
CALL ThemNhanVienKho('nvk28_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho28_3', '0928300000', 'nvk28_3@mail.com', '120000000283', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 28, Số 3 Đường ABC, TP.HCM', 28, 28, 8600000);
CALL ThemNhanVienKho('nvk29_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho29_1', '0929100000', 'nvk29_1@mail.com', '120000000291', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 29, Số 1 Đường ABC, TP.HCM', 29, 29, 8200000);
CALL ThemNhanVienKho('nvk29_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho29_2', '0929200000', 'nvk29_2@mail.com', '120000000292', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 29, Số 2 Đường ABC, TP.HCM', 29, 29, 8400000);
CALL ThemNhanVienKho('nvk29_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho29_3', '0929300000', 'nvk29_3@mail.com', '120000000293', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 29, Số 3 Đường ABC, TP.HCM', 29, 29, 8600000);
CALL ThemNhanVienKho('nvk30_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho30_1', '0930100000', 'nvk30_1@mail.com', '120000000301', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 30, Số 1 Đường ABC, TP.HCM', 30, 30, 8200000);
CALL ThemNhanVienKho('nvk30_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho30_2', '0930200000', 'nvk30_2@mail.com', '120000000302', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 30, Số 2 Đường ABC, TP.HCM', 30, 30, 8400000);
CALL ThemNhanVienKho('nvk30_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho30_3', '0930300000', 'nvk30_3@mail.com', '120000000303', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 30, Số 3 Đường ABC, TP.HCM', 30, 30, 8600000);
CALL ThemNhanVienKho('nvk31_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho31_1', '0931100000', 'nvk31_1@mail.com', '120000000311', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 31, Số 1 Đường ABC, TP.HCM', 31, 31, 8200000);
CALL ThemNhanVienKho('nvk31_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho31_2', '0931200000', 'nvk31_2@mail.com', '120000000312', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 31, Số 2 Đường ABC, TP.HCM', 31, 31, 8400000);
CALL ThemNhanVienKho('nvk31_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho31_3', '0931300000', 'nvk31_3@mail.com', '120000000313', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 31, Số 3 Đường ABC, TP.HCM', 31, 31, 8600000);
CALL ThemNhanVienKho('nvk32_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho32_1', '0932100000', 'nvk32_1@mail.com', '120000000321', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 32, Số 1 Đường ABC, TP.HCM', 32, 32, 8200000);
CALL ThemNhanVienKho('nvk32_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho32_2', '0932200000', 'nvk32_2@mail.com', '120000000322', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 32, Số 2 Đường ABC, TP.HCM', 32, 32, 8400000);
CALL ThemNhanVienKho('nvk32_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho32_3', '0932300000', 'nvk32_3@mail.com', '120000000323', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 32, Số 3 Đường ABC, TP.HCM', 32, 32, 8600000);
CALL ThemNhanVienKho('nvk33_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho33_1', '0933100000', 'nvk33_1@mail.com', '120000000331', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 33, Số 1 Đường ABC, TP.HCM', 33, 33, 8200000);
CALL ThemNhanVienKho('nvk33_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho33_2', '0933200000', 'nvk33_2@mail.com', '120000000332', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 33, Số 2 Đường ABC, TP.HCM', 33, 33, 8400000);
CALL ThemNhanVienKho('nvk33_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho33_3', '0933300000', 'nvk33_3@mail.com', '120000000333', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 33, Số 3 Đường ABC, TP.HCM', 33, 33, 8600000);
CALL ThemNhanVienKho('nvk34_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho34_1', '0934100000', 'nvk34_1@mail.com', '120000000341', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 34, Số 1 Đường ABC, TP.HCM', 34, 34, 8200000);
CALL ThemNhanVienKho('nvk34_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho34_2', '0934200000', 'nvk34_2@mail.com', '120000000342', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 34, Số 2 Đường ABC, TP.HCM', 34, 34, 8400000);
CALL ThemNhanVienKho('nvk34_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho34_3', '0934300000', 'nvk34_3@mail.com', '120000000343', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 34, Số 3 Đường ABC, TP.HCM', 34, 34, 8600000);
CALL ThemNhanVienKho('nvk35_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho35_1', '0935100000', 'nvk35_1@mail.com', '120000000351', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 35, Số 1 Đường ABC, TP.HCM', 35, 35, 8200000);
CALL ThemNhanVienKho('nvk35_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho35_2', '0935200000', 'nvk35_2@mail.com', '120000000352', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 35, Số 2 Đường ABC, TP.HCM', 35, 35, 8400000);
CALL ThemNhanVienKho('nvk35_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho35_3', '0935300000', 'nvk35_3@mail.com', '120000000353', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 35, Số 3 Đường ABC, TP.HCM', 35, 35, 8600000);
CALL ThemNhanVienKho('nvk36_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho36_1', '0936100000', 'nvk36_1@mail.com', '120000000361', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 36, Số 1 Đường ABC, TP.HCM', 36, 36, 8200000);
CALL ThemNhanVienKho('nvk36_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho36_2', '0936200000', 'nvk36_2@mail.com', '120000000362', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 36, Số 2 Đường ABC, TP.HCM', 36, 36, 8400000);
CALL ThemNhanVienKho('nvk36_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho36_3', '0936300000', 'nvk36_3@mail.com', '120000000363', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 36, Số 3 Đường ABC, TP.HCM', 36, 36, 8600000);
CALL ThemNhanVienKho('nvk37_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho37_1', '0937100000', 'nvk37_1@mail.com', '120000000371', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 37, Số 1 Đường ABC, TP.HCM', 37, 37, 8200000);
CALL ThemNhanVienKho('nvk37_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho37_2', '0937200000', 'nvk37_2@mail.com', '120000000372', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 37, Số 2 Đường ABC, TP.HCM', 37, 37, 8400000);
CALL ThemNhanVienKho('nvk37_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho37_3', '0937300000', 'nvk37_3@mail.com', '120000000373', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 37, Số 3 Đường ABC, TP.HCM', 37, 37, 8600000);
CALL ThemNhanVienKho('nvk38_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho38_1', '0938100000', 'nvk38_1@mail.com', '120000000381', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 38, Số 1 Đường ABC, TP.HCM', 38, 38, 8200000);
CALL ThemNhanVienKho('nvk38_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho38_2', '0938200000', 'nvk38_2@mail.com', '120000000382', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 38, Số 2 Đư  ng ABC, TP.HCM', 38, 38, 8400000);
CALL ThemNhanVienKho('nvk38_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho38_3', '0938300000', 'nvk38_3@mail.com', '120000000383', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 38, Số 3 Đường ABC, TP.HCM', 38, 38, 8600000);
CALL ThemNhanVienKho('nvk39_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho39_1', '0939100000', 'nvk39_1@mail.com', '120000000391', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 39, Số 1 Đường ABC, TP.HCM', 39, 39, 8200000);
CALL ThemNhanVienKho('nvk39_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho39_2', '0939200000', 'nvk39_2@mail.com', '120000000392', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 39, Số 2 Đường ABC, TP.HCM', 39, 39, 8400000);
CALL ThemNhanVienKho('nvk39_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho39_3', '0939300000', 'nvk39_3@mail.com', '120000000393', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 39, Số 3 Đường ABC, TP.HCM', 39, 39, 8600000);
CALL ThemNhanVienKho('nvk40_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho40_1', '0940100000', 'nvk40_1@mail.com', '120000000401', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 40, Số 1 Đường ABC, TP.HCM', 40, 40, 8200000);
CALL ThemNhanVienKho('nvk40_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho40_2', '0940200000', 'nvk40_2@mail.com', '120000000402', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 40, Số 2 Đường ABC, TP.HCM', 40, 40, 8400000);
CALL ThemNhanVienKho('nvk40_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho40_3', '0940300000', 'nvk40_3@mail.com', '120000000403', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 40, Số 3 Đường ABC, TP.HCM', 40, 40, 8600000);
CALL ThemNhanVienKho('nvk41_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho41_1', '0941100000', 'nvk41_1@mail.com', '120000000411', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 41, Số 1 Đường ABC, TP.HCM', 41, 41, 8200000);
CALL ThemNhanVienKho('nvk41_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho41_2', '0941200000', 'nvk41_2@mail.com', '120000000412', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 41, Số 2 Đường ABC, TP.HCM', 41, 41, 8400000);
CALL ThemNhanVienKho('nvk41_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho41_3', '0941300000', 'nvk41_3@mail.com', '120000000413', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 41, Số 3 Đường ABC, TP.HCM', 41, 41, 8600000);
CALL ThemNhanVienKho('nvk42_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho42_1', '0942100000', 'nvk42_1@mail.com', '120000000421', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 42, Số 1 Đường ABC, TP.HCM', 42, 42, 8200000);
CALL ThemNhanVienKho('nvk42_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho42_2', '0942200000', 'nvk42_2@mail.com', '120000000422', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 42, Số 2 Đường ABC, TP.HCM', 42, 42, 8400000);
CALL ThemNhanVienKho('nvk42_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho42_3', '0942300000', 'nvk42_3@mail.com', '120000000423', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 42, Số 3 Đường ABC, TP.HCM', 42, 42, 8600000);
CALL ThemNhanVienKho('nvk43_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho43_1', '0943100000', 'nvk43_1@mail.com', '120000000431', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 43, Số 1 Đường ABC, TP.HCM', 43, 43, 8200000);
CALL ThemNhanVienKho('nvk43_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho43_2', '0943200000', 'nvk43_2@mail.com', '120000000432', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 43, Số 2 Đường ABC, TP.HCM', 43, 43, 8400000);
CALL ThemNhanVienKho('nvk43_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho43_3', '0943300000', 'nvk43_3@mail.com', '120000000433', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 43, Số 3 Đường ABC, TP.HCM', 43, 43, 8600000);
CALL ThemNhanVienKho('nvk44_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho44_1', '0944100000', 'nvk44_1@mail.com', '120000000441', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 44, Số 1 Đường ABC, TP.HCM', 44, 44, 8200000);
CALL ThemNhanVienKho('nvk44_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho44_2', '0944200000', 'nvk44_2@mail.com', '120000000442', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 44, Số 2 Đường ABC, TP.HCM', 44, 44, 8400000);
CALL ThemNhanVienKho('nvk44_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho44_3', '0944300000', 'nvk44_3@mail.com', '120000000443', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 44, Số 3 Đường ABC, TP.HCM', 44, 44, 8600000);
CALL ThemNhanVienKho('nvk45_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho45_1', '0945100000', 'nvk45_1@mail.com', '120000000451', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 45, Số 1 Đường ABC, TP.HCM', 45, 45, 8200000);
CALL ThemNhanVienKho('nvk45_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho45_2', '0945200000', 'nvk45_2@mail.com', '120000000452', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 45, Số 2 Đường ABC, TP.HCM', 45, 45, 8400000);
CALL ThemNhanVienKho('nvk45_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho45_3', '0945300000', 'nvk45_3@mail.com', '120000000453', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 45, Số 3 Đ ờng ABC, TP.HCM', 45, 45, 8600000);
CALL ThemNhanVienKho('nvk46_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho46_1', '0946100000', 'nvk46_1@mail.com', '120000000461', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 46, Số 1 Đường ABC, TP.HCM', 46, 46, 8200000);
CALL ThemNhanVienKho('nvk46_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho46_2', '0946200000', 'nvk46_2@mail.com', '120000000462', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 46, Số 2 Đường ABC, TP.HCM', 46, 46, 8400000);
CALL ThemNhanVienKho('nvk46_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho46_3', '0946300000', 'nvk46_3@mail.com', '120000000463', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 46, Số 3 Đường ABC, TP.HCM', 46, 46, 8600000);
CALL ThemNhanVienKho('nvk47_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho47_1', '0947100000', 'nvk47_1@mail.com', '120000000471', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 47, Số 1 Đường ABC, TP.HCM', 47, 47, 8200000);
CALL ThemNhanVienKho('nvk47_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho47_2', '0947200000', 'nvk47_2@mail.com', '120000000472', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 47, Số 2 Đường ABC, TP.HCM', 47, 47, 8400000);
CALL ThemNhanVienKho('nvk47_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho47_3', '0947300000', 'nvk47_3@mail.com', '120000000473', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 47, Số 3 Đường ABC, TP.HCM', 47, 47, 8600000);
CALL ThemNhanVienKho('nvk48_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho48_1', '0948100000', 'nvk48_1@mail.com', '120000000481', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 48, Số 1 Đường ABC, TP.HCM', 48, 48, 8200000);
CALL ThemNhanVienKho('nvk48_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho48_2', '0948200000', 'nvk48_2@mail.com', '120000000482', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 48, Số 2 Đường ABC, TP.HCM', 48, 48, 8400000);
CALL ThemNhanVienKho('nvk48_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho48_3', '0948300000', 'nvk48_3@mail.com', '120000000483', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 48, Số 3 Đường ABC, TP.HCM', 48, 48, 8600000);
CALL ThemNhanVienKho('nvk49_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho49_1', '0949100000', 'nvk49_1@mail.com', '120000000491', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 49, Số 1 Đường ABC, TP.HCM', 49, 49, 8200000);
CALL ThemNhanVienKho('nvk49_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho49_2', '0949200000', 'nvk49_2@mail.com', '120000000492', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 49, Số 2 Đường ABC, TP.HCM', 49, 49, 8400000);
CALL ThemNhanVienKho('nvk49_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho49_3', '0949300000', 'nvk49_3@mail.com', '120000000493', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 49, Số 3 Đường ABC, TP.HCM', 49, 49, 8600000);
CALL ThemNhanVienKho('nvk50_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho50_1', '0950100000', 'nvk50_1@mail.com', '120000000501', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 50, Số 1 Đường ABC, TP.HCM', 50, 50, 8200000);
CALL ThemNhanVienKho('nvk50_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho50_2', '0950200000', 'nvk50_2@mail.com', '120000000502', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 50, Số 2 Đường ABC, TP.HCM', 50, 50, 8400000);
CALL ThemNhanVienKho('nvk50_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho50_3', '0950300000', 'nvk50_3@mail.com', '120000000503', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 50, Số 3 Đư ng ABC, TP.HCM', 50, 50, 8600000);
CALL ThemNhanVienKho('nvk51_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho51_1', '0951100000', 'nvk51_1@mail.com', '120000000511', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 51, Số 1 Đường ABC, TP.HCM', 51, 51, 8200000);
CALL ThemNhanVienKho('nvk51_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho51_2', '0951200000', 'nvk51_2@mail.com', '120000000512', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 51, Số 2 Đường ABC, TP.HCM', 51, 51, 8400000);
CALL ThemNhanVienKho('nvk51_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho51_3', '0951300000', 'nvk51_3@mail.com', '120000000513', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 51, Số 3 Đường ABC, TP.HCM', 51, 51, 8600000);
CALL ThemNhanVienKho('nvk52_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho52_1', '0952100000', 'nvk52_1@mail.com', '120000000521', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 52, Số 1 Đường ABC, TP.HCM', 52, 52, 8200000);
CALL ThemNhanVienKho('nvk52_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho52_2', '0952200000', 'nvk52_2@mail.com', '120000000522', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 52, Số 2 Đường ABC, TP.HCM', 52, 52, 8400000);
CALL ThemNhanVienKho('nvk52_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho52_3', '0952300000', 'nvk52_3@mail.com', '120000000523', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 52, Số 3 Đường ABC, TP.HCM', 52, 52, 8600000);
CALL ThemNhanVienKho('nvk53_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho53_1', '0953100000', 'nvk53_1@mail.com', '120000000531', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 53, Số 1  ường ABC, TP.HCM', 53, 53, 8200000);
CALL ThemNhanVienKho('nvk53_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho53_2', '0953200000', 'nvk53_2@mail.com', '120000000532', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 53, Số 2 Đường ABC, TP.HCM', 53, 53, 8400000);
CALL ThemNhanVienKho('nvk53_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho53_3', '0953300000', 'nvk53_3@mail.com', '120000000533', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 53, Số 3 Đường ABC, TP.HCM', 53, 53, 8600000);
CALL ThemNhanVienKho('nvk54_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho54_1', '0954100000', 'nvk54_1@mail.com', '120000000541', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 54, Số 1 Đường ABC, TP.HCM', 54, 54, 8200000);
CALL ThemNhanVienKho('nvk54_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho54_2', '0954200000', 'nvk54_2@mail.com', '120000000542', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 54, Số 2 Đường ABC, TP.HCM', 54, 54, 8400000);
CALL ThemNhanVienKho('nvk54_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho54_3', '0954300000', 'nvk54_3@mail.com', '120000000543', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 54, Số 3 Đường ABC, TP.HCM', 54, 54, 8600000);
CALL ThemNhanVienKho('nvk55_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho55_1', '0955100000', 'nvk55_1@mail.com', '120000000551', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 55, Số 1 Đường ABC, TP.HCM', 55, 55, 8200000);
CALL ThemNhanVienKho('nvk55_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho55_2', '0955200000', 'nvk55_2@mail.com', '120000000552', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 55, S  2 Đường ABC, TP.HCM', 55, 55, 8400000);
CALL ThemNhanVienKho('nvk55_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho55_3', '0955300000', 'nvk55_3@mail.com', '120000000553', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 55, Số 3 Đường ABC, TP.HCM', 55, 55, 8600000);
CALL ThemNhanVienKho('nvk56_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho56_1', '0956100000', 'nvk56_1@mail.com', '120000000561', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 56, Số 1 Đường ABC, TP.HCM', 56, 56, 8200000);
CALL ThemNhanVienKho('nvk56_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho56_2', '0956200000', 'nvk56_2@mail.com', '120000000562', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 56, Số 2 Đường ABC, TP.HCM', 56, 56, 8400000);
CALL ThemNhanVienKho('nvk56_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho56_3', '0956300000', 'nvk56_3@mail.com', '120000000563', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 56, Số 3 Đường ABC, TP.HCM', 56, 56, 8600000);
CALL ThemNhanVienKho('nvk57_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho57_1', '0957100000', 'nvk57_1@mail.com', '120000000571', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 57, Số 1 Đường ABC, TP.HCM', 57, 57, 8200000);
CALL ThemNhanVienKho('nvk57_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho57_2', '0957200000', 'nvk57_2@mail.com', '120000000572', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 57, Số 2 Đường ABC, TP.HCM', 57, 57, 8400000);
CALL ThemNhanVienKho('nvk57_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho57_3', '0957300000', 'nvk57_3@mail.com', '120000000573', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 57, Số 3 Đường ABC, TP.HCM', 57, 57, 8600000);
CALL ThemNhanVienKho('nvk58_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho58_1', '0958100000', 'nvk58_1@mail.com', '120000000581', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 58, Số 1 Đường ABC, TP.HCM', 58, 58, 8200000);
CALL ThemNhanVienKho('nvk58_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho58_2', '0958200000', 'nvk58_2@mail.com', '120000000582', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 58, Số 2 Đường ABC, TP.HCM', 58, 58, 8400000);
CALL ThemNhanVienKho('nvk58_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho58_3', '0958300000', 'nvk58_3@mail.com', '120000000583', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 58, Số 3 Đường ABC, TP.HCM', 58, 58, 8600000);
CALL ThemNhanVienKho('nvk59_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho59_1', '0959100000', 'nvk59_1@mail.com', '120000000591', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 59, Số 1 Đường ABC, TP.HCM', 59, 59, 8200000);
CALL ThemNhanVienKho('nvk59_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho59_2', '0959200000', 'nvk59_2@mail.com', '120000000592', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 59, Số 2 Đường ABC, TP.HCM', 59, 59, 8400000);
CALL ThemNhanVienKho('nvk59_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho59_3', '0959300000', 'nvk59_3@mail.com', '120000000593', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 59, Số 3 Đường ABC, TP.HCM', 59, 59, 8600000);
CALL ThemNhanVienKho('nvk60_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho60_1', '0960100000', 'nvk60_1@mail.com', '120000000601', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 60, Số 1 Đường ABC, TP.HCM', 60, 60, 8200000);
CALL ThemNhanVienKho('nvk60_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho60_2', '0960200000', 'nvk60_2@mail.com', '120000000602', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 60, Số 2 Đường ABC, TP.HCM', 60, 60, 8400000);
CALL ThemNhanVienKho('nvk60_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho60_3', '0960300000', 'nvk60_3@mail.com', '120000000603', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 60, Số 3 Đường ABC, TP.HCM', 60, 60, 8600000);
CALL ThemNhanVienKho('nvk61_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho61_1', '0961100000', 'nvk61_1@mail.com', '120000000611', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 61, Số 1 Đường ABC, TP.HCM', 61, 61, 8200000);
CALL ThemNhanVienKho('nvk61_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho61_2', '0961200000', 'nvk61_2@mail.com', '120000000612', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 61, Số 2 Đường ABC, TP.HCM', 61, 61, 8400000);
CALL ThemNhanVienKho('nvk61_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho61_3', '0961300000', 'nvk61_3@mail.com', '120000000613', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 61, Số 3 Đường ABC, TP.HCM', 61, 61, 8600000);
CALL ThemNhanVienKho('nvk62_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho62_1', '0962100000', 'nvk62_1@mail.com', '120000000621', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 62, Số 1 Đường ABC, TP.HCM', 62, 62, 8200000);
CALL ThemNhanVienKho('nvk62_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho62_2', '0962200000', 'nvk62_2@mail.com', '120000000622', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 62, Số 2 Đường ABC, TP.HCM', 62, 62, 8400000);
CALL ThemNhanVienKho('nvk62_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho62_3', '0962300000', 'nvk62_3@mail.com', '120000000623', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 62, Số 3  ường ABC, TP.HCM', 62, 62, 8600000);
CALL ThemNhanVienKho('nvk63_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho63_1', '0963100000', 'nvk63_1@mail.com', '120000000631', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 63, Số 1 Đường ABC, TP.HCM', 63, 63, 8200000);
CALL ThemNhanVienKho('nvk63_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho63_2', '0963200000', 'nvk63_2@mail.com', '120000000632', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 63, Số 2 Đường ABC, TP.HCM', 63, 63, 8400000);
CALL ThemNhanVienKho('nvk63_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienKho63_3', '0963300000', 'nvk63_3@mail.com', '120000000633', TO_DATE('1995-01-01','YYYY-MM-DD'), 'Nam', 'Kho 63, Số 3 Đường ABC, TP.HCM', 63, 63, 8600000);
commit;

CALL ThemNhanVienGiaoHang('nvgh1_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang1_1', '0811100000', 'nvgh1_1@mail.com', '180000000001', TO_DATE('1998-01-01','YYYY-MM-DD'), 'Nam', 'Kho 1, Số 1 Đường ABC, TP.HCM', 1, 1, 5);
CALL ThemNhanVienGiaoHang('nvgh1_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang1_2', '0811100001', 'nvgh1_2@mail.com', '180000000002', TO_DATE('1998-02-02','YYYY-MM-DD'), 'Nam', 'Kho 1, Số 1 Đường ABC, TP.HCM', 1, 1, 5);
CALL ThemNhanVienGiaoHang('nvgh1_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang1_3', '0811100002', 'nvgh1_3@mail.com', '180000000003', TO_DATE('1998-03-03','YYYY-MM-DD'), 'Nam', 'Kho 1, Số 1 Đường ABC, TP.HCM', 1, 1, 5);
CALL ThemNhanVienGiaoHang('nvgh2_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang2_1', '0811100003', 'nvgh2_1@mail.com', '180000000004', TO_DATE('1998-04-04','YYYY-MM-DD'), 'Nam', 'Kho 2, Số 1 Đường ABC, TP.HCM', 2, 2, 5);
CALL ThemNhanVienGiaoHang('nvgh2_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang2_2', '0811100004', 'nvgh2_2@mail.com', '180000000005', TO_DATE('1998-05-05','YYYY-MM-DD'), 'Nam', 'Kho 2, Số 1 Đường ABC, TP.HCM', 2, 2, 5);
CALL ThemNhanVienGiaoHang('nvgh2_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang2_3', '0811100005', 'nvgh2_3@mail.com', '180000000006', TO_DATE('1998-06-06','YYYY-MM-DD'), 'Nam', 'Kho 2, Số 1 Đường ABC, TP.HCM', 2, 2, 5);
CALL ThemNhanVienGiaoHang('nvgh3_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang3_1', '0811100006', 'nvgh3_1@mail.com', '180000000007', TO_DATE('1998-07-07','YYYY-MM-DD'), 'Nam', 'Kho 3, Số 1 Đư  ng ABC, TP.HCM', 3, 3, 5);
CALL ThemNhanVienGiaoHang('nvgh3_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang3_2', '0811100007', 'nvgh3_2@mail.com', '180000000008', TO_DATE('1998-08-08','YYYY-MM-DD'), 'Nam', 'Kho 3, Số 1 Đường ABC, TP.HCM', 3, 3, 5);
CALL ThemNhanVienGiaoHang('nvgh3_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang3_3', '0811100008', 'nvgh3_3@mail.com', '180000000009', TO_DATE('1998-09-09','YYYY-MM-DD'), 'Nam', 'Kho 3, Số 1 Đường ABC, TP.HCM', 3, 3, 5);
CALL ThemNhanVienGiaoHang('nvgh4_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang4_1', '0811100009', 'nvgh4_1@mail.com', '180000000010', TO_DATE('1998-10-10','YYYY-MM-DD'), 'Nam', 'Kho 4, Số 1 Đường ABC, TP.HCM', 4, 4, 5);
CALL ThemNhanVienGiaoHang('nvgh4_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang4_2', '0811100010', 'nvgh4_2@mail.com', '180000000011', TO_DATE('1998-11-11','YYYY-MM-DD'), 'Nam', 'Kho 4, Số 1 Đường ABC, TP.HCM', 4, 4, 5);
CALL ThemNhanVienGiaoHang('nvgh4_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang4_3', '0811100011', 'nvgh4_3@mail.com', '180000000012', TO_DATE('1998-12-12','YYYY-MM-DD'), 'Nam', 'Kho 4, Số 1 Đường ABC, TP.HCM', 4, 4, 5);
CALL ThemNhanVienGiaoHang('nvgh5_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang5_1', '0811100012', 'nvgh5_1@mail.com', '180000000013', TO_DATE('1998-01-13','YYYY-MM-DD'), 'Nam', 'Kho 5, Số 1 Đường ABC, TP.HCM', 5, 5, 5);
CALL ThemNhanVienGiaoHang('nvgh5_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang5_2', '0811100013', 'nvgh5_2@mail.com', '180000000014', TO_DATE('1998-02-14','YYYY-MM-DD'), 'Nam', 'Kho 5, Số 1 Đường ABC, TP.HCM', 5, 5, 5);
CALL ThemNhanVienGiaoHang('nvgh5_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang5_3', '0811100014', 'nvgh5_3@mail.com', '180000000015', TO_DATE('1998-03-15','YYYY-MM-DD'), 'Nam', 'Kho 5, Số 1 Đường ABC, TP.HCM', 5, 5, 5);
CALL ThemNhanVienGiaoHang('nvgh6_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang6_1', '0811100015', 'nvgh6_1@mail.com', '180000000016', TO_DATE('1998-04-16','YYYY-MM-DD'), 'Nam', 'Kho 6, Số 1 Đường ABC, TP.HCM', 6, 6, 5);
CALL ThemNhanVienGiaoHang('nvgh6_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang6_2', '0811100016', 'nvgh6_2@mail.com', '180000000017', TO_DATE('1998-05-17','YYYY-MM-DD'), 'Nam', 'Kho 6, Số 1 Đường ABC, TP.HCM', 6, 6, 5);
CALL ThemNhanVienGiaoHang('nvgh6_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang6_3', '0811100017', 'nvgh6_3@mail.com', '180000000018', TO_DATE('1998-06-18','YYYY-MM-DD'), 'Nam', 'Kho 6, Số 1 Đường ABC, TP.HCM', 6, 6, 5);
CALL ThemNhanVienGiaoHang('nvgh7_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang7_1', '0811100018', 'nvgh7_1@mail.com', '180000000019', TO_DATE('1998-07-19','YYYY-MM-DD'), 'Nam', 'Kho 7, Số 1 Đường ABC, TP.HCM', 7, 7, 5);
CALL ThemNhanVienGiaoHang('nvgh7_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang7_2', '0811100019', 'nvgh7_2@mail.com', '180000000020', TO_DATE('1998-08-20','YYYY-MM-DD'), 'Nam', 'Kho 7, S   1 Đường ABC, TP.HCM', 7, 7, 5);
CALL ThemNhanVienGiaoHang('nvgh7_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang7_3', '0811100020', 'nvgh7_3@mail.com', '180000000021', TO_DATE('1998-09-21','YYYY-MM-DD'), 'Nam', 'Kho 7, Số 1 Đường ABC, TP.HCM', 7, 7, 5);
CALL ThemNhanVienGiaoHang('nvgh8_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang8_1', '0811100021', 'nvgh8_1@mail.com', '180000000022', TO_DATE('1998-10-22','YYYY-MM-DD'), 'Nam', 'Kho 8, Số 1 Đường ABC, TP.HCM', 8, 8, 5);
CALL ThemNhanVienGiaoHang('nvgh8_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang8_2', '0811100022', 'nvgh8_2@mail.com', '180000000023', TO_DATE('1998-11-23','YYYY-MM-DD'), 'Nam', 'Kho 8, Số 1 Đường ABC, TP.HCM', 8, 8, 5);
CALL ThemNhanVienGiaoHang('nvgh8_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang8_3', '0811100023', 'nvgh8_3@mail.com', '180000000024', TO_DATE('1998-12-24','YYYY-MM-DD'), 'Nam', 'Kho 8, Số 1 Đường ABC, TP.HCM', 8, 8, 5);
CALL ThemNhanVienGiaoHang('nvgh9_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang9_1', '0811100024', 'nvgh9_1@mail.com', '180000000025', TO_DATE('1998-01-25','YYYY-MM-DD'), 'Nam', 'Kho 9, Số 1 Đường ABC, TP.HCM', 9, 9, 5);
CALL ThemNhanVienGiaoHang('nvgh9_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang9_2', '0811100025', 'nvgh9_2@mail.com', '180000000026', TO_DATE('1998-02-26','YYYY-MM-DD'), 'Nam', 'Kho 9, Số 1 Đường ABC, TP.HCM', 9, 9, 5);
CALL ThemNhanVienGiaoHang('nvgh9_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang9_3', '0811100026', 'nvgh9_3@mail.com', '180000000027', TO_DATE('1998-03-27','YYYY-MM-DD'), 'Nam', 'Kho 9, Số 1 Đường ABC, TP.HCM', 9, 9, 5);
CALL ThemNhanVienGiaoHang('nvgh10_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang10_1', '0811100027', 'nvgh10_1@mail.com', '180000000028', TO_DATE('1998-04-28','YYYY-MM-DD'), 'Nam', 'Kho 10, Số 1 Đường ABC, TP.HCM', 10, 10, 5);
CALL ThemNhanVienGiaoHang('nvgh10_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang10_2', '0811100028', 'nvgh10_2@mail.com', '180000000029', TO_DATE('1998-05-01','YYYY-MM-DD'), 'Nam', 'Kho 10, Số 1 Đường ABC, TP.HCM', 10, 10, 5);
CALL ThemNhanVienGiaoHang('nvgh10_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang10_3', '0811100029', 'nvgh10_3@mail.com', '180000000030', TO_DATE('1998-06-02','YYYY-MM-DD'), 'Nam', 'Kho 10, Số 1 Đường ABC, TP.HCM', 10, 10, 5);
CALL ThemNhanVienGiaoHang('nvgh11_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang11_1', '0811100030', 'nvgh11_1@mail.com', '180000000031', TO_DATE('1998-07-03','YYYY-MM-DD'), 'Nam', 'Kho 11, Số 1 Đường ABC, TP.HCM', 11, 11, 5);
CALL ThemNhanVienGiaoHang('nvgh11_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang11_2', '0811100031', 'nvgh11_2@mail.com', '180000000032', TO_DATE('1998-08-04','YYYY-MM-DD'), 'Nam', 'Kho 11, Số 1 Đường ABC, TP.HCM', 11, 11, 5);
CALL ThemNhanVienGiaoHang('nvgh11_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang11_3', '0811100032', 'nvgh11_3@mail.com', '180000000033', TO_DATE('1998-09-05','YYYY-MM-DD'), 'Nam', 'Kho 11, Số 1 Đường ABC, TP.HCM', 11, 11, 5);
CALL ThemNhanVienGiaoHang('nvgh12_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang12_1', '0811100033', 'nvgh12_1@mail.com', '180000000034', TO_DATE('1998-10-06','YYYY-MM-DD'), 'Nam', 'Kho 12, Số 1 Đường ABC, TP.HCM', 12, 12, 5);
CALL ThemNhanVienGiaoHang('nvgh12_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang12_2', '0811100034', 'nvgh12_2@mail.com', '180000000035', TO_DATE('1998-11-07','YYYY-MM-DD'), 'Nam', 'Kho 12, Số 1 Đường ABC, TP.HCM', 12, 12, 5);
CALL ThemNhanVienGiaoHang('nvgh12_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang12_3', '0811100035', 'nvgh12_3@mail.com', '180000000036', TO_DATE('1998-12-08','YYYY-MM-DD'), 'Nam', 'Kho 12, Số 1 Đường ABC, TP.HCM', 12, 12, 5);
CALL ThemNhanVienGiaoHang('nvgh13_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang13_1', '0811100036', 'nvgh13_1@mail.com', '180000000037', TO_DATE('1998-01-09','YYYY-MM-DD'), 'Nam', 'Kho 13, Số 1 Đường ABC, TP.HCM', 13, 13, 5);
CALL ThemNhanVienGiaoHang('nvgh13_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang13_2', '0811100037', 'nvgh13_2@mail.com', '180000000038', TO_DATE('1998-02-10','YYYY-MM-DD'), 'Nam', 'Kho 13, Số 1 Đường ABC, TP.HCM', 13, 13, 5);
CALL ThemNhanVienGiaoHang('nvgh13_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang13_3', '0811100038', 'nvgh13_3@mail.com', '180000000039', TO_DATE('1998-03-11','YYYY-MM-DD'), 'Nam', 'Kho 13, Số 1 Đường ABC, TP.HCM', 13, 13, 5);
CALL ThemNhanVienGiaoHang('nvgh14_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang14_1', '0811100039', 'nvgh14_1@mail.com', '180000000040', TO_DATE('1998-04-12','YYYY-MM-DD'), 'Nam', 'Kho 14, Số 1 Đường ABC, TP.HCM', 14, 14, 5);
CALL ThemNhanVienGiaoHang('nvgh14_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang14_2', '0811100040', 'nvgh14_2@mail.com', '180000000041', TO_DATE('1998-05-13','YYYY-MM-DD'), 'Nam', 'Kho 14, Số 1 Đường ABC, TP.HCM', 14, 14, 5);
CALL ThemNhanVienGiaoHang('nvgh14_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang14_3', '0811100041', 'nvgh14_3@mail.com', '180000000042', TO_DATE('1998-06-14','YYYY-MM-DD'), 'Nam', 'Kho 14, Số 1 Đường ABC, TP.HCM', 14, 14, 5);
CALL ThemNhanVienGiaoHang('nvgh15_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang15_1', '0811100042', 'nvgh15_1@mail.com', '180000000043', TO_DATE('1998-07-15','YYYY-MM-DD'), 'Nam', 'Kho 15, Số 1 Đường ABC, TP.HCM', 15, 15, 5);
CALL ThemNhanVienGiaoHang('nvgh15_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang15_2', '0811100043', 'nvgh15_2@mail.com', '180000000044', TO_DATE('1998-08-16','YYYY-MM-DD'), 'Nam', 'Kho 15, Số 1 Đường ABC, TP.HCM', 15, 15, 5);
CALL ThemNhanVienGiaoHang('nvgh15_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang15_3', '0811100044', 'nvgh15_3@mail.com', '180000000045', TO_DATE('1998-09-17','YYYY-MM-DD'), 'Nam', 'Kho 15, Số 1 Đường ABC, TP.HCM', 15, 15, 5);
CALL ThemNhanVienGiaoHang('nvgh16_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang16_1', '0811100045', 'nvgh16_1@mail.com', '180000000046', TO_DATE('1998-10-18','YYYY-MM-DD'), 'Nam', 'Kho 16, Số 1 Đường ABC, TP.HCM', 16, 16, 5);
CALL ThemNhanVienGiaoHang('nvgh16_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang16_2', '0811100046', 'nvgh16_2@mail.com', '180000000047', TO_DATE('1998-11-19','YYYY-MM-DD'), 'Nam', 'Kho 16, Số 1 Đường ABC, TP.HCM', 16, 16, 5);
CALL ThemNhanVienGiaoHang('nvgh16_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang16_3', '0811100047', 'nvgh16_3@mail.com', '180000000048', TO_DATE('1998-12-20','YYYY-MM-DD'), 'Nam', 'Kho 16, Số 1 Đường ABC, TP.HCM', 16, 16, 5);
CALL ThemNhanVienGiaoHang('nvgh17_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang17_1', '0811100048', 'nvgh17_1@mail.com', '180000000049', TO_DATE('1998-01-21','YYYY-MM-DD'), 'Nam', 'Kho 17, Số 1 Đường ABC, TP.HCM', 17, 17, 5);
CALL ThemNhanVienGiaoHang('nvgh17_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang17_2', '0811100049', 'nvgh17_2@mail.com', '180000000050', TO_DATE('1998-02-22','YYYY-MM-DD'), 'Nam', 'Kho 17, Số 1 Đường ABC, TP.HCM', 17, 17, 5);
CALL ThemNhanVienGiaoHang('nvgh17_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang17_3', '0811100050', 'nvgh17_3@mail.com', '180000000051', TO_DATE('1998-03-23','YYYY-MM-DD'), 'Nam', 'Kho 17, Số 1 Đường ABC, TP.HCM', 17, 17, 5);
CALL ThemNhanVienGiaoHang('nvgh18_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang18_1', '0811100051', 'nvgh18_1@mail.com', '180000000052', TO_DATE('1998-04-24','YYYY-MM-DD'), 'Nam', 'Kho 18, Số 1 Đường ABC, TP.HCM', 18, 18, 5);
CALL ThemNhanVienGiaoHang('nvgh18_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang18_2', '0811100052', 'nvgh18_2@mail.com', '180000000053', TO_DATE('1998-05-25','YYYY-MM-DD'), 'Nam', 'Kho 18, Số 1 Đường ABC, TP.HCM', 18, 18, 5);
CALL ThemNhanVienGiaoHang('nvgh18_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang18_3', '0811100053', 'nvgh18_3@mail.com', '180000000054', TO_DATE('1998-06-26','YYYY-MM-DD'), 'Nam', 'Kho 18, Số 1 Đường ABC, TP.HCM', 18, 18, 5);
CALL ThemNhanVienGiaoHang('nvgh19_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang19_1', '0811100054', 'nvgh19_1@mail.com', '180000000055', TO_DATE('1998-07-27','YYYY-MM-DD'), 'Nam', 'Kho 19, Số 1 Đường ABC, TP.HCM', 19, 19, 5);
CALL ThemNhanVienGiaoHang('nvgh19_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang19_2', '0811100055', 'nvgh19_2@mail.com', '180000000056', TO_DATE('1998-08-28','YYYY-MM-DD'), 'Nam', 'Kho 19, Số 1 Đường ABC, TP.HCM', 19, 19, 5);
CALL ThemNhanVienGiaoHang('nvgh19_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang19_3', '0811100056', 'nvgh19_3@mail.com', '180000000057', TO_DATE('1998-09-01','YYYY-MM-DD'), 'Nam', 'Kho 19, Số 1 Đường ABC, TP.HCM', 19, 19, 5);
CALL ThemNhanVienGiaoHang('nvgh20_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang20_1', '0811100057', 'nvgh20_1@mail.com', '180000000058', TO_DATE('1998-10-02','YYYY-MM-DD'), 'Nam', 'Kho 20, Số 1 Đường ABC, TP.HCM', 20, 20, 5);
CALL ThemNhanVienGiaoHang('nvgh20_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang20_2', '0811100058', 'nvgh20_2@mail.com', '180000000059', TO_DATE('1998-11-03','YYYY-MM-DD'), 'Nam', 'Kho 20, Số 1 Đường ABC, TP.HCM', 20, 20, 5);
CALL ThemNhanVienGiaoHang('nvgh20_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang20_3', '0811100059', 'nvgh20_3@mail.com', '180000000060', TO_DATE('1998-12-04','YYYY-MM-DD'), 'Nam', 'Kho 20, Số 1 Đường ABC, TP.HCM', 20, 20, 5);
CALL ThemNhanVienGiaoHang('nvgh21_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang21_1', '0811100060', 'nvgh21_1@mail.com', '180000000061', TO_DATE('1998-01-05','YYYY-MM-DD'), 'Nam', 'Kho 21, Số 1 Đường ABC, TP.HCM', 21, 21, 5);
CALL ThemNhanVienGiaoHang('nvgh21_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang21_2', '0811100061', 'nvgh21_2@mail.com', '180000000062', TO_DATE('1998-02-06','YYYY-MM-DD'), 'Nam', 'Kho 21, Số 1 Đường ABC, TP.HCM', 21, 21, 5);
CALL ThemNhanVienGiaoHang('nvgh21_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang21_3', '0811100062', 'nvgh21_3@mail.com', '180000000063', TO_DATE('1998-03-07','YYYY-MM-DD'), 'Nam', 'Kho 21, Số 1 Đường ABC, TP.HCM', 21, 21, 5);
CALL ThemNhanVienGiaoHang('nvgh22_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang22_1', '0811100063', 'nvgh22_1@mail.com', '180000000064', TO_DATE('1998-04-08','YYYY-MM-DD'), 'Nam', 'Kho 22, Số 1 Đường ABC, TP.HCM', 22, 22, 5);
CALL ThemNhanVienGiaoHang('nvgh22_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang22_2', '0811100064', 'nvgh22_2@mail.com', '180000000065', TO_DATE('1998-05-09','YYYY-MM-DD'), 'Nam', 'Kho 22, Số 1 Đường ABC, TP.HCM', 22, 22, 5);
CALL ThemNhanVienGiaoHang('nvgh22_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang22_3', '0811100065', 'nvgh22_3@mail.com', '180000000066', TO_DATE('1998-06-10','YYYY-MM-DD'), 'Nam', 'Kho 22, Số 1 Đường ABC, TP.HCM', 22, 22, 5);
CALL ThemNhanVienGiaoHang('nvgh23_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang23_1', '0811100066', 'nvgh23_1@mail.com', '180000000067', TO_DATE('1998-07-11','YYYY-MM-DD'), 'Nam', 'Kho 23, Số 1 Đường ABC, TP.HCM', 23, 23, 5);
CALL ThemNhanVienGiaoHang('nvgh23_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang23_2', '0811100067', 'nvgh23_2@mail.com', '180000000068', TO_DATE('1998-08-12','YYYY-MM-DD'), 'Nam', 'Kho 23, Số 1 Đường ABC, TP.HCM', 23, 23, 5);
CALL ThemNhanVienGiaoHang('nvgh23_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang23_3', '0811100068', 'nvgh23_3@mail.com', '180000000069', TO_DATE('1998-09-13','YYYY-MM-DD'), 'Nam', 'Kho 23, Số 1 Đường ABC, TP.HCM', 23, 23, 5);
CALL ThemNhanVienGiaoHang('nvgh24_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang24_1', '0811100069', 'nvgh24_1@mail.com', '180000000070', TO_DATE('1998-10-14','YYYY-MM-DD'), 'Nam', 'Kho 24, Số 1 Đường ABC, TP.HCM', 24, 24, 5);
CALL ThemNhanVienGiaoHang('nvgh24_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang24_2', '0811100070', 'nvgh24_2@mail.com', '180000000071', TO_DATE('1998-11-15','YYYY-MM-DD'), 'Nam', 'Kho 24, Số 1 Đường ABC, TP.HCM', 24, 24, 5);
CALL ThemNhanVienGiaoHang('nvgh24_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang24_3', '0811100071', 'nvgh24_3@mail.com', '180000000072', TO_DATE('1998-12-16','YYYY-MM-DD'), 'Nam', 'Kho 24, Số 1 Đường ABC, TP.HCM', 24, 24, 5);
CALL ThemNhanVienGiaoHang('nvgh25_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang25_1', '0811100072', 'nvgh25_1@mail.com', '180000000073', TO_DATE('1998-01-17','YYYY-MM-DD'), 'Nam', 'Kho 25, Số 1 Đường ABC, TP.HCM', 25, 25, 5);
CALL ThemNhanVienGiaoHang('nvgh25_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang25_2', '0811100073', 'nvgh25_2@mail.com', '180000000074', TO_DATE('1998-02-18','YYYY-MM-DD'), 'Nam', 'Kho 25, Số 1 Đường ABC, TP.HCM', 25, 25, 5);
CALL ThemNhanVienGiaoHang('nvgh25_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang25_3', '0811100074', 'nvgh25_3@mail.com', '180000000075', TO_DATE('1998-03-19','YYYY-MM-DD'), 'Nam', 'Kho 25, Số 1 Đường ABC, TP.HCM', 25, 25, 5);
CALL ThemNhanVienGiaoHang('nvgh26_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang26_1', '0811100075', 'nvgh26_1@mail.com', '180000000076', TO_DATE('1998-04-20','YYYY-MM-DD'), 'Nam', 'Kho 26, Số 1 Đường ABC, TP.HCM', 26, 26, 5);
CALL ThemNhanVienGiaoHang('nvgh26_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang26_2', '0811100076', 'nvgh26_2@mail.com', '180000000077', TO_DATE('1998-05-21','YYYY-MM-DD'), 'Nam', 'Kho 26, Số 1 Đường ABC, TP.HCM', 26, 26, 5);
CALL ThemNhanVienGiaoHang('nvgh26_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang26_3', '0811100077', 'nvgh26_3@mail.com', '180000000078', TO_DATE('1998-06-22','YYYY-MM-DD'), 'Nam', 'Kho 26, Số 1 Đường ABC, TP.HCM', 26, 26, 5);
CALL ThemNhanVienGiaoHang('nvgh27_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang27_1', '0811100078', 'nvgh27_1@mail.com', '180000000079', TO_DATE('1998-07-23','YYYY-MM-DD'), 'Nam', 'Kho 27, Số 1 Đường ABC, TP.HCM', 27, 27, 5);
CALL ThemNhanVienGiaoHang('nvgh27_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang27_2', '0811100079', 'nvgh27_2@mail.com', '180000000080', TO_DATE('1998-08-24','YYYY-MM-DD'), 'Nam', 'Kho 27, Số 1 Đường ABC, TP.HCM', 27, 27, 5);
CALL ThemNhanVienGiaoHang('nvgh27_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang27_3', '0811100080', 'nvgh27_3@mail.com', '180000000081', TO_DATE('1998-09-25','YYYY-MM-DD'), 'Nam', 'Kho 27, Số 1 Đường ABC, TP.HCM', 27, 27, 5);
CALL ThemNhanVienGiaoHang('nvgh28_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang28_1', '0811100081', 'nvgh28_1@mail.com', '180000000082', TO_DATE('1998-10-26','YYYY-MM-DD'), 'Nam', 'Kho 28, Số 1 Đường ABC, TP.HCM', 28, 28, 5);
CALL ThemNhanVienGiaoHang('nvgh28_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang28_2', '0811100082', 'nvgh28_2@mail.com', '180000000083', TO_DATE('1998-11-27','YYYY-MM-DD'), 'Nam', 'Kho 28, Số 1 Đường ABC, TP.HCM', 28, 28, 5);
CALL ThemNhanVienGiaoHang('nvgh28_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang28_3', '0811100083', 'nvgh28_3@mail.com', '180000000084', TO_DATE('1998-12-28','YYYY-MM-DD'), 'Nam', 'Kho 28, Số 1 Đường ABC, TP.HCM', 28, 28, 5);
CALL ThemNhanVienGiaoHang('nvgh29_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang29_1', '0811100084', 'nvgh29_1@mail.com', '180000000085', TO_DATE('1998-01-01','YYYY-MM-DD'), 'Nam', 'Kho 29, Số 1 Đường ABC, TP.HCM', 29, 29, 5);
CALL ThemNhanVienGiaoHang('nvgh29_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang29_2', '0811100085', 'nvgh29_2@mail.com', '180000000086', TO_DATE('1998-02-02','YYYY-MM-DD'), 'Nam', 'Kho 29, Số 1 Đường ABC, TP.HCM', 29, 29, 5);
CALL ThemNhanVienGiaoHang('nvgh29_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang29_3', '0811100086', 'nvgh29_3@mail.com', '180000000087', TO_DATE('1998-03-03','YYYY-MM-DD'), 'Nam', 'Kho 29, Số 1 Đường ABC, TP.HCM', 29, 29, 5);
CALL ThemNhanVienGiaoHang('nvgh30_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang30_1', '0811100087', 'nvgh30_1@mail.com', '180000000088', TO_DATE('1998-04-04','YYYY-MM-DD'), 'Nam', 'Kho 30, Số 1 Đường ABC, TP.HCM', 30, 30, 5);
CALL ThemNhanVienGiaoHang('nvgh30_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang30_2', '0811100088', 'nvgh30_2@mail.com', '180000000089', TO_DATE('1998-05-05','YYYY-MM-DD'), 'Nam', 'Kho 30, Số 1 Đường ABC, TP.HCM', 30, 30, 5);
CALL ThemNhanVienGiaoHang('nvgh30_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang30_3', '0811100089', 'nvgh30_3@mail.com', '180000000090', TO_DATE('1998-06-06','YYYY-MM-DD'), 'Nam', 'Kho 30, Số 1 Đường ABC, TP.HCM', 30, 30, 5);
CALL ThemNhanVienGiaoHang('nvgh31_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang31_1', '0811100090', 'nvgh31_1@mail.com', '180000000091', TO_DATE('1998-07-07','YYYY-MM-DD'), 'Nam', 'Kho 31, Số 1 Đường ABC, TP.HCM', 31, 31, 5);
CALL ThemNhanVienGiaoHang('nvgh31_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang31_2', '0811100091', 'nvgh31_2@mail.com', '180000000092', TO_DATE('1998-08-08','YYYY-MM-DD'), 'Nam', 'Kho 31, Số 1 Đường ABC, TP.HCM', 31, 31, 5);
CALL ThemNhanVienGiaoHang('nvgh31_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang31_3', '0811100092', 'nvgh31_3@mail.com', '180000000093', TO_DATE('1998-09-09','YYYY-MM-DD'), 'Nam', 'Kho 31, Số 1 Đường ABC, TP.HCM', 31, 31, 5);
CALL ThemNhanVienGiaoHang('nvgh32_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang32_1', '0811100093', 'nvgh32_1@mail.com', '180000000094', TO_DATE('1998-10-10','YYYY-MM-DD'), 'Nam', 'Kho 32, Số 1 Đường ABC, TP.HCM', 32, 32, 5);
CALL ThemNhanVienGiaoHang('nvgh32_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang32_2', '0811100094', 'nvgh32_2@mail.com', '180000000095', TO_DATE('1998-11-11','YYYY-MM-DD'), 'Nam', 'Kho 32, Số 1 Đường ABC, TP.HCM', 32, 32, 5);
CALL ThemNhanVienGiaoHang('nvgh32_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang32_3', '0811100095', 'nvgh32_3@mail.com', '180000000096', TO_DATE('1998-12-12','YYYY-MM-DD'), 'Nam', 'Kho 32, Số 1 Đường ABC, TP.HCM', 32, 32, 5);
CALL ThemNhanVienGiaoHang('nvgh33_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang33_1', '0811100096', 'nvgh33_1@mail.com', '180000000097', TO_DATE('1998-01-13','YYYY-MM-DD'), 'Nam', 'Kho 33, Số 1 Đường ABC, TP.HCM', 33, 33, 5);
CALL ThemNhanVienGiaoHang('nvgh33_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang33_2', '0811100097', 'nvgh33_2@mail.com', '180000000098', TO_DATE('1998-02-14','YYYY-MM-DD'), 'Nam', 'Kho 33, Số 1 Đường ABC, TP.HCM', 33, 33, 5);
CALL ThemNhanVienGiaoHang('nvgh33_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang33_3', '0811100098', 'nvgh33_3@mail.com', '180000000099', TO_DATE('1998-03-15','YYYY-MM-DD'), 'Nam', 'Kho 33, Số 1 Đường ABC, TP.HCM', 33, 33, 5);
CALL ThemNhanVienGiaoHang('nvgh34_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang34_1', '0811100099', 'nvgh34_1@mail.com', '180000000100', TO_DATE('1998-04-16','YYYY-MM-DD'), 'Nam', 'Kho 34, Số 1 Đường ABC, TP.HCM', 34, 34, 5);
CALL ThemNhanVienGiaoHang('nvgh34_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang34_2', '0811100100', 'nvgh34_2@mail.com', '180000000101', TO_DATE('1998-05-17','YYYY-MM-DD'), 'Nam', 'Kho 34, Số 1 Đường ABC, TP.HCM', 34, 34, 5);
CALL ThemNhanVienGiaoHang('nvgh34_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang34_3', '0811100101', 'nvgh34_3@mail.com', '180000000102', TO_DATE('1998-06-18','YYYY-MM-DD'), 'Nam', 'Kho 34, Số 1 Đường ABC, TP.HCM', 34, 34, 5);
CALL ThemNhanVienGiaoHang('nvgh35_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang35_1', '0811100102', 'nvgh35_1@mail.com', '180000000103', TO_DATE('1998-07-19','YYYY-MM-DD'), 'Nam', 'Kho 35, Số 1 Đường ABC, TP.HCM', 35, 35, 5);
CALL ThemNhanVienGiaoHang('nvgh35_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang35_2', '0811100103', 'nvgh35_2@mail.com', '180000000104', TO_DATE('1998-08-20','YYYY-MM-DD'), 'Nam', 'Kho 35, Số 1 Đường ABC, TP.HCM', 35, 35, 5);
CALL ThemNhanVienGiaoHang('nvgh35_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang35_3', '0811100104', 'nvgh35_3@mail.com', '180000000105', TO_DATE('1998-09-21','YYYY-MM-DD'), 'Nam', 'Kho 35, Số 1 Đường ABC, TP.HCM', 35, 35, 5);
CALL ThemNhanVienGiaoHang('nvgh36_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang36_1', '0811100105', 'nvgh36_1@mail.com', '180000000106', TO_DATE('1998-10-22','YYYY-MM-DD'), 'Nam', 'Kho 36, Số 1 Đường ABC, TP.HCM', 36, 36, 5);
CALL ThemNhanVienGiaoHang('nvgh36_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang36_2', '0811100106', 'nvgh36_2@mail.com', '180000000107', TO_DATE('1998-11-23','YYYY-MM-DD'), 'Nam', 'Kho 36, Số 1 Đường ABC, TP.HCM', 36, 36, 5);
CALL ThemNhanVienGiaoHang('nvgh36_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang36_3', '0811100107', 'nvgh36_3@mail.com', '180000000108', TO_DATE('1998-12-24','YYYY-MM-DD'), 'Nam', 'Kho 36, Số 1 Đường ABC, TP.HCM', 36, 36, 5);
CALL ThemNhanVienGiaoHang('nvgh37_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang37_1', '0811100108', 'nvgh37_1@mail.com', '180000000109', TO_DATE('1998-01-25','YYYY-MM-DD'), 'Nam', 'Kho 37, Số 1 Đường ABC, TP.HCM', 37, 37, 5);
CALL ThemNhanVienGiaoHang('nvgh37_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang37_2', '0811100109', 'nvgh37_2@mail.com', '180000000110', TO_DATE('1998-02-26','YYYY-MM-DD'), 'Nam', 'Kho 37, Số 1 Đường ABC, TP.HCM', 37, 37, 5);
CALL ThemNhanVienGiaoHang('nvgh37_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang37_3', '0811100110', 'nvgh37_3@mail.com', '180000000111', TO_DATE('1998-03-27','YYYY-MM-DD'), 'Nam', 'Kho 37, Số 1 Đường ABC, TP.HCM', 37, 37, 5);
CALL ThemNhanVienGiaoHang('nvgh38_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang38_1', '0811100111', 'nvgh38_1@mail.com', '180000000112', TO_DATE('1998-04-28','YYYY-MM-DD'), 'Nam', 'Kho 38, Số 1 Đường ABC, TP.HCM', 38, 38, 5);
CALL ThemNhanVienGiaoHang('nvgh38_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang38_2', '0811100112', 'nvgh38_2@mail.com', '180000000113', TO_DATE('1998-05-01','YYYY-MM-DD'), 'Nam', 'Kho 38, Số 1 Đường ABC, TP.HCM', 38, 38, 5);
CALL ThemNhanVienGiaoHang('nvgh38_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang38_3', '0811100113', 'nvgh38_3@mail.com', '180000000114', TO_DATE('1998-06-02','YYYY-MM-DD'), 'Nam', 'Kho 38, Số 1 Đường ABC, TP.HCM', 38, 38, 5);
CALL ThemNhanVienGiaoHang('nvgh39_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang39_1', '0811100114', 'nvgh39_1@mail.com', '180000000115', TO_DATE('1998-07-03','YYYY-MM-DD'), 'Nam', 'Kho 39, Số 1 Đường ABC, TP.HCM', 39, 39, 5);
CALL ThemNhanVienGiaoHang('nvgh39_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang39_2', '0811100115', 'nvgh39_2@mail.com', '180000000116', TO_DATE('1998-08-04','YYYY-MM-DD'), 'Nam', 'Kho 39, Số 1 Đường ABC, TP.HCM', 39, 39, 5);
CALL ThemNhanVienGiaoHang('nvgh39_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang39_3', '0811100116', 'nvgh39_3@mail.com', '180000000117', TO_DATE('1998-09-05','YYYY-MM-DD'), 'Nam', 'Kho 39, Số 1 Đường ABC, TP.HCM', 39, 39, 5);
CALL ThemNhanVienGiaoHang('nvgh40_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang40_1', '0811100117', 'nvgh40_1@mail.com', '180000000118', TO_DATE('1998-10-06','YYYY-MM-DD'), 'Nam', 'Kho 40, Số 1 Đường ABC, TP.HCM', 40, 40, 5);
CALL ThemNhanVienGiaoHang('nvgh40_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang40_2', '0811100118', 'nvgh40_2@mail.com', '180000000119', TO_DATE('1998-11-07','YYYY-MM-DD'), 'Nam', 'Kho 40, Số 1 Đường ABC, TP.HCM', 40, 40, 5);
CALL ThemNhanVienGiaoHang('nvgh40_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang40_3', '0811100119', 'nvgh40_3@mail.com', '180000000120', TO_DATE('1998-12-08','YYYY-MM-DD'), 'Nam', 'Kho 40, Số 1 Đường ABC, TP.HCM', 40, 40, 5);
CALL ThemNhanVienGiaoHang('nvgh41_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang41_1', '0811100120', 'nvgh41_1@mail.com', '180000000121', TO_DATE('1998-01-09','YYYY-MM-DD'), 'Nam', 'Kho 41, Số 1 Đường ABC, TP.HCM', 41, 41, 5);
CALL ThemNhanVienGiaoHang('nvgh41_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang41_2', '0811100121', 'nvgh41_2@mail.com', '180000000122', TO_DATE('1998-02-10','YYYY-MM-DD'), 'Nam', 'Kho 41, Số 1 Đường ABC, TP.HCM', 41, 41, 5);
CALL ThemNhanVienGiaoHang('nvgh41_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang41_3', '0811100122', 'nvgh41_3@mail.com', '180000000123', TO_DATE('1998-03-11','YYYY-MM-DD'), 'Nam', 'Kho 41, Số 1 Đường ABC, TP.HCM', 41, 41, 5);
CALL ThemNhanVienGiaoHang('nvgh42_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang42_1', '0811100123', 'nvgh42_1@mail.com', '180000000124', TO_DATE('1998-04-12','YYYY-MM-DD'), 'Nam', 'Kho 42, Số 1 Đường ABC, TP.HCM', 42, 42, 5);
CALL ThemNhanVienGiaoHang('nvgh42_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang42_2', '0811100124', 'nvgh42_2@mail.com', '180000000125', TO_DATE('1998-05-13','YYYY-MM-DD'), 'Nam', 'Kho 42, Số 1 Đường ABC, TP.HCM', 42, 42, 5);
CALL ThemNhanVienGiaoHang('nvgh42_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang42_3', '0811100125', 'nvgh42_3@mail.com', '180000000126', TO_DATE('1998-06-14','YYYY-MM-DD'), 'Nam', 'Kho 42, Số 1 Đường ABC, TP.HCM', 42, 42, 5);
CALL ThemNhanVienGiaoHang('nvgh43_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang43_1', '0811100126', 'nvgh43_1@mail.com', '180000000127', TO_DATE('1998-07-15','YYYY-MM-DD'), 'Nam', 'Kho 43, Số 1 Đường ABC, TP.HCM', 43, 43, 5);
CALL ThemNhanVienGiaoHang('nvgh43_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang43_2', '0811100127', 'nvgh43_2@mail.com', '180000000128', TO_DATE('1998-08-16','YYYY-MM-DD'), 'Nam', 'Kho 43, Số 1 Đường ABC, TP.HCM', 43, 43, 5);
CALL ThemNhanVienGiaoHang('nvgh43_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang43_3', '0811100128', 'nvgh43_3@mail.com', '180000000129', TO_DATE('1998-09-17','YYYY-MM-DD'), 'Nam', 'Kho 43, Số 1 Đường ABC, TP.HCM', 43, 43, 5);
CALL ThemNhanVienGiaoHang('nvgh44_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang44_1', '0811100129', 'nvgh44_1@mail.com', '180000000130', TO_DATE('1998-10-18','YYYY-MM-DD'), 'Nam', 'Kho 44, Số 1 Đường ABC, TP.HCM', 44, 44, 5);
CALL ThemNhanVienGiaoHang('nvgh44_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang44_2', '0811100130', 'nvgh44_2@mail.com', '180000000131', TO_DATE('1998-11-19','YYYY-MM-DD'), 'Nam', 'Kho 44, Số 1 Đường ABC, TP.HCM', 44, 44, 5);
CALL ThemNhanVienGiaoHang('nvgh44_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang44_3', '0811100131', 'nvgh44_3@mail.com', '180000000132', TO_DATE('1998-12-20','YYYY-MM-DD'), 'Nam', 'Kho 44, Số 1 Đường ABC, TP.HCM', 44, 44, 5);
CALL ThemNhanVienGiaoHang('nvgh45_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang45_1', '0811100132', 'nvgh45_1@mail.com', '180000000133', TO_DATE('1998-01-21','YYYY-MM-DD'), 'Nam', 'Kho 45, Số 1 Đường ABC, TP.HCM', 45, 45, 5);
CALL ThemNhanVienGiaoHang('nvgh45_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang45_2', '0811100133', 'nvgh45_2@mail.com', '180000000134', TO_DATE('1998-02-22','YYYY-MM-DD'), 'Nam', 'Kho 45, Số 1 Đường ABC, TP.HCM', 45, 45, 5);
CALL ThemNhanVienGiaoHang('nvgh45_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang45_3', '0811100134', 'nvgh45_3@mail.com', '180000000135', TO_DATE('1998-03-23','YYYY-MM-DD'), 'Nam', 'Kho 45, Số 1 Đường ABC, TP.HCM', 45, 45, 5);
CALL ThemNhanVienGiaoHang('nvgh46_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang46_1', '0811100135', 'nvgh46_1@mail.com', '180000000136', TO_DATE('1998-04-24','YYYY-MM-DD'), 'Nam', 'Kho 46, Số 1 Đường ABC, TP.HCM', 46, 46, 5);
CALL ThemNhanVienGiaoHang('nvgh46_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang46_2', '0811100136', 'nvgh46_2@mail.com', '180000000137', TO_DATE('1998-05-25','YYYY-MM-DD'), 'Nam', 'Kho 46, Số 1 Đường ABC, TP.HCM', 46, 46, 5);
CALL ThemNhanVienGiaoHang('nvgh46_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang46_3', '0811100137', 'nvgh46_3@mail.com', '180000000138', TO_DATE('1998-06-26','YYYY-MM-DD'), 'Nam', 'Kho 46, Số 1 Đường ABC, TP.HCM', 46, 46, 5);
CALL ThemNhanVienGiaoHang('nvgh47_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang47_1', '0811100138', 'nvgh47_1@mail.com', '180000000139', TO_DATE('1998-07-27','YYYY-MM-DD'), 'Nam', 'Kho 47, Số 1 Đường ABC, TP.HCM', 47, 47, 5);
CALL ThemNhanVienGiaoHang('nvgh47_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang47_2', '0811100139', 'nvgh47_2@mail.com', '180000000140', TO_DATE('1998-08-28','YYYY-MM-DD'), 'Nam', 'Kho 47, Số 1 Đường ABC, TP.HCM', 47, 47, 5);
CALL ThemNhanVienGiaoHang('nvgh47_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang47_3', '0811100140', 'nvgh47_3@mail.com', '180000000141', TO_DATE('1998-09-01','YYYY-MM-DD'), 'Nam', 'Kho 47, Số 1 Đường ABC, TP.HCM', 47, 47, 5);
CALL ThemNhanVienGiaoHang('nvgh48_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang48_1', '0811100141', 'nvgh48_1@mail.com', '180000000142', TO_DATE('1998-10-02','YYYY-MM-DD'), 'Nam', 'Kho 48, Số 1 Đường ABC, TP.HCM', 48, 48, 5);
CALL ThemNhanVienGiaoHang('nvgh48_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang48_2', '0811100142', 'nvgh48_2@mail.com', '180000000143', TO_DATE('1998-11-03','YYYY-MM-DD'), 'Nam', 'Kho 48, Số 1 Đường ABC, TP.HCM', 48, 48, 5);
CALL ThemNhanVienGiaoHang('nvgh48_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang48_3', '0811100143', 'nvgh48_3@mail.com', '180000000144', TO_DATE('1998-12-04','YYYY-MM-DD'), 'Nam', 'Kho 48, Số 1 Đường ABC, TP.HCM', 48, 48, 5);
CALL ThemNhanVienGiaoHang('nvgh49_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang49_1', '0811100144', 'nvgh49_1@mail.com', '180000000145', TO_DATE('1998-01-05','YYYY-MM-DD'), 'Nam', 'Kho 49, Số 1 Đường ABC, TP.HCM', 49, 49, 5);
CALL ThemNhanVienGiaoHang('nvgh49_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang49_2', '0811100145', 'nvgh49_2@mail.com', '180000000146', TO_DATE('1998-02-06','YYYY-MM-DD'), 'Nam', 'Kho 49, Số 1 Đường ABC, TP.HCM', 49, 49, 5);
CALL ThemNhanVienGiaoHang('nvgh49_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang49_3', '0811100146', 'nvgh49_3@mail.com', '180000000147', TO_DATE('1998-03-07','YYYY-MM-DD'), 'Nam', 'Kho 49, Số 1 Đường ABC, TP.HCM', 49, 49, 5);
CALL ThemNhanVienGiaoHang('nvgh50_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang50_1', '0811100147', 'nvgh50_1@mail.com', '180000000148', TO_DATE('1998-04-08','YYYY-MM-DD'), 'Nam', 'Kho 50, Số 1 Đường ABC, TP.HCM', 50, 50, 5);
CALL ThemNhanVienGiaoHang('nvgh50_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang50_2', '0811100148', 'nvgh50_2@mail.com', '180000000149', TO_DATE('1998-05-09','YYYY-MM-DD'), 'Nam', 'Kho 50, Số 1 Đường ABC, TP.HCM', 50, 50, 5);
CALL ThemNhanVienGiaoHang('nvgh50_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang50_3', '0811100149', 'nvgh50_3@mail.com', '180000000150', TO_DATE('1998-06-10','YYYY-MM-DD'), 'Nam', 'Kho 50, Số 1 Đường ABC, TP.HCM', 50, 50, 5);
CALL ThemNhanVienGiaoHang('nvgh51_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang51_1', '0811100150', 'nvgh51_1@mail.com', '180000000151', TO_DATE('1998-07-11','YYYY-MM-DD'), 'Nam', 'Kho 51, Số 1 Đường ABC, TP.HCM', 51, 51, 5);
CALL ThemNhanVienGiaoHang('nvgh51_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang51_2', '0811100151', 'nvgh51_2@mail.com', '180000000152', TO_DATE('1998-08-12','YYYY-MM-DD'), 'Nam', 'Kho 51, Số 1 Đường ABC, TP.HCM', 51, 51, 5);
CALL ThemNhanVienGiaoHang('nvgh51_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang51_3', '0811100152', 'nvgh51_3@mail.com', '180000000153', TO_DATE('1998-09-13','YYYY-MM-DD'), 'Nam', 'Kho 51, Số 1 Đường ABC, TP.HCM', 51, 51, 5);
CALL ThemNhanVienGiaoHang('nvgh52_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang52_1', '0811100153', 'nvgh52_1@mail.com', '180000000154', TO_DATE('1998-10-14','YYYY-MM-DD'), 'Nam', 'Kho 52, Số 1 Đường ABC, TP.HCM', 52, 52, 5);
CALL ThemNhanVienGiaoHang('nvgh52_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang52_2', '0811100154', 'nvgh52_2@mail.com', '180000000155', TO_DATE('1998-11-15','YYYY-MM-DD'), 'Nam', 'Kho 52, Số 1 Đường ABC, TP.HCM', 52, 52, 5);
CALL ThemNhanVienGiaoHang('nvgh52_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang52_3', '0811100155', 'nvgh52_3@mail.com', '180000000156', TO_DATE('1998-12-16','YYYY-MM-DD'), 'Nam', 'Kho 52, Số 1 Đường ABC, TP.HCM', 52, 52, 5);
CALL ThemNhanVienGiaoHang('nvgh53_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang53_1', '0811100156', 'nvgh53_1@mail.com', '180000000157', TO_DATE('1998-01-17','YYYY-MM-DD'), 'Nam', 'Kho 53, Số 1 Đường ABC, TP.HCM', 53, 53, 5);
CALL ThemNhanVienGiaoHang('nvgh53_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang53_2', '0811100157', 'nvgh53_2@mail.com', '180000000158', TO_DATE('1998-02-18','YYYY-MM-DD'), 'Nam', 'Kho 53, Số 1 Đường ABC, TP.HCM', 53, 53, 5);
CALL ThemNhanVienGiaoHang('nvgh53_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang53_3', '0811100158', 'nvgh53_3@mail.com', '180000000159', TO_DATE('1998-03-19','YYYY-MM-DD'), 'Nam', 'Kho 53, Số 1 Đường ABC, TP.HCM', 53, 53, 5);
CALL ThemNhanVienGiaoHang('nvgh54_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang54_1', '0811100159', 'nvgh54_1@mail.com', '180000000160', TO_DATE('1998-04-20','YYYY-MM-DD'), 'Nam', 'Kho 54, Số 1 Đường ABC, TP.HCM', 54, 54, 5);
CALL ThemNhanVienGiaoHang('nvgh54_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang54_2', '0811100160', 'nvgh54_2@mail.com', '180000000161', TO_DATE('1998-05-21','YYYY-MM-DD'), 'Nam', 'Kho 54, Số 1 Đường ABC, TP.HCM', 54, 54, 5);
CALL ThemNhanVienGiaoHang('nvgh54_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang54_3', '0811100161', 'nvgh54_3@mail.com', '180000000162', TO_DATE('1998-06-22','YYYY-MM-DD'), 'Nam', 'Kho 54, Số 1 Đường ABC, TP.HCM', 54, 54, 5);
CALL ThemNhanVienGiaoHang('nvgh55_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang55_1', '0811100162', 'nvgh55_1@mail.com', '180000000163', TO_DATE('1998-07-23','YYYY-MM-DD'), 'Nam', 'Kho 55, Số 1 Đường ABC, TP.HCM', 55, 55, 5);
CALL ThemNhanVienGiaoHang('nvgh55_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang55_2', '0811100163', 'nvgh55_2@mail.com', '180000000164', TO_DATE('1998-08-24','YYYY-MM-DD'), 'Nam', 'Kho 55, Số 1 Đường ABC, TP.HCM', 55, 55, 5);
CALL ThemNhanVienGiaoHang('nvgh55_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang55_3', '0811100164', 'nvgh55_3@mail.com', '180000000165', TO_DATE('1998-09-25','YYYY-MM-DD'), 'Nam', 'Kho 55, Số 1 Đường ABC, TP.HCM', 55, 55, 5);
CALL ThemNhanVienGiaoHang('nvgh56_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang56_1', '0811100165', 'nvgh56_1@mail.com', '180000000166', TO_DATE('1998-10-26','YYYY-MM-DD'), 'Nam', 'Kho 56, Số 1 Đường ABC, TP.HCM', 56, 56, 5);
CALL ThemNhanVienGiaoHang('nvgh56_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang56_2', '0811100166', 'nvgh56_2@mail.com', '180000000167', TO_DATE('1998-11-27','YYYY-MM-DD'), 'Nam', 'Kho 56, Số 1 Đường ABC, TP.HCM', 56, 56, 5);
CALL ThemNhanVienGiaoHang('nvgh56_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang56_3', '0811100167', 'nvgh56_3@mail.com', '180000000168', TO_DATE('1998-12-28','YYYY-MM-DD'), 'Nam', 'Kho 56, Số 1 Đường ABC, TP.HCM', 56, 56, 5);
CALL ThemNhanVienGiaoHang('nvgh57_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang57_1', '0811100168', 'nvgh57_1@mail.com', '180000000169', TO_DATE('1998-01-01','YYYY-MM-DD'), 'Nam', 'Kho 57, Số 1 Đường ABC, TP.HCM', 57, 57, 5);
CALL ThemNhanVienGiaoHang('nvgh57_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang57_2', '0811100169', 'nvgh57_2@mail.com', '180000000170', TO_DATE('1998-02-02','YYYY-MM-DD'), 'Nam', 'Kho 57, Số 1 Đường ABC, TP.HCM', 57, 57, 5);
CALL ThemNhanVienGiaoHang('nvgh57_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang57_3', '0811100170', 'nvgh57_3@mail.com', '180000000171', TO_DATE('1998-03-03','YYYY-MM-DD'), 'Nam', 'Kho 57, Số 1 Đường ABC, TP.HCM', 57, 57, 5);
CALL ThemNhanVienGiaoHang('nvgh58_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang58_1', '0811100171', 'nvgh58_1@mail.com', '180000000172', TO_DATE('1998-04-04','YYYY-MM-DD'), 'Nam', 'Kho 58, Số 1 Đường ABC, TP.HCM', 58, 58, 5);
CALL ThemNhanVienGiaoHang('nvgh58_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang58_2', '0811100172', 'nvgh58_2@mail.com', '180000000173', TO_DATE('1998-05-05','YYYY-MM-DD'), 'Nam', 'Kho 58, Số 1 Đường ABC, TP.HCM', 58, 58, 5);
CALL ThemNhanVienGiaoHang('nvgh58_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang58_3', '0811100173', 'nvgh58_3@mail.com', '180000000174', TO_DATE('1998-06-06','YYYY-MM-DD'), 'Nam', 'Kho 58, Số 1 Đường ABC, TP.HCM', 58, 58, 5);
CALL ThemNhanVienGiaoHang('nvgh59_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang59_1', '0811100174', 'nvgh59_1@mail.com', '180000000175', TO_DATE('1998-07-07','YYYY-MM-DD'), 'Nam', 'Kho 59, Số 1 Đường ABC, TP.HCM', 59, 59, 5);
CALL ThemNhanVienGiaoHang('nvgh59_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang59_2', '0811100175', 'nvgh59_2@mail.com', '180000000176', TO_DATE('1998-08-08','YYYY-MM-DD'), 'Nam', 'Kho 59, Số 1 Đường ABC, TP.HCM', 59, 59, 5);
CALL ThemNhanVienGiaoHang('nvgh59_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang59_3', '0811100176', 'nvgh59_3@mail.com', '180000000177', TO_DATE('1998-09-09','YYYY-MM-DD'), 'Nam', 'Kho 59, Số 1 Đường ABC, TP.HCM', 59, 59, 5);
CALL ThemNhanVienGiaoHang('nvgh60_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang60_1', '0811100177', 'nvgh60_1@mail.com', '180000000178', TO_DATE('1998-10-10','YYYY-MM-DD'), 'Nam', 'Kho 60, Số 1 Đường ABC, TP.HCM', 60, 60, 5);
CALL ThemNhanVienGiaoHang('nvgh60_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang60_2', '0811100178', 'nvgh60_2@mail.com', '180000000179', TO_DATE('1998-11-11','YYYY-MM-DD'), 'Nam', 'Kho 60, Số 1 Đường ABC, TP.HCM', 60, 60, 5);
CALL ThemNhanVienGiaoHang('nvgh60_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang60_3', '0811100179', 'nvgh60_3@mail.com', '180000000180', TO_DATE('1998-12-12','YYYY-MM-DD'), 'Nam', 'Kho 60, Số 1 Đường ABC, TP.HCM', 60, 60, 5);
CALL ThemNhanVienGiaoHang('nvgh61_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang61_1', '0811100180', 'nvgh61_1@mail.com', '180000000181', TO_DATE('1998-01-13','YYYY-MM-DD'), 'Nam', 'Kho 61, Số 1 Đường ABC, TP.HCM', 61, 61, 5);
CALL ThemNhanVienGiaoHang('nvgh61_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang61_2', '0811100181', 'nvgh61_2@mail.com', '180000000182', TO_DATE('1998-02-14','YYYY-MM-DD'), 'Nam', 'Kho 61, Số 1 Đường ABC, TP.HCM', 61, 61, 5);
CALL ThemNhanVienGiaoHang('nvgh61_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang61_3', '0811100182', 'nvgh61_3@mail.com', '180000000183', TO_DATE('1998-03-15','YYYY-MM-DD'), 'Nam', 'Kho 61, Số 1 Đường ABC, TP.HCM', 61, 61, 5);
CALL ThemNhanVienGiaoHang('nvgh62_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang62_1', '0811100183', 'nvgh62_1@mail.com', '180000000184', TO_DATE('1998-04-16','YYYY-MM-DD'), 'Nam', 'Kho 62, Số 1 Đường ABC, TP.HCM', 62, 62, 5);
CALL ThemNhanVienGiaoHang('nvgh62_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang62_2', '0811100184', 'nvgh62_2@mail.com', '180000000185', TO_DATE('1998-05-17','YYYY-MM-DD'), 'Nam', 'Kho 62, Số 1 Đường ABC, TP.HCM', 62, 62, 5);
CALL ThemNhanVienGiaoHang('nvgh62_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang62_3', '0811100185', 'nvgh62_3@mail.com', '180000000186', TO_DATE('1998-06-18','YYYY-MM-DD'), 'Nam', 'Kho 62, Số 1 Đường ABC, TP.HCM', 62, 62, 5);
CALL ThemNhanVienGiaoHang('nvgh63_1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang63_1', '0811100186', 'nvgh63_1@mail.com', '180000000187', TO_DATE('1998-07-19','YYYY-MM-DD'), 'Nam', 'Kho 63, Số 1 Đường ABC, TP.HCM', 63, 63, 5);
CALL ThemNhanVienGiaoHang('nvgh63_2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang63_2', '0811100187', 'nvgh63_2@mail.com', '180000000188', TO_DATE('1998-08-20','YYYY-MM-DD'), 'Nam', 'Kho 63, Số 1 Đường ABC, TP.HCM', 63, 63, 5);
CALL ThemNhanVienGiaoHang('nvgh63_3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'NhanVienGiaoHang63_3', '0811100188', 'nvgh63_3@mail.com', '180000000189', TO_DATE('1998-09-21','YYYY-MM-DD'), 'Nam', 'Kho 63, Số 1 Đường ABC, TP.HCM', 63, 63, 5);
commit;

CALL ThemKhachHang('KH1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_1', '0123456101', 'KH1@example.com', '096205221001', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_2', '0123456102', 'KH2@example.com', '096205221002', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_3', '0123456103', 'KH3@example.com', '096205221003', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH4', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_4', '0123456104', 'KH4@example.com', '096205221004', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH5', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_5', '0123456105', 'KH5@example.com', '096205221005', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH6', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_6', '0123456106', 'KH6@example.com', '096205221006', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH7', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_7', '0123456107', 'KH7@example.com', '096205221007', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH8', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_8', '0123456108', 'KH8@example.com', '096205221008', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH9', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_9', '0123456109', 'KH9@example.com', '096205221009', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH10', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_10', '0123456110', 'KH10@example.com', '096205221010', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH11', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_11', '0123456111', 'KH11@example.com', '096205221011', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH12', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_12', '0123456112', 'KH12@example.com', '096205221012', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH13', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_13', '0123456113', 'KH13@example.com', '096205221013', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH14', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_14', '0123456114', 'KH14@example.com', '096205221014', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH15', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_15', '0123456115', 'KH15@example.com', '096205221015', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH16', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_16', '0123456116', 'KH16@example.com', '096205221016', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH17', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_17', '0123456117', 'KH17@example.com', '096205221017', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH18', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_18', '0123456118', 'KH18@example.com', '096205221018', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH19', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_19', '0123456119', 'KH19@example.com', '096205221019', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH20', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_20', '0123456120', 'KH20@example.com', '096205221020', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH21', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_21', '0123456121', 'KH21@example.com', '096205221021', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH22', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_22', '0123456122', 'KH22@example.com', '096205221022', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH23', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_23', '0123456123', 'KH23@example.com', '096205221023', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH24', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_24', '0123456124', 'KH24@example.com', '096205221024', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH25', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_25', '0123456125', 'KH25@example.com', '096205221025', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH26', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_26', '0123456126', 'KH26@example.com', '096205221026', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH27', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_27', '0123456127', 'KH27@example.com', '096205221027', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH28', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_28', '0123456128', 'KH28@example.com', '096205221028', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH29', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_29', '0123456129', 'KH29@example.com', '096205221029', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH30', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_30', '0123456130', 'KH30@example.com', '096205221030', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH31', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_31', '0123456131', 'KH31@example.com', '096205221031', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH32', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_32', '0123456132', 'KH32@example.com', '096205221032', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH33', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_33', '0123456133', 'KH33@example.com', '096205221033', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH34', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_34', '0123456134', 'KH34@example.com', '096205221034', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH35', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_35', '0123456135', 'KH35@example.com', '096205221035', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH36', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_36', '0123456136', 'KH36@example.com', '096205221036', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH37', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_37', '0123456137', 'KH37@example.com', '096205221037', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH38', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_38', '0123456138', 'KH38@example.com', '096205221038', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH39', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_39', '0123456139', 'KH39@example.com', '096205221039', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH40', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_40', '0123456140', 'KH40@example.com', '096205221040', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH41', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_41', '0123456141', 'KH41@example.com', '096205221041', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH42', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_42', '0123456142', 'KH42@example.com', '096205221042', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH43', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_43', '0123456143', 'KH43@example.com', '096205221043', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH44', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_44', '0123456144', 'KH44@example.com', '096205221044', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH45', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_45', '0123456145', 'KH45@example.com', '096205221045', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH46', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_46', '0123456146', 'KH46@example.com', '096205221046', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH47', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_47', '0123456147', 'KH47@example.com', '096205221047', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH48', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_48', '0123456148', 'KH48@example.com', '096205221048', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH49', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_49', '0123456149', 'KH49@example.com', '096205221049', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH50', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_50', '0123456150', 'KH50@example.com', '096205221050', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH51', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_51', '0123456151', 'KH51@example.com', '096205221051', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH52', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_52', '0123456152', 'KH52@example.com', '096205221052', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH53', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_53', '0123456153', 'KH53@example.com', '096205221053', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH54', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_54', '0123456154', 'KH54@example.com', '096205221054', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH55', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_55', '0123456155', 'KH55@example.com', '096205221055', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH56', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_56', '0123456156', 'KH56@example.com', '096205221056', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH57', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_57', '0123456157', 'KH57@example.com', '096205221057', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH58', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_58', '0123456158', 'KH58@example.com', '096205221058', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH59', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_59', '0123456159', 'KH59@example.com', '096205221059', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH60', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_60', '0123456160', 'KH60@example.com', '096205221060', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH61', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_61', '0123456161', 'KH61@example.com', '096205221061', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH62', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_62', '0123456162', 'KH62@example.com', '096205221062', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH63', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_63', '0123456163', 'KH63@example.com', '096205221063', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH64', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_64', '0123456164', 'KH64@example.com', '096205221064', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH65', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_65', '0123456165', 'KH65@example.com', '096205221065', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH66', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_66', '0123456166', 'KH66@example.com', '096205221066', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH67', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_67', '0123456167', 'KH67@example.com', '096205221067', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH68', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_68', '0123456168', 'KH68@example.com', '096205221068', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH69', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_69', '0123456169', 'KH69@example.com', '096205221069', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH70', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_70', '0123456170', 'KH70@example.com', '096205221070', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH71', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_71', '0123456171', 'KH71@example.com', '096205221071', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH72', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_72', '0123456172', 'KH72@example.com', '096205221072', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH73', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_73', '0123456173', 'KH73@example.com', '096205221073', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH74', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_74', '0123456174', 'KH74@example.com', '096205221074', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH75', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_75', '0123456175', 'KH75@example.com', '096205221075', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH76', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_76', '0123456176', 'KH76@example.com', '096205221076', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH77', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_77', '0123456177', 'KH77@example.com', '096205221077', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH78', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_78', '0123456178', 'KH78@example.com', '096205221078', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH79', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_79', '0123456179', 'KH79@example.com', '096205221079', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH80', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_80', '0123456180', 'KH80@example.com', '096205221080', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH81', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_81', '0123456181', 'KH81@example.com', '096205221081', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH82', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_82', '0123456182', 'KH82@example.com', '096205221082', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH83', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_83', '0123456183', 'KH83@example.com', '096205221083', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH84', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_84', '0123456184', 'KH84@example.com', '096205221084', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH85', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_85', '0123456185', 'KH85@example.com', '096205221085', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH86', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_86', '0123456186', 'KH86@example.com', '096205221086', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH87', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_87', '0123456187', 'KH87@example.com', '096205221087', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH88', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_88', '0123456188', 'KH88@example.com', '096205221088', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH89', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_89', '0123456189', 'KH89@example.com', '096205221089', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH90', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_90', '0123456190', 'KH90@example.com', '096205221090', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH91', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_91', '0123456191', 'KH91@example.com', '096205221091', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH92', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_92', '0123456192', 'KH92@example.com', '096205221092', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH93', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_93', '0123456193', 'KH93@example.com', '096205221093', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH94', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_94', '0123456194', 'KH94@example.com', '096205221094', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH95', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_95', '0123456195', 'KH95@example.com', '096205221095', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH96', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_96', '0123456196', 'KH96@example.com', '096205221096', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH97', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_97', '0123456197', 'KH97@example.com', '096205221097', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH98', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_98', '0123456198', 'KH98@example.com', '096205221098', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH99', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_99', '0123456199', 'KH99@example.com', '096205221099', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
CALL ThemKhachHang('KH100', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'HoTen_100', '0123456200', 'KH100@example.com', '096205221100', TO_DATE('1990-01-01','YYYY-MM-DD'), 'Nam');
commit;

--them donhang
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 1, NULL, '0123456101', '0944991420', 1, N'HoTen_1', N'Tùng Nhân', N'234/36b đường nguyễn trãi khóm 2, 9, Cà Mau, Cà Mau', 0, 15000, NULL, NULL, N'Đã giao', N'Nhanh', N'Tài liệu');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 1, NULL, '0123456101', '0944991420', 1, N'HoTen_1', N'Tùng Nhân', N'234/36b đường nguyễn trãi khóm 2, 9, Cà Mau, Cà Mau', 20000, 15000, NULL, NULL, N'Đã giao', N'Nhanh', N'Tài liệu');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 21, NULL, '0123456121', '0944991420', 1, N'HoTen_21', N'nhân', N'234/36b đường nguyễn trãi, 9, Cà Mau, Cà Mau', 0, 15000, NULL, NULL, N'Đã giao', N'Nhanh', N'Tài liệu');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 21, NULL, '0123456121', '0944991420', 1, N'HoTen_21', N'zzz', N'zzz, Trà Cú, Trà Cú, Trà Vinh', 0, 15000, NULL, NULL, N'Đã giao', N'Nhanh', N'Tài liệu');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 21, NULL, '0123456121', '0944991420', 1, N'HoTen_21', N'nhân', N'234/36b đường nguyễn trãi, 9, Cà Mau, Cà Mau', 0, 15000, NULL, NULL, N'Đã giao', N'Nhanh', N'Tài liệu');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 101, NULL, '0944991420', '0837934818', 2, N'Ngô Tùng Nhân', N'Trần Minh Hiếu', N'234/36b Đường Nguyễn Trãi, 9, Cà Mau, Cà Mau', 0, 15000, NULL, NULL, N'Đã giao', N'Nhanh', N'Tài liệu');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 101, NULL, '0944991420', '0944600909', 2, N'Ngô Tùng Nhân', N'Nguyễn Thanh Tùng', N'54 âu dương lân, Lê Hồng Phong, Thái Bình, Thái Bình', 70000, 15000, NULL, NULL, N'Đã giao', N'Nhanh', N'Tài liệu');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 26, NULL, '0922414602', '0882675916', 4, N'Người Gửi 1', N'Người Nhận 1', N'Số 1 Đường XYZ, Quận ABC', 0, 60000, NULL, NULL, N'Đã giao', N'Tiết kiệm', N'Cồng kềnh');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 10, NULL, '0911906057', '0890082012', 57, N'Người Gửi 2', N'Người Nhận 2', N'Số 2 Đường XYZ, Quận ABC', 0, 55000, NULL, NULL, N'Đã giao', N'Hỏa tốc', N'Bình thường');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 69, NULL, '0925532884', '0811216292', 59, N'Người Gửi 3', N'Người Nhận 3', N'Số 3 Đường XYZ, Quận ABC', 0, 60000, NULL, NULL, N'Đã giao', N'Tiết kiệm', N'Cồng kềnh');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 77, NULL, '0967669942', '0833584567', 60, N'Người Gửi 4', N'Người Nhận 4', N'Số 4 Đường XYZ, Quận ABC', 0, 40000, NULL, NULL, N'Đã giao', N'Nhanh', N'Bình thường');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 3, NULL, '0946799871', '0853322491', 52, N'Người Gửi 5', N'Người Nhận 5', N'Số 5 Đường XYZ, Quận ABC', 0, 65000, NULL, NULL, N'Đã giao', N'Nhanh', N'Cồng kềnh');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 57, NULL, '0999157587', '0810714557', 12, N'Người Gửi 6', N'Người Nhận 6', N'Số 6 Đường XYZ, Quận ABC', 0, 15000, NULL, NULL, N'Đã giao', N'Nhanh', N'Tài liệu');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 55, NULL, '0933315811', '0866379283', 17, N'Người Gửi 7', N'Người Nhận 7', N'Số 7 Đường XYZ, Quận ABC', 0, 80000, NULL, NULL, N'Đã giao', N'Hỏa tốc', N'Cồng kềnh');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 27, NULL, '0991561453', '0892855356', 30, N'Người Gửi 8', N'Người Nhận 8', N'Số 8 Đường XYZ, Quận ABC', 0, 15000, NULL, NULL, N'Đã giao', N'Nhanh', N'Tài liệu');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 68, NULL, '0996058030', '0829965889', 48, N'Người Gửi 9', N'Người Nhận 9', N'Số 9 Đường XYZ, Quận ABC', 0, 35000, NULL, NULL, N'Đã giao', N'Tiết kiệm', N'Bình thường');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 83, NULL, '0992436538', '0859214474', 17, N'Người Gửi 10', N'Người Nhận 10', N'Số 10 Đường XYZ, Quận ABC', 0, 65000, NULL, NULL, N'Đã giao', N'Nhanh', N'Cồng kềnh');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 82, NULL, '0921359467', '0811063646', 40, N'Người Gửi 11', N'Người Nhận 11', N'Số 11 Đường XYZ, Quận ABC', 0, 80000, NULL, NULL, N'Đã giao', N'Hỏa tốc', N'Cồng kềnh');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 71, NULL, '0932437591', '0848848695', 14, N'Người Gửi 12', N'Người Nhận 12', N'Số 12 Đường XYZ, Quận ABC', 0, 10000, NULL, NULL, N'Đã giao', N'Tiết kiệm', N'Tài liệu');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 81, NULL, '0952632949', '0859231397', 3, N'Người Gửi 13', N'Người Nhận 13', N'Số 13 Đường XYZ, Quận ABC', 0, 15000, NULL, NULL, N'Đã giao', N'Nhanh', N'Tài liệu');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 56, NULL, '0968404442', '0842857903', 43, N'Người Gửi 14', N'Người Nhận 14', N'Số 14 Đường XYZ, Quận ABC', 0, 80000, NULL, NULL, N'Đã giao', N'Hỏa tốc', N'Cồng kềnh');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 54, NULL, '0952604932', '0891594127', 23, N'Người Gửi 15', N'Người Nhận 15', N'Số 15 Đường XYZ, Quận ABC', 0, 35000, NULL, NULL, N'Đã giao', N'Tiết kiệm', N'Bình thường');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 96, NULL, '0993962854', '0844675278', 22, N'Người Gửi 16', N'Người Nhận 16', N'Số 16 Đường XYZ, Quận ABC', 0, 35000, NULL, NULL, N'Đã giao', N'Tiết kiệm', N'Bình thường');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 80, NULL, '0974683376', '0823999046', 59, N'Người Gửi 17', N'Người Nhận 17', N'Số 17 Đường XYZ, Quận ABC', 0, 60000, NULL, NULL, N'Đã giao', N'Tiết kiệm', N'Cồng kềnh');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 20, NULL, '0984071248', '0848690980', 30, N'Người Gửi 18', N'Người Nhận 18', N'Số 18 Đường XYZ, Quận ABC', 0, 80000, NULL, NULL, N'Đã giao', N'Hỏa tốc', N'Cồng kềnh');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 83, NULL, '0998426355', '0860840982', 23, N'Người Gửi 19', N'Người Nhận 19', N'Số 19 Đường XYZ, Quận ABC', 0, 80000, NULL, NULL, N'Đã giao', N'Hỏa tốc', N'Cồng kềnh');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 58, NULL, '0913221261', '0863964399', 22, N'Người Gửi 20', N'Người Nhận 20', N'Số 20 Đường XYZ, Quận ABC', 0, 55000, NULL, NULL, N'Đã giao', N'Hỏa tốc', N'Bình thường');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 38, NULL, '0963644411', '0826400446', 40, N'Người Gửi 21', N'Người Nhận 21', N'Số 21 Đường XYZ, Quận ABC', 0, 30000, NULL, NULL, N'Đã giao', N'Hỏa tốc', N'Tài liệu');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 82, NULL, '0910937185', '0827316327', 36, N'Người Gửi 22', N'Người Nhận 22', N'Số 22 Đường XYZ, Quận ABC', 0, 55000, NULL, NULL, N'Đã giao', N'Hỏa tốc', N'Bình thường');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 95, NULL, '0926559329', '0852475691', 46, N'Người Gửi 23', N'Người Nhận 23', N'Số 23 Đường XYZ, Quận ABC', 0, 55000, NULL, NULL, N'Đã giao', N'Hỏa tốc', N'Bình thường');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 59, NULL, '0978276225', '0851031288', 22, N'Người Gửi 24', N'Người Nhận 24', N'Số 24 Đường XYZ, Quận ABC', 0, 35000, NULL, NULL, N'Đã giao', N'Tiết kiệm', N'Bình thường');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 48, NULL, '0974171068', '0897184115', 33, N'Người Gửi 25', N'Người Nhận 25', N'Số 25 Đường XYZ, Quận ABC', 0, 55000, NULL, NULL, N'Đã giao', N'Hỏa tốc', N'Bình thường');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 12, NULL, '0966700411', '0838327789', 10, N'Người Gửi 26', N'Người Nhận 26', N'Số 26 Đường XYZ, Quận ABC', 0, 10000, NULL, NULL, N'Đã giao', N'Tiết kiệm', N'Tài liệu');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 4, NULL, '0917493913', '0885008433', 1, N'Người Gửi 27', N'Người Nhận 27', N'Số 27 Đường XYZ, Quận ABC', 0, 35000, NULL, NULL, N'Đã giao', N'Tiết kiệm', N'Bình thường');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 29, NULL, '0921474023', '0824985685', 47, N'Người Gửi 28', N'Người Nhận 28', N'Số 28 Đường XYZ, Quận ABC', 0, 65000, NULL, NULL, N'Đã giao', N'Nhanh', N'Cồng kềnh');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 47, NULL, '0974427783', '0881497486', 10, N'Người Gửi 29', N'Người Nhận 29', N'Số 29 Đường XYZ, Quận ABC', 0, 40000, NULL, NULL, N'Đã giao', N'Nhanh', N'Bình thường');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 92, NULL, '0927436090', '0837815480', 52, N'Người Gửi 30', N'Người Nhận 30', N'Số 30 Đường XYZ, Quận ABC', 0, 65000, NULL, NULL, N'Đã giao', N'Nhanh', N'Cồng kềnh');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 84, NULL, '0978809715', '0867637596', 56, N'Người Gửi 31', N'Người Nhận 31', N'Số 31 Đường XYZ, Quận ABC', 0, 10000, NULL, NULL, N'Đã giao', N'Tiết kiệm', N'Tài liệu');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 71, NULL, '0978758195', '0834053242', 60, N'Người Gửi 32', N'Người Nhận 32', N'Số 32 Đường XYZ, Quận ABC', 0, 40000, NULL, NULL, N'Đã giao', N'Nhanh', N'Bình thường');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 95, NULL, '0922780918', '0889750249', 53, N'Người Gửi 33', N'Người Nhận 33', N'Số 33 Đường XYZ, Quận ABC', 0, 35000, NULL, NULL, N'Đã giao', N'Tiết kiệm', N'Bình thường');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 18, NULL, '0972904794', '0848598852', 57, N'Người Gửi 34', N'Người Nhận 34', N'Số 34 Đường XYZ, Quận ABC', 0, 30000, NULL, NULL, N'Đã giao', N'Hỏa tốc', N'Tài liệu');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 95, NULL, '0911470779', '0884136501', 2, N'Người Gửi 35', N'Người Nhận 35', N'Số 35 Đường XYZ, Quận ABC', 0, 35000, NULL, NULL, N'Đã giao', N'Tiết kiệm', N'Bình thường');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 98, NULL, '0994527664', '0886303629', 53, N'Người Gửi 36', N'Người Nhận 36', N'Số 36 Đường XYZ, Quận ABC', 0, 10000, NULL, NULL, N'Đã giao', N'Tiết kiệm', N'Tài liệu');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 52, NULL, '0978576169', '0890232219', 60, N'Người Gửi 37', N'Người Nhận 37', N'Số 37 Đường XYZ, Quận ABC', 0, 35000, NULL, NULL, N'Đã giao', N'Tiết kiệm', N'Bình thường');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 13, NULL, '0913052132', '0887208701', 25, N'Người Gửi 38', N'Người Nhận 38', N'Số 38 Đường XYZ, Quận ABC', 0, 80000, NULL, NULL, N'Đã giao', N'Hỏa tốc', N'Cồng kềnh');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 90, NULL, '0981490757', '0890340884', 6, N'Người Gửi 39', N'Người Nhận 39', N'Số 39 Đường XYZ, Quận ABC', 0, 80000, NULL, NULL, N'Đã giao', N'Hỏa tốc', N'Cồng kềnh');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 85, NULL, '0996049493', '0880280495', 47, N'Người Gửi 40', N'Người Nhận 40', N'Số 40 Đường XYZ, Quận ABC', 0, 10000, NULL, NULL, N'Đã giao', N'Tiết kiệm', N'Tài liệu');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 53, NULL, '0987280436', '0873285860', 41, N'Người Gửi 41', N'Người Nhận 41', N'Số 41 Đường XYZ, Quận ABC', 0, 65000, NULL, NULL, N'Đã giao', N'Nhanh', N'Cồng kềnh');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 55, NULL, '0987438432', '0891357087', 28, N'Người Gửi 42', N'Người Nhận 42', N'Số 42 Đường XYZ, Quận ABC', 0, 30000, NULL, NULL, N'Đã giao', N'Hỏa tốc', N'Tài liệu');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 86, NULL, '0941565977', '0875956927', 18, N'Người Gửi 43', N'Người Nhận 43', N'Số 43 Đường XYZ, Quận ABC', 0, 40000, NULL, NULL, N'Đã giao', N'Nhanh', N'Bình thường');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 72, NULL, '0921025098', '0882961536', 51, N'Người Gửi 44', N'Người Nhận 44', N'Số 44 Đường XYZ, Quận ABC', 0, 55000, NULL, NULL, N'Đã giao', N'Hỏa tốc', N'Bình thường');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 41, NULL, '0968910976', '0890577158', 49, N'Người Gửi 45', N'Người Nhận 45', N'Số 45 Đường XYZ, Quận ABC', 0, 60000, NULL, NULL, N'Đã giao', N'Tiết kiệm', N'Cồng kềnh');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 27, NULL, '0969863573', '0865856606', 3, N'Người Gửi 46', N'Người Nhận 46', N'Số 46 Đường XYZ, Quận ABC', 0, 35000, NULL, NULL, N'Đã giao', N'Tiết kiệm', N'Bình thường');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 13, NULL, '0987656933', '0890490565', 41, N'Người Gửi 47', N'Người Nhận 47', N'Số 47 Đường XYZ, Quận ABC', 0, 55000, NULL, NULL, N'Đã giao', N'Hỏa tốc', N'Bình thường');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 74, NULL, '0945149815', '0823056735', 45, N'Người Gửi 48', N'Người Nhận 48', N'Số 48 Đường XYZ, Quận ABC', 0, 10000, NULL, NULL, N'Đã giao', N'Tiết kiệm', N'Tài liệu');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 36, NULL, '0966371073', '0817074592', 34, N'Người Gửi 49', N'Người Nhận 49', N'Số 49 Đường XYZ, Quận ABC', 0, 10000, NULL, NULL, N'Đã giao', N'Tiết kiệm', N'Tài liệu');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 50, NULL, '0953954397', '0856191414', 56, N'Người Gửi 50', N'Người Nhận 50', N'Số 50 Đường XYZ, Quận ABC', 0, 60000, NULL, NULL, N'Đã giao', N'Tiết kiệm', N'Cồng kềnh');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 72, NULL, '0954642736', '0857302007', 49, N'Người Gửi 51', N'Người Nhận 51', N'Số 51 Đường XYZ, Quận ABC', 0, 35000, NULL, NULL, N'Đã giao', N'Tiết kiệm', N'Bình thường');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 61, NULL, '0997185205', '0829222911', 59, N'Người Gửi 52', N'Người Nhận 52', N'Số 52 Đường XYZ, Quận ABC', 0, 10000, NULL, NULL, N'Đã giao', N'Tiết kiệm', N'Tài liệu');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 91, NULL, '0963435529', '0856174914', 28, N'Người Gửi 53', N'Người Nhận 53', N'Số 53 Đường XYZ, Quận ABC', 0, 55000, NULL, NULL, N'Đã giao', N'Hỏa tốc', N'Bình thường');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 39, NULL, '0943637760', '0835282051', 46, N'Người Gửi 54', N'Người Nhận 54', N'Số 54 Đường XYZ, Quận ABC', 0, 30000, NULL, NULL, N'Đã giao', N'Hỏa tốc', N'Tài liệu');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 12, NULL, '0997535881', '0823817972', 46, N'Người Gửi 55', N'Người Nhận 55', N'Số 55 Đường XYZ, Quận ABC', 0, 15000, NULL, NULL, N'Đã giao', N'Nhanh', N'Tài liệu');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 30, NULL, '0953031509', '0842299671', 51, N'Người Gửi 56', N'Người Nhận 56', N'Số 56 Đường XYZ, Quận ABC', 0, 10000, NULL, NULL, N'Đã giao', N'Tiết kiệm', N'Tài liệu');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 84, NULL, '0974880811', '0842335022', 21, N'Người Gửi 57', N'Người Nhận 57', N'Số 57 Đường XYZ, Quận ABC', 0, 10000, NULL, NULL, N'Đã giao', N'Tiết kiệm', N'Tài liệu');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 8, NULL, '0911163654', '0829806604', 16, N'Người Gửi 58', N'Người Nhận 58', N'Số 58 Đường XYZ, Quận ABC', 0, 35000, NULL, NULL, N'Đã giao', N'Tiết kiệm', N'Bình thường');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 53, NULL, '0972309947', '0887592158', 53, N'Người Gửi 59', N'Người Nhận 59', N'Số 59 Đường XYZ, Quận ABC', 0, 55000, NULL, NULL, N'Đã giao', N'Hỏa tốc', N'Bình thường');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 97, NULL, '0960430238', '0852178619', 51, N'Người Gửi 60', N'Người Nhận 60', N'Số 60 Đường XYZ, Quận ABC', 0, 55000, NULL, NULL, N'Đã giao', N'Hỏa tốc', N'Bình thường');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 57, NULL, '0982964796', '0850216715', 54, N'Người Gửi 61', N'Người Nhận 61', N'Số 61 Đường XYZ, Quận ABC', 0, 10000, NULL, NULL, N'Đã giao', N'Tiết kiệm', N'Tài liệu');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 34, NULL, '0981236872', '0838316341', 44, N'Người Gửi 62', N'Người Nhận 62', N'Số 62 Đường XYZ, Quận ABC', 0, 30000, NULL, NULL, N'Đã giao', N'Hỏa tốc', N'Tài liệu');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 60, NULL, '0911800787', '0844801415', 28, N'Người Gửi 63', N'Người Nhận 63', N'Số 63 Đường XYZ, Quận ABC', 0, 35000, NULL, NULL, N'Đã giao', N'Tiết kiệm', N'Bình thường');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 77, NULL, '0966908290', '0869845830', 39, N'Người Gửi 64', N'Người Nhận 64', N'Số 64 Đường XYZ, Quận ABC', 0, 65000, NULL, NULL, N'Đã giao', N'Nhanh', N'Cồng kềnh');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 77, NULL, '0970703156', '0813461749', 16, N'Người Gửi 65', N'Người Nhận 65', N'Số 65 Đường XYZ, Quận ABC', 0, 30000, NULL, NULL, N'Đã giao', N'Hỏa tốc', N'Tài liệu');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 95, NULL, '0931308781', '0857845608', 24, N'Người Gửi 66', N'Người Nhận 66', N'Số 66 Đường XYZ, Quận ABC', 0, 80000, NULL, NULL, N'Đã giao', N'Hỏa tốc', N'Cồng kềnh');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 30, NULL, '0999245364', '0882400527', 25, N'Người Gửi 67', N'Người Nhận 67', N'Số 67 Đường XYZ, Quận ABC', 0, 35000, NULL, NULL, N'Đã giao', N'Tiết kiệm', N'Bình thường');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 87, NULL, '0940499214', '0874110735', 8, N'Người Gửi 68', N'Người Nhận 68', N'Số 68 Đường XYZ, Quận ABC', 0, 15000, NULL, NULL, N'Đã giao', N'Nhanh', N'Tài liệu');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 14, NULL, '0952920218', '0827338530', 44, N'Người Gửi 69', N'Người Nhận 69', N'Số 69 Đường XYZ, Quận ABC', 0, 65000, NULL, NULL, N'Đã giao', N'Nhanh', N'Cồng kềnh');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 59, NULL, '0923892468', '0853667953', 20, N'Người Gửi 70', N'Người Nhận 70', N'Số 70 Đường XYZ, Quận ABC', 0, 35000, NULL, NULL, N'Đã giao', N'Tiết kiệm', N'Bình thường');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 15, NULL, '0921502721', '0812545655', 17, N'Người Gửi 71', N'Người Nhận 71', N'Số 71 Đường XYZ, Quận ABC', 0, 80000, NULL, NULL, N'Đã giao', N'Hỏa tốc', N'Cồng kềnh');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 25, NULL, '0988122796', '0811046153', 54, N'Người Gửi 72', N'Người Nhận 72', N'Số 72 Đường XYZ, Quận ABC', 0, 15000, NULL, NULL, N'Đã giao', N'Nhanh', N'Tài liệu');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 3, NULL, '0978245508', '0897407505', 38, N'Người Gửi 73', N'Người Nhận 73', N'Số 73 Đường XYZ, Quận ABC', 0, 10000, NULL, NULL, N'Đã giao', N'Tiết kiệm', N'Tài liệu');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 23, NULL, '0998957586', '0823623375', 55, N'Người Gửi 74', N'Người Nhận 74', N'Số 74 Đường XYZ, Quận ABC', 0, 65000, NULL, NULL, N'Đã giao', N'Nhanh', N'Cồng kềnh');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 80, NULL, '0975389942', '0845201249', 32, N'Người Gửi 75', N'Người Nhận 75', N'Số 75 Đường XYZ, Quận ABC', 0, 15000, NULL, NULL, N'Đã giao', N'Nhanh', N'Tài liệu');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 34, NULL, '0971942102', '0820748087', 27, N'Người Gửi 76', N'Người Nhận 76', N'Số 76 Đường XYZ, Quận ABC', 0, 55000, NULL, NULL, N'Đã giao', N'Hỏa tốc', N'Bình thường');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 15, NULL, '0911053083', '0828622011', 7, N'Người Gửi 77', N'Người Nhận 77', N'Số 77 Đường XYZ, Quận ABC', 0, 55000, NULL, NULL, N'Đã giao', N'Hỏa tốc', N'Bình thường');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 34, NULL, '0942498323', '0831165727', 11, N'Người Gửi 78', N'Người Nhận 78', N'Số 78 Đường XYZ, Quận ABC', 0, 40000, NULL, NULL, N'Đã giao', N'Nhanh', N'Bình thường');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 96, NULL, '0931089438', '0822850055', 49, N'Người Gửi 79', N'Người Nhận 79', N'Số 79 Đường XYZ, Quận ABC', 0, 60000, NULL, NULL, N'Đã giao', N'Tiết kiệm', N'Cồng kềnh');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 37, NULL, '0983018443', '0886892664', 57, N'Người Gửi 80', N'Người Nhận 80', N'Số 80 Đường XYZ, Quận ABC', 0, 60000, NULL, NULL, N'Đã giao', N'Tiết kiệm', N'Cồng kềnh');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 97, NULL, '0940643882', '0860064899', 35, N'Người Gửi 81', N'Người Nhận 81', N'Số 81 Đường XYZ, Quận ABC', 0, 15000, NULL, NULL, N'Đã giao', N'Nhanh', N'Tài liệu');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 42, NULL, '0976303079', '0879298591', 11, N'Người Gửi 82', N'Người Nhận 82', N'Số 82 Đường XYZ, Quận ABC', 0, 15000, NULL, NULL, N'Đã giao', N'Nhanh', N'Tài liệu');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 71, NULL, '0916388647', '0841455911', 34, N'Người Gửi 83', N'Người Nhận 83', N'Số 83 Đường XYZ, Quận ABC', 0, 35000, NULL, NULL, N'Đã giao', N'Tiết kiệm', N'Bình thường');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 48, NULL, '0940691225', '0896479381', 46, N'Người Gửi 84', N'Người Nhận 84', N'Số 84 Đường XYZ, Quận ABC', 0, 35000, NULL, NULL, N'Đã giao', N'Tiết kiệm', N'Bình thường');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 1, NULL, '0944733290', '0854960547', 42, N'Người Gửi 85', N'Người Nhận 85', N'Số 85 Đường XYZ, Quận ABC', 0, 30000, NULL, NULL, N'Đã giao', N'Hỏa tốc', N'Tài liệu');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 25, NULL, '0971561641', '0841696966', 7, N'Người Gửi 86', N'Người Nhận 86', N'Số 86 Đường XYZ, Quận ABC', 0, 80000, NULL, NULL, N'Đã giao', N'Hỏa tốc', N'Cồng kềnh');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 47, NULL, '0940558565', '0818801403', 45, N'Người Gửi 87', N'Người Nhận 87', N'Số 87 Đường XYZ, Quận ABC', 0, 40000, NULL, NULL, N'Đã giao', N'Nhanh', N'Bình thường');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 62, NULL, '0942724152', '0837478086', 40, N'Người Gửi 88', N'Người Nhận 88', N'Số 88 Đường XYZ, Quận ABC', 0, 10000, NULL, NULL, N'Đã giao', N'Tiết kiệm', N'Tài liệu');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 12, NULL, '0972371782', '0823709670', 50, N'Người Gửi 89', N'Người Nhận 89', N'Số 89 Đường XYZ, Quận ABC', 0, 80000, NULL, NULL, N'Đã giao', N'Hỏa tốc', N'Cồng kềnh');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 52, NULL, '0934209982', '0875377173', 59, N'Người Gửi 90', N'Người Nhận 90', N'Số 90 Đường XYZ, Quận ABC', 0, 15000, NULL, NULL, N'Đã giao', N'Nhanh', N'Tài liệu');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 28, NULL, '0935594827', '0847864721', 40, N'Người Gửi 91', N'Người Nhận 91', N'Số 91 Đường XYZ, Quận ABC', 0, 65000, NULL, NULL, N'Đã giao', N'Nhanh', N'Cồng kềnh');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 96, NULL, '0937127560', '0846947212', 11, N'Người Gửi 92', N'Người Nhận 92', N'Số 92 Đường XYZ, Quận ABC', 0, 35000, NULL, NULL, N'Đã giao', N'Tiết kiệm', N'Bình thường');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 74, NULL, '0947509539', '0873415377', 6, N'Người Gửi 93', N'Người Nhận 93', N'Số 93 Đường XYZ, Quận ABC', 0, 15000, NULL, NULL, N'Đã giao', N'Nhanh', N'Tài liệu');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 68, NULL, '0957294101', '0817105073', 8, N'Người Gửi 94', N'Người Nhận 94', N'Số 94 Đường XYZ, Quận ABC', 0, 60000, NULL, NULL, N'Hủy', N'Tiết kiệm', N'Cồng kềnh');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 21, NULL, '0918113830', '0895771624', 46, N'Người Gửi 95', N'Người Nhận 95', N'Số 95 Đường XYZ, Quận ABC', 0, 65000, NULL, NULL, N'Hủy', N'Nhanh', N'Cồng kềnh');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 96, NULL, '0946727136', '0866153393', 45, N'Người Gửi 96', N'Người Nhận 96', N'Số 96 Đường XYZ, Quận ABC', 0, 10000, NULL, NULL, N'Hủy', N'Tiết kiệm', N'Tài liệu');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 29, NULL, '0984875922', '0869851712', 35, N'Người Gửi 97', N'Người Nhận 97', N'Số 97 Đường XYZ, Quận ABC', 0, 80000, NULL, NULL, N'Hủy', N'Hỏa tốc', N'Cồng kềnh');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 42, NULL, '0992565614', '0819881322', 51, N'Người Gửi 98', N'Người Nhận 98', N'Số 98 Đường XYZ, Quận ABC', 0, 30000, NULL, NULL, N'Hủy', N'Hỏa tốc', N'Tài liệu');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 98, NULL, '0918734840', '0881504084', 12, N'Người Gửi 99', N'Người Nhận 99', N'Số 99 Đường XYZ, Quận ABC', 0, 80000, NULL, NULL, N'Hủy', N'Hỏa tốc', N'Cồng kềnh');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 90, NULL, '0947897731', '0843708658', 29, N'Người Gửi 100', N'Người Nhận 100', N'Số 100 Đường XYZ, Quận ABC', 0, 10000, NULL, NULL, N'Hủy', N'Tiết kiệm', N'Tài liệu');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 77, NULL, '0991727737', '0873854696', 55, N'Người Gửi 101', N'Người Nhận 101', N'Số 101 Đường XYZ, Quận ABC', 0, 65000, NULL, NULL, N'Hủy', N'Nhanh', N'Cồng kềnh');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 52, NULL, '0968737299', '0832385462', 2, N'Người Gửi 102', N'Người Nhận 102', N'Số 102 Đường XYZ, Quận ABC', 0, 60000, NULL, NULL, N'Hủy', N'Tiết kiệm', N'Cồng kềnh');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 97, NULL, '0997080946', '0849859716', 6, N'Người Gửi 103', N'Người Nhận 103', N'Số 103 Đường XYZ, Quận ABC', 0, 40000, NULL, NULL, N'Hủy', N'Nhanh', N'Bình thường');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 88, NULL, '0995806555', '0826848671', 12, N'Người Gửi 104', N'Người Nhận 104', N'Số 104 Đường XYZ, Quận ABC', 0, 80000, NULL, NULL, N'Hủy', N'Hỏa tốc', N'Cồng kềnh');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 53, NULL, '0929917378', '0884624867', 52, N'Người Gửi 105', N'Người Nhận 105', N'Số 105 Đường XYZ, Quận ABC', 0, 80000, NULL, NULL, N'Hủy', N'Hỏa tốc', N'Cồng kềnh');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 33, NULL, '0953609774', '0876603661', 3, N'Người Gửi 106', N'Người Nhận 106', N'Số 106 Đường XYZ, Quận ABC', 0, 60000, NULL, NULL, N'Hủy', N'Tiết kiệm', N'Cồng kềnh');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 91, NULL, '0988160796', '0861302914', 57, N'Người Gửi 107', N'Người Nhận 107', N'Số 107 Đường XYZ, Quận ABC', 0, 10000, NULL, NULL, N'Hủy', N'Tiết kiệm', N'Tài liệu');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 7, NULL, '0935584922', '0815815787', 57, N'Người Gửi 108', N'Người Nhận 108', N'Số 108 Đường XYZ, Quận ABC', 0, 65000, NULL, NULL, N'Hủy', N'Nhanh', N'Cồng kềnh');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 22, NULL, '0969979295', '0843704287', 46, N'Người Gửi 109', N'Người Nhận 109', N'Số 109 Đường XYZ, Quận ABC', 0, 10000, NULL, NULL, N'Hủy', N'Tiết kiệm', N'Tài liệu');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 9, NULL, '0979284628', '0821645116', 18, N'Người Gửi 110', N'Người Nhận 110', N'Số 110 Đường XYZ, Quận ABC', 0, 10000, NULL, NULL, N'Hủy', N'Tiết kiệm', N'Tài liệu');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 86, NULL, '0915734641', '0822347075', 51, N'Người Gửi 111', N'Người Nhận 111', N'Số 111 Đường XYZ, Quận ABC', 0, 80000, NULL, NULL, N'Hủy', N'Hỏa tốc', N'Cồng kềnh');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 74, NULL, '0912266349', '0885241743', 53, N'Người Gửi 112', N'Người Nhận 112', N'Số 112 Đường XYZ, Quận ABC', 0, 40000, NULL, NULL, N'Hủy', N'Nhanh', N'Bình thường');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 74, NULL, '0921722818', '0831391478', 57, N'Người Gửi 113', N'Người Nhận 113', N'Số 113 Đường XYZ, Quận ABC', 0, 65000, NULL, NULL, N'Hủy', N'Nhanh', N'Cồng kềnh');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 88, NULL, '0965624027', '0889896673', 45, N'Người Gửi 114', N'Người Nhận 114', N'Số 114 Đường XYZ, Quận ABC', 0, 40000, NULL, NULL, N'Hủy', N'Nhanh', N'Bình thường');
INSERT INTO DOANGIAOVAN.DONHANG(ID_DONHANG, ID_KHACHHANG, ID_NVGIAOHANG, SDTNGUOIGUI, SDTNGUOINHAN, ID_KHOTIEPNHAN, TENNGUOIGUI, TENNGUOINHAN, DIACHINHAN, TIENCOD, PHI, THOIGIANNHAN, THOIGIANDUKIEN, TRANGTHAI, DICHVU, LOAIHANGHOA) VALUES
(DOANGIAOVAN.SEQ_DONHANG.NEXTVAL, 2, NULL, '0939757600', '0832894404', 25, N'Người Gửi 115', N'Người Nhận 115', N'Số 115 Đường XYZ, Quận ABC', 0, 80000, NULL, NULL, N'Hủy', N'Hỏa tốc', N'Cồng kềnh');
COMMIT;
--them goi hang

ALTER SESSION SET NLS_TIMESTAMP_FORMAT = 'MM/DD/SYYYY HH24:MI:SS.FF';
INSERT INTO DOANGIAOVAN.GOIHANG(ID_GOIHANG, ID_KHOHANGGUI, ID_KHOHANGDEN, NGAYGUI, ID_NHANVIEN, SOLUONG, TRANGTHAI) VALUES
(DOANGIAOVAN.SEQ_GOIHANG.NEXTVAL, 1, 2, TO_DATE('06-02-2025 15:14:56', 'DD-MM-YYYY HH24:MI:SS'), 1, 2, N'Hoàn thành');
INSERT INTO DOANGIAOVAN.GOIHANG(ID_GOIHANG, ID_KHOHANGGUI, ID_KHOHANGDEN, NGAYGUI, ID_NHANVIEN, SOLUONG, TRANGTHAI) VALUES
(DOANGIAOVAN.SEQ_GOIHANG.NEXTVAL, 1, 2, TO_DATE('06-02-2025 15:15:22', 'DD-MM-YYYY HH24:MI:SS'), 1, 2, N'Hoàn thành');
INSERT INTO DOANGIAOVAN.GOIHANG(ID_GOIHANG, ID_KHOHANGGUI, ID_KHOHANGDEN, NGAYGUI, ID_NHANVIEN, SOLUONG, TRANGTHAI) VALUES
(DOANGIAOVAN.SEQ_GOIHANG.NEXTVAL, 1, 2, TO_DATE('06-02-2025 16:56:13', 'DD-MM-YYYY HH24:MI:SS'), 1, 2, N'Hoàn thành');
INSERT INTO DOANGIAOVAN.GOIHANG(ID_GOIHANG, ID_KHOHANGGUI, ID_KHOHANGDEN, NGAYGUI, ID_NHANVIEN, SOLUONG, TRANGTHAI) VALUES
(DOANGIAOVAN.SEQ_GOIHANG.NEXTVAL, 1, 1, TO_DATE('06-02-2025 17:16:03', 'DD-MM-YYYY HH24:MI:SS'), 1, 2, N'Hoàn thành');
INSERT INTO DOANGIAOVAN.GOIHANG(ID_GOIHANG, ID_KHOHANGGUI, ID_KHOHANGDEN, NGAYGUI, ID_NHANVIEN, SOLUONG, TRANGTHAI) VALUES
(DOANGIAOVAN.SEQ_GOIHANG.NEXTVAL, 1, 1, TO_DATE('06-02-2025 17:50:23', 'DD-MM-YYYY HH24:MI:SS'), 1, 1, N'Hoàn thành');
INSERT INTO DOANGIAOVAN.GOIHANG(ID_GOIHANG, ID_KHOHANGGUI, ID_KHOHANGDEN, NGAYGUI, ID_NHANVIEN, SOLUONG, TRANGTHAI) VALUES
(DOANGIAOVAN.SEQ_GOIHANG.NEXTVAL, 1, 2, TO_DATE('06-02-2025 20:50:16', 'DD-MM-YYYY HH24:MI:SS'), 1, 1, N'Hoàn thành');
INSERT INTO DOANGIAOVAN.GOIHANG(ID_GOIHANG, ID_KHOHANGGUI, ID_KHOHANGDEN, NGAYGUI, ID_NHANVIEN, SOLUONG, TRANGTHAI) VALUES
(DOANGIAOVAN.SEQ_GOIHANG.NEXTVAL, 1, 2, TO_DATE('06-03-2025 08:08:50', 'DD-MM-YYYY HH24:MI:SS'), 1, 2, N'Hoàn thành');
INSERT INTO DOANGIAOVAN.GOIHANG(ID_GOIHANG, ID_KHOHANGGUI, ID_KHOHANGDEN, NGAYGUI, ID_NHANVIEN, SOLUONG, TRANGTHAI) VALUES
(DOANGIAOVAN.SEQ_GOIHANG.NEXTVAL, 1, 1, TO_DATE('06-06-2025 20:41:51', 'DD-MM-YYYY HH24:MI:SS'), 1, 1, N'Hoàn thành');
COMMIT;

-- them baocaokho
INSERT INTO DOANGIAOVAN.BAOCAOKHO(ID_BAOCAOKHO, ID_NHANVIEN, KYBAOCAO, NGAYTAOBAOCAO, SOGOIHANGNHAP, SOGOIHANGXUAT) VALUES 
(DOANGIAOVAN.SEQ_BAOCAOKHO.NEXTVAL, 1, TO_DATE('05-01-2025', 'MM-DD-YYYY'), TO_DATE('05-02-2025', 'MM-DD-YYYY'), 120, 110); 
INSERT INTO DOANGIAOVAN.BAOCAOKHO(ID_BAOCAOKHO, ID_NHANVIEN, KYBAOCAO, NGAYTAOBAOCAO, SOGOIHANGNHAP, SOGOIHANGXUAT) VALUES 
(DOANGIAOVAN.SEQ_BAOCAOKHO.NEXTVAL, 2, TO_DATE('05-02-2025', 'MM-DD-YYYY'), TO_DATE('05-03-2025', 'MM-DD-YYYY'), 100, 90); 
INSERT INTO DOANGIAOVAN.BAOCAOKHO(ID_BAOCAOKHO, ID_NHANVIEN, KYBAOCAO, NGAYTAOBAOCAO, SOGOIHANGNHAP, SOGOIHANGXUAT) VALUES 
(DOANGIAOVAN.SEQ_BAOCAOKHO.NEXTVAL, 3, TO_DATE('05-03-2025', 'MM-DD-YYYY'), TO_DATE('05-04-2025', 'MM-DD-YYYY'), 130, 125); 
INSERT INTO DOANGIAOVAN.BAOCAOKHO(ID_BAOCAOKHO, ID_NHANVIEN, KYBAOCAO, NGAYTAOBAOCAO, SOGOIHANGNHAP, SOGOIHANGXUAT) VALUES 
(DOANGIAOVAN.SEQ_BAOCAOKHO.NEXTVAL, 4, TO_DATE('05-04-2025', 'MM-DD-YYYY'), TO_DATE('05-05-2025', 'MM-DD-YYYY'), 115, 105); 
INSERT INTO DOANGIAOVAN.BAOCAOKHO(ID_BAOCAOKHO, ID_NHANVIEN, KYBAOCAO, NGAYTAOBAOCAO, SOGOIHANGNHAP, SOGOIHANGXUAT) VALUES 
(DOANGIAOVAN.SEQ_BAOCAOKHO.NEXTVAL, 5, TO_DATE('05-05-2025', 'MM-DD-YYYY'), TO_DATE('05-06-2025', 'MM-DD-YYYY'), 140, 130); 
INSERT INTO DOANGIAOVAN.BAOCAOKHO(ID_BAOCAOKHO, ID_NHANVIEN, KYBAOCAO, NGAYTAOBAOCAO, SOGOIHANGNHAP, SOGOIHANGXUAT) VALUES 
(DOANGIAOVAN.SEQ_BAOCAOKHO.NEXTVAL, 6, TO_DATE('05-06-2025', 'MM-DD-YYYY'), TO_DATE('05-07-2025', 'MM-DD-YYYY'), 125, 115); 
INSERT INTO DOANGIAOVAN.BAOCAOKHO(ID_BAOCAOKHO, ID_NHANVIEN, KYBAOCAO, NGAYTAOBAOCAO, SOGOIHANGNHAP, SOGOIHANGXUAT) VALUES 
(DOANGIAOVAN.SEQ_BAOCAOKHO.NEXTVAL, 7, TO_DATE('05-07-2025', 'MM-DD-YYYY'), TO_DATE('05-08-2025', 'MM-DD-YYYY'), 110, 105); 
INSERT INTO DOANGIAOVAN.BAOCAOKHO(ID_BAOCAOKHO, ID_NHANVIEN, KYBAOCAO, NGAYTAOBAOCAO, SOGOIHANGNHAP, SOGOIHANGXUAT) VALUES 
(DOANGIAOVAN.SEQ_BAOCAOKHO.NEXTVAL, 8, TO_DATE('05-08-2025', 'MM-DD-YYYY'), TO_DATE('05-09-2025', 'MM-DD-YYYY'), 135, 120); 
INSERT INTO DOANGIAOVAN.BAOCAOKHO(ID_BAOCAOKHO, ID_NHANVIEN, KYBAOCAO, NGAYTAOBAOCAO, SOGOIHANGNHAP, SOGOIHANGXUAT) VALUES 
(DOANGIAOVAN.SEQ_BAOCAOKHO.NEXTVAL, 9, TO_DATE('05-09-2025', 'MM-DD-YYYY'), TO_DATE('05-10-2025', 'MM-DD-YYYY'), 95, 90); 
INSERT INTO DOANGIAOVAN.BAOCAOKHO(ID_BAOCAOKHO, ID_NHANVIEN, KYBAOCAO, NGAYTAOBAOCAO, SOGOIHANGNHAP, SOGOIHANGXUAT) VALUES 
(DOANGIAOVAN.SEQ_BAOCAOKHO.NEXTVAL, 10, TO_DATE('05-10-2025', 'MM-DD-YYYY'), TO_DATE('05-11-2025', 'MM-DD-YYYY'), 105, 100); 
INSERT INTO DOANGIAOVAN.BAOCAOKHO(ID_BAOCAOKHO, ID_NHANVIEN, KYBAOCAO, NGAYTAOBAOCAO, SOGOIHANGNHAP, SOGOIHANGXUAT) VALUES 
(DOANGIAOVAN.SEQ_BAOCAOKHO.NEXTVAL, 11, TO_DATE('05-11-2025', 'MM-DD-YYYY'), TO_DATE('05-12-2025', 'MM-DD-YYYY'), 150, 145); 
INSERT INTO DOANGIAOVAN.BAOCAOKHO(ID_BAOCAOKHO, ID_NHANVIEN, KYBAOCAO, NGAYTAOBAOCAO, SOGOIHANGNHAP, SOGOIHANGXUAT) VALUES 
(DOANGIAOVAN.SEQ_BAOCAOKHO.NEXTVAL, 12, TO_DATE('05-12-2025', 'MM-DD-YYYY'), TO_DATE('05-13-2025', 'MM-DD-YYYY'), 160, 155); 
INSERT INTO DOANGIAOVAN.BAOCAOKHO(ID_BAOCAOKHO, ID_NHANVIEN, KYBAOCAO, NGAYTAOBAOCAO, SOGOIHANGNHAP, SOGOIHANGXUAT) VALUES 
(DOANGIAOVAN.SEQ_BAOCAOKHO.NEXTVAL, 13, TO_DATE('05-13-2025', 'MM-DD-YYYY'), TO_DATE('05-14-2025', 'MM-DD-YYYY'), 145, 135); 
INSERT INTO DOANGIAOVAN.BAOCAOKHO(ID_BAOCAOKHO, ID_NHANVIEN, KYBAOCAO, NGAYTAOBAOCAO, SOGOIHANGNHAP, SOGOIHANGXUAT) VALUES 
(DOANGIAOVAN.SEQ_BAOCAOKHO.NEXTVAL, 14, TO_DATE('05-14-2025', 'MM-DD-YYYY'), TO_DATE('05-15-2025', 'MM-DD-YYYY'), 125, 120); 
INSERT INTO DOANGIAOVAN.BAOCAOKHO(ID_BAOCAOKHO, ID_NHANVIEN, KYBAOCAO, NGAYTAOBAOCAO, SOGOIHANGNHAP, SOGOIHANGXUAT) VALUES 
(DOANGIAOVAN.SEQ_BAOCAOKHO.NEXTVAL, 15, TO_DATE('05-15-2025', 'MM-DD-YYYY'), TO_DATE('05-16-2025', 'MM-DD-YYYY'), 135, 130); 
INSERT INTO DOANGIAOVAN.BAOCAOKHO(ID_BAOCAOKHO, ID_NHANVIEN, KYBAOCAO, NGAYTAOBAOCAO, SOGOIHANGNHAP, SOGOIHANGXUAT) VALUES 
(DOANGIAOVAN.SEQ_BAOCAOKHO.NEXTVAL, 16, TO_DATE('05-16-2025', 'MM-DD-YYYY'), TO_DATE('05-17-2025', 'MM-DD-YYYY'), 140, 138); 
INSERT INTO DOANGIAOVAN.BAOCAOKHO(ID_BAOCAOKHO, ID_NHANVIEN, KYBAOCAO, NGAYTAOBAOCAO, SOGOIHANGNHAP, SOGOIHANGXUAT) VALUES 
(DOANGIAOVAN.SEQ_BAOCAOKHO.NEXTVAL, 17, TO_DATE('05-17-2025', 'MM-DD-YYYY'), TO_DATE('05-18-2025', 'MM-DD-YYYY'), 155, 150); 
INSERT INTO DOANGIAOVAN.BAOCAOKHO(ID_BAOCAOKHO, ID_NHANVIEN, KYBAOCAO, NGAYTAOBAOCAO, SOGOIHANGNHAP, SOGOIHANGXUAT) VALUES 
(DOANGIAOVAN.SEQ_BAOCAOKHO.NEXTVAL, 18, TO_DATE('05-18-2025', 'MM-DD-YYYY'), TO_DATE('05-19-2025', 'MM-DD-YYYY'), 130, 125); 
INSERT INTO DOANGIAOVAN.BAOCAOKHO(ID_BAOCAOKHO, ID_NHANVIEN, KYBAOCAO, NGAYTAOBAOCAO, SOGOIHANGNHAP, SOGOIHANGXUAT) VALUES 
(DOANGIAOVAN.SEQ_BAOCAOKHO.NEXTVAL, 19, TO_DATE('05-19-2025', 'MM-DD-YYYY'), TO_DATE('05-20-2025', 'MM-DD-YYYY'), 120, 118); 
INSERT INTO DOANGIAOVAN.BAOCAOKHO(ID_BAOCAOKHO, ID_NHANVIEN, KYBAOCAO, NGAYTAOBAOCAO, SOGOIHANGNHAP, SOGOIHANGXUAT) VALUES 
(DOANGIAOVAN.SEQ_BAOCAOKHO.NEXTVAL, 20, TO_DATE('05-20-2025', 'MM-DD-YYYY'), TO_DATE('05-21-2025', 'MM-DD-YYYY'), 140, 135);
COMMIT;
-- insert BAOCAOGIAOHANG
INSERT INTO DOANGIAOVAN.BAOCAOGIAOHANG(ID_BAOCAOGIAOHANG, ID_NVGIAOHANG, TONGDONHANGDAGIAO, TONGTIENCOD, NGAYKHOITAO, TONGDHGIAOTHATBAI) VALUES
(DOANGIAOVAN.SEQ_BAOCAOGIAOHANG.NEXTVAL, 1, 120, 2500000, TO_DATE('06-02-2025', 'MM-DD-YYYY'), 5);
INSERT INTO DOANGIAOVAN.BAOCAOGIAOHANG(ID_BAOCAOGIAOHANG, ID_NVGIAOHANG, TONGDONHANGDAGIAO, TONGTIENCOD, NGAYKHOITAO, TONGDHGIAOTHATBAI) VALUES
(DOANGIAOVAN.SEQ_BAOCAOGIAOHANG.NEXTVAL, 2, 98, 1875000, TO_DATE('06-02-2025', 'MM-DD-YYYY'), 3);
INSERT INTO DOANGIAOVAN.BAOCAOGIAOHANG(ID_BAOCAOGIAOHANG, ID_NVGIAOHANG, TONGDONHANGDAGIAO, TONGTIENCOD, NGAYKHOITAO, TONGDHGIAOTHATBAI) VALUES
(DOANGIAOVAN.SEQ_BAOCAOGIAOHANG.NEXTVAL, 3, 110, 2040000, TO_DATE('06-02-2025', 'MM-DD-YYYY'), 4);
INSERT INTO DOANGIAOVAN.BAOCAOGIAOHANG(ID_BAOCAOGIAOHANG, ID_NVGIAOHANG, TONGDONHANGDAGIAO, TONGTIENCOD, NGAYKHOITAO, TONGDHGIAOTHATBAI) VALUES
(DOANGIAOVAN.SEQ_BAOCAOGIAOHANG.NEXTVAL, 4, 130, 2800000, TO_DATE('06-02-2025', 'MM-DD-YYYY'), 2);
INSERT INTO DOANGIAOVAN.BAOCAOGIAOHANG(ID_BAOCAOGIAOHANG, ID_NVGIAOHANG, TONGDONHANGDAGIAO, TONGTIENCOD, NGAYKHOITAO, TONGDHGIAOTHATBAI) VALUES
(DOANGIAOVAN.SEQ_BAOCAOGIAOHANG.NEXTVAL, 5, 75, 1520000, TO_DATE('06-02-2025', 'MM-DD-YYYY'), 6);
INSERT INTO DOANGIAOVAN.BAOCAOGIAOHANG(ID_BAOCAOGIAOHANG, ID_NVGIAOHANG, TONGDONHANGDAGIAO, TONGTIENCOD, NGAYKHOITAO, TONGDHGIAOTHATBAI) VALUES
(DOANGIAOVAN.SEQ_BAOCAOGIAOHANG.NEXTVAL, 6, 89, 1790000, TO_DATE('06-02-2025', 'MM-DD-YYYY'), 4);
INSERT INTO DOANGIAOVAN.BAOCAOGIAOHANG(ID_BAOCAOGIAOHANG, ID_NVGIAOHANG, TONGDONHANGDAGIAO, TONGTIENCOD, NGAYKHOITAO, TONGDHGIAOTHATBAI) VALUES
(DOANGIAOVAN.SEQ_BAOCAOGIAOHANG.NEXTVAL, 7, 102, 2100000, TO_DATE('06-02-2025', 'MM-DD-YYYY'), 1);
INSERT INTO DOANGIAOVAN.BAOCAOGIAOHANG(ID_BAOCAOGIAOHANG, ID_NVGIAOHANG, TONGDONHANGDAGIAO, TONGTIENCOD, NGAYKHOITAO, TONGDHGIAOTHATBAI) VALUES
(DOANGIAOVAN.SEQ_BAOCAOGIAOHANG.NEXTVAL, 8, 95, 1950000, TO_DATE('06-02-2025', 'MM-DD-YYYY'), 3);
INSERT INTO DOANGIAOVAN.BAOCAOGIAOHANG(ID_BAOCAOGIAOHANG, ID_NVGIAOHANG, TONGDONHANGDAGIAO, TONGTIENCOD, NGAYKHOITAO, TONGDHGIAOTHATBAI) VALUES
(DOANGIAOVAN.SEQ_BAOCAOGIAOHANG.NEXTVAL, 9, 115, 2300000, TO_DATE('06-02-2025', 'MM-DD-YYYY'), 2);
INSERT INTO DOANGIAOVAN.BAOCAOGIAOHANG(ID_BAOCAOGIAOHANG, ID_NVGIAOHANG, TONGDONHANGDAGIAO, TONGTIENCOD, NGAYKHOITAO, TONGDHGIAOTHATBAI) VALUES
(DOANGIAOVAN.SEQ_BAOCAOGIAOHANG.NEXTVAL, 10, 100, 2000000, TO_DATE('06-02-2025', 'MM-DD-YYYY'), 3);
INSERT INTO DOANGIAOVAN.BAOCAOGIAOHANG(ID_BAOCAOGIAOHANG, ID_NVGIAOHANG, TONGDONHANGDAGIAO, TONGTIENCOD, NGAYKHOITAO, TONGDHGIAOTHATBAI) VALUES
(DOANGIAOVAN.SEQ_BAOCAOGIAOHANG.NEXTVAL, 11, 108, 2150000, TO_DATE('06-02-2025', 'MM-DD-YYYY'), 2);
INSERT INTO DOANGIAOVAN.BAOCAOGIAOHANG(ID_BAOCAOGIAOHANG, ID_NVGIAOHANG, TONGDONHANGDAGIAO, TONGTIENCOD, NGAYKHOITAO, TONGDHGIAOTHATBAI) VALUES
(DOANGIAOVAN.SEQ_BAOCAOGIAOHANG.NEXTVAL, 12, 92, 1840000, TO_DATE('06-02-2025', 'MM-DD-YYYY'), 4);
INSERT INTO DOANGIAOVAN.BAOCAOGIAOHANG(ID_BAOCAOGIAOHANG, ID_NVGIAOHANG, TONGDONHANGDAGIAO, TONGTIENCOD, NGAYKHOITAO, TONGDHGIAOTHATBAI) VALUES
(DOANGIAOVAN.SEQ_BAOCAOGIAOHANG.NEXTVAL, 13, 125, 2600000, TO_DATE('06-02-2025', 'MM-DD-YYYY'), 2);
INSERT INTO DOANGIAOVAN.BAOCAOGIAOHANG(ID_BAOCAOGIAOHANG, ID_NVGIAOHANG, TONGDONHANGDAGIAO, TONGTIENCOD, NGAYKHOITAO, TONGDHGIAOTHATBAI) VALUES
(DOANGIAOVAN.SEQ_BAOCAOGIAOHANG.NEXTVAL, 14, 86, 1720000, TO_DATE('06-02-2025', 'MM-DD-YYYY'), 5);
INSERT INTO DOANGIAOVAN.BAOCAOGIAOHANG(ID_BAOCAOGIAOHANG, ID_NVGIAOHANG, TONGDONHANGDAGIAO, TONGTIENCOD, NGAYKHOITAO, TONGDHGIAOTHATBAI) VALUES
(DOANGIAOVAN.SEQ_BAOCAOGIAOHANG.NEXTVAL, 15, 77, 1550000, TO_DATE('06-02-2025', 'MM-DD-YYYY'), 6);
INSERT INTO DOANGIAOVAN.BAOCAOGIAOHANG(ID_BAOCAOGIAOHANG, ID_NVGIAOHANG, TONGDONHANGDAGIAO, TONGTIENCOD, NGAYKHOITAO, TONGDHGIAOTHATBAI) VALUES
(DOANGIAOVAN.SEQ_BAOCAOGIAOHANG.NEXTVAL, 16, 135, 2900000, TO_DATE('06-02-2025', 'MM-DD-YYYY'), 1);
INSERT INTO DOANGIAOVAN.BAOCAOGIAOHANG(ID_BAOCAOGIAOHANG, ID_NVGIAOHANG, TONGDONHANGDAGIAO, TONGTIENCOD, NGAYKHOITAO, TONGDHGIAOTHATBAI) VALUES
(DOANGIAOVAN.SEQ_BAOCAOGIAOHANG.NEXTVAL, 17, 90, 1800000, TO_DATE('06-02-2025', 'MM-DD-YYYY'), 3);
INSERT INTO DOANGIAOVAN.BAOCAOGIAOHANG(ID_BAOCAOGIAOHANG, ID_NVGIAOHANG, TONGDONHANGDAGIAO, TONGTIENCOD, NGAYKHOITAO, TONGDHGIAOTHATBAI) VALUES
(DOANGIAOVAN.SEQ_BAOCAOGIAOHANG.NEXTVAL, 18, 122, 2450000, TO_DATE('06-02-2025', 'MM-DD-YYYY'), 2);
INSERT INTO DOANGIAOVAN.BAOCAOGIAOHANG(ID_BAOCAOGIAOHANG, ID_NVGIAOHANG, TONGDONHANGDAGIAO, TONGTIENCOD, NGAYKHOITAO, TONGDHGIAOTHATBAI) VALUES
(DOANGIAOVAN.SEQ_BAOCAOGIAOHANG.NEXTVAL, 19, 97, 1930000, TO_DATE('06-02-2025', 'MM-DD-YYYY'), 4);
INSERT INTO DOANGIAOVAN.BAOCAOGIAOHANG(ID_BAOCAOGIAOHANG, ID_NVGIAOHANG, TONGDONHANGDAGIAO, TONGTIENCOD, NGAYKHOITAO, TONGDHGIAOTHATBAI) VALUES
(DOANGIAOVAN.SEQ_BAOCAOGIAOHANG.NEXTVAL, 20, 113, 2250000, TO_DATE('06-02-2025', 'MM-DD-YYYY'), 3);

COMMIT;
-- them danhgia
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 1, 1, N'Đơn hàng 1 giao đúng hẹn, hài lòng.', 3, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 2, 1, N'Đơn hàng 2 giao đúng hẹn, hài lòng.', 2, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 3, 21, N'Đơn hàng 3 giao đúng hẹn, hài lòng.', 1, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 4, 21, N'Đơn hàng 4 giao đúng hẹn, hài lòng.', 5, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 5, 21, N'Đơn hàng 5 giao đúng hẹn, hài lòng.', 4, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 8, 26, N'Đơn hàng 8 giao đúng hẹn, hài lòng.', 2, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 9, 10, N'Đơn hàng 9 giao đúng hẹn, hài lòng.', 5, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 10, 69, N'Đơn hàng 10 giao đúng hẹn, hài lòng.', 3, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 11, 77, N'Đơn hàng 11 giao đúng hẹn, hài lòng.', 2, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 12, 3, N'Đơn hàng 12 giao đúng hẹn, hài lòng.', 5, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 13, 57, N'Đơn hàng 13 giao đúng hẹn, hài lòng.', 3, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 14, 55, N'Đơn hàng 14 giao đúng hẹn, hài lòng.', 5, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 15, 27, N'Đơn hàng 15 giao đúng hẹn, hài lòng.', 2, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 16, 68, N'Đơn hàng 16 giao đúng hẹn, hài lòng.', 4, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 17, 17, N'Đơn hàng 17 giao đúng hẹn, hài lòng.', 1, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 18, 18, N'Đơn hàng 18 giao đúng hẹn, hài lòng.', 5, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 19, 19, N'Đơn hàng 19 giao đúng hẹn, hài lòng.', 2, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 20, 20, N'Đơn hàng 20 giao đúng hẹn, hài lòng.', 5, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 21, 56, N'Đơn hàng 21 giao đúng hẹn, hài lòng.', 1, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 22, 54, N'Đơn hàng 22 giao đúng hẹn, hài lòng.', 2, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 23, 96, N'Đơn hàng 23 giao đúng hẹn, hài lòng.', 4, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 24, 80, N'Đơn hàng 24 giao đúng hẹn, hài lòng.', 2, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 25, 20, N'Đơn hàng 25 giao đúng hẹn, hài lòng.', 1, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 26, 83, N'Đơn hàng 26 giao đúng hẹn, hài lòng.', 2, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 27, 58, N'Đơn hàng 27 giao đúng hẹn, hài lòng.', 2, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 28, 38, N'Đơn hàng 28 giao đúng hẹn, hài lòng.', 5, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 29, 82, N'Đơn hàng 29 giao đúng hẹn, hài lòng.', 4, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 30, 95, N'Đơn hàng 30 giao đúng hẹn, hài lòng.', 1, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 31, 59, N'Đơn hàng 31 giao đúng hẹn, hài lòng.', 5, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 32, 48, N'Đơn hàng 32 giao đúng hẹn, hài lòng.', 3, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 33, 12, N'Đơn hàng 33 giao đúng hẹn, hài lòng.', 3, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 34, 4, N'Đơn hàng 34 giao đúng hẹn, hài lòng.', 4, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 35, 29, N'Đơn hàng 35 giao đúng hẹn, hài lòng.', 2, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 36, 47, N'Đơn hàng 36 giao đúng hẹn, hài lòng.', 2, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 37, 92, N'Đơn hàng 37 giao đúng hẹn, hài lòng.', 1, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 38, 84, N'Đơn hàng 38 giao đúng hẹn, hài lòng.', 1, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 39, 71, N'Đơn hàng 39 giao đúng hẹn, hài lòng.', 5, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 40, 95, N'Đơn hàng 40 giao đúng hẹn, hài lòng.', 3, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 41, 18, N'Đơn hàng 41 giao đúng hẹn, hài lòng.', 2, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 42, 95, N'Đơn hàng 42 giao đúng hẹn, hài lòng.', 4, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 43, 98, N'Đơn hàng 43 giao đúng hẹn, hài lòng.', 4, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 44, 52, N'Đơn hàng 44 giao đúng hẹn, hài lòng.', 1, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 45, 13, N'Đơn hàng 45 giao đúng hẹn, hài lòng.', 3, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 46, 90, N'Đơn hàng 46 giao đúng hẹn, hài lòng.', 4, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 47, 85, N'Đơn hàng 47 giao đúng hẹn, hài lòng.', 3, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 48, 53, N'Đơn hàng 48 giao đúng hẹn, hài lòng.', 4, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 49, 55, N'Đơn hàng 49 giao đúng hẹn, hài lòng.', 4, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 50, 86, N'Đơn hàng 50 giao đúng hẹn, hài lòng.', 1, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 51, 72, N'Đơn hàng 51 giao đúng hẹn, hài lòng.', 3, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 52, 41, N'Đơn hàng 52 giao đúng hẹn, hài lòng.', 5, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 53, 27, N'Đơn hàng 53 giao đúng hẹn, hài lòng.', 4, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 54, 13, N'Đơn hàng 54 giao đúng hẹn, hài lòng.', 2, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 55, 74, N'Đơn hàng 55 giao đúng hẹn, hài lòng.', 3, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 56, 36, N'Đơn hàng 56 giao đúng hẹn, hài lòng.', 1, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 57, 50, N'Đơn hàng 57 giao đúng hẹn, hài lòng.', 5, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 58, 72, N'Đơn hàng 58 giao đúng hẹn, hài lòng.', 3, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 59, 61, N'Đơn hàng 59 giao đúng hẹn, hài lòng.', 5, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 60, 91, N'Đơn hàng 60 giao đúng hẹn, hài lòng.', 4, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 61, 39, N'Đơn hàng 61 giao đúng hẹn, hài lòng.', 5, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 62, 12, N'Đơn hàng 62 giao đúng hẹn, hài lòng.', 5, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 63, 30, N'Đơn hàng 63 giao đúng hẹn, hài lòng.', 4, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 64, 84, N'Đơn hàng 64 giao đúng hẹn, hài lòng.', 2, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 65, 8, N'Đơn hàng 65 giao đúng hẹn, hài lòng.', 1, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 66, 53, N'Đơn hàng 66 giao đúng hẹn, hài lòng.', 4, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 67, 97, N'Đơn hàng 67 giao đúng hẹn, hài lòng.', 1, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 68, 57, N'Đơn hàng 68 giao đúng hẹn, hài lòng.', 3, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 69, 34, N'Đơn hàng 69 giao đúng hẹn, hài lòng.', 5, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 70, 60, N'Đơn hàng 70 giao đúng hẹn, hài lòng.', 2, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 71, 77, N'Đơn hàng 71 giao đúng hẹn, hài lòng.', 1, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 72, 77, N'Đơn hàng 72 giao đúng hẹn, hài lòng.', 3, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 73, 95, N'Đơn hàng 73 giao đúng hẹn, hài lòng.', 3, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 74, 30, N'Đơn hàng 74 giao đúng hẹn, hài lòng.', 5, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 75, 87, N'Đơn hàng 75 giao đúng hẹn, hài lòng.', 1, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 76, 14, N'Đơn hàng 76 giao đúng hẹn, hài lòng.', 4, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 77, 59, N'Đơn hàng 77 giao đúng hẹn, hài lòng.', 1, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 78, 15, N'Đơn hàng 78 giao đúng hẹn, hài lòng.', 2, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 79, 25, N'Đơn hàng 79 giao đúng hẹn, hài lòng.', 5, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 80, 3, N'Đơn hàng 80 giao đúng hẹn, hài lòng.', 5, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 81, 23, N'Đơn hàng 81 giao đúng hẹn, hài lòng.', 2, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 82, 80, N'Đơn hàng 82 giao đúng hẹn, hài lòng.', 5, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 83, 34, N'Đơn hàng 83 giao đúng hẹn, hài lòng.', 4, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 84, 15, N'Đơn hàng 84 giao đúng hẹn, hài lòng.', 3, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 85, 34, N'Đơn hàng 85 giao đúng hẹn, hài lòng.', 2, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 86, 96, N'Đơn hàng 86 giao đúng hẹn, hài lòng.', 2, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
INSERT INTO DOANGIAOVAN.DANHGIA(ID_DANHGIA, ID_DONHANG, ID_KHACHHANG, NOIDUNGDANHGIA, DIEMDANHGIA, NGAYTAO) VALUES
(DOANGIAOVAN.SEQ_DANHGIA.NEXTVAL, 87, 37, N'Đơn hàng 87 giao đúng hẹn, hài lòng.', 4, TO_DATE('06-01-2025', 'MM-DD-YYYY'));
COMMIT;