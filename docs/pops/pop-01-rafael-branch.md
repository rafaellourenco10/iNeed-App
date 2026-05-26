# POP 01: Como criar uma Branch de Desenvolvimento

* **Objetivo:** Padronizar a criação de ramificações no repositório para evitar conflitos na branch principal `main`.
* **Responsável:** Rafael (Desenvolvedor).
* **Quando usar:** Ao iniciar o desenvolvimento de uma nova funcionalidade ou correção de bug.
* **Pré-requisitos:** Ter o Git instalado e o repositório clonado localmente na máquina.
* **Passo a passo:**
  1. No terminal do VS Code, certifique-se de estar na branch `main`.
  2. Execute `git pull` para atualizar o repositório local.
  3. Execute `git checkout -b feature/nome-da-tarefa` (ou `bugfix/nome-do-erro`).
  4. Inicie o desenvolvimento.
* **Evidências esperadas:** A nova branch deve aparecer listada no repositório remoto do GitHub.
* **Critérios de sucesso:** Branch criada a partir da versão mais recente da `main`, sem conflitos prévios.
* **Referências utilizadas:** GITHUB DOCS. GitHub Flow.