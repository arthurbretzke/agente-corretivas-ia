#!/usr/bin/env bash
# Revisão espaçada: lista os 2 conceitos com revisão vencida (proxima <= hoje), os mais atrasados primeiro.
# Saída: proxima | conceito | pergunta | intervalo
hoje=$(date +%F)
awk -F'|' -v hoje="$hoje" '
    /^\| *[0-9a-zA-Z]/ && $7 ~ /[0-9]{4}-[0-9]{2}-[0-9]{2}/ {
        gsub(/^ +| +$/, "", $2); gsub(/^ +| +$/, "", $4); gsub(/ /, "", $6); gsub(/ /, "", $7)
        if ($7 <= hoje) print $7 " | " $2 " | " $4 " | " $6
    }' "$(dirname "$0")/../aprendizado/conceitos.md" | sort | head -2
