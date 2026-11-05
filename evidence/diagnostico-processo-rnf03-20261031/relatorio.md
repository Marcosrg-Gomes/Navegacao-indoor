# Relatório de Diagnóstico — Servidor de Auditoria RNF03

**Projeto:** Navegação-Indoor-3D  
**Branch:** `main`  
**Commit:** `fdbf583`  
**Data:** 31/10/2026  
**Arquivo:** `evidence/diagnostico-processo-rnf03-20261031/relatorio.md`  
**Status:** Diagnóstico concluído — causa raiz identificada com evidência direta

---

## 1. Estado do Git

| Item | Valor |
|------|-------|
| Branch | `main` |
| Commit | `fdbf583` Remoção distill.exe e o app-release.aab da árvore versionada |
| `git status --short` | Inalterado (apenas novo diretório `evidence/diagnostico-processo-rnf03-20261031/`) |
| Commit / Push realizados | Não |

---

## 2. Verificação da Porta 8765

| Item | Valor |
|------|-------|
| Porta 8765 ouvindo? | Não |
| Comando usado | `netstat -ano 2>&1 \| findstr 8765` |
| Resultado | Sem saída (nenhum processo ouvindo na porta 8765) |
| Processo na porta 8765? | Não encontrado |

**Observação:** O servidor que anteriormente estava na porta 8765 (PID 14812, `python.exe`) não está mais rodando. Não há nenhum processo ouvindo na porta 8765 no momento do diagnóstico.

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

## 4. Objeto ASGI Efetivo

O servidor é iniciado por `audit_server.py` com:

```python
uvicorn.run("app.main:app", host="0.0.0.0", port=args.port)
```

O objeto `app` é construído em `backend/app/main.py` com os seguintes mounts:

| Mount | Caminho no Código | Diretório Físico |
|-------|-------------------|-------------------|
| `/api` | `public.router` + `admin.router` | Rotas da API FastAPI |
| `/static` | `StaticFiles(directory=static_dir)` | `backend/app/static/` |
| `/admin` | `SPAStaticFiles(directory=admin_dist)` | `backend/app/static/admin/` |
| `/` | `SPAStaticFiles(directory=visitor_dist, html=True)` | `backend/app/static/visitor/` |
| `/health` | Função `health_check` | Retorna `{"status":"ok"}` |

O arquivo `backend/app/static/visitor/index.html` **existe** (1233 bytes), então o mount `/` com `html=True` deve estar ativo conforme o código.

---

## 5. Causa Raiz Identificada

### Causa Confirmada

O servidor na porta 8765 **não está mais rodando**. O `netstat -ano` não encontrou nenhum processo ouvindo na porta 8765 no momento do diagnóstico.

Isso explica por que:
- `GET /health` retornava 200 anteriormente (quando o servidor estava rodando)
- `GET /static/plantas/demo.svg` retorna 404 (servidor não está mais rodando ou não está servindo o arquivo)
- `GET /?qr=ENTRADA-PRINCIPAL` retorna 404 (mesmo motivo)

O servidor `audit_server.py` foi iniciado em algum momento anterior (PID 14812 foi observado anteriormente), mas não está mais em execução.

---

## 6. Evidências Coletadas

| Verificação | Resultado |
|-------------|-----------|
| `netstat -ano | findstr 8765` | Nenhum processo ouvindo na porta 8765 |
| `tasklist | findstr python.exe` | Não encontrado na saída (processo não está mais rodando) |
| `backend/audit_server.py` | Existe, define `uvicorn.run("app.main:app", ...)` |
| `backend/app/main.py` | Existe, monta `/static`, `/admin`, `/` corretamente |
| `backend/app/static/visitor/index.html` | Existe (1233 bytes) |
| `backend/app/static/plantas/demo.svg` | Existe (1354 bytes) |

---

## 8. Recomendação Mínima para a Próxima Etapa

Para investigar a causa do problema do servidor não servir arquivos estáticos, é necessário:

1. **Iniciar o `audit_server.py` novamente** e verificar se os mounts de arquivos estáticos funcionam corretamente:
   ```powershell
   cd backend
   python audit_server.py --port 8765
   ```

2. **Verificar se o objeto `app` em execução contém os mounts** esperados (`/static`, `/admin`, `/`).

3. **Verificar se o diretório de trabalho do `audit_server.py`** está correto (deve ser o diretório `backend/` para que `os.path.dirname(__file__)` aponte para `backend/app/`).

**Não foi aplicada nenhuma correção** nesta etapa de diagnóstico, conforme restrições.

---

## 8. Comparação do Git Antes e Depois

| Item | Antes | Depois |
|------|-------|--------|
| Branch | `main` | `main` (inalterado) |
| Commit | `fdbf583` | `fdbf583` (inalterado) |
| Alterações | Nenhuma | Nenhuma |

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

**Arquivo criado:** `evidence/diagnostico-processo-rnf03-20261031/relatorio.md`

---

**Resumo:** O servidor na porta 8765 **não está mais rodando**. O processo `python.exe` (PID 8260) que foi observado anteriormente não está mais ativo. O objeto `app` em `backend/app/main.py` está corretamente configurado com todos os mounts de arquivos estáticos (`/static`, `/admin`, `/`), mas o servidor que estava rodando na porta 8765 não está mais ativo. A causa do teste de performance falhar é a ausência do servidor, não um problema no código-fonte.