package models;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Camada Model: Gerenciador de Persistência para Auditoria. Executa as
 * consultas de rastreabilidade de ações críticas no banco de dados.
 *
 */
public class AuditDAO {

    // Recupera a coleção unificada de trilhas combinando dados de tabelas.
    public List<AuditBean> getLogs() {
        List<AuditBean> logs = new ArrayList<>();

        // Query com junção relacional e ordenação decrescente (eventos mais recentes primeiro)
        String query = "SELECT a.timestamp, u.name AS username, a.action_type, a.details "
                + "FROM audit_log a "
                + "INNER JOIN users u ON a.user_id = u.id "
                + "ORDER BY a.timestamp DESC";

        try (Connection conn = Database.getConnection(); PreparedStatement stmt = conn.prepareStatement(query); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                AuditBean log = new AuditBean();
                log.setTimestamp(rs.getTimestamp("timestamp"));
                log.setUsername(rs.getString("username"));
                log.setActionType(rs.getString("action_type"));
                log.setDetails(rs.getString("details"));
                logs.add(log);
            }

        } catch (SQLException e) {
            System.err.println("Erro ao recuperar logs de auditoria: " + e.getMessage());
        }

        return logs;
    }

    // Insere de forma autônoma um novo evento crítico na tabela audit_log
    public boolean logAction(int userId, String actionType, String details) {
        String sql = "INSERT INTO audit_log (user_id, action_type, details) VALUES (?, ?, ?)";
        try (Connection conn = Database.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            stmt.setString(2, actionType);
            stmt.setString(3, details);

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Erro ao gravar log de auditoria: " + e.getMessage());
            return false;
        }
    }
}
