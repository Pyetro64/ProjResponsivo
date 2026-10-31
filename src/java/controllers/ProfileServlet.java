package controllers;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import models.Database;
import models.UserBean;
import models.AuditDAO; // IMPORTAÇÃO DA CAMADA DE AUDITORIA

@WebServlet("/profile") 
@MultipartConfig(
    maxFileSize = 1024 * 1024 * 2,      // Máximo 2MB por arquivo (Igual ao PHP)
    maxRequestSize = 1024 * 1024 * 4    // Máximo 4MB por requisição total
)
public class ProfileServlet extends HttpServlet {

    // INTERCEPTA A EXIBIÇÃO DO PERFIL (MÉTOPDO GET)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        UserBean user = (session != null) ? (UserBean) session.getAttribute("user") : null;

        // Trava de segurança ativa: impede que usuários deslogados forcem o acesso à view        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/pagina?p=login");
            return;
        }

        // Despacha o fluxo limpo para ser renderizado pelo Jsp
        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }

    // PROCESSA O ARQUIVO BINÁRIO ENVIADO (MÉTODO POST)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        UserBean user = (session != null) ? (UserBean) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/pagina?p=login");
            return;
        }

        String msgPerfil = "";
        
        try {
            // Captura o pedaço binário mapeado pelo input name="imagem"
            Part filePart = request.getPart("imagem"); 
            
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = filePart.getSubmittedFileName().toLowerCase();
                
                // 1. Validação de Extensão de Arquivos
                if (!fileName.endsWith(".jpg") && !fileName.endsWith(".jpeg") && 
                    !fileName.endsWith(".png") && !fileName.endsWith(".webp")) {
                    
                    request.setAttribute("msgPerfil", "Erro: Formato de imagem não permitido. Use apenas JPG, JPEG, PNG ou WEBP.");
                    request.getRequestDispatcher("/profile.jsp").forward(request, response);
                    return;
                }

                // 2. Extrai o fluxo de entrada de bytes
                InputStream inputStream = filePart.getInputStream();
                // 3. Executa a persistência relacional do LONGBLOB no banco de dados
                boolean sucesso = atualizarFotoBanco(user.getId(), inputStream);

                if (sucesso) {
                    // ==========================================================
                    // 4.REGISTRAR AÇÃO NO LOG DE AUDITORIA
                    // ==========================================================
                    AuditDAO auditDao = new AuditDAO();
                    String detalhes = "O usuário atualizou sua foto de perfil.";
                    auditDao.logAction(user.getId(), "ATUALIZAR_FOTO_PERFIL", detalhes);

                    msgPerfil = "Foto de perfil updated com sucesso!";
                } else {
                    msgPerfil = "Erro: Falha ao salvar a imagem no banco de dados.";
                }
            } else {
                msgPerfil = "Erro: Nenhuma imagem selecionada ou falha no upload.";
            }
        } catch (Exception e) {
            msgPerfil = "Erro: O tamanho da imagem deve ser menor que 2MB.";
        }

        // Recarrega a View injetando a string de feedback do processamento
        request.setAttribute("msgPerfil", msgPerfil);
        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }

    // Executa a regra de Upsert (Update ou Insert) do fluxo de bytes no MySQL
    private boolean atualizarFotoBanco(int userId, InputStream imagemStream) {
        Connection conn = null;
        PreparedStatement stmtCheck = null;
        PreparedStatement stmtAction = null;
        ResultSet rs = null;

        try {
            conn = Database.getConnection();
            
            // Verifica se o registro de perfil já existe para evitar duplicações de PK
            String sqlCheck = "SELECT user_id FROM perfil WHERE user_id = ?";
            stmtCheck = conn.prepareStatement(sqlCheck);
            stmtCheck.setInt(1, userId);
            rs = stmtCheck.executeQuery();

            if (rs.next()) {
                // Se o registro existe, atualiza a foto (UPDATE)
                String sqlUpdate = "UPDATE perfil SET foto_perfil = ? WHERE user_id = ?";
                stmtAction = conn.prepareStatement(sqlUpdate);
                stmtAction.setBlob(1, imagemStream);
                stmtAction.setInt(2, userId);
            } else {
                // Se não existe, cria a primeira entrada vinculada (INSERT)
                String sqlInsert = "INSERT INTO perfil (user_id, foto_perfil) VALUES (?, ?)";
                stmtAction = conn.prepareStatement(sqlInsert);
                stmtAction.setInt(1, userId);
                stmtAction.setBlob(2, imagemStream);
            }

            int rows = stmtAction.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            System.err.println("Erro ao atualizar foto de perfil: " + e.getMessage());
            return false;
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (stmtCheck != null) stmtCheck.close(); } catch (Exception e) {}
            try { if (stmtAction != null) stmtAction.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}
