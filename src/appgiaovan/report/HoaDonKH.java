/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package appgiaovan.report;

/**
 *
 * @author ASUS
 */
import java.io.File;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.awt.Desktop; // Để mở file PDF sau khi tạo [cite: 95]

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

import java.io.FileOutputStream;
import java.sql.*;
import java.text.SimpleDateFormat;
import appgiaovan.ConnectDB.ConnectionUtils;

public class HoaDonKH {

    private String filePath;

    public String getFilePath() {
        return filePath;
    }
    
    public void XuatHD(int idDonHang) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = ConnectionUtils.getMyConnection();

            // Truy vấn đơn hàng
            String query = "SELECT * FROM DONHANG WHERE id_donhang = ?";
            stmt = conn.prepareStatement(query);
            stmt.setInt(1, idDonHang);
            rs = stmt.executeQuery();

            if (rs.next()) {
                String tenNguoiGui = rs.getString("TenNguoiGui");
                String sdtNguoiGui = rs.getString("TenNguoiNhan");
                String tenNguoiNhan = rs.getString("TenNguoiNhan");
                String sdtNguoiNhan = rs.getString("SDTNguoiNhan");
                String diaChiNhan = rs.getString("DiaChiNhan");
                Timestamp thoiGianTao = rs.getTimestamp("ThoiGianTao");
                double tienCod = rs.getDouble("TienCOD");
                double phi = rs.getDouble("Phi");
                String loaiHang = rs.getString("LoaiHangHoa");
                String dichVu = rs.getString("DichVu");

                Document document = new Document(PageSize.A6, 20, 20, 20, 20);
                filePath = "exportpdf" + "/hoadon_" + idDonHang + ".pdf";
                PdfWriter writer = PdfWriter.getInstance(document, new FileOutputStream(filePath));

                document.open();

                BaseFont bf = BaseFont.createFont("src/VietFontsWeb1_ttf/vuTimes.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
                Font font = new Font(bf, 12);
                Font titleFont = new Font(bf, 16, Font.BOLD);
                Font normalFont = new Font(bf, 11, Font.NORMAL);
                Font boldFont = new Font(bf, 11, Font.BOLD);

                Paragraph title = new Paragraph("HÓA ĐƠN", titleFont);
                title.setAlignment(Element.ALIGN_CENTER);
                document.add(title);
                
                Paragraph gap = new Paragraph();
                gap.setSpacingAfter(20f);
                document.add(gap);
                
                Barcode128 barcode = new Barcode128();
                barcode.setCode(String.valueOf(idDonHang));
                barcode.setCodeType(Barcode128.CODE128);

                Image barcodeImage = barcode.createImageWithBarcode(writer.getDirectContent(), null, null);
                barcodeImage.setAlignment(Image.ALIGN_CENTER);
                document.add(barcodeImage);

                Paragraph orderCode = new Paragraph("Mã đơn hàng: " + idDonHang, boldFont);
                orderCode.setAlignment(Element.ALIGN_CENTER);
                document.add(orderCode);
                document.add(Chunk.NEWLINE);

                PdfPTable table = new PdfPTable(2);
                table.setWidthPercentage(100);
                table.setWidths(new float[]{1, 1});
                table.addCell(new PdfPCell(new Phrase("Người gửi", boldFont)));
                table.addCell(new PdfPCell(new Phrase("Người nhận", boldFont)));

                PdfPCell cellSender = new PdfPCell();
                cellSender.addElement(new Phrase("Tên: " + tenNguoiGui, normalFont));
                cellSender.addElement(new Phrase("SĐT: " + sdtNguoiGui, normalFont));
                table.addCell(cellSender);

                PdfPCell cellReceiver = new PdfPCell();
                cellReceiver.addElement(new Phrase("Tên: " + tenNguoiNhan, normalFont));
                cellReceiver.addElement(new Phrase("SĐT: " + sdtNguoiNhan, normalFont));
                cellReceiver.addElement(new Phrase("Địa chỉ: " + diaChiNhan, normalFont));
                table.addCell(cellReceiver);

                document.add(table);

                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
                PdfPTable infoTable = new PdfPTable(2);
                infoTable.setWidthPercentage(100);
                infoTable.setSpacingBefore(10);

                infoTable.addCell(new Phrase("Thời gian tạo:", normalFont));
                infoTable.addCell(new Phrase(sdf.format(thoiGianTao), normalFont));
                infoTable.addCell(new Phrase("Loại hàng hóa:", normalFont));
                infoTable.addCell(new Phrase(loaiHang, normalFont));
                infoTable.addCell(new Phrase("Loại dịch vụ:", normalFont));
                infoTable.addCell(new Phrase(dichVu, normalFont));
                infoTable.addCell(new Phrase("Phí:", normalFont));
                infoTable.addCell(new Phrase(String.format("%,.0f đ", phi), normalFont));
                infoTable.addCell(new Phrase("Tiền COD:", normalFont));
                infoTable.addCell(new Phrase(String.format("%,.0f đ", tienCod), normalFont));
                
                
                document.add(infoTable);
                BarcodeQRCode qrcode = new BarcodeQRCode("ID: " + idDonHang, 80, 80, null);
                Image qrImage = qrcode.getImage();
                qrImage.setAbsolutePosition(document.right() - 70, document.top() - 90);
                document.add(qrImage);
                document.close();
               

                System.out.println("Đã xuất hoadon_" + idDonHang + ".pdf");
                File pdfFile = new File(filePath);
                if (pdfFile.exists()) {
                    if (Desktop.isDesktopSupported()) {
                        Desktop.getDesktop().open(pdfFile);
                    }
                }
            } else {
                System.out.println("Không tìm thấy đơn hàng với ID: " + idDonHang);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (stmt != null) stmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}
    

   
