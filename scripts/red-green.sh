#!/usr/bin/env bash
# Prova a correção: o teste de regressão FALHA sem a correção e PASSA com ela.
# Uso: scripts/red-green.sh <ClasseTest[#metodo]> <arquivo de produção>...
# Última linha: "FIM ok" (prova válida) ou "FIM falha: <motivo>".
set -u
[ $# -ge 2 ] || { echo "uso: $0 <ClasseTest[#metodo]> <arquivo de produção>..."; exit 2; }
teste="$1"; shift
cd "$(git rev-parse --show-toplevel)" || exit 2

roda() { (cd app && mvn -q test -Dtest="$teste" >/dev/null 2>&1); }

# Sem alteração nos arquivos de produção não há o que provar (e o stash pop pegaria outro stash).
if git diff --quiet -- "$@"; then
    echo "FIM falha: nenhuma alteração em $*"; exit 1
fi

git stash push --quiet -- "$@"
roda; vermelho=$?
git stash pop --quiet
roda; verde=$?

echo "vermelho (sem a correção): $([ $vermelho -ne 0 ] && echo 'falhou, como esperado' || echo 'PASSOU (o teste não reproduz o bug)')"
echo "verde (com a correção):    $([ $verde -eq 0 ] && echo 'passou' || echo 'FALHOU')"
if [ $vermelho -ne 0 ] && [ $verde -eq 0 ]; then
    echo "FIM ok"
else
    echo "FIM falha: o teste não prova a correção"; exit 1
fi
