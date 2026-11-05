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
