## Abstract:
Starting from the 17th of May, we will start a course where we will cover the basis of R, introduce data wrangling tools for data analysis with the tidyverse and data.table, and introduce tools and methods for mapping spatial data and  computing spatial statistics. The course will be taught online, and it will be organized in a series of 4*4h + 1 full day classes.
As day 1 will be exclusively an introduction to R, people with a basic background in R, are not obliged to attend the course. However, as we will introduce the tidyverse as well as concepts on how to optimise R code, it is still advisable to follow the course from day 1.

While there are no prior requirements on knowing R, it is expected that the students are familiar with RStudio and handling csv files. It is advised to read the first chapters to R for Data Science (https://r4ds.had.co.nz). The first day will be merely an introduction to R, RStudio and to the tidyverse package.

### Important:
It is mandatory to have R (https://www.r-project.org) and RStudio (https://rstudio.com/products/rstudio) installed on your computer, prior to the starting date (https://r4ds.had.co.nz/introduction.html#prerequisites).
Also make sure that both R and RStudio are update. If you have any troubles installing it, please email me at least 24h in advance.

##### Below some TODO before starting the class on Thursday. It is extremely important that this is done BEFORE the course starts. Installing some packages and downloading the data might take some considerable time.

#### Create an R Project.

Create a new R Project.
https://support.rstudio.com/hc/en-us/articles/200526207-Using-Projects

#### Install packages

```
install.packages(c("tidyverse", "data.table", "lubridate", "sf",
                   "ggmap","ggspatial","igraph", "nycflights13",
                   "leaflet", "rgdal", "gstat", "tmap", "spatstat",
                   "visNetwork", "ggraph", "raster"))
```

### Spatial Analysis using R – syllabus

#### Day 1 (17th May: 13h-17h)

1. Introduction to R and RStudio 
    1. Menus
    2. Scripts
    3. Basic Data Values
    4. Numeric and integer, logical, factors, missing values and time.
    5. Basic Data Structures
    6. Vectors, matrices, lists and data.frames
    7. Functions, Loops and conditions

2. Tidyverse – Part I
    1. Pipes, tibbles.

#### Day 2 (18th May: 13h-17h)

3. Tidyverse – Part II
    1. dplyr, ggplot2, lubridate, forcats. 
4. Data.Table
    1. DT[i, j, by], order, filter, arrange
5. Exercise:
    1. Working with large datasets the cab data example
    2. Differences in speed, memory and when to use Tidyverse or Data.Table.

#### Day 3 (20th May: 13h-17h)

6. Spatial Packages
    1. Rgdal, sf/sp, rgeos, ggmap, igraph
7. Coordinate systems/Spatial Projections
8. Plotting Data (Introduction) – Part I
    1. Leaflet, ggplot2 (part II), ggmap (part II)
9. Spatial Statistics – Part I
    1. Spatial interpolation
        1. Introduction to Thiessen polygons, IDW
        2.	Kriging
10. Exercise: Meuse Zinc data

#### Day 4 - part I (21st May: 09h-12h)

11. Spatial Statistics – Part II
    1. Point Pattern Analysis
        1. Density based analysis (i.e. global density, local density, quadrat density, kernel density)
        2.	Distance based analysis (i.e. average nearest neighbour, K, L and G functions)
    3. Clustering algorithms and analysis in R
12. Network Analysis in R.
    1. Introduction to graphs (e.g. directed networks, undirected networks)
    2. Centrality indicators (e.g. degree, closeness, betweenness, eigenvector, density)
13. Exercise:
    1. Japanese pines data
    2. Air transport data

#### Day 4 - part II (21st May: 13h-17h)

14.	Spatial Statistics - Part III:
    1. DBSCAN
    2. OPTICS
    3. Challenges in Spatial Statistics
15.	Plotting Data – Part II
    1. Covid-19 data for Belgium (https://www.sciensano.be/en/covid-19-data).
16. Exercise: Bring your own data

