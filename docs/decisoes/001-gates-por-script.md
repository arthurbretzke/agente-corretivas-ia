# 001: Gates verificados por script, não pelo modelo

**Contexto.** Um LLM pode afirmar "os testes passaram" sem ter rodado os testes, ou ler errado uma saída longa.

**Decisão.** Toda passagem de fase que depende de um fato verificável (teste vermelho → verde, evidências
presentes) é decidida por um script com saída fixa (`FIM ok` / `FIM falha`). O agente só pode declarar a fase
concluída citando essa linha.

**Consequências.** Menos liberdade para o agente, mais confiança no PR. O custo é manter os scripts simples o
bastante para não virarem a nova fonte de bugs.
