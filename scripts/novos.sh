#!/usr/bin/env bash
# Regra nº 0: lista os arquivos de knowledge/ que nenhum índice cobre (contribuição nova a ler e indexar).
# Coberto = caminho citado no INDEX.md, ou dentro de uma pasta indexada inteira (classes/, decisoes/, manuais/,
# classes-de-defeito/). Saída vazia = nada novo.
# Uso: bash scripts/novos.sh
cd "$(dirname "$0")/../knowledge" || exit 1

find . -type f | sed 's#^\./##' | sort | while read -r f; do
    case "$f" in
        INDEX.md|classes/*|decisoes/*|manuais/*|classes-de-defeito/*) continue ;;
    esac
    grep -qF -- "$f" INDEX.md || echo "$f"
done
