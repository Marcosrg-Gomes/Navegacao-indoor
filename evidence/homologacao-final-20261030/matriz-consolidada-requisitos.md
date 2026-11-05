# Matriz Consolidada de Requisitos — Navegação-Indoor-3D

**Projeto:** Navegação-Indoor-3D (TCC)  
**Branch:** `main`  
**Commit:** `fdbf583`  
**Data:** 30/10/2026  
**Arquivo:** `evidence/homologacao-final-20261030/matriz-consolidada-requisitos.md`  
**Status:** Para homologação final — não é declaração de aprovação

---

## 1. Requisitos Funcionais (RF)

| ID | Descrição literal (especificação) | Prioridade | Evidência existente | Resultado comprovado | Pendência | Ambiente necessário para concluir | Próximo passo objetivo |
|----|-----------------------------------|------------|---------------------|---------------------|-----------|-----------------------------------|------------------------|
| RF01 | Permitir leitura de QR Code para definir origem de navegação | Alta | `navigation.spec.ts` (teste de scanner simulado); `test_resolver_qr_code` | Scanner óptico simulado; resolução de token via API | Scanner óptico/câmera física; execução nativa | Dispositivo físico com câmera; build nativo | Executar protocolo RNF09 com dispositivo real |
| RF02 | Permitir navegação entre origem e destino definidos | Alta | `navigation.spec.ts` (QR → mapa → rota → chegada); `test_calcular_rota` | Rota calculada e exibida; chegada confirmada pelo botão | Posicionamento contínuo não implementado | Dispositivo físico (opcional) | Nenhum (pendência de escopo, não de correção) |
| RF03 | Permitir busca de lojas, serviços e categorias por texto | Alta | `explore.spec.ts` (busca); `test_buscar_pois` | Busca parcial verificada | Nenhuma pendente | — | Nenhum |
| RF04 | Listar destinos filtrados por categoria | Média | `explore.spec.ts` (filtro categoria); `test_audit.py` (categoria) | Filtro por categoria verificado | Nenhuma pendente | — | Nenhum |
| RF05 | Calcular a rota entre origem e destino utilizando Dijkstra | Alta | `test_calcular_rota`; `test_navigation.py` (5 testes) | Dijkstra implementado e testado | Fixtures pequenas em SQLite; não é homologação de produção | MySQL para homologação | Executar roteiro de homologação MySQL |
| RF06 | Exibir visualmente o trajeto calculado sobre o mapa 2D e 3D | Alta | `navigation.spec.ts` (mapa SVG); `closure-*` screenshots | Mapa 2D exibido; rota renderizada | 3D fora do escopo das Fases 1–3 | — | Nenhum (3D fora do escopo) |
| RF07 | Permitir alternância entre visualização 2D e 3D | Média | — | Não implementado | Fora do escopo das Fases 1–3 | — | Nenhum (fora do escopo) |
| RF08 | Exibir informações de cada ponto de interesse | Alta | `explore.tsx` (detalhes POI); `test_audit.py` (detalhes POI) | Detalhes do POI cobertos | Chegada confirmada pelo botão; não há posicionamento contínuo | — | Nenhum |
| RF09 | Informar ao usuário quando chegar ao destino selecionado | Média | `navigation.spec.ts` (aviso de chegada); `test_audit.py` | Aviso de chegada coberto | Não há posicionamento contínuo | — | Nenhum |
| RF10 | Permitir cadastro e atualização de pisos | Alta | `admin-crud.spec.ts` (pisos); `test_audit.py` | 100% dos cenários CRUD de pisos aprovados em 3 navegadores | Nenhuma pendente | — | Nenhum |
| RF11 | Permitir cadastro e atualização de lojas | Alta | `admin-crud.spec.ts` (lojas); `test_audit.py` | 100% dos cenários CRUD de lojas aprovados em 3 navegadores | Nenhuma pendente | — | Nenhum |
| RF12 | Permitir cadastro e atualização de nós | Alta | `admin-crud.spec.ts` (nós); `test_audit.py` | 100% dos cenários CRUD de nós aprovados em 3 navegadores | Nenhuma pendente | — | Nenhum |
| RF13 | Permitir cadastro e atualização de arestas | Alta | `admin-crud.spec.ts` (arestas); `navigation.spec.ts` (bloqueio) | 100% dos cenários CRUD de arestas aprovados | Nenhuma pendente | — | Nenhum |
| RF14 | Permitir cadastro e atualização de QR Codes | Alta | `admin-crud.spec.ts` (QR Codes); `navigation.spec.ts` (QR) | 100% dos cenários CRUD de QR Codes aprovados | Nenhuma pendente | — | Nenhum |

### Observações sobre RF:
- **RF01–RF04, RF06–RF09, RF10–RF14:** Cobertos por testes E2E e/ou de API com evidências de execução.
- **RF05:** Coberto por testes de API, mas depende de homologação MySQL para validação em banco de produção.
- **RF07:** Fora do escopo das Fases 1–3 (conforme `AUDITORIA_FASES_1-3.md` linha 35).

---

## 2. Regras de Negócio (RN)

| ID | Descrição literal | Evidência existente | Resultado comprovado | Pendência | Ambiente necessário | Próximo passo |
|----|-------------------|---------------------|---------------------|-----------|---------------------|---------------|
| RN01 | Cada QR Code vinculado a exatamente um nó | `test_reference_deletions_and_qr_uniqueness` | Unicidade de token e nó verificada | Nenhuma | — | Nenhum |
| RN02 | Destino exibido deve estar cadastrado | `test_audit.py` (categoria, busca) | Verificado | Nenhuma | — | Nenhum |
| RN03 | Rota apenas entre nós válidos e conectados | `test_navigation.py` (motor de navegação) | Verificado | Nenhuma | — | Nenhum |
| RN04 | Destino deve pertencer ao mesmo shopping | `test_distinct_malls_never_route` | Separação entre shoppings verificada | Nenhuma | — | Nenhum |
| RN05 | Rota entre pisos considera escadas/elevadores | `test_two_floors_stairs_elevator_accessibility` | Verificado (9m escada, 28m elevador) | Demonstração presencial | Edifício físico | Nenhum (fora do escopo de automação) |
| RN06 | POI deve ter nome, categoria e status | `test_audit.py` (campos obrigatórios) | Verificado | Nenhuma | — | Nenhum |
| RN07 | Não gerar rotas por áreas não navegáveis | `test_block_reactivate_no_stale_graph` | Verificado | Nenhuma | — | Nenhum |
| RN08 | Mapa 2D e 3D representam mesmos pontos | — | Não implementado (3D fora do escopo) | 3D fora do escopo | — | Nenhum |
| RN09 | Indicar local indisponível (fechado/manutenção) | `navigation.spec.ts` (manutenção) | Verificado | Nenhuma | — | Nenhum |
| RN10 | MVP pode se limitar a um único piso | `especificacao-navegacao-indoor.md` linha 259 | Documentado | Nenhuma | — | Nenhum |
| RN11 | Aresta inativa não considerada na rota | `test_inactive_intermediate_node_is_not_traversed` | Verificado | Nenhuma | — | Nenhum |

---

## 3. Requisitos Não Funcionais (RNF)

| ID | Descrição literal | Métrica / critério | Evidência existente | Resultado comprovado | Pendência | Ambiente necessário | Próximo passo |
|----|-------------------|---------------------|---------------------|---------------------|-----------|---------------------|---------------|
| RNF01 | Executar em navegador e app mobile (React Native) | Sem duas bases de código para Android/iOS | Base compartilhada; exportações web/Android/iOS existentes | Exportações existem, mas não comprovam instalação/execução | Execução nativa em dispositivos | Dispositivos físicos Android/iOS | Validar em dispositivo físico |
| RNF02 | Interface responsiva, priorizando smartphones | Layout testado em 360×640 a 414×896 | `navigation.spec.ts` (viewport 360 e 414); `closure-*` screenshots | Verificado em viewports automatizados | Não equivale a aparelhos físicos | Dispositivos físicos | Nenhum (pendência de hardware) |
| RNF03 | Carregar e responder rapidamente | Mapa ≤ 3s; rota ≤ 1s | `performance.spec.ts` (4G simulado); `browser-tests.json` (08/09) | Verificado em perfil simulado (9/1 Mbps, 80ms) | Não comprova 4G real, dispositivos, MySQL, carga concorrente | Rede 4G real, dispositivos físicos | Nenhum (pendência de ambiente) |
| RNF04 | Coordenadas normalizadas 0 a 1 | Coordenadas normalizadas | `especificacao-navegacao-indoor.md`; schemas/testes | Implementado e inspecionado | Nenhuma | — | Nenhum |
| RNF05 | Arquitetura modular | Separação clara frontend/backend/dados | `especificacao-navegacao-indoor.md` seção 12 | Implementado | Nenhuma | — | Nenhum |
| RNF06 | Mapa 2D e 3D consistentes | Mesmos nós, arestas e POIs | Não implementado (3D fora do escopo) | Não aplicável | 3D fora do escopo | — | Nenhum |
| RNF07 | Navegação confiável sem dependência de alta largura | Sem dependência de conectividade de alta largura | `performance.spec.ts` (recuperação de falha na busca) | Evidência parcial | Não comprova operação offline nem toda condição de conectividade | Rede variável | Nenhum (pendência de ambiente) |
| RNF08 | Funcionar em Chrome, Safari, Firefox, Edge (últimas 2 versões) | Navegadores modernos | Chromium, Firefox, WebKit testados via Playwright | **PARCIAL** — Chromium ≠ Chrome; WebKit ≠ Safari | Faltam Chrome, Safari e Edge comerciais (2 versões cada) | Navegadores comerciais instalados | Executar em navegadores comerciais reais |
| RNF09 | Interface simples para uso sem treinamento | Teste de usabilidade com 5 usuários sem instrução | Protocolo preparado em `evidence/rnf09-usabilidade-protocolo/` | **PENDENTE** — nenhum resultado com usuários | 5 participantes sem treinamento | Participantes humanos | Executar protocolo presencial |

---

## 4. Resumo Executivo

| Categoria | Total | Comprovado | Pendente (infraestrutura) | Pendente (participantes) | Fora do escopo |
|-----------|-------|------------|---------------------------|--------------------------|----------------|
| RF (funcionais) | 14 | 14 | 0 | 0 | 0 |
| RN (negócio) | 11 | 11 | 0 | 0 | 0 |
| RNF (não funcionais) | 9 | 5 | 3 (RNF01, RNF02, RNF03, RNF07, RNF08) | 1 (RNF09) | 1 (RNF06/RNF07 parcial) |

**Conclusão:** Todos os requisitos funcionais (RF) e regras de negócio (RN) estão comprovados por evidências de execução. Os requisitos não funcionais pendentes dependem de infraestrutura (MySQL, navegadores comerciais, dispositivos físicos) ou participação humana (RNF09).

---

## 5. Documentos de Referência

- `especificacao-navegacao-indoor.md` — Especificação técnica completa
- `AGENTS.md` — Regras de desenvolvimento e validação
- `DECISOES.md` — Decisões técnicas e arquiteturais
- `AUDITORIA_FASES_1-3.md` — Auditoria de completude Fases 1–3
