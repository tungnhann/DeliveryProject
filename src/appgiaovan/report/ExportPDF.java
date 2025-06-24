/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package appgiaovan.report;

import appgiaovan.Entity.TK_DanhGia;
import appgiaovan.Entity.TK_DonHang;
import java.io.ByteArrayOutputStream;
import java.io.*;
import java.io.FileOutputStream;
import javax.swing.JFileChooser;
import org.jfree.chart.JFreeChart;
import com.itextpdf.text.Document;
import com.itextpdf.text.Font;
import com.itextpdf.text.Image;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.text.*;
import com.itextpdf.text.Element;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfPTable;
import java.awt.image.BufferedImage;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.imageio.ImageIO;
import javax.swing.JOptionPane;

/**
 *
 * @author HP
 */
public class ExportPDF {

    public static void exportDoanhThu(JFreeChart chart, String thangBaoCao, double tongDoanhThu) {
        try {
            JFileChooser fileChooser = new JFileChooser();
            fileChooser.setDialogTitle("Lưu báo cáo PDF");
            fileChooser.setSelectedFile(new File("bao_cao_doanh_thu.pdf"));

            int userSelection = fileChooser.showSaveDialog(null);
            if (userSelection == JFileChooser.APPROVE_OPTION) {
                File fileToSave = fileChooser.getSelectedFile();

                Document document = new Document() {
                };
                PdfWriter writer = PdfWriter.getInstance(document, new FileOutputStream(fileToSave));
                document.open();

                String fontPath = "src/VietFontsWeb1_ttf/times.ttf"; // hoặc "C:/path/to/timesnewroman.ttf"
                BaseFont baseFont = BaseFont.createFont(fontPath, BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
                Font titleFont = new Font(baseFont, 16, Font.BOLD);
                Font normalFont = new Font(baseFont, 12);

                // ========== MỤC 1 ==========
                Paragraph title1 = new Paragraph("1. Tổng quan doanh thu:", titleFont);
                document.add(title1);
                Date ngayBaoCao = new Date();
                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                String formattedDate = formatNgay(ngayBaoCao);

                document.add(new Paragraph("Ngày báo cáo: " + formattedDate, normalFont));

                document.add(new Paragraph("Tháng báo cáo: " + thangBaoCao, normalFont));

                document.add(new Paragraph(String.format("Tổng doanh thu: %.2f triệu VND", tongDoanhThu), normalFont));
                document.add(Chunk.NEWLINE);

                // ========== MỤC 2 ==========
                Paragraph title2 = new Paragraph("2. Biểu đồ doanh thu", titleFont);
                document.add(title2);

                BufferedImage chartImage = chart.createBufferedImage(500, 300);
                ByteArrayOutputStream baos = new ByteArrayOutputStream();
                ImageIO.write(chartImage, "png", baos);
                Image chartImg = Image.getInstance(baos.toByteArray());
                chartImg.setAlignment(Image.ALIGN_CENTER);
                document.add(chartImg);

                document.close();
                writer.close();

                JOptionPane.showMessageDialog(null, "Xuất PDF thành công!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            JOptionPane.showMessageDialog(null, "Lỗi khi xuất PDF: " + e.getMessage());
        }
    }

    public static void exportDanhGia(TK_DanhGia danhGia, JFreeChart pieChart) throws Exception {
        JFileChooser fileChooser = new JFileChooser();
        fileChooser.setDialogTitle("Lưu báo cáo PDF");
        fileChooser.setSelectedFile(new File("bao_cao_danh_gia.pdf"));

        int userSelection = fileChooser.showSaveDialog(null);
        if (userSelection == JFileChooser.APPROVE_OPTION) {
            File fileToSave = fileChooser.getSelectedFile();

            Document document = new Document() {
            };
            PdfWriter writer = PdfWriter.getInstance(document, new FileOutputStream(fileToSave));
            document.open();

            // Font
            String fontPath = "src/VietFontsWeb1_ttf/times.ttf"; // hoặc "C:/path/to/timesnewroman.ttf"
            BaseFont baseFont = BaseFont.createFont(fontPath, BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
            Font titleFont = new Font(baseFont, 16, Font.BOLD);
            Font normalFont = new Font(baseFont, 12);

            Paragraph title = new Paragraph("BÁO CÁO THỐNG KÊ ĐÁNH GIÁ", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            title.setSpacingAfter(20f);
            document.add(title);

            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            document.add(new Paragraph("Ngày báo cáo: " + sdf.format(danhGia.getNgay()), normalFont));
            document.add(new Paragraph("Tổng lượt đánh giá: " + danhGia.getTongLuotDanhGia(), normalFont));
            document.add(Chunk.NEWLINE);

            PdfPTable table = new PdfPTable(2);
            table.setWidthPercentage(80);
            table.setSpacingBefore(10f);

            table.addCell(new Phrase("Hạng sao", normalFont));
            table.addCell(new Phrase("Số lượng", normalFont));
            table.addCell(new Phrase("1 sao", normalFont));
            table.addCell(new Phrase(String.valueOf(danhGia.getSoLuong1Sao()), normalFont));
            table.addCell(new Phrase("2 sao", normalFont));
            table.addCell(new Phrase(String.valueOf(danhGia.getSoLuong2Sao()), normalFont));
            table.addCell(new Phrase("3 sao", normalFont));
            table.addCell(new Phrase(String.valueOf(danhGia.getSoLuong3Sao()), normalFont));
            table.addCell(new Phrase("4 sao", normalFont));
            table.addCell(new Phrase(String.valueOf(danhGia.getSoLuong4Sao()), normalFont));
            table.addCell(new Phrase("5 sao", normalFont));
            table.addCell(new Phrase(String.valueOf(danhGia.getSoLuong5Sao()), normalFont));

            document.add(table);
            document.add(Chunk.NEWLINE);
            
            int width = 500, height = 300;
            BufferedImage chartImage = pieChart.createBufferedImage(width, height);
            ByteArrayOutputStream chartOut = new ByteArrayOutputStream();
            ImageIO.write(chartImage, "png", chartOut);
            Image chartImg = Image.getInstance(chartOut.toByteArray());

            chartImg.setAlignment(Image.ALIGN_CENTER);
            chartImg.scaleToFit(500, 300); 
            document.add(chartImg);

            document.close();
            writer.close();
            JOptionPane.showMessageDialog(null, "Xuất PDF thành công!");

        }

    }

    public static void exportDonHang(java.util.List<TK_DonHang> list, JFreeChart barChart) throws Exception {
        JFileChooser fileChooser = new JFileChooser();
        fileChooser.setDialogTitle("Lưu báo cáo PDF");
        fileChooser.setSelectedFile(new File("bao_cao_don_hang.pdf"));

        int userSelection = fileChooser.showSaveDialog(null);
        if (userSelection == JFileChooser.APPROVE_OPTION) {
            File fileToSave = fileChooser.getSelectedFile();

            Document document = new Document() {
            };
            PdfWriter writer = PdfWriter.getInstance(document, new FileOutputStream(fileToSave));
            document.open();

            // Font
            String fontPath = "src/VietFontsWeb1_ttf/times.ttf"; // hoặc "C:/path/to/timesnewroman.ttf"
            BaseFont baseFont = BaseFont.createFont(fontPath, BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
            Font titleFont = new Font(baseFont, 16, Font.BOLD);
            Font normalFont = new Font(baseFont, 12);

            Paragraph title = new Paragraph("BÁO CÁO THỐNG KÊ ĐƠN HÀNG", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            title.setSpacingAfter(20f);
            document.add(title);

            PdfPTable table = new PdfPTable(5);
            table.setWidthPercentage(100);
            table.setSpacingBefore(10f);

            table.addCell(new Phrase("Ngày", normalFont));
            table.addCell(new Phrase("Tổng đơn", normalFont));
            table.addCell(new Phrase("Đã giao", normalFont));
            table.addCell(new Phrase("Thất bại", normalFont));
            table.addCell(new Phrase("Đã huỷ", normalFont));

            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            for (TK_DonHang tk : list) {
                table.addCell(new Phrase(sdf.format(tk.getNgay()), normalFont));
                table.addCell(new Phrase(String.valueOf(tk.getTongSoDonHang()), normalFont));
                table.addCell(new Phrase(String.valueOf(tk.getSoLuongDaGiao()), normalFont));
                table.addCell(new Phrase(String.valueOf(tk.getSoLuongThatBai()), normalFont));
                table.addCell(new Phrase(String.valueOf(tk.getSoLuongDaHuy()), normalFont));
            }

            document.add(table);
            document.add(Chunk.NEWLINE);

            // Xuất biểu đồ sang ảnh và nhúng vào PDF
            int width = 600, height = 400;
            BufferedImage chartImage = barChart.createBufferedImage(width, height);
            ByteArrayOutputStream chartOut = new ByteArrayOutputStream();
            ImageIO.write(chartImage, "png", chartOut);
            Image chartImg = Image.getInstance(chartOut.toByteArray());

            chartImg.setAlignment(Image.ALIGN_CENTER);
            chartImg.scaleToFit(500, 350);
            document.add(chartImg);

            document.close();
            writer.close();
            JOptionPane.showMessageDialog(null, "Xuất PDF thành công!");

        }
    }

    public static String formatNgay(Date date) {
        return new SimpleDateFormat("dd/MM/yyyy").format(date);
    }

    public static void main(String[] args) {

    }

}
