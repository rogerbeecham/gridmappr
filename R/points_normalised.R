#' @title points_normalised
#'
#' @description From https://observablehq.com/@jwolondon/gridmap-allocation.
#' Returns an LP solution allocating 2D points to a grid.
#'
#' @importFrom dplyr distinct mutate
#' @importFrom scales rescale
#'
#' @param pts tibble of geographic points (x,y) to be transformed for allocation to grid.
#' @param grd tibble defining grid positions.
#' @param compactness Optional parameter between 0 and 1 where 0 allocates towards edges, 0.5 preserves scaled geographic location and 1 allocates towards centre of grid. Default is 1 (compact cluster).
#
#' @return A tibble of transformed grid coordinates
#'
#' @export
#' @examples
#' library(tibble)
#' pts <- tribble(
#'   ~x, ~y,
#'   2, 4,
#'   1, 5,
#'   2, 1,
#'   3, 3,
#'   3, 4
#' )
#' grd <- grid_locations(n_row = 3, n_col = 3, spacers = list())
#' points_normalised(pts, grd, .6)
points_normalised <- function(pts, grd, compactness) {
  # Scale to rectangle centred at middle of gird.
  # Size of grid inversely proportional to compactness
  n_rows <- grd |>
    distinct(row) |>
    nrow()
  n_cols <- grd |>
    distinct(col) |>
    nrow()
  cr <- (n_rows + 1) / 2
  cc <- (n_cols + 1) / 2
  r_height <- (1 / (compactness + 0.001) - 1) * (n_rows) + 1
  r_width <- (1 / (compactness + 0.001) - 1) * (n_cols) + 1
  min_y <- min(pts$y)
  max_y <- max(pts$y)
  min_x <- min(pts$x)
  max_x <- max(pts$x)
  return(pts |>
    mutate(
      y = rescale(y, to = c(cc - r_height / 2, cc + r_height / 2), from = c(min_y, max_y)),
      x = rescale(x, to = c(cc - r_width / 2, cc + r_width / 2), from = c(min_x, max_x))
    ))
}
