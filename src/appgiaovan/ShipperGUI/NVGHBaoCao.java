package appgiaovan.ShipperGUI;

import appgiaovan.Controller.LapBaoCaoController;
import appgiaovan.GUI.Components.TimeWeather;
import com.formdev.flatlaf.FlatLightLaf;
import javax.swing.*;
import java.awt.*;
import javax.swing.border.TitledBorder;
import appgiaovan.Controller.LapBaoCaoController;

public class NVGHBaoCao extends JPanel {

    private JTextField reportTimeField;
    private JTextField deliveredField;
    private JTextField failedField;
    private JTextField revenueField;
    int id;

    public NVGHBaoCao(int idtk) {
       
        id = idtk;
        setLayout(new BorderLayout());
        
        JPanel mainPanel = new JPanel(new BorderLayout());
        mainPanel.setBackground(Color.WHITE);
        mainPanel.add(new TimeWeather("Hồ Chí Minh 30°C"), BorderLayout.NORTH);
        JPanel contentPanel = new JPanel(new BorderLayout());
        contentPanel.setPreferredSize(new Dimension(600, 400));
        contentPanel.setBorder(BorderFactory.createTitledBorder(
            BorderFactory.createLineBorder(Color.GRAY, 2), "Thông tin báo cáo",
            TitledBorder.DEFAULT_JUSTIFICATION, TitledBorder.DEFAULT_POSITION,
            new Font("Segoe UI", Font.BOLD, 20), Color.DARK_GRAY));
        contentPanel.setBackground(Color.WHITE);
        JPanel formPanel = new JPanel(new GridBagLayout());
        formPanel.setBackground(Color.WHITE);
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(10, 10, 10, 10);
        gbc.anchor = GridBagConstraints.WEST;
        gbc.gridx = 0; gbc.gridy = 0;
        formPanel.add(createLabel("Thời gian báo cáo:"), gbc);
        reportTimeField = createTextField(20);
        reportTimeField.setText(java.time.LocalDateTime.now()
            .format(java.time.format.DateTimeFormatter.ofPattern("HH:mm dd-MM-yyyy")));
        reportTimeField.setEditable(false);
        gbc.gridx = 1;
        formPanel.add(reportTimeField, gbc);

        gbc.gridy++; gbc.gridx = 0;
        formPanel.add(createLabel("Đã giao:"), gbc);
        deliveredField = createTextField(20);
        deliveredField.setEditable(true);
        gbc.gridx = 1;
        formPanel.add(deliveredField, gbc);

        gbc.gridy++; gbc.gridx = 0;
        formPanel.add(createLabel("Giao thất bại:"), gbc);
        failedField = createTextField(20);
        failedField.setEditable(true);
        gbc.gridx = 1;
        formPanel.add(failedField, gbc);

        gbc.gridy++; gbc.gridx = 0;
        formPanel.add(createLabel("Tiền đã nhận:"), gbc);
        revenueField = createTextField(20);
        revenueField.setEditable(true);
        gbc.gridx = 1;
        formPanel.add(revenueField, gbc);

        contentPanel.add(formPanel, BorderLayout.CENTER);

        JPanel centerWrapper = new JPanel(new GridBagLayout());
        centerWrapper.setBackground(Color.WHITE);
        centerWrapper.add(contentPanel);
        mainPanel.add(centerWrapper, BorderLayout.CENTER);

        JPanel buttonPanel = new JPanel(new FlowLayout(FlowLayout.RIGHT, 10, 10));
        buttonPanel.setBackground(Color.WHITE);
        JButton sendBtn = new JButton("Gửi");
        sendBtn.setFont(new Font("Segoe UI", Font.PLAIN, 20));
        buttonPanel.add(sendBtn);
        contentPanel.add(buttonPanel, BorderLayout.SOUTH);

       add(mainPanel, BorderLayout.CENTER);

        sendBtn.addActionListener(e -> {
        try {
            int dagiao = Integer.parseInt(deliveredField.getText().trim());
            int thatbai = Integer.parseInt(failedField.getText().trim());
            int cod = Integer.parseInt(revenueField.getText().trim());

            new LapBaoCaoController().ThemBaoCao(id, dagiao, thatbai, cod);
            JOptionPane.showMessageDialog(this, "Đã gửi báo cáo!", "Thông báo",
                    JOptionPane.INFORMATION_MESSAGE);
        } catch (NumberFormatException ex) {
            JOptionPane.showMessageDialog(this, "Vui lòng nhập đúng định dạng số ở các trường!", "Lỗi nhập liệu",
                    JOptionPane.ERROR_MESSAGE);
        }
    });

    }

    private JLabel createLabel(String text) {
        JLabel label = new JLabel(text);
        label.setFont(new Font("Segoe UI", Font.PLAIN, 20));
        return label;
    }

    private JTextField createTextField(int cols) {
        JTextField tf = new JTextField(cols);
        tf.setFont(new Font("Segoe UI", Font.PLAIN, 20));
        return tf;
    }

    public static void main(String[] args) {
       try {
            UIManager.setLookAndFeel(new FlatLightLaf());
        } catch (Exception e) {
            e.printStackTrace();
        }

        SwingUtilities.invokeLater(() -> {
            JFrame frame = new JFrame("Báo cáo nhân viên");
            frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            frame.setSize(800, 600);
            frame.setLocationRelativeTo(null);
            frame.setContentPane(new NVGHBaoCao(1));
            frame.setVisible(true);
        });
    }
}
