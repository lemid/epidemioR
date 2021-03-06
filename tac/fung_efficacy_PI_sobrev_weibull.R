# Ensaio de Efici�ncia dos fungicidas em frutos maduros destacados (ex vivo).

# Objetivo ----------------------------------------------------------------

# 1. Analisar o momento em que apareceram os sintomas da doen�a relacionando spp X fungicidas;
# 2. O evento estimado ao longo do tempo ser� o PI (per�odo de incuba��o) - medida epidemiol�gica;
# 3. Aplica��o do modelo de regress�o param�trico de Weibull (esquema fatorial).


# -------------------------------------------------------------------------

# Pacotes.

rm(list = objects())

library(tidyverse)
library(survival)
library(emmeans)

# Ser� usada a `ordered_cld()`.
url <- "https://raw.githubusercontent.com/walmes/wzRfun/master/R/pairwise.R"
source(url)


# -------------------------------------------------------------------------

# Importa��o dos dados e prepara��o.

# An�lise dos dados (leitura).
da <- read_tsv("frutosmaduros.txt")
attr(da, "spec") <- NULL
str(da)

# Tabela de frequ�ncia cruzada.
xtabs(~spp + fung, data = da)

# Existe NA em algum lugar?
u <- !complete.cases(da)
sum(u)
da[u, ]

# # Substitui o NA por censura a direita.
# da <- da %>%
#   replace_na(replace = list(status = 0))

# Criar fatores.
da <- da %>%
  mutate(fung = factor(fung),
         spp = factor(spp),
         ue = interaction(fung, spp, rep))

# A tabela cont�m o registro dia ap�s dia de cada unidade 
#experimental. O evento ocorre quando o vari�vel `status` troca de valor
# 0 para 1.
da %>%
  filter(ue == levels(ue)[1])

# Determina a primeira data de valor `status == 1` para cada unidade
# experimental.
da_1 <- da %>%
  group_by(ue) %>%
  filter(status == 1) %>%
  top_n(day, n = -1)
da_1

# Determina a �ltima data de valor `status == 0` para cada unidade
# experimental restante, ou seja, que n�o apresentou `status == 1`.
da_0 <- anti_join(da, da_1, by = "ue") %>%
  group_by(ue) %>%
  top_n(day, n = 1)
da_0

# Junta as duas por��es.
da_final <- bind_rows(da_1, da_0) %>%
  ungroup()
da_final

xtabs(~fung + spp, data = da_final)

xtabs(status ~ fung + spp, data = da_final)

# Verifica.
da_final %>%
  filter(spp == "Ch", fung == "mythos") %>%
  print(n = Inf)


# -------------------------------------------------------------------------

# An�lise explorat�ria.

str(da_final)

# Ordena pelo dia do evento dentro de cada unidade experimental.
da_final <- da_final %>%
  group_by(spp, fung) %>%
  arrange(day) %>%
  mutate(ord = seq_along(day)/n())

# Gr�fico com a linha do tempo de cada fruto que mostra quando o evento
# aconteceu e que tipo de desfecho.

ggplot(data = da_final,
       mapping = aes(x = day, y = ord, shape = factor(status))) +
  facet_grid(facets = spp ~ fung) +
  geom_point() +
  geom_segment(mapping = aes(x = 0, y = ord, xend = day, yend = ord)) +
  scale_shape_manual(breaks = c(0, 1),
                     values = c(1, 19),
                     labels = c("Censura", "Sintoma")) +
  labs(shape = "Desfecho",
       x = "Dias ap�s inocula��o",
       y = "Ordem do fruto") +
  scale_x_continuous(breaks = seq(0, max(da_final$day), by = 2))


# ATEN��O -----------------------------------------------------------------

# Ser� feita an�lise de sobrevi�ncia com esses dados pois � motivada
# pelo tipo de resposta de natureza "tempo at� desfecho". Para acomodar
# a estrutura de planejamento fatorial completo 2 x 6, ser� usada uma
# abordagem param�trica. Por apresentar boa flexibilidade, ser� usada a
# distribui��o Weibull para o tempo at� o desfecho. Com isso consegue-se
# acomodar a censura e a estrutura experimental.


# -------------------------------------------------------------------------

# Antes de ir para o ajuste da Weibull, vamos reconhecer a
# parametriza��o.

# Gera n�meros aleat�rios de uma distribui��o Weibull.

y <- rweibull(n = 1000, shape = 4, scale = 2)
plot(ecdf(y))

# Ajusta o modelo com a `survreg()`.
m <- survreg(formula = Surv(time = y) ~ 1, dist = "weibull")
summary(m)

# Compreende os coeficientes estimados.
exp(coef(m)) # scale = exp(coef) -> 2.

1/m$scale    # shape = 1/m$scale -> 4.

# Verifica o ajuste com obsevado vs ajustado.
plot(ecdf(y))
curve(pweibull(x, shape = 1/m$scale, scale = exp(coef(m))),
      add = TRUE,
      col = 2)

# Obten��o do tempo m�dio.
a <- 1/m$scale
b <- unname(exp(coef(m))[1])
c("sample_mean" = mean(y),
  "estimated_mean" = b * gamma(1 + 1/a))


# -------------------------------------------------------------------------

# Ajustar a Weibull acomodando a estrutura experimental.

# COMENT�RIO: a an�lise de sobreviv�ncia � a abrodagem mais adequada para
# an�lise destes dados, visto que de fato a vari�vel resposta � o tempo
# para o desfecho e tem-se censura.

# A modelagem � para a vari�vel aleat�ria `tempo para aparecimento de
# sintoma` (desfecho).

s <- with(da_final,
          Surv(time = day,
               event = status))

# Modelo nulo que n�o tem efeito de nenhum fator.
m0 <- survreg(formula = s ~ 1,
              data = da_final,
              dist = "weibull")

# Inclui o efeito de esp�cie.
m1 <- survreg(formula = s ~ spp,
              data = da_final,
              dist = "weibull")

# Inclui o efeito de esp�cie e fungicidas (aditivo).
m2 <- survreg(formula = s ~ spp + fung,
              data = da_final,
              dist = "weibull")

# Inclui o efeito de esp�cie e fungicidas com intera��o.
m3 <- survreg(formula = s ~ spp * fung,
              data = da_final,
              dist = "weibull")

# Teste da raz�o de verossimilhan�as entre modelos encaixados.
anova(m0, m1, m2, m3)


# O modelo com intera��o � o mais apropriado para descrever o tempo para
# o aparecimento de sintomas. Portanto, existe intera��o entre esp�cies
# e produtos ao n�vel de 5% pelo teste da deviance entre modelos
# encaixados.

# Modelo final.
mx <- m3


# -------------------------------------------------------------------------
# Extra��o dos tempos m�dios e confec��o das curvas de sobreviv�ncia.

# M�dias amostrais (que ignoram estrutura e censura).
# da_final %>%
#     group_by(spp, fung) %>%
#     summarise(m_day = mean(day))

# M�dias ajustadas (� na interpreta��o do par�metro da Weibull).
emm <- emmeans(mx,
               specs = ~spp + fung)
emm

tb_emm <- as.data.frame(emm)

# Estimativas conforme parametriza��o da {p, d, q, r}weibull.
a <- 1/mx$scale          # shape.
b <- exp(tb_emm$emmean)  # scale.

# Obten��o do tempo m�dio (� uma fun��o complexa dos dois par�metros).
tb_emm$mean_day <- b * gamma(1 + 1/a)
tb_emm

# Curvas de probabilidade de desfecho.
tb_curves <- tb_emm %>%
  group_by(spp, fung) %>%
  do({
    day <- seq(0, 20, length.out = 51)
    dens <- dweibull(day, shape = a, scale = exp(.$emmean))
    accu <- pweibull(day, shape = a, scale = exp(.$emmean))
    data.frame(day, dens, accu)
  }) %>%
  ungroup()

# As curvas de densidade ajustadas.
ggplot(data = tb_curves,
       mapping = aes(x = day, y = dens)) +
  facet_grid(facets = spp ~ fung) +
  geom_line()

# As curvas de "1 - sobrevi�ncia".
ggplot(data = tb_curves,
       mapping = aes(x = day, y = accu)) +
  facet_grid(facets = spp ~ fung) +
  geom_line()

# Valores observados com sobreposi��o das curvas ajustadas.
ggplot(data = da_final,
       mapping = aes(x = day, y = ord, shape = factor(status))) +
  facet_grid(facets = spp ~ fung) +
  geom_point() +
  scale_shape_manual(breaks = c(0, 1),
                     values = c(1, 19),
                     labels = c("Censura", "Sintoma")) +
  labs(shape = "Desfecho",
       x = "Dias ap�s inocula��o",
       y = "Frequ�ncia acumulada") +
  geom_vline(data = tb_emm,
             mapping = aes(xintercept = mean_day),
             color = "orange") +
  geom_line(data = tb_curves,
            inherit.aes = FALSE,
            mapping = aes(x = day, y = accu))


# -------------------------------------------------------------------------

# Fazendo o estudo da intera��o com desdobramento com testes para o
# par�metro de loca��o.

# Estudar produtos em cada esp�cie.
emm_fung_in <- emmeans(mx, specs = ~fung | spp)
emm_fung_in

# contrast(emm_fung_in, method = "pairwise")
fung_in_comp <- multcomp::cld(emm_fung_in)
fung_in_comp

# Tabela com o resultado das compara��es m�ltiplas.
tb_contr <- as.data.frame(fung_in_comp)
tb_contr

# Transformar os n�meros para letras e ordenar as letras conforme as
# estimativas.
f <- function(x) {
  l <- x %>%
    str_trim() %>%
    str_split("") %>%
    flatten_chr() %>%
    as.integer()
  str_c(letters[l], collapse = "")
}
f(" 123 ")

# Acerta a representa��o da signific�ncia dos contrastes com letras.
tb_contr <- tb_contr %>%
  mutate(let = map_chr(.group, f)) %>%
  group_by(spp) %>%
  mutate(let2 = ordered_cld(let = let, means = emmean))

ggplot(data = tb_contr,
       mapping = aes(x = fung, y = emmean)) +
  facet_wrap(facets = ~spp) +
  geom_point() +
  geom_errorbar(mapping = aes(ymin = lower.CL,
                              ymax = upper.CL),
                width = 0.05) +
  geom_text(mapping = aes(label = sprintf("%0.2f %s",
                                          emmean,
                                          let2)),
            hjust = 0.5,
            vjust = -1,
            angle = 90,
            nudge_x = 0.075) +
  labs(x = "fungicidas",
       y = "Estimativa do par�metro de loca��o")
