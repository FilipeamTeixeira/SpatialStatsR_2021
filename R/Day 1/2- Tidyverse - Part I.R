#### Spatial Data Analysis in R - Day 1 ####

# 2.a
#### Tidyverse - Part I ####
library(tidyverse)

# Pipes

iris %>%
  as_tibble()

iris %>%
  as_tibble() %>%
  filter(Species == "setosa") %>%
  summarise(mean_length = mean(Sepal.Length))

# Tibbles

head(iris)
iris_tb <- as_tibble(iris)
head(iris_tb)

# printing
iris
iris_tb

print(iris, n = 3) # will throw error

print(iris_tb, n = 3) # works for tibbles

