<%!
    /** Número do WhatsApp do salão (formato internacional, sem símbolos). */
    private static final String WHATSAPP = "5521988313692";

    /** Escapa texto para exibição segura em HTML (evita XSS e quebra de atributos). */
    private static String esc(Object valor) {
        if (valor == null) return "";
        String s = String.valueOf(valor);
        StringBuilder sb = new StringBuilder(s.length() + 16);
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            switch (c) {
                case '&': sb.append("&amp;"); break;
                case '<': sb.append("&lt;"); break;
                case '>': sb.append("&gt;"); break;
                case '"': sb.append("&quot;"); break;
                case '\'': sb.append("&#39;"); break;
                default: sb.append(c);
            }
        }
        return sb.toString();
    }

    /**
     * Páginas novas (criadas na modernização do frontend) abertas direto pelo .jsp.
     * As páginas originais continuam usando a rota existente /pagina?p=nome.
     * Se o PageServlet aceitar qualquer "p", basta esvaziar este conjunto.
     */
    private static final java.util.Set<String> PAGINAS_NOVAS =
            new java.util.HashSet<String>(java.util.Arrays.asList("ajuda", "admin_dashboard"));

    /** Monta o endereço de uma página do sistema. */
    private static String rota(String ctx, String nome) {
        if (PAGINAS_NOVAS.contains(nome)) return ctx + "/" + nome + ".jsp";
        return ctx + "/pagina?p=" + nome;
    }

    /** Chave da página atual: parâmetro "p" (rota /pagina) ou nome do arquivo .jsp aberto direto. */
    private static String paginaAtual(String p, String uri) {
        if (p != null && !p.isEmpty()) return p;
        if (uri == null) return "";
        int i = uri.lastIndexOf('/');
        String arq = i >= 0 ? uri.substring(i + 1) : uri;
        return arq.endsWith(".jsp") ? arq.substring(0, arq.length() - 4) : arq;
    }

    /** Link de WhatsApp com mensagem pronta (texto já codificado para URL). */
    private static String zap(String textoCodificado) {
        return "https://wa.me/" + WHATSAPP + (textoCodificado == null ? "" : "?text=" + textoCodificado);
    }

    /** Ícones de traço (24x24) usados no menu, painel e cards. */
    private static String icone(String nome) {
        String p;
        switch (nome) {
            case "home": p = "<path d='M3 11.5 12 4l9 7.5'/><path d='M5 10v10h14V10'/><path d='M10 20v-6h4v6'/>"; break;
            case "painel": p = "<rect x='3' y='3' width='7' height='9' rx='1.5'/><rect x='14' y='3' width='7' height='5' rx='1.5'/><rect x='14' y='12' width='7' height='9' rx='1.5'/><rect x='3' y='16' width='7' height='5' rx='1.5'/>"; break;
            case "usuarios": p = "<circle cx='9' cy='8' r='3.5'/><path d='M2.5 20c0-3.6 2.9-6 6.5-6s6.5 2.4 6.5 6'/><circle cx='17.5' cy='9' r='2.5'/><path d='M17 14.2c2.7.2 4.5 2.1 4.5 5.1'/>"; break;
            case "usuario": p = "<circle cx='12' cy='8' r='4'/><path d='M4 21c0-4.2 3.6-7 8-7s8 2.8 8 7'/>"; break;
            case "mail": p = "<rect x='3' y='5' width='18' height='14' rx='2.5'/><path d='m4 7 8 6 8-6'/>"; break;
            case "auditoria": p = "<rect x='5' y='4' width='14' height='17' rx='2.5'/><path d='M9 4.5h6M9 10h6M9 14h6M9 18h3'/>"; break;
            case "sair": p = "<path d='M10 4H6a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h4'/><path d='m15 8 4 4-4 4M19 12H9'/>"; break;
            case "zap": p = "<path d='M4 20l1.4-4.2A8 8 0 1 1 8.2 18.6L4 20z'/>"; break;
            case "pin": p = "<path d='M12 21s7-5.6 7-11a7 7 0 1 0-14 0c0 5.4 7 11 7 11z'/><circle cx='12' cy='10' r='2.5'/>"; break;
            case "imagem": p = "<rect x='3' y='4' width='18' height='16' rx='2.5'/><circle cx='9' cy='10' r='1.8'/><path d='m21 16-5-5-9 9'/>"; break;
            case "check": p = "<path d='m5 12.5 4.5 4.5L19 7.5'/>"; break;
            case "seta": p = "<path d='M5 12h14M13 6l6 6-6 6'/>"; break;
            case "menu": p = "<path d='M4 7h16M4 12h16M4 17h16'/>"; break;
            case "chave": p = "<circle cx='8' cy='15' r='4'/><path d='m11 12 9-9M16 7l3 3'/>"; break;
            case "ajuda": p = "<circle cx='12' cy='12' r='9'/><path d='M9.5 9.5a2.5 2.5 0 1 1 3.5 2.3c-.7.4-1 .9-1 1.7M12 17h.01'/>"; break;
            case "tesoura": p = "<circle cx='6' cy='6' r='3'/><circle cx='6' cy='18' r='3'/><path d='M20 4 8.1 15.9M14.5 14.5 20 20M8.1 8.1 12 12'/>"; break;
            case "brilho": p = "<path d='M12 3l1.9 5.1L19 10l-5.1 1.9L12 17l-1.9-5.1L5 10l5.1-1.9z'/><path d='M19 16v4M17 18h4'/>"; break;
            case "gota": p = "<path d='M12 3s6 6.2 6 10.5a6 6 0 0 1-12 0C6 9.2 12 3 12 3z'/>"; break;
            case "presente": p = "<rect x='3' y='8' width='18' height='4' rx='1'/><path d='M5 12v8h14v-8M12 8v12'/><path d='M12 8c-2.8 0-4.5-1.2-4.5-2.7S9.6 3 12 8zm0 0c2.8 0 4.5-1.2 4.5-2.7S14.4 3 12 8z'/>"; break;
            case "pata": p = "<ellipse cx='12' cy='15.5' rx='4.3' ry='3.6'/><ellipse cx='6' cy='11' rx='1.9' ry='2.5'/><ellipse cx='18' cy='11' rx='1.9' ry='2.5'/><ellipse cx='9.5' cy='6.5' rx='1.9' ry='2.5'/><ellipse cx='14.5' cy='6.5' rx='1.9' ry='2.5'/>"; break;
            case "instagram": p = "<rect x='3' y='3' width='18' height='18' rx='5'/><circle cx='12' cy='12' r='4'/><circle cx='17.5' cy='6.5' r='1'/>"; break;
            case "relogio": p = "<circle cx='12' cy='12' r='9'/><path d='M12 7v5l3 2'/>"; break;
            case "escudo": p = "<path d='M12 3 5 6v5c0 4.6 3 8 7 10 4-2 7-5.4 7-10V6z'/><path d='m9 12 2 2 4-4'/>"; break;
            case "mais": p = "<path d='M12 5v14M5 12h14'/>"; break;
            case "voltar": p = "<path d='M19 12H5M11 6l-6 6 6 6'/>"; break;
            case "camera": p = "<path d='M4 8h3l1.5-2.5h7L17 8h3v11H4z'/><circle cx='12' cy='13' r='3.5'/>"; break;
            default: p = "";
        }
        return "<svg class='icone' viewBox='0 0 24 24' aria-hidden='true' focusable='false' fill='none' stroke='currentColor' stroke-width='1.8' stroke-linecap='round' stroke-linejoin='round'>" + p + "</svg>";
    }
%>
