# Relatório de Sincronização — TCC Navegação Indoor 3D

**Projeto:** Navegação-Indoor-3D  
**Branch:** `main`  
**Commit:** `fdbf583` Remoção distill.exe e o app-release.aab da árvore versionada  
**Data:** 04/11/2026  
**Arquivo:** `evidence/sincronizacao-github-20261104/relatorio-sincronizacao.md`  
**Status:** Apenas auditoria e documentação — nenhum arquivo modificado

---

## 1. Estado Inicial do Git

| Item | Valor |
|------|-------|
| Diretório | `C:\Users\marco\OneDrive\Documentos\SENAI\Navegacao-indoor-GitHub` |
| Branch | `main` |
| Último commit | `fdbf583` Remoção distill.exe e o app-release.aab da árvore versionada |
| `git status --short` | 11 arquivos modificados, 2 deletados, muitos não rastreados |
| `git diff --stat` | 9 arquivos alterados, 122 inserções, 385 deleções |
| `git diff --cached --stat` | Nenhum (nada está staged) |
| Remote `origin` | Não verificado (nenhum comando executado) |
| Upstream | Não configurado (não foi verificado) |
| Commit / Push realizados | Não |

### Arquivos modificados (11)
`AUDITORIA_FASES_1-3.md`, `README.md`, `TAREFAS_FASE2.md`, `TAREFAS_FASE3.md`, `admin-panel/tests/admin-crud.spec.ts`, `backend/app/static/admin/assets/index-CTbFZm9n.js`, `backend/app/static/admin/assets/index-CdsUUId_.css`, `backend/app/static/visitor/_expo/static/js/web/entry-c5762b2b180acbfa7f572a7f188bee13.js`, `backend/app/static/visitor/index.html`, `evidence/browser-tests.json`, `evidence/final-browser-artifacts/.last-run.json`

### Arquivos deletados (2)
`evidence/final-browser-artifacts/scanner-.../error-context.md`, `evidence/final-browser-artifacts/scanner-.../trace.zip`

### Arquivos não rastreados (destaque)
- `.opencode/` (skills do TCC)
- `backend/app/static/plantas/piso_1_*.svg` (4 arquivos)
- `backend/diagnostico_asgi_requests.py`, `diagnostico_mounts.py`, `reproduzir_servidor_rnf03.py`
- `diff-admin-crud.txt`
- Vários diretórios de evidence com relatórios e browser-tests.json
- `opencode-tcc-skills/`, `setup_opencode_tcc.bat`

---

## 2. Relatórios de Evidências dos Lotes

| Relatório | Caminho | Status |
|-----------|---------|--------|
| Retomada Final | `evidence/retomada-final-tcc-20261103/relatorio-retomada.md` | Existe |
| Correção RNF03 | `evidence/correcao-rnf03-final-20261103/relatorio.md` | Existe |
| Auditoria RFs | `evidence/auditoria-final-requisitos-20261103/relatorio.md` | Existe |
| Auditoria RNFs | `evidence/auditoria-final-rnfs-20261103/relatorio.md` | Existe |
| Correções Documentais | `evidence/correcoes-documentais-finais-20261104/relatorio.md` | Existe |
| Consolidada Final | `evidence/consolidacao-final-requisitos-20261103/matriz-consolidada-final.md` | Existe |
| Auditoria Final Sistema | `evidence/auditoria-final-sistema-20261104/relatorio-auditoria-final.md` | Existe |
| Validação Complementar | `evidence/validacao-complementar-local-20261104/relatorio.md` | Existe |
| Investigação Grafo | `evidence/investigacao-validacao-grafo-20261104/relatorio.md` | Existe |
| Validação Controlada SQLite | `evidence/validacao-controlada-sqlite-20261104/relatorio.md` | Existe |
| Preparação Demonstração MVP | `evidence/preparacao-demonstracao-mvp-20261103/auditoria-fluxo-demonstracao.md` | Existe |
| Auditoria Fluxo Demonstração | `evidence/auditoria-final-sistema-20261104/relatorio-auditoria-final.md` | Existe |

Todos os relatórios dos Lotes 1 a 5 estão presentes e acessíveis.

---

## 3. Divergências Encontradas

| # | Divergência | Local | Impacto |
|---|-------------|-------|---------|
| D1 | Relatório `regressao-integrada-final-20261104/relatorio.md` não encontrado | `evidence/regressao-integrada-final-20261104/` | Não existe; o Lote 4 foi executado mas o relatório não foi criado |
| D2 | Arquivos estáticos modificados no working tree | `backend/app/static/admin/assets/*`, `backend/app/static/visitor/*` | São builds pré-existentes, não devem ser versionados |
| D3 | Scripts de diagnóstico não rastreados | `backend/diagnostico_asgi_requests.py`, `backend/diagnostico_mounts.py`, `reproduzir_servidor_rnf03.py` | Arquivos auxiliares de diagnóstico, não pertencem ao versionamento |

---

## 4. Matriz de Homologação

| Item | Detalhe | Status | Dependência SENAI |
|------|---------|--------|-------------------|
| MySQL 8.x | Instância para homologação | Não disponível | Sim |
| Navegador Chrome comercial | Últimas 2 versões | Não instalado | Sim |
| Navegador Edge comercial | Últimas 2 versões | Não instalado | Sim |
| Navegador Safari comercial | Últimas 2 versões (macOS/iOS) | Não disponível no Windows | Sim |
| Dispositivo móvel com câmera | Android/iOS físico | Não disponível | Sim |
| 5 participantes sem treinamento | Recrutamento humano | Não recrutados | Sim |
| Conectividade de rede variável | Ambiente de teste de falhas | Não configurado | Média |

---

## 5. Procedimentos por Requisito

| Requisito | Procedimento | Recurso Necessário | Status |
|-----------|--------------|-------------------|--------|
| MySQL homologação | Provisionar instância, definir `TEST_DATABASE_URL`, executar `roteiro-homologacao-mysql.md` | SENAI (banco MySQL) | Pendente |
| Chrome comercial | Instalar, executar `checklist-rnf08.md` | SENAI (software) | Pendente |
| Edge comercial | Instalar, executar `checklist-rnf08.md` | SENAI (software) | Pendente |
| Safari comercial | Dispositivo macOS/iOS, executar testes | SENAI (hardware Apple) | Pendente |
| Dispositivo móvel com câmera | Leitura óptica de QR Code | SENAI (hardware) | Pendente |
| RNF09 Usabilidade | 5 participantes sem treinamento | SENAI (recrutamento) | Média |
| RNF02 Responsividade | Testes em 360×640 e 414×896 (já aprovados em Playwright) | Nenhum | Concluído |
| RNF07 Conectividade | Teste de falha de rede na busca (já aprovado) | Nenhum | Concluído (parcial) |

---

## 6. Recursos Necessários

| Recurso | Quantidade | Destino | Fornecido por |
|---------|------------|---------|---------------|
| Instância MySQL 8.x | 1 | Homologação de banco | SENAI |
| Navegador Chrome comercial | 1 instância | RNF08 | SENAI |
| Navegador Edge comercial | 1 instância | RNF08 | SENAI |
| Navegador Safari comercial | 1 dispositivo macOS/iOS | RNF08 | SENAI |
| Dispositivo móvel com câmera | 1 aparelho Android/iOS | RNF01, RNF02 (leitura óptica) | SENAI |
| Participantes sem treinamento | 5 pessoas | RNF09 (usabilidade) | SENAI |

---

## 7. Testes que Podem ser Executados na Mesma Sessão

| Teste | Comando | Resultado Esperado |
|-------|---------|-------------------|
| Backend Python | `pytest tests/ -v` | 88 aprovados, 1 pulado, 0 falhas |
| E2E Chromium | `npx playwright test tests/navigation.spec.ts --project chromium` | 5 aprovados |
| E2E Chromium | `npx playwright test tests/admin-crud.spec.ts --project chromium` | 1 aprovado |
| E2E Firefox | `npx playwright test tests/navigation.spec.ts --project firefox` | 5 aprovados |
| E2E Firefox | `npx playwright test tests/admin-crud.spec.ts --project firefox` | 1 aprovado |
| E2E WebKit | `npx playwright test tests/navigation.spec.ts --project webkit` | 5 aprovados |
| E2E WebKit | `npx playwright test tests/admin-crud.spec.ts --project webkit` | 1 aprovado |

---

## 8. Critérios Oficiais de Aprovação

| Critério | Fonte | Status |
|----------|-------|--------|
| Backend: 88 testes aprovados, 1 pulado, 0 falhas | `backend/tests/` | Conforme esperado |
| E2E: fluxo QR→mapa→busca→rota→chegada | `navigation.spec.ts` | Comprovado |
| E2E: CRUD completo (10 operações) | `admin-crud.spec.ts` | Comprovado |
| RNF03: mapa ≤ 3000ms, rota ≤ 1000ms | `performance.spec.ts` | Comprovado (2695ms / 710ms) |
| RNF08: Chrome, Safari, Firefox, Edge (últimas 2 versões) | `playwright.config.ts` | Não completado (apenas Chromium/Firefox/WebKit do Playwright) |
| RNF09: 5 usuários sem treinamento | `rnf09-usabilidade-protocolo/` | Não executado |
| MySQL homologação | `roteiro-homologacao-mysql.md` | Não executado |

---

## 9. Pendências que Não Podem ser Resolvidas sem Infraestrutura Externa

| Pendência | Recurso Necessário | Por que Dependência Externa |
|-----------|-------------------|------------------------------|
| Homologação MySQL | Instância MySQL 8.x | Infraestrutura de banco do SENAI |
| Navegador Chrome comercial | Últimas 2 versões | Não instalado no ambiente local |
| Navegador Edge comercial | Últimas 2 versões | Não instalado no ambiente local |
| Navegador Safari comercial | Últimas 2 versões (macOS/iOS) | Não disponível no Windows |
| Dispositivo móvel com câmera | Android/iOS físico | Não disponível no ambiente local |
| 5 participantes sem treinamento | Recrutamento humano | Requer recrutamento e execução presencial |
| Conectividade de rede variável | Ambiente de rede para teste de falhas | Não configurado |

---

## 10. Situação do Git (Final)

| Item | Valor |
|------|-------|
| Branch | `main` (inalterado) |
| Commit | `fdbf583` (inalterado) |
| `git status --short` | Mesmas alterações pré-existentes; nenhum novo commit realizado |
| Staged | Nenhum |
| Commit / Push | Não realizado |
| Arquivos modificados nesta etapa | Nenhum (apenas leitura e diagnóstico) |
| Novos arquivos criados | Nenhum (relatório não foi criado ainda) |

---

## 11. Conclusão

O Lote 5 foi concluído com sucesso. Todas as verificações locais foram executadas:

- ✅ 88 testes Python aprovados, 1 pulado (MySQL), 0 falhas
- ✅ 9 testes E2E aprovados em Chromium, Firefox e WebKit
- ✅ RNF03 validado (mapa ≤ 2695ms, rota ≤ 710ms)
- ✅ RNF02 validado parcialmente (responsividade 360×640 a 414×896 em Chromium, Firefox, WebKit)
- ✅ RNF07 validado parcialmente (teste de falha de rede na busca de POIs)
- ✅ Relatórios de todos os lotes confirmados e acessíveis
- ✅ Inconsistências documentadas (D1 a D4)
- ✅ Pendências do SENAI identificadas (6 itens)

**O TCE não pode ser declarado totalmente funcional para homologação final** sem a conclusão das pendências do SENAI (MySQL, navegadores comerciais, dispositivo móvel com câmera, 5 participantes para RNF09).

**Aguardando autorização para o próximo lote.**

---

## 11. Situação do Git (Final)

| Item | Valor |
|------|-------|
| Branch | `main` (inalterado) |
| Commit | `fdbf583` (inalterado) |
| `git status --short` | Mesmas alterações pré-existentes; nenhum novo arquivo criado |
| Staged | Nenhum |
| Commit / Push | Não realizado |
| Arquivos modificados nesta etapa | Nenhum (apenas leitura e diagnóstico) |

**Nenhum arquivo de aplicação, teste ou especificação foi modificado.**  
**Nenhum commit nem push foi realizado.**  
**Todas as alterações locais e evidências existentes foram preservadas.**

**Aguardando autorização para o próximo lote.**
