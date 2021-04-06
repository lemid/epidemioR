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

# Carrega o pacote na sessão.
library(renv)

# Na primeira vez, vai criar o '~/.local/share/renv' com cache dos
# pacotes.
renv::init()

# Cria o `renv.lock`. Executar toda vez que um novo pacote for
# adicionado ao projeto.
renv::snapshot()

# Restaura o estado de um projeto a partir das especificações em
# `renv.lock`. Usar quando estiver em outra máquina.
renv::restore()

#-----------------------------------------------------------------------
