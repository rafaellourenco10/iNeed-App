---
version: 1
slug: "site-index-html"
primary_target: "site/index.html"
related_targets: []
---

Scope: landing page pública do app (site/index.html), modo Persuade. Visitante chega pelo celular, quase sempre para baixar o APK.
Audience: clientes que querem contratar serviço pontual e prestadores que querem anunciar. Ação: baixar o APK (GitHub Releases).
Proof: só fatos do README (sem métricas, depoimentos ou avaliações). Prints das telas ainda não existem: molduras marcadas em img/telas/.
Constraints: estático, sem build, Inter, paleta do app (cores.dart), Beta, só Android.

## Direction contract
THESIS: a confiança é o produto; a página se organiza em torno do selo de verificado, recusando o hero genérico de "app de serviços" com ícones em cards.
OWN-WORLD: campo azul #00288E→#1565C0 dono do topo e da seção do selo; fundo #F8F9FF; laranja #FD761A só na ação de baixar; cards brancos raio 16 com sombra azulada do app; chips de status nas cores reais; ícone verified do Material.
STORY: entende que é um marketplace de serviços, acredita porque vê como o selo é conferido, baixa e instala sem medo do aviso do Android.
FIRST VIEWPORT: mobile: título 2 linhas, subtítulo, botão laranja de largura total com versão/tamanho, link "como instalar"; celular com card de prestador sobreposto logo abaixo. Desktop: texto à esquerda, celular à direita.
FORM: estrutura #5 do ranking (selo como espinha), com ergonomia de download-first (#4); seed 86cb52c0. Assinatura: checklist do validador marcando os 4 itens e o selo aparecendo; trilho de status pendente→em andamento→concluída.
FINISH: unreviewed and undocumented is unfinished; this build ends with the finish review, the verdict, DESIGN.md, and every shipping raster carrying its provenance
