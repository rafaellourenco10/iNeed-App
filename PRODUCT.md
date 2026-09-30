# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

## Users
- **Clientes e prestadores (app Flutter, Android/iOS):** clientes contratam serviços sob demanda; prestadores anunciam uma especialidade (eletricista, encanador…) com valor/hora.
- **Validadores (equipe iNeed, 1–3 pessoas):** revisam no computador (notebook/desktop), alguns envios por dia, os documentos que prestadores enviam para ganhar o selo de verificado.

## Product Purpose
Marketplace brasileiro de serviços sob demanda (v0.5.0 Beta). Conecta clientes a prestadores locais. O selo de verificado existe para gerar confiança na hora de contratar.

## Operating Context
- App Flutter fala só com a API Node/Express (Render); Firestore via Admin SDK. Sem plano Blaze: imagens de verificação ficam em base64 no Firestore.
- Painel de validação: página única `backend/public/admin.html`, servida em `/admin`, sem build. Acesso por e-mail listado em `ADMIN_EMAILS`.
- Prestador envia duas fotos: documento com foto (RG/CNH) e comprovante de qualificação (certificado, diploma, registro).

## Capabilities and Constraints
- Checklist obrigatório do validador: nome do documento = nome do cadastro; foto legível e documento válido; comprovante bate com a especialidade; comprovante em nome do prestador.
- Recusa exige motivo, que o prestador vê no app e numa notificação. Pode reenviar após recusa.
- Documentos pessoais (LGPD): exibir só para validadores autenticados; nada de cache público.
- Idioma: português do Brasil.

## Brand Commitments
- Nome: iNeed. Cor primária do app: azul `#00288E` (gradiente até `#1565C0`).
- Painel de validação segue o padrão de mercado de ferramentas de revisão KYC (Sumsub / Onfido), por escolha do usuário.

## Evidence on Hand
Sem depoimentos, métricas ou clientes publicáveis. Não inventar números.

## Product Principles
1. Confiança acima de volume: melhor recusar com motivo claro que aprovar na dúvida.
2. O validador decide com tudo à vista — documento, dados do cadastro e checklist na mesma tela.
3. Todo "não" explica o porquê e o caminho para resolver.
