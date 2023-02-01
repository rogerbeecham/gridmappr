#' London borough outline collected from OS OpenGeography
#'
#' Outline of London Boroughs collected from OS OpenGeography, simplified and in sf geometry.
#'
#' @format An sf data.frame with 33 observation and 5 variables:
#' \describe{
#'   \item{area_code}{Code identifying local authority}
#'   \item{area_name}{Name identifying local authority}
#'   \item{easting}{Easting of local authority centroid}
#'   \item{northing}{Northing of local authority centroid}
#'   \item{geometry}{MULTIPOLYGON representing local authority outline}
#' }
#' @source \url{https://geoportal.statistics.gov.uk/}
"london_boroughs"
