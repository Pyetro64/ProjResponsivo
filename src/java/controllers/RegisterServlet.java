package controllers;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import models.UserDAO;

/**
 * Camada Controller: Centralizador do Fluxo de Novos Cadastros.
 * Captura dados cadastrais da View e os despacha para higienização e hashing. 
 */
@WebServlet("/registrar") // Alinhado com a propriedade action definida no formulário jsp
public class RegisterServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Bloqueia acessos diretos via GET, redirecionando o fluxo para a tela visual
        response.sendRedirect(request.getContextPath() + "/pagina?p=register");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Coleta os parâmetros enviados pelo corpo da requisição POST
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");

        // Validação preventiva: impede submissões vazias ou fraudes de borda
        if (username == null || email == null || phone == null || password == null ||
            username.trim().isEmpty() || email.trim().isEmpty() || phone.trim().isEmpty()) {
            
            request.setAttribute("error", "Erro: Todos os campos do formulário devem ser preenchidos.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (password.length() < 6) {
            request.setAttribute("error", "Erro: A senha deve conter no mínimo 6 caracteres.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // 2. Instancia a camada de persistência para execução JDBC
        UserDAO dao = new UserDAO();
        
        // Executa a rotina contendo o algoritmo jBcrypt interno (desenvolvido na Etapa 4)
        boolean sucesso = dao.cadastrarUsuario(username.trim(), email.trim(), phone.trim(), password);

        if (sucesso) {
            // Se gravado no MySQL com sucesso, despacha o usuário para o login com feedback visual verde
            response.sendRedirect(request.getContextPath() + "/pagina?p=login&msg=registered");
        } else {
            // Caso falhe (ex: tentativa de duplicar e-mail que possui restrição UNIQUE no banco)
            request.setAttribute("error", "Erro ao efetuar cadastro. O e-mail informado já pode estar em uso.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}
