<%@page import="models.UserBean"%>
<%@page import="models.UserDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/includes/helpers.jsp" %>
<%
    // Trava de segurança: bloqueia usuário comum (usu) e visitante (feita ANTES do HTML)
    HttpSession sessaoEdit = request.getSession(false);
    UserBean adminLogado = (sessaoEdit != null) ? (UserBean) sessaoEdit.getAttribute("user") : null;

    if (adminLogado == null || !"adm".equalsIgnoreCase(adminLogado.getUserType())) {
        response.sendRedirect(request.getContextPath() + "/pagina?p=home");
        return;
    }

    // ID do usuário a editar, vindo da URL
    String idParam = request.getParameter("id");
    UserBean usuarioEdicao = null;

    if (idParam != null) {
        try {
            UserDAO dao = new UserDAO();
            usuarioEdicao = dao.getUserById(Integer.parseInt(idParam));
        } catch (NumberFormatException e) {
            usuarioEdicao = null; // ID inválido
        }
    }

    // ID inválido ou usuário inexistente: volta para a lista
    if (usuarioEdicao == null) {
        response.sendRedirect(request.getContextPath() + "/pagina?p=admin_users");
        return;
    }
%>
<jsp:include page="/includes/header.jsp"><jsp:param name="titulo" value="Editar acesso"/><jsp:param name="area" value="painel"/></jsp:include>

<div class="painel__cab">
    <div>
        <h1>Editar nível de acesso</h1>
        <p>Alterando as permissões de: <strong><%= esc(usuarioEdicao.getName()) %></strong></p>
    </div>
    <a class="botao botao--mini botao--contorno" href="<%= rota(request.getContextPath(), "admin_users") %>"><%= icone("voltar") %>Voltar à lista</a>
</div>

<%-- POST para o AdminServlet (/admin/atualizar): id (oculto) e user_type --%>
<form class="formulario cartao" style="max-width:520px" method="post" action="<%= request.getContextPath() %>/admin/atualizar" data-envio-unico>
    <input type="hidden" name="id" value="<%= usuarioEdicao.getId() %>">

    <div class="campo">
        <label for="user_type">Nível de acesso</label>
        <select id="user_type" name="user_type">
            <option value="usu" <%= "usu".equalsIgnoreCase(usuarioEdicao.getUserType()) ? "selected" : "" %>>USU (Usuário comum)</option>
            <option value="adm" <%= "adm".equalsIgnoreCase(usuarioEdicao.getUserType()) ? "selected" : "" %>>ADM (Administrador)</option>
        </select>
    </div>

    <div class="hero__acoes">
        <button class="botao botao--mini" type="submit">Salvar alterações</button>
        <a class="botao botao--mini botao--contorno" href="<%= rota(request.getContextPath(), "admin_users") %>">Cancelar</a>
    </div>
</form>

<jsp:include page="/includes/footer.jsp" />
