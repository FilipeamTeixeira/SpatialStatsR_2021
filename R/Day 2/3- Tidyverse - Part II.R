#### Spatial Data Analysis in R - Day 2 ####
library(tidyverse)

# 3.a
#### dplyr ####
# not needed to load again the package, if you already loaded the tidyverse before

iris_tb <- as_tibble(iris)
iris_tb


# filter
iris_tb %>%
  filter(Species == "setosa") # note the == notation

iris_tb %>%
  filter(Species != "setosa") # note the != notation

iris_tb %>%
  filter(Sepal.Length > 7.1, Petal.Width < 1.8) # note the > and < notation

iris_tb %>%
  filter(Sepal.Length > 7.1 | Petal.Width < 1.8) # note the | notation
# In r | means 'or' and & means 'and' Use it wisely

# select
iris_tb %>%
  select(Species, sp_length = Sepal.Length) # the = renames the variable/column name

# rename
iris_tb %>%
  rename(plant_species = Species)

# mutate
iris_tb %>%
  mutate(length_nonsense = ifelse(Sepal.Length > 4.8, "Huuuge", "Normal"))

iris_tb %>%
  mutate(length_nonsense = Petal.Length * Petal.Width)

# group, summarise
iris_tb %>%
  mutate(length_nonsense = ifelse(Sepal.Length > 4.8, "Huuuge", "Normal")) %>%
  group_by(Species, length_nonsense) %>% # groups by variable(s)
  summarise(count = n()) # n() counts events/samples

# arrange
iris_tb %>%
  arrange(Sepal.Length) # also works with characters, multiple or/and grouped variables

# distinct
iris_tb %>%
  distinct(Species)

iris_tb %>%
  distinct(Species, Sepal.Length, .keep_all = TRUE)


#### ggplot2 ####
# ggplot2 uses + instead of %>% after ggplot() !!!!!!!!!

# the reasoning behind this is that you add (+) components to the graph
# instead of following/pipping (%>%) operations with data


diamonds

diamonds %>%
  ggplot() + # starts graph
  geom_point(aes(cut, carat)) # type of graph

diamonds %>%
  filter(clarity == "I1") %>%
  ggplot() + # starts graph
  geom_point(aes(carat, depth, color = cut, size = price),
             alpha = .4) # type of graph

diamonds %>%
  filter(clarity == "I1") %>%
  ggplot() + # starts graph
  geom_point(aes(carat, depth), color = "#1DACE8", size = .3)
# color or size can be fixed. But it has to be outside of aes()

diamonds %>%
  filter(clarity == "I1") %>%
  ggplot() + # starts graph
  geom_point(aes(carat, depth, color = cut, size = price), alpha = .7) +
  xlab("Fancy x label") +
  ylab("Fancy y label") +
  labs(size = "$$$$", color = "Goodness!!!!!", title = "Diamond graph") +
  theme_minimal() # pre-set theme


# TIP - http://opencolor.tools/palettes/wesanderson/
# This is a good resource for nice color palettes.

ggsave("diamonds.png")

#### lubridate ####
library(lubridate)

# import data (ignore the code)
covid <- data.table::fread("data/covid/conf_cases_mun.csv") %>%
  select(date = DATE, city_nl = TX_DESCR_NL, province = PROVINCE, cases = CASES) %>%
  filter(!is.na(date), cases != "<5", !is.na(city_nl)) %>%
  mutate(cases = as.numeric(cases)) %>%
  as_tibble()
# import until here

covid %>%
  mutate(day_of_week = weekdays(date), month = month(date))

covid %>%
  filter(city_nl == "Gent") %>%
  arrange(date) %>%
  mutate(date = as_date(date)) %>%
  filter(row_number()==1 | row_number()==n()) %>%
  mutate(days = lag(date) - date) %>%
  filter(!is.na(days)) %>%
  select(days)

# forcats

covid %>%
  count(city_nl, sort = TRUE)

# fct_lump
# 'lumps' n number of factors. In this case the highest 5
covid %>%
  mutate(city_nl = fct_lump(city_nl, n = 5, other_level = "Other Cities")) %>%
  count(city_nl)

# order by number of observations with each level (largest first)
covid %>%
  mutate(city_nl = fct_lump(city_nl, n = 5)) %>%
  filter(city_nl != "Other") %>%
  mutate(city_nl = fct_infreq(city_nl)) %>%
  ggplot(aes(x = city_nl)) +
  geom_bar(fill = "#1DACE8") +
  coord_flip() +
  theme_minimal()

