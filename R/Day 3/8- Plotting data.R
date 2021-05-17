#### Spatial Data Analysis in R - Day 3 ####
#### Plotting Data (Introduction) - part I ####

#### ggplot2 ####
# Don't forget the cool colors http://opencolor.tools/palettes/wesanderson/
library(tidyverse)

# histogram
ggplot(diamonds, aes(price, fill = cut)) +
  geom_histogram(binwidth = 500) # change binwidth to see what happens

# binwidth = number of observations inside 1 bar
# bins = number of bars


# Line plot
# First lets import covid data

covid <- data.table::fread("data/covid/conf_cases_mun.csv") %>%
  rowwise() %>%
  mutate(new_name = str_split(TX_DESCR_NL, " \\(")[[1]][1]) %>%
  select(NIS5, date = DATE, city_nl = new_name, province = PROVINCE, region = REGION,
         cases = CASES) %>%
  filter(!is.na(date), !is.na(city_nl)) %>%
  mutate(cases = ifelse(cases == "<5", "4", cases)) %>%
  mutate(cases = as.numeric(cases)) %>%
  as_tibble()


covid %>%
  filter(city_nl == "Antwerpen" | city_nl == "Gent" | city_nl == "Brussel") %>%
  ggplot(aes(date, cases)) +
  geom_line(aes(color = city_nl)) +
  theme_minimal() # clean and pretty

# Point plot
covid %>%
  filter(city_nl == "Antwerpen" | city_nl == "Gent" | city_nl == "Brussel") %>%
  ggplot(aes(date, cases)) +
  geom_point(aes(color = city_nl), size = .3) +
  theme_minimal() # clean and pretty

# Mixed total
covid %>%
  group_by(date) %>%
  summarise(cases = sum(cases)) %>%
  ggplot(aes(date, cases)) +
  geom_line(color = "#1DACE8") +
  geom_point(color = "#1DACE8", size = .4) +
  theme_minimal() # clean and pretty


# Smoothed conditional means
covid %>%
  filter(city_nl == "Antwerpen" | city_nl == "Gent" | city_nl == "Brussel") %>%
  ggplot(aes(date, cases, color = city_nl)) +
  geom_point(size = .3) +
  geom_smooth(lwd = .3, alpha = .1) +
  theme_minimal() # clean and pretty

covid %>%
  filter(city_nl == "Antwerpen" | city_nl == "Gent" | city_nl == "Brussel",
         date > "2020-07-15") %>%
  ggplot(aes(date, cases, color = city_nl)) +
  geom_point(size = .3) +
  geom_line(size = .3) +
  theme_minimal() # clean and pretty


# Plot 3 different windows
covid %>%
  filter(city_nl == "Antwerpen" | city_nl == "Gent" | city_nl == "Brussel",
         date > "2020-07-15") %>%
  ggplot(aes(date, cases, color = city_nl)) +
  geom_point(size = .3) +
  geom_line(size = .3) +
  facet_wrap(~city_nl) +
  theme_minimal() # clean and pretty

#8.a.ii
#### Leaflet ####
library(leaflet)
library(sf)

# For leaflet we need a SpatialPolygons object,
# meaning that the st_read isn't the best choice
be_new <- rgdal::readOGR("data/covid/be_mun.geojson")

# create color palette for leaflet
factpal <- colorFactor(c("#1DACE8", "#F24D29", "#76A08A"), be_new$region)


leaflet(be_new) %>%
  addProviderTiles("CartoDB.Positron") %>% # Background map
  addPolygons(stroke = FALSE, smoothFactor = 0.1, fillOpacity = .5,
              fillColor = ~factpal(region)) # Add polygons

leaflet(be_new) %>%
  addProviderTiles("CartoDB.Positron") %>% # Background map
  addPolygons(stroke = FALSE, smoothFactor = 0.3, fillOpacity = .5,
              fillColor = ~factpal(region),
              label = ~region,
              labelOptions = labelOptions(textsize = "15px")) %>%
  addLegend("bottomright", pal = factpal, values = ~region,
            title = "Regions",
            opacity = 1)

# Important
# label, labelOptions

# NOTE: try to delete the bottomright parameter

