Convert parquet file to SAS transport file (.xpt)
================

``` r
pacman::p_load(
        rio,            # import and export files
        here,           # locate files 
        tidyverse,      # data management and visualization
        arrow,          # large files management
        haven           # read/write SAS file
)
```

# Read parquet files into R as a Dataset R6 object

**Note: This step connects the source file to R without loading the
entire dataset.**

``` r
folder_path <- here("test_get_parquet/data_parquet/")

data_parquet <- arrow::open_dataset(folder_path)

data_parquet
```

    ## FileSystemDataset with 7 Parquet files
    ## 2 columns
    ## date: date32[day]
    ## inflation_percent: double
    ## 
    ## See $metadata for additional Schema metadata

``` r
dim(data_parquet)
```

    ## [1] 61  2

# Read entire parquet files into R using `collect()`

**Note: This step reads the entire dataset into RAM.**

``` r
dataset <- data_parquet %>% collect()

dataset %>% tibble()
```

    ## # A tibble: 61 × 2
    ##    date       inflation_percent
    ##    <date>                 <dbl>
    ##  1 1960-01-01              1.46
    ##  2 1961-01-01              1.07
    ##  3 1962-01-01              1.20
    ##  4 1963-01-01              1.24
    ##  5 1964-01-01              1.28
    ##  6 1965-01-01              1.59
    ##  7 1966-01-01              3.02
    ##  8 1967-01-01              2.77
    ##  9 1968-01-01              4.27
    ## 10 1969-01-01              5.46
    ## # ℹ 51 more rows

# Write SAS transport file (.xpt)

``` r
haven::write_xpt(data = dataset,
                 path = here("test_get_parquet/data_sas.xpt"))
```

# Read the converted SAS transport file into R

``` r
data_sas <- haven::read_xpt(file = here("test_get_parquet/data_sas.xpt"))

data_sas %>% tibble()
```

    ## # A tibble: 61 × 2
    ##    date       inflation_percent
    ##    <date>                 <dbl>
    ##  1 1960-01-01              1.46
    ##  2 1961-01-01              1.07
    ##  3 1962-01-01              1.20
    ##  4 1963-01-01              1.24
    ##  5 1964-01-01              1.28
    ##  6 1965-01-01              1.59
    ##  7 1966-01-01              3.02
    ##  8 1967-01-01              2.77
    ##  9 1968-01-01              4.27
    ## 10 1969-01-01              5.46
    ## # ℹ 51 more rows
