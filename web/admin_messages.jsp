<%@page import="java.text.SimpleDateFormat"%>
<%@page import="models.MessageBean"%>
<%@page import="java.util.List"%>
<%@page import="models.MessageDAO"%>
<%@page import="models.UserBean"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/includes/helpers.jsp" %>
<%
    // Acesso restrito a administradores (feito ANTES do HTML)
    HttpSession sessaoAdmin = request.getSession(false);
    UserBean adminLogado = (sessaoAdmin != null) ? (UserBean) sessaoAdmin.getAttribute("user") : null;

    if (adminLogado == null || !"adm".equalsIgnoreCase(adminLogado.getUserType())) {
        response.sendRedirect(request.getContextPath() + "/pagina?p=home");
        return;
    }

    // Filtro de status da URL (?status=pendente|lida|resolvida)
    String statusFiltro = request.getParameter("status");
    MessageDAO msgDao = new MessageDAO();
    List<MessageBean> mensagens = msgDao.getAllMessages(statusFiltro);
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    String ctx = request.getContextPath();
    String stAtivo = statusFiltro == null ? "" : statusFiltro;
%>
<jsp:include page="/includes/header.jsp"><jsp:param name="titulo" value="Mensagens"/><jsp:param name="area" value="painel"/></jsp:include>

<div class="painel__cab">
    <div>
        <h1>Mensagens</h1>
        <p>Recados enviados pelo formulário de contato.</p>
    </div>
    <span class="total"><%= mensagens.size() %> mensagem(ns)</span>
</div>

<%-- Feedback das ações despachadas pelo AdminServlet --%>
<% if ("success".equals(request.getParameter("msg"))) { %>
<p class="aviso aviso--ok" role="status">Mensagem marcada como resolvida com sucesso!</p>
<% } else if ("deleted".equals(request.getParameter("msg"))) { %>
<p class="aviso aviso--ok" role="status">Mensagem excluída permanentemente.</p>
<% } else if ("error".equals(request.getParameter("msg"))) { %>
<p class="aviso aviso--erro" role="alert">Erro ao processar operação na mensagem.</p>
<% } %>

<div class="filtros" role="group" aria-label="Filtrar por status">
    <a class="filtro <%= stAtivo.isEmpty() ? "is-ativo" : "" %>" href="<%= ctx %>/pagina?p=admin_messages">Todas</a>
    <a class="filtro <%= "pendente".equals(stAtivo) ? "is-ativo" : "" %>" href="<%= ctx %>/pagina?p=admin_messages&amp;status=pendente">Pendentes</a>
    <a class="filtro <%= "lida".equals(stAtivo) ? "is-ativo" : "" %>" href="<%= ctx %>/pagina?p=admin_messages&amp;status=lida">Lidas</a>
    <a class="filtro <%= "resolvida".equals(stAtivo) ? "is-ativo" : "" %>" href="<%= ctx %>/pagina?p=admin_messages&amp;status=resolvida">Resolvidas</a>
</div>

<% if (mensagens.isEmpty()) { %>
<div class="vazio"><%= icone("mail") %><strong>Nenhuma mensagem encontrada</strong><span>Troque o filtro para ver outras mensagens.</span></div>
<% } else { %>
<div class="tabela-rolagem">
    <table class="tabela tabela--cartoes">
        <thead>
            <tr><th>ID</th><th>Data de envio</th><th>Nome</th><th>Assunto</th><th>Status</th><th>Ações</th></tr>
        </thead>
        <tbody>
            <% for (MessageBean msg : mensagens) {
                   String st = msg.getStatus() == null ? "pendente" : msg.getStatus().toLowerCase();
            %>
            <tr>
                <td data-rotulo="ID"><%= msg.getId() %></td>
                <td data-rotulo="Data de envio"><%= sdf.format(msg.getCreatedAt()) %></td>
                <td data-rotulo="Nome"><%= esc(msg.getName()) %></td>
                <td data-rotulo="Assunto"><%= esc(msg.getSubject()) %></td>
                <td data-rotulo="Status"><span class="selo selo--<%= esc(st) %> badge-status"><%= esc(st.toUpperCase()) %></span></td>
                <td data-rotulo="Ações" class="acoes">
                    <button type="button" class="mini btn-ler"
                            data-id="<%= msg.getId() %>"
                            data-name="<%= esc(msg.getName()) %>"
                            data-subject="<%= esc(msg.getSubject()) %>"
                            data-message="<%= esc(msg.getMessage()) %>">Ler</button>
                    <% if (!"resolvida".equals(st)) { %>
                    <a class="mini" href="<%= ctx %>/admin/resolver-mensagem?id=<%= msg.getId() %>"
                       data-confirmar="Marcar mensagem como resolvida?">Resolver</a>
                    <% } %>
                    <a class="mini mini--perigo" href="<%= ctx %>/admin/deletar-mensagem?id=<%= msg.getId() %>"
                       data-confirmar="Tem certeza que deseja excluir esta mensagem?">Excluir</a>
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>
</div>
<% } %>

<%-- Janela de leitura. O script usa data-marcar-lida para avisar o AdminServlet (POST JSON {id}) --%>
<div id="modal-mensagem" class="modal-msg" role="dialog" aria-modal="true" aria-labelledby="modal-titulo" aria-hidden="true"
     data-marcar-lida="<%= ctx %>/admin/marcar-lida">
    <div class="modal-msg__caixa">
        <button type="button" class="modal-msg__fechar" aria-label="Fechar">&times;</button>
        <h3 id="modal-titulo">Mensagem de: <span id="modal-name"></span></h3>
        <p><strong>ID da mensagem:</strong> <span id="modal-id"></span></p>
        <p><strong>Assunto:</strong> <span id="modal-subject"></span></p>
        <p class="modal-msg__texto" id="modal-message"></p>
    </div>
</div>

<script src="<%= ctx %>/assets/js/admin_messages.js"></script>

<jsp:include page="/includes/footer.jsp" />
