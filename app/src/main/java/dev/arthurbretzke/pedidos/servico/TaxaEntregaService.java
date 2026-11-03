package dev.arthurbretzke.pedidos.servico;

import java.math.BigDecimal;
import java.math.RoundingMode;

import org.springframework.stereotype.Service;

/** Taxa de entrega: grátis a partir de R$ 50; senão R$ 5 + R$ 1,50 por km acima de 2 km. */
@Service
public class TaxaEntregaService {

    static final BigDecimal FRETE_GRATIS_A_PARTIR_DE = new BigDecimal("50.00");
    static final BigDecimal TAXA_BASE = new BigDecimal("5.00");
    static final BigDecimal POR_KM_EXTRA = new BigDecimal("1.50");
    static final double KM_INCLUSOS = 2.0;

    public BigDecimal calcular(BigDecimal subtotal, double distanciaKm) {
        if (subtotal.compareTo(FRETE_GRATIS_A_PARTIR_DE) > 0) {
            return BigDecimal.ZERO.setScale(2);
        }
        double kmExtra = Math.max(0, distanciaKm - KM_INCLUSOS);
        return TAXA_BASE.add(POR_KM_EXTRA.multiply(BigDecimal.valueOf(kmExtra)))
                .setScale(2, RoundingMode.HALF_EVEN);
    }
}
