# Protocolo de Avaliação Presencial de Usabilidade — RNF09

**Projeto:** Navegação-Indoor-3D (TCC)  
**Requisito avaliado:** RNF09 — Usabilidade presencial  
**Versão:** 1.0  
**Data:** 30/10/2026  
**Local:** evidence/rnf09-usabilidade-protocolo/protocolo-usabilidade-rnf09.md  
**Status:** Protocolo preparado, não executado (sem participantes)

---

## 1. Referência aos Critérios Documentados

Os critérios abaixo são extraídos literalmente dos documentos do projeto. Nenhum critério adicional foi inventado.

### 1.1 Fonte documental

- `AGENTS.md` — Seção "Comandos de validação" (linha 48): *"Os testes E2E e a execução de câmera/dispositivo devem ser reportados como não executados quando não houver ambiente adequado."*
- `AGENTS.md` — Seção "Visão geral": descreve o sistema composto por API FastAPI, aplicativo Expo/React Native e painel administrativo React/Vite, usando QR Codes, mapas 2D e roteamento por Dijkstra.
- `AUDITORIA_FASES_1-3.md` — Seção "RNF09 — usabilidade presencial" (linhas 87-91):
  > **PENDENTE.** Não foram recrutados participantes nem coletados tempos, satisfação ou resultados neste ambiente. A especificação pede cinco usuários sem treinamento; a definição de pronto exige ausência de erros críticos. O critério anterior "4/5 concluem e satisfação ≥ 4/5" não vem da especificação e foi removido como condição de aceite.
  >
  > Roteiro proposto, ainda não executado: entregar QR de entrada, pedir localização de uma loja, observar busca e categoria, reação a QR inválido/local em manutenção e conclusão do trajeto. Registrar ajuda necessária, conclusão, tempos e erros de forma anonimizada. Classificar erros críticos e documentar correções/reteste antes do aceite. Salvar resultados reais em `evidence/rnf09-usabilidade.md` quando existirem; esse arquivo não foi preenchido com dados simulados.
- `DECISOES.md` — Item 21 "Usabilidade (RNF09)" (linhas 43-44):
  > Permanece pendente até teste com cinco usuários sem treinamento. A definição de pronto exige ausência de erros críticos. O antigo critério de 4/5 conclusões e satisfação ≥ 4/5 não constava na especificação e não é adotado como substituto. Não há resultados de participantes neste repositório.

### 1.2 Critérios de aprovação (definição de pronto)

| Critério | Fonte | Observação |
|----------|-------|------------|
| Cinco usuários sem treinamento | `AUDITORIA_FASES_1-3.md` linha 89 | Participantes não treinados no sistema |
| Ausência de erros críticos | `AUDITORIA_FASES_1-3.md` linha 89; `DECISOES.md` linha 43 | Definição de erro crítico definida na Seção 6 deste protocolo |
| Não adotar critério "4/5 concluem e satisfação ≥ 4/5" | `AUDITORIA_FASES_1-3.md` linha 89; `DECISOES.md` linha 43 | Esse critério foi explicitamente removido como condição de aceite |

### 1.3 Tarefas exigidas (roteiro proposto)

Conforme `AUDITORIA_FASES_1-3.md` linha 91:

1. Entregar QR de entrada
2. Pedir localização de uma loja
3. Observar busca e categoria
4. Observar reação a QR inválido
5. Observar reação a local em manutenção
6. Observar conclusão do trajeto

---

## 2. Objetivo e Escopo

### 2.1 Objetivo

Avaliar a usabilidade presencial do aplicativo de navegação indoor (mobile Expo/React Native) com cinco participantes sem treinamento, verificando se conseguem completar o fluxo de navegação (entrada via QR Code → busca de destino → seleção de categoria → cálculo de rota → conclusão do trajeto) sem encontrar erros críticos.

### 2.2 Escopo

**Inclui:**
- Fluxo completo de entrada via QR Code (leitura ou digitação manual do token)
- Busca de destino por nome/categoria na tela "Explorar"
- Seleção de destino e cálculo de rota
- Navegação pelo mapa com indicação de origem e destino
- Tratamento de QR Code inválido
- Tratamento de local em manutenção
- Conclusão do trajeto (chegada ao destino)

**Não inclui:**
- Testes de desempenho (RNF03) — já cobertos por execução simulada
- Testes de matriz de navegadores (RNF08) — já avaliados separadamente
- Testes de API/backend — já cobertos pelos 88 testes Python aprovados
- Testes de câmera óptica em dispositivo físico (depende de ambiente adequado)
- Coleta de métricas de satisfação (não é condição de aceite conforme `DECISOES.md` item 21)

---

## 3. Perfil e Quantidade de Participantes

| Parâmetro | Valor | Fonte |
|-----------|-------|-------|
| Quantidade | 5 participantes | `AUDITORIA_FASES_1-3.md` linha 89; `DECISOES.md` linha 43 |
| Treinamento prévio | Sem treinamento no sistema | `AUDITORIA_FASES_1-3.md` linha 89 |
| Recrutamento | Pendente — não foram recrutados participantes | `AUDITORIA_FASES_1-3.md` linha 89 |
| Anonimização | Resultados registrados de forma anonimizada | `AUDITORIA_FASES_1-3.md` linha 91 |

**Critérios de elegibilidade:**
- Não ter participado do desenvolvimento do projeto
- Não ter recebido treinamento ou instrução prévia sobre o aplicativo
- Ser maior de 18 anos (ou ter responsável legal presente)
- Ter visão suficiente para interagir com interface móvel (ou acompanhante de acessibilidade, se necessário)

---

## 4. Ambiente e Equipamentos Necessários

| Item | Status | Observação |
|------|--------|------------|
| Dispositivo móvel (smartphone ou tablet) com câmera | Pendente | Necessário para leitura óptica de QR Code |
| Aplicativo mobile instalado (Expo/React Native) | Pendente | Build nativo necessário; versão web não substitui execução nativa |
| QR Codes impressos (entrada e destino) | Pendente | Gerados pelo painel admin (`/admin/qr`) |
| Planta baixa do piso visível no mapa | Pendente | Configurada via `/admin/pisos` com `imagem_planta_url` |
| Servidor backend acessível | Pendente | Deve estar rodando na rede local do dispositivo |
| Rede Wi-Fi ou dados móveis | Pendente | Dispositivo deve alcançar o backend |
| Formulário de observação (impresso ou digital) | Pendente | Modelo na Seção 8 deste protocolo |
| Cronômetro/timer | Pendente | Para medição de tempo de conclusão |
| Caneta ou dispositivo para registro | Pendente | Para anotar erros e ajuda necessária |

**Nota sobre ambiente:** Conforme `AGENTS.md` linha 48-49, se não houver ambiente adequado (dispositivo/câmera), os testes devem ser reportados como não executados.

---

## 5. Tarefas Representativas dos Fluxos Reais

O roteiro segue a proposta de `AUDITORIA_FASES_1-3.md` linha 91. Cada tarefa deve ser executada sequencialmente por cada participante.

| Tarefa | Descrição | Fluxo do app | Critério de conclusão |
|--------|-----------|--------------|----------------------|
| T1 — Entrada via QR Code | Participante recebe QR de entrada e informa ao app (câmera ou digitação manual) | `scan.tsx` → `resolveQrCode` → `setOriginNode` | Origem definida e exibida no mapa |
| T2 — Busca de destino | Participante busca uma loja pelo nome na tela "Explorar" | `explore.tsx` → `listPois` → seleção de loja | Loja selecionada como destino |
| T3 — Filtro por categoria | Participante filtra lojas por categoria (opcional, observação) | `explore.tsx` → chips de categoria | Lista filtrada exibida |
| T4 — Cálculo de rota | App calcula rota entre origem e destino selecionados | `NavigationContext` → `calculateRoute` → `route-panel` | Painel de rota exibido com distância e instruções |
| T5 — QR Code inválido | Participante escaneia/digita um token inválido | `scan.tsx` → erro de resolução → "Tentar novamente" | Mensagem de erro exibida, app não trava |
| T6 — Local em manutenção | Participante seleciona loja com status "manutenção" | `explore.tsx` → badge "Em manutenção" → rota bloqueada | App informa indisponibilidade, não calcula rota |
| T7 — Conclusão do trajeto | Participante conclui a navegação (chegada ou "Cheguei ao destino") | `NavigationContext` → `completeNavigation` → `hasArrived = true` | Mensagem de chegada exibida |

---

## 6. Definição de Erro Crítico

Conforme `AUDITORIA_FASES_1-3.md` linha 89 e `DECISOES.md` linha 43, a definição de pronto exige **ausência de erros críticos**. Um erro crítico é definido como:

| Categoria | Descrição | Exemplo |
|-----------|-----------|---------|
| **Bloqueio de fluxo** | O participante não consegue prosseguir para a próxima tarefa sem intervenção do pesquisador | App trava ao ler QR Code; tela fica em branco sem recuperação |
| **Perda de dados** | Informação inserida pelo participante é perdida ou corrompida | Token digitado some; destino selecionado não é mantido |
| **Informação enganosa** | App exibe informação falsa que leva o participante a ação incorreta | Rota calculada para destino errado; status "Aberto" para loja fechada |
| **Falha de navegação** | Não é possível calcular ou exibir rota entre origem e destino válidos | `calculateRoute` retorna erro para nós conectados; mapa não renderiza |
| **Sem recuperação de erro** | Participante não consegue sair de um estado de erro sem reiniciar o app | Mensagem de erro sem botão "Tentar novamente"; tela congelada |

**Erros não críticos (registrados, mas não impedem aprovação):**
- Participante demora mais que o esperado para encontrar um botão
- Participante pede esclarecimento sobre terminologia
- Participante toca no elemento errado mas consegue corrigir sozinho
- Mensagem de erro exibida corretamente e participante se recupera sozinho

---

## 7. Instruções Neutras Fornecidas aos Participantes

O pesquisador deve ler o seguinte roteiro exatamente, sem acrescentar explicações sobre como usar o app:

> "Olá, obrigado por participar. Este teste avalia o aplicativo de navegação indoor, não o seu desempenho. Não há respostas certas ou erradas.
>
> Vou pedir que você execute algumas tarefas usando o app. Enquanto você faz, vou observar e anotar onde você tem dificuldade ou precisa de ajuda. Você pode parar a qualquer momento.
>
> Começando pela primeira tarefa: você recebeu um QR Code de entrada. Por favor, use o app para informar sua posição de partida usando esse código.
>
> Depois, procure uma loja específica pelo nome e defina-a como destino.
>
> Se houver opção de filtrar por categoria, sinta-se à vontade para experimentar.
>
> O app deve calcular uma rota até o destino. Acompanhe a rota no mapa.
>
> Em seguida, vou pedir que você tente usar um QR Code inválido e observe o que acontece.
>
> Também vou pedir que você tente selecionar uma loja que esteja em manutenção.
>
> Por fim, conclua a navegação (ou informe se não conseguir).
>
> Você tem dúvidas antes de começar?"

---

## 8. Formulário Individual de Observação

Um formulário deve ser preenchido para cada participante.

### 8.1 Dados da sessão

| Campo | Preenchimento |
|-------|---------------|
| ID do participante (anônimo, ex.: P01) | |
| Data e hora | |
| Dispositivo usado (modelo, SO) | |
| Nome do pesquisador | |
| Versão do app | |

### 8.2 Registro por tarefa

Para cada tarefa (T1–T7), o pesquisador registra:

| Tarefa | Concluída? (S/N) | Tempo (segundos) | Ajuda necessária? (S/N) | Tipo de ajuda | Erros observados | Erro crítico? (S/N) | Observações |
|--------|------------------|------------------|-------------------------|---------------|------------------|---------------------|-------------|
| T1 — Entrada via QR | | | | | | | |
| T2 — Busca de destino | | | | | | | |
| T3 — Filtro por categoria | | | | | | | |
| T4 — Cálculo de rota | | | | | | | |
| T5 — QR inválido | | | | | | | |
| T6 — Local em manutenção | | | | | | | |
| T7 — Conclusão do trajeto | | | | | | | |

**Tipos de ajuda:** verbal (explicação), gestual (apontar elemento), física (tocar no dispositivo), reinício do app.

### 8.3 Erros críticos observados

| # | Tarefa | Descrição do erro crítico | Categoria (bloqueio/perda/engano/navegação/sem recuperação) |
|---|--------|---------------------------|-------------------------------------------------------------|
| 1 | | | |
| 2 | | | |
| 3 | | | |

### 8.4 Resumo do participante

| Campo | Preenchimento |
|-------|---------------|
| Todas as tarefas concluídas? (S/N) | |
| Número total de erros críticos | |
| Participante precisou de ajuda para concluir alguma tarefa? (S/N) | |
| Comentários livres do participante (se espontâneos) | |

---

## 9. Tabela Consolidada de Resultados

A ser preenchida após todas as 5 sessões.

| Participante | T1 QR | T2 Busca | T3 Categoria | T4 Rota | T5 QR inválido | T6 Manutenção | T7 Chegada | Erros críticos | Ajuda necessária | Concluiu tudo? |
|--------------|-------|----------|--------------|---------|----------------|---------------|------------|----------------|------------------|----------------|
| P01 | | | | | | | | | | |
| P02 | | | | | | | | | | |
| P03 | | | | | | | | | | |
| P04 | | | | | | | | | | |
| P05 | | | | | | | | | | |
| **Total** | | | | | | | | | | |

**Métricas agregadas:**
- Taxa de conclusão geral: ___ / 5 participantes
- Número total de erros críticos: ___
- Participantes que concluíram todas as tarefas sem ajuda: ___
- Tempo médio de conclusão (T1–T4): ___ segundos

---

## 10. Critérios de Aprovação, Reprovação e Inconclusão

### 10.1 Aprovado

O RNF09 é considerado **aprovado** quando todos os seguintes critérios são atendidos:

1. Todos os 5 participantes foram executados (sem treinamento prévio)
2. **Zero erros críticos** observados em qualquer participante (conforme definição da Seção 6)
3. Resultados registrados de forma anonimizada em `evidence/rnf09-usabilidade.md`

### 10.2 Reprovado

O RNF09 é considerado **reprovado** quando:

1. Pelo menos um erro crítico foi observado em qualquer participante, **ou**
2. Não foi possível executar os 5 participantes (falta de participantes ou ambiente inadequado)

### 10.3 Inconclusivo

O RNF09 é considerado **inconclusivo** quando:

1. O ambiente necessário não está disponível (dispositivo/câmera/backend), conforme `AGENTS.md` linha 48
2. Os participantes foram recrutados mas não puderam completar as tarefas por fatores externos ao app (ex.: falha de rede, dispositivo sem bateria)
3. Resultados foram coletados mas não há clareza suficiente para classificar erros como críticos ou não críticos

### 10.4 Ações pós-avaliação

Conforme `AUDITORIA_FASES_1-3.md` linha 91:
- Classificar erros críticos
- Documentar correções/reteste antes do aceite
- Salvar resultados reais em `evidence/rnf09-usabilidade.md` (não preencher com dados simulados)

---

## 11. Preparação Técnica

### 11.1 Preparação concluída

| Item | Status | Evidência |
|------|--------|-----------|
| Documentação de requisitos (RNF09) | ✅ Disponível | `AUDITORIA_FASES_1-3.md` linhas 87-91; `DECISOES.md` item 21 |
| Fluxo de leitura de QR Code | ✅ Implementado | `mobile/app\(tabs)\scan.tsx` |
| Fluxo de busca de POI | ✅ Implementado | `mobile/app\(tabs)\explore.tsx`, `mobile/components/SearchBar.tsx` |
| Fluxo de cálculo de rota | ✅ Implementado | `mobile/context/NavigationContext.tsx`, `mobile/services/api.ts` |
| Fluxo de conclusão de navegação | ✅ Implementado | `mobile/app\(tabs)\index.tsx` (`completeNavigation`, `hasArrived`) |
| Testes de API aprovados | ✅ 88 passed | `backend/tests/` executado em 30/10/2026 |
| Testes E2E admin-crud aprovados | ✅ Chromium e WebKit | `admin-panel/tests/admin-crud.spec.ts` |
| Teste multiusuário aprovado | ✅ Chromium | `admin-panel/tests/multiuser.spec.ts` |

### 11.2 Dependências técnicas pendentes

| Dependência | Status | Necessária para |
|-------------|--------|-------------|
| Build nativo do app mobile (Android/iOS) | ❌ Não construído | Execução presencial em dispositivo físico |
| Câmera física para leitura óptica de QR | ❌ Não disponível | Leitura de QR Code via câmera (fallback: digitação manual) |
| Dispositivo móvel para participantes | ❌ Não disponível | Execução das 5 sessões |
| Backend acessível na rede local do dispositivo | ❌ Não configurado | App deve alcançar a API |
| QR Codes impressos (entrada e destino) | ❌ Não gerados | Tarefas T1, T5, T6 |
| Planta baixa configurada para pelo menos um piso | ⚠️ Parcial | `demo.svg` existe; verificar se há piso com plantas no banco de teste |
| Pelo menos uma loja com status "manutenção" | ⚠️ Parcial | Verificar no banco de teste |

### 11.3 Atividades que exigem participantes reais

Todas as atividades abaixo **não podem** ser executadas sem os 5 participantes:

1. Recrutamento de 5 pessoas sem treinamento
2. Assinatura de termo de consentimento (se aplicável)
3. Execução das 7 tarefas por cada participante
4. Registro de tempo, erros e ajuda necessária
5. Coleta de comentários espontâneos
6. Classificação de erros críticos vs não críticos
7. Preenchimento da tabela consolidada
8. Determinação de aprovação/reprovação/inconclusão

### 11.4 Resultados que só poderão ser registrados após execução presencial

| Resultado | Onde será registrado |
|-----------|---------------------|
| Tempos de conclusão por tarefa e participante | `evidence/rnf09-usabilidade.md` |
| Número de erros críticos por participante | `evidence/rnf09-usabilidade.md` |
| Taxa de conclusão geral | `evidence/rnf09-usabilidade.md` |
| Decisão de aprovação/reprovação/inconclusão | `evidence/rnf09-usabilidade.md` |
| Correções identificadas e reteste | `evidence/rnf09-usabilidade.md` + `DECISOES.md` (atualizar) |

---

## 12. Limitações Conhecidas

| Limitação | Impacto | Mitigação |
|-----------|---------|-----------|
| Não há dispositivo móvel disponível no ambiente atual | Não é possível executar o teste presencial | Reportar como não executado conforme `AGENTS.md` linha 48 |
| Não há câmera física para leitura óptica | A tarefa T1 pode ser executada via digitação manual do token | Documentar como alternativa aceitável no formulário |
| Não há participantes recrutados | Não é possível coletar dados reais | Não simular resultados; registrar como pendente |
| Não há MySQL configurado | O teste usa SQLite (não é homologação de produção) | Documentar como limitação, não bloqueador do RNF09 |
| Versão web do app não equivale a execução nativa | `DECISOES.md` item 22 | Priorizar build nativo quando disponível |

---

## 13. Próximo Passo

Quando o ambiente estiver disponível (dispositivo móvel, build nativo, backend acessível):

1. Recrutar 5 participantes sem treinamento
2. Executar o protocolo conforme Seções 5–9
3. Registrar resultados em `evidence/rnf09-usabilidade.md` (novo arquivo, não sobrescrever)
4. Classificar erros críticos conforme Seção 6
5. Atualizar `DECISOES.md` se houver correções decorrentes
6. Declarar RNF09 aprovado/reprovado/inconclusivo com base nos critérios da Seção 10

---

## 14. Estado do Git (momento da elaboração deste protocolo)

| Item | Valor |
|------|-------|
| Branch | `main` |
| Commit | `fdbf583` |
| `git status --short` | Apenas `admin-panel/tests/admin-crud.spec.ts` modificado (correção anterior validada) + arquivos de build estáticos pré-existentes + evidências anteriores |
| Nenhum commit ou push foi realizado | Conforme regras obrigatórias |

---

**Fim do protocolo. Nenhum dado de participante foi coletado. Nenhum arquivo de código foi modificado.**