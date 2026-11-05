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
