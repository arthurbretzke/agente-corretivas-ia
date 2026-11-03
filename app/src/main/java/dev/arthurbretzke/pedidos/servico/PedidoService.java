package dev.arthurbretzke.pedidos.servico;

import java.math.BigDecimal;
import java.math.RoundingMode;

import org.springframework.stereotype.Service;

import dev.arthurbretzke.pedidos.dominio.Item;
import dev.arthurbretzke.pedidos.dominio.Pedido;
import dev.arthurbretzke.pedidos.dominio.Resumo;

/** Fecha o pedido: subtotal dos itens, taxa de entrega, desconto do cupom e total. */
@Service
public class PedidoService {

    private final TaxaEntregaService taxaEntrega;
    private final CupomService cupons;

    public PedidoService(TaxaEntregaService taxaEntrega, CupomService cupons) {
        this.taxaEntrega = taxaEntrega;
        this.cupons = cupons;
    }

    public Resumo resumir(Pedido pedido) {
        BigDecimal subtotal = pedido.itens().stream()
                .map(Item::total)
                .reduce(BigDecimal.ZERO, BigDecimal::add)
                .setScale(2, RoundingMode.HALF_EVEN);
        BigDecimal taxa = taxaEntrega.calcular(subtotal, pedido.distanciaKm());
        BigDecimal desconto = cupons.desconto(pedido.cupom(), subtotal.add(taxa));
        return new Resumo(subtotal, taxa, desconto, subtotal.add(taxa).subtract(desconto));
    }
}
