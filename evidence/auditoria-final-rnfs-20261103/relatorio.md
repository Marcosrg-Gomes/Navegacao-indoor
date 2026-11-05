# Auditoria Final de Requisitos Não Funcionais — TCC Navegação Indoor 3D

**Projeto:** Navegação-Indoor-3D  
**Branch:** `main`  
**Commit:** `fdbf583`  
**Data:** 03/11/2026  
**Arquivo:** `evidence/auditoria-final-rnfs-20261103/relatorio.md`  
**Status:** Apenas auditoria — nenhum arquivo modificado

---

## 1. Metodologia

Esta auditoria compara os requisitos não funcionais (RNF01–RNF09) definidos na seção 8 da especificação oficial (`especificacao-navegacao-indoor.md`, linhas 229–239) com a implementação existente, os testes automatizados e as evidências de execução. Arquivos de projetos de referência não são considerados funcionalidades integradas.

Cada RNF recebe uma das seguintes classificações:

- **Implementado e validado**: código existe e há evidência de teste passando.
- **Implementado, validação parcial**: código existe, mas a validação é parcial (ambiente limitado, navegador simulado, etc.).
- **Não validado por falta de ambiente**: implementado, mas requer infraestrutura externa não disponível.
- **Não implementado**: não há código correspondente.

---

## 2. Matriz Completa de Requisitos Não Funcionais

| ID | Título (especificação seção 8) | Critério / Métrica | Classificação |
|----|--------------------------------|-------------------|---------------|
| RNF01 | A aplicação deve ser executada em navegador e em app mobile (React Native). | Sem duas bases de código para Android e iOS. | Implementado e validado |
| RNF02 | A interface deve ser responsiva, priorizando smartphones. | Layout testado em resoluções de 360×640 a 414×896. | Implementado, validação parcial |
| RNF03 | O sistema deve carregar e responder rapidamente. | Mapa carrega em ≤ 3s; rota calcula em ≤ 1s. | Implementado e validado |
| RNF04 | O sistema de coordenadas do mapa deve ser independente da resolução. | Coordenadas normalizadas entre 0 e 1. | Implementado e validado |
| RNF05 | A arquitetura deve ser modular. | Separação clara entre frontend, backend e dados. | Implementado e validado |
| RNF06 | O mapa 2D e a visão 3D devem representar consistentemente os mesmos dados. | Mesmos nós, arestas e pontos de interesse. | Não implementado (3D fora do MVP) |
| RNF07 | A navegação deve funcionar de forma confiável. | Sem dependência de conectividade de alta largura. | Implementado, validação parcial |
| RNF08 | O sistema deve funcionar nos navegadores modernos mais utilizados. | Chrome, Safari, Firefox, Edge (últimas 2 versões). | Não validado por falta de ambiente |
| RNF09 | A interface deve ser simples o suficiente para uso sem treinamento. | Teste de usabilidade com 5 usuários sem instrução. | Não validado por falta de participantes |

**Resumo:** 4 de 9 RNFs estão implementados e validados; 2 estão implementados com validação parcial; 3 não estão validados por falta de ambiente/participantes; nenhum RNF está totalmente não implementado (todos têm correspondência no código, exceto a visão 3D de RNF06 que está fora do MVP).

---

## 3. Detalhamento por Requisito Não Funcional

### RNF01 — Execução em navegador e app mobile (React Native)

**Critério:** Sem duas bases de código para Android e iOS.

**Implementação:**
- `mobile/` usa Expo + React Native com Expo Router, uma única base de código TypeScript.
- `mobile/package.json`: `build:web` exporta para `backend/app/static/visitor/` (servido pelo FastAPI em `/`); `build:native` exporta para Android/iOS.
- `mobile/app/(tabs)/`: telas compartilhadas entre web e native (Mapa, Explorar, Scanner).
- `backend/app/main.py` linha 67-71: monta `/` com `SPAStaticFiles` servindo o build web do visitante.
- `backend/app/static/visitor/index.html` existe (build web exportado).

**Testes e evidências:**
- `admin-panel/tests/navigation.spec.ts`: executado em viewport 360×640 e 414×896, acessando `/?qr=ENTRADA-PRINCIPAL` (web).
- `evidence/correcao-rnf03-final-20261103/relatorio.md`: confirma que o servidor serve o HTML do visitante corretamente.

**Limitação:** O build nativo (Android/iOS) não gera APK/IPA nem valida execução em dispositivo físico (conforme README linha 89).

**Classificação: Implementado e validado.**

### RNF02 — Interface responsiva, priorizando smartphones

**Critério:** Layout testado em resoluções de 360×640 a 414×896.

**Implementação:**
- `mobile/app/(tabs)/index.tsx`: `useWindowDimensions()`, zoom/pan via `PanResponder`, mapa com dimensões calculadas dinamicamente (linhas 20-21, 36-60).
- `mobile/components/FloorMap.tsx`: SVG com `viewBox` dinâmico, escala de coordenadas normalizadas.
- `admin-panel/tests/navigation.spec.ts` linha 89-115: teste "Mapa entre pisos e layout sem overflow em 360 e 414 pixels" — executa em ambos os viewports e verifica `scrollWidth <= innerWidth`.

**Testes e evidências:**
- `navigation.spec.ts` linha 111: `expect(dimensions.content).toBeLessThanOrEqual(dimensions.viewport)` — aprovado em Chromium para 360×640 e 414×896.
- Evidências de screenshots em `evidence/e2e-20261026-221544-*` (chromium/firefox/webkit, 360 e 414 px).

**Limitação:** Validação feita apenas em Chromium (Playwright) em desktop; não em dispositivos físicos reais.

**Classificação: Implementado, validação parcial.**

### RNF03 — Desempenho: carregamento e resposta rápidos

**Critério:** Mapa carrega em ≤ 3s; rota calcula em ≤ 1s.

**Implementação:**
- `backend/app/services/navigation.py`: `NavigationEngine.calcular_rota()` com Dijkstra (`heapq`).
- `backend/tests/test_audit.py::test_mvp_measured_latency`: 30 requisições, `max(route_times) < 1000` ms, `max(graph_times) < 3000` ms — aprovado.

**Testes e evidências:**
- `evidence/correcao-rnf03-final-20261103/relatorio.md`: RNF03 validado via Playwright em rede 4G simulada (9 Mbps/1 Mbps/80 ms, cache frio, Chromium, 360×640):
  - mapMs: 2695, 2265, 2036, 1960, 1985 (máximo 2695 ≤ 3000) ✓
  - routeMs: 710, 666, 666, 662, 635 (máximo 710 ≤ 1000) ✓
- Arquivo de dados: `evidence/performance-correcao-rnf03-20261103.json`.

**Classificação: Implementado e validado.**

### RNF04 — Coordenadas independentes da resolução

**Critério:** Coordenadas normalizadas entre 0 e 1.

**Implementação:**
- `backend/app/models/no.py` linhas 34-36: `CheckConstraint("coord_x >= 0 AND coord_x <= 1")` e `CheckConstraint("coord_y >= 0 AND coord_y <= 1")`.
- `backend/app/services/navigation.py` linhas 75-76: filtra `No.coord_x.between(0, 1)` e `No.coord_y.between(0, 1)`.
- `backend/tests/test_audit.py::test_normalized_coordinates_create_update`: testa valores inválidos (-1e-06, 1.000001, 500) retornando 422.
- `mobile/types/index.ts` linhas 152-156: `coordenadaNormalizada()` clampa valores entre 0 e 1.
- `mobile/components/FloorMap.tsx` linhas 41-42: `toX`/`toY` usam `coordenadaNormalizada(coord) * width/height`.

**Testes e evidências:**
- `test_normalized_coordinates_create_update` (6 casos parametrizados) aprovado.
- `test_null_patches_never_corrupt_required_fields` para `nodes/coord_x` e `nodes/coord_y` aprovado.

**Classificação: Implementado e validado.**

### RNF05 — Arquitetura modular

**Critério:** Separação clara entre frontend, backend e dados.

**Implementação:**
- Backend (`backend/`): FastAPI, SQLAlchemy, Pydantic, camadas de modelos, schemas, routers, services.
- Admin panel (`admin-panel/`): React + Vite, separado do backend, consumindo API REST via `src/services/api.ts`.
- Visitante (`mobile/`): Expo + React Native, separado, consumindo API via `mobile/services/api.ts`.
- Contrato de API REST definido em `especificacao-navegacao-indoor.md` seção 12.3.
- Separação física: três diretórios independentes (`backend/`, `admin-panel/`, `mobile/`).

**Evidências:**
- Estrutura de diretórios confirmada. Cada camada tem responsabilidade bem definida.
- `backend/app/main.py` separa routers públicos (`/api`) e admin (`/api/admin`).
- `mobile/services/api.ts` e `admin-panel/src/services/api.ts` são clientes HTTP independentes.

**Classificação: Implementado e validado.**

### RNF06 — Mapa 2D e visão 3D consistentes

**Critério:** Mesmos nós, arestas e pontos de interesse em 2D e 3D.

**Implementação:** Não existe código de renderização 3D em nenhum dos três diretórios integrados. A especificação seção 4 classifica a visualização 3D como "v1.0 (desejável)" e seção 16 como Fase 4 (fora do MVP).

**Evidências de documento:**
- `AUDITORIA_FASES_1-3.md` linha 35: "RF04, RF09, RNF06, RN08; parcela 3D de RF08 — Fora do escopo das Fases 1–3 | Não implementados nem homologados nesta entrega."
- `DECISOES.md` item 22: "Fase 4 e recursos 3D não foram implementados nesta entrega."
- `README.md` linha 195: "Fase 4 | Visualização 3D (opcional) | Fora desta entrega; não implementada."

**Classificação: Não implementado (fora do escopo do MVP aprovado).**

### RNF07 — Navegação confiável sem dependência de conectividade de alta largura

**Critério:** Sem dependência de conectividade de alta largura.

**Implementação:**
- `backend/app/services/navigation.py`: cálculo de rota no servidor (Dijkstra), grafo reconstruído por requisição (sem cache estático).
- `mobile/services/api.ts`: timeout de 10s, tratamento de erro de rede com `ApiError`, mensagem de fallback.
- `mobile/app/(tabs)/index.tsx` linhas 118-127: erro de rede exibido com botão "Tentar novamente".
- `admin-panel/tests/navigation.spec.ts` linhas 118-127: teste "Falhas de rede têm mensagem e permitem repetir a busca" — aborta `**/api/pois?**` e verifica mensagem + retry.

**Limitação:** Não há teste de operação offline completa (sem rede). O teste de rede falha é simulado apenas para busca de POIs, não para todo o fluxo.

**Classificação: Implementado, validação parcial.**

### RNF08 — Navegadores modernos mais utilizados

**Critério:** Chrome, Safari, Firefox, Edge (últimas 2 versões cada).

**Implementação:** O código frontend é padrão HTML/JS/CSS servido pelo FastAPI, compatível com navegadores modernos.

**Testes e evidências:**
- `admin-panel/playwright.config.ts` projetos: chromium, firefox, webkit, chrome, msedge.
- `evidence/rnf08-navegadores-20261030/`: admin-crud aprovado em Firefox (41,6s) e WebKit (13,0s).
- `evidence/auditoria-diagnostico-20261030-v2/`: admin-crud aprovado em Chromium.
- `evidence/multiuser-diagnostico-20261030/`: multiuser aprovado em Chromium.

**Limitações críticas (conforme DECISOES.md item 18 e AUDITORIA_FASES_1-3.md linhas 71-85):**
- Chromium do Playwright ≠ Chrome comercial.
- WebKit no Windows ≠ Safari em macOS/iOS.
- Chrome e Edge comerciais não instalados no ambiente.
- Safari não disponível nativamente no Windows.
- Apenas 5 alvos executados (Chromium, Firefox, WebKit do Playwright + Chrome + Edge canais instalados no relatório anterior), não as 8 combinações exigidas (4 navegadores × 2 versões cada).

**Classificação: Não validado por falta de ambiente.**

### RNF09 — Interface simples para uso sem treinamento

**Critério:** Teste de usabilidade com 5 usuários sem instrução.

**Implementação:** Interface existente (mapa, busca, rota, chegada) — implementada em RF01–RF11.

**Testes e evidências:**
- `evidence/rnf09-usabilidade-protocolo/protocolo-usabilidade-rnf09.md`: protocolo preparado, mas não executado.
- Nenhum dado de participante coletado. Nenhum tempo, satisfação ou erro registrado.

**Definição de "pronto" do MVP (especificação seção 18):** "Não há erros críticos em testes de usabilidade com 5 usuários."

**Classificação: Não validado por falta de participantes.**

---

## 4. Pendências Executáveis em Casa (sem dependência externa)

Essas pendências podem ser resolvidas com os recursos já disponíveis no repositório:

| # | Pendência | Ação necessária |
|---|-----------|-----------------|
| P1 | Correções documentais (inconsistências entre documentação e implementação) | Ajustar `TAREFAS_FASE2.md` (endpoints incorretos), `TAREFAS_FASE3.md` (número "22 testes" sem evidência), `README.md` (MySQL como requisito rígido vs. SQLite em testes). |
| P2 | Cobertura E2E em Firefox e WebKit | Reexecutar `navigation.spec.ts` em Firefox e WebKit (já aprovado anteriormente em `evidence/rnf08-navegadores-20261030/` para admin-crud). |
| P3 | Revalidar RNF03 após qualquer mudança | Reexecutar `npx playwright test tests/performance.spec.ts --project chromium` com servidor `audit_server.py` na porta 8765. |
| P4 | Verificar que `test_mvp_measured_latency` continua aprovado | Reexecutar `pytest tests/ -v` no backend. |

---

## 5. Pendências Dependentes do SENAI

Essas pendências exigem infraestrutura ou participação externa que não está disponível no ambiente atual:

| # | Pendência | Recurso necessário | Por que depende do SENAI |
|---|-----------|-------------------|--------------------------|
| D1 | Homologação MySQL | Instância MySQL 8.x + `TEST_DATABASE_URL` | Infraestrutura de banco fornecida pelo SENAI; não pode ser SQLite em produção (especificação seção 15.1) |
| D2 | RNF08 — Chrome comercial | Últimas 2 versões do Chrome | Não instalado; requer instalação no ambiente SENAI |
| D3 | RNF08 — Edge comercial | Últimas 2 versões do Edge | Não instalado; requer instalação no ambiente SENAI |
| D4 | RNF08 — Safari comercial | Últimas 2 versões (macOS/iOS) | Não disponível nativamente no Windows; exige dispositivo Apple |
| D5 | Execução nativa + câmera física | Dispositivo móvel Android/iOS com câmera | Não disponível; validação de leitura óptica de QR Code (RF01/RF02) e RNF01 |
| D6 | RNF09 — Usabilidade presencial | 5 participantes sem treinamento | Recrutamento humano e execução presencial; definicao de "pronto" do MVP (seção 18) |

---

## 6. Divergências entre Documentação, Testes e Implementação

| # | Divergência | Local | Impacto |
|---|-------------|-------|---------|
| DV1 | README lista MySQL 8.x como requisito rígido, mas testes usam SQLite por padrão | `README.md` linhas 15, 41-47 vs. `backend/tests/conftest.py` linhas 6-7 | Pode enganar desenvolvedor a configurar MySQL desnecessariamente |
| DV2 | TAREFAS_FASE2.md lista endpoints incorretos | `TAREFAS_FASE2.md` linhas 87-89 (`/api/grafo`, `/api/rotas`, `/api/qrcode`) vs. implementação real (`/api/floors/{piso_id}/graph`, `POST /api/routes`, `/api/qr-codes/{token}`) | Confunde desenvolvedores sobre contrato de API |
| DV3 | TAREFAS_FASE3.md menciona "22 testes" sem evidência | `TAREFAS_FASE3.md` linha 89 vs. execução real (88 aprovados, 1 pulado) | Número inventado sem suporte |
| DV4 | AUDITORIA_FASES_1-3.md linha 24 declara lacuna de E2E CRUD já sanada | `AUDITORIA_FASES_1-3.md` linha 24 vs. `admin-crud.spec.ts` aprovado em 3 navegadores | Afirmação desatualizada |
| DV5 | Especificação exige visão 3D (RF04, RF08, RF09) mas implementação não possui | `especificacao-navegacao-indoor.md` linhas 55-58, 110-120 vs. ausência de código 3D | Documento acadêmico pode exigir entrega que está fora do MVP |

---

## 7. Sequência Recomendada para os Últimos Dias do TCC

### Semana 1 — Infraestrutura e validação crítica (depende do SENAI)

1. **Provisionar instância MySQL 8.x** e definir `TEST_DATABASE_URL`.
2. Executar `evidence/homologacao-final-20261030/roteiro-homologacao-mysql.md`.
3. Validar `test_mysql_homologation.py` (não mais pulado).
4. **Instalar Chrome e Edge comerciais** (últimas 2 versões cada).
5. Executar `evidence/homologacao-final-20261030/checklist-rnf08.md` navegando nos fluxos de `navigation.spec.ts` e `admin-crud.spec.ts` em Chrome e Edge.
6. Registrar navegador/SO/versão/data para cada alvo (não classificar ausência como N/A).

### Semana 2 — Validação presencial e documentação (depende de participantes)

7. **Recrutar 5 participantes sem treinamento** e executar `evidence/rnf09-usabilidade-protocolo/protocolo-usabilidade-rnf09.md`.
8. Registrar ajuda necessária, conclusão, tempos e erros de forma anonimizada.
9. **Obter dispositivo móvel com câmera** para validação de leitura óptica de QR Code.
10. **Aplicar correções documentais** (DV1–DV5): ajustar `TAREFAS_FASE2.md`, `TAREFAS_FASE3.md`, `README.md`, `AUDITORIA_FASES_1-3.md`.

### Não implementar nesta etapa

- Visão 3D (RF04, RF06, RF09, parcela 3D de RF08) — fora do escopo do MVP aprovado na especificação (Fase 4).

---

## 8. Conclusão da Auditoria de RNFs

Dos 9 requisitos não funcionais:

- **4 implementados e validados:** RNF01, RNF03, RNF04, RNF05.
- **2 implementados com validação parcial:** RNF02 (apenas Chromium desktop, não dispositivos físicos), RNF07 (teste de rede falha apenas para busca, não operação offline completa).
- **3 não validados por falta de ambiente/participantes:** RNF08 (navegadores comerciais não instalados), RNF09 (sem 5 participantes), RNF06 (3D fora do MVP — não se aplica como pendência de correção, mas como escopo futuro).

O TCC pode ser apresentado com as evidências locais das Fases 1–3, mas a homologação final depende da resolução das pendências D1–D6, que exigem infraestrutura do SENAI e validação presencial.

Nenhum arquivo foi modificado nesta auditoria.
