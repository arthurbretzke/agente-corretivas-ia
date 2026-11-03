package dev.arthurbretzke.pedidos.servico;

import static org.assertj.core.api.Assertions.assertThat;

import java.math.BigDecimal;

import org.junit.jupiter.api.Test;

class TaxaEntregaServiceTest {

    private final TaxaEntregaService service = new TaxaEntregaService();

    @Test
    void freteGratisParaPedidoAcimaDoMinimo() {
        assertThat(service.calcular(new BigDecimal("60.00"), 8)).isEqualByComparingTo("0.00");
    }

    @Test
    void cobraSoTaxaBaseAteDoisKm() {
        assertThat(service.calcular(new BigDecimal("20.00"), 1.5)).isEqualByComparingTo("5.00");
    }

    @Test
    void cobraKmExtraAcimaDeDoisKm() {
        assertThat(service.calcular(new BigDecimal("20.00"), 4)).isEqualByComparingTo("8.00");
    }
}
