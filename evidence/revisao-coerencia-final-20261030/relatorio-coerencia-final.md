# Relatório de Revisão Final de Coerência — TCC Navegação-Indoor-3D

**Projeto:** Navegação-Indoor-3D  
**Branch:** `main`  
**Commit:** `fdbf583`  
**Data:** 30/10/2026  
**Arquivo:** `evidence/revisao-coerencia-final-20261030/relatorio-coerencia-final.md`  
**Status:** Revisão de coerência — não modifica documentos originais

---

## 1. Documentos Examinados

| Documento | Caminho | Papel na revisão |
|-----------|---------|------------------|
| Especificação técnica | `especificacao-navegacao-indoor.md` | Requisitos funcionais (RF), não funcionais (RNF) e regras de negócio (RN) |
| Decisões técnicas | `DECISOES.md` | Decisões de arquitetura e critérios de aceite |
| Auditoria fases 1-3 | `AUDITORIA_FASES_1-3.md` | Matriz de requisitos, estado de evidências e pendências |
| README | `README.md` | Instruções de setup, fases de entrega, tecnologias |
| Implementação oficial | `IMPLEMENTACAO_OFICIAL.md` | Gates de CI, aceites físicos, estrutura oficial |
| Tarefas Fase 2 | `TAREFAS_FASE2.md` | Checklist do app mobile |
| Tarefas Fase 3 | `TAREFAS_FASE3.md` | Checklist do painel admin |
| Matriz consolidada | `evidence/homologacao-final-20261030/matriz-consolidada-requisitos.md` | Síntese de todos os requisitos |

**Código inspecionado:**
- `backend/app/main.py` — montagem de estáticos, lifespan, CORS
- `backend/app/routers/public.py` — endpoints públicos (shoppings, pisos, grafo, rotas, POIs, QR)
- `backend/app/routers/admin.py` — endpoints admin (CRUD completo)
- `backend/app/migrations.py` — `upgrade_schema` idempotente
- `backend/app/database.py` — engine SQLAlchemy
- `backend/tests/conftest.py` — configuração de teste (SQLite padrão, MySQL via `TEST_DATABASE_URL`)
- `backend/tests/test_mysql_homologation.py` — teste de dialeto MySQL
- `admin-panel/tests/admin-crud.spec.ts` — E2E CRUD (corrigido e aprovado)
- `admin-panel/tests/navigation.spec.ts` — E2E navegação, bloqueio/reativação, multi-piso
- `admin-panel/tests/scanner.spec.ts` — E2E scanner simulado
- `admin-panel/tests/performance.spec.ts` — E2E performance 4G simulado

**Evidências de execução verificadas:**
- `evidence/auditoria-diagnostico-20261030-v2/` — admin-crud Chromium aprovado
- `evidence/rnf08-navegadores-20261030/` — admin-crud Firefox/WebKit aprovados
- `evidence/multiuser-diagnostico-20261030/` — multiuser Chromium aprovado
- 88 testes Python aprovados, 1 ignorado (execução anterior)

---

## 2. Inconsistências Encontradas

### 2.1 Inconsistência 1: README menciona MySQL 8.x como requisito de setup, mas os testes usam SQLite por padrão

**Localização:** `README.md`, linhas 15-16, 41-47, 72

**Descrição:**
O README lista "MySQL 8.x" como pré-requisito na seção de requisitos (linha 15) e instrui o usuário a configurar `.env` com credenciais MySQL e criar o banco `navegacao_indoor` (linhas 41-47). No entanto, a linha 72 esclarece explicitamente: "Os testes Python usam SQLite em memória. Não comprovam a persistência em MySQL exigida para o ambiente de produção."

**Problema:** Há uma tensão não resolvida entre o setup documentado (MySQL obrigatório) e a execução real dos testes (SQLite em memória). Um leitor do README pode concluir incorretamente que a homologação MySQL já foi executada ou que não é necessária.

**Evidência correspondente:**
- `backend/tests/conftest.py` linhas 6-7: `os.environ["DATABASE_URL"] = test_database_url or "sqlite:///:memory:"`
- `backend/tests/test_mysql_homologation.py` linhas 9-11: o teste é pulado quando `TEST_DATABASE_URL` não está definido
- Execução anterior: 88 testes aprovados com SQLite, 1 pulado (MySQL não configurado)

**Proposta de correção:**
Adicionar uma nota clara no README (após a linha 72) explicando que:
- Os testes automatizados rodam em SQLite por padrão
- A homologação MySQL é um passo separado, obrigatório para aceitação integral, e não foi concluída neste ambiente
- O procedimento está em `evidence/homologacao-final-20261030/roteiro-homologacao-mysql.md`

---

### 2.2 Inconsistência 2: TAREFAS_FASE3.md menciona "22 testes passando" para upload, mas o número não corresponde à suíte atual

**Localização:** `TAREFAS_FASE3.md`, linha 89

**Descrição:**
A seção 3 ("Backend e Endpoints Adicionados") afirma: "Cobertura de testes automatizados adicionada em `tests/test_api.py` para upload e montagem estática (22 testes passando)."

**Problema:** A suíte atual de testes contém 89 testes totais (88 aprovados + 1 pulado), conforme execução anterior. Não há como verificar isoladamente que "22 testes" se referem especificamente a upload e montagem estática. Além disso, o número 22 não aparece em nenhum relatório de execução disponível.

**Evidência correspondente:**
- Execução do pytest: 88 aprovados, 1 pulado, 0 falhas (total 89)
- Nenhum relatório parcial menciona "22 testes de upload"

**Proposta de correção:**
Corrigir a linha 89 de `TAREFAS_FASE3.md` para remover o número específico "22" ou substituir por uma referência à suíte completa (88 aprovados, 1 pulado), com ponteiro para a evidência de execução.

---

### 2.3 Inconsistência 3: Especificação menciona mapa 3D como critério de aceite (RF04, RF07, RF09, RF08), mas a implementação não possui visão 3D

**Localização:** `especificacao-navegacao-indoor.md`, linhas 34, 55-58, 110-120, 147-149, 171-181

**Descrição:**
A especificação lista "Ambiente 3D Simplificado" como objetivo específico (linhas 55-58), define RF04 (Exibir representação 3D simplificada), RF07 (Calcular rota entre origem e destino utilizando Dijkstra — também menciona 3D), RF08 (Exibir trajeto no mapa 2D e 3D), RF09 (Alternância entre 2D e 3D) e RF07/RF08 (instruções e rota também na visão 3D). Os critérios de aceite da seção 5.4 (linhas 113-119) exigem que a visão 3D represente os mesmos elementos do 2D, que a alternância não recarregue a página e que a rota seja visível na 3D.

**Problema:** A implementação atual não possui visão 3D. O documento `AUDITORIA_FASES_1-3.md` linha 35 confirma: "RF04, RF09, RNF06, RN08; parcela 3D de RF08 — Fora do escopo das Fases 1–3 | Não implementados nem homologados nesta entrega". O `DECISOES.md` item 22 também confirma: "Fase 4 e recursos 3D não foram implementados nesta entrega."

**Evidência correspondente:**
- `especificacao-navegacao-indoor.md` linhas 55-58, 110-120, 147-149, 171-181 — exigem 3D
- `AUDITORIA_FASES_1-3.md` linha 35 — confirma que 3D está fora do escopo
- `DECISOES.md` item 22 — confirma que Fase 4 e 3D não foram implementados
- `README.md` linha 195 — "Fase 4 | Visualização 3D (opcional) | Fora desta entrega; não implementada"

**Proposta de correção:**
O documento acadêmico deve declarar explicitamente que a visão 3D é um requisito de v1.0/Roadmap (não do MVP), conforme já indicado nas linhas 54-62 da especificação. As seções 5.4, 5.7, 5.9 e os requisitos RF04, RF07, RF08, RF09 devem ser marcados como "não implementados nesta entrega" com referência clara ao documento de auditoria.

---

### 2.4 Inconsistência 4: AUDITORIA_FASES_1-3.md linha 24 declara lacuna na cobertura E2E do CRUD que já foi sanada

**Localização:** `AUDITORIA_FASES_1-3.md`, linha 24

**Descrição:**
A matriz de requisitos na linha 24 afirma para RF12: "E2E não cobre cada operação CRUD de todas as telas; persistência MySQL pendente."

**Problema:** Esta afirmação não está mais correta após a correção do seletor "Nó associado *" em `admin-crud.spec.ts` e a reexecução bem-sucedida em Chromium, Firefox e WebKit. O teste E2E agora cobre todas as 10 operações de cadastro e atualização (5 entidades × 2 operações) exigidas pelo RF12 em três navegadores. A única pendência restante é a persistência MySQL (já listada corretamente na mesma célula).

**Evidência correspondente:**
- `evidence/auditoria-diagnostico-20261030-v2/browser-tests.json` — admin-crud Chromium aprovado (11,8s)
- `evidence/rnf08-navegadores-20261030/browser-tests.json` — admin-crud Firefox (41,6s) e WebKit (13,0s) aprovados
- `evidence/homologacao-final-20261030/matriz-consolidada-requisitos.md` — confirma RF10-RF14 como "Comprovado (E2E 3 navegadores)"

**Proposta de correção:**
Atualizar a célula da linha 24 de `AUDITORIA_FASES_1-3.md` para remover a afirmação "E2E não cobre cada operação CRUD de todas as telas" (que já foi corrigida) e manter apenas "persistência MySQL pendente".

---

### 2.5 Inconsistência 5: TAREFAS_FASE2.md menciona endpoints com nomes que não existem na implementação atual

**Localização:** `TAREFAS_FASE2.md`, linhas 85-88

**Descrição:**
A seção 3 lista endpoints consumidos pelo app:
- `GET /api/grafo?piso_id=...` (linha 87)
- `GET /api/rotas?no_origem_id=...&no_destino_id=...&acessivel=...` (linha 88)
- `GET /api/qrcode/{token}` (linha 89)

**Problema:** A implementação atual usa nomes diferentes:
- `GET /api/floors/{piso_id}/graph` (não `/api/grafo?piso_id=...`)
- `POST /api/routes` com corpo JSON (não `GET /api/rotas?...` com query params)
- `GET /api/qr-codes/{token}` (não `/api/qrcode/{token}`)

**Evidência correspondente:**
- `backend/app/routers/public.py` linhas 54, 86, 163 — endpoints reais
- `mobile/services/api.ts` linhas 167-196 — cliente usa os nomes corretos (`/floors/${pisoId}/graph`, `/routes`, `/qr-codes/${token}`)

**Proposta de correção:**
Corrigir os nomes dos endpoints em `TAREFAS_FASE2.md` linhas 87-89 para corresponder à implementação real:
- `GET /api/floors/{piso_id}/graph`
- `POST /api/routes` (com JSON no corpo)
- `GET /api/qr-codes/{token}`

---

### 2.6 Inconsistência 6: README lista "MySQL 8.x" como requisito rígido, mas o ambiente de desenvolvimento aceita SQLite

**Localização:** `README.md`, linha 15

**Descrição:**
O README lista "MySQL 8.x" como requisito na seção de requisitos, mas o `conftest.py` usa SQLite em memória por padrão e o `audit_server.py` também cria um SQLite temporário.

**Problema:** Um desenvolvedor que seguir o README pode tentar configurar MySQL desnecessariamente para rodar os testes locais, ou pode concluir incorretamente que o projeto não funciona sem MySQL.

**Evidência correspondente:**
- `README.md` linha 15 — "MySQL 8.x"
- `backend/tests/conftest.py` linhas 6-7 — fallback para SQLite
- `backend/audit_server.py` linha 17 — `tempfile.mkdtemp` para SQLite temporário

**Proposta de correção:**
Clarear no README que MySQL é necessário apenas para a homologação de produção (não para testes locais em SQLite), e que o servidor de auditoria (`audit_server.py`) usa SQLite temporário por design.

---

### 2.7 Inconsistência 8: RNF08 declarado como "PARCIAL / PENDENTE" em alguns documentos e como ausente em outros

**Localização:** `AUDITORIA_FASES_1-3.md` linha 33; `README.md` linhas 124, 199

**Descrição:**
O `AUDITORIA_FASES_1-3.md` linha 33 declara RNF08 como "**PARCIAL / PENDENTE**". O `README.md` linha 124 afirma "A matriz das duas últimas versões de Chrome, Safari, Firefox e Edge e o teste com cinco usuários continuam pendentes." O `README.md` linha 199 repete "RNF08 é parcial/pendente, nunca N/A".

**Problema:** Não há inconsistência entre estes documentos — todos são coerentes em declarar RNF08 como pendente. No entanto, o `DECISOES.md` item 18 adiciona nuances importantes (Chromium ≠ Chrome, WebKit ≠ Safari) que não estão refletidas no `README.md` de forma tão detalhada.

**Evidência correspondente:**
- `DECISOES.md` item 18 — nuances sobre navegadores
- `AUDITORIA_FASES_1-3.md` linhas 71-85 — matriz efetivamente executada

**Proposta de correção:**
Adicionar ao `README.md` uma referência explícita ao `DECISOES.md` item 18 e ao `AUDITORIA_FASES_1-3.md` linhas 71-85 para manter a consistência da mensagem sobre RNF08.

---

### 2.8 Inconsistência 9: TAREFAS_FASE2.md menciona endpoint `/api/grafo` que não existe

**Localização:** `TAREFAS_FASE2.md`, linha 87

**Descrição:** Já coberta na inconsistência 5, mas merece destaque separado porque é um erro de nome de endpoint que pode confundir desenvolvedores.

**Proposta de correção:** Mesma da inconsistência 5.

---

## 3. Inconsistências Não Encontradas (Verificadas e Confirmadas como Corretas)

| Item | Verificação | Resultado |
|------|-------------|-----------|
| RF12 coberto por E2E em 3 navegadores | `admin-crud.spec.ts` + evidências de execução | ✅ Consistente — 10 operações aprovadas |
| 88 testes Python aprovados | Execução pytest anterior | ✅ Consistente com `README.md` linha 199 |
| RNF08 declarado como parcial/pendente | `AUDITORIA_FASES_1-3.md` linha 33 | ✅ Consistente com evidências |
| RNF09 pendente | `AUDITORIA_FASES_1-3.md` linha 34 | ✅ Consistente com ausência de participantes |
| 3D fora do escopo | `AUDITORIA_FASES_1-3.md` linha 35 | ✅ Consistente com `README.md` linha 195 |
| Hook failed with code 1 — incidente histórico sem resolução | `AUDITORIA_FASES_1-3.md` linhas 93-109 | ✅ Consistente — não declarado como resolvido |
| SQLite em testes locais | `backend/tests/conftest.py` linhas 6-7 | ✅ Consistente com `README.md` linha 72 |

---

## 4. Resumo das Inconsistências por Severidade

| Severidade | Quantidade | Descrição |
|------------|------------|-----------|
| Alta | 2 | Inconsistências 1 e 4 (afirmam estados que não correspondem à realidade atual) |
| Média | 3 | Inconsistências 2, 3 e 5 (nomes de endpoints, número de testes, visão 3D) |
| Baixa | 3 | Inconsistências 6, 7 e 8 (clareza de documentação, nuances de navegador) |

---

## 5. Limitações da Revisão

1. **Não foi possível verificar execução em MySQL** — não há instância disponível no ambiente.
2. **Não foi possível verificar execução em navegadores comerciais (Chrome, Safari, Edge)** — não instalados.
3. **Não foi possível verificar execução em dispositivos físicos** — não há dispositivo móvel disponível.
4. **Não foi possível verificar RNF09** — não há participantes recrutados.
5. **Não foi possível verificar o incidente do hook original** — não há dados do evento original (comando, shell, stderr).
6. A revisão é baseada estritamente nos documentos e códigos presentes no repositório, sem acesso a documentos acadêmicos externos (monografia, TCC formal).

---

## 6. Próximo Passo

Este relatório deve ser apresentado para revisão antes de qualquer modificação nos documentos. Nenhum documento foi alterado nesta etapa. As correções propostas nas seções 2.1 a 2.8 devem ser aplicadas apenas após aprovação do responsável pelo TCC.

---

## 7. Estado do Git

| Item | Valor |
|------|-------|
| Branch | `main` |
| Commit | `fdbf583` |
| `git status --short` | Inalterado (apenas `admin-panel/tests/admin-crud.spec.ts` modificado + arquivos de build + evidências) |
| Commit / Push realizados | **Não** |

---

## 8. Confirmação de Restritivas

| Restrição | Cumprida? |
|-----------|-----------|
| Não executar commit, push, reset, clean, merge ou rebase | ✅ Sim |
| Não instalar ferramentas nem configurar MySQL ou Docker | ✅ Sim |
| Não modificar código da aplicação nem `backend/app/static/` | ✅ Sim |
| Não sobrescrever documentos ou evidências | ✅ Sim |
| Não declarar requisitos pendentes como aprovados | ✅ Sim |
| Salvar relatório em novo diretório dentro de `evidence/` | ✅ Sim (`evidence/revisao-coerencia-final-20261030/`) |

---

**Fim do relatório. Nenhum documento foi modificado. Nenhum commit ou push foi realizado.**
