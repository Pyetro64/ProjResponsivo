<%@page import="models.UserBean"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/includes/helpers.jsp" %>
<%--
    Cabeçalho único do sistema. Parâmetros opcionais (jsp:param):
      titulo : título da aba do navegador
      area   : "publico" (padrão) | "auth" (login/cadastro/recuperação) | "painel" (conta e administração)
    O rodapé (footer.jsp) fecha o layout certo lendo o atributo de requisição "layoutArea".
--%>
<%
    HttpSession sessaoNavbar = request.getSession(false);
    UserBean usuarioNav = (sessaoNavbar != null) ? (UserBean) sessaoNavbar.getAttribute("user") : null;
    boolean ehAdm = usuarioNav != null && "adm".equalsIgnoreCase(usuarioNav.getUserType());

    String ctx = request.getContextPath();
    String atual = paginaAtual(request.getParameter("p"), request.getRequestURI());
    boolean noPerfil = (request.getRequestURI() != null && request.getRequestURI().endsWith("/profile")) || "profile".equals(atual);

    String area = request.getParameter("area");
    if (area == null || area.isEmpty()) area = "publico";
    request.setAttribute("layoutArea", area);

    String tituloPagina = request.getParameter("titulo");
    String tituloCompleto = (tituloPagina != null && !tituloPagina.trim().isEmpty())
            ? tituloPagina + " | Salon Pet Rose's" : "Salon Pet Rose's | Banho e tosa";

    // Logo: logado vai para o perfil, visitante vai para a home (regra original preservada)
    String homeUrl = (usuarioNav != null) ? ctx + "/profile" : rota(ctx, "home");

    String inicial = "?";
    if (usuarioNav != null && usuarioNav.getName() != null && !usuarioNav.getName().trim().isEmpty()) {
        inicial = usuarioNav.getName().trim().substring(0, 1).toUpperCase();
    }
%>
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title><%= esc(tituloCompleto) %></title>
        <meta name="description" content="Salon Pet Rose's: banho, tosa, hidratação, corte de unha e pacotes para o seu pet. Veja nossa galeria e agende pelo WhatsApp.">
        <meta name="theme-color" content="#fff4f7">
        <script>document.documentElement.classList.add("js");</script>
        <link rel="icon" href="<%= ctx %>/assets/img/favicon.svg" type="image/svg+xml">
        <link rel="icon" href="<%= ctx %>/assets/img/favicon.png" type="image/png">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Bricolage+Grotesque:opsz,wght@12..96,500;12..96,700;12..96,800&family=Figtree:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="<%= ctx %>/assets/css/salon.css">
    </head>
    <body class="area-<%= esc(area) %>">
        <a class="skip" href="#conteudo">Pular para o conteúdo</a>

<% if ("painel".equals(area)) { %>
        <div class="painel">
            <div class="painel__veu" data-fechar-lateral></div>
            <aside class="lateral" id="lateral" aria-label="Menu da conta">
                <a class="marca marca--clara" href="<%= homeUrl %>" aria-label="Salon Pet Rose's">
                    <span class="marca__selo"><%= icone("pata") %></span>
                    <span class="marca__nome">Salon Pet Rose's</span>
                </a>

                <nav class="lateral__nav">
                    <p class="lateral__grupo">Minha conta</p>
                    <a href="<%= ctx %>/profile" class="<%= noPerfil ? "is-atual" : "" %>"><%= icone("usuario") %>Meu perfil</a>
                    <a href="<%= rota(ctx, "contato") %>" class="<%= "contato".equals(atual) ? "is-atual" : "" %>"><%= icone("mail") %>Falar com o salão</a>
                    <a href="<%= rota(ctx, "home") %>"><%= icone("home") %>Ver o site</a>

                    <% if (ehAdm) { %>
                    <p class="lateral__grupo">Administração</p>
                    <a href="<%= rota(ctx, "admin_dashboard") %>" class="<%= "admin_dashboard".equals(atual) ? "is-atual" : "" %>"><%= icone("painel") %>Visão geral</a>
                    <a href="<%= rota(ctx, "admin_users") %>" class="<%= "admin_users".equals(atual) || "admin_edit".equals(atual) ? "is-atual" : "" %>"><%= icone("usuarios") %>Usuários</a>
                    <a href="<%= rota(ctx, "admin_messages") %>" class="<%= "admin_messages".equals(atual) ? "is-atual" : "" %>"><%= icone("mail") %>Mensagens</a>
                    <a href="<%= rota(ctx, "admin_audit_log") %>" class="<%= "admin_audit_log".equals(atual) ? "is-atual" : "" %>"><%= icone("auditoria") %>Auditoria</a>
                    <% } %>
                </nav>

                <% if (usuarioNav != null) { %>
                <div class="lateral__usuario">
                    <span class="avatar" aria-hidden="true"><%= esc(inicial) %></span>
                    <div>
                        <strong><%= esc(usuarioNav.getName()) %></strong>
                        <small><%= ehAdm ? "Administrador" : "Usuário" %></small>
                    </div>
                    <a class="lateral__sair" href="<%= ctx %>/login?action=logout" data-confirmar="Deseja sair do sistema?" aria-label="Sair do sistema"><%= icone("sair") %></a>
                </div>
                <% } %>
            </aside>

            <div class="painel__corpo">
                <header class="painel__topo">
                    <button class="painel__menu" type="button" aria-expanded="false" aria-controls="lateral" data-abrir-lateral>
                        <%= icone("menu") %><span class="sr-only">Abrir menu</span>
                    </button>
                    <span class="painel__titulo"><%= esc(tituloPagina == null ? "" : tituloPagina) %></span>
                    <a class="botao botao--mini botao--contorno" href="<%= rota(ctx, "home") %>">Ver o site</a>
                </header>
                <main id="conteudo" class="painel__main">
<% } else if ("auth".equals(area)) { %>
        <header class="auth-topo">
            <a class="marca" href="<%= homeUrl %>" aria-label="Salon Pet Rose's">
                <span class="marca__selo"><%= icone("pata") %></span>
                <span class="marca__nome">Salon Pet Rose's</span>
            </a>
            <a class="link-voltar" href="<%= rota(ctx, "home") %>"><%= icone("voltar") %>Voltar ao site</a>
        </header>
        <main id="conteudo" class="auth">
<% } else { %>
        <header class="topo" id="topo">
            <div class="topo__barra">
                <a class="marca" href="<%= homeUrl %>" aria-label="Salon Pet Rose's, ir para o início">
                    <span class="marca__selo"><%= icone("pata") %></span>
                    <span class="marca__nome">Salon Pet Rose's</span>
                </a>

                <button class="menu-btn" type="button" aria-expanded="false" aria-controls="menu">
                    <span class="menu-btn__texto">Menu</span>
                    <span class="menu-btn__icone" aria-hidden="true"></span>
                </button>

                <nav class="menu" id="menu" aria-label="Principal">
                    <ul class="menu__lista">
                        <li><a href="<%= rota(ctx, "home") %>" <%= "home".equals(atual) ? "class=\"is-atual\" aria-current=\"page\"" : "" %>>Início</a></li>
                        <li><a href="<%= rota(ctx, "servicos") %>" <%= "servicos".equals(atual) ? "class=\"is-atual\" aria-current=\"page\"" : "" %>>Serviços</a></li>
                        <li><a href="<%= rota(ctx, "portfolio") %>" <%= "portfolio".equals(atual) ? "class=\"is-atual\" aria-current=\"page\"" : "" %>>Galeria</a></li>
                        <li><a href="<%= rota(ctx, "sobre") %>" <%= "sobre".equals(atual) ? "class=\"is-atual\" aria-current=\"page\"" : "" %>>Sobre</a></li>
                        <li><a href="<%= rota(ctx, "ajuda") %>" <%= "ajuda".equals(atual) ? "class=\"is-atual\" aria-current=\"page\"" : "" %>>Ajuda</a></li>
                        <li><a href="<%= rota(ctx, "contato") %>" <%= "contato".equals(atual) ? "class=\"is-atual\" aria-current=\"page\"" : "" %>>Contato</a></li>
                    </ul>
                    <div class="menu__acoes">
                        <% if (usuarioNav == null) { %>
                        <a class="menu__entrar" href="<%= rota(ctx, "login") %>"><%= icone("usuario") %>Entrar</a>
                        <a class="botao botao--mini" href="<%= zap("Ol%C3%A1!%20Quero%20agendar%20um%20hor%C3%A1rio%20para%20o%20meu%20pet.") %>" target="_blank" rel="noopener">Agendar</a>
                        <% } else { %>
                        <a class="menu__entrar" href="<%= ctx %>/profile"><span class="avatar avatar--p" aria-hidden="true"><%= esc(inicial) %></span>Minha conta</a>
                        <% if (ehAdm) { %>
                        <a class="botao botao--mini" href="<%= rota(ctx, "admin_dashboard") %>">Painel</a>
                        <% } %>
                        <a class="botao botao--mini botao--contorno" href="<%= ctx %>/login?action=logout" data-confirmar="Deseja sair do sistema?">Sair</a>
                        <% } %>
                    </div>
                </nav>
            </div>
        </header>

        <main id="conteudo">
<% } %>
