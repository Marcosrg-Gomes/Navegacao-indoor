# Auditoria Final do Sistema — TCC Navegação Indoor 3D

**Projeto:** Navegação-Indoor-3D  
**Branch:** `main`  
**Commit:** `fdbf583` Remoção distill.exe e o app-release.aab da árvore versionada  
**Data:** 04/11/2026  
**Arquivo:** `evidence/auditoria-final-sistema-20261104/relatorio-auditoria-final.md`  
**Status:** Apenas auditoria — nenhum arquivo modificado

---

## 1. Resumo Executivo

Esta auditoria técnica completa avaliou o estado atual do projeto Navegação Indoor 3D, abrangendo backend (FastAPI + SQLAlchemy), aplicativo visitante (Expo + React Native) e painel administrativo (React + Vite). O sistema está **funcional para o escopo MVP (Fases 1–3)**, com todos os 88 testes de backend aprovados, 1 pulado (MySQL não configurado) e 0 falhas. Os testes E2E do Playwright validaram o fluxo completo QR → mapa → busca → rota → chegada em Chromium. O RNF03 (desempenho) foi validado com mapa máximo 2695 ms e rota máxima 710 ms em rede 4G simulada.

**Pendências críticas para entrega:**
- Homologação MySQL não executada (depende do SENAI)
- RNF08 não validado em navegadores comerciais Chrome/Safari/Edge (depende do SENAI)
- RNF09 não executado com 5 participantes (depende de participantes presenciais)
- Leitura óptica de QR Code com câmera física não validada (depende de dispositivo físico)

O sistema **não está pronto para homologação final** sem essas validações externas, mas pode ser apresentado com evidências locais das Fases 1–3.

---

## 2. Estado Inicial do Git

| Item | Valor |
|------|-------|
| Diretório | `C:\Users\marco\OneDrive\Documentos\SENAI\Navegacao-indoor-GitHub` |
| Branch | `main` |
| Último commit | `fdbf583` Remoção distill.exe e o app-release.aab da árvore versionada |
| `git status --short` | 11 arquivos modificados, 2 deletados, 80+ arquivos não rastreados |
| `git diff --stat` | 9 arquivos, 122 inserções, 385 deleções |
| `git diff --cached --stat` | Nenhum (nada está staged) |
| Commit / Push realizados | Não (esta etapa é apenas leitura) |

### Alterações locais preservadas (não revertidas)

**Modificados (11):**
- `AUDITORIA_FASES_1-3.md`, `README.md`, `TAREFAS_FASE2.md`, `TAREFAS_FASE3.md`
- `admin-panel/tests/admin-crud.spec.ts`
- `backend/app/static/admin/assets/index-CTbFZm9n.js`
- `backend/app/static/admin/assets/index-CdsUUId_.css`
- `backend/app/static/visitor/_expo/static/js/web/entry-c5762b2b180acbfa7f572a7f188bee13.js`
- `backend/app/static/visitor/index.html`
- `evidence/browser-tests.json`
- `evidence/final-browser-artifacts/.last-run.json`

**Deletados (2):**
- `evidence/final-browser-artifacts/scanner-.../error-context.md`
- `evidence/final-browser-artifacts/scanner-.../trace.zip`

**Não rastreados (destacados):**
- `.opencode/` (skills do TCC)
- `backend/app/static/plantas/piso_1_*.svg` (4 arquivos)
- `backend/diagnostico_asgi_requests.py`, `diagnostico_mounts.py`, `reproduzir_servidor_rnf03.py`
- `diff-admin-crud.txt`
- Vários diretórios de evidence com relatórios, browser-tests.json, browser-artifacts
- `opencode-tcc-skills/`, `setup_opencode_tcc.bat`

---

## 3. Arquitetura Encontrada

O projeto segue uma arquitetura de três camadas separadas fisicamente:

| Camada | Diretório | Tecnologia | Responsabilidade |
|--------|-----------|------------|------------------|
| Backend/API | `backend/` | Python + FastAPI + SQLAlchemy | Endpoints REST, motor Dijkstra, autenticação API Key, montagem de estáticos |
| Visitante | `mobile/` | Expo + React Native + Expo Router | App móvel/web, leitura QR Code, mapa 2D, busca, rota, chegada |
| Admin | `admin-panel/` | React + Vite + TypeScript | Painel de manutenção: CRUD de pisos, lojas, nós, arestas, QR Codes, validação de grafo |

### Comunicação
- O frontend consome a API REST via HTTP (`fetch` no admin, `fetch` com AbortController no mobile)
- Endpoints públicos em `/api/*`, endpoints admin em `/api/admin/*` (protegidos por `X-API-Key`)
- Arquivos estáticos servidos pelo FastAPI: `/static` (plantas), `/admin` (SPA do painel), `/` (SPA do visitante)
- Banco de dados: MySQL configurado via `DATABASE_URL`, mas testes locais usam SQLite em memória

### Referências/upstreams (não são a implementação integrada)
- `indoor-wayfinder-main/`, `Waypoint-main/`, `QRNav-master/`, `indrz-be-main/`, `indoor-navigation-system-qrcode-augmented-reality-master/`

---

## 4. Auditoria do Backend

### 4.1 Inicialização da Aplicação

O backend é uma aplicação FastAPI com:
- **Lifespan:** Cria tabelas (`Base.metadata.create_all`) e executa migração idempotente (`upgrade_schema`) na inicialização
- **CORS:** Permitido para todas as origens (`allow_origins=["*"]`), sem credentials
- **Montagem de estáticos:** `/static` → `backend/app/static/`, `/admin` → `SPAStaticFiles` com HTML fallback, `/` → `SPAStaticFiles` do visitante (se `index.html` existir)
- **Health check:** `GET /health` retorna `{"status":"ok","versao":"1.0.0"}`

**Servidor de auditoria (`audit_server.py`):** Inicia o app `app.main:app` na porta 8765 com SQLite temporário, executa `seed_db()` e usa chave `audit-local-only`. Validado: todos os 5 endpoints críticos retornam HTTP 200 quando iniciado a partir do diretório `backend/`.

### 4.2 Endpoints e Métodos HTTP

#### Endpoints Públicos (`/api/*`)

| Método | Endpoint | Descrição | Autenticação |
|--------|----------|-----------|--------------|
| GET | `/shoppings` | Lista shoppings ativos | Não |
| GET | `/shoppings/{id}` | Detalhes de um shopping | Não |
| GET | `/shoppings/{id}/floors` | Pisos de um shopping | Não |
| GET | `/floors/{piso_id}/graph` | Grafo (nós e arestas) de um piso | Não |
| POST | `/routes` | Calcula rota via Dijkstra | Não |
| GET | `/pois` | Lista POIs com filtros (q, categoria_id, shopping_id, piso_id) | Não |
| GET | `/pois/{loja_id}` | Detalhes de um POI | Não |
| GET | `/qr-codes/{token}` | Resolve QR Code para nó | Não |

#### Endpoints Admin (`/api/admin/*`)

| Método | Endpoint | Descrição | Autenticação |
|--------|----------|-----------|--------------|
| GET/POST | `/shoppings` | CRUD de shoppings | X-API-Key |
| GET/PUT/DELETE | `/shoppings/{id}` | Detalhes/atualização/soft-delete | X-API-Key |
| GET/POST | `/floors` | CRUD de pisos | X-API-Key |
| GET/PUT/DELETE | `/floors/{id}` | Detalhes/atualização/deleção | X-API-Key |
| POST | `/floors/{id}/upload-planta` | Upload de planta baixa | X-API-Key |
| GET/POST | `/nodes` | CRUD de nós | X-API-Key |
| GET/PUT/DELETE | `/nodes/{id}` | Detalhes/atualização/deleção | X-API-Key |
| GET/POST | `/edges` | CRUD de arestas | X-API-Key |
| GET/PUT/DELETE | `/edges/{id}` | Detalhes/atualização/deleção | X-API-Key |
| GET/POST | `/stores` | CRUD de lojas/POIs | X-API-Key |
| GET/PUT/DELETE | `/stores/{id}` | Detalhes/atualização/deleção | X-API-Key |
| GET/POST | `/categories` | CRUD de categorias | X-API-Key |
| GET/PUT/DELETE | `/categories/{id}` | Detalhes/atualização/deleção | X-API-Key |
| GET/POST | `/qr-codes` | CRUD de QR Codes | X-API-Key |
| GET/PUT/DELETE | `/qr-codes/{id}` | Detalhes/atualização/deleção | X-API-Key |
| GET | `/graph/validate` | Validação de integridade do grafo | X-API-Key |

### 4.3 Validação de Dados

- **Pydantic schemas:** Todos os endpoints usam schemas com validação de tipos e campos obrigatórios
- **RotaRequest:** Valida que `origem_no_id` != `destino_no_id`, ambos > 0
- **Normalização de coordenadas:** CheckConstraint `coord_x` e `coord_y` entre 0 e 1 no modelo `No`
- **Validação de arestas:** Impede conexões entre shoppings diferentes; conexões entre pisos só entre escada/elevador
- **Validação de upload de planta:** Rejeita arquivos malformados, SVG com script, tipos não permitidos
- **Null patches:** Impede corrupção de campos obrigatórios via PATCH com `null`

### 4.4 Autenticação e Autorização

- **API Key:** Header `X-API-Key` requisitado em todos os endpoints admin (`verify_api_key` como dependência global do router admin)
- **Teste de cobertura:** `test_every_admin_operation_requires_key` verifica que TODAS as operações admin retornam 403 sem chave e com chave errada
- **Não há JWT:** Conforme DECISOES.md item 1, API Key foi escolhida para simplificar proteção no MVP
- **Ausência de autenticação para endpoints públicos:** Endpoints de consulta (shoppings, pisos, grafo, rotas, POIs, QR codes) são abertos, conforme esperado para uso por visitantes

### 4.5 Segurança

- **Validação de upload de imagem:** `uploads.py` valida extensão (.png, .jpg, .jpeg, .svg, .webp), tamanho máximo 5 MB, conteúdo SVG sem scripts/referências externas, imagem válida via PIL
- **SQL Injection:** Mitigado pelo uso do SQLAlchemy ORM com queries parametrizadas
- **CORS:** Configurado com wildcard origin, sem credentials (não combina com wildcard origin em navegadores)
- **Soft delete:** Shoppings são inativados (`ativo = False`) em vez de deletados fisicamente

### 4.6 Tratamento de Erros

- **HTTPException:** Usado consistentemente para erros de negócio (404, 400, 403, 409, 422)
- **Mensagens descritivas:** Erros incluem detalhes sobre o problema (ex: "Nó possui arestas conectadas", "Token de QR Code já está em uso")
- **CORS preflight:** Endpoint OPTIONS responde 200 com headers apropriados
- **Falhas de rede no frontend:** Tratadas com `ApiError`, mensagens de fallback e botão "Tentar buscar novamente"

### 4.7 Comunicação com Banco de Dados

- **ORM:** SQLAlchemy 2.0 com modelo declarativo
- **Driver:** pymysql para MySQL, SQLite para testes locais
- **Sessão:** `SessionLocal` com `autocommit=False, autoflush=False`, injeção via `get_db()`
- **Migrações:** `migrations.py` com `upgrade_schema` idempotente (adiciona colunas se não existirem)
- **Testes:** Usam SQLite em memória (`sqlite:///:memory:`); MySQL requer `TEST_DATABASE_URL`

### 4.8 Integridade dos Dados

- **Constraints:** CheckConstraint em coordenadas (0-1), chaves estrangeiras em todas as relações
- **Validações de negócio:** Impede exclusão de nós com arestas/QR/lojas vinculados; impede exclusão de pisos com nós; impede exclusão de categorias com lojas
- **Validação de grafo:** Endpoint `/graph/validate` detecta nós isolados, arestas inválidas, QR codes órfãos, lojas órfãs, componentes desconectados

### 4.9 QR Codes

- **Modelo:** `QRCode` com `token` único, `no_id` vinculado a `No`, campo `ativo`
- **Resolução:** `GET /api/qr-codes/{token}` retorna o nó e piso correspondentes, validando que todos na hierarquia estejam ativos
- **Unicidade:** Token e no_id são únicos; impede duplicação
- **Criação automática de token:** Se não fornecido, gera UUID

### 4.10 Busca de Estabelecimentos

- **Endpoint:** `GET /api/pois` com filtros `q` (busca parcial, case-insensitive), `categoria_id`, `shopping_id`, `piso_id`
- **Busca parcial:** Usa `ilike` com `%termo%` tanto no nome da loja quanto no nome da categoria
- **Filtros aplicados:** Apenas lojas ativas, nós ativos, pisos ativos, shoppings ativos

### 4.11 Mapas e Pavimentos

- **Modelo Piso:** `nome`, `nivel`, `imagem_planta_url`, `largura_metros`, `altura_metros`, `ativo`
- **Upload de planta:** Endpoint `POST /floors/{id}/upload-planta` salva arquivo em `backend/app/static/plantas/`
- **Grafo por piso:** `GET /floors/{piso_id}/graph` retorna nós e arestas ativas do piso
- **Rotas entre pisos:** Suporta conexões via escada/elevador entre pisos diferentes

### 4.12 Cálculo de Rotas

- **Algoritmo:** Dijkstra com `heapq` (biblioteca padrão Python)
- **Grafo reconstruído por requisição:** Não há cache, desativação/reativação de arestas é efetiva imediatamente
- **Filtros:** Ignora arestas inativas; opcionalmente ignora escadas para rotas acessíveis
- **Restrição RN04:** Impede rotas entre shoppings diferentes
- **Saída:** Sequência de nós, distância total em metros, instruções passo a passo

### 4.13 Disponibilidade dos Serviços

- **Health check:** `GET /health` sempre disponível
- **Estáticos:** `/static`, `/admin`, `/` servidos quando os diretórios existem
- **Dependência de build:** O visitante requer `backend/app/static/visitor/index.html` existente; caso contrário, `/` redireciona para health check

---

## 5. Auditoria do Aplicativo Visitante

### 5.1 Inicialização

- **Layout raiz (`_layout.tsx`):** `SafeAreaProvider` + `NavigationProvider` + `Stack` com tela de abas
- **NavigationProvider:** Gerencia estado global (shoppings, pisos, grafo, origem, destino, rota, chegada)
- **Carregamento inicial:** `refresh()` é chamado uma vez no `useEffect` vazio, carrega shoppings, pisos e grafo

### 5.2 Navegação entre Telas

- **Expo Router:** Navegação baseada em arquivos com 3 abas: Mapa (`index.tsx`), Scanner (`scan.tsx`), Explorar (`explore.tsx`)
- **Tabs layout:** Ícones e títulos configurados para cada aba
- **Roteamento:** `useRouter` e `useLocalSearchParams` para parâmetros de URL (`qr`, `token`, `manualOrigin`)

### 5.3 Identificação de Origem

- **Por QR Code:** Parâmetro `qr` ou `token` na URL dispara `resolveQrCode(token)` → `nav.setOriginNode(result.no)`
- **Seleção manual:** Modal com lista de nós do piso atual; `chooseOrigin(node)` define origem
- **Ativação de piso:** `activateFloorForNode()` encontra o piso correspondente ao nó e carrega o grafo
- **Exibição:** `origin-label` mostra `nav.originNode?.nome` ou "Ponto de partida não definido"

### 5.4 Leitura de QR Code

- **Tela Scanner (`scan.tsx`):** `CameraView` do `expo-camera` com `barcodeScannerSettings={{ barcodeTypes: ["qr"] }}`
- **Entrada manual:** Campo de texto para digitar token do QR Code
- **Fallback:** Se a câmera não estiver disponível ou houver erro, oferece seleção manual
- **Limitação:** Testado apenas com câmera simulada (MediaStream sintético) no `scanner.spec.ts`; não validado com câmera física

### 5.5 Carregamento do Mapa

- **Componente FloorMap:** Render SVG com planta de fundo, nós (círculos coloridos por tipo), arestas (linhas), rota (polyline contínua)
- **Planta baixa:** `imagemPlantaUrl` do piso; se não houver, exibe placeholder SVG
- **Zoom/Pan:** `PanResponder` com suporte a toque e pinça; zoom de 1× a 4×
- **Visibilidade:** `testID="floor-map"` verifica se o mapa está visível

### 5.6 Pesquisa de Estabelecimentos

- **SearchBar:** Busca incremental com debounce de 300ms
- **API:** `GET /api/pois?q=...` com correspondência parcial (`ilike`)
- **Resultados:** Exibidos com nome, categoria, badge de status operacional (aberto/fechado/manutenção)
- **Erro de rede:** Exibe mensagem "Não foi possível conectar ao servidor" com botão "Tentar buscar novamente"

### 5.7 Seleção de Destino

- **Da busca:** Clicar em um resultado define o destino e calcula a rota automaticamente
- **Da tela Explorar:** Listagem de POIs com filtro por categoria; tocar define destino
- **Validação RN04:** Verifica que o destino pertence ao mesmo shopping da origem
- **Mesmo nó:** Se origem == destino, define `hasArrived = true`

### 5.8 Solicitação de Rota

- **Chamada:** `calculateRoute(origem.id, destino.no_id, acessivel)` → `POST /api/routes`
- **Estado:** `routeLoading = true` durante o cálculo; exibe "Calculando rota…"
- **Sucesso:** `setRoute(result)` com nós, distância e instruções
- **Falha:** Exibe erro "Não foi possível encontrar uma rota para este destino."

### 5.9 Exibição do Caminho

- **RouteOverlay:** Polyline contínua SVG separada por segmento de piso; marcadores Início (verde) e Destino (vermelho)
- **RoutePanel:** Exibe distância total (ex: "XX.X m"), botões "Ver instruções", "Recalcular", "Cheguei ao destino", "Cancelar rota"
- **Rota entre pisos:** Exibe aviso "Rota entre pisos: use o seletor acima para ver cada trecho."

### 5.10 Notificação de Chegada

- **completeNavigation():** Define `hasArrived = true`
- **arrival-notice:** Exibe "🎉 Você chegou ao destino!" com nome do destino
- **Botão:** "Iniciar outra navegação" limpa a rota

### 5.11 Tratamento de Falhas de Conexão

- **Erro de API:** `ApiError` capturado, mensagem exibida no componente de erro
- **Retry:** Botão "Tentar buscar novamente" chama `search(query)` novamente
- **Erro de rota:** Exibe "Não foi possível calcular a rota."

### 5.12 Compatibilidade da Execução Web

- **Build web:** `expo export --platform web --output-dir ../backend/app/static/visitor`
- **Servido por:** FastAPI `SPAStaticFiles` em `/`
- **Responsividade:** Viewports 360×640 e 414×896 testados em E2E
- **Limitação:** Testado apenas em Chromium (desktop); não em dispositivos físicos

---

## 6. Auditoria do Painel Administrativo

### 6.1 Login e Controle de Acesso

- **Tela Login (`Login.tsx`):** Campo de senha para API Key; valida contra `/api/admin/shoppings`
- **Armazenamento:** `sessionStorage` com chave `admin_api_key`
- **Proteção de rotas:** `App.tsx` renderiza `<Login />` se não autenticado; `<shell />` se autenticado
- **Logout:** `clearApiKey()` remove do sessionStorage e redireciona para login

### 6.2 Cadastro de Shopping

- **Tela Shoppings:** CRUD completo: criar, editar, excluir (soft delete)
- **Campos:** Nome, endereço, latitude, longitude, ativo
- **Validação:** Nome obrigatório; shopping ativo/inativo

### 6.3 Gerenciamento de Pavimentos

- **Tela Floors:** CRUD de pisos vinculados a shoppings
- **Campos:** Nome, nível, largura, altura, URL da imagem da planta, ativo
- **Upload de planta:** Arquivo SVG/PNG/JPG/WebP salvado no backend; validação de tipo e conteúdo

### 6.4 Gerenciamento de Estabelecimentos

- **Tela Stores:** CRUD de lojas/POIs vinculados a nós
- **Campos:** Nome, descrição, categoria, horário, telefone, status operacional (aberto/fechado/manutenção), ativo
- **Validação:** Nome não vazio; status operacional obrigatório; categoria válida; nó não vinculado a outra loja

### 6.5 Gerenciamento de Nós e Arestas

- **Tela Nodes:** CRUD de nós com editor visual (canvas) para posicionamento por clique/arraste
- **Coordenadas normalizadas:** 0.0 a 1.0; validação de range
- **Tela Edges:** CRUD de arestas com cálculo automático de distância baseado nas coordenadas e dimensões do piso
- **Validação de arestas:** Origem e destino diferentes; mesmo shopping; conexões entre pisos só entre escada/elevador

### 6.6 Gerenciamento de QR Codes

- **Tela QRCodes:** CRUD de QR Codes vinculados a nós
- **Geração visual:** `QrCodeViewer` renderiza QR Code em canvas (biblioteca `qrcode`), offline
- **Download PNG e impressão em lote:** Layout de folha formatada (@media print)
- **Validação:** Token único; nó não vinculado a outro QR Code

### 6.7 Edição e Exclusão

- **Edição:** Modais com formulários preenchidos; botões "Salvar" / "Cancelar"
- **Exclusão:** Confirmação via dialog nativo do navegador; soft delete para shoppings; hard delete para outros com validações de referência
- **Validações de exclusão:** Impede excluir nó com arestas/QR/loja; piso com nós; categoria com lojas

### 6.8 Validações

- **Validação de grafo:** Tela Validation consome `GET /api/admin/graph/validate`; detecta nós isolados, arestas inválidas, QR codes órfãos, lojas órfãs, componentes desconectados
- **Links de correção:** Cada problema tem link direto para a tela de edição correspondente
- **Dashboard:** Estatísticas em tempo real (contadores de shoppings, pisos, nós, arestas, lojas, categorias, QRs) + resultado da validação

### 6.9 Integração com Backend

- **Cliente HTTP:** `services/api.ts` com injeção automática de `X-API-Key` do sessionStorage
- **Timeout:** 15 segundos por requisição
- **Upload multipart:** `uploadFile()` para envio de imagens de planta

### 6.10 Testes Automatizados

- **admin-crud.spec.ts:** 1 teste E2E cobrindo CRUD completo (10 operações: 5 entidades × CREATE/UPDATE) + validação de grafo; aprovado em Chromium, Firefox e WebKit
- **Validações de backend:** `test_every_admin_operation_requires_key` (403 sem chave), `test_upload_malformed_and_script_rejected`, `test_null_patches_never_corrupt_required_fields`

---

## 7. Auditoria do Algoritmo de Rotas

### 7.1 Implementação de Dijkstra

- **Arquivo:** `backend/app/services/navigation.py`, classe `NavigationEngine`
- **Biblioteca:** `heapq` (padrão Python) para fila de prioridade
- **Método:** `_dijkstra(graph, origem_id, destino_id)` retorna `(caminho, distância)` ou `(None, None)`

### 7.2 Representação do Grafo

- **Construção:** `_build_graph()` reconstrói o grafo a cada requisição a partir de nós e arestas ativas no banco
- **Nós navegáveis:** Filtra `No.ativo == True`, `Piso.ativo == True`, `Shopping.ativo == True`, coordenadas entre 0 e 1
- **Arestas:** Apenas `Aresta.ativa == True`; opcionalmente `Aresta.acessivel == True` para rotas acessíveis
- **Pesos:** `aresta.distancia` (valor persistido em metros)

### 7.3 Pesos das Arestas

- **Cálculo automático:** `_resolver_distancia_aresta()` calcula distância euclidiana usando coordenadas normalizadas × dimensões do piso
- **Distância explícita:** Se fornecida na criação/atualização, usa o valor informado
- **Conexões entre pisos:** Requer distância explícita; não calcula automaticamente

### 7.4 Identificação de Origem e Destino

- **Origem:** `_obter_no_navegavel(origem_id)` valida que o nó existe, está ativo, pertence a piso e shopping ativos, coordenadas válidas
- **Destino:** Mesma validação
- **RN04:** Impede rota entre nós de shoppings diferentes (retorna 400)

### 7.5 Tratamento de Caminhos Inexistentes

- **Nó isolado:** Se origem == destino, retorna caminho de um nó com distância 0
- **Sem caminho:** Se `distancias[destino] == inf`, retorna `{"sucesso": False, "mensagem": "Não foi possível encontrar uma rota..."}`
- **Nó inexistente:** Retorna `{"sucesso": False, "mensagem": "Nó de origem ou destino não encontrado ou inativo."}`

### 7.6 Tratamento de Arestas Bloqueadas

- **Aresta inativa:** Ignorada na construção do grafo (`Aresta.ativa.is_(True)`)
- **Bloqueio/reativação:** Como o grafo é reconstruído por requisição, a alteração é efetiva imediatamente
- **Teste:** `test_block_reactivate_no_stale_graph` valida que bloquear uma aresta muda a rota e reativar resta a original

### 7.7 Retorno do Caminho Calculado

- **Estrutura:** `{"sucesso": bool, "nos": [{id, nome, tipo, coord_x, coord_y, piso_id}], "distancia_total_metros": float, "instrucoes": [string]}`
- **Instruções:** `_gerar_instrucoes()` gera texto passo a passo com direções (siga em frente, vire esquerda/direita, use elevador, suba/desça escadas)
- **Mudança de piso:** Detecta `atual.piso_id != proximo.piso_id` e gera instrução específica (elevador/escada)

### 7.8 Consistência entre Backend e Mapa Apresentado

- **Backend:** Retorna `nos` com coordenadas e `piso_id` para cada nó da rota
- **Frontend:** `RouteOverlay` desenha polyline por segmento de piso; `FloorMap` renderiza nós e arestas
- **Rota entre pisos:** Frontend separa segmentos por `piso_id` e exibe aviso; backend já inclui instruções de transição
- **Consistência validada:** E2E `navigation.spec.ts` verifica que a rota exibida corresponde ao cálculo da API

---

## 8. Resultados dos Testes

### 8.1 Testes Backend (Python)

**Comando executado:** `cd backend && python -m pytest tests/ -v --tb=short`

**Resultado:** 88 aprovados, 1 pulado, 0 falhas (2,86s)

| Arquivo de teste | Quantidade | Cobertura principal |
|------------------|------------|---------------------|
| `test_api.py` | 17 | Endpoints públicos (shoppings, pisos, grafo, rotas, POIs, QR codes), admin básico, upload planta, static mount |
| `test_audit.py` | 52 (incluindo parametrizações) | Validações de negócio, bloqueio/reativação de aresta, grafo multipiso, QR único, latência MVP, admin auth, coordenadas normalizadas |
| `test_navigation.py` | 8 | Motor Dijkstra: rota válida, sem caminho, aresta inativa, acessível, bidirecional, nó inexistente, instruções, distância |
| `test_mysql_homologation.py` | 1 | Dialeto MySQL (pulado: `TEST_DATABASE_URL` não definida) |

**Teste pulado:** `test_mysql_homologation_database_is_active` — motivo: `TEST_DATABASE_URL` não definida (não há instância MySQL disponível).

### 8.2 Testes E2E (Playwright)

**Execução registrada na auditoria final (30/10/2026):**

| Arquivo | Testes | Navegadores | Resultado | Cobertura |
|---------|--------|-------------|-----------|-----------|
| `admin-crud.spec.ts` | 1 | Chromium, Firefox, WebKit | 1 aprovado (cada) | CRUD completo RF12 (10 operações) |
| `navigation.spec.ts` | 5 | Chromium | 5 aprovados | RF01–RF11, RF13, RNF02 |
| `scanner.spec.ts` | 1 | Chromium (simulado) | 1 aprovado | RF01, RF02 |
| `performance.spec.ts` | 1 | Chromium | 1 aprovado (03/11/2026) | RNF03 |
| `multiuser.spec.ts` | 1 | Chromium | 1 aprovado | RNF03 concorrente |

**Total E2E:** 9 testes executados, todos aprovados em suas respectivas rodadas.

### 8.3 Teste de Desempenho RNF03 (03/11/2026)

**Comando:** `npx playwright test tests/performance.spec.ts --project chromium`

**Resultado:** 1 aprovado (25,4s)

| Amostra | mapMs (limite ≤ 3000) | routeMs (limite ≤ 1000) |
|---------|----------------------|------------------------|
| 1 | 2695 | 710 |
| 2 | 2265 | 666 |
| 3 | 2036 | 666 |
| 4 | 1960 | 662 |
| 5 | 1985 | 635 |

**Máximos observados:** mapMs = 2695 ms (≤ 3000 ✓); routeMs = 710 ms (≤ 1000 ✓)

**Arquivo de dados:** `evidence/performance-correcao-rnf03-20261103.json`

### 8.4 Classificação por Tipo de Teste

| Tipo | Quantidade | Status | Limitações |
|------|------------|--------|------------|
| Testes automatizados locais (backend) | 89 | 88 aprovados, 1 pulado, 0 falhas | MySQL não configurado |
| Testes de integração (backend) | Incluídos acima | Aprovados | Usam SQLite em memória |
| Testes E2E (Playwright) | 9 | Aprovados | Apenas Chromium; não executado em Firefox/WebKit na rodada mais recente |
| Testes de desempenho | 1 | Aprovado | Apenas Chromium; rede simulada |
| Testes em dispositivo físico | 0 | Não executados | Não há dispositivo móvel disponível |
| Testes presenciais (RNF09) | 0 | Não executados | Não há participantes recrutados |

### 8.5 Testes que Não Puderam Ser Executados

| Teste | Motivo |
|-------|--------|
| `navigation.spec.ts` — Firefox, WebKit | Não executado na rodada mais recente |
| `scanner.spec.ts` — Firefox, WebKit | Não executado |
| `performance.spec.ts` — Firefox, WebKit | Não executado |
| `admin-crud.spec.ts` — Firefox, WebKit | Aprovado anteriormente, não reexecutado na rodada mais recente |
| Testes MySQL | Pulado automaticamente (`TEST_DATABASE_URL` não definida) |
| Testes em dispositivos físicos (mobile nativo) | Não há dispositivo disponível |
| Testes com câmera física | Não há câmera disponível para leitura óptica de QR Code |
| RNF09 — usabilidade presencial | Não há 5 participantes sem treinamento recrutados |

---

## 9. Situação dos Requisitos Funcionais

Conforme matriz consolidada em `evidence/consolidacao-final-requisitos-20261103/matriz-consolidada-final.md`:

| ID | Descrição | Classificação | Escopo MVP |
|----|-----------|---------------|------------|
| RF01 | Acesso por QR Code | Implementado e testado | Dentro |
| RF02 | Identificação da posição inicial | Implementado e testado | Dentro |
| RF03 | Mapa 2D do piso | Implementado e testado | Dentro |
| RF04 | Representação 3D | Não implementado | Fora (Fase 4) |
| RF05 | Busca de estabelecimentos | Implementado e testado | Dentro |
| RF06 | Filtro por categoria | Implementado e testado | Dentro |
| RF07 | Cálculo de rota (Dijkstra) | Implementado e testado | Dentro |
| RF08 | Exibição de trajeto (2D e 3D) | Parcialmente implementado (2D OK, 3D não) | Dentro (2D); fora (3D) |
| RF09 | Alternância 2D/3D | Não implementado | Fora (Fase 4) |
| RF10 | Informações dos POIs | Implementado e testado | Dentro |
| RF11 | Aviso de chegada | Implementado e testado | Dentro |
| RF12 | CRUD admin (pisos, lojas, nós, arestas, QR) | Implementado e testado | Dentro |
| RF13 | Bloqueio/reativação de aresta | Implementado e testado | Dentro |

**Contagem corrigida (sem dupla contagem):** 10 implementados e testados, 1 parcialmente implementado (RF08), 2 não implementados fora do MVP (RF04, RF09). Total: 13.

**Requisitos que não atendem aos critérios de aceitação completa:**
- RF08: visão 3D não implementada (fora do escopo MVP)
- RF04, RF09: fora do escopo do MVP (Fase 4)

---

## 10. Situação dos Requisitos Não Funcionais

Conforme auditoria em `evidence/auditoria-final-rnfs-20261103/relatorio.md`:

| ID | Descrição | Implementação | Validação |
|----|-----------|---------------|-----------|
| RNF01 | Execução em navegador e app mobile | Implementado | Validado |
| RNF02 | Interface responsiva (360×640 a 414×896) | Implementado | Validação parcial (apenas Chromium desktop) |
| RNF03 | Carregamento e resposta rápidos (mapa ≤ 3s, rota ≤ 1s) | Implementado | Validado |
| RNF04 | Coordenadas normalizadas (0-1) | Implementado | Validado |
| RNF05 | Arquitetura modular | Implementado | Validado |
| RNF06 | Mapa 2D e visão 3D consistentes | Não implementado (3D fora do MVP) | Não se aplica |
| RNF07 | Navegação confiável sem dependência de banda larga | Implementado | Validação parcial (teste de rede apenas para busca de POIs) |
| RNF08 | Navegadores modernos (Chrome, Safari, Firefox, Edge) | Implementado (código padrão) | Não validado (navegadores comerciais não instalados) |
| RNF09 | Usabilidade com 5 usuários sem treinamento | Implementado (interface existe) | Não validado (sem participantes) |

**Contagem:** 4 implementados e validados, 2 com validação parcial, 2 não validados por falta de ambiente, 1 não implementado fora do MVP. Total: 9.

---

## 11. Problemas Encontrados

### P0 — Impede inicialização ou funcionamento do fluxo principal

Nenhum problema P0 identificado. O fluxo principal (QR → mapa → busca → rota → chegada) está funcionando corretamente.

### P1 — Compromete funcionalidade importante ou segurança

| ID | Descrição | Arquivos envolvidos | Gravidade | Evidência | Impacto na demonstração | Correção recomendada | Ambiente necessário |
|----|-----------|---------------------|-----------|-----------|------------------------|----------------------|---------------------|
| P1-1 | Homologação MySQL não executada | `backend/tests/test_mysql_homologation.py`, `evidence/homologacao-final-20261030/roteiro-homologacao-mysql.md` | P1 | Teste pulado: `TEST_DATABASE_URL` não definida | Não é possível declarar aceite integral da Fase 1 (persistência em produção não comprovada) | Provisionar instância MySQL 8.x, definir `TEST_DATABASE_URL`, executar roteiro de homologação | SENAI (instância MySQL) |
| P1-2 | RNF08 não validado em navegadores comerciais | `admin-panel/playwright.config.ts`, `evidence/rnf08-navegadores-20261030/` | P1 | Apenas Chromium do Playwright testado; Chrome/Edge/Safari comerciais não instalados | Critério de aceite de navegadores não atendido | Instalar Chrome, Edge (últimas 2 versões cada); executar checklist RNF08; Safari requer dispositivo Apple | SENAI (navegadores comerciais, dispositivo Apple para Safari) |
| P1-3 | Leitura óptica de QR Code não validada com câmera física | `mobile/app/(tabs)/scan.tsx`, `admin-panel/tests/scanner.spec.ts` (simulado) | P1 | Teste usa MediaStream sintético; não há câmera física | Leitura óptica de QR Code (RF01/RF02) não comprovada em dispositivo real | Obter dispositivo móvel com câmera; validar leitura óptica | SENAI (dispositivo físico com câmera) |

### P2 — Problema secundário que deve ser resolvido antes da entrega

| ID | Descrição | Arquivos envolvidos | Gravidade | Evidência | Impacto na demonstração | Correção recomendada | Ambiente necessário |
|----|-----------|---------------------|-----------|-----------|------------------------|----------------------|---------------------|
| P2-1 | RNF09 não executado (usabilidade presencial) | `evidence/rnf09-usabilidade-protocolo/protocolo-usabilidade-rnf09.md` | P2 | Protocolo preparado, nenhum dado de participante coletado | Definição de "pronto" do MVP (seção 18) exige teste com 5 usuários | Recrutar 5 participantes sem treinamento; executar protocolo presencial | Participantes presenciais |
| P2-2 | `navigation.spec.ts` não executado em Firefox/WebKit | `admin-panel/tests/navigation.spec.ts` | P2 | Aprovado apenas em Chromium na rodada mais recente | Cobertura de navegadores limitada | Reexecutar E2E em Firefox e WebKit | Nenhum (navegadores Playwright já disponíveis) |
| P2-3 | Documentação inconsistente (endpoints em TAREFAS_FASE2.md, número "22" em TAREFAS_FASE3.md, MySQL no README) | `TAREFAS_FASE2.md`, `TAREFAS_FASE3.md`, `README.md` | P2 | Relatório de correções documentais (30/10/2026) já aplicou correções; verificar se não restam inconsistências | Confusão sobre contrato de API e cobertura de testes | Verificar se as correções aplicadas em 30/10 estão completas | Nenhum |

### P3 — Melhoria não essencial

| ID | Descrição | Arquivos envolvidos | Gravidade | Evidência | Impacto na demonstração | Correção recomendada | Ambiente necessário |
|----|-----------|---------------------|-----------|-----------|------------------------|----------------------|---------------------|
| P3-1 | Visão 3D não implementada (RF04, RF09, parcela 3D de RF08, RNF06) | `especificacao-navegacao-indoor.md` seções 4, 5.4, 5.7, 5.9; seção 16 | P3 | Fora do escopo do MVP (Fase 4) | Não impacta a demonstração do MVP 2D | Não implementar nesta etapa; deixar para Fase 4 | Nenhum |

---

## 12. Funcionalidades que Ainda Precisam de Correção

Nenhuma funcionalidade existente requer correção de código. Todos os problemas identificados são de:
1. **Validação pendente** (MySQL, navegadores comerciais, dispositivo físico, participantes) — dependem de ambiente externo
2. **Documentação** — já corrigida em etapa anterior (30/10/2026)
3. **Escopo futuro** (visão 3D) — fora do escopo do MVP aprovado

---

## 13. Pendências que Dependem do SENAI

| Pendência | Recurso necessário | Por que depende do SENAI | Prioridade |
|-----------|-------------------|--------------------------|------------|
| Instância MySQL 8.x | Banco de dados para homologação | Infraestrutura de banco fornecida pelo SENAI; não pode ser SQLite em produção | P1 |
| Navegador Chrome comercial | Últimas 2 versões | Não instalado; requer instalação no ambiente SENAI | P1 |
| Navegador Edge comercial | Últimas 2 versões | Não instalado; requer instalação no ambiente SENAI | P1 |
| Navegador Safari comercial | Últimas 2 versões (macOS/iOS) | Não disponível nativamente no Windows; exige dispositivo Apple | P1 |
| Dispositivo móvel físico com câmera | Android/iOS físico | Não disponível; validação de leitura óptica de QR Code | P1 |
| 5 participantes sem treinamento | Recrutamento humano | Execução presencial de teste de usabilidade | P2 |
| Conectividade de rede variável / modo offline | Ambiente de rede para teste de falhas | Não configurado | P2 |

---

## 14. Riscos para a Apresentação

| Risco | Descrição | Probabilidade | Impacto | Mitigação |
|-------|-----------|---------------|---------|-----------|
| Sem MySQL | Não é possível declarar aceite integral da Fase 1 | Alta | Alta | Usar `audit_server.py` com SQLite temporário para demonstração local; declarar MySQL como pendência de homologação |
| Sem navegadores comerciais | RNF08 não pode ser declarado como atendido | Alta | Alta | Demonstrar em Chromium; declarar limitação no relatório final |
| Sem dispositivo físico | Leitura óptica de QR Code não comprovada | Alta | Alta | Usar parâmetro URL `?qr=ENTRADA-PRINCIPAL` como alternativa à câmera física |
| Sem participantes RNF09 | Definição de "pronto" do MVP não totalmente atendida | Média | Média | Apresentar protocolo preparado; declarar execução presencial como pendência |
| Visão 3D ausente | Se o documento acadêmico exigir 3D, há lacuna | Baixa | Média | Declarar que 3D está fora do escopo do MVP (Fase 4) conforme especificação |
| Porta 8765 ocupada | Servidor de auditoria não inicia | Baixa | Média | Verificar disponibilidade da porta antes da demonstração; escolher porta alternativa se necessário |
| Build estático desatualizado | Visitante/admin podem não refletir código mais recente | Baixa | Média | Rebuild antes da demonstração se houver mudanças no frontend |

---

## 15. Plano de Correções Priorizado

### Semana 1 — Infraestrutura e validação crítica (depende do SENAI)

| Prioridade | Ação | Responsável | Prazo |
|------------|------|-------------|-------|
| P1 | Provisionar instância MySQL 8.x e definir `TEST_DATABASE_URL` | SENAI | Semana 1 |
| P1 | Executar `evidence/homologacao-final-20261030/roteiro-homologacao-mysql.md` | Equipe TCC | Semana 1 |
| P1 | Instalar Chrome e Edge comerciais (últimas 2 versões cada) | SENAI | Semana 1 |
| P1 | Executar `evidence/homologacao-final-20261030/checklist-rnf08.md` | Equipe TCC | Semana 1 |
| P1 | Obter dispositivo móvel com câmera para leitura óptica de QR Code | SENAI | Semana 1 |

### Semana 2 — Validação presencial e documentação

| Prioridade | Ação | Responsável | Prazo |
|------------|------|-------------|-------|
| P2 | Recrutar 5 participantes sem treinamento; executar `evidence/rnf09-usabilidade-protocolo/protocolo-usabilidade-rnf09.md` | Equipe TCC | Semana 2 |
| P2 | Reexecutar `navigation.spec.ts` em Firefox e WebKit | Equipe TCC | Semana 2 |
| P2 | Verificar se as correções documentais (README, TAREFAS_FASE2/3, AUDITORIA_FASES_1-3) estão completas | Equipe TCC | Semana 2 |

### Não implementar nesta etapa

- Visão 3D (RF04, RF06, RF09, parcela 3D de RF08) — fora do escopo do MVP aprovado (Fase 4)

---

## 16. Critério de Encerramento

✅ Auditoria documentada  
✅ Testes backend executados: 88 aprovados, 1 pulado, 0 falhas  
✅ Testes E2E executados: 9 aprovados (Chromium)  
✅ Teste RNF03 executado: aprovado (mapMs ≤ 2695, routeMs ≤ 710)  
✅ Pendências identificadas e classificadas (P0, P1, P2, P3)  
✅ Dependências do SENAI separadas (MySQL, navegadores comerciais, dispositivo físico, participantes)  
✅ Plano de correções priorizado definido  

**Nenhum arquivo foi modificado, sobrescrito ou removido durante esta auditoria.** O único novo arquivo é o próprio relatório.

---

## 17. Resposta às Perguntas de Conclusão

1. **Arquivo criado:** `evidence/auditoria-final-sistema-20261104/relatorio-auditoria-final.md`

2. **Quantidade de RFs e RNFs classificados:** 13 RFs (RF01–RF13) e 9 RNFs (RNF01–RNF09)

3. **Contagem final de cada categoria:**
   - RFs: 10 implementados e testados, 1 parcialmente implementado (RF08), 2 não implementados fora do MVP (RF04, RF09)
   - RNFs: 4 implementados e validados, 2 com validação parcial, 2 não validados por falta de ambiente, 1 não implementado fora do MVP (RNF06)

4. **Inconsistências encontradas:** A contagem anterior (11 implementados + 1 parcial + 2 não implementados = 14) estava incorreta devido à dupla contagem de RF08. A contagem correta é 10 implementados + 1 parcial + 2 não implementados = 13. Outras inconsistências documentais (endpoints, número de testes, MySQL como requisito rígido) já foram corrigidas em etapa anterior (30/10/2026).

5. **Evidências consultadas:** Todos os relatórios de auditoria anteriores, `especificacao-navegacao-indoor.md`, `evidence/performance-correcao-rnf03-20261103.json`, código fonte de backend, mobile e admin-panel, testes automatizados.

6. **Confirmação de que nenhum arquivo anterior foi modificado:** Confirmado. Apenas o novo arquivo de relatório foi criado.

7. **Situação do Git antes e depois:** Branch `main`, commit `fdbf583`, sem staged, sem commit/push. Apenas novo diretório `evidence/auditoria-final-sistema-20261104/` adicionado como não rastreado.

---

**A auditoria final do sistema está completa. Nenhuma correção foi implementada nesta etapa, aguardando autorização para a próxima fase.**



