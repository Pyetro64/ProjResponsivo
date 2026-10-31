<%@page import="java.util.List"%>
<%@page import="models.UserBean"%>
<%@page import="models.UserDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/includes/helpers.jsp" %>
<%
    // Blindagem em nível de View: só administrador logado (feita ANTES do HTML)
    HttpSession sessaoAdmin = request.getSession(false);
    UserBean adminLogado = (sessaoAdmin != null) ? (UserBean) sessaoAdmin.getAttribute("user") : null;

    if (adminLogado == null || !"adm".equalsIgnoreCase(adminLogado.getUserType())) {
        response.sendRedirect(request.getContextPath() + "/pagina?p=home");
        return;
    }

    UserDAO dao = new UserDAO();
    List<UserBean> listaUsuarios = dao.getAllUsers();
    String ctx = request.getContextPath();
%>
<jsp:include page="/includes/header.jsp"><jsp:param name="titulo" value="Usuários"/><jsp:param name="area" value="painel"/></jsp:include>

<div class="painel__cab">
    <div>
        <h1>Usuários</h1>
        <p>Contas cadastradas e níveis de acesso.</p>
    </div>
    <span class="total"><%= listaUsuarios.size() %> usuário(s)</span>
</div>

<% if ("deleted".equals(request.getParameter("msg"))) { %>
<p class="aviso aviso--ok" role="status">Usuário removido com sucesso!</p>
<% } else if ("error_delete".equals(request.getParameter("msg"))) { %>
<p class="aviso aviso--erro" role="alert">Erro ao excluir o usuário (você não pode se excluir).</p>
<% } else if ("success".equals(request.getParameter("msg"))) { %>
<p class="aviso aviso--ok" role="status">Nível de acesso atualizado com sucesso!</p>
<% } %>

<div class="tabela-rolagem">
    <table class="tabela tabela--cartoes">
        <thead>
            <tr><th>ID</th><th>Nome</th><th>E-mail</th><th>Nível de acesso</th><th>Ações</th></tr>
        </thead>
        <tbody>
            <% for (UserBean u : listaUsuarios) { boolean uAdm = "adm".equalsIgnoreCase(u.getUserType()); %>
            <tr>
                <td data-rotulo="ID"><%= u.getId() %></td>
                <td data-rotulo="Nome"><strong><%= esc(u.getName()) %></strong></td>
                <td data-rotulo="E-mail"><%= esc(u.getEmail()) %></td>
                <td data-rotulo="Nível de acesso"><span class="selo <%= uAdm ? "selo--adm" : "selo--usu" %>"><%= esc(u.getUserType().toUpperCase()) %></span></td>
                <td data-rotulo="Ações" class="acoes">
                    <%-- Tela de alteração de privilégios --%>
                    <a class="mini" href="<%= ctx %>/pagina?p=admin_edit&amp;id=<%= u.getId() %>">Editar</a>
                    <% if (u.getId() != adminLogado.getId()) { %>
                    <%-- Exclusão via GET para o AdminServlet (/admin/deletar) --%>
                    <a class="mini mini--perigo" href="<%= ctx %>/admin/deletar?id=<%= u.getId() %>"
                       data-confirmar="Excluir o usuário <%= esc(u.getName()) %>? Esta ação não pode ser desfeita.">Excluir</a>
                    <% } else { %>
                    <span class="total">(Você)</span>
                    <% } %>
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>
</div>

<jsp:include page="/includes/footer.jsp" />
