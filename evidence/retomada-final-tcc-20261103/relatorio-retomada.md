# Relatório de Retomada Técnica — TCC Navegação Indoor 3D

**Projeto:** Navegação-Indoor-3D  
**Branch:** `main`  
**Commit:** `fdbf583` Remoção distill.exe e o app-release.aab da árvore versionada  
**Data da auditoria:** 03/11/2026  
**Pasta do projeto:** `C:\Users\marco\OneDrive\Documentos\SENAI\Navegacao-indoor-GitHub`  
**Arquivo:** `evidence/retomada-final-tcc-20261103/relatorio-retomada.md`  
**Status:** Apenas leitura e registro — nenhuma alteração de código, commit, push ou comando destrutivo executado.

---

## 1. Estado real do repositório

### 1.1 Pasta atual do projeto
Confirma-se a pasta `C:\Users\marco\OneDrive\Documentos\SENAI\Navegacao-indoor-GitHub` como a raiz do repositório git.

### 1.2 Comandos de git executados e registrados

| Comando | Resultado |
|---------|-----------|
| `git branch --show-current` | `main` |
| `git log -1 --oneline` | `fdbf583 Remoção distill.exe e o app-release.aab da árvore versionada` |
| `git status --short` | 11 arquivos modificados (não staged), 2 arquivos deletados (não staged), muitos arquivos não rastreados |
| `git diff --stat` | 9 arquivos alterados, 122 inserções, 385 deleções (inclui remoção de `error-context.md` e `trace.zip`) |
| `git diff --cached --stat` | (sem saída — nada está staged) |

### 1.3 Alterações staged, unstaged e não rastreadas

**Staged (índice):** nenhum. `git diff --cached --stat` não retornou saída.

**Unstaged (working tree) — 13 entradas:**
- Modificações em 11 arquivos rastreados:
  - `AUDITORIA_FASES_1-3.md`
  - `README.md`
  - `TAREFAS_FASE2.md`
  - `TAREFAS_FASE3.md`
  - `admin-panel/tests/admin-crud.spec.ts`
  - `backend/app/static/admin/assets/index-CTbFZm9n.js`
  - `backend/app/static/admin/assets/index-CdsUUId_.css`
  - `backend/app/static/visitor/_expo/static/js/web/entry-c5762b2b180acbfa7f572a7f188bee13.js`
  - `backend/app/static/visitor/index.html`
  - `evidence/browser-tests.json`
  - `evidence/final-browser-artifacts/.last-run.json`
- Deleções de 2 arquivos rastreados:
  - `evidence/final-browser-artifacts/scanner-.../error-context.md`
  - `evidence/final-browser-artifacts/scanner-.../trace.zip`

**Não rastreados (untracked) — destaque:**
- `.opencode/` (skills do TCC)
- `backend/app/static/plantas/piso_1_*.svg` (4 arquivos de planta baixa)
- `backend/diagnostico_asgi_requests.py`
- `backend/diagnostico_mounts.py`
- `backend/reproduzir_servidor_rnf03.py`
- `diff-admin-crud.txt`
- `evidence/auditoria-diagnostico-20261030/` e `auditoria-diagnostico-20261030-v2/`
- `evidence/auditoria-final-local-20261030/`
- `evidence/correcao-performance-rnf03-20261031/`
- `evidence/correcoes-documentais-20261030/`
- Vários diretórios `crud-final*`, `crud-fix*`, `crud-retry*`, `e2e-*`, `perf-retry-*` com browser-tests.json e browser-artifacts
- `evidence/diagnostico-asgi-requests-rnf03-20261031/`
- `evidence/diagnostico-mounts-rnf03-20261031/`
- `evidence/diagnostico-performance-20261030/`
- `evidence/diagnostico-processo-rnf03-20261031/`
- `evidence/diagnostico-runtime-rnf03-20261031/`
- `evidence/diagnostico-servidor-rnf03-20261031/`
- `evidence/homologacao-final-20261030/`
- `evidence/multiuser-diagnostico-20261030/`
- `evidence/reproducao-servidor-rnf03-20261031/`
- `evidence/revisao-coerencia-final-20261030/`
- `evidence/rnf08-navegadores-20261030/`
- `evidence/rnf09-usabilidade-protocolo/`
- `evidence/validacao-coerencia-documental-20261030/`
- `opencode-tcc-skills/`
- `setup_opencode_tcc.bat`

Todos esses arquivos e diretórios não rastreados existem no working tree e **devem ser preservados**.

---

## 2. Alterações locais que precisam ser preservadas

Nenhuma alteração local deve ser revertida, apagada ou formatada. Em particular:

- **Modificações de documentos** (`README.md`, `TAREFAS_FASE2.md`, `TAREFAS_FASE3.md`, `AUDITORIA_FASES_1-3.md`, `admin-panel/tests/admin-crud.spec.ts`) — já estão no working tree e refletem o estado atual da documentação.
- **Arquivos de build estáticos** em `backend/app/static/admin/assets/` e `backend/app/static/visitor/` — gerados pelos builds de `mobile/` e `admin-panel/`; não devem ser editados manualmente (conforme `AGENTS.md`).
- **Arquivos de evidência** em `evidence/` — incluindo relatórios de auditoria, browser-tests.json, traces, screenshots e `.last-run.json`; não devem ser sobrescritos nem apagados.
- **Arquivos não rastreados de diagnóstico** (`backend/diagnostico_*.py`, `backend/reproduzir_servidor_rnf03.py`) — úteis para entender a causa raiz do problema de estáticos do `audit_server.py`.
- **SVGs de planta baixa** em `backend/app/static/plantas/` — novos arquivos não rastreados.

---

## 3. Estrutura atual de backend, admin-panel e visitor

### 3.1 Backend (`backend/`)
- `app/main.py` — app FastAPI, montagem de estáticos (`/static`, `/admin`, `/`), CORS, lifespan
- `app/config.py`, `app/database.py`, `app/auth.py`, `app/migrations.py`, `app/static_spa.py`
- `app/models/`, `app/schemas/`, `app/routers/` (`public.py`, `admin.py`), `app/services/`
- `app/static/admin/` — build do painel administrativo (servido em `/admin/`)
- `app/static/visitor/` — build do aplicativo visitante (servido em `/`)
- `app/static/plantas/` — plantas baixas (SVG/PNG)
- `tests/` — `conftest.py`, `test_api.py`, `test_audit.py`, `test_navigation.py`, `test_mysql_homologation.py`
- `requirements.txt` — FastAPI, SQLAlchemy, uvicorn, pymysql, pytest, etc.
- `seed.py` — popula banco de exemplo
- `audit_server.py` — servidor de auditoria local na porta 8765 (SQLite temporário)
- `pytest.ini` — marcador `mysql` para testes de homologação
- `.env.example` — variáveis de ambiente (credenciais MySQL, chave admin)

### 3.2 Painel administrativo (`admin-panel/`)
- React + Vite, TypeScript
- `src/` — código-fonte do painel
- `tests/` — Playwright: `admin-crud.spec.ts`, `multiuser.spec.ts`, `navigation.spec.ts`, `performance.spec.ts`, `scanner.spec.ts`
- `playwright.config.ts` — projetos: chromium, firefox, webkit, chrome, msedge; `outputDir` e `AUDIT_REPORT` via variáveis de ambiente
- `package.json` — scripts: `dev`, `build` (`tsc --noEmit && vite build`), `preview`, `test:e2e`
- Build exporta para `backend/app/static/admin/`

### 3.3 Aplicativo visitante (`mobile/`)
- Expo + React Native + Expo Router
- `app/(tabs)/` — abas: Mapa (`index.tsx`), Scanner QR (`scan.tsx`), Explorar POIs (`explore.tsx`)
- `services/api.ts` — cliente que consome `/api/floors/{pisoId}/graph`, `POST /api/routes`, `/api/qr-codes/{token}`
- `package.json` — scripts: `start`, `web`, `build:web` (`expo export --platform web --output-dir ../backend/app/static/visitor`), `build:native`, `typecheck`
- Build web exporta para `backend/app/static/visitor/` (servido em `/`)

### 3.4 Referências/upstreams (não são a implementação integrada)
- `indoor-wayfinder-main/`, `Waypoint-main/`, `QRNav-master/`, `indrz-be-main/`, `indoor-navigation-system-qrcode-augmented-reality-master/`

---

## 4. Como executar cada componente

| Componente | Como executar (conforme README.md) | Porta / URL |
|------------|------------------------------------|-------------|
| **Backend** | `cd backend; pip install -r requirements.txt; cp .env.example .env; uvicorn app.main:app --reload` | `http://localhost:8000` (API em `/api`, saúde em `/health`) |
| **Servidor de auditoria** | `cd backend; python audit_server.py --port 8765` | `http://127.0.0.1:8765` (SQLite temporário, chave `audit-local-only`) |
| **Painel admin** | `cd admin-panel; npm ci; npm run build` (produção) ou `npm run dev` (desenvolvimento) | Servido pelo backend em `/admin/` |
| **Aplicativo visitante** | `cd mobile; npm ci; npm run build:web` | Exporta para `backend/app/static/visitor/`, servido em `/` |
| **Testes backend** | `cd backend; pytest tests/ -v` (SQLite em memória por padrão) | — |
| **Testes Playwright** | `cd admin-panel; npx playwright test` (requer servidor na porta 8765) | Base URL `http://127.0.0.1:8765` |

Comandos de validação definidos em `AGENTS.md`:
```powershell
cd backend; pytest tests/ -v
cd mobile; npm ci; npm run typecheck; npm run build:web
cd admin-panel; npm ci; npm run build
```

---

## 5. Estado atual dos testes

### 5.1 Testes Python (backend)
- **Última execução registrada:** 88 aprovados, 1 pulado, 0 falhas (3,53s)
- Teste pulado: `test_mysql_homologation_database_is_active` (MySQL não configurado, `TEST_DATABASE_URL` não definida)
- Arquivos de teste: `test_api.py`, `test_audit.py`, `test_navigation.py`
- Evidências históricas: `evidence/auditoria-final-local-20261030/`, `closure-pytest.xml`, `final-pytest.xml`

### 5.2 Testes E2E Playwright (admin-panel)
- **Última execução registrada (auditoria final, 30/10):** 8 aprovados, 1 falhou (infraestrutura, não aplicação)
  - `admin-crud.spec.ts` chromium: 1 aprovado
  - `multiuser.spec.ts` chromium: 1 aprovado
  - `navigation.spec.ts` chromium: 5 aprovados
  - `scanner.spec.ts` chromium: 1 aprovado
  - `performance.spec.ts` chromium: 1 falhou (erro de sistema de arquivos ao gravar trace; aplicação funcionou)
- **Execuções anteriores bem-sucedidas:**
  - `admin-crud.spec.ts` Firefox e WebKit aprovados (`evidence/rnf08-navegadores-20261030/`)
  - `multiuser.spec.ts` chromium aprovado (`evidence/multiuser-diagnostico-20261030/`)

### 5.3 Testes que não puderam ser executados
- `admin-crud.spec.ts` — Firefox e WebKit (não reexecutados nesta sessão, mas aprovados anteriormente)
- `navigation.spec.ts` — Firefox e WebKit (não executados)
- `scanner.spec.ts` — Firefox e WebKit (não executados)
- `performance.spec.ts` — Firefox e WebKit (não executados)
- Testes MySQL — pulados automaticamente (`TEST_DATABASE_URL` não definida)
- Testes em dispositivos físicos (mobile nativo) — não há dispositivo disponível
- Testes com câmera física — não há câmera disponível para leitura óptica de QR Code

### 5.4 RNF03 (desempenho)
- Teste `performance.spec.ts` falha porque o mapa SVG não carrega dentro do timeout de 5s sob rede 4G simulada.
- Causa raiz confirmada: `audit_server.py` não está servindo arquivos estáticos corretamente (`/static/plantas/demo.svg` retorna 404; `/?qr=ENTRADA-PRINCIPAL` retorna 404; apenas `/health` responde 200).
- Erro secundário de `ENOENT` ao gravar traces do Playwright em `context.close()`.
- Não há tempos válidos de `mapMs` nem `routeMs` para relatar.

---

## 6. Problemas ainda pendentes (identificados nos relatórios existentes)

### 6.1 Problemas técnicos de código/infraestrutura

| # | Problema | Fonte | Impacto |
|---|----------|-------|---------|
| P1 | `audit_server.py` não serve arquivos estáticos (`/static`, `/`, `/admin` retornam 404) | `evidence/correcao-performance-rnf03-20261031/relatorio.md` | Teste de performance RNF03 não pode ser validado; mapa não carrega |
| P2 | Homologação MySQL não executada (não há instância, `TEST_DATABASE_URL` não definida) | `evidence/homologacao-final-20261030/roteiro-homologacao-mysql.md` | Fase 1 não tem aceite integral; persistência em MySQL não comprovada |
| P3 | RNF08 parcial/pendente — faltam navegadores comerciais (Chrome, Safari, Edge, últimas 2 versões cada) | `evidence/rnf08-navegadores-20261030/`, `AUDITORIA_FASES_1-3.md` linhas 71-85 | Critério de aceite de navegadores não atendido |
| P4 | RNF09 pendente — nenhum teste com 5 usuários sem treinamento executado | `evidence/rnf09-usabilidade-protocolo/`, `AUDITORIA_FASES_1-3.md` linha 34 | Usabilidade presencial não comprovada |
| P5 | Execução nativa em dispositivo físico não validada (sem dispositivo móvel, sem câmera física) | `evidence/auditoria-final-local-20261030/relatorio-auditoria-final.md` | RNF01/RF01 (leitura óptica de QR) não comprovado em dispositivo real |

### 6.2 Inconsistências documentais (não corrigidas nesta etapa)

| # | Inconsistência | Localização | Severidade |
|---|----------------|-------------|------------|
| D1 | README lista MySQL 8.x como requisito rígido, mas testes usam SQLite por padrão | `README.md` linhas 15, 41-47, 72 | Alta |
| D2 | `AUDITORIA_FASES_1-3.md` linha 24 declara lacuna de cobertura E2E do CRUD já sanada | `AUDITORIA_FASES_1-3.md` linha 24 | Alta |
| D3 | `TAREFAS_FASE2.md` linhas 87-89 menciona endpoints que não existem (`/api/grafo`, `/api/rotas`, `/api/qrcode`) | `TAREFAS_FASE2.md` | Média |
| D4 | `TAREFAS_FASE3.md` linha 89 menciona "22 testes passando" sem evidência | `TAREFAS_FASE3.md` linha 89 | Média |
| D5 | Especificação exige visão 3D (RF04, RF08, RF09) mas implementação não possui (Fase 4) | `especificacao-navegacao-indoor.md`, `AUDITORIA_FASES_1-3.md` linha 35 | Média |
| D6 | README não detalha que Chromium ≠ Chrome e WebKit ≠ Safari (nuances de RNF08) | `README.md` vs `DECISOES.md` item 18 | Baixa |

### 6.3 Incidentes não resolvidos
- **Hook failed with code 1:** falhas do lançador de hooks do Token Optimizer reproduzidas em PowerShell e WSL; vínculo com o evento original e correção integrada ainda pendentes (`evidence/resume-hook-launcher.json`, `AUDITORIA_FASES_1-3.md` linhas 93-109).

---

## 7. Cinco prioridades de desenvolvimento para a entrega em duas semanas

1. **Corrigir o `audit_server.py` para servir arquivos estáticos** (`/static`, `/`, `/admin`) de modo que o teste de performance RNF03 consiga carregar o mapa SVG e medir `mapMs` e `routeMs`. Esta é a correção de código mais urgente, pois desbloqueia a validação de desempenho.
2. **Executar a homologação MySQL** seguindo o roteiro em `evidence/homologacao-final-20261030/roteiro-homologacao-mysql.md`, definindo `TEST_DATABASE_URL` e executando `test_mysql_homologation.py`. Obrigatório para o aceite integral da Fase 1.
3. **Executar o checklist RNF08** (`evidence/homologacao-final-20261030/checklist-rnf08.md`) navegando nos fluxos nos navegadores comerciais Chrome e Edge (últimas duas versões cada), registrando navegador/SO/versão/data. Safari não está disponível nativamente no Windows — registrar como lacuna, não como N/A.
4. **Executar o protocolo RNF09** (`evidence/rnf09-usabilidade-protocolo/protocolo-usabilidade-rnf09.md`) com cinco usuários sem treinamento, registrando ajuda necessária, conclusão, tempos e erros. Exige recrutamento de participantes e execução presencial.
5. **Aplicar correções documentais** (não de código): ajustar `README.md` (MySQL como requisito apenas de homologação, não de testes locais), `TAREFAS_FASE2.md` (nomes corretos de endpoints), `TAREFAS_FASE3.md` (remover número "22" sem evidência), `AUDITORIA_FASES_1-3.md` linha 24 (remover afirmação de lacuna de CRUD já sanada), e marcar RF04/RF08/RF09 como não implementados nesta entrega.

---

## 8. Dependências de infraestrutura do SENAI

As seguintes dependências de infraestrutura são **externas ao repositório** e precisam ser providenciadas pelo ambiente do SENAI para concluir a homologação:

| Dependência | Detalhe | Status atual |
|-------------|---------|--------------|
| **Instância MySQL 8.x** | Necessária para homologação de produção; `TEST_DATABASE_URL` deve ser definida | Não disponível no ambiente; não há porta 3306 escutando |
| **Navegador Chrome comercial** | Últimas duas versões, para RNF08 | Não instalado |
| **Navegador Edge comercial** | Últimas duas versões, para RNF08 | Não instalado |
| **Navegador Safari comercial** | Últimas duas versões (macOS/iOS); WebKit no Windows não comprova Safari | Não disponível nativamente no Windows |
| **Dispositivo móvel físico** | Para execução nativa Android/iOS e leitura óptica de QR Code com câmera física | Não disponível |
| **Câmera física** | Para validação de leitura óptica de QR Code (RF01/RF02) | Não disponível |
| **Conectividade de rede variável / modo offline** | Para teste de falhas e recuperação (RNF07) | Não configurado |
| **Cinco participantes sem treinamento** | Para teste de usabilidade presencial RNF09 | Não recrutados |

---

## 9. Observações finais

- Nenhum arquivo foi modificado, corrigido, commitado, pushado, resetado ou removido durante esta auditoria.
- Todos os relatórios de evidência existentes foram preservados intocados.
- O projeto pode ser apresentado com as evidências locais das Fases 1–3, mas **não pode ser declarado totalmente funcional para homologação final** enquanto MySQL, navegadores comerciais, dispositivo físico/câmera e RNF09 não forem concluídos.
- A próxima etapa deverá ser definida após a revisão deste relatório, com foco nas cinco prioridades listadas na seção 7.
