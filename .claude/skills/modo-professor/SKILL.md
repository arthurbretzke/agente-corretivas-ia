---
name: modo-professor
description: >-
  Explicação didática ao fim de toda correção (causa raiz, investigação, correção, alternativas, conceitos,
  prevenção) e o sistema de aprendizado: registro de conceitos, revisão espaçada e calibração de palpites. Use
  ao entregar qualquer correção fora do #rapido, ou quando o humano responder uma pergunta de revisão.
---

# Modo professor

Quem corrige com IA precisa entender a correção, não só recebê-la. Esta skill transforma cada bug em material
de estudo e mede a evolução de quem aprende.

## 1. Explicação (6 itens, completos)

1. **Causa raiz:** o que estava errado e **por que** o bug acontecia, não só onde.
2. **Investigação:** que pistas levaram ao problema.
3. **Correção:** o que mudou e por que resolve, com o trecho antes e depois.
4. **Alternativas:** outras formas de resolver e por que esta foi a escolhida.
5. **Conceitos:** os termos técnicos envolvidos, para estudar depois.
6. **Prevenção:** como evitar ou detectar esse tipo de bug sozinho.

Estilo:
- Blocos curtos, listas e **negrito no ponto principal** de cada item.
- Uma **analogia** para o conceito central, desde que corresponda ao mecanismo real (o que causa o quê). Depois
  dela, ligue cada parte ao código. Se nenhuma analogia encaixar, não force.
- Termos técnicos corretos, definidos na primeira vez.
- Nunca número solto: diga o que é cada valor ("taxa de R$ 5,00, esperado R$ 0,00", não "5 → 0").

## 2. Registro de conceitos

Ao fim da explicação, cada item de "Conceitos" entra na tabela de `aprendizado/conceitos.md`:
`conceito | contexto genérico | pergunta de revisão | vistos | intervalo | proxima | erros | criado`, com
`intervalo` 1 e `proxima` = amanhã. Conceito que já existe não duplica: soma 1 em `vistos`.

## 3. Revisão espaçada

No fim da entrega, rode `bash scripts/vencidos.sh` e mostre "Revisão (1 min, opcional)" com até 2 perguntas
vencidas (sem vencidos, omita o bloco). Se o humano responder:
- **acertou:** o intervalo avança (1 → 3 → 7 → 21 dias) e `proxima` = hoje + intervalo;
- **errou:** o intervalo volta para 1 e `erros` soma 1. Corrija a resposta em 1 ou 2 linhas.

Conceitos com `vistos` >= 3 ou `erros` >= 2 formam a seção "Estudar". Mostre a lista só quando ela mudar.

## 4. Calibração

Se o humano deu palpite na triagem (causa provável e tempo), registre em `aprendizado/calibracao.md`
(`data | issue | palpite | real | causa: acertou/parcial/errou | tempo estimado × real`) e mostre "palpite × real"
em uma linha. A cada 10 registros, mostre a tendência: acerto de causa em % e erro médio de tempo.

## 5. `#eu-primeiro`

Depois da investigação e antes da correção, avalie o raciocínio do humano: o que acertou, o que deixou passar,
qual pista ignorou e uma nota de 0 a 5 (vai para a calibração). Na implementação, deixe 1 a 3 trechos-chave como
`TODO(human)` com uma dica e revise o que ele escrever. `confere-commit.sh` barra `TODO(human)` no commit.
