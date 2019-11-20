# BTMA 431 Group Project 

library(rvest)

webpage <- read_html("https://www.samhsa.gov/data/sites/default/files/cbhsq-reports/NSDUHDetailedTabs2018R2/NSDUHDetTabsSect10pe2018.htm")
tbls <- html_nodes(webpage, "table")
head(tbls)
tbls_ls <- webpage %>%
  html_nodes("table")%>%
  .[13] %>%
  html_table(fill = TRUE)
str(tbls_ls)

table.10.7a <- as.data.frame(tbls_ls)

