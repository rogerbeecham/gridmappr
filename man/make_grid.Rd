% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/make_grid.R
\name{make_grid}
\alias{make_grid}
\title{make_grid}
\usage{
make_grid(sf_file, n_row, n_col)
}
\arguments{
\item{sf_file}{sf object to pass grid over.}

\item{n_row}{number of rows in grid.}

\item{n_col}{number of columns in grid.}
}
\value{
An sf object with variables identifying col and row IDs (bottom left origin), geographic centroid of grid square.
}
\description{
Constructs a 2D grid of a given number of rows and columns over an sf object.
}
\examples{
library(gridmappr)
library(sf)
grid <- make_grid(london_boroughs, 8, 8)
}
