---
name: impacto-contrato
description: >-
  Analisa o impacto de uma nova versão de um contrato de API (OpenAPI em JSON) no código — diff dos schemas,
  matriz campo → código, um analista por tarefa em paralelo, revisor que tenta refutar e relatório com
  arquivo:linha. Use para "o que muda no código com a v2 da API?". Só sinaliza; não altera código.
---

# Impacto de contrato

Entrada: `<api> <versão anterior> <versão nova>` (ex.: `pedidos-api v1 v2`). Pastas:
- `A = contratos/<api>/<anterior>.json`, `N = contratos/<api>/<nova>.json`
- `O = contratos/<api>/impacto-<anterior>-para-<nova>/`

Espere cada etapa terminar antes da próxima. **Não altere código em nenhuma etapa.**

1. **Conferir entrada:** `A` e `N` existem. Rode `python -I scripts/contrato/impacto.py --teste`; se não imprimir
   `ok`, pare e mostre a saída.
2. **Diff e matriz:**
   `python -I scripts/contrato/impacto.py --anterior A --novo N --codigo app/src --saida O/tarefas.json`.
   Cada tarefa é um schema com as mudanças dele, onde ele é definido no código e onde cada campo aparece.
3. **Gate:** mostre o total de mudanças, de tarefas e quantas ficaram `sem_classe` (schema que o código não
   define). Mais de 15 tarefas: pare e espere confirmação antes do fan-out.
4. **Análise:** um agente `analista-contrato` por tarefa, **em paralelo**. Passe o caminho do `tarefas.json`, o id
   da tarefa, o caminho de `N` e a saída `O/analise/<id>.json`. Espere todos.
5. **Revisão:** um agente `revisor-contrato` com as pastas `O` e `N`. Espere `O/revisao.json`.
6. **Relatório** em `O/relatorio.md`, nesta ordem:
   - resumo: versões comparadas e total por classificação final (depois da revisão);
   - tabela `alterar` + `desenvolvimento_novo`: id, schema.campo, o que muda no contrato, `arquivo:linha`, o que
     mudar, teste sugerido, confiança;
   - `sem_cobertura` (buracos da matriz);
   - itens corrigidos pelo revisor: classificação original × corrigida, com o motivo;
   - `ja_atende` e `nao_se_aplica`, uma linha cada.
7. Mostre o caminho do relatório e os números do resumo. Cada item `alterar` ou `desenvolvimento_novo` vira
   melhoria pela skill `especificar-melhoria` só quando o humano pedir.

Ambiguidade reportada por um agente (campo citado em dois lugares com usos diferentes, regra que o contrato não
explica): pare e pergunte. Não deixe o agente decidir sozinho.
