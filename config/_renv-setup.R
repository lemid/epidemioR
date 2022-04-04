#-----------------------------------------------------------------------
# Carrega o pacote.

# Instala se necessário.
if (!require(renv)) {
    if (Sys.info()["user"] == "walmes") {
        system("ipkg renv")
    } else {
        install.packages("renv")
    }
}

#-----------------------------------------------------------------------
# Trabalha no versionamento.

# Abre a documentação externa.
browseURL("https://rstudio.github.io/renv/articles/renv.html")

# Carrega o pacote na sessão.
library(renv)

packageVersion("renv")
ls("package:renv")

# Na primeira vez, vai criar o '~/.local/share/renv' com cache dos
# pacotes. ATTENTION: ao incluir um novo `library(*)` em algum arquivo,
# talvez seja necessário executar o comando abaixo e selecionar a opção
# 2 para que o pacote seja adicionado ao `renv.lock`.
renv::init()

# (find-file "renv.lock")

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

library(package = "multcompView",
        lib.loc = "/usr/lib/R/site-library")
ls("package:multcompView")

#-----------------------------------------------------------------------
