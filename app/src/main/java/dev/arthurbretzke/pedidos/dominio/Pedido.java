package dev.arthurbretzke.pedidos.dominio;

import java.util.List;

/** Pedido a fechar: itens, distância da entrega e cupom opcional (pode ser nulo). */
public record Pedido(List<Item> itens, double distanciaKm, Cupom cupom) {
}
