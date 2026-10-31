<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%-- Abas do painel do administrador. Uso: <jsp:include page="/includes/admin_abas.jsp"><jsp:param name="ativa" value="admin_users"/></jsp:include> --%>
<%
    String ativa = request.getParameter("ativa");
    if (ativa == null) ativa = "";
    String ctx = request.getContextPath();
%>
<nav class="abas" aria-label="Painel administrativo">
    <a href="<%= ctx %>/pagina?p=admin_users" class="<%= ativa.equals("admin_users") || ativa.equals("admin_edit") ? "is-atual" : "" %>">Usuários</a>
    <a href="<%= ctx %>/pagina?p=admin_messages" class="<%= ativa.equals("admin_messages") ? "is-atual" : "" %>">Mensagens</a>
    <a href="<%= ctx %>/pagina?p=admin_audit_log" class="<%= ativa.equals("admin_audit_log") ? "is-atual" : "" %>">Auditoria</a>
</nav>
