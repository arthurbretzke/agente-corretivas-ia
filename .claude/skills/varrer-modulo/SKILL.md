---
name: varrer-modulo
description: Varredura inicial em massa de um pacote ou módulo, gerando esqueletos de entradas não validadas para a base de processos. Use para começar a base de um código ainda não mapeado.
---

# Varrer módulo

Para cada endpoint (`@RestController`) e cada serviço (`@Service`) do pacote informado:

1. Identifique o processo de negócio pelo nome da classe, pelo endpoint e pelos comentários.
2. Liste as classes que participam do fluxo, confirmadas por referência real no código (injeção, chamada), nunca
   por semelhança de nome.
3. Não conseguiu confirmar uma relação com segurança: inclua a entrada mesmo assim e registre a incerteza em
   "Observações". Não omita nem complete por suposição.

Todas as entradas usam **valores fixos**, independente da qualidade da descoberta:
- Confiança: `gerado por varredura automática — não validado manualmente`
- Última validação: em branco

Use o formato da skill `mapear-processo`, sem as seções de métrica, reincidências e lacunas.

Mais de ~15 entradas: pare depois de 15 e pergunte se continua. Ao terminar, **não grave nada**: mostre as
entradas com o slug sugerido de cada uma para o humano revisar antes.
