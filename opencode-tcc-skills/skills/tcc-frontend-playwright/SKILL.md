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
