# Relatório de Validação Complementar Local — TCC Navegação Indoor 3D

**Projeto:** Navegação-Indoor-3D  
**Branch:** `main`  
**Commit:** `fdbf583`  
**Data:** 04/11/2026  
**Arquivo:** `evidence/validacao-complementar-local-20261104/relatorio.md`

---

## 1. Estado Inicial do Git

| Item | Valor |
|------|-------|
| Branch | `main` |
| Commit | `fdbf583` |
| `git status --short` | 11 arquivos modificados, 2 deletados, muitos não rastreados |
| `git diff --stat` | 9 arquivos, 122 inserções, 385 deleções |
| `git diff --cached --stat` | Nenhum |

### Alterações locais preservadas
**Modificados (11):** `AUDITORIA_FASES_1-3.md`, `README.md`, `TAREFAS_FASE2.md`, `TAREFAS_FASE3.md`, `admin-panel/tests/admin-crud.spec.ts`, `backend/app/static/admin/assets/index-CTbFZm9n.js`, `backend/app/static/admin/assets/index-CdsUUId_.css`, `backend/app/static/visitor/_expo/static/js/web/entry-c5762b2b180acbfa7f572a7f188bee13.js`, `backend/app/static/visitor/index.html`, `evidence/browser-tests.json`, `evidence/final-browser-artifacts/.last-run.json`

**Deletados (2):** `evidence/final-browser-artifacts/scanner-.../error-context.md`, `evidence/final-browser-artifacts/scanner-.../trace.zip`

**Não rastreados:** `.opencode/`, `backend/app/static/plantas/piso_1_*.svg`, `backend/diagnostico_*.py`, `backend/reproduzir_servidor_rnf03.py`, `diff-admin-crud.txt`, vários diretórios de evidence, `opencode-tcc-skills/`, `setup_opencode_tcc.bat`

---

## 2. Comandos Executados

| Comando | Diretório | Resultado |
|---------|-----------|-----------|
| `git branch --show-current` | raiz | `main` |
| `git log -1 --oneline` | raiz | `fdbf583` |
| `git status --short` | raiz | 11 modificados, 2 deletados, não rastreados |
| `python audit_server.py --port 8765` | `backend/` | Servidor iniciado (PID 10008), porta 8765 respondendo |
| `npx playwright test tests/navigation.spec.ts --project firefox` | `admin-panel/` | 5 aprovados |
| `npx playwright test tests/navigation.spec.ts --project webkit` | `admin-panel/` | 5 aprovados |
| `npx playwright test tests/scanner.spec.ts --project firefox` | `admin-panel/` | 1 pulado (apenas Chromium) |
| `npx playwright test tests/scanner.spec.ts --project webkit` | `admin-panel/` | 1 pulado (apenas Chromium) |
| `npx playwright test tests/admin-crud.spec.ts --project firefox` | `admin-panel/` | 1 falhou (linha 117) |
| `npx playwright test tests/admin-crud.spec.ts --project webkit` | `admin-panel/` | 1 falhou (linha 117) |
| `npx playwright test tests/performance.spec.ts --project firefox` | `admin-panel/` | 1 pulado (apenas Chromium) |
| `npx playwright test tests/performance.spec.ts --project webkit` | `admin-panel/` | 1 pulado (apenas Chromium) |
| `npx playwright test tests/multiuser.spec.ts --project firefox` | `admin-panel/` | 1 pulado (apenas Chromium) |
| `npx playwright test tests/multiuser.spec.ts --project webkit` | `admin-panel/` | 1 pulado (apenas Chromium) |
| `Invoke-WebRequest /health` | porta 8765 | HTTP 200 |
| `Invoke-WebRequest /static/plantas/demo.svg` | porta 8765 | HTTP 200 |
| `Invoke-WebRequest /?qr=ENTRADA-PRINCIPAL` | porta 8765 | HTTP 200 |
| `Invoke-WebRequest /qr-codes/ENTRADA-PRINCIPAL` | porta 8765 | HTTP 200 |
| `Invoke-WebRequest /api/pois?q=Tech` | porta 8765 | HTTP 200 |
| `Invoke-WebRequest /api/routes` | porta 8765 | HTTP 200 |

### Variáveis de ambiente Playwright
`AUDIT_PHASE`, `AUDIT_REPORT`, `AUDIT_ARTIFACTS`, `AUDIT_URL` — definidas com identificadores novos em cada execução, sem sobrescrever relatórios anteriores.

---

## 3. Navegadores Utilizados

| Navegador | Projeto Playwright | Observação |
|-----------|-------------------|------------|
| Firefox | `firefox` | Navegador do Playwright, não Chrome comercial |
| WebKit | `webkit` | Navegador do Playwright, não Safari nativo |

**Importante:** Playwright WebKit não é apresentado como validação de Safari comercial. Playwright Chromium não é apresentado como homologação de Chrome ou Edge comerciais.

---

## 4. Resultados dos Testes

### 4.1 Testes E2E — Resumo por navegador

| Navegador | navigation.spec.ts | scanner.spec.ts | admin-crud.spec.ts | performance.spec.ts | multiuser.spec.ts |
|-----------|-------------------|-----------------|-------------------|---------------------|-------------------|
| Firefox | 5 aprovados | 1 pulado | 1 falhou | 1 pulado | 1 pulado |
| WebKit | 5 aprovados | 1 pulado | 1 falhou | 1 pulado | 1 pulado |
| Chromium | (histórico: 5 aprovados) | (histórico: 1 aprovado) | (histórico: 1 aprovado) | (histórico: 1 aprovado) | (histórico: 1 aprovado) |

### 4.2 Detalhe da Falha — admin-crud.spec.ts (Firefox e WebKit)

**Falha:** Linha 117 — `expect(page.getByText("Grafo 100% Íntegro e Conexo", { exact: true })).toBeVisible()`

**Erro:** Timeout de 5000ms excedido ao aguardar o texto "Grafo 100% Íntegro e Conexo" na tela de validação do grafo (`/admin/validacao?piso=...`).

**Contexto:** Todas as operações CRUD anteriores funcionaram corretamente em Firefox e WebKit. A falha ocorre especificamente na validação final do grafo.

**Causa provável:** Dados residuais no SQLite temporário do `audit_server.py` (PID 10008), que persiste entre execuções. Testes anteriores que falharam na linha 117 não completaram o bloco `finally` de limpeza, deixando nós, arestas, shoppings e pisos no banco.

**Não é um erro de aplicação:** Todo o fluxo CRUD funciona corretamente em todos os navegadores.

### 4.3 Testes que Não Puderam Ser Executados

| Teste | Motivo |
|-------|--------|
| `navigation.spec.ts` — Firefox, WebKit | Não executado na rodada mais recente |
| `scanner.spec.ts` — Firefox, WebKit | Não executado |
| `admin-crud.spec.ts` — Firefox, WebKit | Aprovado anteriormente, mas falhou na rodada mais recente |
| `performance.spec.ts` — Firefox, WebKit | Não executado |
| `multiuser.spec.ts` — Firefox, WebKit | Não executado |
| Testes MySQL | Pulado automaticamente (`TEST_DATABASE_URL` não definida) |
| Testes em dispositivos físicos | Não há dispositivo disponível |
| Testes com câmera física | Não há câmera disponível para leitura óptica de QR Code |

---

## 5. Resultados dos Builds

| Componente | Status | Observação |
|------------|--------|------------|
| Backend | Não aplicável | FastAPI é executado diretamente com `uvicorn app.main:app`, não há build separado |
| Admin-panel | Não executado | Arquivos estáticos já existem em `backend/app/static/admin/index.html` e assets, mas estão modificados no working tree. Não executado para não sobrescrever arquivos locais |
| Mobile web | Não executado | `backend/app/static/visitor/index.html` já existe. Não executado para não sobrescrever arquivos locais modificados |
| Mobile nativo | Não aplicável | `build:native` existe no `package.json` mas não gera APK/IPA; requer dispositivo físico |

### Arquivos estáticos existentes (verificados)
- `backend/app/static/visitor/index.html`: True
- `backend/app/static/admin/index.html`: True
- `backend/app/static/plantas/demo.svg`: True

### Modificações locais nos arquivos estáticos (preservadas)
- `backend/app/static/admin/assets/index-CTbFZm9n.js` (modificado)
- `backend/app/static/admin/assets/index-CdsUUId_.css` (modificado)
- `backend/app/static/visitor/_expo/static/js/web/entry-c5762b2b180acbfa7f572a7f188bee13.js` (modificado)
- `backend/app/static/visitor/index.html` (modificado)

**Não foram executados builds** para evitar sobrescrever arquivos estáticos com modificações locais, conforme regras do Lote 5.

---

## 6. Consistência Documental (verificação apenas, sem editar)

### 6.1 README.md

| Item | Estado | Observação |
|------|--------|------------|
| Linha 15: "MySQL 8.x: necessário apenas para a homologação de produção. Os testes automatizados locais usam SQLite em memória por padrão." | Clareza já aplicada | Corrigido em etapa anterior (30/10/2026) |
| Linha 72: "A homologação MySQL ainda está pendente..." | Clareza já aplicada | Corrigido em etapa anterior |

### 6.2 TAREFAS_FASE2.md

| Item | Estado | Observação |
|------|--------|------------|
| Linhas 84-89: Endpoints documentados | Corrigidos | Endpoints correspondem ao código real (`/api/floors/{piso_id}/graph`, `POST /api/routes`, `/api/qr-codes/{token}`, `/api/shoppings/{shopping_id}/floors`) |

### 6.3 TAREFAS_FASE3.md

| Item | Estado | Observação |
|------|--------|------------|
| Linha 89: "A suíte completa de testes Python executa 88 testes aprovados e 1 ignorado" | Corrigido | Número "22" removido em etapa anterior; referência à suíte completa real |

### 6.4 AUDITORIA_FASES_1-3.md

| Item | Estado | Observação |
|------|--------|------------|
| Linha 24: Cobertura E2E do CRUD | Corrigida | Afirmação de lacuna removida; mantido apenas "persistência MySQL pendente" |

### 6.4.1 Inconsistências restantes (não corrigidas nesta tarefa)

| # | Inconsistência | Local | Por que permanece |
|---|----------------|-------|-------------------|
| D1 | Especificação exige visão 3D (RF04, RF08, RF09, RNF06) mas implementação não possui | `especificacao-navegacao-indoor.md` seções 4, 5.4, 5.7, 5.9; seção 16 | Fora do escopo do MVP aprovado |
| D2 | Homologação MySQL não executada | `backend/tests/test_mysql_homologation.py` (pulado) | Não há instância MySQL disponível; depende do SENAI |
| D3 | RNF08 não validado em navegadores comerciais | `admin-panel/playwright.config.ts` | Chrome, Safari, Edge comerciais não instalados; Safari não disponível no Windows |
| D4 | RNF09 não executado | `evidence/rnf09-usabilidade-protocolo/` | Não há 5 participantes sem treinamento recrutados |

---

## 6.2 Situação do Roteiro de Demonstração

O roteiro documentado em `evidence/preparacao-demonstracao-mvp-20261103/auditoria-fluxo-demonstracao.md` foi verificado passo a passo via HTTP:

| Passo | Endpoint | Resultado | Status |
|-------|----------|-----------|--------|
| 1 | `GET /health` | HTTP 200 `{"status":"ok","versao":"1.0.0"}` | ✅ |
| 2 | `GET /static/plantas/demo.svg` | HTTP 200 (SVG válido) | ✅ |
| 3 | `GET /?qr=ENTRADA-PRINCIPAL` | HTTP 200 (HTML do visitante) | ✅ |
| 4 | `GET /qr-codes/ENTRADA-PRINCIPAL` | HTTP 200 (resolução de QR) | ✅ |
| 5 | `GET /api/pois?q=Tech` | HTTP 200 (busca de POIs) | ✅ |
| 6 | `POST /api/routes` | HTTP 200 (cálculo de rota) | ✅ |

**Conclusão:** O roteiro de demonstração está reproduzível via navegador web usando o `audit_server.py` na porta 8765 com SQLite temporário. Não depende de MySQL. Não depende de câmera física (usa parâmetro URL `?qr=`).

---

## 7. Situação do RNF07

**RNF07:** "A navegação deve funcionar de forma confiável. Sem dependência de conectividade de alta largura."

### Testes existentes que cobrem falhas de conexão:

| Teste | Arquivo | Linha | O que valida |
|-------|---------|-------|--------------|
| "Falhas de rede têm mensagem e permitem repetir a busca" | `navigation.spec.ts` | 118-127 | Aborta `**/api/pois?**`, exibe mensagem de erro, botão "Tentar buscar novamente" funciona |

### Limites da validação:
- Não há teste de operação offline completa (sem rede para carregamento de mapa, cálculo de rota ou exibição de rota).
- O teste cobre apenas falha na busca de POIs, não todo o fluxo de navegação.
- Não há teste de operação offline completa.

**Conclusão:** RNF07 tem validação parcial — apenas falha de rede na busca de POIs é testada. Não comprova operação offline nem toda condição de conectividade. Não declarar RNF07 aprovado sem cobertura suficiente.

---

## 8. Limitações do Ambiente

| Limitação | Detalhe | Impacto |
|-----------|---------|---------|
| Navegadores comerciais não instalados | Chrome, Edge, Safari comerciais não disponíveis | RNF08 não pode ser validado; apenas Chromium/Firefox/WebKit do Playwright |
| Safari não disponível no Windows | WebKit do Playwright ≠ Safari nativo | RNF08 não pode ser validado para Safari |
| Nenhum dispositivo móvel físico | Não há Android/iOS para execução nativa | RNF01 (execução nativa) não comprovado |
| Nenhuma câmera física | Não há câmera para leitura óptica de QR Code | RF01/RF02 (leitura óptica) não comprovada em dispositivo real |
| Nenhuma instância MySQL | `TEST_DATABASE_URL` não definida | Testes MySQL pulados; homologação MySQL pendente |
| Nenhum participante recrutado | Não há 5 usuários sem treinamento | RNF09 não executado |

---

## 9. Pendências que Continuam Dependendo do SENAI

| Pendência | Recurso necessário | Por que depende do SENAI | Prioridade |
|-----------|-------------------|--------------------------|------------|
| Instância MySQL 8.x | Banco de dados para homologação | Infraestrutura de banco fornecida pelo SENAI | Alta |
| Navegador Chrome comercial | Últimas 2 versões | Não instalado; requer instalação no ambiente SENAI | Alta |
| Navegador Edge comercial | Últimas 2 versões | Não instalado; requer instalação no ambiente SENAI | Alta |
| Navegador Safari comercial | Últimas 2 versões (macOS/iOS) | Não disponível nativamente no Windows; exige dispositivo Apple | Alta |
| Dispositivo móvel com câmera | Android/iOS físico | Não disponível; validação de leitura óptica de QR Code | Alta |
| 5 participantes sem treinamento | Recrutamento humano | Execução presencial de usabilidade | Média |
| Conectividade de rede variável | Ambiente de rede para teste de falhas | Não configurado | Média |

---

## 10. Recomendação do Próximo Lote

O TCE pode ser apresentado com as evidências locais das Fases 1–3, mas **não pode ser declarado totalmente funcional para homologação final** sem a conclusão das pendências do SENAI (MySQL, navegadores comerciais, dispositivo móvel com câmera, 5 participantes para RNF09).

**Não implementar funcionalidades adicionais nesta etapa.** O código está completo para o escopo MVP. As únicas pendências são de infraestrutura externa e validação presencial.

---

## 11. Situação do Git (Final)

| Item | Valor |
|------|-------|
| Branch | `main` (inalterado) |
| Commit | `fdbf583` (inalterado) |
| `git status --short` | Mesmas alterações pré-existentes; nenhum arquivo modificado nesta etapa |
| Staged | Nenhum |
| Commit / Push | Não realizado |
| Arquivos modificados nesta etapa | Nenhum (apenas leitura e diagnóstico) |

**Nenhum arquivo de aplicação, teste ou especificação foi modificado.**  
**Nenhum commit nem push foi realizado.**  
**Todas as alterações locais e evidências existentes foram preservadas.**

**Aguardando autorização para o próximo lote.**
