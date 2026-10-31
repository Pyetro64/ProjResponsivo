/* Painel de mensagens: leitura em janela flutuante + marcação como "lida" via fetch.
   A rota do servlet vem do atributo data-marcar-lida do #modal-mensagem (monta o contextPath no JSP). */
document.addEventListener("DOMContentLoaded", function () {
  "use strict";
  var modal = document.getElementById("modal-mensagem");
  if (!modal) return;
  var rota = modal.getAttribute("data-marcar-lida");

  function abrir(abrir) {
    modal.classList.toggle("is-aberto", abrir);
    modal.setAttribute("aria-hidden", String(!abrir));
  }

  document.querySelectorAll(".btn-ler").forEach(function (botao) {
    botao.addEventListener("click", function () {
      var id = botao.getAttribute("data-id");
      document.getElementById("modal-id").textContent = id;
      document.getElementById("modal-name").textContent = botao.getAttribute("data-name");
      document.getElementById("modal-subject").textContent = botao.getAttribute("data-subject");
      document.getElementById("modal-message").textContent = botao.getAttribute("data-message");
      abrir(true);

      var selo = botao.closest("tr").querySelector(".badge-status");
      if (selo && selo.textContent.trim().toLowerCase() === "pendente") {
        fetch(rota, {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ id: id })
        })
          .then(function (r) { return r.json(); })
          .then(function (dados) {
            if (dados && dados.sucesso) {
              selo.textContent = "LIDA";
              selo.className = "selo selo--lida badge-status";
            }
          })
          .catch(function () { /* mantém o status atual se a rede falhar */ });
      }
    });
  });

  modal.querySelector(".modal-msg__fechar").addEventListener("click", function () { abrir(false); });
  modal.addEventListener("click", function (e) { if (e.target === modal) abrir(false); });
  document.addEventListener("keydown", function (e) { if (e.key === "Escape") abrir(false); });
});
