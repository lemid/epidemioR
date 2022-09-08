#!/bin/bash

# ATTENTION: run `_used_R_packages.sh` to get the list of packages used.

if [ "$USER" == "walmes" ]; then
    ipkg tidyverse knitr rmarkdown bookdown htmltools
    ipkg survminer nlme drc multcomp directlabels lmtest gridExtra
    igth rstudio/rmarkdown
else
    Rscript -e 'install.packages(c("tidyverse", "knitr", "rmarkdown", "bookdown", "htmltools")'
    Rscript -e 'install.packages(c("survminer", "nlme", "drc", "multcomp", "directlabels", "lmtest", "gridExtra"))'
    Rscript -e 'library(devtools); install_github("rstudio/rmarkdown")'
fi

exit 0

#-----------------------------------------------------------------------
# Additional commands for GNU/Linux Ubuntu users.
#-----------------------------------------------------------------------

#--------------------------------------------
# Pandoc.

# Verifica se existe alguma instalação do pandoc.
Rscript -e 'rmarkdown::pandoc_available()'
pandoc --version

# Installs latest version of pandoc.
# https://stackoverflow.com/questions/61100045/how-to-install-stable-and-fresh-pandoc-on-ubuntu

# Open page with files.
firefox https://github.com/jgm/pandoc/releases

# Remove pandoc from the system.
sudo apt purge pandoc

# Downloads the latest version.
cd ~/Downloads/
wget https://github.com/jgm/pandoc/releases/download/2.13/pandoc-2.13-1-amd64.deb

# Installs.
ls pandoc-*-amd64.deb
sudo dpkg -i pandoc-*-amd64.deb

# Check path and version.
which pandoc
pandoc --version

#-----------------------------------------------------------------------
