<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/includes/helpers.jsp" %>
<%
    String ctx = request.getContextPath();
%>
<jsp:include page="/includes/header.jsp"><jsp:param name="titulo" value="Nova senha"/><jsp:param name="area" value="auth"/></jsp:include>

<div class="auth__arte" aria-hidden="true">
    <img src="<%= ctx %>/assets/img/halloween-laco.jpg" width="738" height="1281" alt="">
</div>

<div class="auth__caixa">
    <h1>Definir nova senha</h1>
    <p class="auth__lead">Digite o código de 6 números e escolha a nova senha.</p>

    <% if (request.getAttribute("message") != null) {
           boolean isError = "error".equalsIgnoreCase((String) request.getAttribute("message_type"));
    %>
    <p class="aviso <%= isError ? "aviso--erro" : "aviso--ok" %>" role="<%= isError ? "alert" : "status" %>"><%= esc(request.getAttribute("message")) %></p>
    <% } %>

    <%-- POST para /recuperar-senha/alterar: token, new_password, confirm_password --%>
    <form class="formulario formulario--cartao" method="post" action="<%= ctx %>/recuperar-senha/alterar">
        <div class="campo campo--larga campo--codigo"><label for="token">Código de verificação (6 números)</label>
            <input id="token" type="text" name="token" pattern="\d{6}" maxlength="6" inputmode="numeric" placeholder="123456" required autocomplete="off"></div>
        <div class="campo campo--larga"><label for="new_password">Nova senha</label>
            <input id="new_password" type="password" name="new_password" required minlength="6" autocomplete="new-password" placeholder="Mínimo 6 caracteres"></div>
        <div class="campo campo--larga"><label for="confirm_password">Confirme a nova senha</label>
            <input id="confirm_password" type="password" name="confirm_password" required minlength="6" autocomplete="new-password" placeholder="Repita a nova senha"></div>
        <button class="botao" type="submit">Salvar nova senha</button>
    </form>
</div>

<jsp:include page="/includes/footer.jsp" />
