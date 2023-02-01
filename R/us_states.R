#' US State outline
#'
#' Outline of US States collected from US Census Bureau, simplified and in sf geometry.
#'
#' @format An sf data.frame with 32 observation and 12 variables:
#' \describe{
#'   \item{STATEFP}{State FIPS code}
#'   \item{STATENS}{State national standard code}
#'   \item{AFFGEOID}{American FactFinder code}
#'   \item{GEOID}{State identifier FIPS}
#'   \item{STUSPS}{United States Postal Service state abbreviation}
#'   \item{NAME}{State name}
#'   \item{LSAD}{Legal/statistical area description code for American Indian/Alaska Native/Native Hawaiian area}
#'   \item{ALAND}{Land area}
#'   \item{AWATER}{Water area}
#'   \item{x}{X coordinate of state centroid}
#'   \item{y}{Y coordinate of state centroid}
#'   \item{geometry}{MULTIPOLYGON representing state outline}
#' }
#' @source \url{https://www.census.gov/data.html}
"us_states"
