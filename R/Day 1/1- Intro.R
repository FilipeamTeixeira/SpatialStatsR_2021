#### Spatial Data Analysis in R - Day 1 ####
#### Introduction to R ####

# Get working directory
# Set new working directory with setwd("path_to_directory/root_folder")
getwd()

# 1.c
# Factors

A_to_D <- factor(c(1,3,4,3,1,3,4),
                 levels = c(1,2,3,4),
                 labels = c("A", "B", "C", "D"))

A_to_D

# 1.d
#### Basic Data Structures ####
# Vectors

vector_a <- c(1,3,4,5)
vector_a

# Operations with vectors

vector_a * 3 #multiplication
vector_a[2] #select position
vector_a[-2] #remove element

vector_a
vector_a[2] <- 20 #replace element
vector_a

vector_b <- c(vector_a[1:2], 80, vector_a[3:4]) #add element in between vector
vector_b

# Matrices

mt <- matrix(1:10, nrow = 2, byrow = TRUE)
mt

# Structure of a matrix -> m[row,column]
mt[1,3] #select row 1, column 3
mean(mt) #mean/average
sum(mt) #sum

mt_named <- matrix(c(1,2,3, 11,12,13), nrow = 2, ncol = 3, byrow = TRUE,
                   dimnames = list(c("row1", "row2"),
                                   c("C.1", "C.2", "C.3")))

mt_named
mt

# Lists
lt <- list(numbers = c(1,3,5),
           shopping = c("apples", "rice", "tuna"),
           grades = data.frame(students = c("John", "Maria", "Sarah"),
                               grades = c(15, 19, 14)),
           todo = "Wear a mask. Wash your hands")
lt

lt[3] #select 3rd item in list


# Data.Frames

df <- data.frame(students = c("John", "Maria", "Sarah"),
                 grades = c(15, 19, 14))

df[1,] #select row one
df[1,1] <- "Peter" #Change field
df[1,]

df <- rbind(df, c("Jane", 18)) #add new entry with rbind (row bind)
df

# 1.e
#### Functions, Loops and conditions ####
# Functions

say_hello <- function(x){
  print(paste("Hello, ", x, "! How are you today?", sep = ""))
}

say_hello("Filipe")

# Loops - for

for(i in 1:10){
  print(i)
}

for(i in 1:10){ #1
  cal_i <- i^2 #2
  print(cal_i) #3
}


# Loops - if

for(i in 1:10){
  i <- i^2
  if(i < 60){
    print(paste(i, "is smaller than 60."))
  }else{
    print(paste(i, "is bigger than 60."))
  }
}

# If else

fun_2 <- function(x){
ifelse(x <= 2, "Smaller or equal than 2", "Larger than 2")
}

fun_2(1.1)
fun_2(30)


#### EXTRA - Day 1 - Import/Export ####

covid_full <- readxl::read_excel("data/covid/covid_full.xlsx")
?readxl::read_xlsx()

covid_csv <- readr::read_csv("data/covid/conf_cases_mun.csv")

head(covid_full)
tail(covid_full)
colnames(covid_full)

df_names <- covid_full

colnames(df_names) <- c("Date", "Province", "Region", "Age",
                        "Sex", "Number of cases")

data.frame(`student names` = c("john", "Peter"))

head(covid_csv)

# However!!!!
library(tidyverse)

# Read with data.table
covid_csv_dt <- data.table::fread("data/covid/conf_cases_mun.csv") %>%
  as_tibble() # last step not needed


covid_csv_dt <- data.table::fread("data/covid/conf_cases_mun.csv")
covid_csv_dt <- as_tibble(covid_csv_dt)

head(covid_csv_dt)

# Write with data.table
data.table::fwrite(covid_csv_dt, "new_pretty_df.csv")
