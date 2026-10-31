<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/includes/helpers.jsp" %>
<jsp:include page="/includes/header.jsp"><jsp:param name="titulo" value="Página não encontrada"/></jsp:include>

<section class="secao secao--gap" style="max-width:640px;text-align:center;justify-items:center;padding-block:clamp(56px,10vw,120px)">
    <span class="ficha__icone" style="width:72px;height:72px"><%= icone("pata") %></span>
    <h1>Página não encontrada</h1>
    <p style="color:var(--suave)">O endereço que você abriu não existe ou foi removido.</p>
    <p><a class="botao" href="<%= rota(request.getContextPath(), "home") %>">Voltar ao início</a></p>
</section>

<jsp:include page="/includes/footer.jsp" />
