package dev.arthurbretzke.pedidos.dominio;

/** Cupom usado depois da data de validade. */
public class CupomExpiradoException extends RuntimeException {

    public CupomExpiradoException(String codigo) {
        super("Cupom " + codigo + " expirado");
    }
}
