# 003: Replay de bugs conhecidos como avaliação

**Contexto.** Sem medida, não dá para saber se uma mudança no prompt ou numa fase melhorou ou piorou o agente.

**Decisão.** Bugs com correção conhecida ficam em `evals/casos/` e o gabarito em `evals/gabarito/`. O modo
`replay` roda o pipeline no caso, e um hook impede o agente de ler o gabarito. O resultado entra em
`evals/resultados.md`.

**Consequências.** Toda mudança no pipeline pode ser comparada com a anterior nos mesmos casos. O limite é o
tamanho do conjunto: 3 casos mostram o mecanismo, mas não são estatística.
