library(knitr)
opts_chunk$set(cache = FALSE,
               tidy = FALSE,
               warning = FALSE,
               fig.width = 7,
               fig.height = 4.32,
               out.width = "100%",
               fig.align = "center",
               eval.after= "fig.cap",
               # dpi = 96,
               # dev = "png",
               # dev.args = list(family = "Lato"),
               dev.args = list(
                   family = ifelse(
                       knitr::opts_knit$get("rmarkdown.pandoc.to") == "html",
                       "Roboto Condensed", "Palatino")))
options(width = 68)

# Verifica se o output é html, pdf, etc.
isOutput <- function(format) {
    fmt <- knitr::opts_knit$get("rmarkdown.pandoc.to")
    if (missing(format)) {
        fmt
    } else {
        format[1] == fmt
    }
}

# Adiciona os autores no topo do capítulo.
chapter_authors <- function(authors = c("Louise Larissa May De Mio",
                                        "Walmes Marques Zeviani")) {
    if (knitr::is_html_output()) {
        a <- paste("<div class='chapterauthors'>",
                   paste(authors, collapse = "<br>\n"),
                   "</div>\n", sep = "\n")
        cat(a)
    }
    if (knitr::is_latex_output()) {
        a <- paste("\\begin{flushright}",
                   paste(authors, collapse = "\\\\\n"),
                   "\\end{flushright}\n\\vspace{2em}", sep = "\n")
        # ATTENTION: Pacote latex fancyhdr precisa ser chamado.
        cat("\\pagestyle{fancy}")
        cat(a)
    }
}
