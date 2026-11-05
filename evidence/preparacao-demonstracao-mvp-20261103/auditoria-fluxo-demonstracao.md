# Auditoria do Fluxo de Demonstração do MVP — TCC Navegação Indoor 3D

**Projeto:** Navegação-Indoor-3D  
**Branch:** `main`  
**Commit:** `fdbf583` Remoção distill.exe e o app-release.aab da árvore versionada  
**Data:** 03/11/2026  
**Arquivo:** `evidence/preparacao-demonstracao-mvp-20261103/auditoria-fluxo-demonstracao.md`  
**Status:** Apenas auditoria e documentação — nenhum arquivo modificado

---

## 1. Diagrama Textual do Fluxo Real

O fluxo de demonstração do visitante segue a sequência abaixo, conforme especificado na seção 13 da especificação oficial e implementado no código:

```
[Usuário acessa ?qr=ENTRADA-PRINCIPAL ou ?token=ENTRADA-PRINCIPAL]
        │
        ▼
[Backend: GET /qr-codes/{token} resolve token para nó + piso]
        │
        ▼
[Frontend mobile: define nó como origem (origin-label exibe nome)]
        │
        ▼
[Backend: GET /floors/{piso_id}/graph carrega nós e arestas do piso]
        │
        ▼
[Frontend: renderiza mapa 2D com FloorMap + RouteOverlay]
        │
        ▼
[Usuário busca destino via SearchBar (ex: "Tech")]
        │
        ▼
[Backend: GET /pois?q=Tech filtra POIs por correspondência parcial]
        │
        ▼
[Usuário seleciona destino (ex: "TechStore, Aberto")]
        │
        ▼
[Frontend: POST /api/routes com origem_no_id e destino_no_id]
        │
        ▼
[Backend: NavigationEngine.calcular_rota() executa Dijkstra]
        │
        ▼
[Backend retorna: nós da rota, distância total, instruções]
        │
        ▼
[Frontend: exibe route-panel com distância e rota desenhada no mapa]
        │
        ▼
[Usuário clica "Cheguei ao destino"]
        │
        ▼
[Frontend: exibe arrival-notice "Você chegou ao destino!"]
```

---

## 2. Arquivos e Endpoints Envolvidos

### 2.1 Backend (`backend/`)

| Arquivo | Função no fluxo de demonstração |
|---------|--------------------------------|
| `app/main.py` | App FastAPI, monta estáticos (`/static`, `/admin`, `/`), health check em `/health`, lifespan com criação de tabelas |
| `app/routers/public.py` | Endpoints públicos: `GET /qr-codes/{token}` (linha 163), `GET /floors/{piso_id}/graph` (linha 54), `GET /pois` (linha 99), `POST /api/routes` (linha 85) |
| `app/services/navigation.py` | `NavigationEngine.calcular_rota()` executa Dijkstra, constrói grafo, gera instruções |
| `app/models/qr_code.py` | Modelo `QRCode` com `token` único vinculado a `No` |
| `app/models/no.py` | Modelo `No` com coordenadas normalizadas (0-1), tipo, ativo |
| `app/models/aresta.py` | Modelo `Aresta` com `ativa`, `acessivel`, `bidirecional`, `distancia` |
| `app/models/loja.py` | Modelo `Loja` com `nome`, `descricao`, `categoria_id`, `status_operacional` |
| `app/models/piso.py` | Modelo `Piso` com `imagem_planta_url`, `largura_metros`, `altura_metros` |
| `seed.py` | Popula banco com dados de demonstração (Shopping Demo Center, 22 nós, 13 lojas, 7 QR codes) |

### 2.2 Aplicativo Visitante (`mobile/`)

| Arquivo | Função no fluxo de demonstração |
|---------|--------------------------------|
| `app/(tabs)/index.tsx` | Tela principal Mapa: lê parâmetro `qr`/`token`, chama `resolveQrCode`, define origem, renderiza FloorMap, busca destino, exibe route-panel, chegada |
| `app/(tabs)/scan.tsx` | Tela Scanner QR: câmera + entrada manual de token como fallback |
| `context/NavigationContext.tsx` | Estado global: `setOriginNode()`, `setDestinationLoja()`, `computeRoute()`, `completeNavigation()` |
| `services/api.ts` | Cliente HTTP: `resolveQrCode()`, `getFloorGraph()`, `listPois()`, `calculateRoute()` |
| `components/FloorMap.tsx` | Render SVG mapa 2D com plantas, nós, arestas, rota overlay |
| `components/RouteOverlay.tsx` | Polyline contínua da rota, marcadores Início/Destino |
| `components/SearchBar.tsx` | Busca incremental com debounce 300ms, sugestões, badge de status |
| `components/PoiDetails.tsx` | Modal com detalhes do POI, status operacional, aviso fechado |

### 2.3 Endpoints Envolvidos no Fluxo

| Endpoint | Método | Função no fluxo |
|----------|--------|-----------------|
| `/health` | GET | Verificação de saúde do servidor |
| `/qr-codes/{token}` | GET | Resolve token de QR Code para nó e piso |
| `/floors/{piso_id}/graph` | GET | Retorna grafo (nós e arestas) do piso |
| `/pois?q=...` | GET | Busca de POIs com correspondência parcial |
| `/api/routes` | POST | Calcula rota via Dijkstra |
| `/static/plantas/demo.svg` | GET | Serve imagem da planta baixa |

---

## 3. Pré-requisitos para Execução

### 3.1 Pré-requisitos de Software

| Item | Detalhe | Status |
|------|---------|--------|
| Python 3.11+ | Para o backend FastAPI | Necessário |
| Dependências Python (`requirements.txt`) | FastAPI, SQLAlchemy, uvicorn, pymysql, pytest, etc. | Necessário (instalar com `pip install -r requirements.txt`) |
| Node.js + npm | Para mobile e admin-panel | Necessário (Node.js 24.12.0 foi usado na revisão) |
| Dependências npm (`package-lock.json`) | Expo, React Native, React, Vite, etc. | Necessário (instalar com `npm ci`) |
| Build estático do visitante | `backend/app/static/visitor/index.html` já existe | Presente no repositório |
| Build estático do admin | `backend/app/static/admin/index.html` já existe | Presente no repositório |

### 3.2 Pré-requisitos de Infraestrutura

| Item | Detalhe | Status |
|------|---------|--------|
| Porta 8765 livre | Para o `audit_server.py` | Verificar disponibilidade |
| Diretório de trabalho `backend/` | Para executar `audit_server.py` e `uvicorn` | Obrigatório |
| Variáveis de ambiente | `DATABASE_URL`, `ADMIN_API_KEY`, `SECRET_KEY` (definidas pelo `audit_server.py`) | Não necessário configurar manualmente para demo local |

### 3.3 Observação sobre MySQL

O fluxo de demonstração **não depende de MySQL**. O `audit_server.py` cria um SQLite temporário e executa `seed_db()` automaticamente. Os testes locais usam SQLite em memória por padrão (`conftest.py` linhas 6-7). A homologação MySQL é necessária apenas para aceitação de produção, não para demonstração local.

---

## 4. Procedimento de Demonstração Passo a Passo

### 4.1 Inicialização do Backend

1. Abrir terminal no diretório `backend/`
2. Executar: `python audit_server.py --port 8765`
3. Aguardar inicialização (o servidor cria SQLite temporário, executa migrations e seed)
4. Verificar que o servidor respondeu com sucesso (sem erros no stdout)

### 4.2 Validação Rápida dos Endpoints

Antes da demonstração, validar os 5 endpoints críticos:

| Passo | Comando | Resultado esperado |
|-------|---------|-------------------|
| 1 | `GET http://127.0.0.1:8765/health` | `{"status":"ok","versao":"1.0.0"}` (HTTP 200) |
| 2 | `GET http://127.0.0.1:8765/static/plantas/demo.svg` | SVG válido (HTTP 200, image/svg+xml) |
| 3 | `GET http://127.0.0.1:8765/?qr=ENTRADA-PRINCIPAL` | HTML do visitante (HTTP 200, text/html) |
| 4 | `GET http://127.0.0.1:8765/` | HTML do visitante (HTTP 200, text/html) |
| 5 | `GET http://127.0.0.1:8765/admin/` | HTML do admin (HTTP 200, text/html) |

### 4.3 Fluxo de Demonstração do Visitante

| Passo | Ação na interface | Resultado esperado | Endpoint envolvido |
|-------|-------------------|-------------------|-------------------|
| 1 | Acessar `http://127.0.0.1:8765/?qr=ENTRADA-PRINCIPAL` no navegador | Página carrega, `origin-label` exibe "Entrada Principal" | `GET /qr-codes/ENTRADA-PRINCIPAL` |
| 2 | Verificar mapa 2D visível | `floor-map` exibe planta com nós e arestas | `GET /floors/{piso_id}/graph` |
| 3 | Buscar "Tech" na SearchBar | Sugestões exibem "TechStore, Aberto" | `GET /pois?q=Tech` |
| 4 | Clicar em "TechStore, Aberto" | Destino definido, rota calculada automaticamente | `POST /api/routes` |
| 5 | Verificar `route-panel` visível | Exibe distância total (ex: "XX.X m") e rota desenhada | `POST /api/routes` |
| 6 | Clicar "Ver instruções" | Modal exibe instruções passo a passo | (frontend, dados da rota) |
| 7 | Clicar "Cheguei ao destino" | `arrival-notice` exibe "🎉 Você chegou ao destino!" | (frontend) |

### 4.4 Fluxo Alternativo (Sem QR Code Físico)

Se não houver câmera física ou leitura óptica:

1. Acessar `http://127.0.0.1:8765/?token=ENTRADA-PRINCIPAL` diretamente na barra de endereços
2. Ou acessar `http://127.0.0.1:8765/` e clicar em "Definir ponto de partida" → selecionar "Entrada Principal" no modal
3. Ou acessar `/scan` e digitar manualmente o token `ENTRADA-PRINCIPAL` no campo de texto

### 4.5 Repetibilidade da Demonstração

O fluxo pode ser repetido após reiniciar o servidor:
- O `audit_server.py` cria um novo SQLite temporário a cada execução
- O `seed_db()` é executado automaticamente na inicialização
- Os mesmos tokens QR (`ENTRADA-PRINCIPAL`, etc.) estão disponíveis após cada reinicialização

---

## 5. Dados de Teste Disponíveis

### 5.1 QR Codes de Demonstração (do `seed.py`)

| Token | Nó vinculado | Nome do nó | Tipo | Piso |
|-------|-------------|------------|------|------|
| `ENTRADA-PRINCIPAL` | Nó 1 | Entrada Principal | entrada | Térreo |
| `ENTRADA-LATERAL` | Nó 2 | Entrada Lateral | entrada | Térreo |
| `CORREDOR-CENTRAL` | Nó 6 | Corredor Central | corredor | Térreo |
| `NORTE-CENTRAL` | Nó 11 | Corredor Norte Central | corredor | Térreo |
| `SUL-CENTRAL` | Nó 14 | Corredor Sul Central | corredor | Térreo |
| `DESTINO-TECHSTORE` | Nó 17 | TechStore | loja | Térreo |

### 5.2 Destinos Disponíveis para Demonstração

| Nome | Categoria | Status | Nó | Uso sugerido |
|------|-----------|--------|-----|--------------|
| TechStore | Tecnologia | Aberto | 17 | Destino principal (busca "Tech") |
| Moda Fashion | Moda | Aberto | 16 | Destino alternativo |
| Restaurante Sabor | Alimentação | Aberto | 18 | Destino alternativo |
| Cinema Star | Entretenimento | Fechado | 19 | Exemplo de local fechado |
| Farmácia Saúde | Serviços | Aberto | 20 | Destino alternativo |
| Café Aroma | Alimentação | Aberto | 5 | Destino alternativo |
| Joalheria Brilho | Moda | Em manutenção | 15 | Exemplo de manutenção |

### 5.3 Dados do Teste Automatizado (`conftest.py` `sample_data`)

| Item | Valor |
|------|-------|
| Shopping | Shopping Teste |
| Piso | Piso 1 (100×60 m) |
| Nó origem | n1: Entrada (0.1, 0.5) |
| Nó destino | n5: Loja Destino (0.7, 0.5) |
| QR Code | QR-TEST-ENTRADA → Nó n1 |
| Arestas | 5 ativas + 1 inativa (n1→n5 direto) |

---

## 6. Testes e Evidências Existentes

### 6.1 Testes Backend que Cobrem o Fluxo

| Teste | Arquivo | O que valida |
|-------|---------|--------------|
| `test_resolver_qr_code` | `tests/test_api.py` | Resolve QR válido para nó e piso |
| `test_inactive_hierarchy_not_public_or_navigable` | `tests/test_audit.py` | QR inativo retorna 404 |
| `test_calcular_rota` | `tests/test_navigation.py` | Rota válida entre dois nós |
| `test_block_reactivate_no_stale_graph` | `tests/test_audit.py` | Bloqueio/reativação de aresta muda a rota |
| `test_two_floors_stairs_elevator_accessibility` | `tests/test_audit.py` | Rota entre pisos com escada/elevador |
| `test_mvp_measured_latency` | `tests/test_audit.py` | Latência: rota < 1000ms, grafo < 3000ms |

**Resultado registrado:** 88 aprovados, 1 pulado (MySQL), 0 falhas.

### 6.2 Testes E2E que Cobrem o Fluxo

| Teste | Arquivo | O que valida |
|-------|---------|--------------|
| "QR → mapa → busca → rota → chegada" | `navigation.spec.ts` linha 9 | Fluxo completo: QR→mapa→busca→rota→chegada, bloqueio/reativação, multipiso |
| "Scanner manual, QR inválido..." | `navigation.spec.ts` linha 69 | QR inválido exibe mensagem, QR válido define origem |
| "Mapa entre pisos e layout sem overflow" | `navigation.spec.ts` linha 89 | Rota entre pisos, responsividade 360×640 e 414×896 |

**Resultado registrado:** 5 aprovados em Chromium (navagation.spec.ts).

### 6.3 Evidências de Execução do RNF03

| Arquivo | Conteúdo |
|---------|----------|
| `evidence/performance-correcao-rnf03-20261103.json` | 5 amostras: mapMs máximo 2695 ms, routeMs máximo 710 ms |
| `evidence/correcao-rnf03-final-20261103/relatorio.md` | Validação completa do RNF03 e dos 5 endpoints |

---

## 7. Limitações Conhecidas

| # | Limitação | Impacto na demonstração |
|---|-----------|------------------------|
| L1 | Leitura óptica com câmera física não testada | Não usar câmera física na demo; usar parâmetro `?qr=` ou `?token=` na URL |
| L2 | Execução nativa (Android/iOS) não validada | Demonstrar via navegador web, não via app nativo |
| L3 | `navigation.spec.ts` não executado em Firefox/WebKit | Validado apenas em Chromium; demo em Chromium |
| L4 | MySQL não configurado | Usar `audit_server.py` com SQLite temporário (funciona para demo local) |
| L5 | `audit_server.py` deve ser iniciado do diretório `backend/` | Não iniciar de outro diretório para evitar problemas de mounts estáticos |
| L6 | Porta 8765 deve estar livre | Verificar disponibilidade antes de iniciar |
| L7 | Visão 3D não implementada (RF04/RF09) | Demonstrar apenas mapa 2D; não prometer alternância 2D/3D |
| L8 | Build nativo não gera APK/IPA | Não prometer instalação em dispositivo móvel |

---

## 8. Plano Alternativo para a Demonração

### 8.1 Se a Leitura Física de QR Code Não Funcionar

**Alternativa A (recomendada):** Acessar diretamente `http://127.0.0.1:8765/?qr=ENTRADA-PRINCIPAL` no navegador. Isso simula a leitura do QR Code sem precisar de câmera física.

**Alternativa B:** Acessar `http://127.0.0.1:8765/` e usar o botão "Definir ponto de partida" → selecionar "Entrada Principal" no modal de seleção manual.

**Alternativa C:** Acessar `/scan` e digitar manualmente o token `ENTRADA-PRINCIPAL` no campo de texto.

### 8.2 Se o Backend Não Iniciar

Verificar:
1. Porta 8765 está livre (`Get-NetTCPConnection -LocalPort 8765`)
2. Diretório de trabalho é `backend/`
3. Dependências Python instaladas (`pip install -r requirements.txt`)
4. `backend/app/static/visitor/index.html` existe (para servir o visitante)

### 8.3 Se Algum Endpoint Falhar

| Endpoint falho | Ação alternativa |
|----------------|------------------|
| `/qr-codes/{token}` | Usar seleção manual de origem no mapa |
| `/floors/{piso_id}/graph` | O mapa não renderiza; verificar se `audit_server.py` foi iniciado do diretório correto |
| `/pois` | A busca não funciona; pular diretamente para seleção de destino via clique no nó |
| `/api/routes` | A rota não é calculada; exibir apenas o mapa com origem definida |

---

## 9. Classificação Geral da Prontidão da Demonstração

| Critério | Classificação | Justificativa |
|----------|---------------|---------------|
| Fluxo completo QR→mapa→busca→rota→chegada | ✅ Validado | Coberto por `navigation.spec.ts` (5 aprovados em Chromium) e execução manual dos 5 endpoints |
| Servidor de auditoria (`audit_server.py`) | ✅ Validado | Todos os 5 endpoints retornam HTTP 200 quando iniciado do diretório `backend/` |
| Dados de demonstração (seed) | ✅ Disponíveis | 7 QR Codes, 13 lojas, 22 nós cadastrados pelo `seed.py` |
| RNF03 (desempenho) | ✅ Validado | mapMs máximo 2695 ≤ 3000, routeMs máximo 710 ≤ 1000 |
| Leitura óptica com câmera física | ❌ Não validado | Não há câmera física disponível; usar parâmetro URL como alternativa |
| Execução nativa mobile | ❌ Não validado | Build nativo não gera APK/IPA; demonstrar via navegador |
| Navegadores comerciais (Chrome/Edge/Safari) | ⚠️ Parcial | Apenas Chromium do Playwright testado; demo em Chromium |
| Homologação MySQL | ❌ Não executada | Não necessário para demonstração local (SQLite temporário) |
| Repetibilidade após reinicialização | ✅ Validado | `audit_server.py` recria SQLite temporário e executa seed a cada inicialização |

### Classificação Geral: **PRONTO PARA DEMONSTRAÇÃO (com ressalvas)**

O fluxo de demonstração do MVP está **validado e reprodutível** via navegador web usando o `audit_server.py` na porta 8765. Os principais caminhos (QR→mapa→busca→rota→chegada) estão cobertos por código e testes automatizados.

**Ressalvas para a apresentação à banca:**
1. Usar parâmetro `?qr=ENTRADA-PRINCIPAL` na URL em vez de câmera física.
2. Demonstrar apenas o mapa 2D (não prometer visão 3D).
3. Usar Chromium para a demonstração (navegadores comerciais não validados).
4. Não depender de MySQL (usar SQLite temporário do `audit_server.py`).
5. Ter o servidor já iniciado antes da apresentação para evitar problemas de inicialização ao vivo.

---

## 10. Situação do Git

| Item | Valor |
|------|-------|
| Branch | `main` |
| Commit | `fdbf583` |
| `git status --short` | Nenhuma alteração nesta tarefa (apenas novo diretório de evidence) |
| Staged | Nenhum |
| Commit / Push | Não realizado |

Nenhum arquivo existente foi modificado, sobrescrito ou removido. O único novo arquivo é o próprio relatório de auditoria.

---