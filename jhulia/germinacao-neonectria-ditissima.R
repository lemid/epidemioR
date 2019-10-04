#-----------------------------------------------------------------------
#                                            Prof. Dr. Walmes M. Zeviani
#                                leg.ufpr.br/~walmes · github.com/walmes
#                                        walmes@ufpr.br · @walmeszeviani
#                      Laboratory of Statistics and Geoinformation (LEG)
#                Department of Statistics · Federal University of Paraná
#                                       2019-Abr-23 · Curitiba/PR/Brazil
#-----------------------------------------------------------------------

# Ajuste de modelos para ensaio que avaliou a germinação em um
# experimento fatorial completamente cruzado com períodos de
# molhamento. Será 1) polinômios e 2) modelos não lineares para fazer o
# ajuste.

#-----------------------------------------------------------------------
# Pacotes.

rm(list = objects())

library(lattice)
library(latticeExtra)
library(tidyverse)
library(directlabels)

#-----------------------------------------------------------------------
# Importação dos dados.

tb <- read_csv2("germinacao-neonectria-ditissima.csv",
                comment = "#")
attr(tb, "spec") <- NULL
tb

tb$bloc <- ifelse(test = is.element(tb$temp,
                                    set = c(12, 16, 20, 26, 35)),
                  yes = "inoc1",
                  no = "inoc2")

#-----------------------------------------------------------------------
# Análise exploratória.

ggplot(data = tb) +
    aes(x = temp, y = ger, color = factor(pm), shape = bloc) +
    facet_wrap(facets = ~esp, ncol = 1) +
    geom_point() +
    stat_summary(aes(shape = NULL), fun.y = "mean", geom = "line") +
    labs(x = "Temperatura",
         y = "Germinação",
         color = "Período de\nmolhamento")

ggplot(data = tb) +
    aes(x = pm, y = ger, color = factor(temp), shape = bloc) +
    facet_wrap(facets = ~esp, ncol = 1) +
    geom_point() +
    stat_summary(aes(shape = NULL), fun.y = "mean", geom = "line") +
    labs(x = "Período de\nmolhamento",
         y = "Germinação",
         color = "Temperatura")

#-----------------------------------------------------------------------
# Os dados tem efeito de bloco que representa o inóculo usado no
# experimento. Diferentes condições levam a inóculos com diferentes
# viabilidades, etc. Por isso existe difereça de comportamento entre
# inóculos. O comportamento da germinação em relação à temperatura dá
# uma curva côncava com ponto de máximo no interior da região
# experimental. A germinação como função do período de molhamento
# sinaliza uma função monótona não descrecente. Na temperatura 35 não
# houve germinação. As impressões são as mesmas para ascósporos e
# conídios. Mas as análises serão feitas em separado.

#-----------------------------------------------------------------------
# Ascósporos. ----------------------------------------------------------
#-----------------------------------------------------------------------

tb_asc <- tb %>%
    filter(esp == "asc" & temp < 35)

ggplot(data = tb_asc) +
    aes(x = temp, y = ger) +
    facet_wrap(facets = ~pm) +
    geom_point() +
    geom_smooth(method = "lm", formula = y ~ poly(x, degree = 3))

ggplot(data = tb_asc) +
    aes(x = pm, y = ger) +
    facet_wrap(facets = ~temp) +
    geom_point() +
    geom_smooth(method = "lm", formula = y ~ poly(x, degree = 3))

#-----------------------------------------------------------------------
# Ajuste de modelo polinômial.

# Modelo fatorial completamente cruzado considerado os fatores como
# categóricosd. Esse é o modelo maximal.
mx <- lm(ger ~ bloc + factor(temp) * factor(pm),
         data = tb_asc)
anova(mx)

# Modelo quadrático completo.
m0 <- lm(ger ~ bloc + poly(temp, degree = 3) * poly(pm, degree = 3),
         data = tb_asc)

# Diagnóstico.
par(mfrow = c(2, 2))
plot(m0)
layout(1)

# Existe falta de ajuste com relação ao maximal?
anova(m0, mx)

# ATTENTION: embora possa haver falta de ajuste com o modelo maximal, o
# modelo de polinômio permite interpolar previsões para fazer a
# superfície.

# Existe interação entre temperatura e molhamento?
anova(m0)
summary(m0)

summary(tb_asc)

# Valores usados no experimento e malha fina para predição.
pm_u <- unique(tb_asc$pm)
pm_s <- seq(from = 2, to = 61, length.out = 51)
temp_u <- unique(tb_asc$temp)
temp_s <- seq(from = 11, to = 29, length.out = 51)
bloc_i <- unique(tb_asc$bloc)[1]

#-----------------------------------------------------------------------
# Para verificar como ficou o ajuste como função da temperatura.

# ATTENTION: predição considerando bloco 1 e não média dos blocos.
grid <- crossing(temp = temp_s, pm = pm_u, bloc = bloc_i)
grid$ger <- predict(m0, newdata = grid)

# Faz a média no efeito dos blocos.
grid$ger <- grid$ger + 0.5 * coef(m0)["blocinoc2"]

ggplot(data = tb_asc) +
    aes(x = temp, y = ger) +
    facet_wrap(facets = ~pm) +
    geom_point() +
    geom_line(data = grid,
              mapping = aes(x = temp, y = ger), color = "green3")

#-----------------------------------------------------------------------
# Para verificar como ficou o ajuste como função da temperatura.

# ATTENTION: predição considerando bloco 1 e não média dos blocos.
grid <- crossing(temp = temp_u, pm = pm_s, bloc = bloc_i)
grid$ger <- predict(m0, newdata = grid)

# Faz a média no efeito dos blocos.
grid$ger <- grid$ger + 0.5 * coef(m0)["blocinoc2"]

ggplot(data = tb_asc) +
    aes(x = pm, y = ger) +
    facet_wrap(facets = ~temp) +
    geom_point() +
    geom_line(data = grid,
              mapping = aes(x = pm, y = ger), color = "tomato")

#-----------------------------------------------------------------------
# Gráfico da predição consirando ambos fatores simultâneamente.

grid <- crossing(temp = temp_s,
                 pm = pm_s,
                 bloc = bloc_i)
grid$ger <- predict(m0, newdata = grid)

# Faz a média no efeito dos blocos.
grid$ger <- grid$ger + 0.5 * coef(m0)["blocinoc2"]

gg <-
    ggplot(data = grid) +
    aes(x = temp, y = pm) +
    geom_raster(aes(fill = ger)) +
    geom_contour(aes(z = ger, color = ..level..),
                 color = "black",
                 size = 0.25) +
    scale_fill_distiller(palette = "Spectral", direction = 1) +
    labs(x = "Temperatura",
         y = "Período de molhamento",
         fill = "Germinação") +
    theme_light()
gg

# Qual e temperatura ótima para cada molhamento?
opt_temp <- function(temp, pm) {
    -predict(m0,
             newdata = data.frame(temp = temp,
                                  pm = pm,
                                  bloc = bloc_i))
}

# Determinar a temperatura ótima para vários valores de molhamento.
pm_seq <- seq(3, 60, by = 3)
temp_opt <- sapply(pm_seq,
                   FUN = function(pm) {
                       optim(par = c(20),
                             fn = opt_temp,
                             pm = pm,
                             method = "Brent",
                             lower = 12,
                             upper = 28)$par
                   })

gg <- gg +
    geom_path(data = data.frame(temp = temp_opt, pm = pm_seq),
              mapping = aes(x = temp, y = pm),
              linetype = 2) +
    geom_vline(xintercept = seq(10, 30, by = 2.5),
               size = 0.5, linetype = 3, color = "gray50") +
    geom_hline(yintercept = seq(0, 60, by = 5),
               size = 0.5, linetype = 3, color = "gray50")

direct.label(gg, list("top.pieces",
                      colour = "black",
                      hjust = 1,
                      vjust = 1))

#-----------------------------------------------------------------------
# Gráfico 3D.

source("https://github.com/walmes/wzRfun/raw/master/R/panel.3d.contour.R")

colr <- brewer.pal(11, "Spectral")
colr <- colorRampPalette(colr, space = "rgb")

wireframe(ger ~ pm + temp,
          data = grid,
          scales = list(arrows = FALSE),
          zlim = c(0, 100),
          panel.3d.wireframe = panel.3d.contour,
          type = c("on", "top", "bottom")[1],
          col.regions = colr(101),
          col = "gray50",
          col.contour = "black",
          par.settings = list(regions = list(alpha = 0.7)),
          drape = TRUE,
          xlab = list("Período de molhamento", rot = 30),
          ylab = list("Temperatura", rot = -38),
          zlab = list("Germinação", rot = 90)) +
    latticeExtra::layer({
        with(tb_asc,
             panel.cloud(x = pm,
                         y = temp,
                         subscripts = 1:length(temp),
                         z = ger,
                         type = "p",
                         col = "black",
                         pch = 1,
                         alpha = 1,
                         ...))
    })

# CAUTION: esse gráfico 3D é extremamente questionável em termos de
# utilidade, eficiência e expressividade. Não é possível fazer qualquer
# julgamento acurado sobre o comportamento da função em nunhuma das
# direções, tão pouco verificar se o modelo se ajusta aos dados. Você
# está oferencendo algo que não utilidade alguma. Eu fortemente
# desencojado o seu uso dando preferência para os gráficos apresentados
# antes desse que são melhores para julgar adequação do modelo e
# entender o comparamento da função na direção da temperatura e período
# de molhamento. Existem inúmeros artigos sobre visualização de dados
# recomendando o não uso de visualizações em 3D. Use por sua conta e
# risco.

#-----------------------------------------------------------------------
# Ajuste de modelo não linear.

# Valores fixamos para estimação da beta generalizada.
t_min <- 5
t_max <- 35

# source("https://raw.githubusercontent.com/walmes/wzRfun/master/R/rp.nls.R")
# library(rpanel)
#
# tb_asc$grp <- factor(tb_asc$pm)
# str(tb_asc)
#
# model <-
#     ger ~ exp(b1) * (temp - t_min)^exp(b3) * (t_max - temp)^exp(b5)
#
# eye_fit <- rp.nls(model = model,
#                   data = as.data.frame(tb_asc),
#                   subset = "grp",
#                   start = list(b1 = c(-8, 2),
#                                b3 = c(-2, 2),
#                                b5 = c(-2, 2)))
# dput(sapply(eye_fit, FUN = coef))

eye_coef <-
    structure(c(-12.730483989427, 1.05033907453802, 1.07664754456808,
                -11.265322576423, 1.06411975602676, 0.951244715862163,
                -6.50420693554943, 0.687215631463602, 0.576311488723139,
                -5.94021873221621, 0.645834793400137, 0.59968632529966,
                -2.52221791784997, 0.201865729050778, 0.236065337237383,
                -0.880964939027934, -0.117360550458558,
                0.0136063718398191, -1.72348045204139,
                0.0667346636461368, 0.163334703168507),
              .Dim = c(3L, 7L),
              .Dimnames = list(
                  c("b1", "b3", "b5"),
                  c("3", "6", "12", "24", "36", "48", "60")))

#-----------------------------------------------------------------------
# Ajuste da beta generalizada por perído de molhamento.

library(nlme)

rowMeans(eye_coef)

# Valores fixamos para estimação da beta generalizada.
t_min <- 5
t_max <- 35

model <-
    ger ~ exp(b1) * (temp - t_min)^exp(b3) * (t_max - temp)^exp(b5) | pm

n0 <- nlsList(model = model,
              start = rowMeans(eye_coef),
              data = tb_asc)
n0

# GOOD: deu ajuste. Fazer a predição.
grid <- crossing(pm = pm_u, temp = temp_s)
grid$ger <- predict(n0, newdata = grid)

ggplot(data = tb_asc) +
    aes(x = temp, y = ger) +
    facet_wrap(facets = ~pm) +
    geom_point() +
    geom_line(data = grid,
              mapping = aes(x = temp, y = ger), color = "green3")

#-----------------------------------------------------------------------
# Ajuste da beta generalizada * monomolecular.

model <-
    ger ~ exp(b1) * (temp - t_min)^exp(b3) * (t_max - temp)^exp(b5) *
        (1 - exp(b6) * exp(-b7 * pm))

n1 <- nls(model, data = tb_asc,
          start = list(b1 = -2,
                       b3 = 0.5,
                       b5 = 0.5,
                       b6 = 1,
                       b7 = 0.01))
summary(n1)

# Para temperatura em cada molhamento.
grid <- crossing(pm = pm_u, temp = temp_s)
grid$ger <- predict(n1, newdata = grid)

ggplot(data = tb_asc) +
    aes(x = temp, y = ger) +
    facet_wrap(facets = ~pm) +
    geom_point() +
    geom_line(data = grid,
              mapping = aes(x = temp, y = ger), color = "turquoise3")

# Para molhamento em cada temperatura.
grid <- crossing(temp = temp_u, pm = pm_s)
grid$ger <- predict(n1, newdata = grid)

ggplot(data = tb_asc) +
    aes(x = pm, y = ger) +
    facet_wrap(facets = ~temp) +
    geom_point() +
    geom_line(data = grid,
              mapping = aes(x = pm, y = ger), color = "chocolate")

#-----------------------------------------------------------------------
# Predição usando ambas os fatores.

grid <- crossing(temp = temp_s, pm = pm_s)
grid$ger <- predict(n1, newdata = grid)

gg <- ggplot(data = grid) +
    aes(x = temp, y = pm) +
    geom_raster(aes(fill = ger)) +
    geom_contour(aes(z = ger, color = ..level..),
                 color = "black",
                 size = 0.25) +
    scale_fill_distiller(palette = "Spectral", direction = 1) +
    labs(x = "Temperatura",
         y = "Período de molhamento",
         fill = "Germinação") +
    theme_light()
gg

# Qual e temperatura ótima para cada molhamento?
t_opt <- with(as.list(coef(n1)), {
    u <- exp(b3)/(exp(b3) + exp(b5))
    t_min + (t_max - t_min) * u
})

gg <- gg +
    geom_vline(xintercept = t_opt, linetype = 2) +
    geom_vline(xintercept = seq(10, 30, by = 2.5),
               size = 0.5, linetype = 3, color = "gray50") +
    geom_hline(yintercept = seq(0, 60, by = 5),
               size = 0.5, linetype = 3, color = "gray50")

direct.label(gg, list("top.pieces",
                      colour = "black",
                      hjust = 1,
                      vjust = 1))

#***********************************************************************
# CAUTION: O modelo `m0` é bem mais adequado para o ajuste do que o
# `n1`. Isso porque em `m0` 1) está acomodado o efeito de blocos, 2)
# possui termos de interação que são significativos, 3) polinômios
# cúbicos são bem mais flexíveis e portanto o ajuste do modelo aos
# dados. Portanto, considere o ajuste da beta generalizada com
# monolecular com cuidado para fazer a discussão pois ele é um modelo
# que apresenta falta de ajuste em relação ao modelo polinômial.

# Diferença de ajuste dos modelos.
cor(fitted(mx), tb_asc$ger)^2 # Modelo maximal.
cor(fitted(m0), tb_asc$ger)^2 # Polinômio com interação.
cor(fitted(n1), tb_asc$ger)^2 # Modelo não linear aditivo.

#-----------------------------------------------------------------------
# Conídios. ------------------------------------------------------------
#-----------------------------------------------------------------------

tb_con <- tb %>%
    filter(esp == "con" & temp < 35)

ggplot(data = tb_con) +
    aes(x = temp, y = ger) +
    facet_wrap(facets = ~pm) +
    geom_point() +
    geom_smooth(method = "lm", formula = y ~ poly(x, degree = 3))

ggplot(data = tb_con) +
    aes(x = pm, y = ger) +
    facet_wrap(facets = ~temp) +
    geom_point() +
    geom_smooth(method = "lm", formula = y ~ poly(x, degree = 3))

#-----------------------------------------------------------------------
# Ajuste de modelo polinômial.

# Modelo fatorial completamente cruzado considerado os fatores como
# categóricosd. Esse é o modelo maximal.
mx <- lm(ger ~ bloc + factor(temp) * factor(pm),
         data = tb_con)
anova(mx)

# Modelo quadrático completo.
m0 <- lm(ger ~ bloc + poly(temp, degree = 3) * poly(pm, degree = 3),
         data = tb_con)

# Diagnóstico.
par(mfrow = c(2, 2))
plot(m0)
layout(1)

# Existe falta de ajuste com relação ao maximal?
anova(m0, mx)

# ATTENTION: embora possa haver falta de ajuste com o modelo maximal, o
# modelo de polinômio permite interpolar previsões para fazer a
# superfície.

# Existe interação entre temperatura e molhamento?
anova(m0)
summary(m0)

summary(tb_con)

# Valores usados no experimento e malha fina para predição.
pm_u <- unique(tb_con$pm)
pm_s <- seq(from = 2, to = 61, length.out = 51)
temp_u <- unique(tb_con$temp)
temp_s <- seq(from = 11, to = 29, length.out = 51)
bloc_i <- unique(tb_con$bloc)[1]

#-----------------------------------------------------------------------
# Para verificar como ficou o ajuste como função da temperatura.

# ATTENTION: predição considerando bloco 1 e não média dos blocos.
grid <- crossing(temp = temp_s, pm = pm_u, bloc = bloc_i)
grid$ger <- predict(m0, newdata = grid)

# Faz a média no efeito dos blocos.
grid$ger <- grid$ger + 0.5 * coef(m0)["blocinoc2"]

ggplot(data = tb_con) +
    aes(x = temp, y = ger) +
    facet_wrap(facets = ~pm) +
    geom_point() +
    geom_line(data = grid,
              mapping = aes(x = temp, y = ger), color = "green3")

#-----------------------------------------------------------------------
# Para verificar como ficou o ajuste como função da temperatura.

# ATTENTION: predição considerando bloco 1 e não média dos blocos.
grid <- crossing(temp = temp_u, pm = pm_s, bloc = bloc_i)
grid$ger <- predict(m0, newdata = grid)

# Faz a média no efeito dos blocos.
grid$ger <- grid$ger + 0.5 * coef(m0)["blocinoc2"]

ggplot(data = tb_con) +
    aes(x = pm, y = ger) +
    facet_wrap(facets = ~temp) +
    geom_point() +
    geom_line(data = grid,
              mapping = aes(x = pm, y = ger), color = "tomato")

#-----------------------------------------------------------------------
# Gráfico da predição consirando ambos fatores simultâneamente.

grid <- crossing(temp = temp_s,
                 pm = pm_s,
                 bloc = bloc_i)
grid$ger <- predict(m0, newdata = grid)

# Faz a média no efeito dos blocos.
grid$ger <- grid$ger + 0.5 * coef(m0)["blocinoc2"]

gg <-
    ggplot(data = grid) +
    aes(x = temp, y = pm) +
    geom_raster(aes(fill = ger)) +
    geom_contour(aes(z = ger, color = ..level..),
                 color = "black",
                 size = 0.25) +
    scale_fill_distiller(palette = "Spectral", direction = 1) +
    labs(x = "Temperatura",
         y = "Período de molhamento",
         fill = "Germinação") +
    theme_light()
gg

# Qual e temperatura ótima para cada molhamento?
opt_temp <- function(temp, pm) {
    -predict(m0,
             newdata = data.frame(temp = temp,
                                  pm = pm,
                                  bloc = bloc_i))
}

# Determinar a temperatura ótima para vários valores de molhamento.
pm_seq <- seq(3, 60, by = 3)
temp_opt <- sapply(pm_seq,
                   FUN = function(pm) {
                       optim(par = c(20),
                             fn = opt_temp,
                             pm = pm,
                             method = "Brent",
                             lower = 12,
                             upper = 28)$par
                   })

gg <- gg +
    geom_path(data = data.frame(temp = temp_opt, pm = pm_seq),
              mapping = aes(x = temp, y = pm),
              linetype = 2) +
    geom_vline(xintercept = seq(10, 30, by = 2.5),
               size = 0.5, linetype = 3, color = "gray50") +
    geom_hline(yintercept = seq(0, 60, by = 5),
               size = 0.5, linetype = 3, color = "gray50")

direct.label(gg, list("top.pieces",
                      colour = "black",
                      hjust = 1,
                      vjust = 1))

#-----------------------------------------------------------------------
# Gráfico 3D.

source("https://github.com/walmes/wzRfun/raw/master/R/panel.3d.contour.R")

colr <- brewer.pal(11, "Spectral")
colr <- colorRampPalette(colr, space = "rgb")

wireframe(ger ~ pm + temp,
          data = grid,
          scales = list(arrows = FALSE),
          zlim = c(0, 100),
          panel.3d.wireframe = panel.3d.contour,
          type = c("on", "top", "bottom")[1],
          col.regions = colr(101),
          col = "gray50",
          col.contour = "black",
          par.settings = list(regions = list(alpha = 0.7)),
          drape = TRUE,
          xlab = list("Período de molhamento", rot = 30),
          ylab = list("Temperatura", rot = -38),
          zlab = list("Germinação", rot = 90)) +
    latticeExtra::layer({
        with(tb_con,
             panel.cloud(x = pm,
                         y = temp,
                         subscripts = 1:length(temp),
                         z = ger,
                         type = "p",
                         col = "black",
                         pch = 1,
                         alpha = 1,
                         ...))
    })

# CAUTION: esse gráfico 3D é extremamente questionável em termos de
# utilidade, eficiência e expressividade. Não é possível fazer qualquer
# julgamento acurado sobre o comportamento da função em nunhuma das
# direções, tão pouco verificar se o modelo se ajusta aos dados. Você
# está oferencendo algo que não utilidade alguma. Eu fortemente
# desencojado o seu uso dando preferência para os gráficos apresentados
# antes desse que são melhores para julgar adequação do modelo e
# entender o comparamento da função na direção da temperatura e período
# de molhamento. Existem inúmeros artigos sobre visualização de dados
# recomendando o não uso de visualizações em 3D. Use por sua conta e
# risco.

#-----------------------------------------------------------------------
# Ajuste de modelo não linear.

# Valores fixamos para estimação da beta generalizada.
t_min <- 5
t_max <- 35

# source("https://raw.githubusercontent.com/walmes/wzRfun/master/R/rp.nls.R")
# library(rpanel)
#
# tb_con$grp <- factor(tb_con$pm)
# str(tb_con)
#
# model <-
#     ger ~ exp(b1) * (temp - t_min)^exp(b3) * (t_max - temp)^exp(b5)
#
# eye_fit <- rp.nls(model = model,
#                   data = as.data.frame(tb_con),
#                   subset = "grp",
#                   start = list(b1 = c(-8, 2),
#                                b3 = c(-2, 2),
#                                b5 = c(-2, 2)))
# dput(sapply(eye_fit, FUN = coef))

eye_coef <-
    structure(c(-14.7074031021612, 1.30756596410883, 1.09061339184484,
                -6.87817629176345, 0.822141779628012, 0.565914516124436,
                -1.86996900185194, 0.309522623970687,
                -0.121020573363381, -1.52831888104588, 0.2869075633222,
                -0.121247422281347, -0.831858259424389,
                0.144361599508198, -0.192591825905539, 1.22262839139061,
                -0.360693477299354, -0.624916925711801,
                1.20090377813346, -0.3397608592905, -0.627918469192016),
              .Dim = c(3L, 7L),
              .Dimnames = list(
                  c("b1", "b3", "b5"),
                  c("3", "6", "12", "24", "36", "48", "60")))

#-----------------------------------------------------------------------
# Ajuste da beta generalizada por perído de molhamento.

library(nlme)

rowMeans(eye_coef)

# Valores fixamos para estimação da beta generalizada.
t_min <- 5
t_max <- 35

model <-
    ger ~ exp(b1) * (temp - t_min)^exp(b3) * (t_max - temp)^exp(b5) | pm

n0 <- nlsList(model = model,
              start = rowMeans(eye_coef),
              data = tb_con)
n0

# GOOD: deu ajuste. Fazer a predição.
grid <- crossing(pm = pm_u, temp = temp_s)
grid$ger <- predict(n0, newdata = grid)

ggplot(data = tb_con) +
    aes(x = temp, y = ger) +
    facet_wrap(facets = ~pm) +
    geom_point() +
    geom_line(data = grid,
              mapping = aes(x = temp, y = ger), color = "green3")

#-----------------------------------------------------------------------
# Ajuste da beta generalizada * monomolecular.

model <-
    ger ~ exp(b1) * (temp - t_min)^exp(b3) * (t_max - temp)^exp(b5) *
        (1 - exp(b6) * exp(-b7 * pm))

n1 <- nls(model, data = tb_con,
          start = list(b1 = -2,
                       b3 = 0.5,
                       b5 = 0.5,
                       b6 = 1,
                       b7 = 0.01))
summary(n1)

# Para temperatura em cada molhamento.
grid <- crossing(pm = pm_u, temp = temp_s)
grid$ger <- predict(n1, newdata = grid)

ggplot(data = tb_con) +
    aes(x = temp, y = ger) +
    facet_wrap(facets = ~pm) +
    geom_point() +
    geom_line(data = grid,
              mapping = aes(x = temp, y = ger), color = "turquoise3")

# Para molhamento em cada temperatura.
grid <- crossing(temp = temp_u, pm = pm_s)
grid$ger <- predict(n1, newdata = grid)

ggplot(data = tb_con) +
    aes(x = pm, y = ger) +
    facet_wrap(facets = ~temp) +
    geom_point() +
    geom_line(data = grid,
              mapping = aes(x = pm, y = ger), color = "chocolate")

#-----------------------------------------------------------------------
# Predição usando ambas os fatores.

grid <- crossing(temp = temp_s, pm = pm_s)
grid$ger <- predict(n1, newdata = grid)

gg <- ggplot(data = grid) +
    aes(x = temp, y = pm) +
    geom_raster(aes(fill = ger)) +
    geom_contour(aes(z = ger, color = ..level..),
                 color = "black",
                 size = 0.25) +
    scale_fill_distiller(palette = "Spectral", direction = 1) +
    labs(x = "Temperatura",
         y = "Período de molhamento",
         fill = "Germinação") +
    theme_light()
gg

# Qual e temperatura ótima para cada molhamento?
t_opt <- with(as.list(coef(n1)), {
    u <- exp(b3)/(exp(b3) + exp(b5))
    t_min + (t_max - t_min) * u
})

gg <- gg +
    geom_vline(xintercept = t_opt, linetype = 2) +
    geom_vline(xintercept = seq(10, 30, by = 2.5),
               size = 0.5, linetype = 3, color = "gray50") +
    geom_hline(yintercept = seq(0, 60, by = 5),
               size = 0.5, linetype = 3, color = "gray50")

direct.label(gg, list("top.pieces",
                      colour = "black",
                      hjust = 1,
                      vjust = 1))

#***********************************************************************
# CAUTION: O modelo `m0` é bem mais adequado para o ajuste do que o
# `n1`. Isso porque em `m0` 1) está acomodado o efeito de blocos, 2)
# possui termos de interação que são significativos, 3) polinômios
# cúbicos são bem mais flexíveis e portanto o ajuste do modelo aos
# dados. Portanto, considere o ajuste da beta generalizada com
# monolecular com cuidado para fazer a discussão pois ele é um modelo
# que apresenta falta de ajuste em relação ao modelo polinômial.

# Diferença de ajuste dos modelos.
cor(fitted(mx), tb_con$ger)^2 # Modelo maximal.
cor(fitted(m0), tb_con$ger)^2 # Polinômio com interação.
cor(fitted(n1), tb_con$ger)^2 # Modelo não linear aditivo.

#-----------------------------------------------------------------------
