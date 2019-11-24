# BTMA 431 Group Project 

library(rvest)
library(stringr)
library(dplyr)

webpage <- read_html("https://www.samhsa.gov/data/sites/default/files/cbhsq-reports/NSDUHDetailedTabs2018R2/NSDUHDetTabsSect10pe2018.htm")
tbls <- html_nodes(webpage, "table")
head(tbls)
tbls_ls <- webpage %>%
  html_nodes("table")%>%
  .[13] %>%
  html_table(fill = TRUE)
str(tbls_ls)

table.10.7a <- as.data.frame(tbls_ls)
row.names(table.10.7a) <- table.10.7a[[1]]
table.10.7a[[1]] <- NULL

table.10.7a <- table.10.7a[-c(19), ]

whitout.a.pattern <- "[[:digit:]]*[,]*[[:digit:]]*" 

for (col in 1:ncol(table.10.7a)){
  without.a <- str_extract(table.10.7a[[col]], pattern = whitout.a.pattern)
  table.10.7a[[col]] <- without.a
}

for (col in 1:ncol(table.10.7a)){
  for (row in 1:nrow(table.10.7a)){
    cell <- table.10.7a[row, col]
    cell <- gsub(",", "", cell)
    table.10.7a[row, col] <- cell
  }
}

for (col in 1:ncol(table.10.7a)){
  table.10.7a[[col]] <- sapply(table.10.7a[[col]], as.numeric)
}

View(table.10.7a)


