#### Spatial Data Analysis in R - Day 2 ####

#### data.table ####
library(data.table)

covid <- fread("data/covid/conf_cases_mun.csv")
class(covid) # we see data.table and data.frame

# ignore this bit. run it only to "clean the data"
covid <- covid %>%
  select(date = DATE, city_nl = TX_DESCR_NL, province = PROVINCE, cases = CASES) %>%
  filter(!is.na(date), cases != "<5", !is.na(city_nl)) %>%
  mutate(cases = as.numeric(cases))
# ignore until here


# DT [i, j, by]
# i – where | order by
# j – select | update
# by – group by


# operations in i (filter)
covid[city_nl == "Gent" & cases > 50]

# operations in i (filter and order)
covid[city_nl == "Gent"][order(cases)]
# note that we don't use %>% but we nest operations with [][]

# operations in j (select)
covid[city_nl == "Gent", .(date, cases)] # note the .() !!!!!! SUPER IMPORTANT
# the . notation combined with (), allows more parameters to be included
# e.g. multiple variables, or naming a summed variable

# operations in j (do)
covid[city_nl == "Gent", sum(cases)]

# combine everything and group with by
covid[,.(sum_cases = sum(cases)), by = c("city_nl", "province")][order(-sum_cases)]

# count observations
covid[,.(sum_cases = sum(cases), observations = .N),
      by = c("city_nl", "province")][order(-sum_cases)]
# .N counts for data.table objects the number of observations
# same as n() in dplyr (tidyverse)

# opperations with := (data.table's mutate)
colnames(covid)
class(covid$date)

covid[ ,date_char:= as.character(date)]

# covid[ , date_char := as.character(date)]
# This won't work. Can you spot the difference?
# Note, when working with := you don't need the assign (<-) operator.

colnames(covid)
class(covid$date_char)

# 5-
# EXERCISE TIME :)

# 1- Import cab/taxi data (cab_data.csv) and find the best/faster way to import the file

# 2.1- Summarise and count occurrences per day of the week per PULocation
# (pickup_datetime, PULocationID)
# Do it both with tidyverse and data.table syntax

# NOTE!!!!! Probably it's better to try the tidyverse once you have time to sit
# rest, have a cup of tea and some cookies.
# Fast computer will take about 4-10 minutes.
# Doesn't matter if it's multi-core as tidyverse runs on single core.

# 2.2- Compare speed and easiness of reading

# 3- Convert pickup_datetime and dropoff_datetime to lubridate/data.
# NOTE: Text data is in US format (mm/dd/yyyy)
# TIP: Use dplyr's mutate

# 4.1- Calculate travel time in minutes
# TIP: Operations with mdy_hms give results in seconds

# 4.2- Calculate average travel time and standard deviation, per PULocationID

# BONUS: Which location has the highest travel time?
# And lowest standard deviation?

# What are your conclusions????
