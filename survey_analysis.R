## Load necessary packages
library(ggplot2)
library(tidyverse)

## Import raw data from csv files
table1 <- tbl_df(read.csv("All_Response_Data_09152019.csv", colClasses = "character"))
table2 <- tbl_df(read.csv("Individual_Response_Data_09152019.csv",
                          colClasses = "character"))

## Create table containing survey questions
qvector <- paste("Q", seq(1, 50), sep = "")
questions <- as.data.frame(cbind(qvector, c(colnames(table1)[1:43], table1[1, 44:50])))
rownames(questions) <- seq(1, 50)
colnames(questions) <- c("Number", "Survey Question")
questions <- mutate(questions, Type = c(rep("Background Info", 9), table1[1, 10:43], 
                                        rep("Frequency of Counselor Duties", 7)))

## Create table containing background information responses and remove blank 1st row
infotable <- select(table1, 1:9)
infotable <- infotable[-1,]

## Create table containing survey responses to first type of questions
responsetable1 <- select(table1, 1, 10:43)
responsetable1 <- responsetable1[-1, ]

## Replace periods with spaces in questions and column names in tables
questions$`Survey Question` <- gsub("\\.", " ", questions$`Survey Question`)
