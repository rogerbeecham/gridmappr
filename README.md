
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
solvers and their application to the [Grid map
allocation](https://observablehq.com/@jwolondon/gridmap-allocation?collection=@jwolondon/utilities)
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

## Example allocations

### London boroughs

For generating a gridmap layout of 33 London boroughs, we first try an
8x8 regular grid.

- `n_row` Set to 8
- `n_col` Set to 8
- `compactness` Set to .6, attempting to preserve the geographic layout
  with a degree of compactness around the grid centre.

``` r
n_row <- 8
n_col <- 8
pts <- london_boroughs |> st_drop_geometry() |> select(area_name, x=easting, y=northing)
solution <- points_to_grid(pts, n_row, n_col, .6)
```

``` r
gridmap <- make_grid(london_boroughs, n_row, n_col) |> left_join(solution)  |> 
  ggplot() + 
  geom_sf(fill="transparent", colour="#EEEEEE", linewidth=.6) +
  geom_text(aes(x=x, y=y, label=str_extract(area_name, "^.{3}")), size=4, colour="#451C14") 

realmap <- london_boroughs |> 
  ggplot() + 
  geom_sf(fill="#F1DDD1", colour="#ffffff", linewidth=.6) +
  geom_text(aes(x=easting, y=northing, label=word(area_name,1)), size=2, colour="#451C14")

realmap + gridmap
```

![](./man/figures/lb-no-spacers.svg)

Adding explicit spacers (light grey) for grid cells that cannot have
points allocated to them. Doing this, we can get to the
[LondonSquared](https://github.com/aftertheflood/londonsquared) layout.

``` r
n_row <- 7
n_col <- 8
spacers <- list(
  c(1,3), c(1,5), c(1,6),
  c(2,2), c(2,7),
  c(3,1), 
  c(6,1), c(6,2), c(6,7), c(6,8),
  c(7,2), c(7,3), c(7,4), c(7,6), c(7,7)
)
pts <- london_boroughs |> st_drop_geometry() |> select(area_name, x=easting, y=northing)
solution <- points_to_grid(pts, n_row, n_col, 1, spacers)
```

``` r
gridmap <- make_grid(london_boroughs, n_row, n_col) |> left_join(solution)  |> 
  ggplot() + 
  geom_sf(fill="transparent", colour="#EEEEEE", linewidth=.6) +
  geom_sf(
    data=. %>% inner_join(spacers |> map_df(~bind_rows(row=.x[1], col=.x[2]))),
    colour="#EEEEEE", linewidth=.6, fill="#FAFAFA",
  ) +
  geom_text(aes(x=x, y=y, label=str_extract(area_name, "^.{3}")), size=4, colour="#451C14")

realmap + gridmap
```

![](./man/figures/lb-spacers.svg)

### US States

Generating a gridmap layout of US states.

- `n_row` Set to 7
- `n_col` Set to 12
- `compactness` Set to .8

``` r
n_row <- 7
n_col <- 12
pts <- us_states |> st_drop_geometry() |> select(STUSPS, x, y)
solution <- points_to_grid(pts, n_row, n_col, .6)
```

``` r
gridmap <- make_grid(us_states, n_row, n_col) |> left_join(solution) |> 
  ggplot() + geom_sf(fill="transparent", colour="#EEEEEE", linewidth=.6) +
  geom_text(aes(x=x, y=y, label=STUSPS), size=4, colour="#451C14") +
  theme_void()

realmap <- us_states |> 
  ggplot() + geom_sf(fill="#F1DDD1", colour="#ffffff", linewidth=.4) +
  geom_text(aes(x=x, y=y, label=STUSPS), size=2, colour="#451C14") +
  theme_void()

realmap + gridmap
```

![](./man/figures/us-no-spacers.svg)

``` r
n_row <- 7
n_col <- 12
spacers <- list(
  c(4,2), c(4,3),
  c(3,5),c(3,4),c(3,3),c(3,12),c(3,11),
  c(2,4),c(2,5),c(2,6),c(2,7),c(2,8)
)
pts <- us_states |> st_drop_geometry() |> select(STUSPS, x, y)
solution <- points_to_grid(pts, n_row, n_col, .9, spacers)
```

``` r
gridmap <- make_grid(us_states, n_row, n_col) |> left_join(solution) |> 
  ggplot() + 
  geom_sf(fill="transparent", colour="#EEEEEE", linewidth=.6) +
  geom_sf(
    data=. %>% inner_join(spacers |> map_df(~bind_rows(row=.x[1], col=.x[2]))),
    colour="#EEEEEE", linewidth=.6, fill="#FAFAFA",
  ) +
  geom_text(aes(x=x, y=y, label=STUSPS), size=4, colour="#451C14") +
  theme_void()

realmap + gridmap
```

![](./man/figures/us-spacers.svg)

### Leicestershire Wards

``` r
n_row <- 14
n_col <- 14
pts <- leics_wards |> st_drop_geometry() |> select(ward_name, x=easting, y=northing)
solution <- points_to_grid(pts, n_row, n_col, 0)
```

``` r
gridmap <- make_grid(leics_wards, n_row, n_col) |> left_join(solution) |> 
  ggplot() + 
  geom_sf(fill="transparent", colour="#EEEEEE", linewidth=.6) +
  geom_sf(
    data=. %>% inner_join(spacers |> map_df(~bind_rows(row=.x[1], col=.x[2]))),
    colour="#EEEEEE", linewidth=.6, fill="#FAFAFA",
  ) +
  geom_text(aes(x=x, y=y, label=str_extract(ward_name, "^.{3}")), size=4, colour="#451C14") +
  theme_void()

realmap <- leics_wards |> 
  ggplot() + geom_sf(fill="#F1DDD1", colour="#ffffff", linewidth=.4) +
  geom_text(aes(x=easting, y=northing, label=str_extract(ward_name, "^.{3}")), size=2, colour="#451C14") +
  theme_void()
realmap + gridmap
```

![](./man/figures/leics.svg)

## Example applications

- [Wood et al. 2012](https://www.gicentre.net/featuredpapers) :
  Re-implement in gpplot2
- [Beecham and Slingsby
  2019](https://journals.sagepub.com/doi/10.1177/0308518X19850580) :
  Re-implement in gpplot2
- [Beecham et al. 2021](https://eprints.whiterose.ac.uk/172944/) :
  Re-implement in ggplot2
