# Classes de defeito

Tipos de defeito que **já apareceram** neste projeto. Servem para dois momentos:

1. **Investigação:** o sintoma da issue bate com o sintoma típico de uma classe? Comece pelo padrão de código dela.
2. **Caça a bugs irmãos (`#irmaos`):** com a causa confirmada, enquadre o defeito numa classe e rode o padrão de
   busca dela no resto do código. Pare em ~15 ocorrências. Não corrija: liste `arquivo:linha`, risco e motivo.

Regras do catálogo:
- Só entra classe com evidência real (uma issue ou caso de avaliação). Não é lista teórica de bugs.
- Classe nova: uma seção neste formato e uma linha na tabela.
- Os padrões são heurísticas para começar a busca, não prova.

| Classe | Sintoma típico | Exemplos |
|---|---|---|
| [limite-inclusivo-trocado](#limite-inclusivo-trocado) | Regra falha exatamente no valor ou na data do limite | casos 01 e 02 |
| [base-de-calculo-errada](#base-de-calculo-errada) | Percentual certo, valor final errado | caso 03 |

## limite-inclusivo-trocado

- **Sintoma:** "a partir de R$ 50" não vale com R$ 50,00; "válido até dia 3" recusa no dia 3.
- **Mecanismo:** comparação estrita onde a regra é inclusiva (`>` no lugar de `>=`, `isBefore` negado no lugar de
  `isAfter`).
- **Padrão de busca:** `grep -rnE "compareTo\([^)]*\) *[<>] *0|!.*\.is(Before|After)\(" app/src/main`
- **Teste que pega:** um caso exatamente no limite, além dos casos acima e abaixo.

## base-de-calculo-errada

- **Sintoma:** desconto, imposto ou comissão com valor diferente do anunciado, embora o percentual esteja certo.
- **Mecanismo:** o percentual é aplicado sobre uma base que já inclui outro valor (taxa, desconto anterior).
- **Padrão de busca:** `grep -rnE "(desconto|percentual|imposto|comissao)[A-Za-z]*\([^;]*\.add\(" app/src/main`
  e revisar cada chamada que recebe uma soma como base.
- **Teste que pega:** cenário em que os dois componentes da base são diferentes de zero (com taxa **e** cupom).
