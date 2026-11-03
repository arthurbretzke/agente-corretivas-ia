# Conceitos estudados

Alimentado ao fim de cada explicação do modo professor (item "Conceitos"). Regras na skill `modo-professor`.

- Conceito já listado: não duplicar; somar 1 em `vistos`.
- `intervalo` (dias): 1 → 3 → 7 → 21. Acertou: avança e `proxima` = hoje + intervalo. Errou: volta para 1 e soma
  1 em `erros`. Depois de acertar com 21, fica em 21.
- Datas em AAAA-MM-DD. Contexto genérico (processo, tipo de bug).
- Vencidos: `bash scripts/vencidos.sh` (os 2 mais atrasados).

## Estudar

Conceitos com `vistos` >= 3 ou `erros` >= 2.

- _nenhum ainda_

## Conceitos

| conceito | contexto | pergunta de revisão | vistos | intervalo | proxima | erros | criado |
|---|---|---|---|---|---|---|---|
| limite inclusivo × exclusivo | entrega grátis "a partir de R$ 50" que não valia com R$ 50,00 | Qual teste pega um `>` que deveria ser `>=`? | 1 | 1 | 2026-11-04 | 0 | 2026-11-03 |
| relógio injetável (Clock) | validade de cupom testada em data fixa | Por que injetar `Clock` em vez de chamar `LocalDate.now()`? | 1 | 1 | 2026-11-04 | 0 | 2026-11-03 |
| BigDecimal e escala | soma de valores monetários do pedido | Por que `isEqualByComparingTo` e não `isEqualTo` para comparar `BigDecimal`? | 1 | 1 | 2026-11-04 | 0 | 2026-11-03 |
