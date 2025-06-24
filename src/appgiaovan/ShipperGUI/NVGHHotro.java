package appgiaovan.ShipperGUI;

import appgiaovan.GUI.Components.RoundedPanel;
import appgiaovan.GUI.Components.MenuBar;
import javax.swing.*;
import java.awt.*;
import java.util.Arrays;
import static javax.swing.WindowConstants.EXIT_ON_CLOSE;
import java.awt.event.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class NVGHHotro extends JPanel {

    public NVGHHotro() {
        setLayout(new BorderLayout());
        JPanel mainPanel = new JPanel(new BorderLayout());
        JPanel topPanel = new JPanel(new BorderLayout());
        topPanel.setBorder(BorderFactory.createEmptyBorder(10, 20, 10, 20));
        topPanel.setBackground(Color.WHITE);
        JLabel timeLabel = new JLabel(); 
        timeLabel.setFont(new Font("Segoe UI", Font.BOLD, 16));
        JLabel weatherLabel = new JLabel("Hà Nội: 30°C *"); 
        weatherLabel.setFont(new Font("Segoe UI", Font.BOLD, 16));
        weatherLabel.setHorizontalAlignment(SwingConstants.RIGHT);
        topPanel.add(timeLabel, BorderLayout.WEST);
        topPanel.add(weatherLabel, BorderLayout.EAST);
        mainPanel.add(topPanel, BorderLayout.NORTH);

        Timer timer = new Timer(1000, e -> {
            timeLabel.setText(LocalDateTime.now()
                .format(DateTimeFormatter.ofPattern("HH:mm:ss dd-MM-yyyy")));
        });
        timer.start();
        JPanel supportPanel = new JPanel(null);
        supportPanel.setPreferredSize(new Dimension(800, 600)); 
        supportPanel.setBackground(Color.WHITE); 
        
        JLabel titleLabel = new JLabel("Hỗ trợ nhân viên");
        titleLabel.setFont(new Font("Segoe UI", Font.BOLD, 20));
        titleLabel.setBounds(50, 30, 300, 30);
        supportPanel.add(titleLabel);
        
        JTextArea instructionsArea = new JTextArea("Hướng dẫn sử dụng:\n1. Đăng nhập vào hệ thống.\n2. Quản lý đơn hàng.\n3. Báo cáo kết quả.");
        instructionsArea.setFont(new Font("Segoe UI", Font.PLAIN, 16));
        instructionsArea.setLineWrap(true);
        instructionsArea.setWrapStyleWord(true);
        instructionsArea.setEditable(false);
        instructionsArea.setBounds(50, 80, 400, 120);
        instructionsArea.setBorder(BorderFactory.createLineBorder(Color.LIGHT_GRAY));
        supportPanel.add(instructionsArea);
        
        JLabel hotlineLabel = new JLabel("Hotline: 1800-1234-5678");
        hotlineLabel.setFont(new Font("Segoe UI", Font.BOLD, 16));
        hotlineLabel.setBounds(50, 220, 300, 30);
        supportPanel.add(hotlineLabel);
        
        JLabel tbaoLabel = new JLabel("Hãy liên hệ hotline để được hỗ trợ");
        tbaoLabel.setFont(new Font("Segoe UI", Font.PLAIN, 16));
        tbaoLabel.setBounds(50, 250, 300, 30);
        supportPanel.add(tbaoLabel);

        JPanel centerWrapper = new JPanel(new GridBagLayout());
        centerWrapper.setBackground(Color.WHITE);
        centerWrapper.add(supportPanel);
        mainPanel.add(centerWrapper, BorderLayout.CENTER);

        add(mainPanel, BorderLayout.CENTER);
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            new NVGHHotro().setVisible(true);
        });
    }
}
