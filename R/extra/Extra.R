#### Extra functions ####

#### Thiessen Polygons ####

library(tmap)
library(spatstat)  # Used for the dirichlet tessellation function
library(maptools)  # Used for conversion from SPDF to ppp
library(raster)    # Used to clip out thiessen polygons

# Load data
# Load data
# Load precipitation data
P <- readRDS(gzcon(url("http://colby.edu/~mgimond/Spatial/Data/precip.rds")))
# Load Texas boudary map
W <- readRDS(gzcon(url("http://colby.edu/~mgimond/Spatial/Data/texas.rds")))

# Replace point boundary extent with that of Texas and add X,Y coordinates
P@bbox <- W@bbox
P$X <- coordinates(P)[,1]
P$Y <- coordinates(P)[,2]

# Create a tessellated surface
th  <-  as(dirichlet(as.ppp(P)), "SpatialPolygons")

# The dirichlet function does not carry over projection information
# requiring that this information be added manually
proj4string(th) <- proj4string(P)

# The tessellated surface does not store attribute information
# from the point data layer. We'll use the over() function (from the sp
# package) to join the point attributes to the tesselated surface via
# a spatial join. The over() function creates a dataframe that will need to
# be added to the `th` object thus creating a SpatialPolygonsDataFrame object
th.z     <- over(th, P, fn=mean)
th.spdf  <-  SpatialPolygonsDataFrame(th, th.z)

# Finally, we'll clip the tessellated  surface to the Texas boundaries
th.clp   <- raster::intersect(W,th.spdf)

# Map the data
tm_shape(th.clp) +
  tm_polygons(col="Precip_in", palette="RdBu", auto.palette.mapping=FALSE,
              title="Predicted precipitation \n(in inches)") +
  tm_legend(legend.outside=TRUE)


