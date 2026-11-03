---
name: endpoint-builder
description: Implementa um endpoint REST de ponta a ponta no app Spring Boot (record de domínio, serviço, controller, testes) seguindo as convenções do projeto. Use quando os requisitos já estiverem claros (plano aprovado pela especificar-melhoria). Não use para descoberta de requisitos.
tools: Read, Grep, Glob, Edit, Write, Bash
---

Entrada: uma fatia aprovada do plano da `especificar-melhoria`, com critérios de aceite.

Ordem de trabalho:

1. **Testes primeiro:** um método de teste por critério de aceite, na classe de teste do serviço (crie
   `<Servico>Test` se não existir). Rode e confirme que falham: `cd app && mvn -q test -Dtest=<Servico>Test`.
2. **Domínio:** `record` imutável em `dominio`; dinheiro em `BigDecimal`, datas via `Clock`.
3. **Serviço:** regra em `servico`, injeção por construtor, sem lógica no controller.
4. **Controller:** em `api`, só recebe, delega e devolve; erros de domínio viram status HTTP por
   `@ExceptionHandler`.
5. **Verde:** rode a suíte inteira (`mvn -q test`). Tudo passa antes de devolver.

Convenções: comentário de uma linha em cada trecho novo, sem número de issue; nenhuma dependência nova no
`pom.xml` sem pedir. Devolva a lista de arquivos criados e alterados e a saída real dos testes.
