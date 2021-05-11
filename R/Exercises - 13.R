#### Exercise Answers ####

#### Day 3 ####
library(spatstat)
library(tidyverse)


# 1/2-
# 2- collect information on each dataset with summary
# 2.1- How many points are there per dataset?

data(japanesepines)
summary(japanesepines)

data(redwoodfull)
summary(redwoodfull)

data(cells)
summary(cells)

# 3- plot 3 datasets separately
plot(japanesepines, pch = 19, cex = .4, cols = "#1DACE8")
plot(redwoodfull, pch = 19, cex = .4, cols = "#76A08A")
plot(cells, pch = 19, cex = .4, cols = "#F24D29")

# 4- Rescale Japanesepines
jp_km <- rescale(japanesepines, 0.1754386, "unit")

# 5- Calculate Quadrat Density (Japanesepines) and plot it (11.a.i)
jp_count <- quadratcount(jp_km, nx = 5, ny = 5)
jp_dens <- intensity(jp_count, image = TRUE)

plot(jp_dens, main="Quadrat Density", las = 1)  # Plot density raster
plot(jp_km, pch=19, cex=0.4, col=rgb(0,0,0,.5), add=TRUE)  # Add points

# 6- Calculate Kernel Density (3 datasets) and plot it (11.a.ii)
kern_jp <- density(jp_km)
plot(kern_jp, main = "Kernel Density", las=1)
contour(kern_jp, add=TRUE)

kern_red <- density(redwoodfull)
plot(kern_red, main = "Kernel Density", las=1)
contour(kern_red, add=TRUE)

kern_cells <- density(cells)
plot(kern_cells, main = "Kernel Density", las=1)
contour(kern_cells, add=TRUE)

# 7- Calculate L function (3 datasets) (11.b.ii)
lfun_jp <- Lest(jp_km, correction = "iso")
plot(lfun_jp, main="L-Function jp", las=1)

lfun_red <- Lest(redwoodfull, correction = "iso")
plot(lfun_red, main="L-Function red", las=1)

lfun_cells <- Lest(cells, correction = "iso")
plot(lfun_cells, main="L-Function cells", las=1)

#8-??


# PART II
# 11- Summarise per month and add new column called flights
flights <- nycflights13::flights

g_UA <- flights %>%
  group_by(origin, dest, month, carrier) %>%
  summarise(flights = n()) %>%
  filter(month == 1, carrier == "UA") %>%
  graph_from_data_frame(directed = TRUE)

# 12-
g_DL <- flights %>%
  group_by(origin, dest, month, carrier) %>%
  summarise(flights = n()) %>%
  filter(month == 1, carrier == "DL") %>%
  graph_from_data_frame(directed = TRUE)

# 13.1 average degree
mean(degree(g_UA))
mean(degree(g_DL))

# 13.2-
edge_density(g_UA)
edge_density(g_DL)

# 13.3-
summary(g_UA)
summary(g_DL)

# 14 What does the number of edges and nodes tells you?

# 15 Which airport is the most important (more connections) for each carrier?
degree(g_UA) #EWR
degree(g_DL) #JFK

# BONUS: Plot degree distribution of 10 busiest connections for (UA/DL)

V(g_UA)$degree <- degree(g_UA)
V(g_DL)$degree <- degree(g_DL)

UA <- as_data_frame(g_UA, "vertices")
DL <- as_data_frame(g_DL, "vertices")

UA$carrier <- "UA"
DL$carrier <- "DL"

carriers <- rbind(UA, DL)

carriers %>%
  arrange(-degree) %>%
  head(10) %>%
  ggplot(aes(name, degree)) +
  geom_point(aes(color = carrier)) +
  theme_minimal()
