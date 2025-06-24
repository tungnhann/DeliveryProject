package appgiaovan.ShipperGUI;

import appgiaovan.GUI.Components.MenuBar;
import appgiaovan.GUI.Components.MenuBar.MenuClickListener;
import javax.swing.*;
import java.awt.*;
import java.util.Arrays;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class NVGHMenu extends JPanel {

    private MenuBar menu;

    public NVGHMenu(int idtk) throws SQLException, ClassNotFoundException {
        java.util.List<String> items = Arrays.asList("Quản lý đơn hàng", "Báo cáo","Thông tin cá nhân", "Hỗ trợ", "Đăng xuất");
        java.util.List<String> icons = Arrays.asList("order.png", "report.png","employee.png", "support.jpg", "logout.png");

        setLayout(new BorderLayout());

        menu = new MenuBar(items, icons, idtk);
        add(menu, BorderLayout.WEST);
        setPreferredSize(menu.getPreferredSize());
    }

    public void addMenuClickListener(MenuClickListener listener) {
        menu.addMenuClickListener(listener); 
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            try {
                new NVGHMenu(29).setVisible(true);
            } catch (SQLException ex) {
                Logger.getLogger(NVGHMenu.class.getName()).log(Level.SEVERE, null, ex);
            } catch (ClassNotFoundException ex) {
                Logger.getLogger(NVGHMenu.class.getName()).log(Level.SEVERE, null, ex);
            }
        });
    }
}
