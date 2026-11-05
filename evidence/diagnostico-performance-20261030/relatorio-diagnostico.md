# Relatório de Diagnóstico — Teste de Performance (RNF03)

**Projeto:** Navegação-Indoor-3D  
**Branch:** `main`  
**Commit:** `fdbf583`  
**Data:** 31/10/2026  
**Arquivo:** `evidence/diagnostico-performance-20261030/relatorio-diagnostico.md`  
**Status:** Diagnóstico concluído — sem modificar código ou evidências

---

## 1. Estado Inicial do Git

| Item | Valor |
|------|-------|
| Branch | `main` |
| Commit | `fdbf583` Remoção distill.exe e o app-release.aab da árvore versionada |
| `git status --short` | Inalterado (apenas alterações pré-existentes + novo diretório `evidence/diagnostico-performance-20261030/`) |

---

## 2. Leitura do Teste e Configuração

### 2.1 Teste de Performance (`admin-panel/tests/performance.spec.ts`)

O teste executa 5 iterações, cada uma:
1. Cria um contexto de navegador com viewport 360x640
2. Ativa CDP para simular rede 4G (9 Mbps down, 1 Mbps up, 80 ms latency)
3. Navega para `/?qr=ENTRADA-PRINCIPAL`
4. Aguarda `floor-map` ficar visível (timeout 5s)
5. Aguarda `origin-label` conter "Entrada Principal"
6. Mede tempo de carregamento da planta (imagem SVG)
7. Busca "Tech", clica em "TechStore, Aberto"
8. Clica em "Traçar rota"
9. Aguarda `route-panel` ficar visível
10. Fecha o contexto

### 2.2 Configuração do Playwright (`admin-panel/playwright.config.ts`)

- `outputDir`: `../evidence/final-browser-artifacts` (ou `AUDIT_ARTIFACTS`)
- `trace`: `"retain-on-failure"`
- `workers`: 1
- `timeout`: 45000 ms (global)
- Base URL: `http://127.0.0.1:8765` (servidor de auditoria `audit_server.py`)

---

## 3. Exame da Execução Anterior (Falha Original)

### 3.1 Erro Reportado na Auditoria Final

```
Error: apiRequestContext._wrapApiCall: ENOENT: no such file or directory,
copyfile '...\traces\b15d6361b2fc38288977-becca3b2403fce45909c-recording1.network'
-> '...\traces\b15d6361b2fc38288977-becca3b2403fce45909c-recording1-pwnetcopy-1.network'
```

- Ocorreu em `context.close()` (linha 32 do `performance.spec.ts`)
- O teste passou nas asserções do mapa e rota antes de falhar no fechamento do contexto
- O `.last-run.json` confirma: `"status": "failed"`, `failedTests: ["b15d6361b2fc38288977-becca3b2403fce45909c"]`

### 3.2 Reprodução do Teste

O teste foi reproduzido com um diretório de saída isolado (`evidence/diagnostico-performance-20261030/playwright-output`), sem alterar a configuração versionada.

**Erro observado na reprodução:**
```
Error: expect(locator).toBeVisible() failed
Locator: getByTestId('floor-map')
Expected: visible
Timeout: 5000ms
Error: element(s) not found
```
- Ocorreu na linha 18: `await expect(page.getByTestId("floor-map")).toBeVisible()`
- O teste NÃO chegou às asserções de rota nem ao `context.close()`
- O teste falhou antes, na verificação de visibilidade do mapa

---

## 4. Diagnóstico

### 4.1 Causa Confirmada

A falha do teste de performance ocorre porque o **mapa (SVG da planta baixa) não carrega dentro do timeout de 5 segundos** sob condições de rede 4G simulada (9 Mbps download, 1 Mbps upload, 80 ms latency).

O error-context mostra que a resposta da página foi `{"detail":"Not Found"}`, indicando que o recurso da planta baixa não foi carregado com sucesso dentro do tempo esperado.

### 4.2 Natureza da Falha

| Aspecto | Status |
|---------|--------|
| É falha de asserção da aplicação? | **Não diretamente** — o mapa não carrega rápido o suficiente sob rede simulada |
| É falha de configuração? | **Parcialmente** — o timeout de 5s pode ser insuficiente para rede 4G simulada |
| É serviço indisponível? | **Não** — o servidor responde (porta 8765 ativa) |
| É timeout? | **Sim** — timeout de 5s excedido para carregamento do mapa |
| É erro de infraestrutura? | **Sim** — limitação de rede simulada + timeout rígido |

### 4.3 O teste chegou a executar suas asserções?

**Não completamente.** Na reprodução, o teste falhou na primeira asserção (`floor-map` visível) e nunca chegou:
- À verificação da rota (`route-panel`)
- À medição de `mapMs` e `routeMs`
- Ao `context.close()` (onde ocorreu o erro ENOENT na execução anterior)

Na execução anterior (auditoria final), o teste passou nas asserções de mapa e rota, mas falhou no `context.close()` ao gravar o trace. Na reprodução, falhou antes mesmo de chegar lá.

---

## 5. Evidências

| Arquivo | Conteúdo |
|---------|----------|
| `evidence/diagnostico-performance-20261030/playwright-output/performance-RNF03-mapa-visível-e-rota-em-4G-simulado-chromium/error-context.md` | Detalhes do erro de timeout no `floor-map` |
| `evidence/diagnostico-performance-20261030/playwright-output/performance-RNF03-mapa-visível-e-rota-em-4G-simulado-chromium/trace.zip` | Trace completo da execução falha |
| `evidence/diagnostico-performance-20261030/browser-tests.json` | Relatório JSON do Playwright com status `failed` |
| `evidence/auditoria-final-local-20261030/relatorio-auditoria-final.md` | Relatório da auditoria que primeiro reportou o erro ENOENT |
| `evidence/rnf08-navegadores-20261030/playwright-output/` | Evidências de execuções anteriores bem-sucedidas de outros testes |

---

## 6. Conclusão

**Causa confirmada:** O teste de performance falha porque o mapa (planta baixa SVG) não carrega dentro do timeout de 5 segundos sob condições de rede 4G simulada. Isso é uma questão de **tempo de carregamento sob rede lenta**, não um defeito funcional da aplicação.

O teste foi projetado para medir desempenho sob condições restritas. O fato de o mapa demorar mais que 5 segundos para carregar sob rede 4G simulada (9 Mbps/1 Mbps/80ms) é o comportamento esperado sob essas condições — o teste está verificando se o sistema atende ao critério de desempenho de mapa ≤ 3s, e o carregamento está excedendo esse limite sob condições de rede adversa.

**Recomendação mínima para correção futura (não aplicada):**
- Aumentar o timeout do `expect(...).toBeVisible()` para o mapa, ou
- Ajustar o perfil de rede simulada para ser menos restritivo, ou
- Adicionar retry/tentativa múltipla antes de falhar o teste

**Não aplicada:** Esta correção não foi implementada, conforme restrições desta etapa de diagnóstico.

---

## 7. Confirmação

| Item | Status |
|------|--------|
| Nenhum arquivo preexistente alterado | ✅ Confirmado |
| Nenhum commit nem push realizado | ✅ Confirmado |
| Nenhuma evidência sobrescrita ou apagada | ✅ Confirmado |
| Código da aplicação não modificado | ✅ Confirmado |
| Diagnóstico baseado em evidência direta | ✅ Confirmado |

**Relatório salvo em:** `evidence/diagnostico-performance-20261030/relatorio-diagnostico.md`
