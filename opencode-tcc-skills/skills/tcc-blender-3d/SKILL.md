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
