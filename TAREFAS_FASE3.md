# Fase 3 — Painel Administrativo (React + Vite + TypeScript)

Documentação de entrega e status das tarefas da Fase 3 do projeto de Navegação Indoor.

---

## 1. Estrutura de Arquivos Implementada

```
admin-panel/
├── src/
│   ├── components/
│   │   ├── FormField.tsx        # Campo de formulário com rótulos e validação
│   │   ├── Modal.tsx            # Modal reutilizável com backdrop e acessibilidade
│   │   └── QrCodeViewer.tsx     # Gerador visual offline de QR Codes (Canvas/PNG/Impressão)
│   ├── pages/
│   │   ├── Dashboard.tsx        # Resumo de estatísticas e indicador de saúde do grafo
│   │   ├── Floors.tsx           # CRUD de pisos + upload/definição da planta baixa
│   │   ├── Nodes.tsx            # Editor visual de nós sobre a planta (0.0-1.0 normalizado)
│   │   ├── Edges.tsx            # CRUD de arestas (distância automática, acessibilidade, sentido)
│   │   ├── Stores.tsx           # CRUD de lojas/POIs vinculadas a nós
│   │   ├── Categories.tsx       # CRUD de categorias
│   │   ├── Shoppings.tsx        # CRUD de shoppings
│   │   ├── QRCodes.tsx          # CRUD e geração visual de QR Codes com layout de impressão
│   │   ├── Validation.tsx       # Validação de grafo com links diretos de correção
│   │   └── Login.tsx            # Tela de autenticação por API Key (sessionStorage)
│   ├── services/
│   │   └── api.ts               # Cliente HTTP com injeção de X-API-Key e upload multipart
│   ├── App.tsx                  # Shell com menu lateral responsivo e proteção por chave
│   ├── styles.css               # Design system com tema dark, responsividade e regras de print
│   ├── types.ts                 # Tipagem TypeScript do domínio administrativo
│   └── main.tsx
├── package.json
└── vite.config.ts               # Base /admin/ e saída de build para o backend FastAPI
```

---

## 2. Checklist de Funcionalidades Entregues

### Autenticação & Infraestrutura
- [x] Autenticação simples por API Key (`X-API-Key`), armazenada em `sessionStorage`
- [x] Roteamento estruturado em React Router v6 com guarda de autenticação
- [x] Notificações em Toast integradas para todas as operações de CRUD
- [x] Configuração de build do Vite com `base: "/admin/"` direcionado para `backend/app/static/admin/`
- [x] Servimento estático da SPA montado diretamente no FastAPI em `http://localhost:8000/admin`
- [x] Montagem estática de uploads em `http://localhost:8000/static`

### Telas Administrativas
- [x] **Dashboard** (`pages/Dashboard.tsx`):
  - Totais em tempo real de Shoppings, Pisos, Nós, Arestas, Lojas, Categorias e QR Codes
  - Card de status e saúde do grafo com resumo de inconsistências e link rápido
- [x] **Pisos e Plantas** (`pages/Floors.tsx`):
  - CRUD completo de pisos vinculados a shoppings
  - Definição de dimensões em metros (largura × altura para cálculo métrico de rotas)
  - Suporte duplo para plantas: URL externa ou upload de arquivo local diretamente para o backend
  - Pré-visualização ao vivo da planta baixa
- [x] **Editor Visual de Nós** (`pages/Nodes.tsx`):
  - Exibição interativa da planta baixa do piso selecionado
  - Clique na planta com conversão instantânea para coordenadas normalizadas (`0.0` a `1.0`)
  - Arraste e solte (drag-and-drop) para reposicionamento fino com persistência imediata
  - Formulário completo de edição de atributos (nome, tipo, status ativo/inativo)
  - Filtro por tipos de nó (corredor, loja, entrada, escada, elevador, banheiro, saída)
- [x] **Arestas de Navegação** (`pages/Edges.tsx`):
  - CRUD completo de arestas entre nós de um piso
  - Cálculo automático de distância métrica baseado nas coordenadas dos nós e dimensões do piso
  - Flags de acessibilidade (♿) e bidirecionalidade (ida e volta)
  - Tabela detalhada de conexões com status operacional
- [x] **Lojas e Pontos de Interesse** (`pages/Stores.tsx`):
  - CRUD completo de lojas vinculadas exclusivamente a nós do grafo
  - Associação com categorias, horários de funcionamento e contatos
- [x] **QR Codes de Localização** (`pages/QRCodes.tsx`):
  - CRUD de QR codes vinculados a nós
  - Geração visual 100% offline no navegador usando a biblioteca `qrcode` (em `<canvas>`)
  - Download individual em formato PNG
  - Botão de impressão em lote com layout de folha formatada (`@media print`) para totens e placas de teste
- [x] **Validação de Grafo** (`pages/Validation.tsx`):
  - Consumo de `GET /api/admin/graph/validate` com filtro por piso ou escopo global
  - Identificação clara de nós isolados, arestas inválidas, referências órfãs e ilhas desconectadas
  - Links diretos com ID para navegar imediatamente até a tela e item com problema

---

## 3. Backend e Endpoints Adicionados

- `POST /api/admin/floors/{id}/upload-planta`: Recebe arquivos de imagem (.png, .jpg, .svg, .webp), armazena em `backend/app/static/plantas/` e atualiza a URL da planta do piso.
- `app.mount("/static", StaticFiles(directory=static_dir), name="static")`
- `app.mount("/admin", StaticFiles(directory=admin_dist, html=True), name="admin")`
- Cobertura de testes automatizados adicionada em `tests/test_api.py` para upload e montagem estática (22 testes passando).

---

## 4. Como Executar

### Modo Desenvolvimento
```bash
# Backend (porta 8000)
cd backend && uvicorn app.main:app --reload

# Painel Admin (porta 5173 com proxy reverso para a API)
cd admin-panel && npm run dev
```

### Modo Produção Unificado (FastAPI)
```bash
# Build do painel admin para a pasta estática do backend
cd admin-panel && npm run build

# Iniciar backend (o painel estará disponível em http://localhost:8000/admin/)
cd backend && uvicorn app.main:app
```
