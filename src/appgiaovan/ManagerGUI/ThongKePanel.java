package appgiaovan.ManagerGUI;

import appgiaovan.Controller.ThongKeController;
import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ThongKePanel extends JPanel {

    private JTable table;
    private DefaultTableModel tableModel;
    private JButton btnXuatPDF;
    private ThongKeController controller;

    public ThongKePanel() {
        try {
            this.controller = new ThongKeController();
        } catch (SQLException ex) {
            Logger.getLogger(ThongKePanel.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(ThongKePanel.class.getName()).log(Level.SEVERE, null, ex);
        }
       

        setLayout(new BorderLayout());

        JTabbedPane tabbedPane = new JTabbedPane();

        tabbedPane.addTab("Đơn Hàng", new ThongKeDonHangPanel());
        tabbedPane.addTab("Đánh Giá", new ThongKeDanhGiaPanel());
        tabbedPane.addTab("Doanh Thu",new ThongKeDoanhThuPanel());

        add(tabbedPane, BorderLayout.CENTER);
    }
  
    

    public static void main(String[] args) {
        try {
            UIManager.setLookAndFeel(new com.formdev.flatlaf.FlatLightLaf());
        } catch (Exception e) {
            e.printStackTrace();
        }

        SwingUtilities.invokeLater(() -> {
            JFrame frame = new JFrame("Test Employee Main Panel");
            frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            frame.setSize(1000, 600);
            frame.setLocationRelativeTo(null);
            frame.setLayout(new BorderLayout());

            frame.add(new ThongKePanel(), BorderLayout.CENTER);
            frame.setVisible(true);
        });
    }
}
