<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/includes/helpers.jsp" %>
<%
    String ctx = request.getContextPath();
%>
<jsp:include page="/includes/header.jsp"><jsp:param name="titulo" value=""/></jsp:include>

<section class="hero" id="inicio">
    <div class="hero__texto">
        <h1>Banho e tosa feitos com carinho para o seu pet</h1>
        <p class="hero__lead">Banho, tosa, hidratação e corte de unha em um salão que trata cada cachorrinho como cliente especial.</p>
        <div class="hero__acoes">
            <a class="botao" href="<%= zap("Ol%C3%A1!%20Quero%20agendar%20um%20hor%C3%A1rio%20para%20o%20meu%20pet.") %>" target="_blank" rel="noopener"><%= icone("zap") %>Agendar pelo WhatsApp</a>
            <a class="botao botao--contorno" href="<%= rota(ctx, "servicos") %>">Ver serviços</a>
        </div>
        <p class="hero__local"><%= icone("pin") %><span>Rua Gervásio Ferreira, 27 Loja, em frente ao Campo do Milionário</span></p>
    </div>

    <div class="hero__cena">
        <figure class="hero__arco">
            <img src="<%= ctx %>/assets/img/divulgacao-logo.jpg" width="917" height="1600" alt="Arte de divulgação do Salon Pet Rose's com o logotipo cor-de-rosa e lilás, coroa dourada, tesoura e produtos de banho em tons pastel" fetchpriority="high">
        </figure>
        <aside class="comanda" aria-label="Resumo do atendimento">
            <h2>Atendimento do dia</h2>
            <ul>
                <li><%= icone("check") %>Banho</li>
                <li><%= icone("check") %>Tosa</li>
                <li><%= icone("check") %>Hidratação</li>
                <li><%= icone("check") %>Corte de unha</li>
            </ul>
            <p>Horários combinados pelo WhatsApp.</p>
        </aside>
    </div>
</section>

<section class="secao secao--gap" aria-labelledby="atalhos-titulo">
    <h2 id="atalhos-titulo">Por onde começar</h2>
    <div class="atalhos">
        <a class="atalho atalho--servicos" href="<%= rota(ctx, "servicos") %>">
            <%= icone("tesoura") %>
            <h3>Serviços</h3>
            <p>Banho, tosa, hidratação, unhas e pacotes. Veja o que cada atendimento inclui.</p>
        </a>
        <a class="atalho atalho--galeria" href="<%= rota(ctx, "portfolio") %>">
            <img src="<%= ctx %>/assets/img/halloween-gravata.jpg" width="726" height="1279" alt="" loading="lazy">
            <%= icone("imagem") %>
            <h3>Galeria</h3>
            <p>Clientes que passaram por aqui.</p>
        </a>
        <a class="atalho atalho--ajuda" href="<%= rota(ctx, "ajuda") %>">
            <%= icone("ajuda") %>
            <h3>Ajuda</h3>
            <p>Como agendar e dúvidas comuns.</p>
        </a>
        <a class="atalho atalho--contato" href="<%= rota(ctx, "contato") %>">
            <%= icone("mail") %>
            <h3>Contato</h3>
            <p>Endereço, WhatsApp e recados.</p>
        </a>
    </div>
</section>

<div class="faixa">
    <div class="faixa__miolo">
        <div>
            <h2>Vamos marcar o horário do seu pet?</h2>
            <p>Chame no WhatsApp para combinar o serviço e o melhor dia.</p>
        </div>
        <a class="botao botao--claro" href="<%= zap("Ol%C3%A1!%20Quero%20agendar%20um%20hor%C3%A1rio%20para%20o%20meu%20pet.") %>" target="_blank" rel="noopener"><%= icone("zap") %>Chamar no WhatsApp</a>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
