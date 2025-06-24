package appgiaovan.ShipperGUI;

import appgiaovan.Controller.CapNhatController;
import appgiaovan.Controller.QLDonHangController;
import appgiaovan.EmployeeGUI.QuanLyDonHangPanel;
import appgiaovan.EmployeeGUI.TableDonHang;
import appgiaovan.Entity.DonHang;
import appgiaovan.GUI.Components.TimeWeather;
import javax.swing.*;
import java.awt.*;
import static java.nio.file.Files.list;
import java.sql.SQLException;
import static java.util.Collections.list;
import java.util.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class QuanLyDonHang extends JPanel {

    private int idtk;
    private NVGHLoc filter = new NVGHLoc();
    private TableDonHang listOrder;
    private final QLDonHangController controller = new QLDonHangController();

    public QuanLyDonHang(int idtk) throws SQLException, ClassNotFoundException {

        setLayout(new BorderLayout());
        JPanel mainPanel = new JPanel(new BorderLayout());
        mainPanel.add(new TimeWeather("Hồ Chí Minh 30°C"), BorderLayout.NORTH);
        JPanel centerPanel = new JPanel(new BorderLayout());
        filter.setPreferredSize(new Dimension(0, 60));
        centerPanel.add(filter, BorderLayout.NORTH);
        String[] columns = {
            "", "Mã đơn hàng", "Tên người nhận", "Địa chỉ", "SĐT nhận",
            "Trạng thái", "Tiền COD", "Thời gian tạo", "SĐT gửi", "Tên người gửi"
        };

        QLDonHangController dsdh = new QLDonHangController();
        List<DonHang> ds = dsdh.HienThiDSDHChoNVGH(idtk);

        Object[][] data;
        if (ds == null || ds.isEmpty()) {
            data = new Object[0][columns.length];
        } else {
            data = new Object[ds.size()][columns.length];
            for (int i = 0; i < ds.size(); i++) {
                DonHang dh = ds.get(i);
                data[i][0] = false;
                data[i][1] = dh.getIdDonHang();
                data[i][2] = dh.getTenNguoiNhan();
                data[i][3] = dh.getDiaChiNhan();
                data[i][4] = dh.getSdtNguoiNhan();
                data[i][5] = dh.getTrangThai();
                data[i][6] = dh.getTienCOD();
                data[i][7] = dh.getThoiGianTao();
                data[i][8] = dh.getSdtNguoiGui();
                data[i][9] = dh.getTenNguoiGui();
            }
        }
        listOrder = new TableDonHang(columns, data);
        centerPanel.add(listOrder, BorderLayout.CENTER);
        mainPanel.add(centerPanel, BorderLayout.CENTER);
        add(mainPanel, BorderLayout.CENTER);
        filter.getfilterButton().addActionListener(e -> {
            try {
                DonHang dh = filter.getDonHang();

                HienThiDanhSach(dh, idtk);
            } catch (SQLException | ClassNotFoundException ex) {
                Logger.getLogger(QuanLyDonHangPanel.class.getName()).log(Level.SEVERE, null, ex);
            }
        });
        filter.getDGButton().addActionListener(e -> {
            try {
                
                XuLyCapNhatDonHang("Đã giao");
                HienThiDanhSach(idtk);


            } catch (ClassNotFoundException ex) {
                Logger.getLogger(QuanLyDonHang.class.getName()).log(Level.SEVERE, null, ex);
            } catch (Exception ex) {
                Logger.getLogger(QuanLyDonHang.class.getName()).log(Level.SEVERE, null, ex);
            }
        });
        filter.getTBButton().addActionListener(e -> {
            try {
                System.out.print(234);
                XuLyCapNhatDonHang("Giao thất bại");
                HienThiDanhSach(idtk);


            } catch (ClassNotFoundException ex) {
                Logger.getLogger(QuanLyDonHang.class.getName()).log(Level.SEVERE, null, ex);
            } catch (Exception ex) {
                Logger.getLogger(QuanLyDonHang.class.getName()).log(Level.SEVERE, null, ex);
            }
        });

        HienThiDanhSach(idtk);
    }

    public final void HienThiDanhSach(int idtk) throws SQLException, ClassNotFoundException {
        List<DonHang> dsDonHang = controller.LayDSDonHangSP(idtk);
        String[] columns = DonHang.getTableHeaders1();
        Object[][] data = new Object[dsDonHang.size()][columns.length];

        for (int i = 0; i < dsDonHang.size(); i++) {
            data[i] = dsDonHang.get(i).toTableRow1();
        }

        listOrder.setTableData(data);
    }

    public final void HienThiDanhSach(DonHang dh, int idtk) throws SQLException, ClassNotFoundException {
        List<DonHang> dsDonHang = controller.LayDSDonHangSP(dh, idtk);
        String[] columns = DonHang.getTableHeaders1();

        if (dsDonHang.isEmpty()) {

            Object[][] data = new Object[0][columns.length];
            listOrder.setTableData(data);
            return;
        }

        Object[][] data = new Object[dsDonHang.size()][columns.length];
        for (int i = 0; i < dsDonHang.size(); i++) {
            data[i] = dsDonHang.get(i).toTableRow1();
        }

        listOrder.setTableData(data);
    }

    public void XuLyCapNhatDonHang(String trangThai) throws SQLException, ClassNotFoundException, Exception {
        for (int i = 0; i < listOrder.getRowCount(); i++) {
            Boolean isChecked = (Boolean) listOrder.getValueAt(i, 0);
            if (Boolean.TRUE.equals(isChecked)) {
                Integer maDonHang = (Integer) listOrder.getValueAt(i, 1);
                new CapNhatController().CapNhatDHDaGiao(maDonHang, trangThai);
            }
        }

//        DonHang dh = filter.getDonHang();


    }

}
