
package appgiaovan;

import appgiaovan.Controller.QLKHController;
import appgiaovan.Entity.KhachHang;
import appgiaovan.Entity.TaiKhoan;
import appgiaovan.GUI.FormNhapMatKhauMoi;
import appgiaovan.GUI.LOGIN;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.*;

public class VerificationForm extends JFrame {
    private final JTextField codeField;
    private final JButton verifyButton;
    private final String realCode;
    public VerificationForm(String realCode,String email) {
        this.realCode = realCode;

        setTitle("Xác nhận đăng ký");
        setSize(300, 150);
        setLocationRelativeTo(null);
        setLayout(null);

        JLabel codeLabel = new JLabel("Nhập mã:");
        codeLabel.setBounds(20, 20, 100, 20);
        add(codeLabel);

        codeField = new JTextField();
        codeField.setBounds(100, 20, 150, 20);
        add(codeField);

        verifyButton = new JButton("Xác nhận");
        verifyButton.setBounds(100, 60, 100, 30);
        add(verifyButton);

        verifyButton.addActionListener(e -> verifyCode(email));
    }

    public VerificationForm(String realCode, String email, KhachHang kh, TaiKhoan tk) {
        this.realCode = realCode;
        setTitle("Xác nhận đăng ký");
        setSize(300, 150);
        setLocationRelativeTo(null);
        setLayout(null);

        JLabel codeLabel = new JLabel("Nhập mã:");
        codeLabel.setBounds(20, 20, 100, 20);
        add(codeLabel);

        codeField = new JTextField();
        codeField.setBounds(100, 20, 150, 20);
        add(codeField);

        verifyButton = new JButton("Xác nhận");
        verifyButton.setBounds(100, 60, 100, 30);
        add(verifyButton);

        verifyButton.addActionListener(e -> {
            try {
                verifyDK(email,kh,tk);
            } catch (ClassNotFoundException ex) {
                Logger.getLogger(VerificationForm.class.getName()).log(Level.SEVERE, null, ex);
            }
        });
    }
    private void verifyDK(String email,KhachHang kh,TaiKhoan tk) throws ClassNotFoundException{
        QLKHController controller=new QLKHController();
        if (codeField.getText().equals(realCode)) {
            JOptionPane.showMessageDialog(this, "Xác nhận thành công!");
            controller.taoKhachHang(kh, tk);
            JOptionPane.showMessageDialog(this, "Đăng ký tài khoản thành công!", 
                        "Thành công", JOptionPane.INFORMATION_MESSAGE);
            SwingUtilities.invokeLater(() -> {
                    LOGIN fp = new LOGIN();
                    fp.setVisible(true);
                    dispose();
                });
        } else {
            JOptionPane.showMessageDialog(this, "Sai mã xác nhận.");
        }
    }
    private void verifyCode(String email) {
        if (codeField.getText().equals(realCode)) {
            JOptionPane.showMessageDialog(this, "Xác nhận thành công!");
            FormNhapMatKhauMoi form=new FormNhapMatKhauMoi(email);
            form.setVisible(true);// đóng form xác nhận
            dispose(); 
        } else {
            JOptionPane.showMessageDialog(this, "Sai mã xác nhận.");
        }
    }
    static public void main(String[] args){
        
    }
}

