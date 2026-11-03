package dev.arthurbretzke.pedidos.servico;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.Clock;
import java.time.LocalDate;

import org.springframework.stereotype.Service;

import dev.arthurbretzke.pedidos.dominio.Cupom;
import dev.arthurbretzke.pedidos.dominio.CupomExpiradoException;

/** Desconto do cupom: percentual sobre a base, válido até o dia de validade (inclusive). */
@Service
public class CupomService {

    private final Clock clock;

    public CupomService(Clock clock) {
        this.clock = clock;
    }

    public BigDecimal desconto(Cupom cupom, BigDecimal base) {
        if (cupom == null) {
            return BigDecimal.ZERO.setScale(2);
        }
        LocalDate hoje = LocalDate.now(clock);
        if (!hoje.isBefore(cupom.validoAte())) {
            throw new CupomExpiradoException(cupom.codigo());
        }
        return base.multiply(cupom.percentual())
                .divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_EVEN);
    }
}
