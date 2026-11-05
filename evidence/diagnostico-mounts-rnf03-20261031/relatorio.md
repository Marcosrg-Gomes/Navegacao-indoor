# Relatório de Diagnóstico — Mounts ASGI do Teste de Performance RNF03

**Projeto:** Navegação-Indoor-3D  
**Branch:** `main`  
**Commit:** `fdbf583`  
**Data:** 31/10/2026  
**Arquivo:** `evidence/diagnostico-mounts-rnf03-20261031/relatorio.md`  
**Status:** Diagnóstico concluído

---

## 1. Estado do Git

| Item | Valor |
|------|-------|
| Branch | `main` |
| Commit | `fdbf583` Remoção distill.exe e o app-release.aab da árvore versionada |
| `git status --short` | Inalterado (apenas novo diretório `evidence/diagnostico-mounts-rnf03-20261031/`) |
| Commit / Push realizados | Não |

---

## 2. Diagnóstico Executado

Um script Python foi executado a partir do diretório `backend/` para importar isoladamente o módulo `app.main` e inspecionar o objeto `app` (FastAPI) criado.

**Comando executado:**
```powershell
cd backend
python diagnostico_mounts.py
```

---

## 3. Resultados Observados

### 3.1 Importação do Módulo

| Item | Valor |
|------|-------|
| `app.main.__file__` | `C:\Users\marco\OneDrive\Documentos\SENAI\Navegacao-indoor-GitHub\backend\app\main.py` |
| `app.main.__name__` | `app.main` |
| Tipo do objeto `app` | `fastapi.FastAPI` |
| `app.title` | `API Navegação Indoor` |
| `app.version` | `1.0.0` |

A importação foi bem-sucedida. Não houve erros.

### 3.2 Mounts Registrados no Objeto `app`

O objeto `app` contém os seguintes mounts e rotas relevantes:

| Path | Nome | Tipo | Diretório |
|------|------|------|-----------|
| `/static` | `static` | `Mount` | `None` |
| `/admin` | `admin` | `Mount` | `None` |
| `""` (vazio) | `visitor` | `Mount` | `None` |
| `/health` | `health_check` | `APIRoute` | `None` |

**Nota:** O mount raiz (`/`) é registrado com `path=""` (string vazia), não `path="/"`. Isso é comportamento esperado do Starlette/FastAPI para o mount raiz.

### 3.3 Verificação de Arquivos Estáticos

| Arquivo | Caminho | Existe? |
|---------|---------|---------|
| `static_dir` | `...\backend\app\static` | Sim |
| `plantas_dir` | `...\backend\app\static\plantas` | Sim |
| `demo.svg` | `...\backend\app\static\plantas\demo.svg` | Sim |
| `visitor_dist` | `...\backend\app\static\visitor` | Sim |
| `visitor_index.html` | `...\backend\app\static\visitor\index.html` | Sim |
| `admin_dist` | `...\backend\app\static\admin` | Sim |

Todos os arquivos e diretórios esperados existem no sistema de arquivos.

---

## 4. Diferenças entre Mounts Esperados e Observados

| Mount Esperado | Encontrado no Objeto `app`? | Observação |
|---------------|----------------------------|------------|
| `/static` | ✅ Sim | Registrado como `Mount` com name="static" |
| `/admin` | ✅ Sim | Registrado como `Mount` com name="admin" |
| `/` | ✅ Sim | Registrado como `Mount` com name="visitor", path="" (vazio) |

Todos os três mounts esperados estão presentes no objeto `app` quando importado isoladamente a partir do diretório `backend`.

---

## 5. Diferenças entre o Código-Fonte e o Servidor em Execução

### Código-fonte (`backend/app/main.py`)

O código define os mounts corretamente:
- Linha 56: `app.mount("/static", StaticFiles(directory=static_dir), name="static")`
- Linha 57: `app.mount("/admin", SPAStaticFiles(directory=admin_dist), name="admin")`
- Linha 68-69: `app.mount("/", SPAStaticFiles(directory=visitor_dist, html=True), name="visitor")`

### Servidor em Execução (Porta 8765)

O servidor na porta 8765 (PID 8260, `python.exe`) **não está servindo arquivos estáticos**:
- `GET /static/plantas/demo.svg` → `404 Not Found`
- `GET /?qr=ENTRADA-PRINCIPAL` → `404 Not Found`
- `GET /admin/` → `404 Not Found`
- `GET /health` → `200 OK` (funciona)

---

## 6. Conclusão

### Causa Comprovada

**Não foi possível confirmar a causa raiz com evidência direta**, pois não foi possível inspecionar o objeto `app` em execução no processo `python.exe` (PID 8260) na porta 8765.

No entanto, o diagnóstico isolado confirma que:

1. **O código-fonte em `backend/app/main.py` está correto:** Todos os mounts de arquivos estáticos estão definidos adequadamente.
2. **O objeto `app` importado isoladamente contém todos os mounts esperados:** `/static`, `/admin`, e `/` estão todos presentes.
3. **Os arquivos físicos existem:** `demo.svg`, `index.html` e os diretórios estão todos presentes no sistema de arquivos.

Portanto, o problema **não está no código-fonte do `main.py`**, mas sim em algo que acontece entre a definição do objeto `app` no código e o servidor em execução na porta 8765.

### Possíveis Causas (Não Confirmadas)

| Hipótese | Status | Justificativa |
|----------|--------|---------------|
| O processo na porta 8765 não está usando o objeto `app` definido em `backend/app/main.py` | Não comprovado | Não foi possível inspecionar o objeto `app` em execução |
| O `audit_server.py` está carregando um módulo `app.main` diferente | Não comprovado | Não foi possível verificar o `sys.path` do processo em execução |
| O servidor foi iniciado antes de alguma alteração no código | Não comprovado | Não há evidência de quando o servidor foi iniciado vs. quando o código foi alterado |

---

## 8. Recomendação Mínima para a Próxima Etapa

Para identificar a causa raiz, é necessário:

1. **Verificar qual objeto `app` está sendo servido na porta 8765:** Adicionar log de depuração no `audit_server.py` para imprimir `app.router.routes` após a criação do objeto FastAPI, confirmando se os mounts de `/static`, `/admin` e `/` estão presentes.

2. **Verificar o `sys.path` do processo em execução:** Confirmar que o `app.main` sendo importado é o mesmo arquivo em `backend/app/main.py`.

3. **Verificar o diretório de trabalho do processo:** Confirmar que o `os.path.dirname(__file__)` no `main.py` retorna o caminho esperado quando executado pelo `audit_server.py`.

Essa investigação requer acesso ao processo em execução ou adição de log de depuração no `audit_server.py`, o que está fora do escopo desta etapa de diagnóstico somente-leitura.

---

## 8. Comparação do Git Antes e Depois

| Item | Antes | Depois |
|------|-------|--------|
| Branch | `main` | `main` (inalterado) |
| Commit | `fdbf583` | `fdbf583` (inalterado) |
| `git status --short` | Alterações pré-existentes | Mesmo conjunto + novo diretório `evidence/diagnostico-mounts-rnf03-20261031/` |

---

## 9. Confirmação de Restritivas

| Restrição | Cumprida? |
|-----------|-----------|
| Diagnóstico somente leitura | ✅ Sim |
| Não modificar arquivos de aplicação, testes, configuração ou evidências | ✅ Sim |
| Não reiniciar nem encerrar processos | ✅ Sim |
| Não instalar dependências | ✅ Sim |
| Não alterar variáveis de ambiente | ✅ Sim |
| Não executar comandos destrutivos do Git | ✅ Sim |
| Não fazer commit nem push | ✅ Sim |
| Não exibir segredos ou tokens | ✅ Sim |

**Arquivo criado:** `evidence/diagnostico-mounts-rnf03-20261031/relatorio.md`

---

**Resumo:** O objeto `app` importado isoladamente a partir do diretório `backend` **contém todos os mounts de arquivos estáticos corretamente configurados** (`/static`, `/admin`, `/`). O problema não está no código-fonte, mas em algo que acontece quando o `audit_server.py` carrega e executa esse objeto na porta 8765. A causa raiz não pôde ser confirmada sem inspecionar o objeto `app` em execução.
