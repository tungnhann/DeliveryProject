package appgiaovan;

import java.io.File;
import javax.mail.*;
import javax.mail.internet.*;
import java.util.Properties;
import java.util.Random;
import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.swing.JFileChooser;
import javax.swing.JOptionPane;

public class EmailSender {
    public static void sendMail(String toEmail, File pdfFile, String tieuDe) throws Exception {
        final String fromEmail = "3p1nPMIT@gmail.com";
        final String password = "fboftfflmqhazakj"; // App password nếu dùng Gmail

        // Thiết lập thông số SMTP
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        // Tạo session xác thực
        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        try {
            // Tạo email
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(tieuDe);

            // Nội dung text
            BodyPart messageBodyPart = new MimeBodyPart();
            messageBodyPart.setText("Vui lòng xem thông tin chi tiết ở tệp đính kèm.");

            // Đính kèm file PDF
            MimeBodyPart attachmentPart = new MimeBodyPart();
            DataSource source = new FileDataSource(pdfFile);
            attachmentPart.setDataHandler(new DataHandler(source));
            attachmentPart.setFileName(pdfFile.getName());

            // Gom tất cả lại
            Multipart multipart = new MimeMultipart();
            multipart.addBodyPart(messageBodyPart);
            multipart.addBodyPart(attachmentPart);

            message.setContent(multipart);

            // Gửi mail
            Transport.send(message);

            System.out.println("Gửi Email thành công.");
        } catch (MessagingException e) {
            throw new RuntimeException("Lỗi gửi email: " + e.getMessage(), e);
        }
    }

    public static void sendEmail(String toEmail, String code) {
        // Cấu hình thông tin SMTP 
        final String fromEmail = "3p1nPMIT@gmail.com";
        final String password = "fboftfflmqhazakj"; 
        String generatedCode = String.valueOf(new Random().nextInt(900000) + 100000);
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Xác nhận đăng ký tài khoản");
            message.setText("Mã xác nhận của bạn là: " + code);

            Transport.send(message);
            System.out.println("Email sent successfully to " + toEmail);

        } catch (MessagingException e) {
            e.printStackTrace();    
        }
    }

    public static void sendEmailWithAttachment(String toEmail, String subject, String body, File attachment) {
        final String fromEmail = "3p1nPMIT@gmail.com";
        final String password = "fboftfflmqhazakj"; // App password

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);

            // Body email
            MimeBodyPart messageBodyPart = new MimeBodyPart();
            messageBodyPart.setText(body);

            Multipart multipart = new MimeMultipart();
            multipart.addBodyPart(messageBodyPart);

            // File đính kèm
            if (attachment != null && attachment.exists()) {
                MimeBodyPart attachmentPart = new MimeBodyPart();
                DataSource source = new FileDataSource(attachment);
                attachmentPart.setDataHandler(new DataHandler(source));
                attachmentPart.setFileName(attachment.getName());
                multipart.addBodyPart(attachmentPart);
            }

            message.setContent(multipart);
            Transport.send(message);

            System.out.println("Email với file đính kèm đã được gửi tới " + toEmail);

        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
    
    public static void sendFileByEmail() {
        JFileChooser fileChooser = new JFileChooser();
        fileChooser.setDialogTitle("Chọn file để gửi email");
        int result = fileChooser.showOpenDialog(null);

        if (result == JFileChooser.APPROVE_OPTION) {
            File selectedFile = fileChooser.getSelectedFile();

            String toEmail = JOptionPane.showInputDialog(null, "Nhập địa chỉ email người nhận:");
            if (toEmail == null || toEmail.trim().isEmpty()) {
                JOptionPane.showMessageDialog(null, "Địa chỉ email không hợp lệ.");
                return;
            }

            String subject = "File thống kê đơn hàng";
            String body = "Vui lòng xem file thống kê đính kèm.";

            EmailSender.sendEmailWithAttachment(toEmail, subject, body, selectedFile);

            JOptionPane.showMessageDialog(null, "Đã gửi file tới: " + toEmail);
        }
    }
    

    public static void main(String[] args) {
        sendFileByEmail();
    }
}
