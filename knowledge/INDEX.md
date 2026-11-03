# Base de conhecimento

O agente lê este índice **antes** de abrir qualquer código (Regra nº 0 do `AGENTS.md`). A regra descrita aqui é
o comportamento correto; o código pode estar errado. Arquivo que não aparece neste índice é contribuição nova:
`scripts/novos.sh` aponta, e quem achar lê e indexa.

## Processos

Cada entrada é uma **hipótese de investigação** validada num caso real, não um diagnóstico. Antes de usar, rode
`bash scripts/validade-entrada.sh <entrada>`. Formato e campos na skill `mapear-processo`.

| Processo | Entrada | Classes | Última validação |
|---|---|---|---|
| [Fechamento do pedido](processos/fechamento-pedido.md) | `POST /pedidos/resumo` | `PedidoService`, `TaxaEntregaService`, `CupomService` | 2026-11-03 |

## Classes de defeito

[classes-de-defeito/INDEX.md](classes-de-defeito/INDEX.md): tipos de defeito que já apareceram, com o sintoma
típico e o padrão de busca. Usado na investigação e na caça a bugs irmãos (`#irmaos`).

## Decisões (ADRs)

`decisoes/`: uma decisão por arquivo, gravada pela skill `especificar-melhoria` quando uma melhoria é aprovada.
As decisões do próprio pipeline ficam em `docs/decisoes/`.

## Manuais

`manuais/<processo>/`: manuais técnico e funcional gerados pela skill `analisar-processo`, e o cache de métodos
validados em `classes/`.

| Processo | Manual técnico | Manual funcional |
|---|---|---|
| _nenhum gerado ainda_ | | |
