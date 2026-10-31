package models;

import java.sql.Timestamp;
/**
 * Camada Model: Objeto de Transferência de Dados (Java Bean) para Mensagens.
 * Modela os atributos do formulário de contato em conformidade com as colunas do MySQL.
 */

public class MessageBean {
    private int id;
    private Integer userId; // Integer aceita null (necessário para usuários não logados)
    private String name;
    private String email;
    private String subject;
    private String message;
    private String status; // Mapeado a partir do ENUM do MySQL
    private Timestamp createdAt;

    // Métodos Getters e Setters de Acesso Controlado
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getSubject() { return subject; }
    public void setSubject(String subject) { this.subject = subject; }
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
