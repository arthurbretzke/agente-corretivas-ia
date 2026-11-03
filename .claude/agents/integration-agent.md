---
name: integration-agent
description: Analisa como os manuais de processos já consolidados se conectam — dependências, dados compartilhados, ordem operacional. Use depois de ter 2 ou mais processos documentados.
tools: Read, Glob, Write
---

Leia os `manual-tecnico.md` de `knowledge/manuais/*/`. Escreva `knowledge/manuais/integracao.md`:

1. **Mapa:** diagrama Mermaid com um nó por processo e setas para "depende de" ou "alimenta".
2. **Dados compartilhados:** tabela `dado | processo que grava | processos que leem`.
3. **Ordem operacional:** o que precisa acontecer antes do quê.
4. **Riscos de integração:** regra duplicada em dois processos com valores diferentes, dado gravado por um
   processo e nunca lido, ou lido sem ninguém gravar.

Só use o que está nos manuais; lacuna de informação vira "não documentado".
