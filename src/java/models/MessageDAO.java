package models;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MessageDAO {

    // Insere um novo registro de mensagem na tabela messages vinda do formulário de contato
    public boolean save(Integer userId, String name, String email, String subject, String message) {
        String sql = "INSERT INTO messages (user_id, name, email, subject, message) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = Database.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            // Tratamento de integridade: se não houver ID de usuário logado, injeta NULL na FK
            if (userId != null) {
                stmt.setInt(1, userId);
            } else {
                stmt.setNull(1, Types.INTEGER);
            }
            stmt.setString(2, name);
            stmt.setString(3, email);
            stmt.setString(4, subject);
            stmt.setString(5, message);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Erro ao salvar mensagem de contato: " + e.getMessage());
            return false;
        }
    }

    // Busca todas as mensagens com filtro de status opcional
    public List<MessageBean> getAllMessages(String status) {
        List<MessageBean> lista = new ArrayList<>();
        String sql = "SELECT * FROM messages";
        // Se um status específico for enviado via parâmetro, anexa o filtro à cláusula WHERE
        if (status != null && !status.trim().isEmpty()) {
            sql += " WHERE status = ?";
        }
        sql += " ORDER BY created_at DESC";

        try (Connection conn = Database.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            if (status != null && !status.trim().isEmpty()) {
                stmt.setString(1, status);
            }
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    MessageBean msg = new MessageBean();
                    msg.setId(rs.getInt("id"));
                    msg.setUserId(rs.getObject("user_id") != null ? rs.getInt("user_id") : null);
                    msg.setName(rs.getString("name"));
                    msg.setEmail(rs.getString("email"));
                    msg.setSubject(rs.getString("subject"));
                    msg.setMessage(rs.getString("message"));
                    msg.setStatus(rs.getString("status"));
                    msg.setCreatedAt(rs.getTimestamp("created_at"));
                    lista.add(msg);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erro ao listar mensagens: " + e.getMessage());
        }
        return lista;
    }

    // Atualiza o status de triagem de uma mensagem específica no banco.
    public boolean updateStatus(int id, String status) {
        String sql = "UPDATE messages SET status = ? WHERE id = ?";
        try (Connection conn = Database.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Erro ao atualizar status da mensagem: " + e.getMessage());
            return false;
        }
    }

    // Remove permanentemente um chamado da tabela messages.
    public boolean delete(int id) {
        String sql = "DELETE FROM messages WHERE id = ?";
        try (Connection conn = Database.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Erro ao deletar mensagem: " + e.getMessage());
            return false;
        }
    }
}
