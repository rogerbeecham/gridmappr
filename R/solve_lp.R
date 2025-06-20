#' @title solve_lp
#'
#' @description From https://observablehq.com/@jwolondon/gridmap-allocation.
#' Returns an LP solution allocating 2D points to a grid.
#'
#' @import ompr
#' @import ompr.roi
#' @import ROI.plugin.glpk
#' @importFrom dplyr select filter
#'
#' @param pts tibble of geographic points (x,y) to be transformed for allocation to grid.
#' @param grd tibble defining grid positions.
#' @param compactness Optional parameter between 0 and 1 where 0 allocates towards edges, 0.5 preserves scaled geographic location and 1 allocates towards centre of grid. Default is 1 (compact cluster).
#' @return A tibble containing solution with row-ids of pts and grd tibbles on which model constructed.
#' @author Roger Beecham
#' @examples
#'
#' library(sf)
#' library(dplyr)
#' pts <- london_boroughs |> st_drop_geometry() |> select(area_name, x = easting, y = northing)
#' grd <- grid_locations(n_row = 8, n_col = 8, spacers = list())
#' grd_pos <- solve_lp(points_normalised(pts, grd, 0.6), grd, 0.6)
#' grd_pos
#'
#' @export
solve_lp <- function(pts, grd, compactness) {
  # Define model
  n_grd <- nrow(grd)
  n_pts <- nrow(pts)
  model <- MIPModel() |>
    # 1 if grd gets assigned a pt.
    add_variable(x[grd_i, pts_i], grd_i = 1:n_grd, pts_i = 1:n_pts, type = "binary") |>
    # Every point needs to be assigned to *one* grid cell.
    add_constraint(sum_expr(x[grd_i, pts_i], grd_i = 1:n_grd) == 1, pts_i = 1:n_pts) |>
    # Every grid cell can contain no more than *one* point.
    add_constraint(sum_expr(x[grd_i, pts_i], pts_i = 1:n_pts) <= 1, grd_i = 1:n_grd) |>
    # Set objective (cost is distance between pts and grd positions).
    set_objective(sum_expr(cost(grd, pts, grd_i, pts_i) * x[grd_i, pts_i], grd_i = 1:n_grd, pts_i = 1:n_pts), "min")

  result <- solve_model(model, with_ROI(solver = "glpk"))
  # Return row IDs for tibble on which grd and pts was defined and to which pts are matched to grd
  return(get_solution(result, x[grd, pt]) |> filter(value == 1) |> select(grd, pt))
}

cost <- function(grd_rc, pts_yx, rc_i, pt_i) {
  c <- grd_rc[rc_i, ]$col
  r <- grd_rc[rc_i, ]$row
  x <- pts_yx[pt_i, ]$x
  y <- pts_yx[pt_i, ]$y
  return((x - c) * (x - c) + (y - r) * (y - r))
}
