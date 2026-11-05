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
