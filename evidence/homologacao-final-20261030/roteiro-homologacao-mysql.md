# Roteiro de Homologação MySQL — Navegação-Indoor-3D

**Projeto:** Navegação-Indoor-3D (TCC)  
**Destinatário:** SENAI (equipe de validação)  
**Branch:** `main`  
**Commit:** `fdbf583`  
**Data:** 30/10/2026  
**Arquivo:** `evidence/homologacao-final-20261030/roteiro-homologacao-mysql.md`  
**Status:** Procedimento preparatório — não executa homologação por si só

---

## 1. Objetivo

Validar que o backend FastAPI funciona corretamente contra uma instância MySQL de teste, confirmando que a suíte de testes passa com o dialeto MySQL e que as migrações são aplicadas sem erros.

**Não usar banco de produção.** Apenas instância de teste/desenvolvimento descartável.

---

## 2. Pré-requisitos

| Item | Descrição | Status |
|------|-----------|--------|
| Instância MySQL | Servidor MySQL dedicado para teste (não produção) | A ser provido pelo SENAI |
| Banco de teste | Banco dedicado para testes (ex: `navegacao_indoor_test`) | A ser criado pelo SENAI |
| Usuário de teste | Usuário com privilégios apenas no banco de teste | A ser criado pelo SENAI |
| `TEST_DATABASE_URL` | String de conexão no formato `mysql+pymysql://usuario:senha@host:porta/banco` | A ser definida pelo SENAI |
| Python 3.13+ | Ambiente Python do projeto já configurado | ✅ Disponível |
| Dependências Python | `fastapi`, `sqlalchemy`, `pymysql`, `pytest`, `httpx` já instaladas | ✅ Disponível |

---

## 3. Segurança

- **Não usar banco de produção.** A instância MySQL deve ser exclusiva para teste.
- **Não expor credenciais.** A string de conexão deve ser definida apenas como variável de ambiente `TEST_DATABASE_URL`, nunca gravada em código nem em arquivo versionado.
- **Não reutilizar banco com dados importantes.** O banco de teste deve ser descartável.
- **Não executar comandos destrutivos.** O fixture `db_session` dropa as tabelas após cada teste, mas apenas no banco de teste configurado.

---

## 4. Passo a Passo do Roteiro

### Passo 1 — Confirmar conectividade com o MySQL de teste

```powershell
# No terminal do SENAI, substitua os valores pelos reais da instância de teste
# NÃO exiba a senha no log

$env:TEST_DATABASE_URL = "mysql+pymysql://<usuario>:<senha>@<host>:<porta>/<banco_teste>"

# Teste de conectividade (substitua pelos valores reais)
python -c "
from sqlalchemy import create_engine
engine = create_engine('$env:TEST_DATABASE_URL')
conn = engine.connect()
print('Conectado com sucesso ao MySQL de teste')
conn.close()
"
```

**Critério de aprovação:** Conexão estabelecida sem erro. Não exibir credenciais no output.

### Passo 2 — Confirmar que o dialeto é MySQL (não SQLite)

```powershell
python -c "
from sqlalchemy import create_engine
engine = create_engine('$env:TEST_DATABASE_URL')
dialect = engine.dialect.name
print(f'Dialeto detectado: {dialect}')
assert dialect == 'mysql', f'Esperado mysql, obtido {dialect}'
print('OK: Dialeto MySQL confirmado')
"
```

**Critério de aprovação:** Output exibe `Dialeto detectado: mysql`.

### Passo 3 — Configurar variável de ambiente para a suíte de testes

```powershell
# Definir TEST_DATABASE_URL para toda a sessão
$env:TEST_DATABASE_URL = "mysql+pymysql://<usuario>:<senha>@<host>:<porta>/<banco_teste>"

# Verificar que está definida (não exibir valor)
if ($env:TEST_DATABASE_URL) { "TEST_DATABASE_URL está configurada" } else { "ERRO: TEST_DATABASE_URL não definida" }
```

### Passo 4 — Executar o teste de disponibilidade do MySQL

```powershell
cd backend
pytest tests/test_mysql_homologation.py -v --tb=short
```

**Critério de aprovação:** Teste `test_mysql_homologation_database_is_active` aprovado (status `passed`), não `skipped`.

### Passo 5 — Validar migrações (upgrade_schema)

```powershell
# Verificar que a migração é idempotente e funciona contra MySQL
python -c "
from sqlalchemy import create_engine
from app.migrations import upgrade_schema
engine = create_engine('$env:TEST_DATABASE_URL')
upgrade_schema(engine)
upgrade_schema(engine)  # Executar segunda vez para confirmar idempotência
print('OK: Migrações aplicadas com sucesso (idempotente)')
"
```

**Critério de aprovação:** Nenhum erro nas duas execuções.

### Passo 6 — Executar suíte completa de testes contra MySQL

```powershell
cd backend
pytest tests/ -v --tb=short
```

**Critério de aprovação:** Todos os testes aprovados (ou apenas o esperado skip se houver marcador condicional). Não deve haver falhas inesperadas.

### Passo 7 — Registrar resultados

Criar arquivo de evidência em `evidence/homologacao-final-20261030/`:

| Item | Valor a registrar |
|------|-------------------|
| Data e hora | |
| Versão do MySQL | `SELECT VERSION();` |
| Versão do Python | `python --version` |
| TEST_DATABASE_URL configurada? | Sim/Não (não exibir valor) |
| Dialeto confirmado? | Sim/Não |
| Migrações aplicadas? | Sim/Não |
| Testes aprovados | Quantidade |
| Testes falhados | Quantidade |
| Testes ignorados | Quantidade |
| Código de saída do pytest | |

Salvar em: `evidence/homologacao-final-20261030/resultado-homologacao-mysql.md`

---

## 5. Critérios de Aprovação da Homologação MySQL

| Critério | Como verificar | Status alvo |
|----------|---------------|-------------|
| Conectividade MySQL | Teste de conexão bem-sucedido | ✅ |
| Dialeto é MySQL | `engine.dialect.name == "mysql"` | ✅ |
| Teste de homologação aprovado | `test_mysql_homologation_database_is_active` = passed | ✅ |
| Migrações idempotentes | Duas execuções de `upgrade_schema` sem erro | ✅ |
| Suíte completa aprovada | `pytest tests/` sem falhas inesperadas | ✅ |
| Nenhuma credencial exposta | Nenhum valor de senha em logs ou arquivos | ✅ |

---

## 6. Se a Homologação Falhar

| Falha provável | Ação correta |
|---------------|--------------|
| Erro de conexão | Verificar host, porta, usuário, senha e se o MySQL está rodando |
| Dialeto não é MySQL | Verificar se `TEST_DATABASE_URL` aponta para MySQL, não SQLite |
| Erro de migração | Verificar se o usuário MySQL tem privilégios para criar/alterar tabelas |
| Teste falha | Revisar erro específico; não pular nem ignorar |
| Credencial exposta | Remover imediatamente do log/arquivo e rotacionar a senha |

---

## 7. Limitações

- Este roteiro valida o backend contra MySQL de teste. Não valida desempenho em MySQL, carga concorrente, nem operação offline.
- Testes SQLite não substituem homologação em MySQL (conforme `AGENTS.md` linha 49).
- A homologação MySQL é uma das pendências para aceitação integral das Fases 1–3 (conforme `AUDITORIA_FASES_1-3.md` linha 7).

---

## 8. Arquivos de Evidência Associados

| Arquivo | Conteúdo |
|---------|----------|
| `evidence/homologacao-final-20261030/resultado-homologacao-mysql.md` | Resultado da execução (a ser preenchido pelo SENAI) |
| `backend/tests/test_mysql_homologation.py` | Teste de disponibilidade do MySQL |
| `backend/tests/conftest.py` | Configuração de teste (usa `TEST_DATABASE_URL` se definido) |
| `backend/app/migrations.py` | Migração `upgrade_schema` (idempotente) |
| `backend/.env.example` | Exemplo de variáveis (não usar como .env real) |
