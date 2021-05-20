#### Spatial Data Analysis in R - Day 3 ####
#### Network Analysis ####
library(tidyverse)
library(igraph)
library(visNetwork)

library(ggraph)

# 12
# Loading and cleaning data
edges <- data.table::fread("data/edges.csv")
nodes <- data.table::fread("data/nodes.csv")


# Create graph
g <- graph_from_data_frame(edges, nodes, directed=TRUE)

# Plot
plot(g, edge.arrow.size=.4,vertex.label=NA)

# Remove loops
g <- simplify(g, remove.multiple = FALSE, remove.loops = TRUE)
plot(g, edge.arrow.size=.4,vertex.label=NA)



# Set edge color to gray, and the node color to orange.
# Replace the vertex label with the node names stored in "media"

plot(g, edge.arrow.size=.2, edge.curved=0,
     vertex.color="orange", vertex.frame.color="#555555",
     vertex.label=V(g)$media, vertex.label.color="black",
     vertex.label.cex=.7)


# Diameter
diameter(g, directed = TRUE, weights = E(g)$weight)
diameter(g, directed = FALSE, weights=NA)

# Degree
deg <- degree(g, mode="all")

plot(g, vertex.size=deg*3,
     vertex.label=V(g)$media, edge.arrow.size=.2, vertex.label.cex=.7)

#par(mar = c(0,0,0,0))

# Plot using ggraph
ggraph(g, layout = "fr") +
  geom_edge_fan(color = "#1DACE8", alpha = .5) +
  geom_node_point(aes(size = deg), color = "#1DACE8", show.legend = FALSE) +
  geom_node_text(aes(label = name, size = deg)) +
  theme_graph(fg_text_colour = 'white')

# NOTE:
# Layouts 'star', 'circle', 'gem', 'dh', 'graphopt', 'grid', 'mds',
# 'randomly', 'fr', 'kk', 'drl', 'lgl'
# https://www.data-imaginist.com/2017/ggraph-introduction-layouts/



# Cool movable plots (although not that useful)

nodes$label <- nodes$media
nodes$groups <- nodes$type.label

nodes <- nodes %>%
  mutate(color.background = case_when(type.label == "Newspaper" ~ "#1DACE8",
                                      type.label == "TV" ~ "#F24D29",
                                      type.label == "Online" ~ "#76A08A"))

visNetwork(nodes, edges) %>%
  visEdges(color = "#1DACE8") %>%
  visNodes(color = list(border = "#1DACE8"))


# Clustering

# Edge betweenness
ceb <- cluster_edge_betweenness(g)
dendPlot(ceb, mode="hclust")

plot(ceb, g,
     vertex.label=V(g)$media, edge.arrow.size=.2, vertex.label.cex=.7)

# Community detection based on greedy optimization of modularity
cfg <- cluster_fast_greedy(as.undirected(g))
plot(cfg, g,
     vertex.label=V(g)$media, edge.arrow.size=.2, vertex.label.cex=.7)

V(g)$community <- cfg$membership
colrs <- adjustcolor( c("#1DACE8", "#F24D29", "#76A08A", "#1C366B"), alpha=.6)
plot(g, vertex.color=colrs[V(g)$community],
     vertex.label=V(g)$media, edge.arrow.size=.2, vertex.label.cex=.7)



#### Exercise ####
# 1- Import data
library(spatstat)
data(japanesepines)
data(redwoodfull)
data(cells)

# 2- collect information on each dataset with summary
# 2.1- How many points are there per dataset?

# 3- plot 3 datasets separately
# (pch = 19, cex = .4)
# cols - "#1DACE8", "#76A08A", "#F24D29"

# 4- Rescale Japanesepines

# 5- Calculate Quadrat Density (Japanesepines) and plot it (11.a.i)
# 6- Calculate Kernel Density (3 datasets) and plot it (11.a.ii)
# 7- Calculate L function (3 datasets) (11.b.ii)
# 8- What are your conclusions?

# PART II
# 10- Import flight data
library(tidyverse)
library(igraph)
flights <- nycflights13::flights
# 11- Summarise per month and add new column called flights
# The column flights should be a count of
# origin - dest pairs, per carrier, per month
# TIP: use n() to count flights

#origin, dest, carrier, month, number_flights

# 11- Create igraph object (directed) for January and carrier ("UA") (12.a)
# 12- Create igraph object (directed) for January and carrier ("DL") (12.a)

# 13- Compare both graphs (g_UA, g_DL) in terms of:
# 13.1 average degree
# 13.2 edge density (i.e. graph density)
# 13.3 nodes and edges

# 14 What does the number of edges and nodes tells you?
# 15 Which airport is the most important (more connections) for each carrier?
# BONUS: Plot degree distribution of 10 busiest connections for (UA/DL)
# TIP: Create data.frame with degree per airport
# add extra field called carriers with character value for each carrier
# bind datasets
# arrange, filter and plot


