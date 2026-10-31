<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%-- Seção "Serviços": usada na home e na página /pagina?p=servicos --%>
<%
    String ctx = request.getContextPath();
    String[][] servicos = {
        {"Banho e tosa", "Banho completo e tosa no mesmo atendimento."},
        {"Banho", "Para manter o pelo limpo e cheiroso."},
        {"Hidratação", "Cuidado extra para deixar o pelo macio."},
        {"Corte de unha", "Unhas aparadas para mais conforto no dia a dia."},
        {"Pacotes e clubinhos", "Pergunte pelas opções no WhatsApp."}
    };
%>
<section class="servicos" id="servicos" aria-labelledby="servicos-titulo">
    <div class="servicos__conteudo">
        <h2 id="servicos-titulo">O que fazemos pelo seu pet</h2>
        <ul class="servicos__lista">
            <% for (String[] s : servicos) { %>
            <li class="servico">
                <svg class="servico__pata" viewBox="0 0 64 64" aria-hidden="true"><g fill="currentColor"><ellipse cx="32" cy="41" rx="11" ry="9"/><ellipse cx="18" cy="29" rx="5" ry="6.5"/><ellipse cx="46" cy="29" rx="5" ry="6.5"/><ellipse cx="26" cy="18" rx="5" ry="6.5"/><ellipse cx="38" cy="18" rx="5" ry="6.5"/></g></svg>
                <div>
                    <h3><%= s[0] %></h3>
                    <p><%= s[1] %></p>
                </div>
            </li>
            <% } %>
        </ul>
    </div>

    <figure class="servicos__foto">
        <img src="<%= ctx %>/assets/img/divulgacao-servicos.jpg" width="1080" height="1350" alt="Arte de divulgação com a lista de serviços do Salon Pet Rose's, endereço, WhatsApp, Instagram e um cachorrinho caramelo de cabeça inclinada" loading="lazy">
    </figure>
</section>
