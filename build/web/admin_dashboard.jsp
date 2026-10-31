<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.List"%>
<%@page import="models.AuditBean"%>
<%@page import="models.AuditDAO"%>
<%@page import="models.MessageBean"%>
<%@page import="models.MessageDAO"%>
<%@page import="models.UserBean"%>
<%@page import="models.UserDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/includes/helpers.jsp" %>
<%-- Página nova: visão geral do painel. Só LÊ dados dos DAOs existentes (getAllUsers, getAllMessages, getLogs). --%>
<%
    // Blindagem em nível de View: só administrador logado (feita ANTES do HTML)
    HttpSession sessaoAdmin = request.getSession(false);
    UserBean adminLogado = (sessaoAdmin != null) ? (UserBean) sessaoAdmin.getAttribute("user") : null;

    if (adminLogado == null || !"adm".equalsIgnoreCase(adminLogado.getUserType())) {
        response.sendRedirect(request.getContextPath() + "/pagina?p=home");
        return;
    }

    String ctx = request.getContextPath();
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");

    List<UserBean> usuarios = new UserDAO().getAllUsers();
    int totalUsuarios = usuarios.size();
    int totalAdm = 0;
    for (UserBean u : usuarios) {
        if ("adm".equalsIgnoreCase(u.getUserType())) totalAdm++;
    }

    MessageDAO msgDao = new MessageDAO();
    List<MessageBean> todasMensagens = msgDao.getAllMessages(null);
    List<MessageBean> pendentes = msgDao.getAllMessages("pendente");

    List<AuditBean> logs = new AuditDAO().getLogs();
    int totalLogs = logs == null ? 0 : logs.size();
%>
<jsp:include page="/includes/header.jsp"><jsp:param name="titulo" value="Visão geral"/><jsp:param name="area" value="painel"/></jsp:include>

<div class="painel__cab">
    <div>
        <h1>Visão geral</h1>
        <p>Olá, <%= esc(adminLogado.getName()) %>. Aqui está o resumo do sistema.</p>
    </div>
</div>

<div class="numeros">
    <a class="numero" href="<%= rota(ctx, "admin_users") %>">
        <span class="ficha__icone"><%= icone("usuarios") %></span>
        <strong><%= totalUsuarios %></strong>
        <span>Usuários cadastrados</span>
    </a>
    <a class="numero numero--lilas" href="<%= rota(ctx, "admin_users") %>">
        <span class="ficha__icone"><%= icone("escudo") %></span>
        <strong><%= totalAdm %></strong>
        <span>Administradores</span>
    </a>
    <a class="numero numero--alerta" href="<%= ctx %>/pagina?p=admin_messages&amp;status=pendente">
        <span class="ficha__icone"><%= icone("relogio") %></span>
        <strong><%= pendentes.size() %></strong>
        <span>Mensagens pendentes</span>
    </a>
    <a class="numero numero--ok" href="<%= rota(ctx, "admin_messages") %>">
        <span class="ficha__icone"><%= icone("mail") %></span>
        <strong><%= todasMensagens.size() %></strong>
        <span>Mensagens no total</span>
    </a>
</div>

<div class="duas-colunas">
    <section class="cartao" aria-labelledby="pend-titulo">
        <h2 id="pend-titulo">Mensagens pendentes</h2>
        <% if (pendentes.isEmpty()) { %>
        <p style="color:var(--suave)">Nenhuma mensagem pendente.</p>
        <% } else { %>
        <ul class="lista-recente">
            <% int n = 0; for (MessageBean m : pendentes) { if (n++ == 5) break; %>
            <li>
                <strong><%= esc(m.getName()) %></strong>
                <span><%= esc(m.getSubject()) %></span>
                <small><%= sdf.format(m.getCreatedAt()) %></small>
            </li>
            <% } %>
        </ul>
        <a class="botao botao--mini botao--contorno" href="<%= ctx %>/pagina?p=admin_messages&amp;status=pendente">Ver pendentes</a>
        <% } %>
    </section>

    <section class="cartao" aria-labelledby="atalhos-adm">
        <h2 id="atalhos-adm">Atalhos</h2>
        <ul class="lista-recente">
            <li><a href="<%= rota(ctx, "admin_users") %>">Gerenciar usuários</a><small>Alterar nível de acesso ou excluir contas</small></li>
            <li><a href="<%= rota(ctx, "admin_messages") %>">Ler mensagens</a><small>Ler, resolver e excluir recados</small></li>
            <li><a href="<%= rota(ctx, "admin_audit_log") %>">Ver auditoria</a><small><%= totalLogs %> registro(s) de ações</small></li>
        </ul>
    </section>
</div>

<jsp:include page="/includes/footer.jsp" />
