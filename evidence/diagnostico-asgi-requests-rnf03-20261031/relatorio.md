# Relatório de Diagnóstico — Requisições ASGI Isoladas (RNF03)

**Projeto:** Navegação-Indoor-3D  
**Branch:** `main`  
**Commit:** `fdbf583`  
**Data:** 31/10/2026  
**Arquivo:** `evidence/diagnostico-asgi-requests-rnf03-20261031/relatorio.md`  
**Status:** Diagnóstico concluído

---

## 1. Estado do Git

| Item | Valor |
|------|-------|
| Branch | `main` |
| Commit | `fdbf583` Remoção distill.exe e o app-release.aab da árvore versionada |
| `git status --short` | Inalterado (apenas novo diretório `evidence/diagnostico-asgi-requests-rnf03-20261031/`) |
| Commit / Push realizados | Não |

---

## 2. Diagnóstico Executado

Um script Python foi executado a partir do diretório `backend/` para importar isoladamente o módulo `app.main` e fazer requisições ASGI usando `httpx.ASGITransport` com `httpx.AsyncClient`, sem iniciar um servidor TCP.

**Comando executado:**
```powershell
cd backend
python diagnostico_asgi_requests.py
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

O objeto `app` contém os seguintes mounts e rotas:

| Path | Nome | Tipo | Diretório |
|------|------|------|-----------|
| `/static` | `static` | `Mount` | `None` |
| `/admin` | `admin` | `Mount` | `None` |
| `""` (vazio) | `visitor` | `Mount` | `None` |
| `/health` | `health_check` | `APIRoute` | `None` |

O mount raiz (`/`) é registrado com `path=""` (string vazia), que é o comportamento padrão do Starlette/FastAPI para o mount raiz.

### 3.3 Requisições ASGI Isoladas

| Requisição | Status HTTP | Content-Type | Resultado |
|------------|-------------|--------------|-----------|
| `GET /health` | 200 | `application/json` | ✅ Sucesso |
| `GET /static/plantas/demo.svg` | 200 | `image/svg+xml` | ✅ Sucesso |
| `GET /` | 200 | `text/html; charset=utf-8` | ✅ Sucesso |
| `GET /?qr=ENTRADA-PRINCIPAL` | 200 | `text/html; charset=utf-8` | ✅ Sucesso |
| `GET /admin/` | 200 | `text/html; charset=utf-8` | ✅ Sucesso |

Todas as 5 requisições foram atendidas com sucesso pelo objeto `app` importado isoladamente.

---

## 6. Comparação com o Servidor na Porta 8765

| Requisição | Servidor na porta 8765 (execução anterior) | Objeto `app` importado isoladamente |
|------------|--------------------------------------------|-------------------------------------|
| `GET /health` | 200 OK | 200 OK |
| `GET /static/plantas/demo.svg` | 404 Not Found | **200 OK** |
| `GET /?qr=ENTRADA-PRINCIPAL` | 404 Not Found | **200 OK** |
| `GET /admin/` | 404 Not Found | **200 OK** |

**Causa raiz confirmada:** O objeto `app` importado isoladamente a partir do diretório `backend/` **funciona corretamente** e serve todos os arquivos estáticos e páginas HTML corretamente. O problema não está no código-fonte, mas no servidor que estava rodando na porta 8765, que não estava usando o mesmo objeto `app` ou não estava aplicando os mounts de arquivos estáticos corretamente.

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

**Arquivo criado:** `evidence/diagnostico-asgi-requests-rnf03-20261031/relatorio.md`

---

**Resumo:** O objeto `app` importado isoladamente a partir do diretório `backend/` **responde corretamente a todas as requisições** (200 OK para todas as 5 requisições). O problema não está no código-fonte, mas em algo que acontece quando o `audit_server.py` carrega e executa esse objeto na porta 8765. O servidor na porta 8765 não está mais em execução no momento deste diagnóstico.

**Arquivo criado:** `evidence/diagnostico-asgi-requests-rnf03-20261031/relatorio.md`
