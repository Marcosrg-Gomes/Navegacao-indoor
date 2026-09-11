# Auditoria de completude — Fases 1–3

Atualização: 08/09/2026

## Resultado

Os requisitos funcionais, não funcionais e regras de negócio das Fases 1–3 foram verificados como OK ou N/A. A única exceção é o RNF09, que permanece pendente por exigir teste de usabilidade presencial com cinco usuários sem treinamento.

## Fase 1 — Backend

- RF01–RF03, RF05–RF07, RF10 e RF12–RF13: OK — endpoints públicos/admin, QR Code, catálogo, Dijkstra, CRUD e bloqueio de arestas cobertos por `backend/tests`.
- RF04 e RF09: N/A no MVP — visualização 3D e alternância 2D/3D não fazem parte das Fases 1–3.
- RNF01, RNF04–RNF08: OK/N/A conforme escopo — API modular, coordenadas normalizadas, rotas acessíveis e frontend web/mobile validados.
- RN01–RN11: OK — validações de QR, nós, destinos, conectividade, pisos, status operacional e arestas inativas cobertas por testes e fluxo E2E.

## Fase 2 — Mobile

- Fluxos de mapa, QR/manual, busca, categorias, rota, acessibilidade, pisos e chegada: OK — implementação em `mobile/app`, `mobile/components` e `mobile/services`.
- RNF01, RNF02, RNF04, RNF05 e RNF07: OK — `npm run typecheck` aprovado e integração com a API validada.
- RNF03: OK — evidência em `evidence/browser-tests.json`; cinco amostras Chromium em 4G simulado ficaram abaixo de 3 s para mapa e 1 s para rota.
- RNF08: N/A nesta execução — compatibilidade ampla entre navegadores requer matriz de versões dedicada.
- RNF09: PENDENTE — roteiro abaixo.

## Fase 3 — Painel administrativo

- CRUD de shoppings, pisos/plantas, nós, arestas, lojas, categorias e QR Codes: OK.
- Upload de planta, editor visual normalizado, validação do grafo, autenticação por API Key e geração offline de QR: OK.
- `admin-panel`: `npm run build` aprovado (`tsc --noEmit` + Vite).

## Validação automatizada

- Pytest: **87 passed** (`cd backend && pytest -q`).
- Mobile: `npm run typecheck` aprovado.
- Admin: `npm run build` aprovado.
- E2E Chromium: **6 passed** (`cd admin-panel && npm run test:e2e -- --project=chromium`), incluindo QR → mapa → busca → rota → chegada, bloqueio de aresta, manutenção, pisos, responsividade e recuperação de rede.
- RNF03 não foi refeito isoladamente; a execução E2E reutilizou o teste já registrado e manteve as cinco amostras aprovadas.

## RNF09 — pendência e roteiro de teste

Realizar sessão presencial com cinco pessoas que não receberam treinamento. Para cada participante: (1) entregar apenas um QR Code de entrada; (2) pedir que encontre uma loja indicada; (3) pedir que use busca por texto e por categoria; (4) pedir que reaja a QR inválido e local em manutenção; (5) registrar tempo até iniciar rota, conclusão sem ajuda e erros observados. Considerar aprovado se pelo menos 4/5 concluírem o fluxo principal sem ajuda e a média de satisfação for ≥ 4/5. Guardar formulário anonimizado, tempos, observações e conclusão em `evidence/rnf09-usabilidade.md`.
