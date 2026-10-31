<%@page import="models.UserBean"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/includes/helpers.jsp" %>
<%-- O formulário envia para /contato/enviar (ContactServlet) e volta com ?status=success|error --%>
<%
    HttpSession sessaoContato = request.getSession(false);
    UserBean usuarioContato = (sessaoContato != null) ? (UserBean) sessaoContato.getAttribute("user") : null;
    String statusEnvio = request.getParameter("status");
    String ctx = request.getContextPath();
%>
<jsp:include page="/includes/header.jsp"><jsp:param name="titulo" value="Contato"/></jsp:include>
<jsp:include page="/includes/pagina_cab.jsp">
    <jsp:param name="titulo" value="Contato"/>
    <jsp:param name="descricao" value="Chame no WhatsApp para agendar ou deixe um recado com a sua dúvida."/>
</jsp:include>

<div class="secao contato-grade">
    <div class="contato-cartoes">
        <div class="contato-cartao">
            <span class="ficha__icone"><%= icone("zap") %></span>
            <div>
                <h3>WhatsApp</h3>
                <a href="<%= zap(null) %>" target="_blank" rel="noopener">(21) 98831-3692</a>
                <p>Melhor canal para agendar.</p>
            </div>
        </div>
        <div class="contato-cartao">
            <span class="ficha__icone"><%= icone("pin") %></span>
            <div>
                <h3>Endereço</h3>
                <p>Rua Gervásio Ferreira, 27 Loja<br>Em frente ao Campo do Milionário</p>
                <a href="https://www.google.com/maps/search/?api=1&amp;query=Rua+Gerv%C3%A1sio+Ferreira+27+Campo+do+Milion%C3%A1rio" target="_blank" rel="noopener">Ver no mapa</a>
            </div>
        </div>
        <div class="contato-cartao">
            <span class="ficha__icone"><%= icone("instagram") %></span>
            <div>
                <h3>Instagram</h3>
                <a href="https://www.instagram.com/salonpetroses" target="_blank" rel="noopener">@salonpetroses</a>
            </div>
        </div>
    </div>

    <section aria-labelledby="recado-titulo">
        <h2 id="recado-titulo">Deixe um recado</h2>
        <p style="margin:6px 0 18px;color:var(--suave)">Dúvidas, orçamento ou sugestão? Escreva aqui que a gente responde.</p>

        <% if ("success".equals(statusEnvio)) { %>
        <p class="aviso aviso--ok" role="status" style="margin-bottom:16px">Mensagem enviada com sucesso! Entraremos em contato em breve.</p>
        <% } else if ("error".equals(statusEnvio)) { %>
        <p class="aviso aviso--erro" role="alert" style="margin-bottom:16px">Erro ao enviar a mensagem. Tente novamente mais tarde.</p>
        <% } %>

        <form class="formulario formulario--cartao" method="post" action="<%= ctx %>/contato/enviar" data-envio-unico>
            <div class="campo"><label for="c-nome">Nome</label>
                <input id="c-nome" name="name" required maxlength="100" autocomplete="name" value="<%= usuarioContato != null ? esc(usuarioContato.getName()) : "" %>"></div>
            <div class="campo"><label for="c-email">E-mail</label>
                <input id="c-email" type="email" name="email" required maxlength="150" autocomplete="email" value="<%= usuarioContato != null ? esc(usuarioContato.getEmail()) : "" %>"></div>
            <div class="campo campo--larga"><label for="c-assunto">Assunto (opcional)</label>
                <input id="c-assunto" name="subject" maxlength="150" placeholder="Ex.: pacote mensal de banho"></div>
            <div class="campo campo--larga"><label for="c-msg">Mensagem</label>
                <textarea id="c-msg" name="message" rows="5" required minlength="5" maxlength="3000"></textarea></div>
            <button class="botao" type="submit">Enviar recado</button>
        </form>
    </section>
</div>

<jsp:include page="/includes/footer.jsp" />
