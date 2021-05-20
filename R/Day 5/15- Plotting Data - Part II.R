#### Spatial Data Analysis in R - Day 5 ####
#### Plotting Data - Part II ####
library(data.table)
library(sf)
library(tmap)
library(tidyverse)


# If you have slow internet, use
# fread("data/covid/conf_cases_mun.csv")
# fread("data/covid/conf_cases_mun_cumulative.csv")

covid <- fread('https://epistat.sciensano.be/Data/COVID19BE_CASES_MUNI.csv') %>%
  select(NIS5, date = DATE, city_nl = TX_DESCR_NL,
         province = PROVINCE, cases = CASES) %>%
  filter(!is.na(date), !is.na(city_nl), cases !="<5") %>%
  mutate(cases = as.numeric(cases)) %>%
  mutate(NIS5 = as.character(NIS5)) %>%
  as_tibble()

covid_total <- fread('https://epistat.sciensano.be/Data/COVID19BE_CASES_MUNI_CUM.csv') %>%
  select(NIS5, city_nl = TX_DESCR_NL,
         province = PROVINCE, cases = CASES) %>%
  filter(!is.na(city_nl), cases !="<5") %>%
  mutate(cases = as.numeric(cases)) %>%
  as_tibble()

  # Import geojson
be_mun <- st_read("data/covid/be_mun.geojson")

# Plot using tmap
# Similar to ggplot
# tm_shape = ggplot
# tm_ploygons - plots polygons

tm_shape(be_mun) +
  tm_polygons(col = "province") #throws error

# Lets fix the geometry
be_mun <- st_make_valid(be_mun)

tm_shape(be_mun) +
  tm_polygons(col = "province")

# We want to plot cases per capita, so lets first
# get population data for Flanders

pop <- readxl::read_xlsx("data/covid/total_pop.xlsx")

colnames(pop)

pop <- pop %>%
  group_by(CD_REFNIS) %>%
  summarise(population_total = sum(POPULATION),
            area_total = sum(MS_TOT_SUR)) %>%
  rename(NIS5 = CD_REFNIS)

# We will use the NIS5 as a way to join the covid_total and the pop datasets

covid_total <- covid_total %>%
  mutate(NIS5 = as.character(NIS5)) %>%
  left_join(pop, by = "NIS5") %>%
  mutate(cases_100k = (cases*100000)/population_total)

# We use merge to merge the sf and the df data
# We only select the NIS5 column from the be_mun map
# Because the be_mun and the covid_map share 3 variables
# (i.e. NIS5, city_nl, province)
# However, only the NIS5 matches as the other ones are written differently

covid_map <- be_mun %>%
  select(NIS5, province, name_fr = NameFRE, name_de = NameGER) %>%
  merge(covid_total, by = c("NIS5"))

# plot
tm_shape(covid_map) +
  tm_polygons(col = "cases_100k")


# Lets plot per pop density (roughly)
# First lets convert to km2 (for no reason at all actually, except because we can)

covid_map <- covid_map %>%
  mutate(area_total_km2 = area_total*(0.0040468564224)) %>%
  mutate(cases_km2 = cases_100k/area_total_km2) %>%
  mutate(cases_ha = cases_100k/area_total)

c1 <- tm_shape(covid_map) +
  tm_polygons(col = "cases_100k", palette = "viridis",
              border.col = "white", lwd = .3)
c1

c2 <- tm_shape(covid_map) +
  tm_polygons(col = "cases_km2", palette = "viridis",
              border.col = "white", lwd = .3)

c2

# Why is my map all dark?
hist(covid_map$cases_km2)

# We could log(cases_km2) but tmap has a better option
# Style - "quantile", "jenks", "equal"

c2 <- tm_shape(covid_map) +
  tm_polygons(col = "cases_km2", palette = "viridis",
              border.col = "white", lwd = .3,
              n = 6, style = "quantile")

c2

tmap_arrange(c1, c2)

# What about taking this to another level and build animations?

colnames(covid)

# First let's create a week variable and lets summarize data
# NOTE: this isn't accurate as we removed the "<5" data
# Ideally we would get all files from the sciensano website
# and work from there to build a proper graph showing evolution of cases
# i.e. https://epistat.sciensano.be/Data/20200330/COVID19BE_CASES_MUNI_CUM_20200330.csv


covid <- covid %>%
  mutate(week = week(date)) %>%
  group_by(NIS5, city_nl, province, week) %>%
  summarise(cases = sum(cases)) %>%
  left_join(pop, by = "NIS5") %>%
  mutate(cases_100k = (cases*100000)/population_total)

covid_evol <- be_mun %>%
  select(NIS5, province, name_fr = NameFRE, name_de = NameGER) %>%
  merge(covid, by = c("NIS5"))

anim <- tm_shape(covid_evol) +
  tm_polygons(col = "cases_100k", palette = "viridis",
              border.col = "white", lwd = .3, style = "quantile") +
  tm_facets(along = "week", free.coords = FALSE)

anim

# Create Animation

tmap_animation(anim, filename = "covid_anim.gif", delay = 25,
               width = 1500, height = 1500)

# If you get an error
# Install imagemagick https://imagemagick.org/script/download.php



#### Extra tmap exercise ####
# original
tm_shape(covid_map) +
  tm_polygons(col = "cases_100k", palette = "viridis",
              border.col = "white", lwd = .3)

# new breaks
tm_shape(covid_map) +
  tm_polygons(col = "cases_100k", palette = "viridis",
              border.col = "white", lwd = .3,
              breaks = c(0,4000,6000,12000))



#### Gifski example ####
# NOTE: Untested code so use at your own risk

png("frame%03d.png")
par(ask = FALSE)
anim
dev.off()
png_files <- sprintf("frame%03d.png", 1:27)
gif_file <- gifski(png_files)
unlink(png_files)




#### Let's see your data ####



