---------------------
  #                                            Prof. Dr. Walmes M. Zeviani
  #                                leg.ufpr.br/~walmes · github.com/walmes
  #                                        walmes@ufpr.br · @walmeszeviani
  #                      Laboratory of Statistics and Geoinformation (LEG)
  #                Department of Statistics · Federal University of Paraná
  #                                       2019-Fev-28 · Curitiba/PR/Brazil
  #-----------------------------------------------------------------------

#=======================================================================
# Análise de sobreviência para incubação.

#-----------------------------------------------------------------------
# Pacotes
# Para ter um espaço de trabalho limpo.
rm(list = objects())

library(survival)
library(lsmeans)
# ls("package:lsmeans")

library(tidyverse)

#-----------------------------------------------------------------------
# Leitura dos dados.

da <- read_csv2("maca_diam_lesao_n16.csv", locale = locale(decimal_mark = ","))
attr(da, "spec") <- NULL
da

# Tabela de frequência das combinações experimentais.
da %>%
  xtabs(formula = ~temp)

# Empilhar os dados no eixo do tempo.
db <- da %>%
  gather(key = "dai", value = "diam", -(1:3)) %>%
  mutate(dai = as.integer(dai)) %>%
  arrange(temp, rep, dai)
str(db)

# Obtém o tempo de inoculação para as UE que tiveram o evento observado.
dc <- db %>%
  filter(diam > 0) %>%
  group_by(temp, rep) %>%
  summarise(diam = first(diam),
            dai = first(dai)) %>%
  ungroup()

# A diferença corresponde as UE com censura a direita.
c(nrow(da), nrow(dc))

# Cria uma cópia de todas as celas com informação do status.
dd <- da %>%
  select(1:3) %>%
  mutate(status = 1)

# Realiza a junção. Onde tiver `NA` são os censurados.
dd <- full_join(dc, dd, by = c("temp", "rep"))
dd %>% print(n = Inf)

# Muda o valor de status e substitui oa `NA` por valores.
dd <- dd %>%
  mutate(status = ifelse(is.na(dai), 0, 1)) %>%
  replace_na(list(dai = 13, diam = 0))
dd %>% print(n = Inf)

#-----------------------------------------------------------------------
# Análise exploratória.

ggplot(data = dd,
       mapping = aes(x = temp,
                     y = dai)) +
  geom_point(mapping = aes(color = factor(status))) +
  stat_summary(geom = "line",
               fun.y = mean) +
  labs(color = "Incubação") +
  xlab(expression("Temperatura" ~ (degree * C))) +
  ylab("Per??odo após a inoculação (dias)")

#-----------------------------------------------------------------------
# Análise de sobrevivência.

# Com letra maiúscula são as versões categóricas dos fatores
# experimentais.
dd <- dd %>%
  mutate(Temp = factor(temp))

# A modelagem é para a variável aleatória `tempo para a queda da
# folha`. A queda d folha é o desfecho.
s <- with(dd,
          Surv(time = dai,
               event = status,
               type = "right"))
s

# Modelo com interação tripla.
m2 <- survreg(formula = s ~ Temp,
              data = dd,
              dist = "weibull")
anova(m2)

# Estimativas dos efeitos.
summary(m2)

# Médias ajustadas com valor fixado de molhamento.
lsm <- lsmeans(object = m2,
               specs = ~Temp)
lsm

# Gráfico padrão.
plot(lsm)

# Pega a tabela com o IC para fazer o gráfico com a ggplot2.
lsm <- (summary(lsm))
lsm

# Gráfico.
ggplot(data = lsm,
       mapping = aes(x = Temp, y = lsmean)) +
  geom_point() +
  geom_errorbar(mapping = aes(ymin = lower.CL,
                              ymax = upper.CL),
                width = 0.05)

#-----------------------------------------------------------------------
# Tempo médio.

# Aplica ls means para combinações de molhamento e temperatura.
tb_medias <- lsm

# Calculando o tempo médio de inoculação com IC.
tb_medias$media <- exp(tb_medias$lsmean) * gamma(1 + m2$scale)
tb_medias$lwr <- exp(tb_medias$lower.CL) * gamma(1 + m2$scale)
tb_medias$upr <- exp(tb_medias$upper.CL) * gamma(1 + m2$scale)

# Gráfico.
ggplot(data = tb_medias,
       mapping = aes(x = Temp, y = media)) +
  geom_point() +
  geom_line(aes(group = 1), color = "gray50") +
  geom_errorbar(mapping = aes(ymin = lwr,
                              ymax = upr),
                width = 0.05)

# Gráfico.
ggplot(data = filter(tb_medias, !Temp %in% c("5", "10", "12", "35")),
       mapping = aes(x = Temp, y = media)) +
  geom_point() +
  geom_line(aes(group = 1), color = "gray50") +
  geom_errorbar(mapping = aes(ymin = lwr,
                              ymax = upr),
                width = 0.05) +
  xlab(expression("temperature" ~ (degree * C))) +
  ylab("days after inoculation")

tb_medias %>%
  select(Temp, media, lwr, upr) %>%
  arrange(Temp)

#-----------------------------------------------------------------------
#-----------------------------------------------------------------------
# Ajuste de modelo para crescimento da lesão.

dc <- da %>%

  mutate(fruto = 1:n()) %>%
  gather(key = "dai", value = "diam", -c(isol, temp, rep, fruto)) %>%
  mutate(dai = as.integer(dai))
str(dc)

dc <- dc %>%
  filter(diam > 0) %>%
  mutate(diam = sqrt(diam))

ggplot(data = dc,
       mapping = aes(x = dai,
                     y = (diam),
                     color = factor(rep))) +
  geom_point() +
  stat_summary(geom = "line",
               fun.y = mean) +
  facet_wrap(facets = ~temp, nrow = 1) +
  xlab("Per??odo após a inoculação (dias)") +
  ylab("Diâmetro da lesão no fruto")

#-----------------------------------------------------------------------
# Ajuste do modelo para o tamanho da lesão.

# Lista para guardar os ajustes.
fits <- list()

# Expressão do modelo para usar na nls().
model <- diam ~ 0 + (dai > dai_inc) *
  A * (1 - exp(-log(2) * (dai - dai_inc)/V))

# Função do modelo para usar dentro da curve().
expr <- function(dai, A, V, dai_inc) {
  0 + (dai > dai_inc) * A * (1 - exp(-log(2) * (dai - dai_inc)/V))
}

#-----------------------------------------------------------------------
# Temperatura 10

t <- 10

# Tempo de incubação.
dai_inc <- tb_medias$media[tb_medias$Temp == "10"]
dai_inc

# Verifica os valores iniciais.
plot(diam ~ dai, data = filter(dc, temp == t),
     xlim = c(0, 18), ylim = c(0, max(dc$diam)))
start <- list(A = 9, V = 2, dai_inc = dai_inc)
with(start,
     curve(expr(dai, A, V, dai_inc),
           xname = "dai", add = TRUE, col = 2))

# Temperatura 10.
fits$temp10 <- nls(model,
                   data = filter(dc, temp == t),
                   start = start)
summary(fits$temp10)

# Verifica como ficou o ajuste.
plot(diam ~ dai, data = filter(dc, temp == t),
     xlim = c(0, 18), ylim = c(0, max(dc$diam)))
# with(c(as.list(coef(fits$temp10)), dai_inc = dai_inc),
with(as.list(coef(fits$temp10)),
     curve(expr(dai, A, V, dai_inc),
           xname = "dai", add = TRUE, col = 2))

#-----------------------------------------------------------------------

# Temperatura 12.
  

t <- 12

# Tempo de incubação.
dai_inc <- tb_medias$media[tb_medias$Temp == "12"]
dai_inc

# Verifica os valores iniciais.
plot(diam ~ dai, data = filter(dc, temp == t),
     xlim = c(0, 18), ylim = c(0, max(dc$diam)))
start <- list(A = 15, V = 6, dai_inc = dai_inc)
with(start,
     curve(expr(dai, A, V, dai_inc),
           xname = "dai", add = TRUE, col = 2))

# Temperatura 12.
fits$temp12 <- nls(model,
                   data = filter(dc, temp == t),
                   start = start)
summary(fits$temp12)

# Verifica como ficou o ajuste.
plot(diam ~ dai, data = filter(dc, temp == t),
     xlim = c(0, 18), ylim = c(0, max(dc$diam)))
# with(c(as.list(coef(fits$temp12)), dai_inc = dai_inc),
with(as.list(coef(fits$temp12)),
     curve(expr(dai, A, V, dai_inc),
           xname = "dai", add = TRUE, col = 2))

# Temperatura 16.

t <- 16

# Tempo de incubação.
dai_inc <- tb_medias$media[tb_medias$Temp == "16"]
dai_inc

# Verifica os valores iniciais.
plot(diam ~ dai, data = filter(dc, temp == t),
     xlim = c(0, 18), ylim = c(0, max(dc$diam)))
start <- list(A = 5, V = 5, dai_inc = dai_inc)
with(start,
     curve(expr(dai, A, V, dai_inc),
           xname = "dai", add = TRUE, col = 2))

# Temperatura 16.
fits$temp16 <- nls(model,
                   data = filter(dc, temp == t),
                   start = start)
summary(fits$temp16)

# Verifica como ficou o ajuste.
plot(diam ~ dai, data = filter(dc, temp == t),
     xlim = c(0, 18), ylim = c(0, max(dc$diam)))
# with(c(as.list(coef(fits$temp16)), dai_inc = dai_inc),
with(as.list(coef(fits$temp16)),
     curve(expr(dai, A, V, dai_inc),
           xname = "dai", add = TRUE, col = 2))

#-----------------------------------------------------------------------
# Temperatura 20.

t <- 20

# Tempo de incubação.
dai_inc <- tb_medias$media[tb_medias$Temp == "20"]
dai_inc

# Verifica os valores iniciais.
plot(diam ~ dai, data = filter(dc, temp == t),
     xlim = c(0, 18), ylim = c(0, max(dc$diam)))
start <- list(A = 50, V = 10, dai_inc = dai_inc)
with(start,
     curve(expr(dai, A, V, dai_inc),
           xname = "dai", add = TRUE, col = 2))

# Temperatura 20.
fits$temp20 <- nls(model,
                   data = filter(dc, temp == t),
                   start = start)
summary(fits$temp20)

# Verifica como ficou o ajuste.
plot(diam ~ dai, data = filter(dc, temp == t),
     xlim = c(0, 18), ylim = c(0, max(dc$diam)))
# with(c(as.list(coef(fits$temp20)), dai_inc = dai_inc),
with(as.list(coef(fits$temp20)),
     curve(expr(dai, A, V, dai_inc),
           xname = "dai", add = TRUE, col = 2))
#-----------------------------------------------------------------------

# Temperatura 25.

t <- 25

# Tempo de incubação.
dai_inc <- tb_medias$media[tb_medias$Temp == "25"]
dai_inc

# Verifica os valores iniciais.
plot(diam ~ dai, data = filter(dc, temp == t),
     xlim = c(0, 18), ylim = c(0, max(dc$diam)))
start <- list(A = 80, V = 15, dai_inc = dai_inc)
with(start,
     curve(expr(dai, A, V, dai_inc),
           xname = "dai", add = TRUE, col = 2))

# Temperatura 25.
fits$temp25 <- nls(model,
                   data = filter(dc, temp == t),
                   start = start,
                   trace = TRUE)
summary(fits$temp25)

# Verifica como ficou o ajuste.
plot(diam ~ dai, data = filter(dc, temp == t),
     xlim = c(0, 18), ylim = c(0, max(dc$diam)))
# with(c(as.list(coef(fits$temp25)), dai_inc = dai_inc),
with(as.list(coef(fits$temp25)),
     curve(expr(dai, A, V, dai_inc),
           xname = "dai", add = TRUE, col = 2))

#-----------------------------------------------------------------------
# Resultado de todos os ajustes.

# Tabela dos coeficientes ajustados dos modelos.
# sapply(fits, coef)
# lapply(fits, confint.default)

# Estimativa com limite superior e inferior do intervalo de confiança.
lapply(fits, FUN = function(mod) {
  cbind(Estimate = coef(mod), confint.default(mod))
})

# As taxas iniciais de crescimento de lesão são dadas por:
#    f'(dai = dai_inc) = A * log(2)/V.

# Taxas relativas de crescimento inicial da lesão o instante 0.
tx <- function(model) {
  theta <- coef(model)
  theta["A"] * log(2)/theta["V"]
}

sapply(fits, tx)

#-----------------------------------------------------------------------
# Valores preditos.

grid <- data.frame(dai = seq(0, 18, length.out = 101))
grid <- cbind(grid, sapply(fits, predict, newdata = grid))
str(grid)

grid <- grid %>%
  gather(key = temp, value = diam, -dai) %>%
  mutate(temp = as.integer(str_replace(temp, "temp", "")))

ggplot(data = grid,
       mapping = aes(x = dai,
                     y = diam)) +
  geom_line() +
  facet_wrap(facets = ~temp) +
  geom_point(data = dc,
             mapping = aes(x = dai, y = diam))

#-----------------------------------------------------------------------
