<%@page import="java.text.SimpleDateFormat"%>
<%@page import="models.AuditBean"%>
<%@page import="java.util.List"%>
<%@page import="models.AuditDAO"%>
<%@page import="models.UserBean"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/includes/helpers.jsp" %>
<%
    // Blindagem de segurança: só administrador (feita ANTES do HTML)
    HttpSession sessaoAdmin = request.getSession(false);
    UserBean adminLogado = (sessaoAdmin != null) ? (UserBean) sessaoAdmin.getAttribute("user") : null;

    if (adminLogado == null || !"adm".equalsIgnoreCase(adminLogado.getUserType())) {
        response.sendRedirect(request.getContextPath() + "/pagina?p=home");
        return;
    }

    AuditDAO auditDao = new AuditDAO();
    List<AuditBean> listaLogs = auditDao.getLogs();
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
%>
<jsp:include page="/includes/header.jsp"><jsp:param name="titulo" value="Auditoria"/><jsp:param name="area" value="painel"/></jsp:include>

<div class="painel__cab">
    <div>
        <h1>Auditoria</h1>
        <p>Registro das ações feitas no sistema.</p>
    </div>
    <% if (listaLogs != null) { %><span class="total"><%= listaLogs.size() %> registro(s)</span><% } %>
</div>

<% if (listaLogs != null && !listaLogs.isEmpty()) { %>
<div class="tabela-rolagem">
    <table class="tabela tabela--cartoes">
        <thead>
            <tr><th>Data/Hora</th><th>Usuário</th><th>Ação</th><th>Detalhes</th></tr>
        </thead>
        <tbody>
            <% for (AuditBean log : listaLogs) { %>
            <tr>
                <td data-rotulo="Data/Hora"><%= sdf.format(log.getTimestamp()) %></td>
                <td data-rotulo="Usuário"><strong><%= esc(log.getUsername()) %></strong></td>
                <td data-rotulo="Ação"><span class="selo"><%= esc(log.getActionType()) %></span></td>
                <td data-rotulo="Detalhes"><%= esc(log.getDetails()) %></td>
            </tr>
            <% } %>
        </tbody>
    </table>
</div>
<% } else { %>
<div class="vazio"><%= icone("auditoria") %><strong>Nenhum registro de auditoria</strong><span>As ações do sistema aparecerão aqui.</span></div>
<% } %>

<jsp:include page="/includes/footer.jsp" />
