#' French Departments outline collected from data.gouv.fr
#'
#' Outline of French departments collected from data.gouv.fr, simplified and in sf geometry.
#'
#' @format An sf data.frame with 96 observation and 5 variables:
#' \describe{
#'   \item{name}{Name identifying department}
#'   \item{name_prefecture}{Name identifying préfecture of department}
#'   \item{x}{Long of department centroid}
#'   \item{y}{Lat of department centroid}
#'   \item{geometry}{MULTIPOLYGON representing department outline}
#' }
#' @source \url{https://www.data.gouv.fr/en/datasets/carte-des-departements-2-1/}
"france_deps"
