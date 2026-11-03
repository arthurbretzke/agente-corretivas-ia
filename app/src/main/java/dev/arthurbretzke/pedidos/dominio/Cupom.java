package dev.arthurbretzke.pedidos.dominio;

import java.math.BigDecimal;
import java.time.LocalDate;

/** Cupom de desconto percentual, válido até a data informada (inclusive). */
public record Cupom(String codigo, BigDecimal percentual, LocalDate validoAte) {
}
