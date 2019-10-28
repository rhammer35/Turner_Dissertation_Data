## Load necessary packages
library(ggplot2)
library(tidyverse)
library(openxlsx)

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
infotable <- select(table1, 1:9, 30:43)
infotable <- infotable[-1,]

## Create table containing survey responses to Counselor Burnout Inventory questions
cbi_responses <- select(table1, 1, 10:29)
cbi_responses <- cbi_responses[-1, ]
cbi_questions <- questions[10:29, 1:2]

## Replace periods with spaces in questions and column names in tables
questions$`Survey Question` <- gsub("\\.", " ", questions$`Survey Question`)

## Rename columns in CBI data table
colnames(cbi_responses) <- c(questions$`Survey Question`[1], questions$Number[10:29])

## Convert CBI Responses to Numeric Scale
cbi_responses[cbi_responses == "Always True"] <- 5
cbi_responses[cbi_responses == "Often True"] <- 4
cbi_responses[cbi_responses == "Sometimes True"] <- 3
cbi_responses[cbi_responses == "Rarely True"] <- 2
cbi_responses[cbi_responses == "Never True"] <- 1
cbi_responses[, 2:21] <- as.numeric(unlist(cbi_responses[, 2:21]))
cbi_scale <- data.frame(c(1, 2, 3, 4, 5), c("Always True", "Often True", "Sometimes True",
                                            "Rarely True", "Never True"))
colnames(cbi_scale) <- c("Scale Value", "Survey Response")

## Split CBI data by question factor
factor_names <- c("Exhaustion", "Incompetence", "Negative Work Environment",
                  "Devaluing Client", "Deterioration in Personal Life")
cbi_factor <- as.data.frame(cbind(seq(2, 21), rep(factor_names, 4)))
colnames(cbi_factor) <- c("CBI_Question", "CBI_Factor")
cbi_factor$CBI_Question <- as.numeric(as.character(cbi_factor$CBI_Question))
cbi_exhaustion <- select(cbi_responses, 'Respondent ID',
                         cbi_factor[cbi_factor$CBI_Factor == "Exhaustion",][, 1])
cbi_incompetence <- select(cbi_responses, 'Respondent ID',
                           cbi_factor[cbi_factor$CBI_Factor == "Incompetence",][, 1])
cbi_negative <- select(cbi_responses, 'Respondent ID',
                       cbi_factor[cbi_factor$CBI_Factor
                                  == "Negative Work Environment",][, 1])
cbi_devaluing <- select(cbi_responses, 'Respondent ID',
                        cbi_factor[cbi_factor$CBI_Factor == "Devaluing Client",][, 1])
cbi_personal <- select(cbi_responses, 'Respondent ID',
                       cbi_factor[cbi_factor$CBI_Factor
                                  == "Deterioration in Personal Life",][, 1])

## Create Excel file as output with different tabs for each data table
wb <- createWorkbook()
cbi_datasets <- list(cbi_responses, cbi_exhaustion, cbi_devaluing, cbi_incompetence,
                 cbi_negative, cbi_personal, cbi_questions, cbi_scale)
cbi_titles <- c("cbi_responses", "cbi_exhaustion", "cbi_devaluing", "cbi_incompetence",
                "cbi_negative", "cbi_personal", "cbi_questions", "cbi_scale")
for (i in seq_along(cbi_datasets)) {
    
    sheet <- addWorksheet(wb, cbi_titles[i])
    writeDataTable(wb, sheet, data.frame(cbi_datasets[i]))
 
}
saveWorkbook(wb, "Turner_CBI_Data.xlsx")

