# Salon Pet Rose's — Frontend (pasta `web`)

Site e painel do Salon Pet Rose's, em **JSP + HTML + CSS + JS puro** (sem frameworks). Este pacote contém **somente a camada de apresentação**: nenhum Servlet, DAO, Bean, classe Java ou banco de dados foi alterado. Rotas e nomes de campos de formulário foram preservados.

> Status: entrega parcial nº 1. Ainda **não testado em Tomcat** — veja `PENDENCIAS.md`.

## Requisitos
- Java e Apache Tomcat (9 ou 10+; `helpers.jsp` não usa `javax`/`jakarta` de propósito)
- MySQL e o back-end do projeto (pacote `models`, servlets e DAOs — fora deste ZIP)
- Bibliotecas em `web/util/`: `mysql-connector-j`, `jbcrypt`, `jakarta.mail`, `jakarta.activation-api`
- MailHog (`web/util/MailHog_windows_amd64.exe`) para testar o envio de e-mails localmente

## Como instalar
1. Copie a pasta `web` deste ZIP sobre a anterior (substituição integral).
2. Faça *Clean & Build* e execute no Tomcat. O contexto está em `META-INF/context.xml` (`/projresponsivo`).
3. Se usar e-mail (recuperação de senha, contato), inicie o MailHog.

## Estrutura
```
web/
├── home.jsp, servicos.jsp, portfolio.jsp, sobre.jsp, ajuda.jsp, contato.jsp, 404.jsp   páginas públicas
├── login.jsp, register.jsp, forgot_password.jsp, reset_password.jsp                    autenticação
├── profile.jsp                                                                         perfil do usuário
├── admin_dashboard.jsp, admin_users.jsp, admin_edit.jsp,
│   admin_messages.jsp, admin_audit_log.jsp                                             administração
├── includes/
│   ├── header.jsp      cabeçalho + escolha do layout (parâmetro `area`)
│   ├── footer.jsp      rodapé
│   ├── helpers.jsp     funções de apoio: esc(), rota(), icone()
│   └── pagina_cab.jsp  cabeçalho padrão das páginas públicas
├── assets/
│   ├── css/salon.css   todo o visual
│   ├── js/salon.js     comportamentos do site e do painel
│   ├── js/admin_messages.js   modal de leitura de mensagens
│   └── img/            logos, fotos e favicon
├── util/               JARs, MailHog e fotos de perfil de exemplo
└── META-INF/context.xml
```

## Layouts
Definidos pelo parâmetro `area` do `header.jsp`:

| `area` | Uso | Aparência |
|---|---|---|
| `publico` (padrão) | páginas públicas | barra superior e rodapé em 3 colunas |
| `auth` | login, cadastro, recuperação de senha | duas colunas (foto + formulário) |
| `painel` | perfil e administração | menu lateral escuro (gaveta no celular) |

## Rotas
- Páginas originais: `/pagina?p=nome` (resolvidas pelo `PageServlet`).
- `ajuda` e `admin_dashboard` abrem direto por `/ajuda.jsp` e `/admin_dashboard.jsp`, controlado pelo conjunto `PAGINAS_NOVAS` em `includes/helpers.jsp`. Se o servlet aceitar qualquer valor de `p`, esvazie esse conjunto.
- Formulários enviam para: `/login`, `/registrar`, `/contato/enviar`, `/recuperar-senha/solicitar`, `/recuperar-senha/alterar`, `/profile` (upload, campo `imagem`) e `/admin/atualizar`.
- Parâmetros de retorno lidos pelo visual: `status`, `msg`, `msgPerfil`, `message`, `message_type`, `error`, `login_error`.
- O painel é protegido pela checagem de sessão dentro de cada JSP.

## Recursos visuais
- Identidade rosa/lilás/turquesa/amarelo, com ameixa e dourado do tema Halloween; fontes Bricolage Grotesque + Figtree (Google Fonts, com fallback para fonte do sistema).
- Responsivo (celular, tablet, desktop), foco visível, `prefers-reduced-motion` respeitado.
- Abas acessíveis (setas, Home, End; abrem por `#id`), perguntas frequentes em `<details>`, galeria com filtro, lightbox e swipe.
- Tabelas que viram cartões no celular; confirmação com `data-confirmar`; avisos somem em 8 s; botão de envio desativado após o submit (`data-envio-unico`).
- Pré-visualização local da foto antes do envio, no perfil.
- "Visão geral" do painel apenas **lê** dados de `UserDAO.getAllUsers()`, `MessageDAO.getAllMessages(...)` e `AuditDAO.getLogs()`.

## Testes sugeridos
Percorra Início, Serviços, Galeria, Sobre, Ajuda, Contato, Entrar, Criar conta e Recuperar senha. Depois entre como `usu` (perfil) e como `adm` (painel, visão geral, usuários, mensagens, auditoria). Teste em 360 px, 768 px e 1280 px.

## Pendências
Veja `PENDENCIAS.md` (teste em Tomcat, revisão do texto da Ajuda, página de pacotes, fontes auto-hospedadas).
