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
