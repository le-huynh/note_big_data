#'---
#' title: Software - Programming with (Big) Data
#' output: github_document
#'---

#+ message=FALSE
pacman::p_load(
        rio,            # import and export files
        here,           # locate files 
        tidyverse,      # data management and visualization
        microbenchmark, # measure R performance
        bench,          # measure R performance
        pryr,           # measure R performance
        profvis,        # measure R performance
        lobstr,         # get memory address
        lubridate
)

#' ## Measure R performance
# R performance #-------------------

#' How much time does it take to run this loop?
# slightly different for every run
system.time(for (i in 1:100) {i + 5})

# run multiple time --> provide statistics of run time
microbenchmark(for (i in 1:100) {i + 5})

#' Object size
hello <- "Hello, World!"
object.size(hello)

# `character` takes more memory than `factor`
# initialize a large string vector containing letters
large_string <- rep(LETTERS[1:20], 1000^2)
head(large_string)

# store the same information as a factor in a new variable
large_factor <- as.factor(large_string)

# is one bigger than the other?
object.size(large_string) - object.size(large_factor)

#' `pryr::mem_change()`: how different parts of script affect the overall memory occupied by R
# vector with 1000 (pseudo)-random numbers
mem_change(thousand_numbers <- runif(1000))

# vector with 1M (pseudo)-random numbers
mem_change(a_million_numbers <- runif(1000^2))

#' `bench::mark()`: compare performance of different code (timing + memory usage)
# variables
x <- 1:10000
z <- 1.5

# approach I: loop
multiplication <- 
        function(x,z) {
                result <- c()
                for (i in 1:length(x)) {result <- c(result, x[i]*z)}
                return(result)
        }
result <- multiplication(x,z)
head(result)

# approach II: "R-style"
result2 <- x * z 
head(result2)

# comparison
benchmarking <- 
        mark(
                result <- multiplication(x,z),
                result2 <- x * z, 
                min_iterations = 50 
        )
benchmarking[, 4:9]

# visualize output
plot(benchmarking, type = "boxplot")

#' `profvis:profvis()`: analyze performance of several lines of code
# profvis({
#         x <- 1:10000
#         z <- 1.5
#         
#         # approach I: loop
#         multiplication <- 
#                 function(x,z) {
#                         result <- c()
#                         for (i in 1:length(x)) {result <- c(result, x[i]*z)}
#                         return(result)
#                 }
#         result <- multiplication(x,z)
#         
#         # approach II: "R-style"
#         result2 <- x * z 
#         head(result2) 
# })

#' Check memory address
a <- 15
obj_addr(a)

b <- a
obj_addr(b)

#' ## SQL basics
# SQL basics #-------------------

(econ <- rio::import("https://bda-examples.s3.eu-central-1.amazonaws.com/economics.csv") %>%
        tibble())

(inflation <- rio::import("https://bda-examples.s3.eu-central-1.amazonaws.com/inflation.csv") %>%
        tibble())

#' ### R example
## R example #---------------------
# remove observations older than a certain date --> compute yearly averages
econ %>%
        filter(date >= "1968-01-01") %>%
        mutate(year = lubridate::year(date)) %>%
        group_by(year) %>%
        summarise(avg_unemploy = mean(unemploy))

# create dataframe with year, average_unemp_percent, and inflation_percent
(df1 <- econ %>%
        mutate(year = year(date)) %>%
        group_by(year, pop) %>%
        summarise(unemp_percent = unemploy/pop*100) %>%
        group_by(year) %>%
        summarise(average_unemp_percent = mean(unemp_percent)))

(df2 <- inflation %>%
        filter(date >= "1967-01-01", date <= "2015-01-01") %>%
        mutate(year = year(date)) %>%
        select(year, inflation_percent))

df1 %>% left_join(df2)

# rmarkdown::render()
