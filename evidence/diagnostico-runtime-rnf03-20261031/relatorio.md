# Relatório de Diagnóstico — Servidor de Auditoria (RNF03)

**Projeto:** Navegação-Indoor-3D  
**Branch:** `main`  
**Commit:** `fdbf583`  
**Data:** 31/10/2026  
**Arquivo:** `evidence/diagnostico-runtime-rnf03-20261031/relatorio.md`  
**Status:** Diagnóstico concluído — causa não confirmada com evidência direta

---

## 1. Estado do Git

| Item | Valor |
|------|-------|
| Branch | `main` |
| Commit | `fdbf583` Remoção distill.exe e o app-release.aab da árvore versionada |
| `git status --short` | Inalterado (apenas alterações pré-existentes + novo diretório `evidence/diagnostico-runtime-rnf03-20261031/`) |
| Commit / Push realizados | Não |

---

## 2. Processo na Porta 8765

| Item | Valor |
|------|-------|
| Porta | 8765 |
| Protocolo | TCP (LISTENING) |
| PID | 8260 |
| Nome do processo | python.exe |
| Caminho do executável | `C:\Users\marco\AppData\Local\Programs\Python\Python313\python.exe` |
| Empresa | Python Software Foundation |
| Horário de início | 31/10/2026 10:50:02 |
| Uso de memória | ~50 MB |

O processo na porta 8765 é um `python.exe` iniciado em 31/10/2026 às 10:50:02, consistente com o `audit_server.py` (que roda `uvicorn.run("app.main:app", ...)`).

Não foi possível obter a linha de comando completa do processo (ferramenta `wmic` não disponível no ambiente).

---

## 3. Arquivos Examinados

| Arquivo | Caminho | Conteúdo Relevante |
|---------|---------|-------------------|
| Servidor de auditoria | `backend/audit_server.py` | Inicia `uvicorn.run("app.main:app", host="0.0.0.0", port=args.port)` na linha 53 |
| App FastAPI | `backend/app/main.py` | Monta `/static`, `/admin`, `/` com `StaticFiles`/`SPAStaticFiles` nas linhas 56-71 |
| Componente SPA | `backend/app/static_spa.py` | `SPAStaticFiles` estende `StaticFiles` com fallback para `index.html` |
| Página visitante | `backend/app/static/visitor/index.html` | Existe (1233 bytes) |
| Planta baixa | `backend/app/static/plantas/demo.svg` | Existe (1354 bytes) |

---

## 4. Objeto ASGI Esperado vs. Observado

### Objeto ASGI Esperado (conforme `backend/app/main.py`)

O objeto `app` é construído com os seguintes mounts:

| Mount | Caminho no Código | Diretório Físico |
|-------|-------------------|-------------------|
| `/api` | `public.router` + `admin.router` | Rotas da API FastAPI |
| `/static` | `StaticFiles(directory=static_dir)` | `backend/app/static/` |
| `/admin` | `SPAStaticFiles(directory=admin_dist)` | `backend/app/static/admin/` |
| `/` | `SPAStaticFiles(directory=visitor_dist, html=True)` | `backend/app/static/visitor/` |
| `/health` | Função `health_check` | Retorna `{"status":"ok"}` |

O mount `/` com `html=True` significa que qualquer rota não encontrada deve retornar o `index.html` do visitor (SPA fallback).

### O que foi Observado na Execução

| Requisição | Resultado Esperado | Resultado Observado |
|------------|------------------|---------------------|
| `GET /health` | 200 OK | 200 OK `{"status":"ok","versao":"1.0.0"}` |
| `GET /static/plantas/demo.svg` | 200 OK (arquivo existe) | 404 Not Found |
| `GET /?qr=ENTRADA-PRINCIPAL` | 200 OK (SPA do visitor) | 404 Not Found |
| `GET /admin/` | 200 OK (SPA do admin) | 404 Not Found |

O servidor responde corretamente para `/health` (rota definida diretamente no objeto `app`), mas **não serve arquivos estáticos** nem o SPA do visitante, apesar de esses mounts estarem definidos no código-fonte.

---

## 5. Análise do Código

### `backend/app/main.py` — Trechos Relevantes

```python
static_dir = os.path.join(os.path.dirname(__file__), "static")
plantas_dir = os.path.join(static_dir, "plantas")
admin_dist = os.path.join(static_dir, "admin")

os.makedirs(plantas_dir, exist_ok=True)
os.makedirs(admin_dist, exist_ok=True)

app.mount("/static", StaticFiles(directory=static_dir), name="static")
app.mount("/admin", SPAStaticFiles(directory=admin_dist), name="admin")

# ...

visitor_dist = os.path.join(static_dir, "visitor")
if os.path.isfile(os.path.join(visitor_dist, "index.html")):
    app.mount("/", SPAStaticFiles(directory=visitor_dist, html=True), name="visitor")
else:
    app.add_api_route("/", health_check, methods=["GET"])
```

O arquivo `backend/app/static/visitor/index.html` **existe** (1233 bytes), então a condição `os.path.isfile(...)` deve ser `True`, e o mount `/` com `SPAStaticFiles` deve estar ativo.

### `backend/app/static_spa.py`

```python
class SPAStaticFiles(StaticFiles):
    async def get_response(self, path, scope):
        try:
            return await super().get_response(path, scope)
        except HTTPException as exc:
            if exc.status_code != 404 or Path(path).suffix or path.startswith(("api/", "static/")):
                raise
            return await super().get_response("index.html", scope)
```

Isso significa que rotas que não terminam com extensão de arquivo e não começam com `api/` ou `static/` devem retornar `index.html` (fallback SPA).

---

## 6. Causa Comprovada vs. Não Comprovada

### O que NÃO pôde ser confirmado

Não foi possível determinar **por que** o servidor na porta 8765 não está servindo arquivos estáticos, apesar do código em `backend/app/main.py` conter os mounts adequados. As seguintes hipóteses não puderam ser verificadas sem modificar o servidor em execução:

| Hipótese | Status | Justificativa |
|----------|--------|---------------|
| O objeto `app` carregado pelo `audit_server.py` é diferente do código-fonte em `backend/app/main.py` | Não comprovado | Não foi possível inspecionar o objeto `app` em execução |
| O `os.path.dirname(__file__)` no `main.py` retorna um caminho diferente quando executado pelo `audit_server.py` | Não comprovado | Não foi possível verificar o `sys.path` do processo em execução |
| O `SPAStaticFiles` ou `StaticFiles` não estão funcionando conforme esperado | Não comprovado | Não há evidência direta |
| O servidor na porta 8765 não é o `audit_server.py` | Não comprovado | O PID 8260 é um `python.exe`, consistente com `audit_server.py`, mas não foi possível confirmar o comando de inicialização |

---

## 8. Recomendação Mínima para a Próxima Etapa

Investigar diretamente o objeto `app` em execução na porta 8765, por exemplo:

1. Adicionar log de depuração no `audit_server.py` para imprimir `app.routes` e `app.router.routes` após a criação do objeto FastAPI
2. Verificar se `app.router.routes` contém as rotas de `StaticFiles` e `SPAStaticFiles` esperadas
3. Verificar se `os.path.dirname(__file__)` no `main.py` retorna o caminho esperado quando executado pelo `audit_server.py`

Essa investigação requer modificar temporariamente o `audit_server.py` ou adicionar logs de depuração, o que está fora do escopo desta etapa de diagnóstico somente-leitura.

---

## 8. Comparação do Git Antes e Depois

| Item | Antes | Depois |
|------|-------|--------|
| Branch | `main` | `main` (inalterado) |
| Commit | `fdbf583` | `fdbf583` (inalterado) |
| `git status --short` | Alterações pré-existentes | Mesmo conjunto + novo diretório `evidence/diagnostico-runtime-rnf03-20261031/` |

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

**Arquivo criado:** `evidence/diagnostico-runtime-rnf03-20261031/relatorio.md`

---

**Resumo:** O servidor na porta 8765 responde em `/health` mas não serve arquivos estáticos nem o SPA do visitante. A causa raiz não pôde ser confirmada com evidência direta, pois não foi possível inspecionar o objeto `app` em execução no processo Python na porta 8765.