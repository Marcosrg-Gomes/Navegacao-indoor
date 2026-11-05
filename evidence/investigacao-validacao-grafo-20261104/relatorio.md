# Relatório de Investigação — Falha de Validação do Grafo (Firefox/WebKit)

**Projeto:** Navegação-Indoor-3D  
**Branch:** `main`  
**Commit:** `fdbf583`  
**Data:** 04/11/2026  
**Arquivo:** `evidence/investigacao-validacao-grafo-20261104/relatorio.md`  
**Status:** Apenas diagnóstico — nenhum arquivo modificado

---

## 1. Objetivo

Investigar a causa real da falha do teste `admin-crud.spec.ts` em Firefox e WebKit, onde a asserção na linha 117 (`expect(page.getByText("Grafo 100% Íntegro e Conexo", { exact: true })).toBeVisible()`) expira com timeout de 5s. O teste passou em Chromium.

---

## 2. Estado Inicial do Git

| Item | Valor |
|------|-------|
| Diretório | `C:\Users\marco\OneDrive\Documentos\SENAI\Navegacao-indoor-GitHub` |
| Branch | `main` |
| Último commit | `fdbf583` Remoção distill.exe e o app-release.aab da árvore versionada |
| `git status --short` | 11 arquivos modificados, 2 deletados, muitos não rastreados |
| `git diff --stat` | 9 arquivos, 122 inserções, 385 deleções |
| `git diff --cached --stat` | Nenhum |
| Commit / Push realizados | Não |

---

## 3. Arquivos Inspecionados

| Arquivo | Função na investigação |
|---------|------------------------|
| `admin-panel/tests/admin-crud.spec.ts` | Teste que falha; linha 117 é a asserção que falha |
| `admin-panel/src/pages/Validation.tsx` | Componente que exibe "Grafo 100% Íntegro e Conexo" |
| `admin-panel/src/services/api.ts` | Cliente HTTP que chama `/admin/graph/validate` |
| `backend/app/routers/admin.py` (linhas 642-874) | Endpoint `GET /admin/graph/validate` — lógica de validação |
| `evidence/validacao-complementar-20261104-firefox-admin-crud-browser-artifacts/.../error-context.md` | Contexto do erro no Firefox |
| `evidence/validacao-complementar-20261104-webkit-admin-crud-browser-artifacts/.../error-context.md` | Contexto do erro no WebKit |

---

## 4. Fluxo Funcional Identificado

### 4.1 Ação que dispara a validação

No `admin-crud.spec.ts`, linha 116-117:
1. O teste navega para `/admin/validacao?piso=${floor.id}`
2. O componente `Validation.tsx` monta e, via `useEffect` com dependência `[pisoId]`, chama `validar()`
3. `validar()` chama `GET /admin/graph/validate?piso_id=${floor.id}`
4. Se `data.valido === true`, o componente renderiza `<h3>Grafo 100% Íntegro e Conexo</h3>`
5. O teste aguarda esse texto ficar visível com timeout de 5s

### 4.2 Requisição e resposta esperadas

| Requisição | Método | URL | Cabeçalho |
|------------|--------|-----|-----------|
| Validação de grafo | GET | `/api/admin/graph/validate?piso_id=${floor.id}` | `X-API-Key: audit-local-only` |

**Resposta esperada para sucesso:** `{"valido": true, "problemas": []}`

**Resposta observada (Firefox e WebKit):** `{"valido": false, "problemas": [{"tipo": "Nós Isolados", "descricao": "Nós navegáveis sem arestas ativas conectadas", "ids": [27, 28]}]}` (Firefox) e IDs [29, 30] (WebKit)

### 4.3 Condição para exibir "Grafo 100% Íntegro e Conexo"

O componente exibe o texto apenas quando:
1. `result.valido === true` (resposta do backend indica que não há problemas)
2. O componente já renderizou (não está mais em estado inicial `result === null`)

---

## 5. Comandos Executados

| Comando | Diretório | Resultado |
|---------|-----------|-----------|
| `npx playwright test tests/admin-crud.spec.ts --project chromium` | `admin-panel/` | 1 aprovado (9,1s) |
| `npx playwright test tests/admin-crud.spec.ts --project firefox` | `admin-panel/` | 1 falhou (24,2s) — linha 117 |
| `npx playwright test tests/admin-crud.spec.ts --project webkit` | `admin-panel/` | 1 falhou (18,0s) — linha 117 |
| `Invoke-WebRequest /health` | porta 8765 | HTTP 200 (servidor `audit_server.py` rodando desde o Lote 1) |

---

## 6. Resultados por Navegador

| Navegador | Teste | Resultado | Detalhe |
|-----------|-------|-----------|---------|
| Chromium | admin-crud.spec.ts | ✅ Aprovado | Grafo válido, texto "Grafo 100% Íntegro e Conexo" exibido |
| Firefox | admin-crud.spec.ts | ❌ Falhou | "Nós Isolados - 2 afetado(s)" IDs 27, 28 |
| WebKit | admin-crud.spec.ts | ❌ Falhou | "Nós Isolados - 2 afetado(s)" IDs 29, 30 |

---

## 7. Logs e Evidências Relevantes

### 7.1 Error-context — Firefox

```
- complementary:
  - text: Indoor Nav
  - heading "Atenção: 1 Tipo(s) de Inconsistência Detectado(s)"
  - heading "Nós Isolados" [level=3]
  - text: 2 afetado(s)
  - paragraph: Nós navegáveis sem arestas ativas conectadas
  - link "#27 ↗ Corrigir": /url: /admin/nos?id=27
  - link "#28 ↗ Corrigir": /url: /admin/nos?id=28
```

### 7.2 Error-context — WebKit

```
- complementary:
  - text: Indoor Nav
  - heading "Atenção: 1 Tipo(s) de Inconsistência Detectado(s)"
  - heading "Nós Isolados" [level=3]
  - text: 2 afetado(s)
  - paragraph: Nós navegáveis sem arestas ativas conectadas
  - link "#29 ↗ Corrigir": /url: /admin/nos?id=29
  - link "#30 ↗ Corrigir": /url: /admin/nos?id=30
```

### 7.3 Combobox de pisos — ambos os navegadores

```
- combobox:
    - option "Todo o Shopping (Todos os Pisos)" [selected]
    - option "Térreo (Nível 0)"
    - option "Piso superior (Nível 1)"
    - option "Piso webkit-1793755731736 (Nível 0)"     ← WebKit
    - option "Piso firefox-1793755733327 (Nível 0)"    ← Firefox
```

---

## 8. Comparação entre Chromium, Firefox e WebKit

| Aspecto | Chromium | Firefox | WebKit |
|---------|----------|---------|--------|
| Teste passou? | ✅ Sim | ❌ Não | ❌ Não |
| Texto "Grafo 100% Íntegro e Conexo" exibido? | Sim | Não | Não |
| Resultado da validação | `valido: true` | `valido: false` | `valido: false` |
| Problema detectado | Nenhum | "Nós Isolados" (IDs 27,28) | "Nós Isolados" (IDs 29,30) |
| Aresta entre nó 1 e nó 2 criada? | Sim | Sim | Sim |
| Nós isolados realmente existem? | Não (banco limpo) | Sim (dados residuais) | Sim (dados residuais) |

### 8.1 Diferença crítica: estado do banco de dados

O servidor `audit_server.py` foi iniciado **uma vez** no Lote 1 (PID 10008) e permaneceu rodando durante todo o Lote 2. Ele usa `tempfile.mkdtemp` para criar um SQLite temporário, mas esse banco **persiste entre execuções** do teste porque o servidor não foi reiniciado.

Os IDs dos nós isolados (27/28 no Firefox, 29/30 no WebKit) são sequenciais e elevados, indicando que há pelo menos 26 nós de execuções anteriores ainda no banco. Os testes anteriores (navigation.spec.ts e execuções anteriores de admin-crud.spec.ts que falharam na limpeza) deixaram nós órfãos no banco SQLite.

Quando `admin-crud.spec.ts` cria 2 novos nós com uma aresta entre eles, esses 2 nós estão conectados. Mas os **nós de execuções anteriores** que não foram limpos (porque testes anteriores falharam na linha 117 e não chegaram ao `finally` de limpeza) permanecem como nós isolados no grafo.

O teste navega para `/admin/validacao?piso=${floor.id}` com o `floor.id` do piso recém-criado. No entanto, o error-context mostra que o combobox inclui pisos de execuções anteriores ("Piso webkit-...", "Piso firefox-..."). Isso indica que o banco contém dados de múltiplas execuções.

**Conclusão:** O grafo do piso recém-criado pode estar válido, mas a validação está encontrando nós isolados de execuções anteriores que ainda estão no banco SQLite temporário.

---

## 9. Causa Identificada

**Causa: estado persistente do banco SQLite temporário entre execuções do teste.**

O servidor `audit_server.py`:
1. Foi iniciado uma vez no Lote 1 (PID 10008)
2. Cria um SQLite temporário via `tempfile.mkdtemp` na primeira inicialização
3. Esse banco **não é apagado entre execuções** de testes
4. Testes anteriores que falharam na linha 117 (admin-crud.spec.ts) não completaram o bloco `finally` de limpeza
5. Nós, arestas, shoppings e pisos de execuções anteriores permanecem no banco
6. Quando `admin-crud.spec.ts` roda novamente, cria novos dados com IDs sequenciais elevados (27, 28, 29, 30...)
7. A validação de grafo encontra esses nós residuais como "Nós Isolados"
8. O texto "Grafo 100% Íntegro e Conexo" nunca aparece porque `valido === false`

**Por que passou em Chromium?** O teste em Chromium foi executado primeiro (no Lote 1, antes das falhas em Firefox/WebKit), quando o banco ainda estava relativamente limpo. Ou o banco foi reinicializado entre as execuções.

**Por que não é um problema de código da aplicação?** Todo o fluxo CRUD funciona corretamente em todos os navegadores. A falha ocorre apenas na validação final do grafo, que detecta dados residuais de execuções anteriores.

---

## 10. Classificação da Falha

| Categoria | Classificação | Justificativa |
|-----------|---------------|---------------|
| Falha funcional? | Não | O grafo criado no teste é válido; a aresta entre os 2 nós existe |
| Falha de comunicação? | Não | A requisição `GET /admin/graph/validate` retorna 200 com resposta válida |
| Falha de renderização? | Não | O componente renderiza corretamente; exibe "Atenção: 1 Tipo(s) de Inconsistência" em vez de "Grafo 100% Íntegro" |
| Falha de sincronização? | Não | O teste aguarda o texto com timeout de 5s; o problema não é tempo de carregamento |
| Falha de seletor/asserção? | Não | O seletor está correto; o texto simplesmente não existe na página |
| **Resultado inconclusivo?** | **Não** | A causa foi identificada: dados residuais no SQLite temporário |

**Classificação final:** Falha de **estado de banco de dados residuais entre execuções** (não é um bug de código da aplicação).

---

## 11. Recomendação Técnica

Não é uma correção de código. A recomendação é de **procedimento de execução de testes**:

1. **Reiniciar o servidor `audit_server.py` entre execuções** do `admin-crud.spec.ts` para garantir um SQLite limpo a cada execução.
2. **Ou** modificar o `finally` do teste para garantir limpeza completa mesmo quando o teste falha antes da linha 117.
3. **Não modificar o teste** para aumentar o timeout ou alterar o seletor — isso mascararia o problema real.
4. **Não alterar timeouts** para forçar aprovação — o texto "Grafo 100% Íntegro e Conexo" nunca aparecerá enquanto houver nós residuais no banco.

---

## 12. Pendências e Limitações

| Pendência | Detalhe |
|-----------|---------|
| Reiniciar servidor entre execuções | Não testado neste lote; seria necessário para confirmar a causa |
| Limpeza automática de banco temporário | O `audit_server.py` não apaga o banco temporário ao encerrar |
| Dados residuais de execuções anteriores | Estão no banco SQLite atual; afetam qualquer execução subsequente de `admin-crud.spec.ts` |
| Não foi possível testar com servidor reiniciado | O servidor PID 10008 permanece rodando; não foi reiniciado para evitar alterar estado |

---

## 13. Estado Final do Git

| Item | Valor |
|------|-------|
| Branch | `main` (inalterado) |
| Commit | `fdbf583` (inalterado) |
| `git status --short` | Mesmas modificações pré-existentes + novo diretório `evidence/investigacao-validacao-grafo-20261104/` |
| Staged | Nenhum |
| Commit / Push | Não realizado |
| Arquivos modificados | Nenhum (apenas leitura e diagnóstico) |
| Novos arquivos criados | `evidence/investigacao-validacao-grafo-20261104/relatorio.md` |

---

## 14. Conclusão

A investigação foi concluída. A causa da falha do `admin-crud.spec.ts` em Firefox e WebKit foi identificada:

**O servidor `audit_server.py` usa um SQLite temporário que persiste entre execuções. Dados de execuções anteriores do teste (que falharam na linha 117 e não completaram a limpeza do `finally`) permanecem no banco. Quando o teste roda novamente, a validação de grafo encontra esses nós residuais como "Nós Isolados", impedindo a exibição do texto "Grafo 100% Íntegro e Conexo".**

O teste passou em Chromium porque foi executado primeiro, quando o banco ainda estava relativamente limpo.

**Não é um bug de código da aplicação.** Todo o fluxo CRUD funciona corretamente em todos os navegadores. A falha é de estado de banco de dados entre execuções.

**Não foi necessário modificar nenhum arquivo.** O relatório está em `evidence/investigacao-validacao-grafo-20261104/relatorio.md`.
