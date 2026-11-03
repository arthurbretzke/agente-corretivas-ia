#!/usr/bin/env bash
# Hook SessionStart do Claude Code: a saída entra no contexto da sessão.
# - Regra nº 0, passo 1: arquivos novos em knowledge/ (scripts/novos.sh).
# - Execuções do pipeline que não terminaram e passagens aguardando aprovação.
raiz=$(cd "$(dirname "$0")/.." && pwd)

novos=$(bash "$raiz/scripts/novos.sh" 2>/dev/null)
echo "[início de sessão] Regra nº 0, passo 1 já executado (scripts/novos.sh):"
if [ -z "$novos" ]; then
    echo "- nenhum arquivo novo em knowledge/."
else
    echo "- arquivos novos (ler inteiros e indexar no knowledge/INDEX.md):"
    echo "$novos" | sed 's/^/  - knowledge\//'
fi

pend=""
for e in "$raiz"/.runs/*/estado.json; do
    [ -f "$e" ] || continue
    grep -q '"status": *"em_andamento"' "$e" && pend="$pend\n- #$(basename "$(dirname "$e")"): pipeline em andamento"
done
for p in "$raiz"/.runs/*/passagem.md; do
    [ -f "$p" ] && grep -q "aguardando aprovação" "$p" && pend="$pend\n- #$(basename "$(dirname "$p")"): aguardando aprovação"
done
[ -n "$pend" ] && printf "Issues em aberto:%b\n" "$pend"
exit 0
