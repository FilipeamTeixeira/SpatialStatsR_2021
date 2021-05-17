#### Spatial Data Analysis in R - Day 3 ####
#### Spatial Statistics - part I ####

# 9.a
# Loading data
library(rgdal)
library(gstat)
library(tmap)

# Load data
# Load precipitation data
P <- readRDS("data/precip.rds")

# Load Texas boundary map
W <- readRDS("data/texas.rds")

# Replace point boundary extent with that of Texas and add X,Y coordinates
P@bbox <- W@bbox
P$X <- coordinates(P)[,1]
P$Y <- coordinates(P)[,2]

# Quick plot
plot(W)
plot(P, add = TRUE, pch = 19, cex = .5, col = P$Precip_in)


# Plot with tmap
# Why do we use tmap? It allows us to plot SpatialPointsDataFrames
# without having too much work processing the data

tm_shape(W) +
  tm_polygons() +
  tm_shape(P) +
  tm_dots(col="Precip_in", palette="RdBu", size = .5)


# 9.a.ii
#### IDW ####

library(gstat) # Use gstat's IDW routine
library(sp)    # Used for the spsample function
library(raster)

# Create an empty grid with n empty cells

grid              <- as.data.frame(spsample(P, "regular", n=50000))
names(grid)       <- c("X", "Y")
coordinates(grid) <- c("X", "Y")
gridded(grid)     <- TRUE  # Create SpatialPixel object
fullgrid(grid)    <- TRUE  # Create SpatialGrid object

# Add P's projection information to the empty grid
# It will throw an warning so keep that in mind
# However, the warning has been described as not affecting the data

proj4string(P) <- proj4string(P) # Temp fix until new proj env is adopted
proj4string(grid) <- proj4string(P)

# Interpolate the grid cells using a power value of 2 (coeff or idp = 2.0)
P.idw <- gstat::idw(Precip_in ~ 1, P, newdata=grid, idp=2.0)

# data.frame - P
# info from P - Precip_in
# data representation - data.frame called - grid

# Convert to raster object then clip to Texas
rst <- raster(P.idw)
rst.m <- mask(rst, W)

# Plot
tm_shape(rst.m) +
  tm_raster(n=10,palette = "RdBu", auto.palette.mapping = FALSE,
            title="Predicted precipitation \n(in inches)") +
  tm_shape(P) + tm_dots(size=0.2) +
  tm_legend(legend.outside=TRUE)

# NOTE: replace th_shape(rst.m) by th_shape(rst) ("unclipped" map)


# 9 a.iii
#### Kriging ####

# Define the 1st order polynomial equation
f.1 <- as.formula(Precip_in ~ X + Y)

# Compute the sample variogram; note that the f.1 trend model is one of the
# parameters passed to variogram(). This tells the function to create the
# variogram on the de-trended data.
var.smpl <- variogram(f.1, P, cloud = FALSE, cutoff=1000000, width=89900)

# Compute the variogram model by passing the nugget, sill and range values
# to fit.variogram() via the vgm() function.
dat.fit  <- fit.variogram(var.smpl, fit.ranges = FALSE, fit.sills = FALSE,
                          vgm(psill=14, model="Sph", range=590000, nugget=0))

# The following plot allows us to assess the fit
plot(var.smpl, dat.fit, xlim=c(0,1000000))

# Perform the krige interpolation (note the use of the variogram model
# created in the earlier step)
dat.krg <- krige(f.1, P, grid, dat.fit)

# Convert kriged surface to a raster object for clipping
rst <- raster(dat.krg)
rst.m <- mask(rst, W)

# Plot the map
tm_shape(rst.m) +
  tm_raster(n=10, palette="RdBu", auto.palette.mapping=FALSE,
            title="Predicted precipitation \n(in inches)") +
  tm_shape(P) + tm_dots(size=0.2) +
  tm_legend(legend.outside=TRUE)


# Generate variance
rst   <- raster(dat.krg, layer="var1.var")
rst.m <- mask(rst, W)

tm_shape(rst.m) +
  tm_raster(n=7, palette ="Reds",
            title="Variance map \n(in squared inches)") +
  tm_shape(P) +
  tm_dots(size=0.2) +
  tm_legend(legend.outside=TRUE)

# Generate confidence intervals map

rst <- sqrt(raster(dat.krg, layer="var1.var")) * 1.96
rst.m <- mask(rst, W)

tm_shape(rst.m) +
  tm_raster(n=7, palette ="Reds",
            title="95% CI map \n(in inches)") +
  tm_shape(P) +
  tm_dots(size=0.2) +
  tm_legend(legend.outside=TRUE)


#### Exercise ####

# 1- Import, plot and process the data
data(meuse)
meuse %>%
  as_tibble() %>%
  ggplot(aes(x, y)) +
  geom_point(aes(size=zinc), color="blue", alpha=3/4) +
  ggtitle("Zinc Concentration (ppm)") +
  labs(x = NULL, y = NULL) +
  coord_equal() + # so it balances the coordinates
  theme_minimal()

coordinates(meuse) <- ~ x + y
class(meuse)

# 2- Fit a variogram
# TIP: Formula log(zinc)~1
# model for fit vgm(1, "Sph", 900, 1)

# 3- Plot to assess fit
# 4- Load grid data
data("meuse.grid")

# 5- Plot meuse and meuse.grid with ggplot2
# It can be individually or together in the same plot
#

# 6- Compute Kriging
coordinates(meuse.grid) <- ~ x + y
coordinates(meuse.grid) <- c("x", "y") # same as above

# TIP: Same formula as above
# TIP: Use fit calculated in 2- from this exercise

# 7- Plot the results
# TIP: after you get the zinc_krg, convert it with as.data.frame() or as_tibble()


