#!/usr/bin/env bash
# Prepara o modo replay da corrigir-issue para uma issue JÁ CORRIGIDA na main: cria um worktree no commit anterior
# à primeira correção, guarda o diff real (gabarito) numa pasta que o hook bloqueia para o agente e lista os
# arquivos da base que citam a issue (proibidos durante o replay, para o agente não "colar").
# Uso: bash scripts/prepara-replay.sh <issue>
#      bash scripts/prepara-replay.sh --limpar <issue>
# Saída: .runs/<issue>/replay.json (para o agente), evals/gabarito/replay/<issue>.diff (só para o humano) e
#        a linha "FIM ok | FIM erro".
set -u
cd "$(git rev-parse --show-toplevel)" || exit 2
limpar=0; [ "${1:-}" = "--limpar" ] && { limpar=1; shift; }
n=${1:?uso: prepara-replay.sh [--limpar] <issue>}
wt=".replay/$n"

if [ $limpar = 1 ]; then
    git worktree remove --force "$wt" && echo "removido: $wt"
    echo "FIM ok"; exit 0
fi

# commits da main que citam a issue: "fix: ... (#12)"
shas=$(git log main --no-merges --reverse --format=%H -E --grep="#$n([^0-9]|$)")
if [ -z "$shas" ]; then
    echo "nenhum commit citando #$n na main"; echo "FIM erro"; exit 1
fi
pai=$(git rev-parse "$(head -1 <<< "$shas")^")

[ -d "$wt" ] || git worktree add -q --detach "$wt" "$pai"
mkdir -p evals/gabarito/replay ".runs/$n"
for s in $shas; do git show --stat --patch "$s"; done > "evals/gabarito/replay/$n.diff"

proibidos=$(grep -rlE "#$n([^0-9]|$)" knowledge 2>/dev/null | sed 's/.*/"&"/' | paste -sd, -)
cat > ".runs/$n/replay.json" <<EOF
{
  "issue": $n,
  "worktree": "$wt",
  "pai": "$pai",
  "proibidos": [${proibidos}],
  "regras": [
    "Trabalhe só no worktree acima: a main já contém a correção.",
    "Nunca use git log --all nem leia commits posteriores ao 'pai'.",
    "Não abra os arquivos 'proibidos' nem procure o número da issue no repositório ou no GitHub."
  ]
}
EOF
echo "$(wc -l <<< "$shas") commit(s) da issue; worktree em $wt no commit ${pai:0:9}"
echo "Gabarito (só para o humano): evals/gabarito/replay/$n.diff"
echo "FIM ok"
