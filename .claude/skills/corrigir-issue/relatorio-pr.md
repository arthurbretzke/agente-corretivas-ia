# Modelo do relatório do PR (`R/pr.md`)

É o corpo do PR e o único material da revisão humana: deve permitir aprovar ou recusar **sem abrir a conversa**.
Seções vazias ficam com "nenhum/nenhuma", nunca somem.

```markdown
## fix: <descrição curta> (#<n>)

**Confiança: <alta|média|baixa>** · Tipo: <tipo> · Modo: <humano|autônomo>
<motivos da confiança, 1 linha cada: o que faltou para o nível acima>

### Problema
<sintoma do ponto de vista do usuário, 2-3 linhas>
**Aceite:** <linha Aceite da triagem>

### Causa raiz
<mecanismo em 2-4 linhas: o que estava errado e por quê>
- Evidência: `arquivo:linha` — <o que mostra>
- Origem: <commit <sha> de <data> ("<mensagem>") | legado>
- Verificador independente: confirmada

### Correção
<o que mudou e por que resolve, 2-4 linhas>

| Arquivo | Mudança |
|---|---|
| `<caminho>` | <1 linha> |

Chamadores conferidos: <n; algum com comportamento alterado? qual>

### Prova
- Vermelho (código antigo): <linha real do red-green.log>
- Verde (código novo): <linha real>
- `FIM ok`

### Revisão independente
- Bloqueantes: nenhum (<ou: corrigidos: ...>)
- Não bloqueantes: <1 linha cada>
- Perguntas para o revisor humano: <2-3>

### Lacunas (não corrigidas neste PR)
<nenhuma | `arquivo:linha` | gatilho | por que o diff não cobre | alta/média>

### Dados afetados
<não, <motivo> | sim: <quantidade e critério>; roteiro de saneamento anexo (não executado)>
```
