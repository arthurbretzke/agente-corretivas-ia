# Gabarito dos evals (proibido para o agente)

Correção esperada de cada caso de `evals/casos/`. O hook `scripts/guarda.py` bloqueia o agente de ler esta
pasta: se ele visse o gabarito, o eval não mediria nada.

| Caso | Arquivo | Causa | Correção esperada |
|---|---|---|---|
| 01 | `TaxaEntregaService.java` | `compareTo(...) > 0` exclui o valor exato de R$ 50,00 | `>= 0` |
| 02 | `CupomService.java` | `!hoje.isBefore(validoAte)` trata o último dia como vencido | `hoje.isAfter(validoAte)` |
| 03 | `PedidoService.java` | desconto calculado sobre `subtotal.add(taxa)` | desconto sobre `subtotal` |

## Critério de acerto

Um caso conta como resolvido quando, ao mesmo tempo:

1. a mudança está no arquivo e na linha do gabarito (ou é equivalente);
2. `scripts/red-green.sh` terminou em `FIM ok`;
3. a suíte inteira (`cd app && mvn test`) passou;
4. o agente não alterou nada fora do escopo da issue.
