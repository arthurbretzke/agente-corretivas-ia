#!/usr/bin/env bash
# Conferência antes do commit (passo 1 da fechar-pr): arquivo reescrito inteiro, troca de encoding, TODO(human),
# comentário com número de issue, dado pessoal e segredo nas linhas adicionadas.
# Uso: bash scripts/confere-commit.sh [intake.json]
#      intake.json opcional: a lista "sensiveis" (nomes, documentos, e-mails do relato) também é procurada.
# Última linha: "FIM ok" ou "FIM erro" (erro = não commitar).
set -u
cd "$(git rev-parse --show-toplevel)" || exit 2
intake=${1:-}
erros=0
erro() { echo "ERRO: $*"; erros=$((erros + 1)); }

tem_head=0; git rev-parse -q --verify HEAD >/dev/null && tem_head=1

mapfile -t alterados < <({ [ $tem_head = 1 ] && git diff --name-only HEAD; git ls-files --others --exclude-standard; } | sort -u)
for f in "${alterados[@]}"; do
    [ -f "$f" ] || continue
    echo "entra: $f"
    [ $tem_head = 1 ] && git cat-file -e "HEAD:$f" 2>/dev/null || continue
    # arquivo reescrito inteiro para uma mudança pequena: sinal de troca de encoding ou de quebra de linha
    read -r _ del _ <<< "$(git diff --numstat HEAD -- "$f")"
    total=$(git show "HEAD:$f" | wc -l)
    if [ "${del:--}" != "-" ] && [ "$del" -ge 20 ] && [ $((del * 10)) -ge $((total * 8)) ]; then
        erro "$f: $del de $total linhas trocadas (reescrito inteiro?)"
    fi
    git show "HEAD:$f" | iconv -f UTF-8 -t UTF-8 >/dev/null 2>&1 && antes=utf8 || antes=outro
    iconv -f UTF-8 -t UTF-8 "$f" >/dev/null 2>&1 && depois=utf8 || depois=outro
    [ "$antes" != "$depois" ] && erro "$f: encoding mudou ($antes -> $depois)"
done

# linhas adicionadas: diff dos rastreados + conteúdo dos novos
adicionadas() {
    { [ $tem_head = 1 ] && git diff -U0 HEAD -- "$@" | grep -E '^\+[^+]' | sed 's/^+//'
      git ls-files --others --exclude-standard -z -- "$@" | xargs -0 -r cat; } 2>/dev/null
}
tudo=$(mktemp); codigo=$(mktemp)
adicionadas > "$tudo"
adicionadas '*.java' '*.py' '*.sh' '*.js' '*.ts' > "$codigo"

grep -q 'TODO(human)' "$tudo" && erro "TODO(human) sobrando"
grep -qiE '(//|#|\*) .*(issue ?#?|#)[0-9]{1,6}([^0-9]|$)' "$codigo" && erro "comentário com número de issue (o rastreio fica no commit)"
grep -qE '[0-9]{3}\.[0-9]{3}\.[0-9]{3}-[0-9]{2}' "$tudo" && erro "CPF formatado no diff"
grep -qE '[0-9]{2}\.[0-9]{3}\.[0-9]{3}/[0-9]{4}-[0-9]{2}' "$tudo" && erro "CNPJ formatado no diff"
grep -qE '(ghp_|github_pat_|sk-ant-|AKIA)[A-Za-z0-9_]{10,}' "$tudo" && erro "possível segredo (token) no diff"
if [ -n "$intake" ] && [ -f "$intake" ]; then
    while IFS= read -r s; do
        s=${s%$'\r'}
        [ -n "$s" ] && grep -qF -- "$s" "$tudo" && erro "valor sensível do intake no diff: ${s:0:3}***"
    done < <(python -c "import json,sys
for s in json.load(open(sys.argv[1], encoding='utf-8')).get('sensiveis', []):
    s = str(s).strip()
    if len(s) >= 4: print(s)" "$intake")
fi
rm -f "$tudo" "$codigo"

[ $erros -eq 0 ] && echo "FIM ok" || { echo "FIM erro"; exit 1; }
