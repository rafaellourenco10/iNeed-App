---
version: 1
slug: "backend-public-admin-html"
primary_target: "backend/public/admin.html"
related_targets: []
---

# Painel de validação (/admin)

Scope: backend/public/admin.html — login + fila de revisão de documentos de prestadores.
Mode: Operate. Audience: 1–3 validadores iNeed, desktop, poucos envios/dia.
Task: abrir envio pendente, comparar documento e comprovante com o cadastro, marcar checklist, aprovar ou recusar com motivo.
Constraints: arquivo único, sem build, sem libs; dados via /api/verificacoes; português.

## Direction contract

THESIS: Canon of KYC review tools (Sumsub/Onfido), played straight at full fidelity — the user pinned it. Refuses the card-grid admin page: the document is the protagonist, the decision sits beside it.
OWN-WORLD: Light neutral chrome (cool gray panels, white work surface), a dark graphite viewer canvas where documents sit like on a lightbox, iNeed blue #00288E only for primary action/selection, semantic amber/green/red for status. System sans, tabular numerals, 1px hairlines, 8px radii, inline SVG stroke icons.
STORY: The validator sees how many are waiting, opens the oldest, inspects both images with zoom/rotate, ticks four checks, approves (or rejects with a reason chip + note) and lands on the next one.
FIRST VIEWPORT: Top bar (iNeed mark, "Verificações", validator e-mail, Sair). Three columns: 320px queue (status tabs with counts, search, rows with initials/name/specialty/age); flexible viewer (doc tabs, toolbar zoom−/+/fit/rotate/open, image on graphite); 360px decision panel (applicant data, checklist, Aprovar primary disabled until all checked, Recusar secondary).
FORM: Canon (standing exit), user-selected reference Sumsub/Onfido; no seed key — brief-pinned, concept-seed not run.
FINISH: unreviewed and undocumented is unfinished; this build ends with the finish review, the verdict, DESIGN.md, and every shipping raster carrying its provenance
