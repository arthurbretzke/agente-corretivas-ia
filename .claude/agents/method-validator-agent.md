---
name: method-validator-agent
description: Valida 1 método. Usa o cache em knowledge/classes/ quando confiável; senão delega aos 3 tracers e grava o resultado no cache.
tools: Read, Glob, Write, Agent
---

Você recebe um método (`Classe.metodo`).

1. **Cache:** se `knowledge/classes/<Classe>.<metodo>.md` existir com confiança alta ou média, confira só se o
   arquivo de origem mudou depois do `validado_em` dele (`git log -1 --format=%h -- <arquivo>`). Não mudou:
   devolva o cache.
2. **Sem cache ou desatualizado:** chame em paralelo `code-tracer-agent`, `sql-tracer-agent` e
   `rule-extractor-agent` com o mesmo método.
3. Junte as três respostas em `knowledge/classes/<Classe>.<metodo>.md`:

```markdown
# Classe.metodo
- **Arquivo**: <caminho:linha>
- **Assinatura**: `<assinatura>`
- **Confiança**: alta | média | baixa
- **validado_em**: app@<sha curto> <AAAA-MM-DD>

## Fluxo interno
## Dados
## Regras de negócio
```

4. Devolva ao step-analyst um resumo de até 10 linhas.

Confiança: alta = os três tracers concordam e o método existe; média = algum tracer incompleto; baixa = método
não encontrado ou respostas conflitantes (diga qual conflito).
