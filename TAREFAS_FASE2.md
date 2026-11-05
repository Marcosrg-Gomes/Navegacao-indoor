# Fase 2 — Aplicativo Mobile (Expo / React Native)

Documentação de entrega e status das tarefas da Fase 2 do projeto de Navegação Indoor.

---

## 1. Estrutura de Arquivos Implementada

```
mobile/
├── app/
│   ├── _layout.tsx              # Layout raiz com SafeAreaProvider e NavigationProvider
│   └── (tabs)/
│       ├── _layout.tsx          # Tab Navigator (Mapa, Scan, Explorar)
│       ├── index.tsx            # Tela principal: Mapa 2D, busca com autocomplete e painel de rota
│       ├── scan.tsx             # Scanner QR Code com CameraView e fallback manual
│       └── explore.tsx          # Catálogo de POIs com filtro por categorias e status
├── components/
│   ├── FloorMap.tsx             # Renderizador SVG da planta baixa com nós e arestas
│   ├── RouteOverlay.tsx         # Polyline contínuo SVG com início e destino destacados
│   └── SearchBar.tsx            # Busca com debounce de 300ms e dropdown de sugestões
├── context/
│   └── NavigationContext.tsx    # Gerenciamento de estado global (origem, destino, rota, piso)
├── services/
│   └── api.ts                   # Cliente HTTP (fetch) consumindo a API FastAPI
├── constants/
│   └── colors.ts                # Paleta de cores temática do app
└── types/
    └── index.ts                 # Tipagens TypeScript completas do domínio
```

---

## 2. Checklist de Funcionalidades

### Layouts e Roteamento
- [x] Layout raiz (`app/_layout.tsx`) com `NavigationProvider` e `SafeAreaProvider`
- [x] Layout de abas (`app/(tabs)/_layout.tsx`) com ícones e cabeçalhos estilizados:
  - Aba **Mapa**: Mapa interativo, busca e instruções passo a passo
  - Aba **Scan**: Leitor de QR Code via câmera
  - Aba **Explorar**: Listagem de lojas e serviços com filtros

### Componentes de UI
- [x] **RouteOverlay** (`components/RouteOverlay.tsx`):
  - Traçado SVG em Polyline contínuo com sombra de destaque
  - Marcadores visuais circulares para nó de Início (verde) e Nó de Destino (vermelho)
  - Labels de texto SVG indicando claramente as extremidades da rota
- [x] **SearchBar** (`components/SearchBar.tsx`):
  - Campo com debounce de 300ms para evitar requisições redundantes
  - Integração com `GET /api/pois?q=...`
  - Dropdown com badge de status (Aberto/Fechado) e categoria
  - Botão de limpar busca e seleção rápida
- [x] **FloorMap** (`components/FloorMap.tsx`):
  - Planta baixa SVG estilizada com corredores e zonas
  - Renderização das arestas ativas da malha de navegação
  - Renderização diferenciada por tipo de nó (loja, quiosque, banheiro, elevador, etc.)
  - Integração completa com o `RouteOverlay`

### Telas
- [x] **Mapa e Navegação** (`app/(tabs)/index.tsx`):
  - Barra de status de navegação (Origem e Destino selecionados)
  - Modal para seleção manual do ponto de partida (quando sem QR code)
  - Toggle de acessibilidade (rotas sem escadas/obstáculos)
  - Seletor de pisos com abas horizontais
  - Painel de rota expansível com distância estimada e lista de passos (instruções direcionais)
  - Alerta de chegada ao destino quando a rota é concluída
- [x] **Scanner QR Code** (`app/(tabs)/scan.tsx`):
  - Utilização da API moderna `CameraView` do `expo-camera`
  - Leitura otimizada para `barcodeTypes: ["qr"]`
  - Consulta imediata ao backend via `resolveQrCode(token)`
  - Caso o QR seja inválido ou não cadastrado: alerta com opção de seleção manual de origem
  - Interface com visor centralizado e cantos iluminados
- [x] **Explorar POIs** (`app/(tabs)/explore.tsx`):
  - Listagem em cards com nome, categoria, descrição, horário de funcionamento e telefone
  - Chips de filtro por categoria (Alimentação, Moda, Tecnologia, Serviços, Entretenimento)
  - Indicador visual de status operacional (Aberto / Fechado)
  - Ação de definir como destino com redirecionamento automático para o Mapa

---

## 3. Integração com Backend FastAPI

Todos os endpoints da API desenvolvida na Fase 1 são consumidos pelo app:
- `GET /api/shoppings`: Listagem dos shoppings cadastrados
- `GET /api/shoppings/{shopping_id}/floors`: Pisos disponíveis de um shopping
- `GET /api/floors/{piso_id}/graph`: Malha completa de nós e arestas para renderização
- `GET /api/pois?q=...&categoria_id=...&shopping_id=...&piso_id=...`: Busca e catálogo de pontos de interesse
- `POST /api/routes`: Cálculo de rota ótima (Dijkstra) via JSON no corpo da requisição
- `GET /api/qr-codes/{token}`: Resolução do ponto de partida a partir do código escaneado
