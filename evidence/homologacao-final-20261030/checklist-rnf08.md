# Lista de Verificação — RNF08: Matriz de Navegadores

**Projeto:** Navegação-Indoor-3D (TCC)  
**Requisito:** RNF08 — O sistema deve funcionar nos navegadores modernos mais utilizados.  
**Critério (especificação):** Chrome, Safari, Firefox e Edge — últimas 2 versões.  
**Branch:** `main`  
**Commit:** `fdbf583`  
**Data:** 30/10/2026  
**Arquivo:** `evidence/homologacao-final-20261030/checklist-rnf08.md`  
**Status:** Preparatório — não executa validação por si só

---

## 1. Contexto

Conforme `AUDITORIA_FASES_1-3.md` linha 33:
> RNF08: **PARCIAL / PENDENTE**, aplicável às Fases 1–3. Faltam as duas últimas versões dos quatro navegadores exigidos; WebKit não é Safari.

Conforme `DECISOES.md` item 18:
> Os cinco alvos Playwright executados no Windows são evidência parcial, não justificam N/A nem comprovam Safari.

---

## 2. Navegadores Efetivamente Testados (Evidência Existente)

| Navegador | Versão registrada | Plataforma | Testes aprovados | Evidência |
|-----------|-------------------|------------|------------------|-----------|
| Chromium (Playwright) | 153.0.8010.12 | win32 | admin-crud (11,8s); multiuser (7,9s) | `evidence/auditoria-diagnostico-20261030-v2/` |
| Firefox (Playwright) | 155.0 | win32 | admin-crud (41,6s) | `evidence/rnf08-navegadores-20261030/` |
| WebKit (Playwright) | 26.6 | win32 | admin-crud (13,0s) | `evidence/rnf08-navegadores-20261030/` |

**Limite:** Chromium ≠ Chrome (comercial); WebKit ≠ Safari (macOS/iOS). Nenhum navegador comercial foi instalado ou testado neste ambiente.

---

## 3. Checklist de Execução (Para o SENAI)

### 3.1 Navegadores a validar

| Navegador exigido | Versão 1 (mais recente) | Versão 2 (anterior) | Plataforma | Testado? | Evidência |
|-------------------|------------------------|---------------------|------------|----------|-----------|
| Chrome | | | Windows/macOS | ❌ Não | |
| Chrome | | | Windows/macOS | ❌ Não | |
| Safari | | | macOS/iOS | ❌ Não | |
| Safari | | | macOS/iOS | ❌ Não | |
| Firefox | | | Windows/macOS | ❌ Não* | |
| Firefox | | | Windows/macOS | ❌ Não* | |
| Edge | | | Windows | ❌ Não | |
| Edge | | | Windows | ❌ Não | |

\* Firefox do Playwright foi testado, mas não comprova as duas versões comerciais do Firefox.

### 3.2 Fluxos a validar em cada navegador

| Fluxo | Descrição | Teste E2E | Status |
|-------|-----------|-----------|--------|
| Navegação completa | QR → mapa → busca → rota → chegada | `navigation.spec.ts` | Pendente |
| Bloqueio/reativação de aresta | Ciclo bloquear → rota alternativa → reativar | `navigation.spec.ts` | Pendente |
| Scanner QR (simulado) | Leitura de QR via eventos simulados | `scanner.spec.ts` (Chromium apenas) | Pendente |
| Performance (4G simulado) | Mapa ≤ 3s, rota ≤ 1s | `performance.spec.ts` (Chromium apenas) | Pendente |
| Layout responsivo | Sem overflow em 360×640 e 414×896 | `navigation.spec.ts` | Pendente |
| CRUD admin | Cadastro/edição/remoção de registros | `admin-crud.spec.ts` | Pendente em navegadores comerciais |

### 3.3 Critérios de aprovação RNF08

| Critério | Como verificar | Status alvo |
|----------|---------------|-------------|
| Chrome (últimas 2 versões) | Executar fluxos E2E em cada versão | ✅ Ambos aprovados |
| Safari (últimas 2 versões) | Executar fluxos E2E em cada versão | ✅ Ambos aprovados |
| Firefox (últimas 2 versões) | Executar fluxos E2E em cada versão | ✅ Ambos aprovados |
| Edge (últimas 2 versões) | Executar fluxos E2E em cada versão | ✅ Ambos aprovados |
| Registro de versão/SO/data | Documentar para cada execução | ✅ Preenchido |
| Caminhos de câmera | Testar em plataformas compatíveis | ✅ Executado (se aplicável) |

**Não classificar a ausência de ambiente como N/A.** (conforme `AUDITORIA_FASES_1-3.md` linha 85)

---

## 4. Procedimento de Execução

1. Instalar as versões dos navegadores a serem testados (não instalar via este projeto; usar instalação nativa do sistema).
2. Verificar que o Playwright consegue enxergar os navegadores instalados:
   ```powershell
   npx playwright install --dry-run
   ```
3. Executar os testes E2E em cada navegador/versão:
   ```powershell
   cd admin-panel
   npx playwright test tests/ --project <nome-do-projeto>
   ```
4. Registrar navegador, SO, versão, data e resultado para cada execução.
5. Salvar evidências em `evidence/rnf08-validacao-<data>/` (novo diretório, não sobrescrever anterior).

---

## 5. Pendências

| Item | Descrição |
|------|-----------|
| Chrome comercial | Não instalado; não testado |
| Safari | Não disponível no Windows; não testado |
| Edge comercial | Não instalado; não testado |
| Firefox comercial (2 versões) | Apenas Firefox do Playwright testado |
| Registro de versão/SO/data | Não realizado para navegadores comerciais |
| Caminhos de câmera | Não testados em plataformas compatíveis |

---

## 6. Arquivos de Evidência Associados

| Arquivo | Conteúdo |
|---------|----------|
| `evidence/rnf08-navegadores-20261030/` | Testes Playwright em Firefox e WebKit (já executados) |
| `evidence/auditoria-diagnostico-20261030-v2/` | Teste CRUD em Chromium (já executado) |
| `evidence/homologacao-final-20261030/checklist-rnf08.md` | Este checklist (preparatório) |
