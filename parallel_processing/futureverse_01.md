Futurverse - UseR!2024 - lab01
================

``` r
pacman::p_load(
        tidyverse,      # data management and visualization
        future,
        tictoc
)
```

### Task1: Function `slow_sum()`

``` r
slow_sum <- function(x) {
        sum <- 0
        for (value in x) {
                Sys.sleep(1.0)     ## one-second slowdown per value
                sum <- sum + value
        }
        sum
}
```

Test function

``` r
tic()
y <- slow_sum(1:10)
y
```

    ## [1] 55

``` r
toc()
```

    ## 10.25 sec elapsed

### Task2: simple `future` code

``` r
tic()
f <- future(slow_sum(1:10))
y <- value(f)
toc()
```

    ## 10.26 sec elapsed

### Task3: Add another `toc()` just after the `future()` call

``` r
tic()
f <- future(slow_sum(1:10))
toc()
```

    ## 10.22 sec elapsed

``` r
y <- value(f)
toc()
y
```

    ## [1] 55

``` r
toc()
```

### Task4

``` r
plan(multisession, workers = 2)

tic()
f <- future::future(slow_sum(1:10))
toc()
```

    ## 0.03 sec elapsed

``` r
y <- future::value(f)
toc()
y
```

    ## [1] 55

``` r
toc()
```

### Task5

``` r
tic()
fa <- future(slow_sum(1:5))
toc()
```

    ## 0.03 sec elapsed

``` r
fb <- future(slow_sum(6:10))
toc()
y <- value(fa) + value(fb)
toc()
y
```

    ## [1] 55

``` r
toc()
```

### Task6: sum 1:20 in four chunks

``` r
tic()
xs <- list(1:5, 6:10, 11:15, 16:20)
ys <- list()
for (ii in seq_along(xs)) {
        message(paste0("Iteration ", ii))
        ys[[ii]] <- slow_sum(xs[[ii]])
}
```

    ## Iteration 1

    ## Iteration 2

    ## Iteration 3

    ## Iteration 4

``` r
message("Done")
```

    ## Done

``` r
print(ys)
```

    ## [[1]]
    ## [1] 15
    ## 
    ## [[2]]
    ## [1] 40
    ## 
    ## [[3]]
    ## [1] 65
    ## 
    ## [[4]]
    ## [1] 90

``` r
ys <- unlist(ys)
ys
```

    ## [1] 15 40 65 90

``` r
y <- sum(ys)
y
```

    ## [1] 210

``` r
toc()
```

    ## 20.39 sec elapsed

### Task7: `future` version

#### 4 cores

``` r
library(future)
plan(multisession, workers = 4)

tic()
fa <- future(slow_sum(1:5))
toc()
```

    ## 0.05 sec elapsed

``` r
fb <- future(slow_sum(6:10))
toc()
fc <- future(slow_sum(11:15))
toc()
fd <- future(slow_sum(16:20))
toc()

y <- value(fa) + value(fb) + value(fc) + value(fd)
toc()
y
```

    ## [1] 210

``` r
toc()
```

#### 3 cores

``` r
library(future)
plan(multisession, workers = 3)

tic()
fa <- future(slow_sum(1:5))
toc()
```

    ## 0.04 sec elapsed

``` r
fb <- future(slow_sum(6:10))
toc()
fc <- future(slow_sum(11:15))
toc()
fd <- future(slow_sum(16:20))
toc()

y <- value(fa) + value(fb) + value(fc) + value(fd)
toc()
y
```

    ## [1] 210

``` r
toc()
```

### Task8: `parallel_lapply()`

``` r
library(future)
plan(multisession)

tic()
xs <- list(1:5, 6:10, 11:15, 16:20)

ys <- future.apply::future_lapply(xs, slow_sum)
ys <- unlist(ys)
y <- sum(ys)

toc()
```

    ## 5.75 sec elapsed
