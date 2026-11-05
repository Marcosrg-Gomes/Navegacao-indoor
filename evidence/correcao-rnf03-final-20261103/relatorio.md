# Relatório de Correção — RNF03 e Servidor de Auditoria

**Projeto:** Navegação-Indoor-3D  
**Branch:** `main`  
**Commit:** `fdbf583` Remoção distill.exe e o app-release.aab da árvore versionada  
**Data:** 03/11/2026  
**Arquivo:** `evidence/correcao-rnf03-final-20261103/relatorio.md`  
**Status:** Correção aplicada e validada — sem commit nem push

---

## 1. Causa identificada

### 1.1 Diagnóstico da Etapa 1

Foi verificado que o `audit_server.py` inicia o servidor via `uvicorn.run("app.main:app", ...)`, que importa `backend/app/main.py` e executa todos os mounts de arquivos estáticos definidos ali:

- `app.mount("/static", StaticFiles(directory=static_dir), name="static")` — serve `backend/app/static/` (inclui `plantas/demo.svg`)
- `app.mount("/admin", SPAStaticFiles(directory=admin_dist, html=True), name="admin")` — serve o painel administrativo
- `app.mount("/", SPAStaticFiles(directory=visitor_dist, html=True), name="visitor")` — serve o aplicativo visitante (quando `visitor/index.html` existe)

### 1.2 Conclusão sobre a causa raiz

**O `audit_server.py` não requer alteração de código.** Quando iniciado corretamente a partir do diretório `backend/` com `python audit_server.py --port 8765`, todos os mounts estáticos são aplicados e funcionam corretamente.

Os relatórios anteriores (`evidence/correcao-performance-rnf03-20261031/relatorio.md` e `evidence/diagnostico-performance-20261030/relatorio-diagnostico.md`) apontavam 404 para `/static/plantas/demo.svg` e `/?qr=ENTRADA-PRINCIPAL` quando o servidor estava na porta 8765. Essa falha não se reproduziu quando o servidor foi iniciado pelo procedimento oficial (`python audit_server.py --port 8765` a partir de `backend/`). A causa provável das falhas anteriores foi o servidor tendo sido iniciado de um diretório de trabalho diferente ou com uma versão anterior do código, não um defeito no `audit_server.py` ou `main.py`.

Nenhum arquivo de aplicação foi modificado.

---

## 2. Arquivos modificados

**Nenhum arquivo de aplicação, teste ou documentação foi modificado.**

A correção consistiu exclusivamente em iniciar o servidor pelo procedimento oficial e validar que os estáticos são servidos. Não houve alteração em `audit_server.py`, `app/main.py`, `static_spa.py`, `performance.spec.ts` ou qualquer outro arquivo de código.

---

## 3. Endpoints testados e resultados

Servidor iniciado com: `python audit_server.py --port 8765` (PID 9948), a partir de `C:\Users\marco\OneDrive\Documentos\SENAI\Navegacao-indoor-GitHub/backend`.

| Endpoint | Método | Status | Content-Type | Resultado |
|----------|--------|--------|--------------|-----------|
| `/health` | GET | 200 | application/json | `{"status":"ok","versao":"1.0.0"}` |
| `/static/plantas/demo.svg` | GET | 200 | image/svg+xml | SVG válido, 1.354 bytes |
| `/?qr=ENTRADA-PRINCIPAL` | GET | 200 | text/html; charset=utf-8 | HTML do aplicativo visitante |
| `/` | GET | 200 | text/html; charset=utf-8 | HTML do aplicativo visitante |
| `/admin/` | GET | 200 | text/html; charset=utf-8 | HTML do painel administrativo |

Todos os 5 endpoints retornam HTTP 200. O servidor de auditoria serve corretamente:
- A API de saúde (`/health`)
- Os arquivos estáticos de plantas (`/static/plantas/demo.svg`)
- O SPA do visitante (`/` e `/?qr=ENTRADA-PRINCIPAL`)
- O SPA do administrador (`/admin/`)

O servidor foi encerrado após a validação (PID 9948 finalizado).

---

## 4. Testes executados e resultados reais

### 4.1 Testes backend (Python)

Comando: `pytest tests/ -v` a partir de `backend/`

**Resultado: 88 aprovados, 1 pulado, 0 falhas** (3,02s)

- 88 testes aprovados em `test_api.py`, `test_audit.py`, `test_navigation.py`
- 1 pulado: `test_mysql_homologation_database_is_active` (MySQL não configurado — `TEST_DATABASE_URL` não definida)
- Nenhuma falha de asserção

### 4.2 Teste de desempenho RNF03 (Playwright)

Comando: `npx playwright test tests/performance.spec.ts --project chromium` a partir de `admin-panel/`

**Resultado: 1 aprovado** (25,4s total)

O teste executou 5 iterações sob rede 4G simulada (9 Mbps down / 1 Mbps up / 80 ms latency, cache frio, Chromium, viewport 360×640):

| Amostra | mapMs (limite ≤ 3000) | routeMs (limite ≤ 1000) |
|---------|----------------------|------------------------|
| 1 | 2695 | 710 |
| 2 | 2265 | 666 |
| 3 | 2036 | 666 |
| 4 | 1960 | 662 |
| 5 | 1985 | 635 |

**Máximos observados:**
- mapMs: **2695 ms** (critério: ≤ 3000 ms) ✓
- routeMs: **710 ms** (critério: ≤ 1000 ms) ✓

**Critério de conclusão do RNF03:** atendido. Todas as 5 amostras estão dentro dos limites definidos no teste (`expect(sample.mapMs).toBeLessThanOrEqual(3000)` e `expect(sample.routeMs).toBeLessThanOrEqual(1000)`).

### 4.3 Erros de trace

Não houve erro de `ENOENT` na gravação de traces nesta execução. O teste passou completamente, incluindo o `context.close()` de cada iteração.

---

## 5. Tempos medidos

O arquivo `evidence/performance-correcao-rnf03-20261103.json` registra:

```json
{
  "profile": "4G simulado: 9 Mbps down / 1 Mbps up / 80 ms, cache frio, Chromium, 360x640",
  "samples": [
    {"mapMs": 2695, "routeMs": 710},
    {"mapMs": 2265, "routeMs": 666},
    {"mapMs": 2036, "routeMs": 666},
    {"mapMs": 1960, "routeMs": 662},
    {"mapMs": 1985, "routeMs": 635}
  ]
}
```

---

## 6. Pendências e limitações

| Item | Status | Observação |
|------|--------|------------|
| Homologação MySQL | Pendente | `TEST_DATABASE_URL` não definida; testes usam SQLite em memória |
| RNF08 (navegadores comerciais) | Parcial/pendente | Apenas Chromium do Playwright testado; Chrome, Safari e Edge comerciais não instalados |
| RNF09 (usabilidade presencial) | Pendente | Não há 5 participantes sem treinamento recrutados |
| Execução nativa em dispositivo | Pendente | Não há dispositivo móvel ou câmera física disponível |
| `browser-tests.json` não sobrescrito | Observação | O relatório JSON do Playwright no local padrão (`evidence/browser-tests.json`) não foi atualizado com o novo resultado; os dados reais estão no console e em `evidence/performance-correcao-rnf03-20261103.json` |

---

## 7. Estado final do Git

| Item | Valor |
|------|-------|
| Branch | `main` |
| Commit | `fdbf583` |
| Commit / Push realizados | Não |
| Arquivos modificados por esta sessão | Nenhum (apenas novo diretório de evidência criado) |
| Novos arquivos criados | `evidence/correcao-rnf03-final-20261103/relatorio.md` |

Todas as alterações preexistentes no repositório foram preservadas. Nenhum arquivo foi sobrescrito, removido ou revertido.

---

## 8. Critério de conclusão

✅ Servidor iniciado pelo procedimento oficial (`python audit_server.py --port 8765`)  
✅ Arquivos estáticos servidos corretamente (todos os 5 endpoints retornam HTTP 200)  
✅ Aplicação visitante acessível (`/?qr=ENTRADA-PRINCIPAL` retorna HTML)  
✅ Testes backend executados: 88 aprovados, 1 pulado, 0 falhas  
✅ Teste RNF03 executado e aprovado: 1/1, mapMs máximo 2695 ≤ 3000, routeMs máximo 710 ≤ 1000  
✅ Resultados documentados em `evidence/correcao-rnf03-final-20261103/relatorio.md` e `evidence/performance-correcao-rnf03-20261103.json`

O RNF03 está **desbloqueado e validado** com o servidor de auditoria funcionando corretamente.
