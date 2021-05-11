#### Exercise Answers ####

#### Day 2 ####
library(tidyverse)
library(data.table)

# 1- Import cab/taxi data (cab_data.csv) and find the best/faster way to import the file
cab <- fread("data/cab_data.csv")

# 2.1- Summarise and count occurrences per day of the week per PULocation
# (pickup_datetime, PULocationID)
# Do it both with tidyverse and data.table syntax
colnames(cab)

#Takes a long time, so I added head(1000) to filter first 1000 results.
cab_filter <- cab %>%
  head(1000) %>%
  group_by(pickup_datetime, PULocationID) %>%
  mutate(pickup_datetime = weekdays(mdy_hms(pickup_datetime))) %>%
  summarise(count = n())

cab_dt <- cab[,week_day:=weekdays(mdy_hms(pickup_datetime))][,.(sum_cases = .N),
              by = c("week_day","PULocationID")]

#or

cab_dt <- cab[,.(day = weekdays(mdy_hms(pickup_datetime)))][,.(observations = .N),
                                                  by = day][order(observations)]

# 2.2- Compare speed and easiness of reading

# 3- Convert pickup_datetime to lubridate/data.
# NOTE: Text data is in US format (mm/dd/yyyy)
library(lubridate)

cab_dt <- cab_dt %>%
  mutate(pickup_datetime = mdy_hms(pickup_datetime),
         dropoff_datetime = mdy_hms(dropoff_datetime))

# 3- Convert pickup_datetime and dropoff_datetime to lubridate/data.
# NOTE: Text data is in US format (mm/dd/yyyy)
# TIP: Use dplyr's mutate

cab_dt <- cab_dt %>%
  mutate(travel_minutes = as.numeric(round((dropoff_datetime - pickup_datetime)/60, 1)))

# 4.2- Calculate average travel time and standard deviation, per PULocationID

cab_dt <- cab_dt %>%
  group_by(PULocationID) %>%
  summarise(average_travel_time = mean(travel_minutes),
            sd_travel_time = sd(travel_minutes))

# BONUS: Which location has the highest travel time?
# And lowest standard deviation?

cab_dt %>%
  arrange(-average_travel_time)

cab_dt %>%
  arrange(sd_travel_time)

# What are your conclusions????
