#-----------------------------------------------------------------------
#                                            Prof. Dr. Walmes M. Zeviani
#                                leg.ufpr.br/~walmes · github.com/walmes
#                                        walmes@ufpr.br · @walmeszeviani
#                      Laboratory of Statistics and Geoinformation (LEG)
#                Department of Statistics · Federal University of Paraná
#                                       2022-abr-04 · Curitiba/PR/Brazil
#-----------------------------------------------------------------------

# Arquivo para ... TODO

#-----------------------------------------------------------------------
# Carrega o pacote {renv}.

# Instala se necessário.
if (!require(renv)) {
    if (Sys.info()["user"] == "walmes") {
        system("ipkg renv")
    } else {
        install.packages("renv")
    }
}

#-----------------------------------------------------------------------
# IMPORTANT WARNING!

# O {renv} cira um `.Rprofile` que dá `source("renv/activate.R")`.
# Resulta disso que seus endereços padrão para lib/pacotes não são mais
# vistos pois apenas fica visível o que o {renv} cria, no caso
# `/renv/library/*`. Todo `install.package()` dentro de um ambiente
# {renv} vai insatalar os pacotes no endereço de libs `/renv/library/*`.
# Todo `library()` em ambiente {renv} vai ler de lá também.

# Retorna as dependências por arquivo.
renv::dependencies(path = "../")

#-----------------------------------------------------------------------
# Trabalha no versionamento.

# Abre a documentação externa do {renv}.
##' browseURL("https://rstudio.github.io/renv/articles/renv.html")

# Carrega o pacote na sessão.
library(renv)
ls("package:renv")

packageVersion("renv")

# Na primeira vez, vai criar o '~/.local/share/renv' com cache dos
# pacotes. ATTENTION: ao incluir um novo `library(*)` em algum arquivo
# talvez seja necessário executar o comando abaixo e selecionar a opção
# 2 para que o pacote seja adicionado ao `renv.lock`.
renv::init()

# Cria o `renv.lock`. Executar toda vez que um novo pacote for
# adicionado ao projeto.
renv::snapshot()
# renv::snapshot(library = "multcompView")
# renv::snapshot(packages = "multcompView")

# (find-file "renv.lock")

# Restaura o estado de um projeto a partir das especificações em
# `renv.lock`. Usar quando estiver em outra máquina.
renv::restore()

#-----------------------------------------------------------------------
# Instalação de pacotes.

.libPaths()
# .libPaths(new = "/usr/lib/R/site-library")

# Como carregar um pacote que está numa lib fora das vistas pelo {renv}.
library(package = "multcompView",
        lib.loc = "/usr/lib/R/site-library")
ls("package:multcompView")

#-----------------------------------------------------------------------
