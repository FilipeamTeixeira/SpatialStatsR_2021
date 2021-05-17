#### Spatial Data Analysis in R - Day 3 ####
#### Spatial Packages ####

# 6.a
#### rgdal ####
# One of the many packages available to import data.
# BUT... it has been replaced by the st_read in the sf package

# (do not run) be_shp <- readOGR("data/be_shapefile/flanders.shp")

#### sf/sp ####
library(sf)

st_layers("data/be_shapefile/flanders.shp")

be_shp <- st_read("data/be_shapefile/flanders.shp")
plot(st_geometry(be_shp))

be_geojson <- st_read("data/covid/be_mun.geojson")
colnames(be_geojson) # gets variables
plot(be_geojson["region"]) # plot by region
plot(be_geojson["province"]) # plot by province


#plot with ggplot2
library(ggplot2)
ggplot(be_geojson) +
  geom_sf(aes(fill = province), lwd = .1) +
  theme_void()

#### rgeos ####

#### ggspatial ####
library(ggspatial)

# It might take a few minutes
ggplot(be_geojson) +
  annotation_map_tile(type = "cartolight", zoom = 9) +
  geom_sf(aes(fill = province), lwd = .1) +
  annotation_scale(height = unit(0.1, "cm")) +
  annotation_north_arrow(style = north_arrow_minimal(text_size = 7),
                         pad_y = unit(1, "cm"),height = unit(.5, "cm"),
                         width = unit(.5, "cm")) +
  theme_void()



#### ggmap ####
library(ggmap)
# find bounding box coordinates
# http://bboxfinder.com

us <- c(left = -125, bottom = 25.75, right = -67, top = 49)

get_stamenmap(us, zoom = 5, maptype = "toner-lite") %>% ggmap()

violent_crimes <- crime %>%
    filter(-95.39681 <= lon & lon <= -95.34188,
           29.73631 <= lat & lat <=  29.78400,
           !is.na(offense))

# qmplot is the ggmap equivalent to the ggplot2
# function qplot and allows for the quick plotting of maps with data/models/etc.

qmplot(lon, lat, data = violent_crimes,
       maptype = "toner-lite", color = offense, size = I(.3)) +
  facet_wrap(~ offense)



#### igraph ####
library(igraph)
library(nycflights13)
library(tidyverse)

colnames(flights)


ny_flights <- nycflights13::flights %>%
  group_by(origin, dest, carrier, month) %>%
  summarise(count = n(), arr_delay = mean(arr_delay, na.rm = TRUE)) # Notice the 'na.rm'

g <-graph_from_data_frame(ny_flights, directed = TRUE)

plot(g)
summary(g)

g1 <- subgraph.edges(g, E(g)[carrier == "UA" & month == 1])
summary(g1)

V(g1)$degree <- degree(g1)
V(g1)$degree


library(ggraph)

ggraph(g1, layout = 'kk') +
  geom_edge_fan(aes(alpha = arr_delay), color = "#1DACE8") +
  geom_node_point(aes(size = degree), color = "#1DACE8") +
  geom_node_text(aes(label = name), size = 3, repel = TRUE, color = "#7496D2") +
  theme_graph()


