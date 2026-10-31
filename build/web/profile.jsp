<%@page import="java.util.Base64"%>
<%@page import="java.sql.Blob"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="models.Database"%>
<%@page import="java.sql.Connection"%>
<%@page import="models.UserBean"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/includes/helpers.jsp" %>
<%
    // Dados da sessão aberta no login. Redirecionamento feito ANTES de qualquer HTML.
    HttpSession sessao = request.getSession(false);
    UserBean usuarioLogado = (sessao != null) ? (UserBean) sessao.getAttribute("user") : null;

    if (usuarioLogado == null) {
        response.sendRedirect(request.getContextPath() + "/pagina?p=login");
        return;
    }

    String fotoBase64 = null;
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        conn = Database.getConnection();
        // Coluna binária da foto, ligada à FK do usuário
        String sql = "SELECT foto_perfil FROM perfil WHERE user_id = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setInt(1, usuarioLogado.getId());
        rs = stmt.executeQuery();

        if (rs.next()) {
            Blob blob = rs.getBlob("foto_perfil");
            if (blob != null) {
                byte[] imageBytes = blob.getBytes(1, (int) blob.length());
                fotoBase64 = Base64.getEncoder().encodeToString(imageBytes);
            }
        }
    } catch (Exception e) {
        application.log("Erro ao carregar foto do perfil: " + e.getMessage(), e);
    } finally {
        if (rs != null) {
            try { rs.close(); } catch (Exception e) { application.log("Erro ao fechar ResultSet: " + e.getMessage()); }
        }
        if (stmt != null) {
            try { stmt.close(); } catch (Exception e) { application.log("Erro ao fechar Statement: " + e.getMessage()); }
        }
        if (conn != null) {
            try { conn.close(); } catch (Exception e) { application.log("Erro ao fechar Connection: " + e.getMessage()); }
        }
    }

    boolean ehAdmPerfil = "adm".equalsIgnoreCase(usuarioLogado.getUserType());
    String papelPerfil = ehAdmPerfil ? "Administrador" : "Usuário";
    String ctxPerfil = request.getContextPath();
%>
<jsp:include page="/includes/header.jsp"><jsp:param name="titulo" value="Meu perfil"/><jsp:param name="area" value="painel"/></jsp:include>

<div class="painel__cab">
    <div>
        <h1>Meu perfil</h1>
        <p>Seus dados e a foto que aparece na conta.</p>
    </div>
    <% if (ehAdmPerfil) { %>
    <a class="botao botao--mini" href="<%= rota(ctxPerfil, "admin_dashboard") %>"><%= icone("painel") %>Abrir painel</a>
    <% } %>
</div>

<%-- Feedback do upload (atributo "msgPerfil" definido pelo servlet /profile) --%>
<% if (request.getAttribute("msgPerfil") != null) { %>
<p class="aviso aviso--info" role="status"><%= esc(request.getAttribute("msgPerfil")) %></p>
<% } %>

<div class="duas-colunas">
    <section class="perfil-cartao" aria-label="Dados da conta">
        <div class="perfil-cartao__faixa" aria-hidden="true"></div>
        <div class="perfil">
            <% if (fotoBase64 != null) { %>
            <%-- Foto guardada no banco (BLOB), exibida como Base64 --%>
            <img class="perfil__foto" src="data:image/jpeg;base64,<%= fotoBase64 %>" alt="Foto de <%= esc(usuarioLogado.getName()) %>" width="120" height="120">
            <% } else { %>
            <img class="perfil__foto" src="<%= ctxPerfil %>/assets/img/perfil_padrao.png" alt="Foto de perfil padrão" width="120" height="120">
            <% } %>
            <div class="perfil__dados">
                <h2><%= esc(usuarioLogado.getName()) %></h2>
                <p><%= esc(usuarioLogado.getEmail()) %></p>
                <p><span class="selo <%= ehAdmPerfil ? "selo--adm" : "selo--usu" %>"><%= papelPerfil %></span></p>
            </div>
        </div>
    </section>

    <%-- multipart/form-data é obrigatório para enviar o arquivo; campo "imagem" --%>
    <form class="cartao formulario" method="post" action="<%= ctxPerfil %>/profile" enctype="multipart/form-data" data-envio-unico>
        <h2>Trocar foto</h2>
        <div class="campo">
            <label for="imagem">JPG, PNG ou WEBP (até 2 MB)</label>
            <input id="imagem" type="file" name="imagem" accept=".jpg,.jpeg,.png,.webp" required>
        </div>
        <button class="botao botao--mini" type="submit"><%= icone("camera") %>Enviar foto</button>
    </form>
</div>

<section class="cartao" aria-labelledby="seg-titulo">
    <h2 id="seg-titulo">Senha</h2>
    <p style="color:var(--suave)">Para criar uma nova senha, use a recuperação: você informa e-mail e telefone cadastrados e recebe um código.</p>
    <p><a class="botao botao--mini botao--contorno" href="<%= rota(ctxPerfil, "forgot_password") %>"><%= icone("chave") %>Recuperar senha</a></p>
</section>

<jsp:include page="/includes/footer.jsp" />
