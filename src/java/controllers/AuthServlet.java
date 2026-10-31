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

/**
 * Camada Controller: Gerenciador de Autenticação do Sistema. Orquestra o fluxo
 * de login, criação de sessões HTTP e encerramento de acessos. EQUIVALENTE À
 * CLASSE AuthController.php DO PROJETO ORIGINAL.
 */
@WebServlet("/login")
public class AuthServlet extends HttpServlet {

    /**
     * PROCESSA A SUBMISSÃO DO FORMULÁRIO DE ACESSO (MÉTODO POST) EQUIVALENTE AO
     * método loginAction() do PHP.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Instancia a camada de persistência para efetuar a validação do Hash Bcrypt
        UserDAO dao = new UserDAO();
        UserBean usuario = dao.autenticar(email, password);

        if (usuario != null) {
            // Se o jBcrypt validar a credencial, cria ou recupera a sessão ativa no Tomcat
            HttpSession session = request.getSession();
            // Grava o Bean de dados na sessão (Equivalente ao $_SESSION['user']
            session.setAttribute("user", usuario);
            // Redireciona o fluxo de forma segura para o controlador unificado de Perfil
            response.sendRedirect(request.getContextPath() + "/profile");
        } else {
            // Caso falhe, anexa a string explicativa ao escopo de requisição temporária
            request.setAttribute("login_error", "E-mail ou senha inválidos.");
            // Encaminha de volta para a interface de preenchimento (Mantendo o erro ativo)
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
    
    
    /**
     * PROCESSA REQUISIÇÕES DIRETAS DE REDIRECIONAMENTO E LOGOUT (MÉTODO GET)
     * EQUIVALENTE AO método logout() do PHP.
     */

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        
        // Regra para encerramento de sessão: se invocado /login?action=logout
        if ("logout".equals(action)) {
            // Captura a sessão existente sem criar uma nova caso não exista (false)
            HttpSession session = request.getSession(false);
            if (session != null) {
                // Invalida a sessão destruindo o token e limpando os atributos (session_destroy())
                session.invalidate();
            }
            // Despacha o usuário limpo para o fallback seguro da Home
            response.sendRedirect(request.getContextPath() + "/pagina?p=home");
            return;
        }
        
        // Caso seja um acesso GET comum, apenas renderiza a interface visual de login
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
}
