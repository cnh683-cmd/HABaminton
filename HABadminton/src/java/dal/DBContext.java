package dal;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {
    protected Connection connection;

    public DBContext() {
        try {
            String user = "sa";
            String pass = "123456";
            String url = "jdbc:sqlserver://localhost:1433;databaseName=HABadminton;encrypt=true;trustServerCertificate=true";
            
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            connection = DriverManager.getConnection(url, user, pass);
            System.out.println("Kết nối SQL Server thành công!");
        } catch (ClassNotFoundException | SQLException ex) {
            System.out.println("Lỗi kết nối CSDL: " + ex.getMessage());
        }
    }
    
    public static void main(String[] args) {
        new DBContext();
    }
}