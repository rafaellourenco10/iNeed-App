# iNeed

Marketplace mobile que conecta clientes a prestadores de serviços pontuais (eletricista, encanador, pintor, faxina e outros), com backend próprio integrado ao Firebase.

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

## ✅ Estado Atual

**App Flutter** — completo, com dados reais de ponta a ponta (sem mocks):
- Onboarding, cadastro unificado (cliente/prestador), login com email, CPF ou celular (Firebase Auth)
- Home, busca e pedidos (cliente) · Home, busca e propostas (prestador), todos com dados reais do backend
- Fluxo completo de contratação — proposta → aceitar/recusar → concluir → avaliar — com contato via WhatsApp nos dois sentidos (mensagem pré-programada) e notificações in-app a cada etapa
- Perfil compartilhado: dados pessoais editáveis, notificações (com badge de não lidas), método de pagamento (chave Pix + formas aceitas — Dinheiro/Pix/Cartão/Todas as formas — exclusivo do prestador), tema claro/escuro e exclusão de conta (reconfirma senha e apaga em cascata os dois papéis — propostas, avaliações e notificações)
- Quem é cliente e prestador na mesma conta troca de perfil pelo menu sem precisar deslogar
- Categoria "Faz tudo" para prestador com mais de uma especialidade
- Design system Material 3 com identidade visual própria, navegação por abas

**Backend (Node.js + Express)** — publicado em produção:
- API REST completa: autenticação, prestadores, propostas, avaliações e notificações
- Login e cadastro validam de verdade contra o Firebase (não é mock)
- Middleware de autenticação por token JWT, permissões por papel (transições de status de proposta validadas, IDOR fechado)
- Deploy automático no [Render](https://render.com) a cada push na `main`: `https://ineed-app-9lzp.onrender.com`

**Firebase** — projeto configurado e conectado:
- Authentication (Email/Senha) e Cloud Firestore ativos
- Todo o ciclo cliente↔prestador (cadastro, login, propostas, avaliações) grava e lê dados reais

**Build Android:**
- Primeiro APK de teste gerado (`0.1.0`) para instalação direta em aparelhos físicos, fora do Play Store — assinado com chave debug por enquanto

**Em andamento para a v1.0.0:**
- Testes automatizados (backend e Flutter)
- Build de produção assinado para publicação nas lojas

## 💻 Tecnologias

* **Frontend Mobile:** Flutter, Dart, Provider (state management)
* **Backend:** Node.js, Express, Firebase Admin SDK
* **Banco de Dados / Auth:** Firebase Authentication + Cloud Firestore
* **Hospedagem do Backend:** Render
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

Gerar um APK para instalar em outro aparelho (fora do Play Store):
```bash
cd src
flutter build apk --release
```
O arquivo sai em `src/build/app/outputs/flutter-apk/app-release.apk`.

**Backend** (pasta `backend/`) — só necessário para rodar localmente, já que o backend em produção está publicado no Render:
```bash
cd backend
npm install
npm run dev
```
Requer um `.env` com `PORTA`, `FIREBASE_WEB_API_KEY` e a credencial do Firebase (`serviceAccountKey.json` local ou `FIREBASE_SERVICE_ACCOUNT`) — ver [docs/development-environment.md](docs/development-environment.md).
