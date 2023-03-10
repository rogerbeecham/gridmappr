% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/leics_wards.R
\docType{data}
\name{leics_wards}
\alias{leics_wards}
\title{Leicestershire Ward outline collected from OS OpenGeography}
\format{
An sf data.frame with 151 observation and 5 variables:
\describe{
\item{ward_code}{Code identifying ward}
\item{ward_name}{Name identifying ward}
\item{easting}{Easting of ward centroid}
\item{northing}{Northing of ward centroid}
\item{geometry}{MULTIPOLYGON representing ward outline}
}
}
\source{
\url{https://geoportal.statistics.gov.uk/}
}
\usage{
leics_wards
}
\description{
Outline of Leicestershire Wards collected from OS OpenGeography, simplified and in sf geometry.
}
\keyword{datasets}
