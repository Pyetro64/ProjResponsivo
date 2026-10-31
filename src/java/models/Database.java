package models;

import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Database {

    private static final String URL = "jdbc:mysql://localhost:3306/projresponsivejava_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASSWORD = "jk123456"; // Senha padrão do XAMPP é vazia

    public static Connection getConnection() {
        Connection conn = null;
        try {
            // Carrega o Driver JDBC do MySQL
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException | SQLException e) {
            logError(e.getMessage());
            System.err.println("Erro na conexão com o banco de dados: " + e.getMessage());
        }
        return conn;
    }

    // Registra falhas de conexão no arquivo físico de log
    private static void logError(String errorMessage) {
        try (FileWriter fw = new FileWriter("erros.log", true);
             PrintWriter pw = new PrintWriter(fw)) {
            pw.println("[" + new java.util.Date() + "] ERRO CONEXAO: " + errorMessage);
        } catch (IOException ioEx) {
            ioEx.printStackTrace();
        }
    }
}

