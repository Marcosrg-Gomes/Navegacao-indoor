# Relatório de Diagnóstico — Servidor de Auditoria (RNF03)

**Projeto:** Navegação-Indoor-3D  
**Branch:** `main`  
**Commit:** `fdbf583`  
**Data:** 31/10/2026  
**Arquivo:** `evidence/diagnostico-servidor-rnf03-20261031/relatorio.md`  
**Status:** Diagnóstico concluído — correção não aplicada

---

## 1. Estado do Git

| Item | Valor |
|------|-------|
| Branch | `main` |
| Commit | `fdbf583` Remoção distill.exe e o app-release.aab da árvore versionada |
| `git status --short` | Inalterado (apenas alterações pré-existentes) |

---

## 2. Arquivos e Configurações Examinados

| Arquivo | Caminho | Conteúdo Relevante |
|---------|---------|-------------------|
| Servidor de auditoria | `backend/audit_server.py` | Inicia `uvicorn.run("app.main:app", host="0.0.0.0", port=args.port)` |
| App FastAPI | `backend/app/main.py` | Monta `/static`, `/admin`, `/` com `StaticFiles`/`SPAStaticFiles` |
| Componente SPA | `backend/app/static_spa.py` | `SPAStaticFiles` estende `StaticFiles` com fallback para `index.html` |
| Página visitante | `backend/app/static/visitor/index.html` | HTML da aplicação móvel (Expo Router) |
| Planta baixa | `backend/app/static/plantas/demo.svg` | Arquivo de imagem SVG da planta baixa |

---

## 3. Responsabilidade de Cada Rota

| Rota | Responsável | Arquivo | Linha |
|------|-------------|---------|-------|
| `GET /` | `SPAStaticFiles(directory=visitor_dist)` | `backend/app/main.py` | 68-71 |
| `GET /static/{path}` | `StaticFiles(directory=static_dir)` | `backend/app/main.py` | 56 |
| `GET /admin/{path}` | `SPAStaticFiles(directory=admin_dist)` | `backend/app/main.py` | 57 |
| `GET /api/...` | `public.router` + `admin.router` | `backend/app/main.py` | 42-43 |
| `GET /health` | Função `health_check` | `backend/app/main.py` | 59-64 |

---

## 4. Objeto ASGI Efetivamente Utilizado

O servidor na porta 8765 é iniciado por `audit_server.py` (linha 53):

```python
uvicorn.run("app.main:app", host="0.0.0.0", port=args.port)
```

O objeto ASGI é `app.main:app`, construído em `backend/app/main.py`:
- `app = FastAPI(...)` (linha 22)
- `app.add_middleware(CORSMiddleware, ...)` (linha 30-39)
- `app.include_router(public.router, prefix="/api", ...)` (linha 42)
- `app.include_router(admin.router, prefix="/api/admin", ...)` (linha 43)
- `app.mount("/static", StaticFiles(directory=static_dir), name="static")` (linha 56)
- `app.mount("/admin", SPAStaticFiles(directory=admin_dist), name="admin")` (linha 57)
- `app.mount("/", SPAStaticFiles(directory=visitor_dist, html=True), name="visitor")` (linha 69) — **condicional**
- `app.add_api_route("/", health_check, ...)` (linha 70) — **apenas se `index.html` não existir**

---

## 5. Causa Comprovada

### O que foi verificado

| Verificação | Resultado |
|-------------|-----------|
| `backend/app/static/plantas/demo.svg` existe? | **Sim** (1354 bytes) |
| `backend/app/static/visitor/index.html` existe? | **Sim** (1233 bytes) |
| `GET /health` retorna 200? | **Sim** |
| `GET /static/plantas/demo.svg` retorna 200? | **Não — 404** |
| `GET /?qr=ENTRADA-PRINCIPAL` retorna 200? | **Não — 404** |
| `GET /admin/` retorna 200? | **Não — 404** |

### Análise do código

O arquivo `backend/app/main.py` contém a lógica correta para montar arquivos estáticos:

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

O arquivo `backend/app/static/visitor/index.html` **existe** (1233 bytes), então a condição `os.path.isfile(...)` deve ser `True`, e o mount `/` deve estar ativo com `SPAStaticFiles`.

### Diagnóstico

O servidor `audit_server.py` executa `uvicorn.run("app.main:app", ...)`, que carrega o objeto `app` definido em `backend/app/main.py`. Esse objeto inclui os mounts de arquivos estáticos. No entanto, o servidor na porta 8765 **não está servindo arquivos estáticos corretamente**:

1. `/static/plantas/demo.svg` retorna 404, embora o arquivo exista em `backend/app/static/plantas/demo.svg`
2. `/?qr=ENTRADA-PRINCIPAL` retorna 404, embora `backend/app/static/visitor/index.html` exista e o montagem `/` com `html=True` deva servir o `index.html` para qualquer caminho não encontrado

**Causa provável:** O servidor na porta 8765 pode não estar usando o mesmo objeto `app` definido em `backend/app/main.py`, ou há um problema de ambiente (caminho de trabalho, módulo importado diferente, etc.) que impede os mounts de arquivos estáticos de funcionar corretamente.

### Hipóteses não confirmadas

| Hipótese | Status | Justificativa |
|----------|--------|---------------|
| O `audit_server.py` está rodando de um diretório diferente, fazendo `os.path.dirname(__file__)` retornar um caminho incorreto | Não comprovado | `os.path.dirname(__file__)` é baseado no caminho do arquivo, não do diretório de trabalho |
| O módulo `app.main` importado é diferente do arquivo `backend/app/main.py` | Não comprovado | Não há como verificar sem acesso ao processo em execução |
| O `SPAStaticFiles` ou `StaticFiles` estão com bug nessa versão | Não comprovado | Não há evidência direta |
| O servidor na porta 8765 não é o `audit_server.py` | Não comprovado | Não foi possível identificar o comando de inicialização exato |

---

## 6. Correção Mínima Recomendada (não aplicada)

A correção depende da causa raiz, que não pôde ser confirmada com evidência direta:

1. **Se o problema é o `audit_server.py` não montar os arquivos estáticos:** Verificar se o `uvicorn.run("app.main:app", ...)` está carregando o módulo correto e se os mounts estão ativos no objeto `app` resultante.

2. **Se o problema é o caminho do diretório:** Verificar se `os.path.dirname(__file__)` no `main.py` retorna o caminho esperado quando executado pelo `audit_server.py`.

3. **Se o problema é o `SPAStaticFiles`:** Verificar se a classe `SPAStaticFiles` está funcionando corretamente para o mount `/` com `html=True`.

Nenhuma dessas correções foi aplicada, pois não há evidência suficiente para identificar a causa raiz com certeza.

---

## 7. Comandos e Evidências

| Comando | Resultado |
|---------|-----------|
| `curl.exe -s -m 5 "http://127.0.0.1:8765/health"` | `{"status":"ok","versao":"1.0.0"}` (200 OK) |
| `curl.exe -s -m 5 -I "http://127.0.0.1:8765/static/plantas/demo.svg"` | `HTTP/1.1 404 Not Found` |
| `curl.exe -s -m 5 "http://127.0.0.1:8765/?qr=ENTRADA-PRINCIPAL"` | `{"detail":"Not Found"}` (404) |
| `dir backend\app\static\plantas\demo.svg` | Arquivo existe (1354 bytes) |
| `dir backend\app\static\visitor\index.html` | Arquivo existe (1233 bytes) |

---

## 8. Comparação do Git Antes e Depois

| Item | Antes | Depois |
|------|-------|--------|
| Branch | `main` | `main` (inalterado) |
| Commit | `fdbf583` | `fdbf583` (inalterado) |
| Alterações | Nenhuma | Nenhuma |

---

## 9. Conclusão

O servidor de auditoria na porta 8765 **não está servindo arquivos estáticos corretamente**, apesar do código em `backend/app/main.py` conter os mounts adequados. O teste de performance falha porque o navegador não consegue carregar o mapa SVG (`/static/plantas/demo.svg`) nem o HTML do visitante (`/?qr=ENTRADA-PRINCIPAL`).

**Causa raiz não confirmada:** Não foi possível determinar por que o servidor na porta 8765 não está aplicando os mounts de arquivos estáticos definidos em `backend/app/main.py`. É necessário investigar o objeto `app` efetivamente carregado pelo `audit_server.py` ou verificar se há diferença entre o código-fonte e o servidor em execução.

**Recomendação:** Investigar o processo em execução na porta 8765 para confirmar qual objeto ASGI está sendo servido, e verificar se os mounts de arquivos estáticos estão ativos nesse objeto.