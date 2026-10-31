<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/includes/helpers.jsp" %>
<%
    String ctx = request.getContextPath();
%>
<jsp:include page="/includes/header.jsp"><jsp:param name="titulo" value="Recuperar senha"/><jsp:param name="area" value="auth"/></jsp:include>

<div class="auth__arte" aria-hidden="true">
    <img src="<%= ctx %>/assets/img/halloween-branco.jpg" width="574" height="1279" alt="">
</div>

<div class="auth__caixa">
    <h1>Recuperar senha</h1>
    <p class="auth__lead">Informe o e-mail e o telefone cadastrados.</p>

    <%-- Retorno do PasswordResetServlet: atributos "message" e "message_type" ("error" ou outro) --%>
    <% if (request.getAttribute("message") != null) {
           boolean isError = "error".equalsIgnoreCase((String) request.getAttribute("message_type"));
    %>
    <p class="aviso <%= isError ? "aviso--erro" : "aviso--ok" %>" role="<%= isError ? "alert" : "status" %>"><%= esc(request.getAttribute("message")) %></p>
    <% } %>

    <form class="formulario formulario--cartao" method="post" action="<%= ctx %>/recuperar-senha/solicitar">
        <div class="campo campo--larga"><label for="email">E-mail</label>
            <input id="email" type="email" name="email" required autocomplete="email" placeholder="exemplo@email.com"></div>
        <div class="campo campo--larga"><label for="phone">Telefone</label>
            <input id="phone" type="text" name="phone" required inputmode="tel" autocomplete="tel" placeholder="(00) 00000-0000"></div>
        <button class="botao" type="submit">Gerar link de recuperação</button>
        <a class="botao botao--contorno" href="<%= rota(ctx, "login") %>">Voltar</a>
    </form>
</div>

<jsp:include page="/includes/footer.jsp" />
