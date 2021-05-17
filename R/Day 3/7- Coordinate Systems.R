#### Spatial Data Analysis in R - Day 3 ####
#### Cordinate Systems Spatial Projections ####

# 7
library(sf)

# get data
load(url("http://github.com/mgimond/Spatial/raw/master/Data/Sample1.RData"))
rm(list=c("inter.sf", "p.sf", "rail.sf"))

# find coordinate system
st_crs(s.sf)

# set coordinate system if it doesn't exist
s.sf <- st_set_crs(s.sf, "+proj=utm +zone=19 +ellps=GRS80 +datum=NAD83")

# Transform coordinate system

s.sf.gcs <- st_transform(s.sf, "+proj=longlat +datum=WGS84")
st_crs(s.sf.gcs) # Global
st_crs(s.sf) # US

install.packages("rnaturalearth")
install.packages("rgeos")

library("rnaturalearth")
world <- ne_countries(scale = "medium", returnclass = "sf")
world <- world["continent"]

world.ae <- st_transform(world, "+proj=aeqd +lat_0=0 +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs")
plot(world.ae) # Azimuthal equidistant

world.aemaine <- st_transform(world, "+proj=aeqd +lat_0=44.5 +lon_0=-69.8 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs")
plot(world.aemaine) # centered on Maine, US

world.robin <- st_transform(world,"+proj=robin +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs")
plot(world.robin) # Robinson projection

world.mercator <- st_transform(world,"+proj=merc +lon_0=0 +k=1 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs")
plot(world.mercator) # Mercator projection



