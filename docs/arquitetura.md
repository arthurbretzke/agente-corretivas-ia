# Arquitetura

O pipeline é uma skill do Claude Code (`.claude/skills/corrigir-issue/SKILL.md`) que coordena o agente
principal e 3 subagentes de contexto limpo. Cada fase grava um artefato em `.runs/<issue>/` e só avança se o
gate da fase passar.

```mermaid
flowchart TD
    I[GitHub Issue] --> F1[1. Leitura da issue]
    F1 --> F2[2. Triagem e localização]
    K[(knowledge/)] -.consulta.-> F2
    F2 -->|bug| F3[3. Reprodução: teste vermelho]
    F2 -->|comportamento esperado ou melhoria| F7
    F3 --> F4[4. Causa raiz]
    F4 --> V{{verificador-causa}}
    V -->|refutada| F2
    V -->|confirmada| F5[5. Correção]
    F5 --> RG[[red-green.sh]]
    RG -->|FIM ok| F6[6. Validação independente]
    F6 --> R{{revisor}}
    F6 --> L{{lacunas}}
    R -->|ajustar| F5
    L -->|regressão| F5
    R -->|pronto| F7[7. Entrega]
    L -->|nenhuma regressão| F7
    F7 --> G[[gate-entrega.sh]]
    G -->|FIM ok| PR[Pull Request rascunho]
    F7 --> F8[8. Propostas para knowledge/]
```

## Peças

| Peça | Arquivo | Papel |
|---|---|---|
| Orquestrador | `.claude/skills/corrigir-issue/SKILL.md` | define fases, gates e modos (dry-run, push, replay) |
| Verificador | `.claude/agents/verificador-causa.md` | tenta refutar a causa raiz antes de qualquer código |
| Revisor | `.claude/agents/revisor.md` | tenta quebrar a correção, sem ver a investigação |
| Lacunas | `.claude/agents/lacunas.md` | procura regressão e caminhos não cobertos |
| Prova | `scripts/red-green.sh` | teste falha sem a correção e passa com ela |
| Gate final | `scripts/gate-entrega.sh` | bloqueia o PR sem todas as evidências |
| Guardrail | `scripts/guarda.py` (hook `PreToolUse`) | bloqueia gabarito, push forçado e push na main |
| Contexto | `knowledge/` | regras de negócio que o agente lê antes do código |
| Avaliação | `evals/` | casos com gabarito oculto e tabela de resultados |

## O ciclo completo de uma issue

```mermaid
flowchart LR
    S[[SessionStart:<br/>inicio-sessao.sh]] -.-> T
    I[Issue] --> T[triagem]
    T -->|melhoria| E[especificar-melhoria] --> A{{aprovação}}
    T -->|bug| INV[investigar-processo] --> C[correção<br/>+ modo-professor]
    T -->|autônomo| CI[corrigir-issue]
    C --> A
    A --> F[fechar-pr]
    CI --> F
    F --> M[mapear-processo]
    F --> K[(knowledge/<br/>classes de defeito<br/>decisões)]
```

Fora do ciclo de issue: `impacto-contrato` (nova versão de API × código), `analisar-processo` e `varrer-modulo`
(documentação e semente da base).

## Por que subagentes de contexto limpo

O agente que investigou tende a concordar com a própria hipótese. O verificador e o revisor recebem só a issue
e o resultado, nunca o raciocínio, então avaliam a correção como alguém de fora. Detalhes em
[decisoes/002-verificador-contexto-limpo.md](decisoes/002-verificador-contexto-limpo.md).
