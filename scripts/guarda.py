"""Guardrail do agente (hook PreToolUse do Claude Code).

Bloqueia o gabarito dos evals e comandos git destrutivos. Recebe o JSON do hook no stdin; sair com código 2
bloqueia a ferramenta e devolve a mensagem ao agente. Autoteste: python scripts/guarda.py --teste
"""
import json
import re
import sys

PROIBIDO = [
    (re.compile(r"evals[/\\]+gabarito"), "o gabarito dos evals é proibido para o agente"),
    (re.compile(r"git\s+push\b[^\"]*(--force|\s-f\b)"), "push forçado não é permitido"),
    (re.compile(r"git\s+push\b[^\"]*\s(main|master)(?=[\s\"]|$)"), "push direto na main não é permitido; abra um PR"),
    (re.compile(r"git\s+reset\s+--hard"), "reset --hard descarta trabalho"),
    (re.compile(r"rm\s+-[a-z]*r[a-z]*\s+[/~]"), "remoção recursiva fora do projeto"),
]


def motivo_bloqueio(entrada):
    texto = json.dumps(entrada.get("tool_input", {}), ensure_ascii=False)
    for padrao, motivo in PROIBIDO:
        if padrao.search(texto):
            return motivo
    return None


def autoteste():
    bloqueia = [
        {"file_path": "evals/gabarito/01.md"},
        {"file_path": "C:\\repo\\evals\\gabarito\\01.md"},
        {"pattern": "taxa", "path": "evals/gabarito"},
        {"command": "git push origin fix/issue-1 --force"},
        {"command": "git push -f origin fix/issue-1"},
        {"command": "git push origin main"},
        {"command": "git reset --hard HEAD~1"},
        {"command": "rm -rf ~/"},
    ]
    libera = [
        {"command": "git push -u origin fix/issue-3"},
        {"command": "git push -u origin fix-main-menu"},
        {"file_path": "app/src/main/java/dev/arthurbretzke/pedidos/servico/CupomService.java"},
        {"file_path": "evals/casos/01/issue.md"},
    ]
    for entrada in bloqueia:
        assert motivo_bloqueio({"tool_input": entrada}), f"deveria bloquear: {entrada}"
    for entrada in libera:
        assert motivo_bloqueio({"tool_input": entrada}) is None, f"deveria liberar: {entrada}"
    print("ok")


if __name__ == "__main__":
    sys.stderr.reconfigure(encoding="utf-8")  # acentos legíveis também no console do Windows
    if sys.argv[1:] == ["--teste"]:
        autoteste()
        sys.exit(0)
    motivo = motivo_bloqueio(json.load(sys.stdin))
    if motivo:
        print(f"Bloqueado pelo guardrail: {motivo}.", file=sys.stderr)
        sys.exit(2)
