package dev.arthurbretzke.pedidos.servico;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import java.math.BigDecimal;
import java.time.Clock;
import java.time.LocalDate;
import java.time.ZoneOffset;

import org.junit.jupiter.api.Test;

import dev.arthurbretzke.pedidos.dominio.Cupom;
import dev.arthurbretzke.pedidos.dominio.CupomExpiradoException;

class CupomServiceTest {

    static final LocalDate HOJE = LocalDate.of(2026, 11, 3);

    private final CupomService service = new CupomService(
            Clock.fixed(HOJE.atStartOfDay().toInstant(ZoneOffset.UTC), ZoneOffset.UTC));

    @Test
    void semCupomNaoDaDesconto() {
        assertThat(service.desconto(null, new BigDecimal("40.00"))).isEqualByComparingTo("0.00");
    }

    @Test
    void aplicaPercentualSobreABase() {
        Cupom dezPorCento = new Cupom("BEMVINDO10", new BigDecimal("10"), HOJE.plusDays(10));
        assertThat(service.desconto(dezPorCento, new BigDecimal("40.00"))).isEqualByComparingTo("4.00");
    }

    @Test
    void recusaCupomVencido() {
        Cupom vencido = new Cupom("ONTEM", new BigDecimal("10"), HOJE.minusDays(1));
        assertThatThrownBy(() -> service.desconto(vencido, new BigDecimal("40.00")))
                .isInstanceOf(CupomExpiradoException.class);
    }
}
