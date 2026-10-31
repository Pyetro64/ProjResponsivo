/* Comportamentos do site e do painel. Cada bloco só age se encontrar seus elementos na página. */
(function () {
  "use strict";

  /* ---------- Ano no rodapé ---------- */
  var ano = document.getElementById("ano");
  if (ano) ano.textContent = new Date().getFullYear();

  /* ---------- Menu do celular (área pública) ---------- */
  var botaoMenu = document.querySelector(".menu-btn");
  var menu = document.getElementById("menu");
  var larguraDesktop = window.matchMedia("(min-width: 860px)");

  function abrirMenu(abrir) {
    menu.classList.toggle("is-aberto", abrir);
    botaoMenu.setAttribute("aria-expanded", String(abrir));
  }

  if (botaoMenu && menu) {
    botaoMenu.addEventListener("click", function () {
      abrirMenu(botaoMenu.getAttribute("aria-expanded") !== "true");
    });
    menu.addEventListener("click", function (e) {
      if (e.target.closest("a")) abrirMenu(false);
    });
    document.addEventListener("keydown", function (e) {
      if (e.key === "Escape" && menu.classList.contains("is-aberto")) {
        abrirMenu(false);
        botaoMenu.focus();
      }
    });
    larguraDesktop.addEventListener("change", function (e) {
      if (e.matches) abrirMenu(false);
    });
  }

  /* ---------- Menu lateral do painel (celular) ---------- */
  var painel = document.querySelector(".painel");
  var botaoLateral = document.querySelector("[data-abrir-lateral]");

  function lateral(abrir) {
    if (!painel) return;
    painel.classList.toggle("lateral-aberta", abrir);
    if (botaoLateral) botaoLateral.setAttribute("aria-expanded", String(abrir));
  }

  if (painel && botaoLateral) {
    botaoLateral.addEventListener("click", function () {
      lateral(!painel.classList.contains("lateral-aberta"));
    });
    var veu = document.querySelector("[data-fechar-lateral]");
    if (veu) veu.addEventListener("click", function () { lateral(false); });
    document.addEventListener("keydown", function (e) {
      if (e.key === "Escape") lateral(false);
    });
    larguraDesktop.addEventListener("change", function (e) {
      if (e.matches) lateral(false);
    });
  }

  /* ---------- Abas internas (serviços, ajuda) ---------- */
  document.querySelectorAll("[data-abas]").forEach(function (grupo) {
    var abas = Array.prototype.slice.call(grupo.querySelectorAll("[role='tab']"));
    if (!abas.length) return;

    function ativar(aba, foco) {
      abas.forEach(function (a) {
        var on = a === aba;
        a.setAttribute("aria-selected", String(on));
        a.tabIndex = on ? 0 : -1;
        var alvo = document.getElementById(a.getAttribute("aria-controls"));
        if (alvo) alvo.hidden = !on;
      });
      if (foco) aba.focus();
    }

    abas.forEach(function (aba, i) {
      aba.addEventListener("click", function () {
        ativar(aba, false);
        if (history.replaceState) history.replaceState(null, "", "#" + aba.getAttribute("aria-controls"));
      });
      aba.addEventListener("keydown", function (e) {
        var destino = null;
        if (e.key === "ArrowRight") destino = abas[(i + 1) % abas.length];
        if (e.key === "ArrowLeft") destino = abas[(i - 1 + abas.length) % abas.length];
        if (e.key === "Home") destino = abas[0];
        if (e.key === "End") destino = abas[abas.length - 1];
        if (destino) { e.preventDefault(); ativar(destino, true); }
      });
    });

    // Abre a aba indicada na URL (#id) ou a que já vem marcada
    var inicial = abas.filter(function (a) { return "#" + a.getAttribute("aria-controls") === location.hash; })[0]
      || abas.filter(function (a) { return a.getAttribute("aria-selected") === "true"; })[0]
      || abas[0];
    ativar(inicial, false);
  });

  /* ---------- Filtro da galeria ---------- */
  var botoesFiltro = Array.prototype.slice.call(document.querySelectorAll("#galeria [data-filtro]"));
  var itens = Array.prototype.slice.call(document.querySelectorAll("#mural .foto"));

  botoesFiltro.forEach(function (botao) {
    botao.addEventListener("click", function () {
      var filtro = botao.getAttribute("data-filtro");
      botoesFiltro.forEach(function (b) {
        var ativo = b === botao;
        b.classList.toggle("is-ativo", ativo);
        b.setAttribute("aria-pressed", String(ativo));
      });
      itens.forEach(function (item) {
        item.hidden = !(filtro === "todas" || item.getAttribute("data-categoria") === filtro);
      });
    });
  });

  /* ---------- Ampliação das fotos ---------- */
  var caixa = document.getElementById("lightbox");
  if (caixa && typeof caixa.showModal === "function") {
    var imgGrande = document.getElementById("lightbox-img");
    var legenda = document.getElementById("lightbox-legenda");
    var atual = 0;
    var visiveis = [];

    var mostrar = function (indice) {
      atual = (indice + visiveis.length) % visiveis.length;
      var foto = visiveis[atual].querySelector("img");
      imgGrande.src = foto.currentSrc || foto.src;
      imgGrande.alt = foto.alt;
      legenda.textContent = foto.alt;
    };

    var abrirFoto = function (item) {
      visiveis = itens.filter(function (i) { return !i.hidden; });
      mostrar(visiveis.indexOf(item));
      caixa.showModal();
    };

    itens.forEach(function (item) {
      item.querySelector(".foto__botao").addEventListener("click", function () { abrirFoto(item); });
    });

    caixa.querySelector(".lightbox__fechar").addEventListener("click", function () { caixa.close(); });
    caixa.querySelector(".lightbox__nav--ant").addEventListener("click", function () { mostrar(atual - 1); });
    caixa.querySelector(".lightbox__nav--prox").addEventListener("click", function () { mostrar(atual + 1); });
    caixa.addEventListener("click", function (e) { if (e.target === caixa) caixa.close(); });
    caixa.addEventListener("keydown", function (e) {
      if (e.key === "ArrowLeft") mostrar(atual - 1);
      if (e.key === "ArrowRight") mostrar(atual + 1);
    });

    var inicioX = null;
    caixa.addEventListener("touchstart", function (e) { inicioX = e.touches[0].clientX; }, { passive: true });
    caixa.addEventListener("touchend", function (e) {
      if (inicioX === null) return;
      var dif = e.changedTouches[0].clientX - inicioX;
      if (Math.abs(dif) > 50) mostrar(atual + (dif < 0 ? 1 : -1));
      inicioX = null;
    }, { passive: true });
  }

  /* ---------- Perfil: pré-visualização local da foto (nada é enviado até clicar em "Enviar foto") ---------- */
  var campoFoto = document.getElementById("imagem");
  var fotoAtual = document.querySelector(".perfil__foto");
  if (campoFoto && fotoAtual) {
    var fotoOriginal = fotoAtual.getAttribute("src");
    var urlTemp = null;
    campoFoto.addEventListener("change", function () {
      if (urlTemp) { URL.revokeObjectURL(urlTemp); urlTemp = null; }
      var arq = campoFoto.files && campoFoto.files[0];
      if (arq && /^image\//.test(arq.type)) {
        urlTemp = URL.createObjectURL(arq);
        fotoAtual.src = urlTemp;
      } else {
        fotoAtual.src = fotoOriginal;
      }
    });
  }

  /* ---------- Avisos: somem sozinhos depois de 8 segundos ---------- */
  document.querySelectorAll(".aviso").forEach(function (a) {
    setTimeout(function () { a.remove(); }, 8000);
  });

  /* ---------- Confirmação antes de ações destrutivas (links e formulários) ---------- */
  document.addEventListener("submit", function (e) {
    var msg = e.target.getAttribute && e.target.getAttribute("data-confirmar");
    if (msg && !window.confirm(msg)) e.preventDefault();
  });
  document.addEventListener("click", function (e) {
    var a = e.target.closest && e.target.closest("a[data-confirmar]");
    if (a && !window.confirm(a.getAttribute("data-confirmar"))) e.preventDefault();
  });

  /* ---------- Formulários: evita envio duplo (só desativa o botão ao enviar) ---------- */
  document.querySelectorAll("form[data-envio-unico]").forEach(function (f) {
    f.addEventListener("submit", function (e) {
      if (e.defaultPrevented) return;
      var b = f.querySelector("button[type='submit']");
      if (b) setTimeout(function () { b.disabled = true; }, 0);
    });
  });
})();
