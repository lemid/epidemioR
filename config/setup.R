library(knitr)
opts_chunk$set(cache = FALSE,
               tidy = FALSE,
               warning = FALSE,
               fig.width = 7,
               fig.height = 4.32,
               fig.align = "center",
               eval.after= "fig.cap",
               #dpi = 96,
               #dev = "png",               
               #dev.args = list(family = "Lato"),
               dev.args = list(family = "Palatino"))
options(width = 68)

# Verifica se o output é html, pdf , etc.
isOutput <- function(format) {
	fmt <- knitr::opts_knit$get("rmarkdown.pandoc.to")
	if (missing(format)) {
		fmt
	} else {
        format[1] == fmt
    }
}
