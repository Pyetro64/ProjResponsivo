package controllers;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import models.MessageDAO;
import models.UserBean;
/**
 * Camada Controller: Centralizador do recebimento de contatos do público.
 * Identifica se a mensagem pertence a um usuário logado e despacha para o DAO.
 */

@WebServlet("/contato/*") 
public class ContactServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Se tentarem acessar via GET, redireciona para a página visual de contato
        response.sendRedirect(request.getContextPath() + "/pagina?p=contato");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        
        // Processa estritamente a ação de envio configurada na action do formulário
        if ("/enviar".equals(pathInfo)) {
            // Tenta recuperar a sessão do usuário caso ele esteja autenticado no sistema
            HttpSession session = request.getSession(false);
            UserBean user = (session != null) ? (UserBean) session.getAttribute("user") : null;
            
            // Vincula o ID do usuário se estiver logado, caso contrário deixa nulo no banco
            Integer userId = (user != null) ? user.getId() : null;
            
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String subject = request.getParameter("subject");
            String message = request.getParameter("message");

            MessageDAO dao = new MessageDAO();
            boolean sucesso = dao.save(userId, name, email, subject, message);

            // Redireciona limpando o POST e injetando o status correspondente para a View
            if (sucesso) {
                response.sendRedirect(request.getContextPath() + "/pagina?p=contato&status=success");
            } else {
                response.sendRedirect(request.getContextPath() + "/pagina?p=contato&status=error");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/pagina?p=contato");
        }
    }
}
