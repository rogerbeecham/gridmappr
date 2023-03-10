% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/points_to_grid.R
\name{points_to_grid}
\alias{points_to_grid}
\title{points_to_grid}
\usage{
points_to_grid(pts, n_row, n_col, compactness = 1, spacers = list())
}
\arguments{
\item{pts}{tibble of geographic points (x,y) to be allocated to a grid.}

\item{n_row}{maximum number of rows in grid.}

\item{n_col}{maximum number of columns in grid.}

\item{compactness}{Optional parameter between 0 and 1 where 0 allocates towards edges, 0.5 preserves scaled geographic location and 1 allocates towards centre of grid. Default is 1 (compact cluster).}

\item{spacers}{Optional list of grid cell locations defining grid location of fixed spacers which cannot be allocated points. Coordinates are in (row, column) order with origin bottom-left. Default is an empty list.}
}
\value{
A tibble of matched point and grid locations.
}
\description{
From https://observablehq.com/@jwolondon/gridmap-allocation.
Returns an LP solution allocating 2D points to a grid.
}
\examples{
library(tibble)
pts <- tribble(
  ~x, ~y,
  2, 4,
  1, 5,
  2, 1,
  3, 3,
  3, 4
)
points_to_grid(pts, n_row = 3, n_col = 3, spacers = list())
}
