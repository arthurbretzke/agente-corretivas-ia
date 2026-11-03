package dev.arthurbretzke.pedidos.servico;

import static org.assertj.core.api.Assertions.assertThat;

import java.math.BigDecimal;
import java.time.Clock;
import java.time.LocalDate;
import java.time.ZoneOffset;
import java.util.List;

import org.junit.jupiter.api.Test;

import dev.arthurbretzke.pedidos.dominio.Cupom;
import dev.arthurbretzke.pedidos.dominio.Item;
import dev.arthurbretzke.pedidos.dominio.Pedido;
import dev.arthurbretzke.pedidos.dominio.Resumo;

class PedidoServiceTest {

    static final LocalDate HOJE = LocalDate.of(2026, 11, 3);

    private final PedidoService service = new PedidoService(
            new TaxaEntregaService(),
            new CupomService(Clock.fixed(HOJE.atStartOfDay().toInstant(ZoneOffset.UTC), ZoneOffset.UTC)));

    @Test
    void somaItensETaxaSemCupom() {
        Pedido pedido = new Pedido(List.of(new Item("Pastel", 2, new BigDecimal("15.00"))), 1, null);

        Resumo resumo = service.resumir(pedido);

        assertThat(resumo.subtotal()).isEqualByComparingTo("30.00");
        assertThat(resumo.taxaEntrega()).isEqualByComparingTo("5.00");
        assertThat(resumo.total()).isEqualByComparingTo("35.00");
    }

    @Test
    void cupomComFreteGratis() {
        Cupom dezPorCento = new Cupom("BEMVINDO10", new BigDecimal("10"), HOJE.plusDays(5));
        Pedido pedido = new Pedido(List.of(new Item("Pizza", 1, new BigDecimal("60.00"))), 3, dezPorCento);

        Resumo resumo = service.resumir(pedido);

        assertThat(resumo.desconto()).isEqualByComparingTo("6.00");
        assertThat(resumo.total()).isEqualByComparingTo("54.00");
    }
}
