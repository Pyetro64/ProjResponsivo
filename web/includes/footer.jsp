<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/includes/helpers.jsp" %>
<%
    String areaLayout = (String) request.getAttribute("layoutArea");
    if (areaLayout == null) areaLayout = "publico";
    String ctxRodape = request.getContextPath();
%>
<% if ("painel".equals(areaLayout)) { %>
                </main>
            </div>
        </div>
<% } else if ("auth".equals(areaLayout)) { %>
        </main>
<% } else { %>
        </main>

        <footer class="rodape">
            <div class="rodape__miolo">
                <div class="rodape__marca">
                    <a class="marca marca--clara" href="<%= rota(ctxRodape, "home") %>">
                        <span class="marca__selo"><%= icone("pata") %></span>
                        <span class="marca__nome">Salon Pet Rose's</span>
                    </a>
                    <p>Banho, tosa, hidratação e corte de unha com carinho para cada cachorrinho.</p>
                </div>
                <nav class="rodape__col" aria-label="Páginas do site">
                    <h2>Navegar</h2>
                    <a href="<%= rota(ctxRodape, "servicos") %>">Serviços</a>
                    <a href="<%= rota(ctxRodape, "portfolio") %>">Galeria</a>
                    <a href="<%= rota(ctxRodape, "sobre") %>">Sobre</a>
                    <a href="<%= rota(ctxRodape, "ajuda") %>">Ajuda</a>
                    <a href="<%= rota(ctxRodape, "contato") %>">Contato</a>
                </nav>
                <div class="rodape__col">
                    <h2>Fale com a gente</h2>
                    <a href="<%= zap(null) %>" target="_blank" rel="noopener">WhatsApp (21) 98831-3692</a>
                    <a href="https://www.instagram.com/salonpetroses" target="_blank" rel="noopener">Instagram @salonpetroses</a>
                    <p>Rua Gervásio Ferreira, 27 Loja<br>Em frente ao Campo do Milionário</p>
                </div>
            </div>
            <p class="rodape__copia">&copy; <span id="ano">2026</span> Salon Pet Rose's. Todos os direitos reservados.</p>
        </footer>
<% } %>

        <script src="<%= ctxRodape %>/assets/js/salon.js"></script>
    </body>
</html>
