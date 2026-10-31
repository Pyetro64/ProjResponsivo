<%@page import="models.UserBean"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/includes/helpers.jsp" %>
<%
    // Usuário já logado não precisa ver o login: vai para o perfil (feito ANTES do HTML)
    HttpSession sessaoLogin = request.getSession(false);
    UserBean usuarioLogado = (sessaoLogin != null) ? (UserBean) sessaoLogin.getAttribute("user") : null;
    if (usuarioLogado != null) {
        response.sendRedirect(request.getContextPath() + "/profile");
        return;
    }

    // Erro vindo do AuthServlet: Request primeiro, depois Session (e limpa para não repetir no F5)
    String erro = (String) request.getAttribute("login_error");
    if (erro == null && sessaoLogin != null) {
        erro = (String) sessaoLogin.getAttribute("login_error");
        if (erro != null) {
            sessaoLogin.removeAttribute("login_error");
        }
    }
    String emailDigitado = request.getParameter("email");
    String ctx = request.getContextPath();
%>
<jsp:include page="/includes/header.jsp"><jsp:param name="titulo" value="Entrar"/><jsp:param name="area" value="auth"/></jsp:include>

<div class="auth__arte" aria-hidden="true">
    <img src="<%= ctx %>/assets/img/halloween-gravata.jpg" width="726" height="1279" alt="">
</div>

<div class="auth__caixa">
    <h1>Entrar</h1>
    <p class="auth__lead">Acesse a sua conta para ver o perfil e trocar a foto.</p>

    <% if ("registered".equals(request.getParameter("msg"))) { %>
    <p class="aviso aviso--ok" role="status">Registrado com sucesso. Faça login.</p>
    <% } else if ("password_reset".equals(request.getParameter("msg"))) { %>
    <p class="aviso aviso--ok" role="status">Senha redefinida com sucesso! Faça login com a nova senha.</p>
    <% } %>
    <% if (erro != null && !erro.trim().isEmpty()) { %>
    <p class="aviso aviso--erro" role="alert"><%= esc(erro) %></p>
    <% } %>

    <%-- POST para o AuthServlet (/login): campos email e password --%>
    <form class="formulario formulario--cartao" method="post" action="<%= ctx %>/login">
        <div class="campo campo--larga"><label for="email">E-mail</label>
            <input id="email" type="email" name="email" required autocomplete="email" value="<%= esc(emailDigitado) %>"></div>
        <div class="campo campo--larga"><label for="password">Senha</label>
            <input id="password" type="password" name="password" required autocomplete="current-password"></div>
        <button class="botao" type="submit">Entrar</button>
        <div class="auth__links">
            <a href="<%= rota(ctx, "forgot_password") %>">Esqueci minha senha</a>
            <a href="<%= rota(ctx, "register") %>">Criar conta</a>
        </div>
    </form>
</div>

<jsp:include page="/includes/footer.jsp" />
