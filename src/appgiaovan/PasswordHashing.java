
package appgiaovan;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class PasswordHashing {
    public static String hashPassword(String password) {
        try {
            MessageDigest mk = MessageDigest.getInstance("SHA-256");
            byte[] hash = mk.digest(password.getBytes());
            
            StringBuilder hexString = new StringBuilder();
            for(byte b : hash){
                hexString.append(String.format("%02x", b));
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }
    
    public static void main(String[] args) {
        String plainPassword = "123";
        String hashedPassword = hashPassword(plainPassword);

        if (hashedPassword != null) {
            System.out.println("Plain Password: " + plainPassword);
            System.out.println("SHA-256 Hash:   " + hashedPassword);
        }
    }

}

