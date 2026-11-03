# CLAUDE.md

@AGENTS.md

As regras compartilhadas com outras ferramentas estão no `AGENTS.md` acima. Aqui fica só o que é do Claude Code.

## Regras do agente

- **O script prova, o modelo não afirma.** Nunca escreva "teste passou" sem a saída `FIM ok` do script.
- **Gabarito proibido.** `evals/gabarito/` guarda a correção esperada de cada caso de avaliação. Ler essa pasta
  invalida o eval; o hook `scripts/guarda.py` bloqueia o acesso.

## Fluxo automático por momento da issue

- **Issue chega** ("corrigir issue 12", link de issue, relato de bug): primeira resposta = bloco de triagem da
  skill `triagem`. Melhoria ou mudança de regra: skill `especificar-melhoria` (plano, para e espera aprovação).
- **Sem intervenção humana:** `corrigir issue <n>` roda a skill `corrigir-issue` até o PR rascunho.
- **Entrega da correção** (fluxo humano): blocos da seção "Entrega" da skill `triagem`, depois o modo professor.
- **"pode seguir"** depois da aprovação: skill `fechar-pr` inteira, sem precisar digitar o comando.

## Modos por issue (tag na mensagem)

- `#hipoteses`: antes de alterar código, liste as hipóteses de causa e como confirmar cada uma; pare e espere.
- `#quiz`: depois da explicação, faça 2 perguntas sobre a correção; pare e corrija as respostas.
- `#estudo`: `#hipoteses` + `#quiz`.
- `#rapido`: sem explicação; resumo de 1 a 2 linhas.
- `#irmaos`: na entrega, busque o mesmo padrão de defeito em outros processos (classe de
  `knowledge/classes-de-defeito/INDEX.md`), sem corrigir.
- `#eu-primeiro`: mostre a issue, a triagem e o trecho da base, e pare. O humano escreve a hipótese; depois de
  investigar, avalie o raciocínio dele (nota de 0 a 5) e deixe 1 a 3 trechos da correção como `TODO(human)`.

## Explicação após correções

Fora do `#rapido`, toda correção termina com a explicação da skill `modo-professor` (causa raiz, investigação,
correção, alternativas, conceitos, prevenção) e com o registro dos conceitos para revisão espaçada.
