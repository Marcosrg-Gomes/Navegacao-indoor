# Matriz Consolidada de Requisitos e Evidências — TCC Navegação Indoor 3D

**Projeto:** Navegação-Indoor-3D  
**Branch:** `main`  
**Commit:** `fdbf583` Remoção distill.exe e o app-release.aab da árvore versionada  
**Data:** 03/11/2026  
**Arquivo:** `evidence/consolidacao-final-requisitos-20261103/matriz-consolidada-final.md`  
**Status:** Apenas auditoria e documentação — nenhum arquivo modificado

---

## 1. Metodologia e Fontes

Esta matriz consolida os resultados das auditorias realizadas em 03/11/2026, comparando a especificação oficial (`especificacao-navegacao-indoor.md`) com o código integrado (`backend/`, `admin-panel/`, `mobile/`), testes automatizados e evidências de execução.

**Fontes consultadas:**
- `especificacao-navegacao-indoor.md` — requisitos RF01–RF13, RNF01–RNF09, RN01–RN11, plano de fases
- `evidence/auditoria-final-requisitos-20261103/relatorio.md` — auditoria de RFs
- `evidence/auditoria-final-rnfs-20261103/relatorio.md` — auditoria de RNFs
- `evidence/retomada-final-tcc-20261103/relatorio-retomada.md` — estado do repositório e pendências
- `evidence/correcao-rnf03-final-20261103/relatorio.md` — validação do RNF03
- `evidence/performance-correcao-rnf03-20261103.json` — dados de desempenho RNF03
- `evidence/correcoes-documentais-finais-20261103/relatorio.md` — correções documentais

---

## 2. Matriz de Requisitos Funcionais (RF01–RF13)

### 2.1 Classificação Individual dos 13 Requisitos

| ID | Descrição oficial (especificação seção 7) | Prioridade | Situação da implementação | Classificação no MVP |
|----|-------------------------------------------|------------|---------------------------|----------------------|
| RF01 | Permitir acesso ao sistema por meio da leitura de um QR Code. | Alta | Implementado e testado | Dentro do MVP |
| RF02 | Identificar a posição inicial do usuário a partir do QR Code lido. | Alta | Implementado e testado | Dentro do MVP |
| RF03 | Exibir um mapa 2D do piso corrente do shopping. | Alta | Implementado e testado | Dentro do MVP |
| RF04 | Exibir uma representação 3D simplificada do ambiente. | Média | Não implementado | Fora do MVP (Fase 4) |
| RF05 | Permitir a busca de lojas, serviços e categorias por texto. | Alta | Implementado e testado | Dentro do MVP |
| RF06 | Listar destinos filtrados por categoria. | Média | Implementado e testado | Dentro do MVP |
| RF07 | Calcular a rota entre origem e destino utilizando Dijkstra. | Alta | Implementado e testado | Dentro do MVP |
| RF08 | Exibir visualmente o trajeto calculado sobre o mapa 2D e 3D. | Alta | Parcialmente implementado | Dentro do MVP (2D); fora (3D) |
| RF09 | Permitir a alternância entre a visualização 2D e 3D. | Média | Não implementado | Fora do MVP (Fase 4) |
| RF10 | Exibir informações de cada ponto de interesse. | Alta | Implementado e testado | Dentro do MVP |
| RF11 | Informar ao usuário quando ele chegar ao destino selecionado. | Média | Implementado e testado | Dentro do MVP |
| RF12 | Permitir o cadastro e a atualização de pisos, lojas, nós, arestas e QR Codes. | Alta | Implementado e testado | Dentro do MVP |
| RF13 | Permitir que o administrador marque uma aresta como temporariamente indisponível. | Média | Implementado e testado | Dentro do MVP |

### 2.2 Contagem Corrigida (sem dupla contagem)

| Categoria | Quantidade | Requisitos |
|-----------|------------|------------|
| Implementado e testado | **10** | RF01, RF02, RF03, RF05, RF06, RF07, RF10, RF11, RF12, RF13 |
| Parcialmente implementado | **1** | RF08 (2D completo; 3D não implementado) |
| Não implementado (fora do escopo MVP) | **2** | RF04, RF09 |
| **Total** | **13** | RF01–RF13 |

**Explicação da diferença entre implementação parcial e validação parcial:**
- **Implementação parcial (RF08):** o código existe para parte dos critérios de aceite (mapa 2D com rota desenhada, distância, instruções, notificação de chegada), mas não para todos (visão 3D não existe). É uma lacuna de implementação, não de validação.
- **Validação parcial (RNF02, RNF07):** o código existe e atende os critérios, mas a validação foi feita em ambiente limitado (apenas Chromium desktop, não dispositivos físicos; teste de rede falha apenas para busca de POIs, não operação offline completa). É uma lacuna de evidência de validação, não de código.

### 2.3 Detalhamento por Requisito Funcional

| ID | Testes existentes | Evidência (caminho exato) | Limitação |
|----|-------------------|---------------------------|-----------|
| RF01 | `test_resolver_qr_code` (backend); `navigation.spec.ts`, `scanner.spec.ts` (E2E) | `evidence/correcao-rnf03-final-20261103/relatorio.md` (endpoint `/qr-codes/{token}` → 200); `admin-panel/tests/navigation.spec.ts` | Leitura óptica com câmera física não testada (apenas simulada) |
| RF02 | `test_resolver_qr_code`; `navigation.spec.ts` (origin-label) | `evidence/correcao-rnf03-final-20261103/relatorio.md`; `admin-panel/tests/navigation.spec.ts` | Seleção manual sem QR pouco coberta em E2E |
| RF03 | `test_grafo_piso` (backend); `navigation.spec.ts` (floor-map) | `evidence/correcao-rnf03-final-20261103/relatorio.md`; `admin-panel/tests/navigation.spec.ts` | Zoom/pan não testados em E2E |
| RF04 | — | — | Não implementado (Fase 4) |
| RF05 | `test_buscar_pois`; `navigation.spec.ts` (busca "Tech") | `backend/tests/test_api.py`; `admin-panel/tests/navigation.spec.ts` | Sugestões automáticas não testadas em E2E |
| RF06 | `test_closed_maintenance_and_category_search`; `navigation.spec.ts` (chip categoria) | `backend/tests/test_audit.py`; `admin-panel/tests/navigation.spec.ts` | Filtro por categoria isolado não testado em E2E |
| RF07 | `test_calcular_rota` + 7 testes de navegação (backend); `navigation.spec.ts` (Traçar rota) | `backend/tests/test_navigation.py`; `admin-panel/tests/navigation.spec.ts` | Limite <1s não testado via rede simulada em E2E |
| RF08 | `test_instrucoes_geradas`; `navigation.spec.ts` (route-panel, chegada) | `backend/tests/test_audit.py`; `admin-panel/tests/navigation.spec.ts` | Visão 3D não implementada (Fase 4) |
| RF09 | — | — | Não implementado (Fase 4) |
| RF10 | `test_closed_maintenance_and_category_search`; `navigation.spec.ts` (status manutenção) | `backend/tests/test_audit.py`; `admin-panel/tests/navigation.spec.ts` | Painel de detalhes por clique não testado em E2E |
| RF11 | `navigation.spec.ts` (Cheguei ao destino) | `admin-panel/tests/navigation.spec.ts` | — |
| RF12 | `test_admin_criar_no`, `test_upload_planta_piso`, `test_every_admin_operation_requires_key`; `admin-crud.spec.ts` | `backend/tests/test_api.py`; `admin-panel/tests/admin-crud.spec.ts` | Upload de planta válida em E2E não testado (apenas malformado) |
| RF13 | `test_block_reactivate_no_stale_graph`; `navigation.spec.ts` (bloquear/reativar) | `backend/tests/test_audit.py`; `admin-panel/tests/navigation.spec.ts` | — |

---

## 3. Matriz de Requisitos Não Funcionais (RNF01–RNF09)

| ID | Descrição oficial (especificação seção 8) | Critério / Métrica | Situação da implementação | Situação da validação | Testes executados | Evidências | Limitações | Dependências externas |
|----|-------------------------------------------|-------------------|---------------------------|----------------------|-------------------|------------|------------|----------------------|
| RNF01 | Execução em navegador e app mobile (React Native). | Sem duas bases de código para Android e iOS. | Implementado | Validado | `navigation.spec.ts` (viewport 360×640, 414×896) | `evidence/correcao-rnf03-final-20261103/relatorio.md`; `admin-panel/tests/navigation.spec.ts` | Build nativo não gera APK/IPA; não validado em dispositivo físico | — |
| RNF02 | Interface responsiva, priorizando smartphones. | Layout testado em 360×640 a 414×896. | Implementado | Validação parcial | `navigation.spec.ts` linha 111 (scrollWidth ≤ viewport) | `evidence/e2e-20261026-221544-*` (screenshots); `admin-panel/tests/navigation.spec.ts` | Validado apenas em Chromium desktop; não em dispositivos físicos | — |
| RNF03 | Sistema carrega e responde rapidamente. | Mapa ≤ 3s; rota ≤ 1s. | Implementado | Validado | `test_mvp_measured_latency` (backend); `performance.spec.ts` (E2E) | `evidence/performance-correcao-rnf03-20261103.json`; `evidence/correcao-rnf03-final-20261103/relatorio.md` | Teste mede latência local SQLite, não rede 4G simulada (backend); E2E validado em 4G simulado | Servidor `audit_server.py` na porta 8765 |
| RNF04 | Coordenadas independentes da resolução. | Coordenadas normalizadas entre 0 e 1. | Implementado | Validado | `test_normalized_coordinates_create_update`; `test_null_patches_never_corrupt_required_fields` | `backend/tests/test_audit.py` | — | — |
| RNF05 | Arquitetura modular. | Separação clara entre frontend, backend e dados. | Implementado | Validado | — | Estrutura de diretórios (`backend/`, `admin-panel/`, `mobile/`) | — | — |
| RNF06 | Mapa 2D e visão 3D consistentes. | Mesmos nós, arestas e pontos de interesse. | Não implementado | Não se aplica (fora do MVP) | — | `AUDITORIA_FASES_1-3.md` linha 35; `DECISOES.md` item 22 | Visão 3D não implementada (Fase 4) | — |
| RNF07 | Navegação confiável sem dependência de conectividade de alta largura. | Sem dependência de conectividade de alta largura. | Implementado | Validação parcial | `navigation.spec.ts` linhas 118-127 (falha de rede → mensagem + retry) | `admin-panel/tests/navigation.spec.ts` | Não há teste de operação offline completa; apenas busca de POIs | — |
| RNF08 | Navegadores modernos mais utilizados. | Chrome, Safari, Firefox, Edge (últimas 2 versões cada). | Implementado (código padrão) | Não validado por falta de ambiente | `admin-crud.spec.ts` (Chromium, Firefox, WebKit) | `evidence/rnf08-navegadores-20261030/`; `evidence/auditoria-diagnostico-20261030-v2/` | Chromium ≠ Chrome; WebKit ≠ Safari; Chrome/Edge/Safari comerciais não instalados | Navegadores comerciais (SENAI) |
| RNF09 | Interface simples para uso sem treinamento. | Teste de usabilidade com 5 usuários sem instrução. | Implementado (interface existe) | Não validado por falta de participantes | — | `evidence/rnf09-usabilidade-protocolo/protocolo-usabilidade-rnf09.md` (protocolo preparado, não executado) | Nenhum dado de participante coletado | 5 participantes sem treinamento (presencial) |

### Classificação dos RNFs (sem dupla contagem)

| Categoria | Quantidade | RNFs |
|-----------|------------|------|
| Implementado e validado | **4** | RNF01, RNF03, RNF04, RNF05 |
| Implementado, validação parcial | **2** | RNF02, RNF07 |
| Implementado, não validado por falta de ambiente | **2** | RNF08, RNF09 |
| Não implementado (fora do escopo MVP) | **1** | RNF06 |
| **Total** | **9** | RNF01–RNF09 |

---

## 4. Consolidação das Evidências de Testes

### 4.1 Testes Backend (Python)

**Execução registrada em 03/11/2026:** `pytest tests/ -v` a partir de `backend/`

| Métrica | Valor |
|---------|-------|
| Total de testes | 89 |
| Aprovados | 88 |
| Pulados | 1 |
| Falhas | 0 |
| Duração | 3,02s |

**Teste pulado:** `test_mysql_homologation_database_is_active` — motivo: `TEST_DATABASE_URL` não definida (não há instância MySQL disponível).

**Arquivos de teste e cobertura:**

| Arquivo | Quantidade de testes | Cobertura principal |
|---------|---------------------|---------------------|
| `test_api.py` | 17 | Endpoints públicos (shoppings, pisos, grafo, rotas, POIs, QR codes), admin básico, upload planta, static mount |
| `test_audit.py` | 52 (incluindo parametrizações) | Validações de negócio, bloqueio/reativação de aresta, grafo multipiso, QR único, latência MVP, admin auth, coordenadas normalizadas |
| `test_navigation.py` | 8 | Motor Dijkstra: rota válida, sem caminho, aresta inativa, acessível, bidirecional, nó inexistente, instruções, distância |
| `test_mysql_homologation.py` | 1 | Dialeto MySQL (pulso sem `TEST_DATABASE_URL`) |

**Lacunas de cobertura identificadas:**
- Nenhum teste de `GET /api/shoppings/{id}` com dados reais (apenas 404 para inexistente).
- Nenhum teste de `PUT /api/admin/floors/{id}/upload-planta` com arquivo válido (apenas rejeição de malformados).
- Nenhum teste de rota entre pisos via API pública (apenas via admin em `test_audit.py`).
- `test_mvp_measured_latency` mede latência local SQLite, não rede 4G simulada.

### 4.2 Testes E2E (Playwright)

**Execução registrada na auditoria final (30/10/2026):**

| Arquivo | Testes | Navegadores | Resultado | Cobertura |
|---------|--------|-------------|-----------|-----------|
| `admin-crud.spec.ts` | 1 | Chromium, Firefox, WebKit | 1 aprovado (cada) | CRUD completo RF12 (10 operações) |
| `navigation.spec.ts` | 5 | Chromium | 5 aprovados | RF01–RF11, RF13, RNF02 |
| `scanner.spec.ts` | 1 | Chromium (simulado) | 1 aprovado | RF01, RF02 |
| `performance.spec.ts` | 1 | Chromium | 1 falhou (infraestrutura de trace) | RNF03 |
| `multiuser.spec.ts` | 1 | Chromium | 1 aprovado | RNF03 concorrente |

**Total E2E:** 9 testes executados, 8 aprovados, 1 falhou por infraestrutura (não por aplicação).

**Execução de RNF03 em 03/11/2026:** `npx playwright test tests/performance.spec.ts --project chromium` — **1 aprovado** (25,4s).

| Amostra | mapMs (limite ≤ 3000) | routeMs (limite ≤ 1000) |
|---------|----------------------|------------------------|
| 1 | 2695 | 710 |
| 2 | 2265 | 666 |
| 3 | 2036 | 666 |
| 4 | 1960 | 662 |
| 5 | 1985 | 635 |

**Máximos observados:** mapMs = 2695 ms (≤ 3000 ✓); routeMs = 710 ms (≤ 1000 ✓).

**Arquivo de dados:** `evidence/performance-correcao-rnf03-20261103.json`.

### 4.3 Testes que não puderam ser executados

| Teste | Motivo |
|-------|--------|
| `navigation.spec.ts` — Firefox, WebKit | Não executado na rodada mais recente |
| `scanner.spec.ts` — Firefox, WebKit | Não executado |
| `performance.spec.ts` — Firefox, WebKit | Não executado |
| `admin-crud.spec.ts` — Firefox, WebKit | Aprovado anteriormente, não reexecutado na rodada mais recente |
| Testes MySQL | Pulado automaticamente (`TEST_DATABASE_URL` não definida) |
| Testes em dispositivos físicos (mobile nativo) | Não há dispositivo disponível |
| Testes com câmera física | Não há câmera disponível para leitura óptica de QR Code |

### 4.4 Distinção: Simulação vs. Leitura Ótica Física

- **RF01/RF02 (QR Code):** A resolução de token via `/api/qr-codes/{token}` é implementada e testada. No entanto, a leitura óptica com câmera física é **simulada** no teste `scanner.spec.ts` (MediaStream sintético via canvas). Não há validação com câmera física em dispositivo real.
- **RNF01 (execução mobile):** O código compartilhado entre web e native existe (Expo + React Native), mas o build nativo não gera APK/IPA e não valida execução em dispositivo físico.

---

## 5. Quadro de Pendências

### A. Executáveis em Casa (sem recursos externos)

| # | Requisito relacionado | O que falta | Como validar | Evidência esperada | Prioridade |
|---|----------------------|-------------|--------------|--------------------|------------|
| A1 | RF12 (documentação) | `TAREFAS_FASE2.md` já corrigido endpoints; verificar se não restam inconsistências | Ler `TAREFAS_FASE2.md` linhas 84-89 e comparar com `backend/app/routers/public.py` | Nenhuma inconsistência restante | Baixa |
| A2 | RF12 (documentação) | `TAREFAS_FASE3.md` já corrigido (removido "22 testes"); verificar | Ler `TAREFAS_FASE3.md` linha 89 | Referência à suíte completa (88 aprovados, 1 pulado) | Baixa |
| A3 | README (documentação) | Já corrigido (MySQL diferenciado); verificar | Ler `README.md` linhas 15 e 72 | MySQL apenas para homologação; SQLite para testes locais | Baixa |
| A4 | RNF02 | Reexecutar `navigation.spec.ts` em Firefox e WebKit | `cd admin-panel; npx playwright test tests/navigation.spec.ts --project=firefox` e `--project=webkit` | Relatórios JSON com status aprovado | Média |
| A5 | RNF03 | Revalidar após qualquer mudança | `cd backend; python audit_server.py --port 8765` + `cd admin-panel; npx playwright test tests/performance.spec.ts --project chromium` | mapMs ≤ 3000, routeMs ≤ 1000 em 5 amostras | Alta |
| A6 | RF07–RF13 | Reexecutar `pytest tests/ -v` no backend | `cd backend; pytest tests/ -v` | 88 aprovados, 1 pulado, 0 falhas | Alta |

### B. Dependentes do SENAI ou de Infraestrutura Externa

| # | Requisito relacionado | Recurso necessário | Por que depende do SENAI | Como validar | Evidência esperada | Prioridade |
|---|----------------------|-------------------|--------------------------|--------------|--------------------|------------|
| B1 | RF12 / Fase 1 (aceite integral) | Instância MySQL 8.x + `TEST_DATABASE_URL` | Infraestrutura de banco fornecida pelo SENAI; não pode ser SQLite em produção | Executar `evidence/homologacao-final-20261030/roteiro-homologacao-mysql.md` | `test_mysql_homologation.py` não mais pulado; aprovado | Alta |
| B2 | RNF08 | Chrome comercial (últimas 2 versões) | Não instalado no ambiente | Executar `evidence/homologacao-final-20261030/checklist-rnf08.md` | Navegador/SO/versão/data registrados; fluxos aprovados | Alta |
| B3 | RNF08 | Edge comercial (últimas 2 versões) | Não instalado no ambiente | Mesmo que B2 | Mesmo que B2 | Alta |
| B4 | RNF08 | Safari comercial (últimas 2 versões, macOS/iOS) | Não disponível nativamente no Windows | Mesmo que B2 (em dispositivo Apple) | Mesmo que B2 | Alta |
| B5 | RF01/RF02 / RNF01 | Dispositivo móvel físico com câmera | Não disponível; validação de leitura óptica | Instalar app nativo e testar leitura de QR físico | Leitura bem-sucedida, origem definida, mapa carregado | Alta |
| B6 | RNF09 | 5 participantes sem treinamento | Recrutamento humano; execução presencial | Executar `evidence/rnf09-usabilidade-protocolo/protocolo-usabilidade-rnf09.md` | Nenhum erro crítico; tempos e satisfação registrados | Média |
| B7 | RNF07 | Conectividade de rede variável / modo offline | Não configurado no ambiente | Testar falhas e recuperação de rede | Aplicação se recupera após falha de rede | Média |

### C. Fora do Escopo do MVP (Fase Futura)

| # | Requisito relacionado | O que falta | Por que está fora do MVP | Quando poder ser implementado |
|---|----------------------|-------------|--------------------------|------------------------------|
| C1 | RF04 | Representação 3D simplificada do ambiente | Especificação seção 4: "v1.0 (desejável)"; seção 16: Fase 4 | Fase 4 (pós-MVP) |
| C2 | RF09 | Alternância 2D/3D sem recarregar | Especificação seção 4: "v1.0 (desejável)"; seção 16: Fase 4 | Fase 4 (pós-MVP) |
| C3 | RNF06 | Consistência mapa 2D × visão 3D | Depende da implementação 3D (RF04) | Fase 4 (pós-MVP) |
| C4 | Parcela 3D de RF08 | Trajeto visível na visão 3D | Depende da implementação 3D | Fase 4 (pós-MVP) |

---

## 6. Resumo Executivo

### 6.1 Totais por Classificação

**Requisitos Funcionais (13 total):**

| Categoria | Quantidade | Requisitos |
|-----------|------------|------------|
| Implementado e testado | 10 | RF01, RF02, RF03, RF05, RF06, RF07, RF10, RF11, RF12, RF13 |
| Parcialmente implementado | 1 | RF08 (2D completo; 3D fora do MVP) |
| Não implementado (fora do escopo MVP) | 2 | RF04, RF09 |

**Requisitos Não Funcionais (9 total):**

| Categoria | Quantidade | RNFs |
|-----------|------------|------|
| Implementado e validado | 4 | RNF01, RNF03, RNF04, RNF05 |
| Implementado, validação parcial | 2 | RNF02, RNF07 |
| Implementado, não validado por falta de ambiente | 2 | RNF08, RNF09 |
| Não implementado (fora do escopo MVP) | 1 | RNF06 |

### 6.2 Funcionalidades Centrais do MVP Implementadas

O núcleo do MVP (conforme especificação seção 15.1) está implementado e testado:

- **Acesso por QR Code:** Resolução de token para nó e piso; fallback manual para seleção de origem.
- **Mapa 2D:** Renderização SVG com planta, nós, arestas, rota destacada (polyline contínua), zoom e pan.
- **Busca e filtros:** Busca textual por POI com correspondência parcial, filtro por categoria, status operacional.
- **Cálculo de rota:** Dijkstra no backend, arestas inativas ignoradas, instruções passo a passo, validação de mesmo shopping (RN04).
- **Exibição de rota e chegada:** Painel de rota com distância, instruções, notificação de chegada.
- **Informações de POIs:** Modal com nome, categoria, descrição, horário, status operacional (aberto/fechado/manutenção).
- **Painel administrativo:** CRUD completo de shoppings, pisos, nós, arestas, lojas, categorias, QR codes; upload de planta; validação de grafo; bloqueio/reativação de arestas.
- **Rotas entre pisos:** Conexões por escada/elevador, instruções de subida/desida, acessibilidade.

### 6.3 Testes Efetivamente Executados

| Suíte | Total | Aprovados | Pulados | Falhas | Última execução |
|-------|-------|-----------|---------|--------|-----------------|
| Backend (pytest) | 89 | 88 | 1 | 0 | 03/11/2026 |
| E2E Playwright | 9 | 8 | 0 | 1 (infraestrutura) | 30/10/2026 |
| E2E RNF03 (performance) | 1 | 1 | 0 | 0 | 03/11/2026 |

### 6.4 Limitações Conhecidas

1. **Homologação MySQL não executada:** Testes usam SQLite em memória; `TEST_DATABASE_URL` não definida; não há instância MySQL disponível.
2. **RNF08 não validado em navegadores comerciais:** Apenas Chromium do Playwright testado; Chrome, Safari, Edge comerciais não instalados.
3. **Leitura óptica de QR Code não validada em dispositivo físico:** Câmera simulada apenas; não há dispositivo móvel com câmera.
4. **RNF09 não executado:** Protocolo preparado, mas nenhum participante recrutado.
5. **Visão 3D não implementada:** RF04, RF09, parcela 3D de RF08, RNF06 estão fora do escopo do MVP (Fase 4).
6. **Execução nativa não validada:** Build nativo não gera APK/IPA; não testado em dispositivo físico.

### 6.5 Pendências Externas (dependem do SENAI)

| Pendência | Recurso necessário | Prioridade |
|-----------|-------------------|------------|
| Instância MySQL 8.x | Banco de dados para homologação | Alta |
| Navegador Chrome comercial | Últimas 2 versões | Alta |
| Navegador Edge comercial | Últimas 2 versões | Alta |
| Navegador Safari comercial | Últimas 2 versões (macOS/iOS) | Alta |
| Dispositivo móvel com câmera | Android/iOS físico | Alta |
| 5 participantes sem treinamento | Recrutamento presencial | Média |

### 6.6 Riscos para a Demonstração e Entrega

1. **Sem MySQL:** Não é possível declarar aceite integral da Fase 1 (persistência em produção não comprovada).
2. **Sem navegadores comerciais:** RNF08 não pode ser declarado como atendido; apenas evidência parcial com Chromium/Firefox/WebKit do Playwright.
3. **Sem dispositivo físico:** Leitura óptica de QR Code (RF01/RF02) e execução nativa (RNF01) não comprovadas em dispositivo real.
4. **Sem participantes RNF09:** Definição de "pronto" do MVP (seção 18) exige teste com 5 usuários sem treinamento.
5. **Visão 3D ausente:** Se o documento acadêmico exigir entrega de 3D, há lacuna de implementação (Fase 4).

### 6.7 Recomendação Objetiva para as Duas Semanas Restantes

**Semana 1 — Infraestrutura e validação crítica (depende do SENAI):**
1. Provisionar instância MySQL 8.x e definir `TEST_DATABASE_URL`.
2. Executar `evidence/homologacao-final-20261030/roteiro-homologacao-mysql.md`.
3. Instalar Chrome e Edge comerciais; executar `evidence/homologacao-final-20261030/checklist-rnf08.md`.

**Semana 2 — Validação presencial e documentação (depende de participantes):**
4. Recrutar 5 participantes sem treinamento; executar `evidence/rnf09-usabilidade-protocolo/protocolo-usabilidade-rnf09.md`.
5. Obter dispositivo móvel com câmera para validação de leitura óptica de QR Code.
6. Manter as correções documentais já aplicadas (README.md, TAREFAS_FASE2.md, TAREFAS_FASE3.md, AUDITORIA_FASES_1-3.md).

**Não implementar nesta etapa:** Visão 3D (RF04, RF06, RF09, parcela 3D de RF08) — fora do escopo do MVP aprovado.

---

## 7. Situação do Git

### Antes desta tarefa

| Item | Valor |
|------|-------|
| Branch | `main` |
| Commit | `fdbf583` |
| `git status --short` | 11 arquivos modificados (não staged), 2 deletados, muitos não rastreados (incluindo todos os relatórios de evidence criados nesta sessão) |
| Staged | Nenhum |
| Commit / Push | Não realizado |

### Depois desta tarefa

| Item | Valor |
|------|-------|
| Branch | `main` (inalterado) |
| Commit | `fdbf583` (inalterado) |
| `git status --short` | Mesmas modificações pré-existentes + novo diretório `evidence/consolidacao-final-requisitos-20261103/` |
| Staged | Nenhum |
| Commit / Push | Não realizado |

Nenhum arquivo existente foi modificado, sobrescrito ou removido nesta tarefa. O único novo arquivo é o próprio relatório de consolidação.

---

## 8. Resposta às Perguntas de Conclusão

1. **Arquivo criado e tamanho:** `evidence/consolidacao-final-requisitos-20261103/matriz-consolidada-final.md` (aproximadamente 18 KB).

2. **Quantidade de RFs e RNFs classificados:** 13 RFs (RF01–RF13) e 9 RNFs (RNF01–RNF09).

3. **Contagem final de cada categoria:**
   - RFs: 10 implementados e testados, 1 parcialmente implementado (RF08), 2 não implementados fora do MVP (RF04, RF09).
   - RNFs: 4 implementados e validados, 2 com validação parcial, 2 não validados por falta de ambiente, 1 não implementado fora do MVP (RNF06).

4. **Inconsistências encontradas:** A contagem anterior (11 implementados + 1 parcial + 2 não implementados = 14) estava incorreta devido à dupla contagem de RF08. A contagem correta é 10 implementados + 1 parcial + 2 não implementados = 13. Outras inconsistências documentais (DV1–DV5) foram identificadas e parcialmente corrigidas em etapas anteriores.

5. **Evidências consultadas:** Todos os relatórios de auditoria listados na seção 1, plus `evidence/performance-correcao-rnf03-20261103.json` e `especificacao-navegacao-indoor.md`.

6. **Confirmação de que nenhum arquivo anterior foi modificado:** Confirmado. Apenas o novo arquivo de consolidação foi criado.

7. **Situação do Git antes e depois:** Branch `main`, commit `fdbf583`, sem staged, sem commit/push. Apenas novo diretório de evidence adicionado como não rastreado.

---
