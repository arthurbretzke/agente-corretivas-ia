---
name: analisar-processo
description: Análise completa e automática de um processo de negócio por um time de agentes — descoberta, decomposição por passo, validação de métodos (com cache), consolidação técnica e narrativa funcional. Use para documentar um processo inteiro, não para corrigir um bug.
---

# Analisar processo

Processo a analisar: o que o humano informou (nome e, se souber, o ponto de partida). `P` =
`knowledge/manuais/<processo>/`.

Siga a sequência, esperando cada etapa terminar antes da próxima:

1. **Descoberta:** agente `discovery-agent` com o processo e o ponto de partida. Saída: `P/fluxo.json`.
2. **Decomposição:** agente `orchestrator-agent` com o `fluxo.json`. Saída: `P/tarefas.json`.
3. **Gate de custo:** conte os passos e os métodos únicos ainda sem cache confiável em `knowledge/classes/`
   (confiança alta ou média). Mais de 8 passos **ou** mais de 20 métodos: pare e mostre os números ao humano
   antes do fan-out.
4. **Análise por passo:** um `step-analyst-agent` por passo, **em paralelo** (os passos são independentes).
   Cada um delega cada método a um `method-validator-agent`, que usa o cache ou chama os tracers
   (`code-tracer-agent`, `sql-tracer-agent`, `rule-extractor-agent`). Saída: `P/passos/passo_XX.md`.
5. **Consolidação:** `consolidator-agent` (manual técnico, `P/manual-tecnico.md`) e `narrator-agent` (manual
   funcional, sem código, `P/manual-funcional.md`), **em paralelo**, com a mesma entrada.
6. **Índice:** linha do processo em `knowledge/INDEX.md`, seção "Manuais", com os links.
7. **Resumo:** quantos passos, quantos métodos vieram do cache × validados agora, e os caminhos gerados.

Com 2 ou mais processos documentados: `integration-agent` mapeia como eles se conectam e o `module-writer-agent`
escreve o manual do módulo inteiro.

Se um agente reportar ambiguidade (dois pontos de entrada plausíveis, método não encontrado), pare e pergunte:
não deixe o agente decidir sozinho.

## Hierarquia

```
analisar-processo
├── discovery-agent        mapeia a sequência de execução (não documenta)
├── orchestrator-agent     quebra o fluxo em tarefas por passo
├── step-analyst-agent ×N  1 por passo, em paralelo
│   └── method-validator-agent ×M   1 por método, com cache em knowledge/classes/
│       ├── code-tracer-agent       confirma o método e extrai assinatura e fluxo
│       ├── sql-tracer-agent        consultas, repositórios e tabelas usados
│       └── rule-extractor-agent    regras de negócio e o motivo de cada uma
├── consolidator-agent     manual técnico
├── narrator-agent         manual funcional, sem código
├── integration-agent      conexão entre processos (2+ manuais)
└── module-writer-agent    manual do módulo
```

O cache em `knowledge/classes/` faz o segundo processo que usa o mesmo método não pagar a análise de novo.
