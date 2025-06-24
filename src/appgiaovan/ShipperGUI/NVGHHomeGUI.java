package appgiaovan.ShipperGUI;

import appgiaovan.DAO.DonHangDAO;
import appgiaovan.EmployeeGUI.EmployeeSidebar;
import appgiaovan.GUI.Components.RoundedPanel;
import appgiaovan.GUI.Components.MenuBar;
import appgiaovan.GUI.Components.TimeWeather;
import javax.swing.*;
import java.awt.*;
import java.util.Arrays;
import static javax.swing.WindowConstants.EXIT_ON_CLOSE;
import java.awt.event.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import appgiaovan.ShipperGUI.NVGHMenu;
import java.sql.SQLException;

public class NVGHHomeGUI extends JPanel {

    private DonHangDAO dh = new DonHangDAO();
    public NVGHHomeGUI(int idtk) throws SQLException, ClassNotFoundException {
      
        setLayout(new BorderLayout());
        JPanel mainPanel = new JPanel(new BorderLayout());

        mainPanel.add(new TimeWeather("Hồ Chí Minh 30°C"), BorderLayout.NORTH );
        JPanel statPanel = new JPanel(new GridLayout(2, 2, 40, 40));
        statPanel.setBorder(BorderFactory.createEmptyBorder(40, 40, 40, 40));
        statPanel.setPreferredSize(new Dimension(500, 500)); 
        
        JPanel centerWrapper = new JPanel(new GridBagLayout());
        centerWrapper.add(statPanel);

        mainPanel.add(centerWrapper, BorderLayout.CENTER);
        add(mainPanel, BorderLayout.CENTER);
    }

}
