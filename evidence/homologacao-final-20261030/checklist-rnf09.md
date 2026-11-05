# Lista de Verificação — RNF09: Usabilidade Presencial

**Projeto:** Navegação-Indoor-3D (TCC)  
**Requisito:** RNF09 — A interface deve ser simples o suficiente para uso sem treinamento.  
**Critério (especificação):** Teste de usabilidade com 5 usuários sem instrução.  
**Definição de pronto:** Ausência de erros críticos.  
**Branch:** `main`  
**Commit:** `fdbf583`  
**Data:** 30/10/2026  
**Arquivo:** `evidence/homologacao-final-20261030/checklist-rnf09.md`  
**Status:** Preparatório — não executa validação por si só

---

## 1. Contexto

Conforme `AUDITORIA_FASES_1-3.md` linhas 87-91:
> RNF09: **PENDENTE.** Não foram recrutados participantes nem coletados tempos, satisfação ou resultados neste ambiente. A especificação pede cinco usuários sem treinamento; a definição de pronto exige ausência de erros críticos. O critério anterior "4/5 concluem e satisfação ≥ 4/5" não vem da especificação e foi removido como condição de aceite.
>
> Roteiro proposto, ainda não executado: entregar QR de entrada, pedir localização de uma loja, observar busca e categoria, reação a QR inválido/local em manutenção e conclusão do trajeto. Registrar ajuda necessária, conclusão, tempos e erros de forma anonimizada. Classificar erros críticos e documentar correções/reteste antes do aceite. Salvar resultados reais em `evidence/rnf09-usabilidade.md` quando existirem; esse arquivo não foi preenchido com dados simulados.

Conforme `DECISOES.md` item 21:
> Permanece pendente até teste com cinco usuários sem treinamento. A definição de pronto exige ausência de erros críticos. O antigo critério de 4/5 conclusões e satisfação ≥ 4/5 não constava na especificação e não é adotado como substituto. Não há resultados de participantes neste repositório.

---

## 2. Protocolo Preparado

O protocolo completo está em:
`evidence/rnf09-usabilidade-protocolo/protocolo-usabilidade-rnf09.md`

Este documento contém:
- Objetivo e escopo
- Perfil e quantidade de participantes (5 pessoas sem treinamento)
- Ambiente e equipamentos necessários
- 7 tarefas representativas (T1 a T7)
- Instruções neutras para participantes
- Formulário individual de observação
- Tabela consolidada de resultados
- Critérios de aprovação, reprovação e inconclusão
- Definição de erro crítico

---

## 3. Checklist de Execução (Para o SENAI)

### 3.1 Participantes

| Participante | ID anônimo | Sem treinamento? | Data | Horário | Dispositivo |
|--------------|------------|------------------|------|---------|-------------|
| 1 | P01 | ☐ Sim ☐ Não | | | |
| 2 | P02 | ☐ Sim ☐ Não | | | |
| 3 | P03 | ☐ Sim ☐ Não | | | |
| 4 | P04 | ☐ Sim ☐ Não | | | |
| 5 | P05 | ☐ Sim ☐ Não | | | |

**Critério:** Todos os 5 participantes devem ser sem treinamento prévio no sistema.

### 3.2 Ambiente e Equipamentos

| Item | Status | Observação |
|------|--------|------------|
| Dispositivo móvel com câmera | ☐ Disponível ☐ Não disponível | Necessário para leitura óptica de QR Code |
| App mobile instalado (build nativo) | ☐ Disponível ☐ Não disponível | Versão web não substitui execução nativa |
| QR Codes impressos (entrada e destino) | ☐ Gerados ☐ Não gerados | Gerados pelo painel admin (`/admin/qr`) |
| Backend acessível na rede local | ☐ Acessível ☐ Não acessível | Deve estar rodando na rede do dispositivo |
| Formulário de observação | ☐ Preparado ☐ Não preparado | Modelo no protocolo |
| Cronômetro | ☐ Disponível ☐ Não disponível | Para medição de tempo |
| Anonimização garantida | ☐ Sim ☐ Não | Resultados registrados de forma anonimizada |

### 3.3 Tarefas a Executar (por participante)

| Tarefa | Descrição | Concluído? | Tempo (s) | Ajuda necessária? | Erro crítico? |
|--------|-----------|------------|-----------|-------------------|---------------|
| T1 | Entrada via QR Code | ☐ Sim ☐ Não | | ☐ Sim ☐ Não | ☐ Sim ☐ Não |
| T2 | Busca de destino | ☐ Sim ☐ Não | | ☐ Sim ☐ Não | ☐ Sim ☐ Não |
| T3 | Filtro por categoria | ☐ Sim ☐ Não | | ☐ Sim ☐ Não | ☐ Sim ☐ Não |
| T4 | Cálculo de rota | ☐ Sim ☐ Não | | ☐ Sim ☐ Não | ☐ Sim ☐ Não |
| T5 | QR Code inválido | ☐ Sim ☐ Não | | ☐ Sim ☐ Não | ☐ Sim ☐ Não |
| T6 | Local em manutenção | ☐ Sim ☐ Não | | ☐ Sim ☐ Não | ☐ Sim ☐ Não |
| T7 | Conclusão do trajeto | ☐ Sim ☐ Não | | ☐ Sim ☐ Não | ☐ Sim ☐ Não |

---

## 4. Critérios de Aprovação RNF09

| Critério | Como verificar | Status alvo |
|----------|---------------|-------------|
| 5 participantes executados | Todos os 5 IDs preenchidos | ✅ 5 participantes |
| Participantes sem treinamento | Nenhum teve treinamento prévio | ✅ 5 sem treinamento |
| Zero erros críticos | Nenhum erro crítico em qualquer participante | ✅ 0 erros críticos |
| Resultados anonimizados | Salvos em `evidence/rnf09-usabilidade.md` | ✅ Arquivo criado |
| Não usar critério "4/5 e satisfação ≥ 4/5" | Não aplicado (removido como condição) | ✅ Não aplicado |

**Aprovação:** RNF09 aprovado apenas se todos os 5 critérios acima forem atendidos.

**Reprovação:** Pelo menos um erro crítico observado, ou menos de 5 participantes executados.

**Inconclusivo:** Ambiente não disponível, ou resultados insuficientes para classificar erros.

---

## 5. Definição de Erro Crítico

| Categoria | Descrição | Exemplo |
|-----------|-----------|---------|
| Bloqueio de fluxo | Participante não consegue prosseguir sem intervenção | App trava ao ler QR Code; tela fica em branco |
| Perda de dados | Informação inserida é perdida ou corrompida | Token digitado some; destino não é mantido |
| Informação enganosa | App exibe informação falsa | Rota para destino errado; status "Aberto" para loja fechada |
| Falha de navegação | Não é possível calcular ou exibir rota válida | `calculateRoute` retorna erro para nós conectados |
| Sem recuperação de erro | Não consegue sair de erro sem reiniciar app | Mensagem sem botão "Tentar novamente"; tela congelada |

---

## 6. Resultado a Registrar

Após execução, criar arquivo `evidence/rnf09-usabilidade.md` com:

| Campo | Valor |
|-------|-------|
| Data e hora de execução | |
| Quantidade de participantes | 5 |
| Participantes sem treinamento | 5 |
| Total de erros críticos | |
| Taxa de conclusão geral | __ / 5 |
| Participantes sem ajuda | |
| Tempo médio de conclusão (T1-T4) | |
| Decisão | ☐ Aprovado ☐ Reprovado ☐ Inconclusivo |
| Correções identificadas | |
| Reteste necessário? | ☐ Sim ☐ Não |

**Não preencher com dados simulados.** (conforme `AUDITORIA_FASES_1-3.md` linha 91)

---

## 7. Pendências

| Item | Descrição |
|------|-----------|
| Recrutar 5 participantes | Não realizado |
| Dispositivo móvel com câmera | Não disponível no ambiente atual |
| Build nativo do app | Não construído |
| Backend acessível na rede local | Não configurado |
| QR Codes impressos | Não gerados |
| Execução das 5 sessões | Não realizada |
| Registro de resultados em `evidence/rnf09-usabilidade.md` | Não realizado |

---

## 7. Arquivos de Evidência Associados

| Arquivo | Conteúdo |
|---------|----------|
| `evidence/rnf09-usabilidade-protocolo/protocolo-usabilidade-rnf09.md` | Protocolo completo de usabilidade |
| `evidence/homologacao-final-20261030/checklist-rnf09.md` | Este checklist (preparatório) |
| `evidence/rnf09-usabilidade.md` | Resultados reais (a ser preenchido após execução — NÃO criar com dados simulados) |
