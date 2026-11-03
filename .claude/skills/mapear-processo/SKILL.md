---
name: mapear-processo
description: Registra ou atualiza uma entrada da base de processos (knowledge/processos/) a partir de algo confirmado numa issue real. Use quando o humano confirmar o que foi descoberto ou no passo 8 da skill fechar-pr.
---

# Mapear processo

1. Extraia o que der: nome do processo, ponto de entrada (endpoint), classes envolvidas, regras de negócio
   confirmadas, confiança e número da issue.
2. Faltou confiança ou issue: pergunte antes de gravar. Pergunte também, opcional, a **métrica**: tempo até a
   causa raiz e se a base ajudou (sim / parcial / não).
3. Procure o processo na tabela de `knowledge/INDEX.md`.
   - **Existe:** atualize `knowledge/processos/<slug>.md` sem duplicar; suba a confiança conforme informado e
     atualize a coluna "Última validação" do índice.
   - **Não existe:** crie a entrada no formato abaixo e a linha no índice.
4. Em ambos os casos, grave `- **validado_em**: app@<sha curto> <AAAA-MM-DD>` (sem commit ainda: `app@-`) e,
   quando houver, `reincidencias:` e `lacunas:`.
5. Não reescreva outras entradas. Mostre a entrada e a linha do índice para o humano confirmar.

## Formato da entrada

```markdown
# <Processo>

- **Entrada**: <endpoint ou ponto de início>
- **Classes**: `<Classe>` (papel), ...
- **Confiança**: alta | média | baixa | gerado por varredura automática — não validado manualmente
- **Última validação**: <AAAA-MM-DD> · #<issue>
- **validado_em**: app@<sha> <AAAA-MM-DD>
- **Métrica**: #<issue>: <tempo até a causa> · base ajudou: sim | parcial | não
- **reincidencias**: <data> #<issue>: <regra do fluxo que falhou>
- **lacunas**: <data> #<issue>: <gatilho> em <arquivo:linha>

## Regras de negócio
<comportamento esperado, numerado>

## Observações
<nuances, exceções, casos em que a entrada não se aplica>
```

As entradas são **hipóteses de investigação**, não diagnósticos: cada uma foi validada para um caso, e o código
pode ter mudado depois (por isso o `validado_em`).
