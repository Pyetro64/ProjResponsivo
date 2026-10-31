<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/includes/helpers.jsp" %>
<%
    String ctx = request.getContextPath();
    // {arquivo, categoria, largura, altura, rótulo do botão, texto alternativo}
    String[][] fotos = {
        {"halloween-branco", "halloween", "574", "1279", "cachorrinho branco de pelo cacheado sentado em cenário de Halloween",
            "Cachorrinho branco de pelo cacheado e língua de fora, sentado em cenário roxo de Halloween com fantasminhas e abóboras"},
        {"halloween-laco", "halloween", "738", "1281", "cachorrinho com lacinho no topo da cabeça em cenário de Halloween",
            "Cachorrinho de pelo cinza e caramelo com lacinho colorido na cabeça, posando em cenário de Halloween com teias e abóboras"},
        {"divulgacao-servicos", "divulgacao", "1080", "1350", "arte de divulgação com os serviços e o contato do salão",
            "Arte de divulgação com os serviços do Salon Pet Rose's, endereço, WhatsApp e Instagram"},
        {"halloween-gravata", "halloween", "726", "1279", "cachorrinho de gravata colorida em cenário de Halloween",
            "Cachorrinho de pelo longo com gravata colorida e língua de fora, em cenário de Halloween com cortinas lilás e fantasminhas"},
        {"halloween-salsicha", "halloween", "616", "1281", "cachorrinho salsicha marrom deitado em cenário de Halloween",
            "Cachorrinho salsicha marrom deitado sobre um pano branco, em cenário de Halloween com abóboras douradas"},
        {"divulgacao-logo", "divulgacao", "917", "1600", "arte de divulgação com o logotipo do salão",
            "Arte de divulgação com o logotipo Salon Pet Rose's e produtos de banho em tons pastel"}
    };
%>
<jsp:include page="/includes/header.jsp"><jsp:param name="titulo" value="Galeria"/></jsp:include>
<jsp:include page="/includes/pagina_cab.jsp">
    <jsp:param name="titulo" value="Galeria"/>
    <jsp:param name="descricao" value="Clientes que passaram por aqui e as artes do salão. Toque em uma foto para ampliar."/>
</jsp:include>

<section class="galeria" id="galeria" aria-label="Fotos do salão">
    <div class="galeria__miolo">
        <div class="filtros" role="group" aria-label="Filtrar fotos">
            <button class="filtro is-ativo" type="button" data-filtro="todas" aria-pressed="true">Todas</button>
            <button class="filtro" type="button" data-filtro="halloween" aria-pressed="false">Ensaio de Halloween</button>
            <button class="filtro" type="button" data-filtro="divulgacao" aria-pressed="false">Divulgação</button>
        </div>

        <ul class="mural" id="mural">
            <% for (String[] f : fotos) { %>
            <li class="foto" data-categoria="<%= f[1] %>">
                <button type="button" class="foto__botao" aria-label="Ampliar foto: <%= f[4] %>">
                    <img src="<%= ctx %>/assets/img/<%= f[0] %>.jpg" width="<%= f[2] %>" height="<%= f[3] %>" alt="<%= f[5] %>" loading="lazy">
                </button>
            </li>
            <% } %>
        </ul>
    </div>
</section>

<dialog class="lightbox" id="lightbox" aria-label="Foto ampliada">
    <button class="lightbox__fechar" type="button" aria-label="Fechar">&times;</button>
    <button class="lightbox__nav lightbox__nav--ant" type="button" aria-label="Foto anterior">&#8249;</button>
    <figure class="lightbox__figura">
        <img id="lightbox-img" src="" alt="">
        <figcaption id="lightbox-legenda"></figcaption>
    </figure>
    <button class="lightbox__nav lightbox__nav--prox" type="button" aria-label="Próxima foto">&#8250;</button>
</dialog>

<jsp:include page="/includes/footer.jsp" />
