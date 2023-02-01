#' @title make_grid
#'
#' @description Constructs a 2D grid of a given number of rows and columns over an sf object.
#'
#' @importFrom dplyr mutate row_number bind_cols
#' @importFrom tibble tibble as_tibble
#' @importFrom purrr map2_df
#' @importFrom sf st_sf st_make_grid st_coordinates st_centroid
#'
#' @param sf_file sf object to pass grid over.
#' @param n_row number of rows in grid.
#' @param n_col number of columns in grid.
#' @return An sf object with variables identifying col and row IDs (bottom left origin), geographic centroid of grid square.
#'
#' @export
#' @examples
#' library(gridmappr)
#' grid <- make_grid(london_boroughs, 8, 8)
make_grid <- function(sf_file, n_row, n_col) {
  grid_sf <- st_sf(
    geom=st_make_grid(sf_file |> mutate(id=row_number()),
                      n=c(n_col,n_row), what="polygons")
    )
  grid_index <- map2_df(
    rep(1:n_row, each=n_col),  rep(1:n_col, times=n_row),
    ~tibble(col=.y, row=.x)
    )
  grid_sf <- grid_sf |> bind_cols(grid_index)
  st_agr(grid_sf) <- "constant"
  grid_centroids <- grid_sf |>  st_centroid() |>  st_coordinates() |>  as_tibble()
  # Add centroids to to grid_sf.
  grid_sf <- grid_sf |>
    mutate(x=grid_centroids$X, y=grid_centroids$Y)
}
