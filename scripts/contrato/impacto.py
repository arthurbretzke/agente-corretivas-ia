"""Impacto de uma nova versão de contrato OpenAPI (JSON) no código.

Compara components.schemas das duas versões, agrupa as mudanças por schema (uma tarefa por schema) e aponta onde
o código define o schema e cita cada campo. Não altera código.

Uso:
  python -I scripts/contrato/impacto.py --anterior A.json --novo N.json --codigo app/src --saida tarefas.json
  python -I scripts/contrato/impacto.py --teste
"""
import argparse
import json
import re
import sys
import tempfile
from pathlib import Path


def campos(spec):
    """{schema: {campo: {tipo, obrigatorio}}} a partir de components.schemas."""
    saida = {}
    for nome, schema in spec.get("components", {}).get("schemas", {}).items():
        obrigatorios = set(schema.get("required", []))
        saida[nome] = {
            campo: {"tipo": prop.get("type") or prop.get("$ref", "?").split("/")[-1],
                    "obrigatorio": campo in obrigatorios}
            for campo, prop in schema.get("properties", {}).items()
        }
    return saida


def diff(anterior, novo):
    a, n = campos(anterior), campos(novo)
    mudancas = []
    for schema in sorted(set(a) | set(n)):
        if schema not in a:
            mudancas.append({"schema": schema, "campo": None, "mudanca": "schema_novo"})
            continue
        if schema not in n:
            mudancas.append({"schema": schema, "campo": None, "mudanca": "schema_removido"})
            continue
        for campo in sorted(set(a[schema]) | set(n[schema])):
            antes, depois = a[schema].get(campo), n[schema].get(campo)
            base = {"schema": schema, "campo": campo}
            if antes is None:
                mudancas.append({**base, "mudanca": "adicionado", **depois})
            elif depois is None:
                mudancas.append({**base, "mudanca": "removido"})
            else:
                if antes["tipo"] != depois["tipo"]:
                    mudancas.append({**base, "mudanca": "tipo_alterado", "de": antes["tipo"], "para": depois["tipo"]})
                if antes["obrigatorio"] != depois["obrigatorio"]:
                    mudancas.append({**base, "mudanca": "obrigatoriedade",
                                     "de": antes["obrigatorio"], "para": depois["obrigatorio"]})
    return mudancas


def ocorrencias(codigo, termo):
    padrao = re.compile(r"\b" + re.escape(termo) + r"\b")
    achados = []
    for arquivo in sorted(Path(codigo).rglob("*.java")):
        for n, linha in enumerate(arquivo.read_text(encoding="utf-8").splitlines(), 1):
            if padrao.search(linha):
                achados.append(f"{arquivo.as_posix()}:{n}")
    return achados


def tarefas(mudancas, codigo):
    por_schema = {}
    for m in mudancas:
        por_schema.setdefault(m["schema"], []).append(m)
    saida = []
    for i, (schema, itens) in enumerate(por_schema.items(), 1):
        definicao = ocorrencias(codigo, f"record {schema}") + ocorrencias(codigo, f"class {schema}")
        for m in itens:
            m["codigo"] = ocorrencias(codigo, m["campo"]) if m["campo"] else []
        saida.append({"id": f"T{i:02d}", "schema": schema, "definicao": definicao,
                      "sem_classe": not definicao, "mudancas": itens})
    return saida


def autoteste():
    v1 = {"components": {"schemas": {"Pedido": {"required": ["itens"], "properties": {
        "itens": {"type": "array"}, "distanciaKm": {"type": "number"}}}}}}
    v2 = {"components": {"schemas": {
        "Pedido": {"required": ["itens", "distanciaMetros"], "properties": {
            "itens": {"type": "array"}, "distanciaMetros": {"type": "integer"}, "gorjeta": {"type": "number"}}},
        "Avaliacao": {"properties": {"nota": {"type": "integer"}}}}}}
    tipos = {(m["schema"], m["campo"], m["mudanca"]) for m in diff(v1, v2)}
    assert ("Pedido", "distanciaKm", "removido") in tipos
    assert ("Pedido", "distanciaMetros", "adicionado") in tipos
    assert ("Pedido", "gorjeta", "adicionado") in tipos
    assert ("Avaliacao", None, "schema_novo") in tipos
    assert not any(m == "tipo_alterado" for _, _, m in tipos)
    with tempfile.TemporaryDirectory() as pasta:
        Path(pasta, "Pedido.java").write_text("record Pedido(List<Item> itens, double distanciaKm) {}\n", encoding="utf-8")
        t = {x["schema"]: x for x in tarefas(diff(v1, v2), pasta)}
        assert t["Pedido"]["definicao"] and not t["Pedido"]["sem_classe"]
        assert t["Avaliacao"]["sem_classe"]
        removido = next(m for m in t["Pedido"]["mudancas"] if m["campo"] == "distanciaKm")
        assert removido["codigo"], "campo removido deveria apontar o uso no código"
    print("ok")


def main():
    sys.stdout.reconfigure(encoding="utf-8")  # acentos legíveis também no console do Windows
    if sys.argv[1:] == ["--teste"]:
        autoteste()
        return
    p = argparse.ArgumentParser()
    p.add_argument("--anterior", required=True)
    p.add_argument("--novo", required=True)
    p.add_argument("--codigo", required=True)
    p.add_argument("--saida", required=True)
    a = p.parse_args()
    ler = lambda caminho: json.loads(Path(caminho).read_text(encoding="utf-8"))
    resultado = tarefas(diff(ler(a.anterior), ler(a.novo)), a.codigo)
    Path(a.saida).parent.mkdir(parents=True, exist_ok=True)
    Path(a.saida).write_text(json.dumps(resultado, ensure_ascii=False, indent=2), encoding="utf-8")
    total = sum(len(t["mudancas"]) for t in resultado)
    print(f"{total} mudança(s) em {len(resultado)} tarefa(s); sem_classe: {sum(t['sem_classe'] for t in resultado)}")
    print("FIM ok")


if __name__ == "__main__":
    main()
