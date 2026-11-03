package dev.arthurbretzke.pedidos.api;

import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import dev.arthurbretzke.pedidos.dominio.CupomExpiradoException;
import dev.arthurbretzke.pedidos.dominio.Pedido;
import dev.arthurbretzke.pedidos.dominio.Resumo;
import dev.arthurbretzke.pedidos.servico.PedidoService;

/** POST /pedidos/resumo: devolve subtotal, taxa, desconto e total do carrinho. */
@RestController
@RequestMapping("/pedidos")
public class PedidoController {

    private final PedidoService pedidos;

    public PedidoController(PedidoService pedidos) {
        this.pedidos = pedidos;
    }

    @PostMapping("/resumo")
    public Resumo resumo(@RequestBody Pedido pedido) {
        return pedidos.resumir(pedido);
    }

    /** Cupom vencido vira 422 com a mensagem, em vez de erro 500. */
    @ExceptionHandler(CupomExpiradoException.class)
    @ResponseStatus(HttpStatus.UNPROCESSABLE_ENTITY)
    Map<String, String> cupomExpirado(CupomExpiradoException e) {
        return Map.of("erro", e.getMessage());
    }
}
