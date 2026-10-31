<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/includes/helpers.jsp" %>
<%
    String ctx = request.getContextPath();
%>
<jsp:include page="/includes/header.jsp"><jsp:param name="titulo" value="Sobre"/></jsp:include>
<jsp:include page="/includes/pagina_cab.jsp">
    <jsp:param name="titulo" value="Sobre o Salon Pet Rose's"/>
    <jsp:param name="descricao" value="Um salão de banho e tosa que trata cada cachorrinho como cliente especial."/>
</jsp:include>

<div class="secao sobre-grade">
    <div class="sobre__texto">
        <p>O <strong>Salon Pet Rose's</strong> é um salão de banho e tosa que trata cada cachorrinho como cliente especial: banho, tosa, hidratação, corte de unha e pacotes para o dia a dia do seu pet.</p>
        <p>Estamos na <strong>Rua Gervásio Ferreira, 27 Loja</strong>, em frente ao Campo do Milionário. Para agendar um horário, chame no WhatsApp ou deixe um recado pelo site.</p>
        <div class="hero__acoes">
            <a class="botao" href="<%= zap("Ol%C3%A1!%20Quero%20agendar%20um%20hor%C3%A1rio%20para%20o%20meu%20pet.") %>" target="_blank" rel="noopener"><%= icone("zap") %>Agendar pelo WhatsApp</a>
            <a class="botao botao--contorno" href="<%= rota(ctx, "portfolio") %>">Ver a galeria</a>
        </div>
    </div>

    <aside class="sobre-lado" aria-label="Onde estamos">
        <img src="<%= ctx %>/assets/img/halloween-laco.jpg" width="738" height="1281" alt="Cachorrinho de pelo cinza e caramelo com lacinho colorido na cabeça, posando em cenário de Halloween" loading="lazy">
        <div class="contato-cartao">
            <span class="ficha__icone"><%= icone("pin") %></span>
            <div>
                <h3>Onde fica</h3>
                <p>Rua Gervásio Ferreira, 27 Loja<br>Em frente ao Campo do Milionário</p>
                <a href="https://www.google.com/maps/search/?api=1&amp;query=Rua+Gerv%C3%A1sio+Ferreira+27+Campo+do+Milion%C3%A1rio" target="_blank" rel="noopener">Ver no mapa</a>
            </div>
        </div>
    </aside>
</div>

<jsp:include page="/includes/footer.jsp" />
