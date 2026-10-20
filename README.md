# iNeed

<p align="center">
  <a href="https://ineed-app.netlify.app"><img src="https://img.shields.io/badge/%F0%9F%8C%90%20ACESSAR%20O%20SITE-ineed--app.netlify.app-00288E?style=for-the-badge" alt="Acessar o site: ineed-app.netlify.app" height="40"></a>
  &nbsp;
  <a href="https://github.com/rafaellourenco10/iNeed-App/releases/latest/download/ineed.apk"><img src="https://img.shields.io/badge/%F0%9F%93%B2%20BAIXAR%20O%20APK-Android%20%C2%B7%20v0.5.0%20Beta-FD761A?style=for-the-badge" alt="Baixar o APK para Android, v0.5.0 Beta" height="40"></a>
</p>

<h3 align="center">🌐 <a href="https://ineed-app.netlify.app">ineed-app.netlify.app</a></h3>

<p align="center">
  <img src="https://img.shields.io/badge/vers%C3%A3o-0.5.0%20Beta-00288E?style=flat-square" alt="Versão 0.5.0 Beta">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Node.js-339933?style=flat-square&logo=nodedotjs&logoColor=white" alt="Node.js">
  <img src="https://img.shields.io/badge/Firebase-FFCA28?style=flat-square&logo=firebase&logoColor=black" alt="Firebase">
  <img src="https://img.shields.io/badge/Render-46E3B7?style=flat-square&logo=render&logoColor=white" alt="Render">
  <img src="https://img.shields.io/badge/Netlify-00C7B7?style=flat-square&logo=netlify&logoColor=white" alt="Netlify">
</p>

Marketplace mobile que conecta clientes a prestadores de serviços pontuais (eletricista, encanador, pintor, faxina e outros), com backend próprio integrado ao Firebase.

<p align="center">
  <img src="site/img/telas/home-cliente.webp" alt="Tela inicial do cliente" height="500">
  &nbsp;&nbsp;
  <img src="site/img/telas/perfil-prestador.webp" alt="Perfil do prestador com selo de verificado" height="500">
</p>

## 🌐 Site oficial

> ### 👉 [ineed-app.netlify.app](https://ineed-app.netlify.app)

O site é a porta de entrada do projeto. Lá o usuário encontra:

- como o app funciona para quem contrata e para quem presta serviço;
- as categorias de serviço, com vídeos curtos dos profissionais trabalhando;
- como funciona o selo de verificado (o checklist que a equipe confere);
- prints reais das telas do app;
- o botão de download do APK e o passo a passo de instalação no Android;
- perguntas frequentes (é grátis? é seguro instalar fora da Play Store? tem iPhone? como viro prestador?).

O site fica na pasta [`site/`](site/) (HTML, CSS e JS puros, sem build), é publicado na Netlify com a configuração do [`netlify.toml`](netlify.toml) e se atualiza sozinho a cada push na `main`.

## 📲 Instalação no celular

O app ainda não está na Play Store. A instalação é feita pelo APK:

1. Baixe o [`ineed.apk`](https://github.com/rafaellourenco10/iNeed-App/releases/latest/download/ineed.apk) (ou pelo botão do site).
2. Abra o arquivo no celular e permita a instalação de fontes desconhecidas para o navegador, se o Android pedir.
3. Toque em **Instalar**. Se o Play Protect avisar que não reconhece o app, toque em **Mais detalhes → Instalar mesmo assim**.

> O servidor da API usa o plano gratuito do Render. Se ninguém usou o app nos últimos minutos, o primeiro acesso pode levar cerca de 50 segundos.

## 👥 Membros da Equipe

* **Rafael R. Lourenço** — Desenvolvedor responsável pela concepção e construção do projeto: arquitetura da aplicação, desenvolvimento completo do app Flutter (todas as telas, navegação, design system e integrações), desenvolvimento do backend Node.js/Express, integração com Firebase (Authentication + Firestore) e deploy em produção no Render.
* **João Wilson Cunha Silva Pereira** — Responsável pela documentação inicial do projeto e levantamento de requisitos das interfaces de cliente e prestador.
* **Victor Hugo Vicente** — Responsável pela modelagem inicial do banco de dados (estrutura de coleções de Clientes e Prestadores).
* **Nikolas Eduardo da Silva** — Responsável pela documentação do processo de testes e pela separação conceitual dos ambientes de desenvolvimento e produção.
* **Savio Santos** — Responsável pelos POPs de gestão de Sprint (Scrum) e de gerenciamento de requisitos.

## 📝 Sobre o Projeto

O **iNeed** conecta pessoas que precisam de um serviço pontual a profissionais aptos a realizá-lo. A plataforma oferece uma solução prática tanto para quem precisa contratar quanto para quem presta o serviço e busca renda extra com mais visibilidade.

**Para Clientes:**
* Encontrar profissionais disponíveis com rapidez, filtrando por especialidade e preço.
* Enviar propostas de serviço diretamente pelo app (título, descrição, data, horário, endereço — o valor já é o valor/hora cadastrado pelo prestador).
* Acompanhar o status de cada solicitação (pendente, em andamento, concluída) e falar com o prestador pelo WhatsApp.
* Avaliar o serviço concluído com estrelas, elogios rápidos e comentário.

**Para Prestadores:**
* Cadastrar-se com especialidade, valor/hora e biografia.
* Receber e gerenciar propostas recebidas dos clientes, com autonomia para aceitar ou recusar.
* Definir chave Pix e formas de pagamento aceitas (Dinheiro/Pix/Cartão/Todas as formas).
* Acompanhar avaliações reais no perfil público, com média recalculada automaticamente.
* Enviar documento com foto e comprovante de qualificação para ganhar o **selo de verificado**, visível para os clientes.

**Para a Equipe iNeed:**
* Painel web de validação para analisar os documentos enviados pelos prestadores e aprovar ou recusar (com motivo) cada verificação.

## ✅ Estado Atual

**App Flutter** — completo, com dados reais de ponta a ponta (sem mocks):
- Onboarding, cadastro unificado (cliente/prestador), login com email, CPF ou celular (Firebase Auth)
- Home e pedidos (cliente) · Home e propostas (prestador — sem aba de busca separada, já tem busca dentro da Home), todos com dados reais do backend
- Fluxo completo de contratação — proposta → aceitar/recusar → concluir → avaliar — com contato via WhatsApp nos dois sentidos (mensagem pré-programada) e notificações in-app a cada etapa
- Perfil compartilhado: dados pessoais editáveis, notificações (com badge de não lidas), método de pagamento (chave Pix + formas aceitas — Dinheiro/Pix/Cartão/Todas as formas — exclusivo do prestador), tema claro/escuro e exclusão de conta (reconfirma senha e apaga em cascata os dois papéis — propostas, avaliações e notificações)
- Quem é cliente e prestador na mesma conta troca de perfil pelo menu sem precisar deslogar
- Categoria "Faz tudo" para prestador com mais de uma especialidade
- Card "Impulsione seu anúncio" na home do prestador (destaque pago futuro — ver "Em andamento")
- **Verificação de perfil:** o prestador fotografa (câmera ou galeria) um documento com foto e um comprovante de qualificação e envia para análise; a tela mostra o status (em análise, aprovado ou recusado com o motivo) e permite reenviar após recusa. Fotos são comprimidas no aparelho e sobrevivem ao Android encerrar o app com a câmera aberta
- **Selo de verificado** ao lado do nome no card da busca/home do cliente, no perfil público do prestador, nos pedidos do cliente, nos detalhes do serviço, na tela de avaliação, na home do prestador e na tela de perfil — só para quem foi aprovado
- **Puxar para atualizar** em todas as telas que buscam dados do servidor (home, busca, pedidos, propostas, notificações, perfil, perfil do prestador e verificação), inclusive com a lista vazia
- Sessão salva no aparelho se revalida sozinha com o backend ao abrir o app, e desloga automaticamente se o token expirar
- Design system Material 3 com identidade visual própria, navegação por abas

**Backend (Node.js + Express)** — publicado em produção:
- API REST completa: autenticação, prestadores, propostas, avaliações, notificações e verificações de perfil
- Login e cadastro validam de verdade contra o Firebase (não é mock), com telefone e CPF únicos entre contas
- Middleware de autenticação por token JWT, permissões por papel (transições de status de proposta validadas, IDOR fechado)
- Deploy automático no [Render](https://render.com) a cada push na `main`: `https://ineed-app-9lzp.onrender.com`

**Painel de validação (web)** — servido pelo próprio backend em [`/admin`](https://ineed-app-9lzp.onrender.com/admin):
- Página única (`backend/public/admin.html`), sem build, no padrão de ferramentas de revisão KYC: fila de envios à esquerda, documento grande no centro (zoom, arrastar, girar) e painel de decisão à direita
- Checklist obrigatório antes de aprovar: nome e CPF do documento conferem com o cadastro (o CPF vem do perfil do prestador e só aparece para validadores, nos envios pendentes), documento legível e válido, comprovante é da especialidade e está em nome do prestador
- Recusa com motivos prontos + detalhe; o prestador recebe notificação e vê o motivo no app
- Registra quem analisou e quando; atalhos de teclado; funciona também no celular
- **Acesso:** qualquer pessoa com o link vê só a tela de login. Os documentos só aparecem para contas do iNeed cujo e-mail esteja na variável `ADMIN_EMAILS` do Render (separados por vírgula) — a checagem é feita no backend. Para dar acesso a um membro, basta acrescentar o e-mail dele nessa variável
- No plano gratuito do Render o servidor "dorme" após ~15 min sem uso; o primeiro acesso depois disso leva cerca de 50 segundos

**Firebase** — projeto configurado e conectado:
- Authentication (Email/Senha) e Cloud Firestore ativos
- Todo o ciclo cliente↔prestador (cadastro, login, propostas, avaliações) grava e lê dados reais
- Verificações ficam em `verificacoes/{uid}` (status, motivo, quem analisou) e as imagens em `verificacoes/{uid}/arquivos/{tipo}` como base64 (limite de ~600 KB por imagem, validado no backend) — sem Firebase Storage, que exige o plano Blaze. Aprovar grava `verificado: true` em `usuarios/{uid}`. Excluir a conta apaga também os documentos

**Site de apresentação (web)** — publicado em [ineed-app.netlify.app](https://ineed-app.netlify.app):
- Landing page estática na pasta `site/` (HTML, CSS e JS puros, sem build), feita primeiro para o celular e ajustada para telas grandes
- Seções: como funciona (abas cliente/prestador), categorias com vídeos, selo de verificado, download e instalação do APK, perguntas frequentes e equipe
- Prints reais do app, animações de entrada que respeitam a opção "reduzir movimento" do sistema e modo claro/escuro automático
- Botões de download apontam para o link fixo do GitHub Releases; a versão e o tamanho exibidos ficam num único lugar (`site/main.js`)
- Deploy automático na Netlify a cada push na `main`, configurado pelo `netlify.toml` da raiz

**Build Android:**
- APK da **v0.5.0 Beta** publicado no [GitHub Releases](https://github.com/rafaellourenco10/iNeed-App/releases/latest) como `ineed.apk` (~91 MB), com o link fixo `releases/latest/download/ineed.apk` usado pelo site e por este README
- Instalação direta em aparelhos Android, fora da Play Store — assinado com chave debug por enquanto, então as próximas versões precisam ser geradas na mesma máquina para instalar por cima

**Em andamento para a v1.0.0:**
- Testes automatizados (backend e Flutter)
- Build de produção assinado para publicação nas lojas
- Impulsionar anúncio (destaque pago na busca) — tela já existe no app, pagamento ainda não implementado
- Migrar as imagens de verificação para o Firebase Storage caso o projeto passe para o plano Blaze

## 💻 Tecnologias

* **Frontend Mobile:** Flutter, Dart, Provider (state management), image_picker (câmera/galeria)
* **Painel de validação:** HTML, CSS e JavaScript puros, servidos pelo backend
* **Site de apresentação:** HTML, CSS e JavaScript puros, publicado na Netlify
* **Backend:** Node.js, Express, Firebase Admin SDK
* **Banco de Dados / Auth:** Firebase Authentication + Cloud Firestore
* **Hospedagem:** Render (backend) e Netlify (site)
* **Distribuição do APK:** GitHub Releases
* **Controle de Versão:** Git e GitHub

## 📂 Documentação

**Planejamento**
* [Visão Geral do Projeto](docs/planning/project-vision.md)
* [Backlog do Produto](docs/planning/backlog.md)
* [Roadmap](docs/planning/roadmap.md)

**Fluxo de Trabalho**
* [Desenvolvimento vs. Produção](docs/workflow/development-vs-production.md)
* [Organização da Equipe](docs/workflow/team-organization.md)
* [Kanban](docs/workflow/kanban.md) / [Gantt](docs/workflow/gantt.md)

**Processos (POPs)**
* [docs/pops/](docs/pops/)

**Produto e Design**
* [PRODUCT.md](PRODUCT.md) — contexto do produto, usuários e princípios
* [backend/DESIGN.md](backend/DESIGN.md) — sistema visual do painel de validação

## 🚀 Como rodar o projeto

Clonar o repositório:
```bash
git clone https://github.com/rafaellourenco10/iNeed-App.git
```

**App Flutter** (pasta `src/`):
```bash
cd src
flutter pub get
flutter run
```

### Gerar o APK e publicar uma nova versão

```bash
cd src
flutter build apk --release
```

O arquivo sai em `src/build/app/outputs/flutter-apk/app-release.apk`. Para publicar uma nova versão, atualize o `version` no `pubspec.yaml`, gere o APK e crie uma release no GitHub (marcada como **Latest**, não como pre-release) com o arquivo renomeado para exatamente `ineed.apk`. O botão do site sempre baixa a release mais recente, então o site não precisa ser alterado (só o tamanho exibido, em `site/main.js`, se mudar muito).

**Backend** (pasta `backend/`) — só necessário para rodar localmente, já que o backend em produção está publicado no Render:
```bash
cd backend
npm install
npm run dev
```
Requer um `.env` com `PORTA`, `FIREBASE_WEB_API_KEY`, `ADMIN_EMAILS` (e-mails com acesso ao painel, separados por vírgula) e a credencial do Firebase (`serviceAccountKey.json` local ou `FIREBASE_SERVICE_ACCOUNT`) — ver [docs/development-environment.md](docs/development-environment.md).

Com o backend rodando, o painel de validação abre em `http://localhost:3000/admin` (usa o mesmo Firebase de produção).

**Site** (pasta `site/`) — não tem build; para ver localmente antes de publicar:
```bash
npx serve site
```
Abre em `http://localhost:3000`. Qualquer push na `main` publica a versão nova em [ineed-app.netlify.app](https://ineed-app.netlify.app).
