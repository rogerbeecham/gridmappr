#' @title points_to_grid
#'
#' @description From https://observablehq.com/@jwolondon/gridmap-allocation.
#' Returns an LP solution allocating 2D points to a grid.
#'
#' @importFrom dplyr mutate left_join select row_number
#'
#' @param pts tibble of geographic points (x,y) to be allocated to a grid.
#' @param n_row maximum number of rows in grid.
#' @param n_col maximum number of columns in grid.
#' @param compactness Optional parameter between 0 and 1 where 0 allocates towards edges, 0.5 preserves scaled geographic location and 1 allocates towards centre of grid. Default is 1 (compact cluster).
#' @param spacers Optional list of grid cell locations defining grid location of fixed spacers which cannot be allocated points. Coordinates are in (row, column) order with origin bottom-left. Default is an empty list.
#' @return A tibble of matched point and grid locations.
#' @author Roger Beecham
#' @examples
#'
#' library(dplyr)
#' library(sf)
#'
#' pts <- london_boroughs |> st_drop_geometry() |> select(area_name, x = easting, y = northing)
#'
#' solution <- points_to_grid(pts, n_row = 8, n_col = 8, spacers = list(), compactness = .6)
#'
#' solution
#'
#' @export
points_to_grid <- function(pts, n_row, n_col, compactness = 1, spacers = list()) {
  grd <- grid_locations(n_row, n_col, spacers)
  if (nrow(pts) > nrow(grd)) {
    print(paste(
      "Cannot allocate ", nrow(pts),
      " points to a grid with only ",
      nrow(grd),
      " cells."
    ))
    return(
      tibble(
        row = rep(NA, times = n_row, each = n_col),
        col = rep(NA, times = n_row, each = n_col)
      )
    )
  }

  grd_pos <- solve_lp(
    points_normalised(pts, grd, compactness),
    grd,
    compactness
  ) |>
    left_join(grd |> mutate(id = row_number()), by = c("grd" = "id")) |>
    left_join(pts |> mutate(id = row_number()), by = c("pt" = "id")) |>
    select(-c(grd, pt, x, y))
}
