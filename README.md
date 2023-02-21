
# gridmappr

<!-- badges: start -->

[![R-CMD-check](https://github.com/rogerbeecham/gridmappr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/rogerbeecham/gridmappr/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

`gridmappr` is an R package that automates the process of generating
[small multiple gridmap layouts](https://www.gicentre.net/smwg). Given a
set of geographic point locations, it creates a grid (with stated *row,
column* dimensions) and places each point in a grid cell such that the
distance between points in geographic space and that within the grid
space is minimised. The package is an R implementation of Jo Wood’s
Observable notebooks on [Linear
Programming](https://observablehq.com/@jwolondon/hello-linear-programming)
solvers and their application to the [Gridmap
Allocation](https://observablehq.com/@jwolondon/gridmap-allocation?collection=@jwolondon/utilities)
problem.

## Gridmap allocation using compactness with `points_to_grid()`

Gridmaps, sometimes called tilemaps, are maps with spatial units
allocated into a spatially-arranged grid of cells of regular size. Many
gridmaps are generated manually, the widely used
[LondonSquared](https://github.com/aftertheflood/londonsquared) layout
of London boroughs for example. For automatic allocation of spatial
units to grid cells, various constraints might be considered, see
[Meulemans et al. 2017](https://www.gicentre.net/smwg) for a formal
discussion and evaluation.

`gridmappr` allocates geographic point locations to grid cells such that
the total of squared distances between geographic and grid locations is
minimised. Each point is allocated to one grid cell only and a cell in
the grid can contain no more than one geographic point. The grid must
therefore contain at least as many cells as geographic points.

The allocation is optimised with a *compactness* parameter, scaled
between 0-1. A value of 0.5 attempts to place each point at its relative
geographic position scaled within the bounds of the grid; a value of 1
attempts to place each point as close to the centre of the grid as
possible; compactness closer to 0 allocates cells increasingly towards
the edge of the grid.

The main allocation function to call is `points_to_grid()`. This will
return grid cell positions (*row* and *column* identifiers) for a given
set of geographic locations. It is paramerised with:

- `pts` A tibble of geographic points (*x*,*y*) to be allocated to a
  grid.
- `n_row` Maximum number of *rows* in grid.
- `n_col` Maximum number of *columns* in grid.
- `compactness` Optional parameter between `0` and `1` where `0`
  allocates towards edges, `0.5` preserves scaled geographic location
  and `1` allocates towards centre of grid. Default is `1` (compact
  cluster).
- `spacers` Optional list of grid cell locations defining grid location
  of fixed spacers which cannot be allocated points. Coordinates are in
  (`row`, `column`) order with origin `(1,1)` in bottom-left. Default is
  an empty list.

## Installation

You can install the development version of `gridmappr` from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("rogerbeecham/gridmappr")
```

## Example Uses

- [Beecham et al. 2021](https://eprints.whiterose.ac.uk/172944/) ‘On the
  Use of ‘Glyphmaps’ for Analysing the Scale and Temporal Spread of
  COVID-19 Reported Cases’, *ISPRS International Journal of
  Geo-Information*, 10(4), pp. 213–.

- [Beecham and Slingsby
  2019](https://journals.sagepub.com/doi/10.1177/0308518X19850580)
  ‘Characterising labour market self-containment in London with
  geographically arranged small multiples’, *Environment and Planning A:
  Economy and Space*, 51(6), pp. 1217–1224.

- [Wood et al. 2012](https://www.gicentre.net/featuredpapers)
  ‘BallotMaps: Detecting name bias in alphabetically ordered ballot
  papers’, *IEEE Transactions on Visualization and Computer Graphics*,
  17(12), pp. 2384–2391.
