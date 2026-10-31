<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/includes/helpers.jsp" %>
<%-- Cabeçalho das páginas públicas. Uso: <jsp:include page="/includes/pagina_cab.jsp"><jsp:param name="titulo" value="..."/><jsp:param name="descricao" value="..."/></jsp:include> --%>
<%
    String ctxCab = request.getContextPath();
    String tituloCab = request.getParameter("titulo");
    String descricaoCab = request.getParameter("descricao");
%>
<div class="pg-cab">
    <div class="pg-cab__miolo">
        <nav class="trilha" aria-label="Você está em">
            <a href="<%= rota(ctxCab, "home") %>">Início</a>
            <span aria-hidden="true">/</span>
            <span><%= esc(tituloCab) %></span>
        </nav>
        <h1><%= esc(tituloCab) %></h1>
        <% if (descricaoCab != null && !descricaoCab.isEmpty()) { %><p><%= esc(descricaoCab) %></p><% } %>
    </div>
</div>
