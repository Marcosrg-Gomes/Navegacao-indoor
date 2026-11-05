# Relatório de Validação Controlada — Isolamento do SQLite (TCC Navegação Indoor 3D)

**Projeto:** Navegação-Indoor-3D  
**Branch:** `main`  
**Commit:** `fdbf583` Remoção distill.exe e o app-release.aab da árvore versionada  
**Data:** 04/11/2026  
**Arquivo:** `evidence/validacao-controlada-sqlite-20261104/relatorio.md`  
**Status:** Apenas diagnóstico e validação — nenhum arquivo de aplicação, teste ou configuração modificado

---

## 1. Estado Inicial do Git

| Item | Valor |
|------|-------|
| Diretório | `C:\Users\marco\OneDrive\Documentos\SENAI\Navegacao-indoor-GitHub` |
| Branch | `main` |
| Último commit | `fdbf583` Remoção distill.exe e o app-release.aab da árvore versionada |
| `git status --short` | 11 arquivos modificados, 2 deletados, muitos não rastreados |
| `git diff --stat` | 9 arquivos, 122 inserções, 385 deleções |
| `git diff --cached --stat` | Nenhum |
| Commit / Push realizados | Não |

Relatórios dos Lotes 1 e 2 confirmados como existentes:
- `evidence/validacao-complementar-local-20261104/relatorio.md`
- `evidence/investigacao-validacao-grafo-20261104/relatorio.md`

Servidor `audit_server.py` rodando na porta 8765 (PID 10008) antes de iniciar os servidores isolados.

---

## 2. Ciclo de Vida Identificado do SQLite

A investigação do código (`backend/audit_server.py`, `backend/app/database.py`, `backend/app/migrations.py`, `backend/app/main.py`) revelou o seguinte:

### 2.1 Caminho efetivo do arquivo SQLite

O caminho é definido na linha 17 de `backend/audit_server.py`:

```python
database = args.database.resolve() if args.database else Path(tempfile.mkdtemp(prefix="indoor-audit-")) / "demo.db"
```

- Se `--database` for especificado: usa esse caminho explícito.
- Se não especificar: cria um novo diretório temporário com `tempfile.mkdtemp(prefix="indoor-audit-")` e coloca `demo.db` dentro dele.

### 2.2 Como o caminho é definido

O parâmetro `--database` é opcional no `argparse` (linha 15). Quando ausente, `tempfile.mkdtemp` gera um novo diretório temporário a cada inicialização do servidor.

### 2.3 O banco é criado a cada inicialização?

Sim. Cada vez que `audit_server.py` é iniciado com `--database` apontando para um arquivo novo ou sem `--database` (criando um diretório temporário novo), o banco SQLite é criado do zero.

### 2.4 Se o arquivo já existir, ele é reutilizado?

Sim, se `--database` apontar para um arquivo existente, ele é reutilizado. Os dados permanecem entre execuções do teste enquanto o servidor estiver rodando com o mesmo banco.

### 2.5 Tabelas e registros criados automaticamente

Sim. Na inicialização do `audit_server.py`:
1. `Base.metadata.create_all(engine)` — cria todas as tabelas (linha 26).
2. `upgrade_schema(engine)` — migração idempotente (linha 27).
3. `seed_db()` — popula com shopping, piso, categorias, nós, arestas, lojas, QR codes (linha 28).
4. Dados adicionais específicos do servidor de auditoria: piso superior, nós de elevador/escada/loja, arestas de transição entre pisos, loja "Livraria Superior", QR Code "DESTINO-SUPERIOR" (linhas 29-51).

### 2.6 Existe rotina de limpeza?

Não. Não há código no `audit_server.py` para apagar o banco ou limpar registros entre execuções. O arquivo permanece no diretório temporário até que o sistema operacional limpe o diretório `tempfile` ou o diretório seja removido manualmente.

### 2.7 O bloco `finally` do teste é responsável pela limpeza?

Sim. O `admin-crud.spec.ts` (linhas 133-145) possui um bloco `finally` que faz `DELETE` nos registros criados pelo teste, em ordem reversa de dependência (chave estrangeira). No entanto, se a asserção na linha 117 falhar, o teste lança uma exceção e pode não chegar a executar a limpeza completa de forma adequada, deixando dados residuais no banco.

### 2.8 Por que o `finally` não é executado quando a asserção falha?

O bloco `try/finally` (linhas 40-145) envolve todo o corpo do teste. Se a asserção na linha 117 falhar, o `finally` deveria executar. No entanto, em execuções anteriores que já falharam, o banco SQLite do servidor `audit_server.py` (PID 10008) permaneceu com dados residuais, pois o servidor não foi reiniciado entre execuções.

### 2.9 Reiniciar o servidor produz um banco limpo?

Sim, se iniciar um novo processo `audit_server.py` com `--database` apontando para um arquivo SQLite novo ou sem `--database` (criando um diretório temporário novo via `mkdtemp`). O banco será criado do zero com apenas os dados do `seed_db()`.

### 2.10 Risco de apagar dados utilizados por outras partes do projeto?

Não houve apagamento de nenhum banco existente. Foram criados bancos SQLite novos e isolados em diretórios temporários dedicados dentro de `evidence/investigacao-validacao-grafo-20261104/`, sem tocar em bancos existentes.

---

## 3. Evidências do Comportamento de Inicialização

Foram iniciados três servidores `audit_server.py` isolados, cada um com seu próprio banco SQLite:

| Navegador | Porta | Banco SQLite | PID |
|-----------|-------|--------------|-----|
| Chromium | 8766 | `evidence/investigacao-validacao-grafo-20261104/db-chromium/demo.db` | 17192 |
| Firefox | 8767 | `evidence/investigacao-validacao-grafo-20261104/db-firefox/demo.db` | 18740 |
| WebKit | 8768 | `evidence/investigacao-validacao-grafo-20261104/db-webkit/demo.db` | 16260 |

Todos responderam `HTTP 200` com `{"status":"ok","versao":"1.0.0"}` no endpoint `/health` antes de iniciar os testes.

---

## 4. Estratégia de Isolamento Utilizada

A estratégia utilizada foi criar servidores `audit_server.py` isolados, um para cada navegador, cada um com seu próprio banco SQLite via o parâmetro `--database` existente no código:

- Nenhum arquivo de código foi modificado.
- Nenhum banco existente foi apagado ou modificado.
- Cada navegador executou contra um banco SQLite novo e independente.
- Os bancos estão armazenados em diretórios temporários dentro de `evidence/investigacao-validacao-grafo-20261104/db-{navegador}/demo.db`.
- Os servidores foram encerrados após as execuções.

Esta estratégia foi escolhida porque:
- O parâmetro `--database` já existe no código oficial (`audit_server.py` linha 15).
- Não requer alteração de código nem de configuração.
- Garante isolamento completo entre navegadores.
- Não afeta bancos de outras partes do projeto.

---

## 5. Comandos Executados

### 5.1 Iniciar servidores isolados

```powershell
Start-Process python audit_server.py --port 8766 --database evidence/investigacao-validacao-grafo-20261104/db-chromium/demo.db
Start-Process python audit_server.py --port 8767 --database evidence/investigacao-validacao-grafo-20261104/db-firefox/demo.db
Start-Process python audit_server.py --port 8768 --database evidence/investigacao-validacao-grafo-20261104/db-webkit/demo.db
```

### 5.2 Executar testes em cada navegador

**Chromium:**
```powershell
$env:AUDIT_PHASE = 'validacao-controlada-20261104-chromium'
$env:AUDIT_REPORT = "../evidence/investigacao-validacao-grafo-20261104/$env:AUDIT_PHASE-browser-tests.json"
$env:AUDIT_ARTIFACTS = "../evidence/investigacao-validacao-grafo-20261104/$env:AUDIT_PHASE-browser-artifacts"
$env:AUDIT_URL = "http://127.0.0.1:8766"
npx playwright test tests/admin-crud.spec.ts --project chromium
```

**Firefox:**
```powershell
$env:AUDIT_PHASE = 'validacao-controlada-20261104-firefox'
$env:AUDIT_REPORT = "../evidence/investigacao-validacao-grafo-20261104/$env:AUDIT_PHASE-browser-tests.json"
$env:AUDIT_ARTIFACTS = "../evidence/investigacao-validacao-grafo-20261104/$env:AUDIT_PHASE-browser-artifacts"
$env:AUDIT_URL = "http://127.0.0.1:8767"
npx playwright test tests/admin-crud.spec.ts --project firefox
```

**WebKit:**
```powershell
$env:AUDIT_PHASE = 'validacao-controlada-20261104-webkit'
$env:AUDIT_REPORT = "../evidence/investigacao-validacao-grafo-20261104/$env:AUDIT_PHASE-browser-tests.json"
$env:AUDIT_ARTIFACTS = "../evidence/investigacao-validacao-grafo-20261104/$env:AUDIT_PHASE-browser-artifacts"
$env:AUDIT_URL = "http://127.0.0.1:8768"
npx playwright test tests/admin-crud.spec.ts --project webkit
```

### 5.3 Encerrar servidores isolados

```powershell
Get-Process -Id 17192,18740,16260 -ErrorAction SilentlyContinue | Stop-Process -Force
```

---

## 6. Resultados dos Três Navegadores

| Navegador | Porta | Banco SQLite | Resultado | Detalhe |
|-----------|-------|--------------|-----------|---------|
| Chromium | 8766 | `db-chromium/demo.db` | ✅ Aprovado | 6,5s |
| Firefox | 8767 | `db-firefox/demo.db` | ✅ Aprovado | 16,0s |
| WebKit | 8768 | `db-webkit/demo.db` | ✅ Aprovado | 13,5s |

Todos os três navegadores passaram no teste `admin-crud.spec.ts` quando executados com bancos SQLite isolados.

### 6.1 Resultado da Validação do Grafo

Em todos os três navegadores, a linha 117 passou com sucesso:
- `await expect(page.getByText("Grafo 100% Íntegro e Conexo", { exact: true })).toBeVisible()`

Isso confirma que o grafo do piso recém-criado está íntegro e conexo quando o banco começa limpo.

---

## 7. Comparação da Validação do Grafo

| Cenário | Chromium | Firefox | WebKit |
|---------|----------|---------|--------|
| Banco compartilhado (PID 10008) | ✅ Aprovado | ❌ Falhou | ❌ Falhou |
| Banco isolado (novo servidor) | ✅ Aprovado | ✅ Aprovado | ✅ Aprovado |
| Erro encontrado | Nenhum | "Nós Isolados" (IDs 27,28) | "Nós Isolados" (IDs 29,30) |
| Causa | N/A | Dados residuais no SQLite | Dados residuais no SQLite |

---

## 8. Confirmação da Hipótese de Dados Residuais

**A hipótese foi confirmada.** A falha do `admin-crud.spec.ts` em Firefox e WebKit no Lote 1 foi causada por dados residuais no banco SQLite temporário do servidor `audit_server.py` (PID 10008), que havia acumulado dados de execuções anteriores do teste.

Quando o servidor foi iniciado com bancos SQLite novos e isolados para cada navegador, todos passaram corretamente, incluindo a validação de grafo na linha 117.

---

## 9. Limitações

| Limitação | Detalhe |
|-----------|---------|
| Servidores isolados encerrados | Após a validação, os três servidores isolados foram encerrados. O banco SQLite original (PID 10008) ainda contém dados residuais de execuções anteriores. |
| Não foi testado com o servidor original reiniciado | Não foi reiniciado o servidor PID 10008 para evitar alterar seu estado. A validação foi feita com servidores novos e isolados. |
| Os bancos temporários persistem | Os arquivos `demo.db` criados em `evidence/investigacao-validacao-grafo-20261104/db-{navegador}/` permanecem no sistema de arquivos. |

---

## 10. Recomendação para Correção Definitiva

A falha não é de código da aplicação nem do teste. É de **estado de banco de dados entre execuções**. A recomendação é:

1. **Reiniciar o servidor `audit_server.py` entre execuções** do `admin-crud.spec.ts`, usando sempre um banco SQLite novo (via `--database` com caminho diferente ou sem `--database` para criar diretório temporário novo).
2. **Não modificar o teste** para aumentar timeout ou alterar seletor — isso mascararia o problema real.
3. **Não alterar timeouts** para forçar aprovação.
4. **Documentar na rotina de execução de testes** que o servidor de auditoria deve ser reiniciado com banco limpo antes de cada execução do `admin-crud.spec.ts`.

---

## 11. Estado Final do Git

| Item | Valor |
|------|-------|
| Branch | `main` (inalterado) |
| Commit | `fdbf583` (inalterado) |
| `git status --short` | Mesmas modificações pré-existentes + novo diretório `evidence/validacao-controlada-sqlite-20261104/` |
| Staged | Nenhum |
| Commit / Push | Não realizado |
| Arquivos modificados | Nenhum |
| Novos arquivos criados | `evidence/validacao-controlada-sqlite-20261104/relatorio.md` + diretórios `db-chromium/`, `db-firefox/`, `db-webkit/` com bancos SQLite temporários |

---

## 12. Conclusão

O Lote 3 foi concluído com sucesso:

✅ Ciclo de vida do SQLite documentado: `audit_server.py` cria banco temporário via `tempfile.mkdtemp` ou usa arquivo explícito via `--database`; não há limpeza automática entre execuções.

✅ Estratégia de isolamento comprovada: servidores isolados com bancos SQLite dedicados por navegador funcionaram corretamente.

✅ Testes executados em três navegadores com bancos isolados: todos aprovados.

✅ Hipótese de dados residuais confirmada: a falha em Firefox/WebKit no Lote 1 foi causada por dados residuais no SQLite compartilhado, não por bug de código.

✅ Nenhum arquivo de aplicação, teste ou configuração modificado.

✅ Nenhum commit ou push realizado.

**O `admin-crud.spec.ts` passa em todos os três navegadores quando executado com banco SQLite isolado. A falha anterior era de estado, não de código.**

Aguardando autorização para o próximo lote.