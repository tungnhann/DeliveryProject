/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package appgiaovan.ShipperGUI;

import appgiaovan.Entity.DonHang;
import appgiaovan.GUI.Components.*;
import com.formdev.flatlaf.FlatLightLaf;
import javax.swing.*;
import java.awt.*;

import appgiaovan.DAO.DonHangDAO;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class NVGHLoc extends JPanel {

    private JTextField idField = new JTextField();
    private JTextField customerField = new JTextField();
    private JButton filterButton = new JButton("Lọc");
    private JButton dgButton = new JButton("Đã giao");
    private JButton tbButton = new JButton("Giao thất bại");
    //private final JTextField idField = new JTextField("");
    private final JTextField nullField = new JTextField("");
    private final DonHangDAO donHangDAO  = new DonHangDAO();
    private final JComboBox<String> statusComboBox ;
    public NVGHLoc() {
        setLayout(null);
        setBackground(Color.WHITE);

        idField.setPreferredSize(new Dimension(80, 50));
        idField.setBounds(10, 10, 100, 40);
        idField.setBorder(BorderFactory.createTitledBorder("Mã đơn hàng"));
        add(idField);

        String[] trangThai = { "Tất cả","Đang giao", "Đã giao", "Giao thất bại" };
        statusComboBox = new JComboBox<>(trangThai);
        statusComboBox.setPreferredSize(new Dimension(120, 50));
        statusComboBox.setBounds(130, 10, 120, 45);
        statusComboBox.setBorder(BorderFactory.createTitledBorder("Trạng thái"));
        add(statusComboBox);
        
        customerField.setPreferredSize(new Dimension(100, 50));
        customerField.setBounds(270, 10, 130, 40);
        customerField.setBorder(BorderFactory.createTitledBorder("Họ tên"));
        add(customerField);
        
        filterButton.setPreferredSize(new Dimension(60, 30));
        filterButton.setBackground(new Color(0, 136, 153));
        filterButton.setForeground(Color.WHITE);
        filterButton = new RoundedButton(filterButton, 20);
        filterButton.setBounds(420, 10, 70, 30);
        add(filterButton);
        
        dgButton.setPreferredSize(new Dimension(200, 30));
        dgButton.setBackground(new Color(0, 123, 255));
        dgButton.setForeground(Color.WHITE);
        dgButton = new RoundedButton(dgButton, 20);
        dgButton.setBounds(800, 10, 90, 30);
        add(dgButton);
        
        tbButton.setPreferredSize(new Dimension(240, 30));
        tbButton.setBackground(new Color(204, 0, 0));
        tbButton.setForeground(Color.WHITE);
        tbButton = new RoundedButton(tbButton, 20);
        tbButton.setBounds(900, 10, 110, 30);
        add(tbButton);
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            try {
                UIManager.setLookAndFeel(new FlatLightLaf());
            } catch (Exception ex) {
                System.err.println("Không thể cài đặt FlatLaf");
            }
            JFrame frame = new JFrame("");
            frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            frame.setSize(900, 120);
            frame.setLocationRelativeTo(null);
            frame.add(new NVGHLoc());
            frame.setVisible(true);
        });
    }
    public JButton getfilterButton() {
        return this.filterButton;
    }
    public JButton getDGButton(){
        return this.dgButton;
    }
    public JButton getTBButton(){
        return this.tbButton;
    }
    public DonHang getDonHang() {
        DonHang dh = new DonHang();

        String trangThai = (String) statusComboBox.getSelectedItem();
        if (!"Tất cả".equals(trangThai)) {
            dh.setTrangThai(trangThai);
        } else {
            dh.setTrangThai(null);  
        }

        return dh;
    }

}
