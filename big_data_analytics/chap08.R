#'---
#' title: Data Collection and Data Storage
#' output: github_document
#'---

#+ message=FALSE
pacman::p_load(
        rio,            # import and export files
        here,           # locate files 
        tidyverse,      # data management and visualization
        arrow,
        data.table,
        RSQLite
)

#' ## Connecting R to an RDBMS

#' Initialize database
con_air <- dbConnect(SQLite(), "big_data_analytics/data/air.sqlite")

#' Data
flights <- data.table::fread("https://bda-examples.s3.eu-central-1.amazonaws.com/flights.csv")
airports <- data.table::fread("https://bda-examples.s3.eu-central-1.amazonaws.com/airports.csv")
carriers <- data.table::fread("https://bda-examples.s3.eu-central-1.amazonaws.com/carriers.csv")

#' Add tables to database
dbWriteTable(con_air, "flights", flights)
dbWriteTable(con_air, "airports", airports)
dbWriteTable(con_air, "carriers", carriers)

#' Define query
delay_query <-
"SELECT 
year,
month, 
day,
dep_delay,
flight
FROM (flights INNER JOIN airports ON flights.origin=airports.iata) 
INNER JOIN carriers ON flights.carrier = carriers.Code
WHERE carriers.Description = 'United Air Lines Inc.'
AND airports.airport = 'Newark Intl'
ORDER BY flight
LIMIT 10;
"

#' Issue query
delays_df <- dbGetQuery(con_air, delay_query)
delays_df

#' Clean up
dbDisconnect(con_air)


# rmarkdown::render()
