# Fechamento do pedido

- **Entrada**: `POST /pedidos/resumo` (`PedidoController`)
- **Classes**: `PedidoService` (orquestra), `TaxaEntregaService` (taxa), `CupomService` (desconto)
- **Confiança**: alta
- **Última validação**: 2026-11-03 · criação do app
- **validado_em**: app@- 2026-11-03

## Regras de negócio (comportamento esperado)

1. **Subtotal** = soma de preço unitário × quantidade de cada item, 2 casas decimais.
2. **Taxa de entrega** (`TaxaEntregaService`):
   - grátis quando o subtotal é **R$ 50,00 ou mais**;
   - senão, R$ 5,00 + R$ 1,50 por km acima de 2 km.
3. **Cupom** (`CupomService`):
   - percentual aplicado **somente sobre o subtotal dos itens**, nunca sobre a taxa de entrega;
   - válido **até o fim do dia** de `validoAte` (o último dia vale);
   - vencido: resposta 422 com a mensagem "Cupom <código> expirado".
4. **Total** = subtotal + taxa − desconto.

## Testes

`app/src/test/java/dev/arthurbretzke/pedidos/servico/`: um `<Classe>Test` por serviço. Correção nova entra como
método novo na classe de teste do serviço corrigido.

## Observações

Datas vêm do `Clock` injetado (`PedidosApplication.clock`, fuso America/Sao_Paulo). Teste que depende do dia de
hoje deve usar `Clock.fixed`.
