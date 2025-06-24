
package appgiaovan.ConnectDB;
import java.sql.*;


public class ConnectionUtils {
    
   public static Connection getMyConnection() throws SQLException,
          ClassNotFoundException {
      return ConnectionOracle.getConnection();
  }
 
  public static void main(String[] args) throws SQLException,
          ClassNotFoundException {
 
      System.out.println("Đang kết nối ... ");
 
      Connection conn = ConnectionUtils.getMyConnection();
 

      System.out.println("Đang kết nối " + conn);
      System.out.println("Kết nối thành công");
 
  }
}

