@echo off
setlocal EnableExtensions DisableDelayedExpansion

REM ===========================================================================
REM setup_opencode_tcc.bat
REM
REM Prepara as 7 skills do TCC (Navegacao-Indoor-3D) em uma PASTA DEDICADA.
REM
REM Padrao: PREVIA. Nada e criado, alterado ou removido.
REM Gravacao: somente com --apply E confirmacao digitada pelo usuario.
REM
REM Este script NAO: altera opencode.json/opencode.jsonc, altera o repositorio,
REM instala/atualiza/remove MCPs, plugins ou dependencias, executa npm/npx,
REM baixa executaveis, faz commit/push, le .env ou exibe tokens, nem exige admin.
REM
REM Formato de skill (https://opencode.ai/docs/skills): uma pasta por skill com
REM SKILL.md; frontmatter YAML com name e description obrigatorios; name deve
REM ser igual ao nome da pasta (minusculas e hifens). A pagina consultada e a
REM documentacao geral de skills; nada especifico da v2.1.4 foi confirmado.
REM
REM Os textos das skills ficam no FINAL deste arquivo, depois do ultimo exit.
REM O cmd nunca interpreta essa parte; o PowerShell extrai os blocos e grava
REM em UTF-8 sem BOM. As mensagens do script sao ASCII de proposito, para nao
REM depender da pagina de codigo do console (nenhum chcp e executado).
REM ===========================================================================

set "TCC_SELF=%~f0"
set "TCC_APPLY=0"
set "TCC_MODE=preview"

:parse_args
if "%~1"=="" goto args_done
if /i "%~1"=="--apply" goto arg_apply
if /i "%~1"=="--help" goto usage
if /i "%~1"=="-h" goto usage
if "%~1"=="/?" goto usage
echo [ERRO] Argumento desconhecido: "%~1"
echo        Use --help para ver as opcoes.
exit /b 2

:arg_apply
set "TCC_APPLY=1"
shift
goto parse_args

:usage
echo.
echo Uso: setup_opencode_tcc.bat [--apply]
echo.
echo   (sem argumentos)  PREVIA: verifica o ambiente e mostra o que seria criado.
echo                     Nenhum arquivo e criado ou alterado.
echo   --apply           Permite gravar as 7 skills em uma pasta dedicada, mas
echo                     somente depois de voce digitar uma confirmacao.
echo   --help, -h, /?    Mostra esta ajuda.
echo.
echo Execute em um terminal comum (CMD ou PowerShell), sem administrador.
exit /b 0

:args_done
echo.
echo ============================================================
echo  OpenCode TCC - preparo de skills (Navegacao-Indoor-3D)
echo ============================================================
if "%TCC_APPLY%"=="1" echo  Modo: --apply, gravacao somente apos confirmacao digitada
if not "%TCC_APPLY%"=="1" echo  Modo: PREVIA, nenhum arquivo sera criado ou alterado

fltmc >nul 2>&1
if not errorlevel 1 echo [AVISO] Executando como administrador. Nao e necessario; prefira um terminal comum.

where powershell >nul 2>&1
if errorlevel 1 goto no_ps

call :run_ps ps_check
set "RC=%errorlevel%"
if "%RC%"=="90" goto internal_error

echo.
echo Pasta atual: "%CD%"
echo As skills serao gravadas SOMENTE na subpasta dedicada opencode-tcc-skills
echo dentro da pasta base que voce escolher. Nada sera ativado em .opencode,
echo no repositorio ou na configuracao global do OpenCode.
set "TCC_BASE="
set /p "TCC_BASE=Pasta base [Enter = pasta atual]: "
if not defined TCC_BASE set "TCC_BASE=%CD%"
set "TCC_BASE=%TCC_BASE:"=%"

set "TCC_MODE=preview"
call :run_ps ps_plan
set "RC=%errorlevel%"
if not "%RC%"=="0" goto plan_failed

if "%TCC_APPLY%"=="1" goto confirm_apply
echo.
echo ============================================================
echo  PREVIA CONCLUIDA - NENHUMA ALTERACAO FOI REALIZADA.
echo ------------------------------------------------------------
echo  NAO foi feito: gravacao de arquivos, mudanca em MCPs,
echo  configuracao global, repositorio, plugins ou dependencias.
echo  Para gravar as skills: setup_opencode_tcc.bat --apply
echo ============================================================
exit /b 0

:confirm_apply
echo.
echo ATENCAO: serao criados somente a pasta dedicada e os arquivos listados acima.
echo Nenhum arquivo existente sera sobrescrito.
echo Para autorizar, digite exatamente (em maiusculas): GRAVAR SKILLS
set "TCC_CONFIRM="
set /p "TCC_CONFIRM=Confirmacao: "
if not defined TCC_CONFIRM goto cancelled
set "TCC_CONFIRM=%TCC_CONFIRM:"=%"
if not "%TCC_CONFIRM%"=="GRAVAR SKILLS" goto cancelled

set "TCC_MODE=write"
call :run_ps ps_plan
set "RC=%errorlevel%"
if not "%RC%"=="0" goto write_failed

echo.
echo ============================================================
echo  CONCLUIDO
echo ------------------------------------------------------------
echo  REALIZADO : criacao das 7 skills e do manifesto na pasta
echo              dedicada opencode-tcc-skills (lista acima).
echo  NAO FEITO : ativacao das skills, alteracao de MCPs, de
echo              opencode.json/jsonc, do repositorio, instalacao
echo              de pacotes, commit ou push.
echo  PROXIMO   : revise os arquivos. Para o OpenCode enxerga-las,
echo              elas precisam ser copiadas para .opencode\skills
echo              do projeto ou para a pasta global de skills. Isso
echo              NAO e feito por este script; exige autorizacao
echo              separada sua.
echo ============================================================
exit /b 0

:cancelled
echo.
echo Confirmacao nao recebida. NADA foi gravado.
exit /b 1

:no_ps
echo [ERRO] powershell.exe nao encontrado no PATH. Este script usa o PowerShell
echo        apenas para extrair e gravar texto. Nada foi alterado.
exit /b 1

:internal_error
echo [ERRO] Bloco interno nao encontrado no arquivo. O .bat pode estar truncado
echo        ou ter sido editado. Nada foi alterado.
exit /b 1

:plan_failed
echo.
if "%RC%"=="3" echo [PARADO] Conflito: ja existem arquivos nos destinos. Nada foi gravado.
if "%RC%"=="4" echo [PARADO] Pasta base invalida ou bloqueada. Nada foi gravado.
if "%RC%"=="5" echo [PARADO] Conteudo embutido invalido. Nada foi gravado.
if "%RC%"=="90" goto internal_error
echo Codigo de saida: %RC%. NENHUMA alteracao foi realizada.
exit /b %RC%

:write_failed
echo.
echo [ERRO] A gravacao nao foi concluida (codigo %RC%).
echo        Veja acima o que foi criado ate o erro e o manifesto parcial.
echo        Nenhum arquivo existente foi sobrescrito.
exit /b %RC%

:run_ps
powershell -NoProfile -NonInteractive -Command "$t=[IO.File]::ReadAllText($env:TCC_SELF,[Text.Encoding]::UTF8); $m=[regex]::Match($t,'(?ms)^@@BEGIN %~1\r?\n(.*?)\r?\n@@END %~1'); if(-not $m.Success){exit 90}; Invoke-Expression ($m.Groups[1].Value)"
exit /b %errorlevel%

exit /b 0

@@BEGIN ps_check
$ErrorActionPreference = 'Continue'
Write-Host ''
Write-Host '[1/3] Ferramentas (somente leitura: --version)'
$tools = @(
  @('opencode','2.1.4'),
  @('node','24.12.0'),
  @('npm','11.6.2'),
  @('python','3.13.7'),
  @('git','2.55.0')
)
$missing = 0
$ocPath = $null
foreach ($tool in $tools) {
  $name = $tool[0]
  $exp = $tool[1]
  $found = Get-Command $name -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
  if (-not $found) {
    Write-Host ('  [FALTA]     ' + $name + ': nao encontrado no PATH')
    $missing++
    continue
  }
  $exe = $found.Source
  if ($name -eq 'opencode') { $ocPath = $exe }
  $ver = ''
  try { $ver = (& $exe --version 2>&1 | Out-String).Trim() } catch { $ver = '' }
  if ($ver -notmatch '\d+\.\d+') {
    Write-Host ('  [AVISO]     ' + $name + ': encontrado, mas --version nao retornou uma versao (pode ser alias da Microsoft Store)')
    $missing++
    continue
  }
  $first = ($ver -split "`r?`n")[0].Trim()
  if ($first -like ('*' + $exp + '*')) {
    Write-Host ('  [OK]        ' + $name + ': ' + $first)
  } else {
    Write-Host ('  [DIFERENTE] ' + $name + ': ' + $first + '  (esperado ' + $exp + ')')
  }
}
if ($missing -gt 0) { Write-Host ('  Atencao: ' + $missing + ' ferramenta(s) ausente(s) ou sem resposta. Isso nao impede a gravacao de skills, mas revise o ambiente.') }

Write-Host ''
Write-Host '[2/3] MCPs (somente leitura: opencode mcp list)'
$expected = @('github','playwright','context7','gh_grep','sentry','supabase','Roblox_Studio')
if (-not $ocPath) {
  Write-Host '  [PULADO] opencode nao encontrado; nao foi possivel listar MCPs.'
} else {
  $raw = $null
  try {
    $job = Start-Job -ScriptBlock { param($p, $d) Set-Location -LiteralPath $d; & $p mcp list 2>&1 | Out-String } -ArgumentList $ocPath, (Get-Location).Path
    if (Wait-Job $job -Timeout 60) { $raw = (Receive-Job $job | Out-String) } else { Stop-Job $job }
    Remove-Job $job -Force
  } catch { $raw = $null }
  if ([string]::IsNullOrWhiteSpace($raw)) {
    Write-Host '  [AVISO] opencode mcp list nao retornou saida (tempo esgotado ou erro). Nenhuma configuracao foi tocada.'
  } else {
    $clean = [regex]::Replace($raw, '\x1b\[[0-9;?]*[A-Za-z]', '')
    $lines = $clean -split "`r?`n"
    foreach ($n in $expected) {
      $pat = '(?i)(?<![A-Za-z0-9_])' + [regex]::Escape($n) + '(?![A-Za-z0-9_])'
      $hit = $lines | Where-Object { $_ -match $pat } | Select-Object -First 1
      if (-not $hit) {
        Write-Host ('  [NAO LISTADO] ' + $n)
      } elseif ($hit -match '(?i)disconnected|failed|needs[ _]?auth|disabled|error') {
        Write-Host ('  [ATENCAO]     ' + $n + ': listado, mas o status nao parece conectado')
      } elseif ($hit -match '(?i)connected') {
        Write-Host ('  [OK]          ' + $n + ': ja conectado (nao sera reinstalado nem duplicado)')
      } else {
        Write-Host ('  [OK]          ' + $n + ': listado (status nao reconhecido)')
      }
    }
    Write-Host '  Nenhuma configuracao de MCP foi alterada. Linhas brutas nao sao exibidas.'
  }
}
exit 0
@@END ps_check

@@BEGIN ps_plan
$ErrorActionPreference = 'Stop'
$mode = $env:TCC_MODE
$names = @('tcc-repo-audit','tcc-safe-development','tcc-tests-ci','tcc-fastapi-security','tcc-frontend-playwright','tcc-blender-3d','tcc-academic-docs')
Write-Host ''
Write-Host '[3/3] Plano das skills'

$base0 = $env:TCC_BASE
if ([string]::IsNullOrWhiteSpace($base0)) { Write-Host '  [ERRO] pasta base vazia.'; exit 4 }
try { $base = [System.IO.Path]::GetFullPath($base0.Trim().Trim('"')) } catch { Write-Host '  [ERRO] caminho invalido.'; exit 4 }
if ($base.Length -gt 3) { $base = $base.TrimEnd('\') }
if ($base -match '^[A-Za-z]:\\?$' -or $base.StartsWith('\\')) { Write-Host '  [ERRO] escolha uma subpasta local (nao raiz de disco nem caminho de rede).'; exit 4 }
if (-not (Test-Path -LiteralPath $base -PathType Container)) { Write-Host '  [ERRO] a pasta base nao existe (este script nao a cria).'; exit 4 }

$root = Join-Path $base 'opencode-tcc-skills'
$skillsDir = Join-Path $root 'skills'
$manifest = Join-Path $root 'MANIFEST_TCC_SKILLS.txt'
$glob = Join-Path $env:USERPROFILE '.config\opencode'
$rootN = $root.TrimEnd('\') + '\'
$globN = $glob.TrimEnd('\') + '\'
if ($rootN.StartsWith($globN, [System.StringComparison]::OrdinalIgnoreCase)) {
  Write-Host '  [BLOQUEADO] o destino ficaria dentro da configuracao global do OpenCode. Escolha outra pasta.'
  exit 4
}

$inGit = $false
$dir = $base
while ($dir) {
  if (Test-Path -LiteralPath (Join-Path $dir '.git')) { $inGit = $true; break }
  $dir = Split-Path -Parent $dir
}

$text = [IO.File]::ReadAllText($env:TCC_SELF, [Text.Encoding]::UTF8)
$skills = @{}
$bad = 0
foreach ($n in $names) {
  $rx = '(?ms)^@@BEGIN skill:' + [regex]::Escape($n) + '\r?\n(.*?)\r?\n@@END skill:' + [regex]::Escape($n)
  $m = [regex]::Match($text, $rx)
  if (-not $m.Success) { Write-Host ('  [ERRO] conteudo embutido ausente: ' + $n); $bad++; continue }
  $c = ($m.Groups[1].Value -replace "`r`n", "`n").TrimEnd() + "`n"
  $fm = [regex]::Match($c, '(?s)\A---\n(.*?)\n---\n')
  $okName = $false
  $okDesc = $false
  if ($fm.Success) {
    $nm = [regex]::Match($fm.Groups[1].Value, '(?m)^name:\s*(\S+)\s*$')
    $ds = [regex]::Match($fm.Groups[1].Value, '(?m)^description:\s*(\S.*)$')
    if ($nm.Success -and ($nm.Groups[1].Value -ceq $n) -and ($n -cmatch '^[a-z0-9]+(-[a-z0-9]+)*$') -and ($n.Length -le 64)) { $okName = $true }
    if ($ds.Success -and ($ds.Groups[1].Value.Trim().Length -le 1024)) { $okDesc = $true }
  }
  if (-not ($okName -and $okDesc)) { Write-Host ('  [ERRO] frontmatter invalido em: ' + $n); $bad++; continue }
  $skills[$n] = $c
}
if ($bad -gt 0) { Write-Host '  Conteudo embutido invalido; nada foi gravado.'; exit 5 }
Write-Host ('  Skills embutidas validadas (frontmatter name/description): ' + $skills.Count + '/' + $names.Count)

Write-Host ('  Pasta dedicada : ' + $root)
if ($inGit) { Write-Host '  [AVISO] a pasta base esta dentro de um repositorio git. A pasta dedicada apareceria como nao rastreada; este script nunca faz commit.' }

$targets = @()
foreach ($n in $names) { $targets += (Join-Path (Join-Path $skillsDir $n) 'SKILL.md') }
$targets += $manifest

$conflicts = 0
foreach ($p in $targets) {
  if (Test-Path -LiteralPath $p) {
    Write-Host ('  [CONFLITO] ja existe: ' + $p)
    $conflicts++
  } else {
    Write-Host ('  [CRIAR]    ' + $p)
  }
}
if ($conflicts -gt 0) { Write-Host '  Interrompido por conflito. Nenhum arquivo existente sera sobrescrito.'; exit 3 }

if ($mode -ne 'write') {
  Write-Host '  (previa) nada foi criado.'
  exit 0
}

$enc = New-Object System.Text.UTF8Encoding($false)
$sha = [System.Security.Cryptography.SHA256]::Create()
$createdDirs = New-Object System.Collections.ArrayList
$createdFiles = New-Object System.Collections.ArrayList
$hashes = @{}
$err = $null

function Write-NewFile($path, $bytes) {
  $fs = New-Object System.IO.FileStream($path, [System.IO.FileMode]::CreateNew, [System.IO.FileAccess]::Write, [System.IO.FileShare]::None)
  try { $fs.Write($bytes, 0, $bytes.Length) } finally { $fs.Dispose() }
}

try {
  $dirs = @($root, $skillsDir)
  foreach ($n in $names) { $dirs += (Join-Path $skillsDir $n) }
  foreach ($d in $dirs) {
    if (-not (Test-Path -LiteralPath $d)) {
      [void](New-Item -ItemType Directory -Path $d)
      [void]$createdDirs.Add($d)
    }
  }
  foreach ($n in $names) {
    $p = Join-Path (Join-Path $skillsDir $n) 'SKILL.md'
    $bytes = $enc.GetBytes($skills[$n])
    Write-NewFile $p $bytes
    [void]$createdFiles.Add($p)
    $hashes[$p] = ([BitConverter]::ToString($sha.ComputeHash($bytes))).Replace('-', '').ToLower()
  }
} catch {
  $err = $_.Exception.Message
}

$lines = New-Object System.Collections.ArrayList
[void]$lines.Add('# Manifesto de arquivos criados por setup_opencode_tcc.bat')
[void]$lines.Add('# Gerado em: ' + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'))
[void]$lines.Add('# Somente os itens abaixo foram criados pelo script. Uma remocao segura futura deve se limitar a eles,')
[void]$lines.Add('# e apenas se o SHA256 do arquivo ainda for o registrado (arquivo nao editado).')
if ($err) { [void]$lines.Add('STATUS=PARCIAL') } else { [void]$lines.Add('STATUS=COMPLETO') }
[void]$lines.Add('BASE=' + $base)
[void]$lines.Add('ROOT=' + $root)
foreach ($f in $createdFiles) { [void]$lines.Add('FILE|' + $hashes[$f] + '|' + $f) }
[void]$lines.Add('FILE||' + $manifest)
$rev = @($createdDirs)
[array]::Reverse($rev)
foreach ($d in $rev) { [void]$lines.Add('DIR|' + $d) }

$manifestErr = $null
try {
  if (Test-Path -LiteralPath $root) { Write-NewFile $manifest ($enc.GetBytes((($lines -join "`n") + "`n"))) }
} catch { $manifestErr = $_.Exception.Message }

Write-Host ''
if ($createdFiles.Count -gt 0) {
  Write-Host '  Arquivos criados:'
  foreach ($f in $createdFiles) { Write-Host ('    ' + $f) }
}
if (-not $manifestErr -and (Test-Path -LiteralPath $manifest)) { Write-Host ('    ' + $manifest + '  (manifesto)') }
if ($manifestErr) { Write-Host ('  [ERRO] manifesto nao gravado: ' + $manifestErr) }
if ($err) {
  Write-Host ('  [ERRO] falha durante a gravacao: ' + $err)
  exit 6
}
if ($manifestErr) { exit 6 }
exit 0
@@END ps_plan

@@BEGIN skill:tcc-repo-audit
---
name: tcc-repo-audit
description: Audita arquitetura, segurança, regressões e evidências do TCC Navegacao-Indoor-3D em modo somente leitura, priorizando achados e produzindo um relatório. Use antes de propor mudanças no repositório.
compatibility: opencode
---

# Auditoria do repositório do TCC

## Regras
- Somente leitura: não edite arquivos, não instale dependências, não faça commit nem push.
- Nunca abra nem exiba `.env`, tokens, chaves ou senhas. Se encontrar um segredo, cite só arquivo e linha, sem o valor.
- Não presuma a stack. Confirme em README, docs, `package.json`, `requirements*.txt`, `pyproject.toml` e workflows de CI.

## Passos
1. Mapear: API (FastAPI/SQLAlchemy), banco (MySQL em produção, SQLite em testes), app visitante (Expo/React Native), painel admin (React/Vite), testes E2E (Playwright) e cenas 3D (Blender).
2. Ler a documentação existente antes do código e anotar o que ela afirma.
3. Verificar cada afirmação relevante contra o código (autenticação, rotas, modelos, contratos entre API e apps).
4. Procurar: falhas de autorização, validação ausente, segredos no repositório, configuração insegura, dependências desatualizadas conhecidas, testes ausentes, divergência entre docs e código.
5. Para regressões, comparar `git log` e `git diff` das áreas críticas (somente leitura).

## Evidência
Cada achado precisa de: arquivo e linha, comando ou leitura que o comprova, impacto e como reproduzir. O que não foi verificado deve ser marcado como "não verificado".

## Prioridade
- P0: exploração direta, perda de dados ou vazamento de segredo.
- P1: falha de segurança ou regressão provável.
- P2: dívida técnica com risco moderado.
- P3: melhoria ou estilo.

## Formato do relatório
Resumo (3 a 5 linhas), tabela de achados (id, prioridade, local, evidência, recomendação), lista do que não foi verificado e próximos passos sugeridos. Não aplique correções sem autorização.
@@END skill:tcc-repo-audit

@@BEGIN skill:tcc-safe-development
---
name: tcc-safe-development
description: Guia implementação gradual e segura no TCC Navegacao-Indoor-3D, com alterações mínimas, preservação de trabalho não commitado do usuário, validação a cada passo e proibição de commit ou push sem autorização.
compatibility: opencode
---

# Desenvolvimento seguro no TCC

## Antes de editar
1. Rode `git status` e `git diff --stat`. Alterações não commitadas pertencem ao usuário: não as reverta, não as sobrescreva e não as misture com as suas sem avisar.
2. Entenda o código vizinho e siga o estilo existente.
3. Declare o plano em poucas linhas e o escopo exato dos arquivos que serão tocados.

## Durante
- Menor mudança possível que resolve o problema; sem refatorações paralelas.
- Um assunto por vez; valide antes de seguir.
- Não adicione, atualize nem remova dependências sem pedir autorização.
- Não leia nem exiba `.env` ou segredos. Use variáveis de ambiente e arquivos `.env.example` sem valores reais.

## Validar
- Execute apenas os testes e linters que o projeto já define (confira scripts e documentação).
- Informe o comando e o resultado reais. Se não pôde executar, diga isso explicitamente.

## Proibido sem autorização explícita do usuário
`git commit`, `git push`, `git reset --hard`, `git clean`, `git checkout -- .`, `git stash drop`, reescrita de histórico, exclusão de arquivos e mudança de configuração global do OpenCode.

## Entrega
Liste arquivos alterados, motivo, como validar e o que ficou pendente. Sugira a mensagem de commit, mas não execute o commit.
@@END skill:tcc-safe-development

@@BEGIN skill:tcc-tests-ci
---
name: tcc-tests-ci
description: Diagnostica falhas de testes e de CI no TCC Navegacao-Indoor-3D, incluindo testes intermitentes, Playwright, concorrência e cotas compartilhadas, sempre com evidências reproduzíveis.
compatibility: opencode
---

# Testes e CI

## Método
1. Reproduzir primeiro. Registrar comando, ambiente (SO, versões) e saída completa do erro. Sem reprodução, não declare causa.
2. Ler o workflow de CI e os scripts de teste do projeto para saber como os testes realmente rodam.
3. Separar tipos de falha: ambiente/configuração, dados compartilhados, ordem de execução, tempo/espera, dependência externa e defeito real.

## Falhas intermitentes
- Rodar o mesmo teste várias vezes e com `--workers=1` para comparar com a execução paralela.
- Procurar estado compartilhado: banco, usuários fixos, filas, arquivos temporários, portas, relógio.
- Conferir diferenças entre SQLite (testes) e MySQL (produção): tipos, case sensitivity, transações, constraints.
- Em CI, comparar versões, variáveis de ambiente e cache com a execução local.

## Playwright
- Usar `trace`, vídeo e screenshots na falha; analisar o trace antes de mudar o teste.
- Preferir esperas por estado (`expect`, locators com auto-wait) em vez de `waitForTimeout`.
- Isolar dados por teste. Não depender de ordem entre testes.

## Concorrência e cotas
- Identificar recursos com limite compartilhado (rate limit, quotas de API, contas de teste) e como testes paralelos os consomem.
- Propor isolamento, mocks ou serialização apenas onde necessário.

## Relatório
Causa provável, evidência (log, trace, execuções repetidas), correção mínima proposta e risco. Não altere configuração de CI nem instale dependências sem autorização.
@@END skill:tcc-tests-ci

@@BEGIN skill:tcc-fastapi-security
---
name: tcc-fastapi-security
description: Revisa e orienta a segurança da API FastAPI e SQLAlchemy do TCC Navegacao-Indoor-3D, cobrindo autenticação, autorização, validação, configuração, segredos, rate limit e testes de API.
compatibility: opencode
---

# Segurança da API (FastAPI/SQLAlchemy)

## Checklist
1. Autenticação: hash de senha adequado, expiração e validação de tokens, segredo fora do código, logout/revogação se existir.
2. Autorização: toda rota sensível exige dependência de autenticação; verificar papéis (visitante x administrador) e autorização por objeto (um usuário não acessa recurso de outro).
3. Validação: modelos Pydantic estritos, limites de tamanho, tipos e enums; rejeitar campos inesperados quando fizer sentido.
4. Banco: consultas parametrizadas via SQLAlchemy, sem SQL montado por concatenação; atenção a `text()`.
5. Configuração: valores por variáveis de ambiente, sem defaults inseguros em produção, `debug` desligado, CORS restrito às origens necessárias.
6. Segredos: nunca em código, logs ou respostas de erro. Não leia nem exiba `.env`.
7. Abuso: rate limit em login e rotas custosas; limites de upload; paginação.
8. Erros: sem stack trace ou detalhes internos ao cliente; logs sem dados sensíveis.
9. Dependências: conferir versões fixadas e avisos de segurança conhecidos (sem instalar nada).

## Testes
- Usar `TestClient` com SQLite de teste, como o projeto já faz; cobrir 401, 403, 404 e 422.
- Cobrir tentativas de acesso a recursos de outro usuário e entradas malformadas.
- Lembrar que SQLite e MySQL diferem; sinalize o que só pode ser validado em MySQL.

## Saída
Achados com prioridade, arquivo e linha, evidência e correção mínima sugerida. Não aplique mudanças sem autorização.
@@END skill:tcc-fastapi-security

@@BEGIN skill:tcc-frontend-playwright
---
name: tcc-frontend-playwright
description: Orienta fluxos do app Expo/React Native e do painel React/Vite do TCC Navegacao-Indoor-3D, incluindo navegação por QR Code, estados de origem e destino, rotas e testes E2E com Playwright.
compatibility: opencode
---

# Frontend e testes E2E

## Reconhecer o terreno
- Confirmar a estrutura real (pastas do app visitante e do painel admin, scripts de `package.json`, configuração do Playwright) antes de propor mudanças.
- Identificar como o app recebe o QR Code: payload esperado, validação, falhas (QR inválido, expirado, de outro shopping).

## Fluxos a verificar
1. Leitura de QR Code define a origem; tratar permissão de câmera negada e QR inválido.
2. Escolha de destino: estados vazios, origem igual ao destino, destino inexistente.
3. Cálculo e exibição de rota: carregamento, erro de rede, rota não encontrada, mudança de andar.
4. Painel admin: login, listas, formulários com validação, mensagens de erro.
5. Persistência de estado ao voltar, recarregar ou trocar de tela.

## Playwright
- Seletores estáveis (`getByRole`, `getByTestId`); evitar CSS frágil.
- Sem `waitForTimeout`; usar asserções com espera automática.
- Câmera e QR: simular o payload (deep link, parâmetro ou mock) em vez de depender de câmera real.
- Dados de teste isolados por teste; limpar o que criar.
- Em falhas, analisar trace e screenshot antes de alterar o teste.

## Cuidados
- Não instale dependências nem execute `npx` sem autorização.
- Não altere código sem pedido; reporte o que viu, com arquivo e linha.
@@END skill:tcc-frontend-playwright

@@BEGIN skill:tcc-blender-3d
---
name: tcc-blender-3d
description: Orienta geometria, cenas e exportações 3D do TCC Navegacao-Indoor-3D no Blender, validando compatibilidade com os contratos existentes de nomes, escala, coordenadas e formato consumidos pela API e pelos apps.
compatibility: opencode
---

# Blender e navegação 3D

## Princípios
- Nunca sobrescreva `.blend` ou modelos exportados existentes. Trabalhe em cópias com novo nome.
- Não execute o Blender (nem em modo `-b`) sem autorização do usuário.
- Antes de qualquer mudança, descubra o contrato atual: quais nomes de objetos, IDs, escala, origem e formato o app e a API esperam. Procure nos scripts de exportação, na documentação e nos dados de exemplo.

## Checklist de geometria
1. Unidades e escala consistentes (aplicar transformações; sem escala não uniforme oculta).
2. Origem e orientação dos eixos: Blender usa Z para cima; glTF usa Y para cima. Confirme como o exportador converte.
3. Normais corretas, sem faces duplicadas ou malha não manifold onde isso importa.
4. Convenção de nomes estável para andares, salas, lojas e pontos de navegação (nós e arestas).
5. Coordenadas dos nós de navegação coerentes com a geometria e com o que o banco armazena.
6. Materiais e texturas mínimos, para não pesar no app móvel.

## Exportação
- Registrar as opções usadas (formato, eixos, aplicação de modificadores, compressão).
- Comparar a exportação nova com a anterior: lista de nós, nomes, caixa delimitadora e tamanho do arquivo.
- Validar o resultado com ferramentas já instaladas localmente; não baixe validadores.

## Relatório
O que mudou, o que foi comparado, incompatibilidades com o contrato existente e o que não pôde ser verificado.
@@END skill:tcc-blender-3d

@@BEGIN skill:tcc-academic-docs
---
name: tcc-academic-docs
description: Apoia a documentação acadêmica do TCC Navegacao-Indoor-3D, com revisão técnica, consistência entre texto e sistema implementado, referências verificáveis e adequação à norma institucional efetivamente exigida, sem inventar informações.
compatibility: opencode
---

# Documentação acadêmica do TCC

## Regra central
Não invente nada: nem dados, resultados, citações, autores, páginas, DOIs ou normas. O que não puder ser confirmado deve ser marcado como `[VERIFICAR]`.

## Norma institucional
- Descubra qual manual a instituição exige (por exemplo, ABNT ou modelo próprio) pedindo o documento ao usuário. Não presuma versão nem regras de formatação.
- Aplique somente o que o manual confirmado determina: estrutura, citações, referências, margens, fontes.

## Revisão técnica
1. Comparar cada afirmação do texto com o sistema real (arquitetura, tecnologias, funcionalidades, testes). Apontar divergências com arquivo ou trecho de origem.
2. Conferir que métodos, métricas e resultados descritos têm evidência reproduzível (testes, logs, medições).
3. Verificar coerência entre objetivos, metodologia, resultados e conclusão.
4. Sinalizar afirmações sem fonte, exageros e termos usados de forma inconsistente.

## Referências
- Usar apenas fontes que o usuário forneceu ou que possam ser verificadas.
- Se a busca na web estiver disponível, confirmar título, autores, ano e endereço antes de citar.
- Não gerar bibliografia de memória.

## Estilo
Texto claro, impessoal quando a norma pedir, sem plágio. Ao reescrever, preservar o sentido e a autoria do aluno e listar o que foi alterado.

## Saída
Comentários por seção, lista de pendências `[VERIFICAR]` e sugestões de redação. Não altere o código do projeto.
@@END skill:tcc-academic-docs
