// ─── Download: edite só aqui a cada versão ───
const DOWNLOAD = {
  url: 'https://github.com/rafaellourenco10/iNeed-App/releases/latest/download/ineed.apk',
  versao: 'v0.5.0',
  beta: true,
  tamanho: '~95 MB',
};

document.querySelectorAll('[data-apk]').forEach((a) => { a.href = DOWNLOAD.url; });
document.querySelectorAll('[data-apk-info]').forEach((el) => {
  el.textContent = `${DOWNLOAD.versao} · Android · ${DOWNLOAD.tamanho}`;
});
document.querySelectorAll('[data-apk-beta]').forEach((el) => { el.hidden = !DOWNLOAD.beta; });

// ─── Abas "Como funciona" (padrão WAI-ARIA, com setas) ───
const abas = [...document.querySelectorAll('[role="tab"]')];

function selecionar(aba, focar) {
  abas.forEach((a) => {
    const ativa = a === aba;
    a.setAttribute('aria-selected', ativa);
    a.tabIndex = ativa ? 0 : -1;
    document.getElementById(a.getAttribute('aria-controls')).hidden = !ativa;
  });
  if (focar) aba.focus();
}

abas.forEach((aba, i) => {
  aba.addEventListener('click', () => selecionar(aba));
  aba.addEventListener('keydown', (e) => {
    const passo = { ArrowRight: 1, ArrowLeft: -1 }[e.key];
    if (!passo) return;
    e.preventDefault();
    selecionar(abas[(i + passo + abas.length) % abas.length], true);
  });
});
if (abas.length) selecionar(abas[0]);

// ─── Checklist do selo: marca item a item quando entra na tela ───
const checklist = document.querySelector('[data-checklist]');
const semMovimento = matchMedia('(prefers-reduced-motion: reduce)').matches;

if (checklist && 'IntersectionObserver' in window && !semMovimento) {
  checklist.classList.add('aguardando');
  const obs = new IntersectionObserver(([entrada]) => {
    if (!entrada.isIntersecting) return;
    checklist.classList.remove('aguardando');
    obs.disconnect();
  }, { threshold: 0.6 });
  obs.observe(checklist);
}
