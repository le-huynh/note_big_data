Futurverse - UseR!2024 - lab02
================

``` r
pacman::p_load(
        tidyverse,      # data management and visualization
        future,
        tictoc,
        progressr
)
```

### Function `slow_sum()`

``` r
slow_sum <- function(x) {
        sum <- 0
        for (value in x) {
                Sys.sleep(0.1)     ## 0.1 second slowdown per value
                sum <- sum + value
        }
        sum
}
```

### `purrr::map()`

``` r
tic()
xs <- list(1:25, 26:50, 51:75, 76:100)
ys <- map(xs, slow_sum)
ys <- unlist(ys)
y <- sum(ys)
y
```

    ## [1] 5050

``` r
toc()
```

    ## 11.09 sec elapsed

### `furrr::future_map()`

``` r
tic()

plan(multisession, workers = 4)

xs <- list(1:25, 26:50, 51:75, 76:100)
ys <- furrr::future_map(xs, slow_sum)
ys <- unlist(ys)
y <- sum(ys)
y
```

    ## [1] 5050

``` r
toc()
```

    ## 5.11 sec elapsed

### `furrr::future_map_dbl()`

``` r
tic()

plan(multisession, workers = 4)

xs <- list(1:25, 26:50, 51:75, 76:100)
ys <- furrr::future_map_dbl(xs, slow_sum)
y <- sum(ys)
y
```

    ## [1] 5050

``` r
toc()
```

    ## 4.98 sec elapsed
