#### Spatial Data Analysis in R - Day 5 ####
#### Spatial Statistics - Part III ####

install.packages("factoextra")
install.packages("fpc")
install.packages("dbscan")
install.packages("opticskxi")
install.packages("amap")

library(factoextra)

data("multishapes")
df <- multishapes[, 1:2] # Note that data is already scaled!!!

km.res <- kmeans(df, 5, nstart = 25) # K-means clustering
fviz_cluster(km.res, df, ellipse = FALSE, geom = "point") # Plot the data


#### DBSCAN ####
library(fpc)

db <- dbscan(df, eps = 0.15, MinPts = 5)
fviz_cluster(db, df, stand = FALSE, ellipse = FALSE, geom = "point")
# Black dots are outliers

# What is the eps (epsilon) and how to determine it?????

dbscan::kNNdistplot(df, k =  5) # For 5 clusters
abline(h = 0.15, lty = 2) # When "elbow" starts


#### OPTICS algorithm ####
library(dbscan)

# The parameter eps represents the radius of the ǫ-neighborhood considere
# for density estimation and minPts represents the density threshold to identify core
# points. Note that eps is not strictly necessary for OPTICS but is only
# used as an upper limit for the considered neighborhood size used to reduce
# computational complexity.

res <- optics(df, eps = 10, minPts = 10)
res
plot(res) # Reachability plot

# Plot order
plot(df, col = "grey")
polygon(df[res$order,], ) # Order of data points as line

res <- extractDBSCAN(res, eps_cl = .2)
plot(res)
hullplot(df, res)


res <- extractXi(res, xi = 0.15)
res
plot(res)
hullplot(df, res)
