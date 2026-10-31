package controllers;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import models.UserBean;
import models.UserDAO;
import models.MessageDAO;
import models.AuditDAO; // IMPORTAÇÃO OBRIGATÓRIA DA CAMADA DE AUDITORIA

@WebServlet("/admin/*")
public class AdminServlet extends HttpServlet {

     /**
     * Trava de Segurança em nível de Controlador.
     * Barra requisições forçadas via URL de usuários deslogados ou sem privilégio 'adm'.
     */
    private boolean validarAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        UserBean user = (session != null) ? (UserBean) session.getAttribute("user") : null;

        if (user == null || !"adm".equalsIgnoreCase(user.getUserType())) {
            response.sendRedirect(request.getContextPath() + "/pagina?p=home");
            return false;
        }
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!validarAdmin(request, response)) {
            return;
        }

        String pathInfo = request.getPathInfo(); 
        UserDAO dao = new UserDAO();
        AuditDAO auditDao = new AuditDAO(); // Instancia o gerenciador de logs

        // 1. AÇÃO: DELETAR USUÁRIO
        if ("/deletar".equals(pathInfo)) {
            String idParam = request.getParameter("id");
            if (idParam != null) {
                int id = Integer.parseInt(idParam);
                HttpSession session = request.getSession();
                UserBean adminLogado = (UserBean) session.getAttribute("user");

                // Mecanismo de Autoproteção: Impede o administrador de excluir a si próprio
                if (adminLogado.getId() != id) {
                    // Busca os dados do alvo antes de apagar para deixar o log detalhado
                    UserBean usuarioAlvo = dao.getUserById(id);
                    String nomeAlvo = (usuarioAlvo != null) ? usuarioAlvo.getName() : "ID " + id;

                    if (dao.deleteUser(id)) {
                        // ==========================================
                        // REGISTRAR AÇÃO NO LOG DE AUDITORIA (EXCLUSÃO)
                        // ==========================================
                        String detalhes = "O administrador " + adminLogado.getName() + " excluiu permanentemente o usuário: " + nomeAlvo + " (ID: " + id + ").";
                        auditDao.logAction(adminLogado.getId(), "EXCLUIR_USUARIO", detalhes);

                        response.sendRedirect(request.getContextPath() + "/pagina?p=admin_users&msg=deleted");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/pagina?p=admin_users&msg=error_delete");
                    }
                } else {
                    response.sendRedirect(request.getContextPath() + "/pagina?p=admin_users&msg=error_delete");
                }
                return;
            }
        }

        // 2. AÇÃO: RESOLVER MENSAGEM DE CONTATO
        if ("/resolver-mensagem".equals(pathInfo)) {
            String idParam = request.getParameter("id");
            if (idParam != null) {
                int id = Integer.parseInt(idParam);
                MessageDAO msgDao = new MessageDAO();

                if (msgDao.updateStatus(id, "resolvida")) {
                    response.sendRedirect(request.getContextPath() + "/pagina?p=admin_messages&msg=success");
                } else {
                    response.sendRedirect(request.getContextPath() + "/pagina?p=admin_messages&msg=error");
                }
                return;
            }
        }

        // 3. AÇÃO: DELETAR MENSAGEM DE CONTATO
        if ("/deletar-mensagem".equals(pathInfo)) {
            String idParam = request.getParameter("id");
            if (idParam != null) {
                int id = Integer.parseInt(idParam);
                MessageDAO msgDao = new MessageDAO();

                if (msgDao.delete(id)) {
                    response.sendRedirect(request.getContextPath() + "/pagina?p=admin_messages&msg=deleted");
                } else {
                    response.sendRedirect(request.getContextPath() + "/pagina?p=admin_messages&msg=error_delete");
                }
                return;
            }
        }

        response.sendRedirect(request.getContextPath() + "/pagina?p=admin_users");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!validarAdmin(request, response)) {
            return;
        }

        String pathInfo = request.getPathInfo();
        UserDAO dao = new UserDAO();
        AuditDAO auditDao = new AuditDAO();

        // 4. AÇÃO: ATUALIZAR NÍVEL DE ACESSO (POST)
        if ("/atualizar".equals(pathInfo)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String newType = request.getParameter("user_type");

            HttpSession session = request.getSession();
            UserBean adminLogado = (UserBean) session.getAttribute("user");

            // Busca o estado antigo do usuário para mapear a transição exata de privilégios
            UserBean usuarioAntes = dao.getUserById(id);
            
            if (usuarioAntes != null && dao.updateType(id, newType)) {
                // ==========================================
                // REGISTRAR AÇÃO NO LOG DE AUDITORIA (ALTERAÇÃO DE TIPO)
                // ==========================================
                String tipoAntigo = usuarioAntes.getUserType().toUpperCase();
                String tipoNovo = newType.toUpperCase();
                
                String detalhes = "Alterado privilégio do usuário " + usuarioAntes.getName() + " (ID: " + id + ") "
                                + "de [" + tipoAntigo + "] para [" + tipoNovo + "].";
                
                auditDao.logAction(adminLogado.getId(), "ALTERAR_NIVEL_ACESSO", detalhes);

                response.sendRedirect(request.getContextPath() + "/pagina?p=admin_users&msg=success");
            } else {
                response.sendRedirect(request.getContextPath() + "/pagina?p=admin_users&msg=error");
            }
        }
    }
}
