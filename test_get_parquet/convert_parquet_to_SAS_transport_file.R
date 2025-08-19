#'---
#' title: Convert parquet file to SAS transport file (.xpt)
#' author: ""
#' date: ""
#' output:
#'  github_document
#'---

#+ message=FALSE
pacman::p_load(
        rio,            # import and export files
        here,           # locate files 
        tidyverse,      # data management and visualization
        arrow,          # large files management
        haven           # read/write SAS file
)

#' # Read parquet files into R as a Dataset R6 object
#' **Note: This step connects the source file to R without loading the entire dataset.**
folder_path <- here("test_get_parquet/data_parquet/")

data_parquet <- arrow::open_dataset(folder_path)

data_parquet

dim(data_parquet)

#' # Read entire parquet files into R using `collect()`
#' **Note: This step reads the entire dataset into RAM.**
dataset <- data_parquet %>% collect()

dataset %>% tibble()

#' # Write SAS transport file (.xpt)
haven::write_xpt(data = dataset,
                 path = here("test_get_parquet/data_sas.xpt"))

#' # Read the converted SAS transport file into R
data_sas <- haven::read_xpt(file = here("test_get_parquet/data_sas.xpt"))

data_sas %>% tibble()

