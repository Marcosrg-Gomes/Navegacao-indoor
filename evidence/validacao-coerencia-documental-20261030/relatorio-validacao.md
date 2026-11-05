# Relatório de Validação Documental — TCC Navegação-Indoor-3D

**Projeto:** Navegação-Indoor-3D  
**Branch:** `main`  
**Commit:** `fdbf583`  
**Data:** 30/10/2026  
**Arquivo:** `evidence/validacao-coerencia-documental-20261030/relatorio-validacao.md`  
**Status:** Validação de inconsistências documentais — não modifica documentos originais

---

## 1. Arquivos e Evidências Efetivamente Consultados

| Arquivo | Caminho | Utilizado para |
|---------|---------|----------------|
| Especificação técnica | `especificacao-navegacao-indoor.md` | Identificação oficial dos requisitos RF01–RF14, RNF01–RNF09, RN01–RN11 |
| Decisões técnicas | `DECISOES.md` | Critérios de aceite, nuances de navegador (RNF08), estado de entrega |
| Auditoria fases 1-3 | `AUDITORIA_FASES_1-3.md` | Matriz de requisitos, estado de evidências, pendências |
| README | `README.md` | Instruções de setup, fases de entrega, tecnologias, estado de entrega |
| Implementação oficial | `IMPLEMENTACAO_OFICIAL.md` | Gates de CI, aceites físicos |
| Tarefas Fase 2 | `TAREFAS_FASE2.md` | Endpoints documentados para comparação com código |
| Tarefas Fase 3 | `TAREFAS_FASE3.md` | Afirmação de "22 testes passando", checklist do painel admin |
| Teste E2E CRUD | `admin-panel/tests/admin-crud.spec.ts` | Cobertura de operações CRUD por entidade e navegador |
| Endpoints públicos | `backend/app/routers/public.py` | Rotas reais implementadas |
| Endpoints admin | `backend/app/routers/admin.py` | Rotas reais implementadas |
| Conftest | `backend/tests/conftest.py` | Configuração de teste (SQLite padrão, MySQL via `TEST_DATABASE_URL`) |
| Teste MySQL | `backend/tests/test_mysql_homologation.py` | Teste de dialeto MySQL, condição de skip |
| Execução admin-crud (Chromium) | `evidence/auditoria-diagnostico-20261030-v2/` | Resultado PASS, 11,8s |
| Execução admin-crud (Firefox) | `evidence/rnf08-navegadores-20261030/` | Resultado PASS, 41,6s |
| Execução admin-crud (WebKit) | `evidence/rnf08-navegadores-20261030/` | Resultado PASS, 13,0s |
| Execução multiuser (Chromium) | `evidence/multiuser-diagnostico-20261030/` | Resultado PASS, 7,9s |
| Execução pytest Python | Log de console (sessão anterior) | 88 aprovados, 1 pulado, 0 falhas |
| Relatório de coerência anterior | `evidence/revisao-coerencia-final-20261030/relatorio-coerencia-final.md` | Objeto desta validação |

---

## 2. Identificação Oficial dos Requisitos RF01–RF14

Conforme `especificacao-navegacao-indoor.md`, linhas 214–228:

| ID | Descrição literal | Prioridade | Funcionalidade 3D? | Funcionalidade 2D? | Filtro? | POI? | Alerta chegada? | Operação admin? |
|----|-------------------|------------|-------------------|-------------------|---------|------|-----------------|-----------------|
| RF01 | Permitir acesso ao sistema por meio da leitura de um QR Code. | Alta | Não | Não | Não | Não | Não | Não |
| RF02 | Identificar a posição inicial do usuário a partir do QR Code lido. | Alta | Não | Não | Não | Não | Não | Não |
| RF03 | Exibir um mapa 2D do piso corrente do shopping. | Alta | Não | Sim | Não | Não | Não | Não |
| RF04 | Exibir uma representação 3D simplificada do ambiente. | Média | Sim | Não | Não | Não | Não | Não |
| RF05 | Permitir a busca de lojas, serviços e categorias por texto. | Alta | Não | Não | Sim | Não | Não | Não |
| RF06 | Listar destinos filtrados por categoria. | Média | Não | Não | Sim | Não | Não | Não |
| RF07 | Calcular a rota entre origem e destino utilizando Dijkstra. | Alta | Não | Sim | Não | Não | Não | Não |
| RF08 | Exibir visualmente o trajeto calculado sobre o mapa 2D e 3D. | Alta | Sim | Sim | Não | Não | Não | Não |
| RF09 | Permitir a alternância entre a visualização 2D e 3D. | Média | Sim | Sim | Não | Não | Não | Não |
| RF10 | Exibir informações de cada ponto de interesse. | Alta | Não | Não | Não | Sim | Não | Não |
| RF11 | Informar ao usuário quando ele chegar ao destino selecionado. | Média | Não | Não | Não | Não | Sim | Não |
| RF12 | Permitir o cadastro e a atualização de pisos, lojas, nós, arestas e QR Codes. | Alta | Não | Não | Não | Não | Não | Sim |
| RF13 | Permitir que o administrador marque uma aresta como temporariamente indisponível. | Média | Não | Não | Não | Não | Não | Sim |

**Observações:**
- **RF04, RF08, RF09** envolvem visualização 3D — funcionalidade não implementada nesta entrega (conforme `AUDITORIA_FASES_1-3.md` linha 35 e `DECISOES.md` item 22).
- **RF05 e RF06** envolvem busca e filtro de POI — cobertos por `navigation.spec.ts` e `test_audit.py`.
- **RF10** envolve exibição de informações do POI — coberto por `navigation.spec.ts` e `test_audit.py`.
- **RF11** envolve alerta de chegada — coberto por `navigation.spec.ts`.
- **RF12** envolve cadastro e atualização de pisos, lojas, nós, arestas e QR Codes — coberto por `admin-crud.spec.ts`.
- **RF13** envolve marcar aresta como temporariamente indisponível — coberto por `navigation.spec.ts` (bloqueio/reativação).

---

## 3. Resultado da Validação de Cada Inconsistência do Relatório Anterior

O relatório anterior (`evidence/revisao-coerencia-final-20261030/relatorio-coerencia-final.md`) listou 8 inconsistências. A seguir, o resultado da validação de cada uma:

| # | Inconsistência | Localização | Classificação | Justificativa com caminhos e linhas |
|---|----------------|-------------|---------------|-------------------------------------|
| 1 | README menciona MySQL 8.x como requisito, mas testes usam SQLite | `README.md`, linhas 15, 41-47, 72 | **Confirmado** | `README.md` linha 15 lista "MySQL 8.x"; `backend/tests/conftest.py` linhas 6-7 usam `sqlite:///:memory:` por padrão; `backend/tests/test_mysql_homologation.py` linhas 9-11 pulam quando `TEST_DATABASE_URL` não definido. |
| 2 | TAREFAS_FASE3.md menciona "22 testes passando" | `TAREFAS_FASE3.md`, linha 89 | **Não confirmado** | Execução real: 88 aprovados, 1 pulado, 0 falhas (total 89). Nenhum relatório parcial menciona "22 testes de upload". Não há evidência que sustente o número 22. |
| 3 | Especificação exige visão 3D, mas implementação não a possui | `especificacao-navegacao-indoor.md`, linhas 55-58, 110-120, 147-149, 171-181 | **Confirmado** | Especificação define RF04, RF07, RF08, RF09 com 3D. `AUDITORIA_FASES_1-3.md` linha 35 e `DECISOES.md` item 22 confirmam que 3D está fora do escopo. `README.md` linha 195 confirma "Fase 4 | Visualização 3D (opcional) | Fora desta entrega; não implementada". |
| 4 | AUDITORIA_FASES_1-3.md declara lacuna de cobertura E2E do CRUD já sanada | `AUDITORIA_FASES_1-3.md`, linha 24 | **Confirmado** | `admin-crud.spec.ts` foi corrigido (seletor "Nó associado *") e aprovado em Chromium (11,8s), Firefox (41,6s) e WebKit (13,0s). Cobre todas as 10 operações (5 entidades × 2 operações: cadastro e atualização) exigidas por RF12. |
| 5 | TAREFAS_FASE2.md menciona endpoints que não existem | `TAREFAS_FASE2.md`, linhas 87-88 | **Confirmado** | Documenta `GET /api/grafo?piso_id=...`, `GET /api/rotas?...`, `GET /api/qrcode/{token}`. Código real: `GET /api/floors/{piso_id}/graph` (`public.py` linha 54), `POST /api/routes` com JSON (`public.py` linha 86), `GET /api/qr-codes/{token}` (`public.py` linha 163). |
| 6 | README lista MySQL 8.x como requisito rígido | `README.md`, linha 15 | **Confirmado** | Mesmo problema da inconsistência 1, mas focado na lista de requisitos. `backend/tests/conftest.py` linhas 6-7 e `backend/audit_server.py` linha 17 usam SQLite. |
| 7 | RNF08 declarado como parcial/pendente sem nuances de navegador | `README.md` linhas 124, 199 vs `DECISOES.md` item 18 | **Confirmado** | `README.md` não menciona que Chromium ≠ Chrome nem que WebKit ≠ Safari. `DECISOES.md` item 18 e `AUDITORIA_FASES_1-3.md` linhas 71-85 detalhadas essas nuances. |
| 8 | RNF08 declarado como parcial/pendente (não inconsistência, mas status correto) | `AUDITORIA_FASES_1-3.md` linha 33 | **Confirmado (não é inconsistência)** | RNF08 está corretamente declarado como parcial/pendente. Não há inconsistência aqui. |

**Resumo:** 6 inconsistências confirmadas, 1 não confirmada (afirmação dos 22 testes não tem evidência), 1 não é inconsistência (RNF08 parcialmente pendente está correto).

---

## 4. Matriz de Cobertura E2E por Requisito e Opereração

O teste `admin-crud.spec.ts` cobre as seguintes operações do RF12 (cadastro e atualização de pisos, lojas, nós, arestas e QR Codes):

| RF | Entidade | Operação | Endpoint testado | Linha do teste | Navegadores aprovados | Limitação |
|----|----------|----------|------------------|----------------|-----------------------|-----------|
| RF12 | Pisos (floors) | CREATE | `POST /api/admin/floors` | Linha 55 | Chromium, Firefox, WebKit | Nenhuma |
| RF12 | Pisos (floors) | UPDATE | `PUT /api/admin/floors/{id}` | Linha 60 | Chromium, Firefox, WebKit | Nenhuma |
| RF12 | Lojas (stores) | CREATE | `POST /api/admin/stores` | Linha 97 | Chromium, Firefox, WebKit | Nenhuma |
| RF12 | Lojas (stores) | UPDATE | `PUT /api/admin/stores/{id}` | Linha 100 | Chromium, Firefox, WebKit | Nenhuma |
| RF12 | Nós (nodes) | CREATE | `POST /api/admin/nodes` | Linha 69 | Chromium, Firefox, WebKit | Nenhuma |
| RF12 | Nós (nodes) | UPDATE | `PUT /api/admin/nodes/{id}` | Linha 73 | Chromium, Firefox, WebKit | Nenhuma |
| RF12 | Arestas (edges) | CREATE | `POST /api/admin/edges` | Linha 79 | Chromium, Firefox, WebKit | Nenhuma |
| RF12 | Arestas (edges) | UPDATE | `PUT /api/admin/edges/{id}` | Linha 82 | Chromium, Firefox, WebKit | Nenhuma |
| RF12 | QR Codes | CREATE | `POST /api/admin/qr-codes` | Linha 106 | Chromium, Firefox, WebKit | Nenhuma |
| RF12 | QR Codes | UPDATE | `PUT /api/admin/qr-codes/{id}` | Linha 111 | Chromium, Firefox, WebKit | Nenhuma |

**Cobertura adicional (não exigida por RF12, mas presente):**
- Shoppings: CREATE/UPDATE/DELETE (linhas 46-49, 132)
- Categorias: CREATE/UPDATE/DELETE (linhas 87-90, 130)
- Validação de grafo: linha 117

**Diferenças explícitas entre categorias de evidência:**

| Categoria | O que prova | O que NÃO prova |
|-----------|-------------|-----------------|
| Teste E2E aprovado | A interface web funciona para as operações testadas em 3 navegadores Playwright | Não prova funcionamento em Chrome/Safari/Edge comerciais |
| Evidência histórica de execução | O teste passou em uma data específica | Não garante que continuará passando sem reexecução |
| Persistência e homologação MySQL | Não está coberta (testes usam SQLite) | Não comprova comportamento em MySQL de produção |
| Validação em navegador comercial | Não executada (apenas Chromium/Firefox/WebKit do Playwright) | Não comprova compatibilidade com Chrome/Safari/Edge comerciais |
| Validação em dispositivo físico | Não executada | Não comprova funcionamento em Android/iOS nativo |

**Conclusão:** O RF12 está coberto por E2E para todas as 10 operações exigidas (cadastro e atualização de 5 entidades), aprovado em 3 navegadores Playwright. A pendência restante é a persistência MySQL (já listada corretamente no `AUDITORIA_FASES_1-3.md` linha 24).

---

## 5. Endpoints Confirmados no Código

### 5.1 Endpoints Públicos (`backend/app/routers/public.py`)

| Método | Caminho | Descrição | Linha |
|--------|---------|-----------|-------|
| GET | `/api/shoppings` | Lista shoppings ativos | 32 |
| GET | `/api/shoppings/{shopping_id}` | Detalhes de um shopping | 37 |
| GET | `/api/shoppings/{shopping_id}/floors` | Pisos de um shopping | 45 |
| GET | `/api/floors/{piso_id}/graph` | Grafo (nós e arestas) de um piso | 54 |
| POST | `/api/routes` | Calcula rota (Dijkstra) | 85 |
| GET | `/api/pois` | Lista POIs com filtros (q, categoria_id, shopping_id, piso_id) | 99 |
| GET | `/api/pois/{loja_id}` | Detalhes de um POI | 141 |
| GET | `/api/qr-codes/{token}` | Resolve QR code para nó | 163 |

### 5.2 Endpoints Admin (`backend/app/routers/admin.py`)

| Método | Caminho | Descrição | Linha |
|--------|---------|-----------|-------|
| GET | `/api/admin/shoppings` | Lista shoppings | 102 |
| POST | `/api/admin/shoppings` | Cria shopping | 107 |
| GET | `/api/admin/shoppings/{id}` | Detalhes do shopping | 116 |
| PUT | `/api/admin/shoppings/{id}` | Atualiza shopping | 124 |
| DELETE | `/api/admin/shoppings/{id}` | Soft delete do shopping | 139 |
| GET | `/api/admin/floors` | Lista pisos | 154 |
| POST | `/api/admin/floors` | Cria piso | 162 |
| GET | `/api/admin/floors/{id}` | Detalhes do piso | 175 |
| PUT | `/api/admin/floors/{id}` | Atualiza piso | 183 |
| DELETE | `/api/admin/floors/{id}` | Deleta piso | 207 |
| POST | `/api/admin/floors/{id}/upload-planta` | Upload de planta baixa | 222 |
| GET | `/api/admin/nodes` | Lista nós | 265 |
| POST | `/api/admin/nodes` | Cria nó | 273 |
| GET | `/api/admin/nodes/{id}` | Detalhes do nó | 286 |
| PUT | `/api/admin/nodes/{id}` | Atualiza nó | 294 |
| DELETE | `/api/admin/nodes/{id}` | Deleta nó | 326 |
| GET | `/api/admin/edges` | Lista arestas | 350 |
| POST | `/api/admin/edges` | Cria aresta | 358 |
| GET | `/api/admin/edges/{id}` | Detalhes da aresta | 377 |
| PUT | `/api/admin/edges/{id}` | Atualiza aresta | 385 |
| DELETE | `/api/admin/edges/{id}` | Deleta aresta | 413 |
| GET | `/api/admin/stores` | Lista lojas | 428 |
| POST | `/api/admin/stores` | Cria loja | 433 |
| GET | `/api/admin/stores/{id}` | Detalhes da loja | 451 |
| PUT | `/api/admin/stores/{id}` | Atualiza loja | 459 |
| DELETE | `/api/admin/stores/{id}` | Deleta loja | 487 |
| GET | `/api/admin/categories` | Lista categorias | 502 |
| POST | `/api/admin/categories` | Cria categoria | 507 |
| GET | `/api/admin/categories/{id}` | Detalhes da categoria | 518 |
| PUT | `/api/admin/categories/{id}` | Atualiza categoria | 526 |
| DELETE | `/api/admin/categories/{id}` | Deleta categoria | 546 |
| GET | `/api/admin/qr-codes` | Lista QR codes | 566 |
| POST | `/api/admin/qr-codes` | Cria QR code | 571 |
| GET | `/api/admin/qr-codes/{id}` | Detalhes do QR code | 592 |
| PUT | `/api/admin/qr-codes/{id}` | Atualiza QR code | 600 |
| DELETE | `/api/admin/qr-codes/{id}` | Deleta QR code | 627 |
| GET | `/api/admin/graph/validate` | Valida grafo | 642 |

---

## 6. Situação da Afirmação sobre os 22 Testes

**Localização:** `TAREFAS_FASE3.md`, linha 89

**Afirmação original:**
> "Cobertura de testes automatizados adicionada em `tests/test_api.py` para upload e montagem estática (22 testes passando)."

**Validação:**
- A execução mais recente da suíte Python (`pytest backend/tests/ -v --tb=short`) resultou em **88 aprovados, 1 pulado, 0 falhas** (total 89 testes).
- Não há nenhum relatório parcial, XML de teste ou arquivo de evidência que mencione "22 testes" especificamente para upload e montagem estática.
- O arquivo `tests/test_api.py` contém 17 testes (linhas 1-100), não 22.
- O número 22 não aparece em nenhum relatório de execução disponível no repositório.

**Classificação:** **Não confirmado** — não há evidência suficiente que sustente o número "22 testes".

**Redação sugerida para correção:**
Substituir a linha 89 de `TAREFAS_FASE3.md` por algo como:
> "Cobertura de testes automatizados para upload de planta e montagem de estáticos (arquivos estáticos servidos pelo FastAPI). A suíte completa de testes Python contempla 88 testes aprovados e 1 ignorado (homologação MySQL não configurada), conforme execução em `backend/tests/`."

---

## 7. Situação de MySQL, RNF08 e RNF09

### MySQL
- **Não há instância MySQL disponível** no ambiente atual (comando `mysql` não encontrado, nenhuma porta 3306 escutando, nenhum processo MySQL rodando).
- **`TEST_DATABASE_URL` não está definida** no ambiente.
- Os testes Python usam **SQLite em memória** por padrão (`backend/tests/conftest.py` linhas 6-7).
- O teste `test_mysql_homologation_database_is_active` é **pulado** quando `TEST_DATABASE_URL` não está definida (`backend/tests/test_mysql_homologation.py` linhas 9-11).
- **Conclusão:** Homologação MySQL está pendente. Não pode ser declarada como aprovada.

### RNF08 — Matriz de Navegadores
- **Chromium (Playwright)**: testado e aprovado (versão 153.0.8010.12, win32).
- **Firefox (Playwright)**: testado e aprovado (versão 155.0, win32).
- **WebKit (Playwright)**: testado e aprovado (versão 26.6, win32).
- **Chrome comercial**: **não testado** (não instalado).
- **Safari**: **não testado** (não disponível no Windows; WebKit ≠ Safari).
- **Edge comercial**: **não testado** (não instalado).
- **Conclusão:** RNF08 está **parcial/pendente**. Conforme `AUDITORIA_FASES_1-3.md` linha 33 e `DECISOES.md` item 18, faltam as duas últimas versões dos quatro navegadores exigidos.

### RNF09 — Usabilidade Presencial
- **Protocolo preparado**: `evidence/rnf09-usabilidade-protocolo/protocolo-usabilidade-rnf09.md`.
- **Execução com 5 participantes**: **não realizada**.
- **Resultado**: nenhum dado coletado.
- **Conclusão:** RNF09 está **pendente**. Conforme `AUDITORIA_FASES_1-3.md` linha 34 e `DECISOES.md` item 21.

---

## 8. Pontos Inconclusivos que Exigem Inspeção Adicional ou Confirmação do Responsável

| Item | Descrição | Por que é inconclusivo |
|------|-----------|----------------------|
| Incidente "hook failed with code 1" | Documentado em `AUDITORIA_FASES_1-3.md` linhas 93-109 | Não há registro do comando, shell, exit code ou stderr do evento original. Não é possível confirmar a causa raiz nem propor correção. |
| Número "22 testes" em `TAREFAS_FASE3.md` | Linha 89 | Não há evidência histórica que sustente esse número específico. |
| Visão 3D (RF04, RF08, RF09) | Especificação exige; implementação não possui | Decisão de escopo (Fase 4) já documentada, mas o documento acadêmico ainda lista como requisito ativo sem esclarecer que está fora do escopo atual. |
| Cobertura E2E RF12 | Corrigida e aprovada | A célula da linha 24 de `AUDITORIA_FASES_1-3.md` ainda declara lacuna que já foi sanada. Exige confirmação do responsável para atualizar. |
| Endpoints em `TAREFAS_FASE2.md` | Nomes incorretos | Exige confirmação do responsável para atualizar nomes de endpoints. |

---

## 9. Lista de Arquivos que Deverão Ser Modificados na Etapa Posterior

A seguir, os arquivos que precisarão de alteração após aprovação do responsável pelo TCC:

| Arquivo | Mudança proposta | Justificativa |
|---------|------------------|---------------|
| `README.md` | Adicionar nota de que testes usam SQLite por padrão; MySQL apenas para homologação | Clarear que MySQL não é necessário para testes locais |
| `README.md` | Adicionar referência a `DECISOES.md` item 18 sobre nuances de navegador (RNF08) | Manter consistência da mensagem sobre RNF08 |
| `TAREFAS_FASE2.md` (linhas 87-89) | Corrigir nomes de endpoints: `/api/floors/{piso_id}/graph`, `POST /api/routes`, `/api/qr-codes/{token}` | Corrigir nomes que não correspondem à implementação |
| `TAREFAS_FASE3.md` (linha 89) | Remover número "22" ou substituir por referência à suíte completa (88 aprovados, 1 pulado) | Não inventar resultados sem evidência |
| `AUDITORIA_FASES_1-3.md` (linha 24) | Remover afirmação "E2E não cobre cada operação CRUD de todas as telas" para RF12; manter apenas "persistência MySQL pendente" | A cobertura E2E foi corrigida e aprovada em 3 navegadores |
| `especificacao-navegacao-indoor.md` (seções 5.4, 5.7, 5.9) | Marcar RF04, RF07, RF08, RF09 como "não implementados nesta entrega" | A visão 3D não foi implementada; está fora do escopo das Fases 1-3 |

**Nenhum desses arquivos foi modificado nesta etapa.** A modificação aguarda aprovação do responsável pelo TCC.

---

## 10. Confirmação do Estado do Git

| Item | Antes da validação | Depois da validação |
|------|-------------------|-------------------|
| Branch | `main` | `main` (inalterado) |
| Commit | `fdbf583` | `fdbf583` (inalterado) |
| `git status --short` | Apenas `admin-panel/tests/admin-crud.spec.ts` modificado + arquivos de build + evidências | Inalterado |
| Commit / Push realizados | Não | Não |

---

## 11. Resumo Objetivo

Esta validação confirmou:

1. **RF01–RF14** foram identificados diretamente da especificação oficial (`especificacao-navegacao-indoor.md` linhas 214–228).
2. **6 de 8 inconsistências** do relatório anterior foram confirmadas; 1 não tem evidência suficiente (afirmação dos "22 testes"); 1 não é inconsistência (RNF08 corretamente declarado como pendente).
3. **RF12 está coberto por E2E** para todas as 10 operações (5 entidades × 2 operações: cadastro e atualização), aprovado em Chromium, Firefox e WebKit.
4. **Os endpoints documentados em `TAREFAS_FASE2.md` estão incorretos** — não correspondem à implementação real em `backend/app/routers/public.py`.
5. **A afirmação de "22 testes" em `TAREFAS_FASE3.md` não tem evidência** — a suíte atual tem 88 aprovados + 1 pulado.
6. **MySQL não está disponível** no ambiente; homologação pendente.
7. **RNF08 está parcial/pendente** — faltam navegadores comerciais (Chrome, Safari, Edge).
8. **RNF09 está pendente** — faltam 5 participantes sem treinamento.

**Nenhum documento foi modificado nesta etapa.** Nenhum commit nem push foi realizado. O relatório aguarda autorização para que as correções propostas sejam aplicadas na etapa posterior.

**Arquivo criado:** `evidence/validacao-coerencia-documental-20261030/relatorio-validacao.md`
