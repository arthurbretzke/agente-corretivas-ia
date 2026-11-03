#!/usr/bin/env bash
# Gate da fase 7: só libera o PR se cada fase deixou sua evidência em .runs/<issue>/.
# Uso: scripts/gate-entrega.sh <numero-da-issue>
set -u
[ $# -eq 1 ] || { echo "uso: $0 <numero-da-issue>"; exit 2; }
dir="$(git rev-parse --show-toplevel)/.runs/$1"
falhas=0

exige() {
    if ! grep -qs "$2" "$dir/$1"; then
        echo "faltou: $1 com \"$2\""
        falhas=$((falhas + 1))
    fi
}

exige causa.md "Veredito: confirmada"
exige red-green.log "FIM ok"
exige revisao.md "Veredito: pronto"
exige lacunas.md "Regressões: nenhuma"

if [ $falhas -eq 0 ]; then
    echo "FIM ok"
else
    echo "FIM falha: $falhas evidência(s) ausente(s)"; exit 1
fi
