# Políticas do modo autônomo

Cada ponto em que o fluxo humano para e pergunta vira uma regra fixa. Regra nova nasce de
`estado.json.duvidas`: quando uma dúvida se repetir em execuções diferentes, ela entra nesta tabela.

| Parada no fluxo humano | Regra do agente |
|---|---|
| Triagem "comportamento esperado" | Sem código. Relatório com a regra que explica o comportamento (`arquivo:linha` ou trecho da `knowledge/`) e a resposta sugerida ao autor da issue |
| Triagem "dado incorreto" | Sem código. Consulta que quantifica + roteiro de saneamento. Nunca executar |
| Triagem "configuração" | Sem código. Parâmetro a ajustar, valor atual e esperado |
| Melhoria disfarçada | Só o plano de 7 itens da `especificar-melhoria`, em `R/plano.md`. Não implementa |
| Issue sem dado mínimo para reproduzir | Segue com o que tem. Sem sintoma identificável: abstenção, com a pergunta exata ao autor |
| Dois pontos de entrada plausíveis | Investigar os dois até a evidência desempatar. Sem desempate: abstenção, com os candidatos |
| `#hipoteses` (parar antes de corrigir) | Não para: as hipóteses ficam em `triagem.md` e o `verificador-causa` faz o papel do humano |
| Classe de teste não existe | Criar `<Classe>Test` no padrão do projeto, só com o fluxo da correção |
| Dependência nova no `pom.xml` | Não adicionar. Teste com o que existe; se não der, abstenção |
| Alteração de outra issue no repositório | Não tocar nem incluir. Registrar em `duvidas` |
| Lacuna encontrada | Não corrigir. Vai para o PR e para `propostas.md` |
| Bloqueante do revisor | Corrigir 1 vez. Bloqueante de novo: abstenção |
| Causa refutada pelo verificador | Até 2 voltas. Na terceira refutação: abstenção |
| Aprovação humana ("pode seguir") | Substituída pelo `gate-entrega.sh`. PR sempre rascunho; nunca merge |
| Atualizar a base ou uma skill | Proposta em `R/propostas.md`, nunca grava direto |

## Rubrica de confiança

| Confiança | Exige | Resultado |
|---|---|---|
| **alta** | reproduzido com teste · verificador `confirmada` · red-green `FIM ok` · revisor `pronto` · nenhuma lacuna "alta" | PR rascunho |
| **média** | verificador `confirmada` · revisor `pronto` · red-green `FIM ok` · alguma lacuna "alta" listada | PR rascunho com o rótulo "confiança média" |
| **baixa** | qualquer outro caso (voltas esgotadas, sem teste) | Abstenção: relatório com o diff proposto, sem PR |

O relatório lista o que faltou para o nível acima ("sem reprodução por teste", "lacuna alta em X").
