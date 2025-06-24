
package appgiaovan.ConnectDB;
import java.sql.*;

public class ConnectionOracle {
    public static Connection getConnection() throws ClassNotFoundException,
            SQLException {

        String hostName = "localhost";
        String sid = "orcl";
        String userName = "DoAnGiaoVan";
        String password = "Admin123";
        
  
        Class.forName("oracle.jdbc.driver.OracleDriver");

        String connectionURL = "jdbc:oracle:thin:@" + hostName + ":1521:" + sid;

        Connection conn = DriverManager.getConnection(connectionURL, userName,
                password);
        
        return conn;
    }
}

