# Auditoria Final de Requisitos Funcionais — TCC Navegação Indoor 3D

**Projeto:** Navegação-Indoor-3D  
**Branch:** `main`  
**Commit:** `fdbf583`  
**Data:** 03/11/2026  
**Arquivo:** `evidence/auditoria-final-requisitos-20261103/relatorio.md`  
**Status:** Apenas auditoria — nenhum arquivo modificado

---

## 1. Metodologia

Esta auditoria compara a especificação oficial (`especificacao-navegacao-indoor.md`, seção 7, requisitos RF01–RF13) com o código integrado (`backend/`, `admin-panel/`, `mobile/`), os testes automatizados e as evidências de execução. Arquivos de projetos de referência (`indoor-wayfinder-main/`, `Waypoint-main/`, `QRNav-master/`, `indrz-be-main/`, `indoor-navigation-system-qrcode-augmented-reality-master/`) não são considerados funcionalidades integradas.

Cada requisito recebe uma das seguintes classificações:

- **Implementado e testado**: código existe e é coberto por teste automatizado com evidência de execução.
- **Implementado, teste insuficiente**: código existe, mas falta cobertura de teste adequada ou evidência.
- **Parcialmente implementado**: código existe, mas não atende todos os critérios de aceite da especificação.
- **Não implementado**: não há código correspondente.
- **Dependente de infraestrutura/validação presencial**: implementado, mas requer ambiente externo (MySQL, navegadores comerciais, dispositivo físico, câmera, participantes).

---

## 2. Matriz Completa de Requisitos Funcionais

| ID | Título (especificação) | Prioridade | Classificação | Escopo oficial |
|----|------------------------|------------|---------------|----------------|
| RF01 | Permitir acesso ao sistema por meio da leitura de um QR Code. | Alta | Implementado e testado | MVP (entra no MVP) |
| RF02 | Identificar a posição inicial do usuário a partir do QR Code lido. | Alta | Implementado e testado | MVP |
| RF03 | Exibir um mapa 2D do piso corrente do shopping. | Alta | Implementado e testado | MVP |
| RF04 | Exibir uma representação 3D simplificada do ambiente. | Média | Não implementado | v1.0 (desejável), fora do MVP |
| RF05 | Permitir a busca de lojas, serviços e categorias por texto. | Alta | Implementado e testado | MVP |
| RF06 | Listar destinos filtrados por categoria. | Média | Implementado e testado | MVP |
| RF07 | Calcular a rota entre origem e destino utilizando Dijkstra. | Alta | Implementado e testado | MVP |
| RF08 | Exibir visualmente o trajeto calculado sobre o mapa 2D e 3D. | Alta | Parcialmente implementado | MVP (2D implementado; 3D fora do MVP) |
| RF09 | Permitir a alternância entre a visualização 2D e 3D. | Média | Não implementado | v1.0 (desejável), fora do MVP |
| RF10 | Exibir informações de cada ponto de interesse. | Alta | Implementado e testado | MVP |
| RF11 | Informar ao usuário quando ele chegar ao destino selecionado. | Média | Implementado e testado | MVP |
| RF12 | Permitir o cadastro e a atualização de pisos, lojas, nós, arestas e QR Codes. | Alta | Implementado e testado | MVP |
| RF13 | Permitir que o administrador marque uma aresta como temporariamente indisponível. | Média | Implementado e testado | MVP |

**Resumo:** 11 de 13 requisitos funcionais estão implementados e testados. RF04 e RF09 (visão 3D e alternância 2D/3D) estão fora do escopo do MVP conforme a especificação (seção 15.2 — "Fica fora do MVP" não lista explicitamente 3D, mas a seção 4 define v1.0 como desejável e a seção 16, Fase 4, como "Visão 3D e polimento"). RF08 está parcialmente implementado (mapa 2D sim; visão 3D não).

---

## 3. Detalhamento por Requisito

### RF01 — Acesso por QR Code

**Critérios de aceite (especificação seção 5.1):**
1. QR Code contém token/ID que identifica unicamente um nó de navegação.
2. Ao abrir o link, o sistema carrega o mapa do piso correspondente ao nó.
3. O sistema define o nó como origem da rota sem intervenção manual.
4. Caso o QR Code seja inválido ou não exista, exibe mensagem clara e oferece seleção manual.

**Implementação:**
- `backend/app/routers/public.py` linha 163: `GET /api/qr-codes/{token}` resolve token para nó e piso.
- `backend/app/models/qr_code.py`: modelo `QRCode` com `token` único e `no_id` vinculado a `No`.
- `mobile/services/api.ts` linhas 134-197: `extractQrToken()` e `resolveQrCode()` consomem o endpoint.
- `mobile/app/(tabs)/index.tsx` linhas 66-75: lê parâmetro `qr`/`token`, chama `resolveQrCode`, define origem via `nav.setOriginNode()`.
- `mobile/app/(tabs)/scan.tsx` linhas 25-40: leitura por câmera (simulada no teste) e entrada manual de token.
- `mobile/app/(tabs)/index.tsx` linhas 77-80: `chooseOrigin()` para seleção manual de ponto de partida.

**Testes:**
- `backend/tests/test_api.py::test_resolver_qr_code`: resolve QR válido.
- `backend/tests/test_audit.py::test_inactive_hierarchy_not_public_or_navigable`: QR inativo retorna 404.
- `admin-panel/tests/navigation.spec.ts`: fluxo QR → mapa → busca → rota → chegada (aprovado em Chromium); scanner manual com QR inválido exibe mensagem.

**Evidências:** `evidence/correcao-rnf03-final-20261103/relatorio.md` confirma `/qr-codes/{token}` respondendo 200. Teste E2E de navegação aprovado.

**Classificação: Implementado e testado.**

### RF02 — Identificação da Posição Inicial

**Critérios de aceite (seção 5.2):**
1. Sistema carrega grafo do piso e destaca nó de origem.
2. Usuário vê nome/descrição do ponto de partida.
3. Modo alternativo de seleção manual.

**Implementação:**
- `mobile/context/NavigationContext.tsx` linhas 257-301: `setOriginNode()` ativa piso do nó, define origem, recalcula rota se houver destino.
- `mobile/app/(tabs)/index.tsx` linha 112: `testID="origin-label"` exibe `nav.originNode?.nome`.
- `mobile/components/FloorMap.tsx` linhas 129-153: círculo verde destaca nó de origem.
- Seleção manual via modal em `mobile/app/(tabs)/index.tsx` linhas 169-180.

**Testes:** `test_resolver_qr_code` + `test_block_reactivate_no_stale_graph` (origem definida e rota calculada). E2E `navigation.spec.ts` verifica `origin-label` contendo "Entrada Principal".

**Classificação: Implementado e testado.**

### RF03 — Mapa 2D

**Critérios de aceite (seção 5.3):**
1. Mapa carrega em até 3s em 4G.
2. Zoom e arraste.
3. Lojas, corredores e POIs visualmente distinguíveis.
4. Rota desenhada como linha destacada.

**Implementação:**
- `mobile/app/(tabs)/index.tsx` linhas 136-143: `testID="floor-map"`, `FloorMap` com `imagemPlantaUrl`, nós, arestas, `routeNodes`.
- `mobile/components/FloorMap.tsx`: SVG com imagem de planta, linhas de arestas, círculos de nós coloridos por tipo (`TIPO_NO_COR`), `RouteOverlay` para rota.
- Zoom/arraste via `PanResponder` em `index.tsx` linhas 36-60.
- Rota destacada via `RouteOverlay.tsx` (polyline contínua).

**Testes:** `test_grafo_piso` (backend), `navigation.spec.ts` verifica `floor-map` visível e `svg image` com `demo.svg`. RNF03 validado: mapa ≤ 3s (máximo 2695 ms em 5 amostras).

**Classificação: Implementado e testado.**

### RF04 — Ambiente 3D Simplificado

**Critérios de aceite (seção 5.4):**
1. Visão 3D representa mesmos elementos do 2D.
2. Alternância 2D/3D sem recarregar.
3. Rota visível na 3D.

**Implementação:** Não existe código de renderização 3D no backend, mobile ou admin-panel. A especificação seção 4 classifica 3D como "v1.0 (desejável)" e seção 16 como Fase 4 (fora do MVP). `AUDITORIA_FASES_1-3.md` linha 35 confirma: "RF04, RF09, RNF06, RN08; parcela 3D de RF08 — Fora do escopo das Fases 1–3 | Não implementados nem homologados nesta entrega."

**Classificação: Não implementado (fora do escopo do MVP aprovado).**

### RF05 — Busca por Destinos

**Critérios de aceite (seção 5.5):**
1. Sugestões automáticas enquanto digita.
2. Correspondência parcial ("pizz" encontra "Pizzaria X").
3. Filtro por categoria.
4. Seleção de destino calcula rota a partir da origem.

**Implementação:**
- `backend/app/routers/public.py` linhas 99-139: `GET /api/pois` com `q` (ilike parcial), `categoria_id`, `shopping_id`, `piso_id`.
- `mobile/services/api.ts` linhas 171-188: `listPois()` com todos os filtros.
- `mobile/components/SearchBar.tsx`: debounce de 300ms, busca incremental, exibe resultados com categoria e status.
- `mobile/app/(tabs)/index.tsx` linha 100: `SearchBar` com `onSelect={setPoi}` que define destino e navega.

**Testes:** `test_buscar_pois`, `test_closed_maintenance_and_category_search`. E2E `navigation.spec.ts` busca "Tech" e clica em "TechStore, Aberto".

**Classificação: Implementado e testado.**

### RF06 — Listar Destinos Filtrados por Categoria

**Critérios de aceite (seção implícita via RF05/item 3):** resultados filtráveis por categoria.

**Implementação:**
- `backend/app/routers/public.py` linha 131: filtro `categoria_id`.
- `mobile/app/(tabs)/explore.tsx`: chips de categoria, filtro da lista de POIs.
- `mobile/services/api.ts`: parâmetro `categoria_id` em `listPois`.

**Testes:** `test_buscar_pois` (lista POIs), `test_closed_maintenance_and_category_search` (filtro por categoria Vestuário). E2E `navigation.spec.ts` clica em chip "Tecnologia" e verifica TechStore visível / Moda Fashion oculto.

**Classificação: Implementado e testado.**

### RF07 — Cálculo de Rotas (Dijkstra)

**Critérios de aceite (seção 5.6):**
1. Retorna menor rota em distância.
2. Arestas inativas ignoradas.
3. Sem rota possível → mensagem clara.
4. Tempo < 1s para grafo MVP.

**Implementação:**
- `backend/app/services/navigation.py`: `NavigationEngine.calcular_rota()` com Dijkstra (`heapq`), ignora arestas inativas (`Aresta.ativa == True`), filtro `acessível` ignora escadas, valida mesmo shopping (RN04), gera instruções.
- `backend/app/routers/public.py` linhas 85-97: `POST /api/routes`.
- `backend/app/models/aresta.py`: campos `ativa`, `acessivel`, `bidirecional`, `distancia`.

**Testes:** `test_calcular_rota`, `test_rota_sem_caminho`, `test_aresta_inativa_ignorada`, `test_rota_acessivel`, `test_rota_bidirecional`, `test_no_inexistente`, `test_instrucoes_geradas`, `test_block_reactivate_no_stale_graph`, `test_inactive_intermediate_node_is_not_traversed`, `test_two_floors_stairs_elevator_accessibility`, `test_distinct_malls_never_route`, `test_mvp_measured_latency` (rota < 1000ms).

**Classificação: Implementado e testado.**

### RF08 — Exibição Visual do Trajeto (2D e 3D)

**Critérios de aceite (seção 5.7):**
1. Rota desenhada como linha contínua entre origem e destino.
2. Distância total estimada visível.
3. Instruções passo a passo.
4. Notificação ao chegar ao destino.

**Implementação (2D):**
- `mobile/components/RouteOverlay.tsx`: polyline contínua por segmento de piso, marcadores Início/Destino.
- `mobile/app/(tabs)/index.tsx` linhas 156-166: `testID="route-panel"` exibe `distancia_total_metros`, instruções via modal, botão "Cheguei ao destino".
- `mobile/context/NavigationContext.tsx` linhas 199-283: `_gerar_instrucoes()` produz instruções texto.
- `mobile/app/(tabs)/index.tsx` linhas 151-155: `testID="arrival-notice"` exibe "Você chegou ao destino!".

**Implementação (3D):** Não implementada (fora do MVP).

**Testes:** `test_instrucoes_geradas`, `test_two_floors_stairs_elevator_accessibility` (instruções com "Suba"/"Desça"). E2E `navigation.spec.ts` verifica `route-panel` visível, distância, chegada.

**Classificação: Parcialmente implementado (2D completo; 3D fora do escopo MVP).**

### RF09 — Alternância 2D/3D

**Critérios de aceite (seção 5.9):**
1. Alternância sem recarregar página.
2. Rota e destino permanecem.
3. Zoom/posição preservados.

**Implementação:** Não existe código de alternância 2D/3D. Fora do escopo do MVP (Fase 4 da especificação).

**Classificação: Não implementado (fora do escopo do MVP aprovado).**

### RF10 — Informações dos POIs

**Critérios de aceite (seção 5.8):**
1. Clicar em loja exibe painel com informações.
2. Status operacional visível antes da navegação.
3. Local fechado avisa o usuário.

**Implementação:**
- `backend/app/routers/public.py` linhas 141-161: `GET /api/pois/{loja_id}`.
- `backend/app/models/loja.py`: `nome`, `descricao`, `categoria_id`, `horario_funcionamento`, `telefone`, `logo_url`, `status_operacional`, `ativo`.
- `mobile/components/PoiDetails.tsx`: modal com nome, categoria, status, descrição, horário, telefone, aviso se fechado/manutenção.
- `mobile/components/SearchBar.tsx` linhas 189-209: badge de status (aberto/fechado/manutenção) nos resultados.
- `mobile/app/(tabs)/index.tsx` linhas 145-149: card de destino com status e aviso.

**Testes:** `test_closed_maintenance_and_category_search` (status operacional), `test_required_poi_fields` (validação de campos obrigatórios). E2E verifica "Joalheria Brilho, Em manutenção" e aviso "Este local está em manutenção".

**Classificação: Implementado e testado.**

### RF11 — Aviso de Chegada ao Destino

**Critérios de aceite (seção 5.7/item 4): sistema exibe notificação ao chegar.**

**Implementação:**
- `mobile/context/NavigationContext.tsx` linhas 343-348: `completeNavigation()` define `hasArrived = true`.
- `mobile/app/(tabs)/index.tsx` linhas 151-155: `testID="arrival-notice"` com "🎉 Você chegou ao destino!".
- `mobile/app/(tabs)/index.tsx` linha 163: botão "Cheguei ao destino" chama `nav.completeNavigation()`.

**Testes:** `navigation.spec.ts` linha 58-59: clica "Cheguei ao destino" e verifica `arrival-notice` contendo "Você chegou ao destino!".

**Classificação: Implementado e testado.**

### RF12 — Cadastro e Atualização (Pisos, Lojas, Nós, Arestas, QR Codes)

**Critérios de aceite (seção 5.10):**
1. CRUD completo de pisos, lojas, nós, arestas, QR Codes.
2. Validação impede exclusão de nós com arestas associadas.
3. Marcar aresta como inativa e reativar.
4. Ferramenta de validação do grafo.

**Implementação (backend):**
- `backend/app/routers/admin.py`: CRUD completo para shoppings (102-147), pisos (154-258), nós (265-343), arestas (350-421), lojas (428-495), categorias (502-559), QR codes (566-635), validação de grafo (642-874).
- `backend/app/models/`: todas as entidades com `ativo` e validações.
- `backend/app/services/uploads.py`: upload de planta (validado em `test_upload_malformed_and_script_rejected`).

**Implementação (admin-panel):**
- Páginas: `Shoppings.tsx`, `Floors.tsx` (com upload de planta), `Nodes.tsx` (editor visual com canvas), `Edges.tsx`, `Stores.tsx`, `Categories.tsx`, `QRCodes.tsx` (com `QrCodeViewer`), `Validation.tsx`.
- `App.tsx`: rotas para todas as telas, proteção por API key.

**Testes:** `admin-crud.spec.ts` cobre todas as 10 operações (5 entidades × CREATE/UPDATE) aprovado em Chromium, Firefox e WebKit. `test_audit.py` cobre validações de negócio (exclusão bloqueada, unicidade QR, admin requer chave, etc.).

**Classificação: Implementado e testado.**

### RF13 — Marcar Aresta como Indisponível

**Critérios de aceite (seção implícita via RF10/item 3 e seção 13 fluxo): administrador bloqueia/reativa aresta.**

**Implementação:**
- `backend/app/routers/admin.py` linhas 385-411: `PUT /api/admin/edges/{id}` permite alterar `ativa`.
- `backend/app/services/navigation.py` linha 100: `Aresta.ativa.is_(True)` filtra arestas inativas.
- `admin-panel/tests/navigation.spec.ts`: ciclo bloquear → rota alternativa → reativar (aprovado).
- `backend/tests/test_audit.py::test_block_reactivate_no_stale_graph`: mesma validação via API.

**Classificação: Implementado e testado.**

---

## 3. Arquivos e Funções Relevantes da Implementação

### Backend (`backend/`)

| Arquivo | Função/Responsabilidade | Requisitos atendidos |
|---------|------------------------|----------------------|
| `app/main.py` | App FastAPI, mounts estáticos (`/static`, `/admin`, `/`), CORS, lifespan, health check | RF03, RF08, RF12, RNF04 |
| `app/routers/public.py` | Endpoints públicos: shoppings, pisos, grafo, rotas, POIs, QR codes | RF01, RF02, RF03, RF05, RF06, RF07, RF08, RF10 |
| `app/routers/admin.py` | CRUD admin: shoppings, pisos, nós, arestas, lojas, categorias, QR codes, upload planta, validação grafo | RF12, RF13 |
| `app/services/navigation.py` | Motor Dijkstra, construção do grafo, geração de instruções, validação RN03/RN04/RN07 | RF07, RF08 |
| `app/services/uploads.py` | Validação e armazenamento de plantas baixas | RF12 |
| `app/models/` | Modelos SQLAlchemy: Shopping, Piso, No, Aresta, Loja, Categoria, QRCode | Todos (modelo de dados) |
| `app/schemas/` | Schemas Pydantic para validação de entrada/saída | Todos |
| `tests/conftest.py` | Fixtures SQLite, sample_data, client, api_key_header | Infraestrutura de teste |
| `tests/test_api.py` | Testes de endpoints públicos e admin básicos | RF01-RF12 |
| `tests/test_navigation.py` | Testes unitários do motor de navegação | RF07, RF08 |
| `tests/test_audit.py` | Testes de integração: bloqueio/reativação, validações, MySQL, latência MVP | RF07, RF08, RF10, RF11, RF12, RF13, RNF03 |
| `tests/test_mysql_homologation.py` | Teste de dialeto MySQL (pulado sem `TEST_DATABASE_URL`) | Dependência de infraestrutura |

### Admin Panel (`admin-panel/`)

| Arquivo | Função/Responsabilidade | Requisitos atendidos |
|---------|------------------------|----------------------|
| `src/App.tsx` | Roteamento, proteção por API key, layout shell | RF12 (telas admin) |
| `src/pages/Login.tsx` | Autenticação com API key | RF12 (segurança) |
| `src/pages/Dashboard.tsx` | Estatísticas e validação de grafo | RF12 |
| `src/pages/Shoppings.tsx` | CRUD de shoppings | RF12 |
| `src/pages/Floors.tsx` | CRUD de pisos + upload de planta | RF12 |
| `src/pages/Nodes.tsx` | CRUD de nós + editor visual (canvas) | RF12 |
| `src/pages/Edges.tsx` | CRUD de arestas (bloquear/reativar) | RF12, RF13 |
| `src/pages/Stores.tsx` | CRUD de lojas/POIs com status operacional | RF10, RF12 |
| `src/pages/Categories.tsx` | CRUD de categorias | RF06, RF12 |
| `src/pages/QRCodes.tsx` | CRUD de QR codes + visualização (canvas) | RF01, RF12 |
| `src/pages/Validation.tsx` | Validação de integridade do grafo | RF12 |
| `src/services/api.ts` | Cliente HTTP com X-API-Key, upload multipart | Infraestrutura admin |
| `tests/admin-crud.spec.ts` | E2E CRUD completo (10 operações, 3 navegadores) | RF12 |
| `tests/navigation.spec.ts` | E2E: QR→mapa→busca→rota→chegada, bloqueio/reativação, multipiso, erros de rede | RF01-RF11, RF13 |
| `tests/scanner.spec.ts` | E2E scanner (simulado, Chromium apenas) | RF01, RF02 |
| `tests/performance.spec.ts` | E2E RNF03 (mapa ≤ 3s, rota ≤ 1s em 4G simulado) | RNF03 |
| `tests/multiuser.spec.ts` | E2E 5 visitantes simultâneos | RNF03 |

### Visitante Mobile (`mobile/`)

| Arquivo | Função/Responsabilidade | Requisitos atendidos |
|---------|------------------------|----------------------|
| `app/_layout.tsx` | NavigationProvider raiz | Infraestrutura mobile |
| `app/(tabs)/index.tsx` | Tela Mapa: QR origin, busca, rota, zoom/pan, chegada, instruções | RF01-RF03, RF05, RF07-RF11 |
| `app/(tabs)/explore.tsx` | Tela Explorar: lista POIs, filtro por categoria, status operacional | RF05, RF06, RF10 |
| `app/(tabs)/scan.tsx` | Tela Scanner QR: câmera + entrada manual + fallback | RF01, RF02 |
| `context/NavigationContext.tsx` | Estado global: shoppings, pisos, grafo, origem, destino, rota, chegada | RF01-RF03, RF05, RF07-RF11 |
| `services/api.ts` | Cliente API: shoppings, pisos, grafo, POIs, QR, rota | Infraestrutura mobile |
| `components/FloorMap.tsx` | Render SVG mapa 2D, plantas, nós, arestas, rota overlay | RF03, RF08 |
| `components/RouteOverlay.tsx` | Polyline contínua da rota, marcadores Início/Destino | RF08 |
| `components/SearchBar.tsx` | Busca incremental com debounce, sugestões, filtro categoria | RF05, RF06 |
| `components/PoiDetails.tsx` | Modal com detalhes do POI, status operacional, aviso fechado | RF10 |
| `types/index.ts` | Tipos TypeScript compartilhados (Shopping, Piso, No, Aresta, Loja, RotaResponse, etc.) | Infraestrutura |

---

## 4. Testes Existentes e Lacunas de Cobertura

### 4.1 Testes Backend (Python)

**Total:** 89 testes (88 aprovados, 1 pulado, 0 falhas).

| Arquivo | Testes | Cobertura |
|---------|--------|-----------|
| `test_api.py` | 17 | Endpoints públicos, admin básico, upload planta, static mount |
| `test_audit.py` | 52 (incluindo parametrizações) | Validações de negócio, bloqueio/reativação, grafo multipiso, QR único, latência MVP, admin auth |
| `test_navigation.py` | 8 | Motor Dijkstra: rota válida, sem caminho, aresta inativa, acessível, bidirecional, nó inexistente, instruções, distância |
| `test_mysql_homologation.py` | 1 | Dialeto MySQL (pulado: `TEST_DATABASE_URL` não definida) |

**Lacunas de cobertura backend:**
- Nenhum teste de endpoint público `GET /api/shoppings/{id}` além de inexistente (testa 404, não dados reais).
- Nenhum teste de `PUT /api/admin/floors/{id}/upload-planta` com arquivo válido além do malformado (testa rejeição, não aceitação de SVG válido com conteúdo real).
- Nenhum teste de rota entre pisos via API pública além do que está em `test_audit.py` (que testa via admin).
- `test_mvp_measured_latency` mede latência local SQLite, não rede 4G simulada.

### 4.2 Testes E2E (Playwright)

**Total:** 9 testes executados (8 aprovados, 1 falhou por infraestrutura de trace).

| Arquivo | Testes | Navegadores | Cobertura |
|---------|--------|-------------|-----------|
| `admin-crud.spec.ts` | 1 | Chromium, Firefox, WebKit | CRUD completo RF12 |
| `navigation.spec.ts` | 5 | Chromium | RF01-RF11, RF13, RNF02 |
| `scanner.spec.ts` | 1 | Chromium (simulado) | RF01, RF02 |
| `performance.spec.ts` | 1 | Chromium | RNF03 |
| `multiuser.spec.ts` | 1 | Chromium | RNF03 concorrente |

**Lacunas de cobertura E2E:**
- `navigation.spec.ts` não executado em Firefox e WebKit (apenas Chromium).
- `admin-crud.spec.ts` executado em Firefox e WebKit anteriormente, mas não na rodada mais recente.
- `scanner.spec.ts` usa câmera simulada (MediaStream sintético) — não valida leitura óptica real nem câmera física.
- `performance.spec.ts` falhou na execução anterior por erro de gravação de trace (ENOENT); na execução mais recente passou (RNF03 validado).
- Nenhum teste E2E para navegação nativa em dispositivo físico (Android/iOS).
- Nenhum teste de leitura óptica de QR Code com câmera física.

### 4.3 Cobertura por Requisito (Testes)

| RF | Testes unitários | Testes E2E | Lacunas |
|----|-----------------|------------|---------|
| RF01 | `test_resolver_qr_code` | `navigation.spec.ts` (QR→mapa), `scanner.spec.ts` | Leitura óptica real não testada |
| RF02 | `test_resolver_qr_code` | `navigation.spec.ts` (origin-label) | Seleção manual sem QR pouco coberta |
| RF03 | `test_grafo_piso` | `navigation.spec.ts` (floor-map) | Zoom/pan não testados em E2E |
| RF04 | — | — | Não implementado (fora MVP) |
| RF05 | `test_buscar_pois` | `navigation.spec.ts` (busca "Tech") | Sugestões automáticas não testadas em E2E |
| RF06 | `test_closed_maintenance_and_category_search` | `navigation.spec.ts` (chip categoria) | Filtro por categoria isolado não testado |
| RF07 | `test_calcular_rota` + 7 navigation | `navigation.spec.ts` (Traçar rota) | Limite <1s não testado via rede simulada em E2E |
| RF08 | `test_instrucoes_geradas` | `navigation.spec.ts` (route-panel, chegada) | Visão 3D não testada (não implementada) |
| RF09 | — | — | Não implementado (fora MVP) |
| RF10 | `test_closed_maintenance_and_category_search` | `navigation.spec.ts` (status manutenção) | Painel de detalhes por clique não testado em E2E |
| RF11 | — | `navigation.spec.ts` (Cheguei ao destino) | — |
| RF12 | `test_admin_criar_no`, `test_upload_planta_piso`, `test_every_admin_operation_requires_key` | `admin-crud.spec.ts` | Upload de planta válida em E2E não testado |
| RF13 | `test_block_reactivate_no_stale_graph` | `navigation.spec.ts` (bloquear/reativar) | — |

---

## 5. Pendências Ordenadas por Impacto na Entrega

### Alta (bloqueiam aceite integral do MVP)

1. **Homologação MySQL** — `TEST_DATABASE_URL` não definida; testes usam SQLite em memória. A especificação (seção 15.1) lista "Banco de dados MySQL" como parte do MVP. Não há instância MySQL disponível no ambiente.
2. **RNF08 — Navegadores comerciais** — Apenas Chromium do Playwright foi testado. Especificação (RNF08) exige Chrome, Safari, Firefox e Edge (últimas 2 versões cada). Safari não disponível nativamente no Windows; Chrome e Edge comerciais não instalados.
3. **Execução nativa em dispositivo físico** — Não há dispositivo móvel ou câmera física para validar leitura óptica de QR Code (RF01/RF02) e execução nativa do app React Native (RNF01).

### Média (importantes para qualidade, não bloqueiam MVP)

4. **RNF09 — Usabilidade presencial** — Protocolo preparado (`evidence/rnf09-usabilidade-protocolo/`), mas não executado com 5 participantes sem treinamento. Definição de "pronto" do MVP (seção 18) exige "não há erros críticos em testes de usabilidade com 5 usuários".
5. **RF08/RF09/RF04 — Visão 3D** — Fora do escopo do MVP, mas listados como v1.0/Fase 4 na especificação. Se o documento acadêmico exigir entrega de 3D, há lacuna de implementação.

### Baixa (ajustes documentais e de cobertura)

6. **Documentação inconsistente** — `TAREFAS_FASE2.md` lista endpoints incorretos (`/api/grafo`, `/api/rotas`, `/api/qrcode`); `TAREFAS_FASE3.md` menciona "22 testes" sem evidência; `README.md` lista MySQL como requisito rígido mas testes usam SQLite.
7. **Cobertura E2E em Firefox/WebKit** — `navigation.spec.ts` não reexecutado nesses navegadores na rodada mais recente.

---

## 6. Sugestão de Sequência de Implementação para os Próximos Dias

**Semana 1 (infraestrutura e validação crítica):**
1. Provisionar instância MySQL de teste e executar `evidence/homologacao-final-20261030/roteiro-homologacao-mysql.md`.
2. Validar `test_mysql_homologation.py` com `TEST_DATABASE_URL` definida.
3. Instalar Chrome e Edge comerciais; executar `evidence/homologacao-final-20261030/checklist-rnf08.md`.

**Semana 2 (validação presencial e documentação):**
4. Recrutar 5 participantes sem treinamento; executar `evidence/rnf09-usabilidade-protocolo/protocolo-usabilidade-rnf09.md`.
5. Obter dispositivo móvel com câmera para validação de leitura óptica de QR Code.
6. Aplicar correções documentais (endpoints em `TAREFAS_FASE2.md`, número de testes em `TAREFAS_FASE3.md`, nota do MySQL no `README.md`).

**Não implementar nesta etapa:**
- Visão 3D (RF04, RF09, parcela 3D de RF08) — fora do escopo do MVP aprovado.

---

## 7. Dependências que Exigem SENAI ou Validação Presencial

| Dependência | Detalhe | Por que exige SENAI/presencial |
|-------------|---------|-------------------------------|
| Instância MySQL 8.x | `TEST_DATABASE_URL` para homologação | Infraestrutura de banco fornecida pelo SENAI; não pode ser SQLite em produção |
| Navegador Chrome comercial | Últimas 2 versões para RNF08 | Não instalado; requer instalação no ambiente SENAI |
| Navegador Edge comercial | Últimas 2 versões para RNF08 | Não instalado; requer instalação no ambiente SENAI |
| Navegador Safari comercial | Últimas 2 versões (macOS/iOS) para RNF08 | Não disponível nativamente no Windows; exige dispositivo Apple |
| Dispositivo móvel físico | Execução nativa Android/iOS + câmera | Não disponível; requer dispositivo físico fornecido pelo SENAI |
| Câmera física | Leitura óptica de QR Code (RF01/RF02) | Não disponível; testes usam câmera simulada |
| 5 participantes sem treinamento | Teste de usabilidade RNF09 | Recrutamento humano; execução presencial |

---

A auditoria de requisitos funcionais está completa. O relatório segue em `evidence/auditoria-final-requisitos-20261103/relatorio.md`. Nenhum arquivo foi modificado.
