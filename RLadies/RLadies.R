library(readr)
library(dplyr)
library(ggplot2)
library(highcharter)
library(tidyselect)
library(purrr)
library(maps)
capitulos_rladies <- read_csv("capitulos_rladies.csv")
eventos_rladies <- read_csv("eventos_rladies.csv")

glimpse (capitulos_rladies)
glimpse (eventos_rladies)

rladies_full <- merge (capitulos_rladies, eventos_rladies, by.y = "capitulo")

glimpse (rladies_full)

rladies_full %>%
  filter (grepl("science", descripcion_evento, fixed = TRUE)) %>%
  select (capitulo, ciudad, pais, titulo_evento, respuesta_asistire)

mapa_mundi <- map_data("world")
ggplot() +
  geom_polygon(data=mapa_mundi, aes(x=long, y=lat, group=group), fill="green",
               colour="blue") + 
  geom_point(data=capitulos_rladies, aes(x=longitud, y=latitud, size=miembros),
             colour="red")

rladies_full %>%
  filter(grepl("predictivo", descripcion_evento, fixed = TRUE)) %>%
  ggplot (aes(x=longitud, y=latitud))+
  geom_polygon(data=mapa_mundi, aes(x=long, y=lat, group=group), fill="green",
               colour="blue") +
  geom_point(colour="red")

chapters_rladies <- capitulos_rladies %>%
  mutate(lat=latitud, lon=longitud, z=miembros, color=colorize(miembros)) %>%
  select(capitulo, ciudad, pais, lat, lon, z, color)

hcmap() %>%
  hc_add_series(data=chapters_rladies, type="mapbubble", name="Capítulos RLadies",
                minSize=0, maxSize=40) %>%
  hc_tooltip(useHTML = TRUE, headerFormat = "",
             pointFormat = "Capitulo {point.capitulo}, País {point.pais}, Miembros {point.z}")
