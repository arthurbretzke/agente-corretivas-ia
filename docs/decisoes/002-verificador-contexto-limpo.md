# 002: Verificador e revisor de contexto limpo

**Contexto.** O agente que investiga um bug acumula viés de confirmação: depois de escolher uma hipótese, tende a
ler as evidências a favor dela.

**Decisão.** A causa raiz e a correção são avaliadas por subagentes que não recebem a investigação, só a issue,
a causa declarada (verificador) ou o diff (revisor). O papel deles é tentar refutar, não aprovar.

**Consequências.** Mais tokens por issue (dois contextos extras). Em troca, causas erradas são barradas antes de
virar código, e o PR chega ao humano já revisado por alguém "de fora".
