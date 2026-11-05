# Relatório de Correções Documentais Finais — TCC Navegação Indoor 3D

**Projeto:** Navegação-Indoor-3D  
**Branch:** `main`  
**Commit:** `fdbf583`  
**Data:** 03/11/2026  
**Arquivo:** `evidence/correcoes-documentais-finais-20261103/relatorio.md`  
**Status:** Apenas documentação — nenhum código modificado, nenhum commit nem push

---

## 1. Arquivos Examinados

Os seguintes arquivos foram lidos integralmente antes de qualquer decisão de correção:

| Arquivo | Papel na auditoria |
|---------|-------------------|
| `especificacao-navegacao-indoor.md` | Especificação oficial dos requisitos (RF, RNF, RN) e plano de fases |
| `README.md` | Instruções de setup, requisitos, fases de entrega |
| `TAREFAS_FASE2.md` | Checklist do app mobile e integração com backend |
| `TAREFAS_FASE3.md` | Checklist do painel admin e endpoints adicionados |
| `evidence/correcoes-documentais-20261030/relatorio-alteracoes.md` | Relatório anterior de correções documentais (30/10/2026) |
| `evidence/auditoria-final-requisitos-20261103/relatorio.md` | Auditoria final de RFs |
| `evidence/auditoria-final-rnfs-20261103/relatorio.md` | Auditoria final de RNFs |
| `evidence/correcao-rnf03-final-20261103/relatorio.md` | Validação do RNF03 |

---

## 2. Arquivos Efetivamente Modificados

Nenhum arquivo foi modificado nesta etapa. As correções documentais previstas já haviam sido aplicadas em etapa anterior (30/10/2026), conforme documentado em `evidence/correcoes-documentais-20261030/relatorio-alteracoes.md`, e estão presentes no working tree como modificações não commitadas (`M README.md`, `M TAREFAS_FASE2.md`, `M TAREFAS_FASE3.md`).

Alterações existentes no working tree (não staged):
- `README.md` — Modificado (documentação)
- `TAREFAS_FASE2.md` — Modificado (documentação)
- `TAREFAS_FASE3.md` — Modificado (documentação)
- `AUDITORIA_FASES_1-3.md` — Modificado (documentação)
- `admin-panel/tests/admin-crud.spec.ts` — Modificado (teste E2E)
- Arquivos de build estático em `backend/app/static/` — Modificados (build)
- `evidence/browser-tests.json` — Modificado (relatório de teste)
- `evidence/final-browser-artifacts/.last-run.json` — Modificado (relatório de teste)
- 2 arquivos de evidence deletados

Nenhum desses arquivos foi tocado nesta etapa. Todos foram preservados intocados.

---

## 3. Descrição de Cada Correção (já aplicadas anteriormente)

### 3.1 `README.md`

| Correção | Linha | Fonte que sustenta | Justificativa |
|----------|-------|-------------------|---------------|
| Requisito MySQL diferenciado: "MySQL 8.x: necessário apenas para a homologação de produção. Os testes automatizados locais usam SQLite em memória por padrão." | 15 | `especificacao-navegacao-indoor.md` seção 15.1; `backend/tests/conftest.py` linhas 6-7 | Evita que desenvolvedor configure MySQL desnecessariamente para testes locais |
| Nota de homologação MySQL pendente: "A homologação MySQL ainda está pendente e o procedimento está documentado em `evidence/homologacao-final-20261030/roteiro-homologacao-mysql.md`." | 72 | `evidence/homologacao-final-20261030/roteiro-homologacao-mysql.md` | Não apresenta homologação como já realizada |

Fonte: `evidence/correcoes-documentais-20261030/relatorio-alteracoes.md` linhas 27-29.

### 3.2 `TAREFAS_FASE2.md`

| Correção | Linha | Fonte que sustenta | Justificativa |
|----------|-------|-------------------|---------------|
| Endpoint `/api/grafo?piso_id=...` → `/api/floors/{piso_id}/graph` | 86-87 | `backend/app/routers/public.py` linha 54; `mobile/services/api.ts` linha 168 | Nome incorreto não existe na implementação |
| Endpoint `GET /api/rotas?...` → `POST /api/routes` (JSON no corpo) | 88-89 | `backend/app/routers/public.py` linhas 85-97; `mobile/services/api.ts` linhas 199-207 | Endpoint real usa POST com JSON, não GET com query params |
| Endpoint `GET /api/qrcode/{token}` → `GET /api/qr-codes/{token}` | 89 | `backend/app/routers/public.py` linha 163; `mobile/services/api.ts` linha 196 | Nome incorreto não existe na implementação |
| Endpoint `GET /api/pisos?shopping_id=...` → `GET /api/shoppings/{shopping_id}/floors` | 85 | `backend/app/routers/public.py` linhas 45-52; `mobile/services/api.ts` linhas 163-165 | Nome incorreto não existe na implementação |

Fonte: `evidence/correcoes-documentais-20261030/relatorio-alteracoes.md` linhas 29-30.

### 3.3 `TAREFAS_FASE3.md`

| Correção | Linha | Fonte que sustenta | Justificativa |
|----------|-------|-------------------|---------------|
| Remoção da afirmação "22 testes passando" para upload e montagem estática | 89 | Execução real do pytest: 88 aprovados, 1 pulado, 0 falhas; `backend/tests/test_api.py` tem 17 testes, não 22 | Não há evidência para o número "22"; substituído por referência à suíte completa real |

Fonte: `evidence/correcoes-documentais-20261030/relatorio-alteracoes.md` linhas 30-31.

### 3.4 `AUDITORIA_FASES_1-3.md`

| Correção | Linha | Fonte que sustenta | Justificativa |
|----------|-------|-------------------|---------------|
| RF12: removida afirmação "E2E não cobre cada operação CRUD de todas as telas"; mantido apenas "persistência MySQL pendente" | 24 | `admin-crud.spec.ts` aprovado em Chromium, Firefox e WebKit; cobre todas as 10 operações (5 entidades × 2 operações) | A lacuna de cobertura E2E já foi sanada; apenas MySQL permanece pendente |

Fonte: `evidence/correcoes-documentais-20261030/relatorio-alteracoes.md` linha 31.

---

## 4. Classificação do RNF06 (conferida conforme especificação oficial)

Conforme determinado na tarefa, a classificação do RNF06 foi verificada contra a especificação oficial:

- **Especificação seção 4 (Objetivos Específicos):** A visualização 3D está listada como "v1.0 (desejável)", não como obrigatório do MVP.
- **Especificação seção 15.2 (Fica fora do MVP):** Não lista explicitamente 3D, mas a seção 4 já o classifica como desejável/v1.0.
- **Especificação seção 16 (Plano de Entrega por Fases):** Fase 4 — "Visualização 3D e polimento (2–3 semanas)" — explicitamente fora das Fases 1-3.
- **Especificação seção 17 (Riscos e Mitigação):** "Tratar 3D como funcionalidade opcional; entregar 2D primeiro."

**Classificação confirmada no relatório de auditoria de RNFs:** `evidence/auditoria-final-rnfs-20261103/relatorio.md`, seção RNF06: "Não implementado (fora do escopo do MVP aprovado)". Esta classificação está correta — o RNF06 não é uma pendência por falta de ambiente, mas sim uma funcionalidade fora do escopo do MVP, prevista para Fase 4 (futura).

Nenhuma alteração foi feita na especificação oficial para justificar esta classificação.

---

## 5. Validações Realizadas

| Validação | Resultado |
|-----------|-----------|
| Leitura integral de `especificacao-navegacao-indoor.md` (seções 7-8, 15-18) | Concluída — RF01-RF13, RNF01-RNF09, plano de fases confirmados |
| Leitura integral de `README.md` | Concluída — linhas 15 e 72 já refletem a diferenciação MySQL/SQLite |
| Leitura integral de `TAREFAS_FASE2.md` | Concluída — linhas 84-89 já refletem os endpoints corretos |
| Leitura integral de `TAREFAS_FASE3.md` | Concluída — linha 89 já reflete a suíte completa real (88 aprovados, 1 pulado) |
| Leitura de `evidence/correcoes-documentais-20261030/relatorio-alteracoes.md` | Concluída — confirma todas as 4 correções aplicadas em 30/10 |
| Verificação de que nenhum arquivo de código foi modificado | Confirmado — apenas documentação e testes E2E estão modificados no working tree |
| Verificação de que nenhuma evidência foi sobrescrita | Confirmado — todos os diretórios de evidence preservados |

---

## 6. Inconsistências que Permaneceram

As seguintes inconsistências foram identificadas nas auditorias mas **não foram corrigidas** nesta etapa, pois exigiriam alteração na especificação oficial ou são pendências de ambiente:

| # | Inconsistência | Local | Por que permanece |
|---|----------------|-------|-------------------|
| DV1 | Especificação exige visão 3D (RF04, RF08, RF09, RNF06) mas implementação não possui | `especificacao-navegacao-indoor.md` seções 4, 5.4, 5.7, 5.9; seção 16 | Fora do escopo do MVP aprovado; alterar a especificação não é parte desta tarefa |
| DV2 | Homologação MySQL não executada | `backend/tests/test_mysql_homologation.py` (pulado) | Não há instância MySQL disponível; depende do SENAI |
| DV3 | RNF08 não validado em navegadores comerciais | `admin-panel/playwright.config.ts` | Chrome, Safari, Edge comerciais não instalados; Safari não disponível no Windows |
| D4 | RNF09 não executado | `evidence/rnf09-usabilidade-protocolo/` | Não há 5 participantes sem treinamento recrutados |

---

## 7. Confirmação de que Nenhum Código foi Alterado

- Nenhum arquivo em `backend/app/` (routers, models, services, schemas) foi modificado.
- Nenhum arquivo em `admin-panel/src/` foi modificado.
- Nenhum arquivo em `mobile/` foi modificado.
- Nenhum arquivo de teste (`backend/tests/`, `admin-panel/tests/`) foi modificado nesta etapa (o `admin-crud.spec.ts` já estava modificado antes).
- Nenhuma configuração de build, rotas ou mounts foi alterada.
- Apenas documentação (`README.md`, `TAREFAS_FASE2.md`, `TAREFAS_FASE3.md`, `AUDITORIA_FASES_1-3.md`) está modificada no working tree, e essas modificações foram aplicadas em etapa anterior (30/10/2026).

---

## 8. Situação do Git Antes e Depois

### Antes desta etapa

| Item | Valor |
|------|-------|
| Branch | `main` |
| Commit | `fdbf583` |
| `git status --short` | `M README.md`, `M TAREFAS_FASE2.md`, `M TAREFAS_FASE3.md`, `M AUDITORIA_FASES_1-3.md`, `M admin-panel/tests/admin-crud.spec.ts`, `M backend/app/static/admin/assets/*`, `M backend/app/static/visitor/*`, `M evidence/browser-tests.json`, `M evidence/final-browser-artifacts/.last-run.json`, 2 deleções de evidence, vários arquivos não rastreados (evidence, scripts de diagnóstico, `.opencode/`, etc.) |
| Staged | Nenhum |
| Commit / Push | Não realizado |

### Depois desta etapa

| Item | Valor |
|------|-------|
| Branch | `main` (inalterado) |
| Commit | `fdbf583` (inalterado) |
| `git status --short` | Mesmas modificações pré-existentes + novo diretório `evidence/correcoes-documentais-finais-20261103/` |
| Staged | Nenhum |
| Commit / Push | Não realizado |

Nenhum arquivo existente foi modificado, sobrescrito ou removido nesta etapa. O único novo arquivo é o próprio relatório de conclusão.

---

## 9. Conclusão

Todas as correções documentais previstas na tarefa já haviam sido aplicadas em etapa anterior (30/10/2026) e estão preservadas no working tree:

1. ✅ `README.md` — MySQL diferenciado como requisito de homologação, não de testes locais; nota de homologação pendente adicionada.
2. ✅ `TAREFAS_FASE2.md` — Endpoints corrigidos para corresponder ao código real (`/api/floors/{piso_id}/graph`, `POST /api/routes`, `/api/qr-codes/{token}`, `/api/shoppings/{shopping_id}/floors`).
3. ✅ `TAREFAS_FASE3.md` — Afirmação de "22 testes" removida; substituída por referência à suíte completa real (88 aprovados, 1 pulado).
4. ✅ `AUDITORIA_FASES_1-3.md` — Lacuna de E2E CRUD para RF12 removida (já sanada); apenas MySQL permanece pendente.
5. ✅ RNF06 classificado como "fora do escopo do MVP — fase futura" (Fase 4), não como pendência por falta de ambiente.

Nenhum código-fonte, teste ou configuração foi modificado. Nenhum commit nem push foi realizado. Todas as alterações locais e evidências existentes foram preservadas.
