package controllers;

import java.io.IOException;
import java.net.URL;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Controlador Coringa responsável pelo roteamento dinâmico
 * e tratamento de rotas inexistentes sem gerar erros no servidor.
 */
@WebServlet(name = "PaginaController", urlPatterns = {
    "",         // Trata a raiz do projeto (ex: http://localhost:8080/seu-projeto/)
    "/pagina"   // Trata a rota base sem parâmetros
})
public class PaginaController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Captura o parâmetro "p" enviado na URL (ex: ?p=sobre ou ?p=servicos)
        String pageName = request.getParameter("p");

        // Se o nome da página não foi informado, for nulo ou estiver vazio, define "home" como padrão
        if (pageName == null || pageName.trim().isEmpty()) {
            pageName = "home";
        }

        // Sanitiza a string para evitar que digitem caminhos maliciosos (ex: ?p=../WEB-INF/web)
        pageName = pageName.replaceAll("[^a-zA-Z0-9_.-]", "");

        // Monta o caminho da View JSP na raiz do projeto (conforme a estrutura do seu projeto Ant)
        String jspPath = "/" + pageName + ".jsp";

        // Verifica de forma segura se o arquivo JSP realmente existe no servidor
        URL resource = null;
        try {
            resource = getServletContext().getResource(jspPath);
        } catch (Exception e) {
            // Evita que erros de busca quebrem o controller
            resource = null; 
        }

        if (resource != null) {
            // A página existe: encaminha o fluxo de forma limpa para o JSP
            request.getRequestDispatcher(jspPath).forward(request, response);
        } else {
            // A página não existe: define o status HTTP 404 e exibe a view de erro 404 de forma segura
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            request.getRequestDispatcher("/404.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
