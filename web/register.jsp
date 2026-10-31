<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/includes/helpers.jsp" %>
<%
    String ctx = request.getContextPath();
%>
<jsp:include page="/includes/header.jsp"><jsp:param name="titulo" value="Cadastro"/><jsp:param name="area" value="auth"/></jsp:include>

<div class="auth__arte" aria-hidden="true">
    <img src="<%= ctx %>/assets/img/halloween-salsicha.jpg" width="616" height="1281" alt="">
</div>

<div class="auth__caixa">
    <h1>Criar conta</h1>
    <p class="auth__lead">Leva menos de um minuto. Você só precisa de nome, e-mail, telefone e senha.</p>

    <%-- Erro de cadastro vindo do servlet (atributo "error" do Request) --%>
    <% if (request.getAttribute("error") != null) { %>
    <p class="aviso aviso--erro" role="alert"><%= esc(request.getAttribute("error")) %></p>
    <% } %>

    <%-- POST para o endpoint /registrar: username, email, phone, password --%>
    <form class="formulario formulario--cartao" method="post" action="<%= ctx %>/registrar">
        <div class="campo campo--larga"><label for="username">Nome</label>
            <input id="username" type="text" name="username" required minlength="2" maxlength="100" autocomplete="name" value="<%= esc(request.getParameter("username")) %>"></div>
        <div class="campo campo--larga"><label for="email">E-mail</label>
            <input id="email" type="email" name="email" required autocomplete="email" value="<%= esc(request.getParameter("email")) %>"></div>
        <div class="campo campo--larga"><label for="phone">Telefone (com DDD)</label>
            <input id="phone" type="text" name="phone" inputmode="tel" required autocomplete="tel" placeholder="(21) 90000-0000" value="<%= esc(request.getParameter("phone")) %>"></div>
        <div class="campo campo--larga"><label for="password">Senha</label>
            <input id="password" type="password" name="password" required autocomplete="new-password"></div>
        <button class="botao" type="submit">Cadastrar</button>
        <p class="auth__rodape">Já tem conta? <a href="<%= rota(ctx, "login") %>">Entrar</a></p>
    </form>
</div>

<jsp:include page="/includes/footer.jsp" />
