#'---
#' title: Read large file in chunks and convert to Parquet
#' output: github_document
#'---

#+ message=FALSE
pacman::p_load(
        rio,            # import and export files
        here,           # locate files 
        tidyverse,      # data management and visualization
        arrow,
        data.table
)

#' ## Testing
#' ### Data
# data #-----------
data_path <- here("big_data_analytics/data/inflation.csv")

(data <- fread(data_path))

dim(data)

#' ### Read large files in chunks ➔ convert to Parquet
# chunks #------------
(column_names <- names(data))

(parquet_folder <- here("test_get_parquet/data_parquet/"))

#' Chunk1
nrows_to_read = 30
(chunk1 <- fread(data_path,
                nrows = nrows_to_read))

arrow::write_dataset(
        dataset = chunk1,
        format = "parquet",
        path = parquet_folder,
        max_rows_per_file = 10,
        basename_template = paste0("part1-{i}.parquet"))

#' Chunk2
(chunk2 <- fread(data_path,
                skip = nrows_to_read+1) %>%
        rename_with(~column_names))

arrow::write_dataset(
        dataset = chunk2,
        format = "parquet",
        path = parquet_folder,
        max_rows_per_file = 10,
        basename_template = paste0("part2-{i}.parquet"))

#' ### Compare original file and parquet files
df_parquet <- open_dataset(here("test_get_parquet/data_parquet/"))

dim(df_parquet)

data1 <- df_parquet %>% collect()

bind_cols(data, data1) %>%
        select(contains("date"),
               contains("inflation"))

