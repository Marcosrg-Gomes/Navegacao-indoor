# Decisões Técnicas e Arquiteturais

1. **API Key vs JWT**: Optou-se pelo uso de API Key em vez de JWT para simplificar a proteção dos endpoints administrativos no MVP (Minimum Viable Product).

2. **Coordenadas Normalizadas**: Decidimos normalizar as coordenadas no intervalo de `0.0` a `1.0`. Isso garante que a renderização do mapa no front-end e mobile seja independente da resolução original.

3. **heapq para Dijkstra**: Utilizaremos a biblioteca padrão `heapq` do Python para implementar o algoritmo de Dijkstra (caminho mais curto). Isso evita dependências desnecessárias para cálculos de roteamento simples.

4. **Soft delete vs hard delete**: Os endpoints de administração usarão hard delete apenas quando necessário, mas na maior parte do tempo utilizaremos uma flag booleana `ativo` para "soft deletes" (inativação lógica), mantendo o histórico referencial no banco.

5. **Auto-cálculo de distância**: Como temos coordenadas de nós e a dimensão do piso (largura e altura em metros), o sistema ou scripts de seed podem calcular a distância entre os nós automaticamente, em vez de dependerem de entrada manual.

6. **Expo for React Native**: O uso do Expo simplificará e agilizará o desenvolvimento da aplicação mobile, oferecendo testes mais fáceis durante a fase de prototipagem.

7. **Token QR Code**: Optamos por usar tokens baseados em UUIDs ou strings legíveis para humanos (como "ENTRADA-PRINCIPAL") em vez de guardar referências diretas de banco de dados nos QR codes. Isso melhora a resiliência caso os IDs de banco mudem.

8. **Expo Router e Abas**: Adoção de navegação baseada em arquivos (`app/(tabs)/`), estruturando o aplicativo em 3 abas principais: Mapa (`index.tsx`), Scanner QR (`scan.tsx`) e Explorar POIs (`explore.tsx`), envolvidos por `NavigationProvider` no layout raiz.

9. **Polyline SVG contínuo para Rota**: Em vez de gerar múltiplos elementos `<Line>` individuais, a rota calculada é renderizada com um único `<Polyline>` SVG contínuo com marcadores customizados de início (verde) e destino (vermelho), inspirado no QRNav porém otimizado para React Native SVG.

10. **Debounce de 300ms no SearchBar**: Implementado debounce na consulta `GET /api/pois?q=...` para poupar chamadas repetitivas de rede durante a digitação.

11. **CameraView com Fallback Manual**: Utilização da API moderna `CameraView` do `expo-camera` with `barcodeScannerSettings={ barcodeTypes: ["qr"] }`. Em caso de QR Code inválido ou recusa de permissão de câmera, o app oferece fallback imediato para seleção manual do nó de partida no grafo.

12. **Filtro por Categorias em Chips**: Na tela de exploração, chips horizontais disparam requisições filtradas por `categoria_id` ou exibem todas as lojas, com indicação em tempo real de status operacional (Aberto/Fechado).

13. **SPA React + Vite servido pelo FastAPI**: Configurado Vite com `base: "/admin/"` e diretório de build direcionado para `backend/app/static/admin/`, com montagem de estáticos via `StaticFiles(..., html=True)` no FastAPI em `/admin`. Isso viabiliza tanto o desenvolvimento desacoplado com proxy reverso quanto a distribuição unificada monólito/SPA a custo zero de hospedagem.

14. **Upload e Armazenamento Local de Plantas Baixas**: Implementado o endpoint `POST /api/admin/floors/{id}/upload-planta` no backend para receber arquivos de imagem (.png, .jpg, .svg, .webp), armazenando-os em `backend/app/static/plantas/` e atualizando o `imagem_planta_url`, mantendo compatibilidade com URLs externas.

15. **Editor Visual com Coordenadas Normalizadas (`Nodes.tsx`)**: O editor calcula as posições de clique e arraste sobre o contêiner da planta baixa normalizando as coordenadas no intervalo `0.0` a `1.0`. Isso desvincula o grafo da resolução ou redimensionamento da imagem e das proporções da tela.

16. **Geração Visual de QR Code Offline no Frontend**: Adotada a biblioteca `qrcode` para renderizar os códigos diretamente em `<canvas>` no navegador. Isso elimina a dependência de serviços de terceiros, garante operação offline e viabiliza a impressão imediata em lote de folhas de teste para a equipe de campo.

17. **Pre-commit no projeto principal**: Não incluímos `pre-commit` nas dependências das Fases 1–3. O único `.pre-commit-config.yaml` encontrado está em `indrz-be-main/backend`, não versionado, e pertence a uma cópia legada; instalar a ferramenta globalmente criaria uma dependência sem uso no produto auditado. A validação oficial permanece nos comandos declarados em `backend/requirements.txt` e nos scripts npm de `mobile` e `admin-panel`.
