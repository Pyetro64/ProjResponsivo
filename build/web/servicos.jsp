<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/includes/helpers.jsp" %>
<%
    String ctx = request.getContextPath();
    // {ícone, nome, descrição, texto pronto do WhatsApp (já codificado)}
    String[][] banhoTosa = {
        {"tesoura", "Banho e tosa", "Banho completo e tosa no mesmo atendimento.", "Ol%C3%A1!%20Quero%20saber%20sobre%20banho%20e%20tosa."},
        {"gota", "Banho", "Para manter o pelo limpo e cheiroso.", "Ol%C3%A1!%20Quero%20saber%20sobre%20banho."}
    };
    String[][] extras = {
        {"brilho", "Hidratação", "Cuidado extra para deixar o pelo macio.", "Ol%C3%A1!%20Quero%20saber%20sobre%20hidrata%C3%A7%C3%A3o."},
        {"pata", "Corte de unha", "Unhas aparadas para mais conforto no dia a dia.", "Ol%C3%A1!%20Quero%20saber%20sobre%20corte%20de%20unha."}
    };
    String[][] pacotes = {
        {"presente", "Pacotes e clubinhos", "Pergunte pelas opções no WhatsApp.", "Ol%C3%A1!%20Quero%20saber%20sobre%20pacotes%20e%20clubinhos."}
    };
    String[][][] grupos = { banhoTosa, extras, pacotes };
    String[] ids = { "aba-banho", "aba-extras", "aba-pacotes" };
    String[] nomes = { "Banho e tosa", "Cuidados extras", "Pacotes" };
%>
<jsp:include page="/includes/header.jsp"><jsp:param name="titulo" value="Serviços"/></jsp:include>
<jsp:include page="/includes/pagina_cab.jsp">
    <jsp:param name="titulo" value="Serviços"/>
    <jsp:param name="descricao" value="Tudo o que o seu pet precisa para ficar limpo, cheiroso e confortável."/>
</jsp:include>

<div class="secao servicos-lado">
    <div data-abas>
        <div class="abas" role="tablist" aria-label="Tipos de serviço">
            <% for (int g = 0; g < grupos.length; g++) { %>
            <button class="aba" type="button" role="tab" id="tab-<%= ids[g] %>" aria-controls="<%= ids[g] %>" aria-selected="<%= g == 0 %>" tabindex="<%= g == 0 ? 0 : -1 %>"><%= nomes[g] %></button>
            <% } %>
        </div>

        <% for (int g = 0; g < grupos.length; g++) { %>
        <div class="painel-aba" role="tabpanel" id="<%= ids[g] %>" aria-labelledby="tab-<%= ids[g] %>" <%= g == 0 ? "" : "hidden" %>>
            <div class="servicos-grade">
                <% for (String[] s : grupos[g]) { %>
                <article class="ficha">
                    <span class="ficha__icone"><%= icone(s[0]) %></span>
                    <h3><%= s[1] %></h3>
                    <p><%= s[2] %></p>
                    <a class="ficha__link" href="<%= zap(s[3]) %>" target="_blank" rel="noopener">Perguntar no WhatsApp<%= icone("seta") %></a>
                </article>
                <% } %>
            </div>
        </div>
        <% } %>
    </div>

    <figure>
        <img src="<%= ctx %>/assets/img/divulgacao-servicos.jpg" width="1080" height="1350" alt="Arte de divulgação com a lista de serviços do Salon Pet Rose's, endereço, WhatsApp, Instagram e um cachorrinho caramelo de cabeça inclinada" loading="lazy">
    </figure>
</div>

<jsp:include page="/includes/footer.jsp" />
