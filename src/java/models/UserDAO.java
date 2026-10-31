package models;

import java.sql.*;
// IMPORTAÇÃO DA BIBLIOTECA EXTERNA JBCRYPT
import org.mindrot.jbcrypt.BCrypt;

public class UserDAO {

    public boolean cadastrarUsuario(String name, String email, String phone, String password) {
        String sql = "INSERT INTO users (name, email, phone, password) VALUES (?, ?, ?, ?)";

        // 1. Gera o Salt e o Hash da senha usando a biblioteca externa jBcrypt (fator de custo padrão = 10)
        // Isso gera exatamente a mesma estrutura Blowfish/Bcrypt ($2a$) que o password_hash do PHP
        String passwordHash = BCrypt.hashpw(password, BCrypt.gensalt());

        try (Connection conn = Database.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, name);
            stmt.setString(2, email);
            stmt.setString(3, phone);
            stmt.setString(4, passwordHash); // Grava a string criptografada com segurança

            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("Erro ao cadastrar usuário: " + e.getMessage());
            return false;
        }
    }

    // Valida as credenciais de acesso utilizando verificação de via única.
    // Adicione este método em UserDAO.java.
    public UserBean autenticar(String email, String password) {
        // Busca apenas pelo e-mail para trazer o Hash de senha persistido
        String sql = "SELECT id, name, email, password, user_type FROM users WHERE email = ? LIMIT 1";

        try (Connection conn = Database.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String hashBanco = rs.getString("password");

                    // 2. Compara a senha informada em texto plano com o Hash criptografado no banco de dados
                    if (BCrypt.checkpw(password, hashBanco)) {
                        UserBean usuario = new UserBean();
                        usuario.setId(rs.getInt("id"));
                        usuario.setName(rs.getString("name"));
                        usuario.setEmail(rs.getString("email"));
                        usuario.setUserType(rs.getString("user_type"));
                        return usuario; // Senha validada com sucesso
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Erro na autenticação: " + e.getMessage());
        }
        return null; // Retorna nulo se o e-mail não existir ou a senha for inválida
    }

    // Adicione estes métodos dentro da sua classe UserDAO.java existente:
    // Recupera todos os usuários registrados para exibição em painel.
    public java.util.List<UserBean> getAllUsers() {
        java.util.List<UserBean> lista = new java.util.ArrayList<>();
        String sql = "SELECT id, name, email, user_type FROM users";

        try (Connection conn = Database.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                UserBean u = new UserBean();
                u.setId(rs.getInt("id"));
                u.setName(rs.getString("name"));
                u.setEmail(rs.getString("email"));
                u.setUserType(rs.getString("user_type"));
                lista.add(u);
            }
        } catch (SQLException e) {
            System.err.println("Erro ao listar todos os usuários: " + e.getMessage());
        }
        return lista;
    }

    // Busca um usuário específico com base em sua chave primária (ID).
    public UserBean getUserById(int id) {
        String sql = "SELECT id, name, email, user_type FROM users WHERE id = ?";
        try (Connection conn = Database.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    UserBean u = new UserBean();
                    u.setId(rs.getInt("id"));
                    u.setName(rs.getString("name"));
                    u.setEmail(rs.getString("email"));
                    u.setUserType(rs.getString("user_type"));
                    return u;
                }
            }
        } catch (SQLException e) {
            System.err.println("Erro ao buscar usuário por ID: " + e.getMessage());
        }
        return null;
    }

    // Atualiza o nível de permissão (user_type) de uma conta.
    public boolean updateType(int id, String newType) {
        String sql = "UPDATE users SET user_type = ? WHERE id = ?";
        try (Connection conn = Database.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, newType);
            stmt.setInt(2, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Erro ao atualizar nível de acesso: " + e.getMessage());
            return false;
        }
    }

    // Elimina fisicamente um registro de usuário do banco de dados.
    public boolean deleteUser(int id) {
        String sql = "DELETE FROM users WHERE id = ?";
        try (Connection conn = Database.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Erro ao excluir usuário: " + e.getMessage());
            return false;
        }
    }

    // Adicione estes métodos dentro de UserDAO.java:
    public UserBean findByEmailAndPhone(String email, String phone) {
        String sql = "SELECT id, name, email FROM users WHERE email = ? AND phone = ? LIMIT 1";
        try (Connection conn = Database.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            stmt.setString(2, phone);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    UserBean u = new UserBean();
                    u.setId(rs.getInt("id"));
                    u.setName(rs.getString("name"));
                    u.setEmail(rs.getString("email"));
                    return u;
                }
            }
        } catch (SQLException e) {
            System.err.println("Erro ao buscar por email e telefone: " + e.getMessage());
        }
        return null;
    }

    public boolean setResetToken(int userId, String token, String expiryTime) {
        String sql = "UPDATE users SET reset_token = ?, reset_expires = ? WHERE id = ?";
        try (Connection conn = Database.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, token);
            stmt.setString(2, expiryTime);
            stmt.setInt(3, userId);

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Erro ao salvar token de recuperação: " + e.getMessage());
            return false;
        }
    }

    public UserBean getUserByResetToken(String token) {
        // Compara se o token existe e se a data atual do banco é menor que a data de expiração (5 minutos)
        String sql = "SELECT id FROM users WHERE reset_token = ? AND reset_expires > NOW() LIMIT 1";
        try (Connection conn = Database.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, token);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    UserBean u = new UserBean();
                    u.setId(rs.getInt("id"));
                    return u;
                }
            }
        } catch (SQLException e) {
            System.err.println("Erro ao validar token de recuperação: " + e.getMessage());
        }
        return null;
    }

    public boolean resetPassword(int userId, String newPassword) {
        String sql = "UPDATE users SET password = ?, reset_token = NULL, reset_expires = NULL WHERE id = ?";

        // Criptografa a nova senha gerada em texto limpo usando o jBcrypt externo adicionado ao projeto
        String passwordHash = org.mindrot.jbcrypt.BCrypt.hashpw(newPassword, org.mindrot.jbcrypt.BCrypt.gensalt());

        try (Connection conn = Database.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, passwordHash);
            stmt.setInt(2, userId);

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Erro ao redefinir senha no banco: " + e.getMessage());
            return false;
        }
    }

}
