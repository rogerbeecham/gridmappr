#' @title grid_locations
#'
#' @description From https://observablehq.com/@jwolondon/gridmap-allocation.
#' Creates a list of grid locations of a stated size, with spacer positions
#' removed.
#'
#' @importFrom dplyr bind_rows
#' @importFrom tibble tibble
#' @importFrom purrr map_df map
#'
#' @param n_col maximum number of columns defining grid. There must be at least as many grid cells as there are points to allocate.
#' @param n_row maximum number of rows defining grid. There must be at least as many grid cells as there are points to allocate.
#' @param spacers Optional list of grid cell locations defining grid location of fixed spacers which cannot be allocated points. Coordinates are in (row, column) order with origin top-left. Default is an empty array.
#
#' @return A tibble of grid coordinates in the same order as the original array of input points.
#'
#' @export
#' @examples grid_locations(n_row=3,n_col=3,spacers=list())
grid_locations <- function(n_row, n_col, spacers=list()) {
  grd <- list()
  for(row in 1:n_row) {
    for(col in 1:n_col)
    {
      if (!is_spacer(row, col, spacers)) {
        grd[[length(grd) + 1]] <- tibble(row=row, col=col)
      }
    }
  }
  grd <- map_df(grd, ~bind_rows(.x))
  return (grd)
}

is_spacer <- function(r, c, spacers){
  matched <- FALSE
  map(spacers, function(.x) {if(.x[1]==r && .x[2]==c) {matched<<-TRUE}})
  return (matched)
}

