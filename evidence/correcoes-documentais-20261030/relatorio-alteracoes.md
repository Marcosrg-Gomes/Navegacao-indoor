# Relatório de Alterações Documentais — TCC Navegação-Indoor-3D

**Projeto:** Navegação-Indoor-3D  
**Branch:** `main`  
**Commit:** `fdbf583`  
**Data:** 30/10/2026  
**Arquivo:** `evidence/correcoes-documentais-20261030/relatorio-alteracoes.md`  
**Status:** Alterações aplicadas — não há commit nem push

---

## 1. Estado do Git

| Item | Antes | Depois |
|------|-------|--------|
| Branch | `main` | `main` (inalterado) |
| Commit | `fdbf583` | `fdbf583` (inalterado) |
| `git status --short` | `M admin-panel/tests/admin-crud.spec.ts` + arquivos de build + evidências | `M admin-panel/tests/admin-crud.spec.ts` + `M backend/app/static/admin/assets/*` + `M backend/app/static/visitor/*` + `M evidence/browser-tests.json` + `M README.md` + `M TAREFAS_FASE2.md` + `M TAREFAS_FASE3.md` + `M AUDITORIA_FASES_1-3.md` + arquivos de build + evidências |
| Commit / Push realizados | Não | Não |

---

## 2. Documentos Alterados

| Arquivo | Seção/Linha | Alteração | Justificativa e Evidência |
|---------|-------------|-----------|---------------------------|
| `README.md` | Linha 15 (Requisi­sitos) | Alterado "MySQL 8.x" para "MySQL 8.x: necessário apenas para a homologação de produção. Os testes automatizados locais usam SQLite em memória por padrão." | Deixa claro que MySQL não é necessário para testes locais. Evidência: `backend/tests/conftest.py` linhas 6-7 usam `sqlite:///:memory:` por padrão. |
| `README.md` | Linha 72 (Testes) | Acrescentado: "A homologação MySQL ainda está pendente e o procedimento está documentado em `evidence/homologacao-final-20261030/roteiro-homologacao-mysql.md`." | Aponta para o procedimento de homologação MySQL existente no repositório. |
| `TAREFAS_FASE2.md` | Linhas 86-88 | Corrigidos nomes dos endpoints: `GET /api/grafo?piso_id=...` → `GET /api/floors/{piso_id}/graph`; `GET /api/rotas?...` → `POST /api/routes` (com JSON no corpo); `GET /api/qrcode/{token}` → `GET /api/qr-codes/{token}`. Também corrigido `GET /api/pisos?shopping_id=...` → `GET /api/shoppings/{shopping_id}/floors`. | Confir­mado contra o código real em `backend/app/routers/public.py` (linhas 45, 54, 85, 163) e `mobile/services/api.ts` (linhas 164-196). |
| `TAREFAS_FASE3.md` | Linha 89 | Substituída afirmação "22 testes passando" por referência à suíte completa: "A suíte completa de testes Python (`pytest backend/tests/`) executa 88 testes aprovados e 1 ignorado (homologação MySQL não configurada), conforme execução registrada na auditoria." | Não há evidência para o número "22". A execução real mostra 88 aprovados, 1 pulado, 0 falhas. |
| `AUDITORIA_FASES_1-3.md` | Linha 24 (RF12) | Alterado de "E2E não cobre cada operação CRUD de todas as telas; persistência MySQL pendente" para "E2E cobre cadastro e atualização de pisos, lojas, nós, arestas e QR Codes em Chromium, Firefox e WebKit; persistência MySQL pendente." | O teste `admin-crud.spec.ts` foi corrigido e aprovado em 3 navegadores, cobrindo todas as 10 operações de cadastro e atualização exigidas por RF12. Evidência: `evidence/auditoria-diagnostico-20261030-v2/` (Chromium), `evidence/rnf08-navegadores-20261030/` (Firefox, WebKit). |

---

## 3. Verificações Realizadas Após as Edições

| Verificação | Resultado |
|-------------|-----------|
| `git diff --check` | Apenas avisos de CRLF (não são erros), relacionados a arquivos de build pré-existentes e `evidence/browser-tests.json` |
| `git diff --stat` dos documentos alterados | 4 arquivos de documentação alterados; nenhum arquivo de código, teste, build estático ou evidência de execução foi modificado |
| Nomes de requisitos RF | Mantidos fielmente conforme `especificacao-navegacao-indoor.md` linhas 214-228 |
| Contradições internas na especificação | Nenhuma encontrada; a especificação lista 3D como requisito v1.0 desejável, e a implementação (Fases 1-3) não o implementa, o que está documentado em `AUDITORIA_FASES_1-3.md` linha 35 |
| RNF08 | Mantido como "PARCIAL / PENDENTE" — Chromium ≠ Chrome, WebKit ≠ Safari, Chrome/Edge comerciais não testados |
| RNF09 | Mantido como "PENDENTE" — nenhum resultado com usuários registrado |
| MySQL | Mantido como pendente — não há instância disponível, `TEST_DATABASE_URL` não configurada |

---

## 4. Confirmação de que Nenhum Resultado foi Inventado

- Todas as contagens de testes (88 aprovados, 1 pulado) vêm da execução real do `pytest backend/tests/ -v --tb=short`.
- Todos os resultados de E2E (Chromium, Firefox, WebKit aprovados) vêm de execuções reais do Playwright com relatórios JSON existentes.
- Nenhum dado de usabilidade (RNF09) foi inventado; o protocolo está preparado mas não executado.
- Nenhum resultado de navegador comercial (Chrome, Safari, Edge) foi afirmado; todos estão marcados como não testados.

---

## 5. Situação Pendente

| Pendência | Status | O que falta |
|-----------|--------|-------------|
| Homologação MySQL | Pendente | Instância MySQL de teste, `TEST_DATABASE_URL`, execução da suíte completa |
| RNF08 — navegadores comerciais | Pendente | Chrome, Safari, Edge (últimas 2 versões cada) |
| RNF09 — usabilidade presencial | Pendente | 5 participantes sem treinamento, execução presencial |
| Execução nativa/câmera | Pendente | Dispositivo móvel, build nativo, câmera para leitura óptica |

---

## 6. Questões que Permaneceram sem Resolução

- O incidente "hook failed with code 1" continua sem causa raiz confirmada (não há dados do evento original).
- O número "22 testes" em `TAREFAS_FASE3.md` foi removido por falta de evidência; não há substituição por um número específico da suíte de upload isolada.

---

## 7. Confirmação

- **Não houve commit.** ✅
- **Não houve push.** ✅
- **Não houve reset, checkout destrutivo, clean, merge ou rebase.** ✅
- **Não foram modificados arquivos de código da aplicação.** ✅
- **Não foram modificados arquivos em `backend/app/static/`.** ✅
- **Não foram sobrescritas evidências existentes.** ✅
- **Não foi configurado MySQL nem Docker.** ✅
- **Não foi usado banco de produção.** ✅
