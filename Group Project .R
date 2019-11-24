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

who <- read.csv("who_suicide_statistics.csv")
who <- na.omit(who)

# Suicides Per Capita 
years <- unique(who$year)
countries <- unique(who$country)
suicides_country_year <- data.frame()
for (c in 1:length(countries)){
  country <- who %>%
    filter(country == countries[c])
  suicides_country_year[c, 1] <- toString(countries[c])
  for (y in 1:length(years)){
    current_year <- country %>%
      filter(year == years[y])
    total_pop <- sum(current_year$population)
    total_suicides <- sum(current_year$suicides_no)
    per_capita_suicides <- total_suicides/total_pop
    suicides_country_year[c, y + 1] <- per_capita_suicides
  }
}

colnames(suicides_country_year) <- c("Country", years)
suicides_country_year[is.na(suicides_country_year)] = 0
View(suicides_country_year)

colnames(suicides_country_year)

col_order <- c("Country", "1979", "1980", "1981","1982", "1983", "1984","1985", "1986", "1987","1988","1989", "1990",
               "1991", "1992", "1993", "1994", "1995", "1996", "1997", "1998", "1999",
               "2000", "2001", "2002", "2003", "2004", "2005", "2006", "2007", "2008",
               "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016")

suicides_country_year<- suicides_country_year[, col_order]
View(suicides_country_year)

for (i in 1:nrow(suicides_country_year)){
  sum <- 0
  for (c in 2:ncol(suicides_country_year)){
    sum <- sum + suicides_country_year[i, c]
  }
  suicides_country_year$Sum[i] <- sum
}
