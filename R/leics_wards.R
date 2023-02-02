#' Leicestershire Ward outline collected from OS OpenGeography
#'
#' Outline of Leicestershire Wards collected from OS OpenGeography, simplified and in sf geometry.
#'
#' @format An sf data.frame with 151 observation and 5 variables:
#' \describe{
#'   \item{ward_code}{Code identifying ward}
#'   \item{ward_name}{Name identifying ward}
#'   \item{easting}{Easting of ward centroid}
#'   \item{northing}{Northing of ward centroid}
#'   \item{geometry}{MULTIPOLYGON representing ward outline}
#' }
#' @source \url{https://geoportal.statistics.gov.uk/}
"leics_wards"
