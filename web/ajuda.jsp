<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/includes/helpers.jsp" %>
<%-- Página nova: conteúdo estático de apoio. Não usa servlet nem banco. --%>
<%
    String ctx = request.getContextPath();
    String[][] passos = {
        {"Chame no WhatsApp", "Conte o porte e o pelo do seu pet e qual serviço você quer."},
        {"Combine o dia", "O salão confirma com você o melhor dia para o atendimento."},
        {"Leve o seu pet", "Vá até a Rua Gervásio Ferreira, 27 Loja, em frente ao Campo do Milionário."}
    };
    String[][] duvidas = {
        {"Como agendo um horário?", "Pelo WhatsApp, no número (21) 98831-3692. É o canal mais rápido para combinar serviço e dia."},
        {"Quais serviços o salão oferece?", "Banho e tosa, banho, hidratação, corte de unha e pacotes. A página de serviços mostra cada um."},
        {"Onde o salão fica?", "Na Rua Gervásio Ferreira, 27 Loja, em frente ao Campo do Milionário. Há um link para o mapa na página de contato."},
        {"Preciso de conta para usar o site?", "Não. Para ver serviços, galeria e falar com o salão você não precisa entrar. A conta serve para ter um perfil com foto."},
        {"Esqueci minha senha. E agora?", "Na tela de entrada, use \"Esqueci minha senha\". Você informa e-mail e telefone cadastrados e recebe um código para criar uma nova senha."},
        {"Tenho uma dúvida que não está aqui.", "Deixe um recado na página de contato ou chame no WhatsApp."}
    };
%>
<jsp:include page="/includes/header.jsp"><jsp:param name="titulo" value="Ajuda"/></jsp:include>
<jsp:include page="/includes/pagina_cab.jsp">
    <jsp:param name="titulo" value="Ajuda"/>
    <jsp:param name="descricao" value="Como agendar e respostas para as dúvidas mais comuns."/>
</jsp:include>

<div class="secao" data-abas>
    <div class="abas" role="tablist" aria-label="Temas de ajuda">
        <button class="aba" type="button" role="tab" id="tab-como-agendar" aria-controls="como-agendar" aria-selected="true">Como agendar</button>
        <button class="aba" type="button" role="tab" id="tab-duvidas" aria-controls="duvidas" aria-selected="false" tabindex="-1">Perguntas frequentes</button>
    </div>

    <div class="painel-aba" role="tabpanel" id="como-agendar" aria-labelledby="tab-como-agendar">
        <ol class="passos">
            <% for (String[] p : passos) { %>
            <li class="passo"><h3><%= p[0] %></h3><p><%= p[1] %></p></li>
            <% } %>
        </ol>
        <p style="margin-top:22px"><a class="botao" href="<%= zap("Ol%C3%A1!%20Quero%20agendar%20um%20hor%C3%A1rio%20para%20o%20meu%20pet.") %>" target="_blank" rel="noopener"><%= icone("zap") %>Agendar pelo WhatsApp</a></p>
    </div>

    <div class="painel-aba" role="tabpanel" id="duvidas" aria-labelledby="tab-duvidas" hidden>
        <div class="duvidas">
            <% for (String[] d : duvidas) { %>
            <details class="duvida"><summary><%= d[0] %></summary><p><%= d[1] %></p></details>
            <% } %>
        </div>
        <p style="margin-top:22px"><a class="botao botao--contorno" href="<%= rota(ctx, "contato") %>">Falar com o salão</a></p>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
