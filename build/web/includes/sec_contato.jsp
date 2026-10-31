<%@page import="models.UserBean"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/includes/helpers.jsp" %>
<%-- Seção "Contato" + formulário "Deixe um recado" (POST /contato/enviar, ContactServlet) --%>
<%
    HttpSession sessaoContato = request.getSession(false);
    UserBean usuarioContato = (sessaoContato != null) ? (UserBean) sessaoContato.getAttribute("user") : null;
    String statusEnvio = request.getParameter("status");
    String ctx = request.getContextPath();
%>
<section class="contato" id="contato" aria-labelledby="contato-titulo">
    <div class="contato__miolo">
        <h2 id="contato-titulo">Agende o horário do seu pet</h2>
        <p class="contato__lead">Chame no WhatsApp para combinar o serviço e o melhor dia.</p>

        <dl class="contato__dados">
            <div>
                <dt>Endereço</dt>
                <dd>Rua Gervásio Ferreira, 27 Loja<br>Em frente ao Campo do Milionário</dd>
            </div>
            <div>
                <dt>WhatsApp</dt>
                <dd><a href="https://wa.me/<%= WHATSAPP %>" target="_blank" rel="noopener">(21) 98831-3692</a></dd>
            </div>
            <div>
                <dt>Instagram</dt>
                <dd><a href="https://www.instagram.com/salonpetroses" target="_blank" rel="noopener">@salonpetroses</a></dd>
            </div>
        </dl>

        <div class="contato__acoes">
            <a class="botao" href="https://wa.me/<%= WHATSAPP %>" target="_blank" rel="noopener">Chamar no WhatsApp</a>
            <a class="botao botao--contorno" href="https://www.google.com/maps/search/?api=1&amp;query=Rua+Gerv%C3%A1sio+Ferreira+27+Campo+do+Milion%C3%A1rio" target="_blank" rel="noopener">Ver no mapa</a>
        </div>
    </div>
</section>

<section class="recado" id="recado" aria-labelledby="recado-titulo">
    <div class="recado__miolo">
        <h2 id="recado-titulo">Deixe um recado</h2>
        <p class="recado__lead">Dúvidas, orçamento ou sugestão? Escreva aqui que a gente responde.</p>

        <% if ("success".equals(statusEnvio)) { %>
        <p class="aviso aviso--ok aviso--pagina" role="status">Mensagem enviada com sucesso! Entraremos em contato em breve.</p>
        <% } else if ("error".equals(statusEnvio)) { %>
        <p class="aviso aviso--erro aviso--pagina" role="alert">Erro ao enviar a mensagem. Tente novamente mais tarde.</p>
        <% } %>

        <form class="formulario" method="post" action="<%= ctx %>/contato/enviar">
            <div class="campo"><label for="c-nome">Nome</label>
                <input id="c-nome" name="name" required maxlength="100" value="<%= usuarioContato != null ? esc(usuarioContato.getName()) : "" %>"></div>
            <div class="campo"><label for="c-email">E-mail</label>
                <input id="c-email" type="email" name="email" required maxlength="150" value="<%= usuarioContato != null ? esc(usuarioContato.getEmail()) : "" %>"></div>
            <div class="campo campo--larga"><label for="c-assunto">Assunto (opcional)</label>
                <input id="c-assunto" name="subject" maxlength="150" placeholder="Ex.: pacote mensal de banho"></div>
            <div class="campo campo--larga"><label for="c-msg">Mensagem</label>
                <textarea id="c-msg" name="message" rows="4" required minlength="5" maxlength="3000"></textarea></div>
            <button class="botao" type="submit">Enviar recado</button>
        </form>
    </div>
</section>
