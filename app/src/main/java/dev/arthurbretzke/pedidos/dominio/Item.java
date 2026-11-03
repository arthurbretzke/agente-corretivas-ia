package dev.arthurbretzke.pedidos.dominio;

import java.math.BigDecimal;

/** Item do carrinho. */
public record Item(String nome, int quantidade, BigDecimal precoUnitario) {

    /** Valor do item: preço unitário vezes a quantidade. */
    public BigDecimal total() {
        return precoUnitario.multiply(BigDecimal.valueOf(quantidade));
    }
}
