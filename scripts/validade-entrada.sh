#!/usr/bin/env bash
# Confere se o código citado numa entrada da base mudou depois da última validação.
# Uso: bash scripts/validade-entrada.sh knowledge/processos/<slug>.md [...]
# Referência: linha "validado_em: app@<sha curto> <AAAA-MM-DD>". Sha desconhecido ou "-": usa a data.
# Arquivos verificados: os nomes citados entre crases na entrada (`PedidoService`, `TaxaEntregaService.java:18`).
cd "$(git rev-parse --show-toplevel)" || exit 2

for entrada in "$@"; do
    echo "== $(basename "$entrada")"
    ref=$(grep -i 'validado_em' "$entrada" | grep -oE '@[0-9a-f-]+ [0-9]{4}-[0-9]{2}-[0-9]{2}' | head -1)
    if [ -z "$ref" ]; then
        echo "sem validado_em: tratar como hipótese fraca"
        continue
    fi
    sha=${ref%% *}; sha=${sha#@}; data=${ref#* }

    # nomes citados entre crases, reduzidos ao nome do arquivo sem extensão
    tokens=$(grep -o '`[^` ]\{4,\}`' "$entrada" | tr -d '`' | sed 's#.*/##; s/[.#:].*$//' | sort -u)
    arqs=$(git ls-files | awk -v t="$tokens" '
        BEGIN { n = split(t, a, "\n"); for (i = 1; i <= n; i++) s[a[i]] = 1 }
        { b = $0; sub(/.*\//, "", b); sub(/\.[^.]*$/, "", b); if (b in s) print }')
    if [ -z "$arqs" ]; then
        echo "nenhum arquivo citado encontrado no repositório"
        continue
    fi

    if [ "$sha" != "-" ] && git cat-file -e "$sha^{commit}" 2>/dev/null; then
        faixa="$sha..HEAD"; desde="$sha"
    else
        faixa="--after=${data}T23:59:59"; desde="$data"
    fi
    mudou=$(echo "$arqs" | xargs git log --no-merges $faixa --format='%h %ad %an: %s' --date=short -- | head -5)
    if [ -z "$mudou" ]; then
        echo "ok, sem mudança desde $desde"
    else
        echo "ENTRADA POSSIVELMENTE DESATUALIZADA, mudou depois de $desde:"
        echo "$mudou" | sed 's/^/  /'
    fi
done
