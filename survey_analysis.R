## Load necessary packages
library(ggplot2)
library(tidyverse)

## Import raw data from csv files
table1 <- tbl_df(read.csv("All_Response_Data_09152019.csv", colClasses = "character"))
table2 <- tbl_df(read.csv("Individual_Response_Data_09152019.csv",
                          colClasses = "character"))