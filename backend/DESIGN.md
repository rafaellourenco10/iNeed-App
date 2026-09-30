---
name: iNeed Verificações
description: Painel de validação de prestadores (/admin), ferramenta de revisão KYC em arquivo único.
colors:
  azul: "#00288E"
  azul-hover: "#0a36b0"
  azul-suave: "#e8edfa"
  fundo: "#f3f4f7"
  painel: "#ffffff"
  painel-2: "#f8f9fb"
  linha: "#e3e5eb"
  linha-forte: "#cfd3dc"
  texto: "#151821"
  texto-2: "#505767"
  texto-3: "#5f6676"
  lona: "#1d2027"
  lona-2: "#2a2e37"
  lona-linha: "#3a3f4a"
  lona-texto: "#c5c9d3"
  pendente: "#b45309"
  pendente-bg: "#fdf3e2"
  ok: "#15803d"
  ok-bg: "#e5f5ea"
  erro: "#c0262d"
  erro-bg: "#fbe9ea"
typography:
  headline:
    fontFamily: "ui-sans-serif, system-ui, -apple-system, Segoe UI, Roboto, Helvetica Neue, Arial, sans-serif"
    fontSize: "20px"
    fontWeight: 700
    letterSpacing: "-0.01em"
  title:
    fontFamily: "ui-sans-serif, system-ui, -apple-system, Segoe UI, Roboto, Helvetica Neue, Arial, sans-serif"
    fontSize: "17px"
    fontWeight: 700
    lineHeight: 1.25
    letterSpacing: "-0.01em"
  body:
    fontFamily: "ui-sans-serif, system-ui, -apple-system, Segoe UI, Roboto, Helvetica Neue, Arial, sans-serif"
    fontSize: "14px"
    fontWeight: 400
    lineHeight: 1.45
    fontFeature: "tnum"
  body-sm:
    fontFamily: "ui-sans-serif, system-ui, -apple-system, Segoe UI, Roboto, Helvetica Neue, Arial, sans-serif"
    fontSize: "13px"
    fontWeight: 400
    lineHeight: 1.45
  label:
    fontFamily: "ui-sans-serif, system-ui, -apple-system, Segoe UI, Roboto, Helvetica Neue, Arial, sans-serif"
    fontSize: "12px"
    fontWeight: 600
  mono:
    fontFamily: "ui-monospace, Cascadia Mono, Consolas, monospace"
    fontSize: "12px"
    fontWeight: 400
rounded:
  xs: "4px"
  sm: "6px"
  md: "8px"
  lg: "12px"
  pill: "99px"
spacing:
  "4": "4px"
  "6": "6px"
  "8": "8px"
  "10": "10px"
  "12": "12px"
  "14": "14px"
  "16": "16px"
  "20": "20px"
components:
  button-primary:
    backgroundColor: "{colors.azul}"
    textColor: "{colors.painel}"
    rounded: "{rounded.md}"
    padding: "0 14px"
    height: "36px"
  button-primary-hover:
    backgroundColor: "{colors.azul-hover}"
  button-secondary:
    backgroundColor: "{colors.painel}"
    textColor: "{colors.texto}"
    rounded: "{rounded.md}"
    padding: "0 14px"
    height: "36px"
  button-secondary-hover:
    backgroundColor: "{colors.painel-2}"
  button-danger:
    backgroundColor: "{colors.erro}"
    textColor: "{colors.painel}"
    rounded: "{rounded.md}"
    padding: "0 14px"
    height: "36px"
  button-danger-secondary:
    backgroundColor: "{colors.painel}"
    textColor: "{colors.erro}"
    rounded: "{rounded.md}"
    padding: "0 14px"
    height: "36px"
  input:
    backgroundColor: "{colors.painel}"
    textColor: "{colors.texto}"
    rounded: "{rounded.md}"
    padding: "0 12px"
    height: "40px"
  queue-tab-selected:
    backgroundColor: "{colors.painel}"
    textColor: "{colors.texto}"
    rounded: "{rounded.sm}"
    height: "30px"
  queue-item-selected:
    backgroundColor: "{colors.azul-suave}"
    textColor: "{colors.azul}"
    rounded: "{rounded.md}"
    padding: "10px"
  reason-chip:
    backgroundColor: "{colors.painel}"
    textColor: "{colors.texto-2}"
    rounded: "{rounded.pill}"
    padding: "0 11px"
    height: "30px"
  reason-chip-selected:
    backgroundColor: "{colors.erro-bg}"
    textColor: "{colors.erro}"
  status-badge-pendente:
    backgroundColor: "{colors.pendente-bg}"
    textColor: "{colors.pendente}"
    rounded: "{rounded.pill}"
    padding: "2px 8px"
  status-badge-aprovado:
    backgroundColor: "{colors.ok-bg}"
    textColor: "{colors.ok}"
    rounded: "{rounded.pill}"
    padding: "2px 8px"
  status-badge-recusado:
    backgroundColor: "{colors.erro-bg}"
    textColor: "{colors.erro}"
    rounded: "{rounded.pill}"
    padding: "2px 8px"
  doc-tab:
    textColor: "{colors.lona-texto}"
    rounded: "{rounded.md}"
    height: "40px"
  doc-tab-selected:
    backgroundColor: "{colors.painel}"
    textColor: "{colors.texto}"
---

# Design System: iNeed Verificações

Escopo: só o painel web `backend/public/admin.html`. O app Flutter na raiz do repositório tem outro sistema visual e não segue este arquivo.

## Overview

**Creative North Star: "A Mesa de Luz"**

Uma bancada de conferência: moldura clara e silenciosa em cinza frio, e no centro uma lona grafite onde o documento repousa como num negatoscópio. O documento é o protagonista; a decisão fica ao lado, nunca em cima. Segue o cânone das ferramentas de revisão KYC (Sumsub / Onfido), sem reinvenção.

A densidade é de ferramenta de trabalho: texto base de 14px, controles de 30 a 40px, filetes de 1px no lugar de sombras, números tabulares em tudo. O azul iNeed aparece só onde há ação primária ou seleção; o resto da cor é semântico (âmbar pendente, verde aprovado, vermelho recusado).

**Key Characteristics:**
- Três colunas fixas: fila, visor, decisão.
- Moldura clara, visor escuro.
- Azul restrito a ação primária e seleção.
- Filetes de 1px e raio de 8px como gramática de forma.
- Fonte do sistema, numerais tabulares, ícones SVG de traço.

## Colors

Neutros frios quase sem croma, um azul de marca profundo e três pares semânticos (tom forte + fundo lavado).

### Primary
- **Azul iNeed Profundo** (azul): botão Aprovar/Entrar, anel de foco, avatar e nome do item selecionado na fila, ícone do estado vazio.
- **Azul Aceso** (azul-hover): só o hover do botão primário.
- **Névoa Azul** (azul-suave): fundo do item selecionado, halo de foco dos campos (3px), seleção de texto.

### Neutral
- **Cinza Gelo** (fundo): fundo da página, trilho das abas da fila, fundo do estado vazio.
- **Branco de Trabalho** (painel): superfícies de trabalho (fila, decisão, cartões, campos).
- **Branco Enevoado** (painel-2): hover de linhas e botões secundários, campo de busca em repouso.
- **Filete** (linha) e **Filete Firme** (linha-forte): divisórias de coluna e bordas de campos/botões, respectivamente.
- **Tinta Grafite** (texto), **Ardósia** (texto-2), **Ardósia Clara** (texto-3): texto principal, secundário e metadados.
- **Lona Grafite** (lona), **Lona Elevada** (lona-2), **Borda de Lona** (lona-linha), **Giz** (lona-texto): o mundo escuro do visor: fundo, barra de ferramentas/hover, bordas e texto sobre a lona.

### Semantic
- **Âmbar Pendente** (pendente / pendente-bg), **Verde Aprovado** (ok / ok-bg), **Vermelho Recusado** (erro / erro-bg): selos de status, contador de pendentes, checklist marcado, chips de motivo, alertas e o botão Recusar.

### Named Rules
**The Azul-Só-Para-Agir Rule.** O azul marca ação primária, foco e seleção. Nunca decoração, nunca fundo de seção.

**The Par Semântico Rule.** Status sempre como par: texto no tom forte sobre o fundo lavado da mesma família. Nunca o tom forte como fundo cheio, exceto o botão de recusa confirmada.

## Typography

**Body Font:** fonte do sistema (ui-sans-serif, system-ui, Segoe UI, Roboto…)
**Mono Font:** ui-monospace (Cascadia Mono, Consolas) só para identificadores copiáveis.

**Character:** neutra e utilitária; a hierarquia vem de peso (600/700), não de tamanho.

### Hierarchy
- **Headline** (700, 20px): título do login.
- **Title** (700, 17px, 1.25): nome do prestador no painel de decisão, título do estado vazio.
- **Body** (400, 14px, 1.45, numerais tabulares): texto base.
- **Body-sm** (13px): dados do cadastro, itens do checklist, toasts, alertas.
- **Label** (600, 12px): selos, chips, metadados, dicas; títulos de seção usam 13px/700.
- **Mono** (12px): e-mail/ID copiável.

### Named Rules
**The Peso-Antes-de-Tamanho Rule.** Nenhum tamanho acima de 20px. Para destacar, suba o peso para 600/700.

## Layout

Grade de três colunas em tela cheia sob uma barra superior de 52px: fila 340px, visor flexível (minmax(0,1fr)), decisão 360px. Até 1240px as laterais encolhem para 300px e 320px. Abaixo de 960px vira uma coluna: fila sozinha; ao abrir um envio, visor (45vh) e decisão empilhados, com botão Voltar e rodapé de decisão fixo. Cada coluna rola sozinha; a página não rola no desktop.

Ritmo de espaçamento em passos de 2px entre 4 e 20px; padding interno de painel 14px (fila) e 20px (decisão).

## Elevation & Depth

Plano por padrão. A estrutura vem de filetes de 1px e da troca de tom (cinza gelo, branco, grafite). Sombras existem só em três lugares: o cartão de login, a imagem sobre a lona e o toast.

### Shadow Vocabulary
- **Cartão** (`0 1px 2px rgba(16,24,40,.06), 0 4px 12px rgba(16,24,40,.06)`): cartão de login.
- **Aba ativa** (`0 1px 2px rgba(16,24,40,.1)`): aba selecionada no trilho segmentado.
- **Documento na lona** (`0 12px 40px rgba(0,0,0,.45)`): a imagem sobre o grafite.
- **Toast** (`0 8px 24px rgba(16,24,40,.25)`).

### Named Rules
**The Filete-Não-Sombra Rule.** Colunas e seções se separam com filete de 1px, nunca com sombra.

## Shapes

Raio de 8px em botões, campos, linhas da fila, checklist e alertas; 6px em controles internos (abas, botões de ícone); 12px só no cartão de login; pílula (99px) para selos, contadores e chips; círculo para avatares. Ícones SVG de traço 2px, 16px, pontas arredondadas.

## Components

### Buttons
- **Shape:** 8px, altura 36px (40px em bloco, 32px na barra superior), peso 600, ícone + texto com gap de 8px.
- **Primary:** azul com texto branco; hover azul aceso; desabilitado com opacidade .45 (Aprovar fica desabilitado até os quatro itens do checklist serem marcados).
- **Secondary:** branco com filete firme; hover branco enevoado.
- **Danger / Danger-secondary:** vermelho cheio (confirmar recusa) e contorno vermelho sobre branco (abrir recusa).
- **Ícone:** 32px quadrado, sem fundo em repouso.
- **Focus:** contorno de 2px azul com afastamento de 2px, global.

### Chips
- **Motivo de recusa:** pílula 30px com filete firme; selecionado vira par vermelho (erro-bg, erro, borda rosada).
- **Selo de status:** pílula com ponto de 6px na cor do texto.

### Cards / Containers
- **Checklist:** lista com borda de 1px, raio 8px, linhas separadas por filete; marcado deixa o título verde.
- **Resultado:** bloco no fundo lavado do status, sem borda.

### Inputs / Fields
- **Style:** 40px, filete firme, raio 8px, branco. Busca: 34px sobre branco enevoado com ícone à esquerda.
- **Focus:** borda azul + halo de 3px em névoa azul.

### Navigation
- **Abas da fila:** trilho segmentado cinza gelo; aba ativa em branco com sombra mínima; contador em pílula, âmbar quando há pendentes.
- **Item da fila:** avatar de iniciais 36px, nome 600, especialidade e idade em 12px; selecionado em névoa azul com avatar azul.

### Visor (Signature Component)
Lona grafite com abas de documento (miniatura 44×30 + rótulo; ativa em branco), barra de ferramentas em lona elevada (zoom −/+, ajustar, girar, abrir) e a imagem centrada com sombra profunda e raio de 4px. Transformações em 180ms `cubic-bezier(.2,.8,.2,1)`; arraste sem transição.

## Do's and Don'ts

### Do:
- **Do** manter o documento no centro e a decisão ao lado; nunca em modal sobre a imagem.
- **Do** usar o azul só em ação primária, foco e seleção.
- **Do** expressar status sempre como par tom forte + fundo lavado.
- **Do** separar áreas com filetes de 1px (linha / linha-forte).
- **Do** usar numerais tabulares e ícones SVG de traço inline.
- **Do** respeitar `prefers-reduced-motion` (transições reduzidas a ~0).

### Don't:
- **Don't** montar o painel como grade de cards de admin.
- **Don't** usar sombra para separar colunas ou seções.
- **Don't** passar de 20px em texto nem usar fonte de exibição.