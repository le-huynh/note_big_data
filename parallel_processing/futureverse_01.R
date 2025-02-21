#'---
#' title: Futurverse - UseR!2024 - lab01
#' author: ""
#' date: ""
#' output:
#'  github_document
#'---

#+ message=FALSE
pacman::p_load(
        tidyverse,      # data management and visualization
        future,
        tictoc
)

#' ### Task1: Function `slow_sum()`
slow_sum <- function(x) {
        sum <- 0
        for (value in x) {
                Sys.sleep(1.0)     ## one-second slowdown per value
                sum <- sum + value
        }
        sum
}

#' Test function
tic()
y <- slow_sum(1:10)
y
toc()

#' ### Task2: simple `future` code
tic()
f <- future(slow_sum(1:10))
y <- value(f)
toc()

#' ### Task3: Add another `toc()` just after the `future()` call
tic()
f <- future(slow_sum(1:10))
toc()
y <- value(f)
toc()
y
toc()

#' ### Task4
plan(multisession, workers = 2)

tic()
f <- future::future(slow_sum(1:10))
toc()
y <- future::value(f)
toc()
y
toc()

#' ### Task5
tic()
fa <- future(slow_sum(1:5))
toc()
fb <- future(slow_sum(6:10))
toc()
y <- value(fa) + value(fb)
toc()
y
toc()

#' ### Task6: sum 1:20 in four chunks 
tic()
xs <- list(1:5, 6:10, 11:15, 16:20)
ys <- list()
for (ii in seq_along(xs)) {
        message(paste0("Iteration ", ii))
        ys[[ii]] <- slow_sum(xs[[ii]])
}
message("Done")
print(ys)

ys <- unlist(ys)
ys

y <- sum(ys)
y
toc()

#' ### Task7: `future` version
#' #### 4 cores
library(future)
plan(multisession, workers = 4)

tic()
fa <- future(slow_sum(1:5))
toc()
fb <- future(slow_sum(6:10))
toc()
fc <- future(slow_sum(11:15))
toc()
fd <- future(slow_sum(16:20))
toc()

y <- value(fa) + value(fb) + value(fc) + value(fd)
toc()
y
toc()

#' #### 3 cores
library(future)
plan(multisession, workers = 3)

tic()
fa <- future(slow_sum(1:5))
toc()
fb <- future(slow_sum(6:10))
toc()
fc <- future(slow_sum(11:15))
toc()
fd <- future(slow_sum(16:20))
toc()

y <- value(fa) + value(fb) + value(fc) + value(fd)
toc()
y
toc()

#' ### Task8: `parallel_lapply()`
library(future)
plan(multisession)

tic()
xs <- list(1:5, 6:10, 11:15, 16:20)

ys <- future.apply::future_lapply(xs, slow_sum)
ys <- unlist(ys)
y <- sum(ys)

toc()

