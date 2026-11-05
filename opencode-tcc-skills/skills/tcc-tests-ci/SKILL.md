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
