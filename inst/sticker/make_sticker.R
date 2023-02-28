library(hexSticker)
library(ggplot2)
library(gridmappr)
library(sf)
library(dplyr)
library(rmapshaper)

# hex
n_row=14
n_col=14

france <- st_read("/Users/rogerbeecham/Downloads/data/FRA_adm2.shp") |> filter(NAME_1 != "Corse")
france <- france |> rmapshaper::ms_simplify()
france_coords <- france |> st_centroid() |> st_coordinates() |> as_tibble() |> rename_all(tolower)
france <- france |> select(NAME_2) |> bind_cols(france_coords)
pts <- france |> st_drop_geometry() |> select(area_name=NAME_2) |> bind_cols(france_coords)
solution <- points_to_grid(pts, n_row, n_col, .6)

sysfonts::font_add_google("Roboto Mono")

plot <- make_grid(france, n_row, n_col) |>
  left_join(solution) |>
  ggplot() +
  geom_sf(data = france, fill="#bdbdbd", colour="#FFFFFF", linewidth = .07, alpha=.6) +
  geom_sf(data = . %>% filter(is.na(area_name)), fill = "transparent", colour = "#525252", linewidth = .03) +
  geom_sf(data = . %>% filter(!is.na(area_name)), fill = "#F1DDD1", colour = "#451C14", linewidth = .1, alpha=.4) +
  theme_void()
  # + geom_text(aes(x = x, y = y, label = str_extract(area_name, "^.{3}")), size = 1, colour = "#451C14")
sticker(plot, package="gridmappr", p_size=5, s_x=1, s_y=1.2, p_x=1, p_y=.45, s_width=1.6, s_height=1.6, white_around_sticker = TRUE,
       h_fill="#FFFFFF", h_color="#451C14", p_color="#451C14", p_family="Roboto Mono", filename="inst/sticker/gridmappr.svg")
