/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package appgiaovan.ShipperGUI;

import appgiaovan.GUI.Components.ThongTinCaNhan;
import appgiaovan.GUI.LOGIN;
import javax.swing.*;
import java.awt.*;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import appgiaovan.Controller.TokenController;

/**
 *
 * @author ASUS
 */
public class NVGHMainGUI extends JFrame{
    private CardLayout cardLayout;
    private JPanel contentPanel;

    public NVGHMainGUI(int idtk, int idToken) throws ClassNotFoundException, SQLException {
        
        setTitle("3P1N - Nhân viên giao hàng");
        setSize(1300, 700);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null);
        setLayout(new BorderLayout());
        NVGHMenu sidebar = new NVGHMenu(idtk);
        add(sidebar, BorderLayout.WEST);

        cardLayout = new CardLayout();
        contentPanel = new JPanel(cardLayout);

        contentPanel.add(new QuanLyDonHang(idtk),"Quản lý đơn hàng");
        
        contentPanel.add(new NVGHBaoCao(idtk), "Báo cáo");
        contentPanel.add(new ThongTinCaNhan(),"Thông tin cá nhân");
        contentPanel.add(new NVGHHotro(), "Hỗ trợ");

        add(contentPanel);
        sidebar.addMenuClickListener((selectedName) -> {
            if (selectedName.equals("Đăng xuất")) {
                int confirm = JOptionPane.showConfirmDialog(
                    this,
                    "Bạn có chắc chắn muốn đăng xuất không?",
                    "Xác nhận đăng xuất",
                    JOptionPane.YES_NO_OPTION
                );

                if (confirm == JOptionPane.YES_OPTION) {
                    dispose();
                    try {
                        try {
                            new TokenController().capNhatToken(idToken);
                        } catch (ClassNotFoundException ex) {
                            Logger.getLogger(NVGHMainGUI.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    } catch (SQLException ex) {
                        Logger.getLogger(NVGHMainGUI.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    SwingUtilities.invokeLater(() -> new LOGIN().setVisible(true));
                }
            } else {
                cardLayout.show(contentPanel, selectedName);
            }
        });

    }
}
