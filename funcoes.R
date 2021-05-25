#-----------------------------------------------------------------------
#                                            Prof. Dr. Walmes M. Zeviani
#                                leg.ufpr.br/~walmes · github.com/walmes
#                                        walmes@ufpr.br · @walmeszeviani
#                      Laboratory of Statistics and Geoinformation (LEG)
#                Department of Statistics · Federal University of Paraná
#                                       2020-abr-01 · Curitiba/PR/Brazil
#-----------------------------------------------------------------------

#' @author Walmes Zeviani.
#' @description Substitui números por letras na saída da \code{cld()}
#'     para objetos da \code{emmeans()}.
#' @param x \code{chr[>0]} Vetor de strings que são número convertíveis
#'     para inteiro.
#' @return Vetor de mesmo comprimento com letras no lugar dos números.
#' @example
#'
#' num2cld(c("12 ", "123", " 23"))
num2cld <- function(x) {
    u <- strsplit(trimws(x), split = "")
    n <- as.integer(unlist(u))
    stopifnot(!any(is.na(n)))
    k <- max(n)
    sapply(u,
           FUN = function(ui) {
               paste(letters[k:1][rev(as.integer(ui))],
                     collapse = "")
           })
}

#-----------------------------------------------------------------------
