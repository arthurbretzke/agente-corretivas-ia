---
name: fechar-pr
description: >-
  Fecha uma issue já aprovada: conferência do diff, branch, commit, push, PR, nota de release, origem do bug,
  ação preventiva e atualização da base de conhecimento. Use quando o humano disser "pode seguir", "pode subir",
  "pode commitar" ou variação clara depois de aprovar a correção, mesmo sem o comando.
---

# Fechar PR

Só rode com aprovação explícita na conversa ("pode seguir"). Sem ela, pare e pergunte.

**Modo autônomo** (fase 7 da `corrigir-issue` em modo `push`, com `gate-entrega.sh` em `FIM ok`): o gate
substitui a aprovação e nada é perguntado; o PR sai como rascunho e os passos 7 a 9 viram propostas em
`.runs/<n>/propostas.md`.

**Sessão nova:** leia `.runs/<n>/passagem.md` e confira com `git status` e `git diff --stat`. Diff que não bate
com a passagem: pare e pergunte.

## Passos

1. **Conferência:** `bash scripts/confere-commit.sh . .runs/<n>/intake.json`. Com `FIM erro`, pare e mostre os
   erros. Liste o que entra no commit e o que fica de fora. Alteração que não é desta issue: pergunte antes de
   incluir ou deixar de fora; nunca descarte.
2. **Base atualizada:** `git checkout main && git pull origin main`. Arquivo da correção que mudou na `main` desde
   então (`git log HEAD..origin/main -- <arq>`): reaplique a mudança sobre a versão nova e rode os testes de novo.
3. **Branch:** já existe PR da issue (`gh pr list --search "<n>"`)? Aberto: commite na branch dele. Fechado ou
   merged (a issue voltou): `fix/issue-<n>-2`. Senão: `fix/issue-<n>` (ou `feat/issue-<n>`).
4. **Commit** só dos arquivos conferidos: `fix: <descrição curta> (#<n>)`.
5. **PR:** `git push -u origin <branch>` e `gh pr create --base main --title "fix: <descrição> (#<n>)"
   --body-file .runs/<n>/pr.md` (modelo em `.claude/skills/corrigir-issue/relatorio-pr.md`). Passe o link.
6. **Volta para a base:** `git checkout main`. Nunca deixe o repositório parado na branch da issue.
7. **Nota de release** (para o changelog e para quem abriu a issue), no formato abaixo.
8. **Base de conhecimento:** pergunte se deve registrar ou atualizar a entrada do processo (skill
   `mapear-processo`), com a métrica: tempo até a causa raiz e se a base ajudou.
9. **Checklist anti-reincidência** (sem perguntar, uma linha cada):
   - dados afetados respondido na entrega;
   - entrada usada na issue com `validado_em: app@<sha curto> <AAAA-MM-DD>` e, se houver, `reincidencias:` e
     `lacunas:`;
   - a issue entrou como exemplo numa classe de `knowledge/classes-de-defeito/INDEX.md` (ou a classe nova foi
     criada);
   - melhoria: ADR gravado em `knowledge/decisoes/`;
   - conceitos do modo professor registrados (skill `modo-professor`).

No fim, resuma: branch, link do PR, arquivos deixados de fora e por quê. Na passagem, troque o estado para
`Estado: fechado <AAAA-MM-DD> · <link do PR>`.

## Nota de release

Escrita para o usuário final, não para o desenvolvedor. Regras:

1. **Comportamento, não implementação.** Descreva o que mudou no funcionamento, sem classe, método, consulta,
   variável ou exceção.
2. **Valor sem frase pronta.** Diga o impacto quando ele for comprovável; nada de "proporcionando uma melhor
   experiência".
3. **Não invente** causa, impacto ou regra que não esteja na correção.
4. **Sem destacar a falha.** Explique o comportamento depois da mudança; o cenário anterior, se preciso, de forma
   neutra.
5. **Verbos:** prefira "Ajustado", "Aprimorado", "Implementado" a "Corrigido erro".
6. **Sem dado do atendimento:** nada de nome de usuário, número de issue ou ambiente.
7. **Específico e preciso:** diga qual regra mudou e mantenha as condições dela.
8. **Conciso:** uma frase, no máximo duas.

Exemplo. Ruim: "Corrigido bug no compareTo do TaxaEntregaService." Bom: "Ajustada a entrega grátis para valer
também nos pedidos de exatamente R$ 50,00, conforme anunciado no app."

```
Funcionalidade alterada:
<tela, endpoint ou regra>

Nota de release:
<texto>

Origem do defeito (interno):
commit <hash> de <data>, <autor>: "<mensagem>" (via git blame das linhas corrigidas; "legado" se anterior ao
histórico) · confiança alta/média/baixa

Ação preventiva (interno):
<2-3 linhas: padrão de código que evita o defeito + o que testar>
```
