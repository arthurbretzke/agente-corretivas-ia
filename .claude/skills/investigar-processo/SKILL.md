---
name: investigar-processo
description: Consulta a base de processos ao iniciar a investigação de uma issue, para começar pelas classes já mapeadas em vez de buscar no projeto inteiro. Use logo depois da triagem de um bug.
---

# Investigar processo

1. Procure o processo da issue na tabela de `knowledge/INDEX.md` (cada entrada fica em
   `knowledge/processos/<slug>.md`) e nos manuais de `knowledge/manuais/`.
2. **Achou a entrada:** use como hipótese inicial e vá direto às classes indicadas. Rode
   `bash scripts/validade-entrada.sh <entrada>` antes. Confirme lendo o código real: nunca declare "o problema
   é aqui" só porque bate com a base; diga "vou começar por X porque a base indica Y".
3. **Confiança "gerado por varredura automática":** trate como sugestão de onde olhar, não como pista confirmada.
4. **Não achou:** busca direcionada no pacote mais provável, por nome de classe ou de regra. Busca ampla só se a
   direcionada falhar, delegada ao agente `explorador-spring`.
5. **Sintoma bate com uma linha de `lacunas:` ou `reincidencias:` da entrada:** a causa provável já está
   registrada. Comece por ela.
6. Problema com várias camadas ou efeito colateral difícil de rastrear: avise o humano em vez de insistir; pode
   valer trocar para um modelo maior.
7. No fim, pergunte se deve registrar ou atualizar a entrada (skill `mapear-processo`).
