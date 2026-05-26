# Workflow Funcional da Equipe (GitHub Flow)

[cite_start]Adotamos uma adaptação do **GitHub Flow** para garantir integração contínua, revisões ágeis e rastreabilidade entre tarefas e código[cite: 160, 176].

## [cite_start]1. Fluxo de Trabalho (Passo a Passo) [cite: 167]
1. [cite_start]**Criação da Tarefa:** A necessidade é registrada no Backlog (Issue/Card)[cite: 168].
2. [cite_start]**Criação da Branch:** O responsável cria uma branch a partir da `main` no padrão `feature/nome-da-tarefa` ou `bugfix/nome-do-erro`[cite: 169].
3. [cite_start]**Desenvolvimento e Commits:** O código é gerado usando commits semânticos (ex: `feat: add tela de login`, `fix: ajusta rotas`)[cite: 170].
4. [cite_start]**Pull Request (PR):** Concluída a tarefa, abre-se um PR para solicitar a mesclagem com a `main`[cite: 171].
5. **Revisão de Código:** Outro integrante da equipe avalia o código. [cite_start]Testes locais são feitos se necessário[cite: 172].
6. [cite_start]**Merge e Atualização:** Sendo aprovado, o PR é mesclado (`merge`), o card é movido para "Concluído" no Kanban e as evidências são salvas na pasta `docs/evidences/`[cite: 173, 174, 175].

## [cite_start]2. Diagrama do Workflow [cite: 182]
`Issue no Kanban` ➔ `git checkout -b feature/X` ➔ `git commit -m "feat: X"` ➔ `git push` ➔ `Abertura de PR` ➔ `Revisão por Colega` ➔ `Merge na Main` ➔ `Fim`