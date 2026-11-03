---
name: triagem
description: >-
  Triagem de issue de bug e blocos obrigatórios da entrega da correção. Use SEMPRE na primeira resposta a
  qualquer issue ou relato de problema ("valor errado", "dá erro", "não aplica o cupom", número ou link de
  issue), antes de investigar; e de novo ao entregar a correção (testes vermelho → verde, lacunas, dados
  afetados, revisão independente e passagem). NÃO use para funcionalidade nova ou mudança de regra: isso é
  `especificar-melhoria`.
---

# Triagem

Duas paradas no fluxo de uma issue: **triagem** (primeira resposta) e **entrega** (correção pronta para
aprovação). O que vem entre elas (Regra nº 0, investigação, `#hipoteses`) não muda.

## 1. Triagem (primeira resposta)

Antes: Regra nº 0 do `AGENTS.md`. Se abrir uma entrada de `knowledge/processos/`, rode
`bash scripts/validade-entrada.sh <entrada>`; desatualizada → diga numa linha e trate como hipótese fraca.

PR já existente da issue: `gh pr list --search "<n>" --state all`. Achou: a issue voltou ou já tem trabalho
feito. Leia o diff (`gh pr diff <pr>`) antes de investigar: a correção nova parte do que existe.

Saída: no máximo 6 linhas.

```
Triagem
- Tipo: bug de código | dado incorreto | configuração | comportamento esperado | melhoria disfarçada
- Esperado: <uma frase, do ponto de vista do usuário> | Pergunta ao autor da issue: "<pergunta exata>"
- Aceite: <como saberemos que resolveu; vira o teste de regressão>
- Reprodução: <passos e dados mínimos> | falta <X>
- Reincidência: não | sim, <entrada da base>: <por que a correção anterior não segurou>
- Palpite? Qual sua causa provável e tempo estimado? (opcional, não bloqueia)
```

Regras:
- **Melhoria disfarçada:** avise na linha do tipo e siga com `especificar-melhoria`.
- **Comportamento esperado** ou **dado incorreto:** não altere código antes da confirmação humana. Dado
  incorreto: quantifique (Regra nº 1) e monte o roteiro de saneamento.
- **Configuração:** indique o parâmetro e o valor esperado; código só se pedirem.
- **Reincidência:** só afirme se a entrada da base tiver causa registrada para o mesmo processo e o sintoma bater
  (inclusive com uma linha de `lacunas:`). Se for, acrescente `reincidencias:` na entrada
  (`<data> #<n>: <regra do fluxo que falhou>`).
- **Palpite:** se o humano responder, guarde para a calibração (skill `modo-professor`).

## 2. Entrega da correção (antes da aprovação)

Ordem fixa, blocos compactos. Os itens 1, 3, 4, 5 e 6 valem também com `#rapido`, em uma linha cada.

1. **Correção e testes (vermelho → verde):** saída real de
   `bash scripts/red-green.sh <ClasseTest#metodo> <arquivos de produção>`. Sem teste automatizado possível:
   roteiro de teste manual, um caso por critério de aceite (objetivo, pré-condição, dados, passos, resultado
   esperado antes × depois).
2. **Modo professor:** skill `modo-professor` (fora do `#rapido`).
3. **Lacunas da correção** (sempre responder, mesmo "nenhuma"): agente `lacunas`, **na mesma mensagem** que o
   revisor do item 5. Regressão volta para a correção; lacuna não se corrige sem o humano pedir.
   - **`#irmaos`:** enquadre a causa numa classe de `knowledge/classes-de-defeito/INDEX.md` e rode o padrão de
     busca dela, até ~15 ocorrências, sem corrigir.
4. **Dados afetados** (sempre responder, mesmo "não"): o bug gravou dado errado? Não: uma linha dizendo por quê.
   Sim: consulta que quantifica e roteiro de saneamento (Regra nº 1). Nunca executar.
5. **Revisão independente:** agente `revisor`, em paralelo com o item 3. Bloqueante volta para a correção
   antes desta entrega. Mostre bloqueantes resolvidos, não bloqueantes e 2–3 perguntas de revisor sênior.
6. **Passagem:** grave `.runs/<n>/passagem.md` e termine com: "Passagem gravada. Enquanto revisa, pode dar
   `/clear`; na volta, `pode seguir <n>`." Uma sessão nova parte só da passagem, sem reprocessar a conversa.

   ```
   # #<n> - <descrição curta>
   - Estado: aguardando aprovação
   - Triagem: <bloco>
   - Causa raiz: <2-3 linhas>
   - Arquivos: <alterados, não commitados>
   - Testes: <comando> · vermelho: <linha real> · verde: <linha real>
   - Dados afetados: <resposta>
   - Lacunas: <lista ou "nenhuma">
   - Base: <entrada usada ou "nenhuma">
   ```
