/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package appgiaovan.ManagerGUI;

import appgiaovan.Controller.QLNVKhoController;
import appgiaovan.Entity.NhanVienKho;
import appgiaovan.Entity.TaiKhoan;
import javax.swing.*;
import java.awt.*;
import java.util.List;
import static appgiaovan.PasswordHashing.hashPassword;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;

public class FormThemNVKho extends JDialog {

    private QLNVKhoController controller;
    private JTextField txtID, txtHoTen, txtSDT, txtEmail, txtCCCD, txtNgaySinh, txtDiaChi, txtMucLuong, txtTenDangNhap, txtMatKhau;
    private JComboBox<Integer> cboIDKho, cboIDQuanLy;
    private JComboBox<String> cboGioiTinh;

    public FormThemNVKho() throws ClassNotFoundException {
        JFrame frame = new JFrame("Quản Lý Nhân Viên Kho");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setSize(1300, 600);
        frame.setLocationRelativeTo(null); // Center the frame
        super(frame, "Thêm Nhân Viên Kho", true);
        controller = new QLNVKhoController();
        initUI();
        hienThiMaNhanVienKhoMoi();
        hienThiCacLuaChonIDKho();
    }

    private void initUI() {
        JPanel pnl = new JPanel(new GridBagLayout());
        pnl.setBorder(BorderFactory.createEmptyBorder(15, 15, 15, 15));
        pnl.setPreferredSize(new Dimension(650, 550));  // <--- tăng chiều rộng
        GridBagConstraints c = new GridBagConstraints();
        c.insets = new Insets(5, 5, 5, 5);
        c.fill = GridBagConstraints.HORIZONTAL;

        String[] labels = {
            "Mã nhân viên kho:", "Họ Tên:", "SĐT:", "Email:",
            "CCCD:", "Ngày sinh:", "Giới tính:",
            "Địa chỉ",
            "ID_Kho:", "ID_QuanLy:", "Mức lương:",
            "Tên đăng nhập:", "Mật khẩu:"
        };
        Component[] fields = {
            txtID = new JTextField(), txtHoTen = new JTextField(),
            txtSDT = new JTextField(), txtEmail = new JTextField(),
            txtCCCD = new JTextField(),
            txtNgaySinh = new JTextField(),
            cboGioiTinh = new JComboBox<>(new String[]{"Nam", "Nữ"}),
            txtDiaChi = new JTextField(), 
            cboIDKho = new JComboBox<>(),
            cboIDQuanLy = new JComboBox<>(), 
            txtMucLuong = new JTextField(),
            txtTenDangNhap = new JTextField(),
            txtMatKhau = new JPasswordField()
        };
        txtID.setEnabled(false);
        cboIDQuanLy.setEnabled(false);
        for (int i = 0; i < labels.length; i++) {
            c.gridx = 0;
            c.gridy = i;
            c.weightx = 0.2;
            pnl.add(new JLabel(labels[i]), c);

            c.gridx = 1;
            c.weightx = 0.8;
            pnl.add(fields[i], c);
        }

        // nút lưu/hủy
        JPanel btnPanel = new JPanel(new FlowLayout(FlowLayout.RIGHT, 10, 0));
        JButton btnSave = new JButton("Lưu");
        btnSave.addActionListener(e -> onSave());
        JButton btnCancel = new JButton("Hủy");
        btnCancel.addActionListener(e -> dispose());
        btnPanel.add(btnSave);
        btnPanel.add(btnCancel);

        c.gridx = 0;
        c.gridy = labels.length;
        c.gridwidth = 2;
        c.anchor = GridBagConstraints.EAST;
        pnl.add(btnPanel, c);

        setContentPane(pnl);
        pack();
        setLocationRelativeTo(getOwner());
        setResizable(false);
    }

    public void hienThiMaNhanVienKhoMoi() throws ClassNotFoundException {
        txtID.setText(String.valueOf(controller.layMaNhanVienKhoMoi()));
    }
    
    public void hienThiCacLuaChonIDKho(){
        try {
            List<Integer> dsKho = controller.layTatCaIDKho();
            for (Integer id : dsKho) {
                cboIDKho.addItem(id);
            }
            if (!dsKho.isEmpty()) {
                Integer firstKho = dsKho.get(0);
                Integer mg = controller.layIDQuanLyTheoKho(firstKho);
                cboIDQuanLy.addItem(mg);
                cboIDQuanLy.setSelectedItem(mg);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }

    cboIDKho.addActionListener(e -> {
        Integer selectedKho = (Integer) cboIDKho.getSelectedItem();
        try {
            Integer mg = controller.layIDQuanLyTheoKho(selectedKho);
            cboIDQuanLy.removeAllItems();
            if (mg != null) {
                cboIDQuanLy.addItem(mg);
                cboIDQuanLy.setSelectedItem(mg);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    });
    }

    public boolean kiemTraDinhDangThongTin() {

        if (txtID.getText().trim().isEmpty() ||
            txtHoTen.getText().trim().isEmpty() ||
            txtSDT.getText().trim().isEmpty() ||
            txtEmail.getText().trim().isEmpty() ||
            txtCCCD.getText().trim().isEmpty() ||
            txtNgaySinh.getText().trim().isEmpty() ||
            cboGioiTinh.getSelectedItem() == null ||
            txtDiaChi.getText().trim().isEmpty() ||
            cboIDKho.getSelectedItem() == null ||
            cboIDQuanLy.getSelectedItem() == null ||
            txtMucLuong.getText().trim().isEmpty() ||
            txtTenDangNhap.getText().trim().isEmpty()) {
            JOptionPane.showMessageDialog(null, "Vui lòng điền đầy đủ thông tin.");
            return false;
        }


        String sdt = txtSDT.getText().trim();
        if (!sdt.matches("^0\\d{9}$")) {
            JOptionPane.showMessageDialog(null, "Số điện thoại phải có 10 chữ số và bắt đầu bằng số 0.");
            return false;
        }

        String ngaySinh = txtNgaySinh.getText().trim();
        if (!ngaySinh.matches("^\\d{4}-\\d{2}-\\d{2}$")) {
            JOptionPane.showMessageDialog(null, "Ngày sinh phải theo định dạng YYYY-MM-DD.");
            return false;
        }


        try {
            LocalDate.parse(ngaySinh); 
        } catch (DateTimeParseException e) {
            JOptionPane.showMessageDialog(null, "Ngày sinh không hợp lệ.");
            return false;
        }

        return true; 
    }




    public void hienThiThongBao(String msg) {
        JOptionPane.showMessageDialog(this, msg);
    }

    private void onSave() {
        if (!kiemTraDinhDangThongTin()) {
            hienThiThongBao("Thông tin không hợp lệ");
            return;
        }
        NhanVienKho nv = new NhanVienKho();
        TaiKhoan tk = new TaiKhoan();
        nv.setID_NguoiDung(Integer.parseInt(txtID.getText()));
        nv.setHoTen(txtHoTen.getText());
        nv.setSDT(txtSDT.getText());
        nv.setEmail(txtEmail.getText());
        nv.setCCCD(txtCCCD.getText());
        nv.setNgaySinh(java.sql.Date.valueOf(txtNgaySinh.getText()));
        nv.setGioiTinh(cboGioiTinh.getSelectedItem().toString());
        nv.setDiaChi(txtDiaChi.getText());
        nv.setID_Kho((Integer)cboIDKho.getSelectedItem());
        nv.setID_QuanLy((Integer)cboIDQuanLy.getSelectedItem());
        nv.setMucLuong(Double.parseDouble(txtMucLuong.getText()));
        tk.setTenTaiKhoan(txtTenDangNhap.getText());
        tk.setMatKhauMaHoa(hashPassword(txtMatKhau.getText()));
        boolean ok = controller.taoNhanVienKho(nv, tk);
        hienThiThongBao(ok ? "Thêm thành công" : "Thêm thất bại");
        if (ok) {
            dispose();
        }
    }
}
