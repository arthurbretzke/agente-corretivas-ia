---
name: especificar-melhoria
description: >-
  Especificação e plano de melhoria (funcionalidade nova ou mudança de regra) antes de qualquer código. Use
  SEMPRE para "quero que passe a...", "incluir opção para...", "nova regra", "novo campo", "criar parâmetro",
  ou quando a `triagem` classificar a issue como melhoria disfarçada de bug. NÃO use para erro em algo que já
  deveria funcionar: isso é `triagem`.
---

# Especificar melhoria

Antes de qualquer código, entregue o plano abaixo e **pare** até o humano aprovar. Depois, execute fatia a fatia
no fluxo normal: testes vermelho → verde, revisão independente e dados afetados (entrega da skill `triagem`).

Pesquisa barata: Regra nº 0 (`knowledge/`), depois o agente `explorador-spring`. Não leia o projeto inteiro.

## O plano (7 itens, compacto)

```
1. Especificação
   Objetivo do usuário: <uma frase>
   Regras de negócio: <lista curta, com a fonte quando houver>
   Critérios de aceite: <cada um verificável>
2. Perguntas em aberto: <só as que mudam a implementação; "nenhuma" é válido>
3. Impacto em quem não pediu: parametrizar | mudar o padrão para todos
   Recomendação: <qual> porque <motivo>. Padrão: não mudar o comportamento de quem não pediu.
4. Funcionalidade análoga: <classe ou endpoint mais parecido que já existe> e o que copiar dela.
5. Testes de caracterização: <comportamento atual a registrar antes de mexer>. Viram a prova de que quem não
   pediu não foi afetado.
6. Fatias: <lista numerada; cada fatia pequena e validável sozinha>
7. Onde o código mora: <camada/pacote> porque <motivo>.
```

## Depois da aprovação ("pode seguir"): ADR

Grave `knowledge/decisoes/AAAA-MM-<slug>.md`, curto:

```
# <Decisão em uma frase>
- Data: AAAA-MM-DD · Rastreio: #<n>
## Contexto
<2-4 linhas: necessidade e restrições>
## Opções
- <opção A>: <prós e contras em 1 linha>
- <opção B>: ...
## Escolha e motivo
<opção escolhida> porque <motivo>. Impacto em quem não pediu: <...>
```
