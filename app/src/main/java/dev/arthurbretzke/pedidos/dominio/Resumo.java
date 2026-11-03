package dev.arthurbretzke.pedidos.dominio;

import java.math.BigDecimal;

/** Valores que o cliente vê antes de confirmar o pedido. */
public record Resumo(BigDecimal subtotal, BigDecimal taxaEntrega, BigDecimal desconto, BigDecimal total) {
}
