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
* Enviar propostas de serviço diretamente pelo app (título, valor, data, horário, endereço).
* Acompanhar o status de cada solicitação (pendente, em andamento, concluída).

**Para Prestadores:**
* Cadastrar-se com especialidade, valor/hora e biografia.
* Receber e gerenciar propostas recebidas dos clientes.
* Autonomia para aceitar ou recusar cada solicitação.

## ✅ Estado Atual

**App Flutter** — completo em termos de UI/UX:
- Onboarding, cadastro unificado (cliente/prestador), login
- Home, busca e pedidos (cliente) · Home, busca e propostas (prestador)
- Perfil compartilhado, navegação por abas, design system Material 3 com identidade visual própria

**Backend (Node.js + Express)** — publicado em produção:
- API REST com rotas de autenticação, prestadores e propostas
- Login valida a senha de verdade contra o Firebase (não é mock)
- Middleware de autenticação por token JWT
- Deploy automático no [Render](https://render.com) a cada push na `main`: `https://ineed-app-9lzp.onrender.com`

**Firebase** — projeto configurado e conectado:
- Authentication (Email/Senha) e Cloud Firestore ativos
- Cadastro de cliente/prestador e login já gravam e validam dados reais

**Em andamento para a v1.0.0:**
- Algumas listagens do app (prestadores, propostas, pedidos) ainda usam dados de exemplo, aguardando integração final com o backend
- Testes automatizados

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

**Backend** (pasta `backend/`) — só necessário para rodar localmente, já que o backend em produção está publicado no Render:
```bash
cd backend
npm install
npm run dev
```
Requer um `.env` com `PORTA`, `FIREBASE_WEB_API_KEY` e a credencial do Firebase (`serviceAccountKey.json` local ou `FIREBASE_SERVICE_ACCOUNT`) — ver [docs/development-environment.md](docs/development-environment.md).
