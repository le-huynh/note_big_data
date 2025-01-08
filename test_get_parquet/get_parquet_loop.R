#'---
#' title: Read large file in chunks and convert to Parquet using FOR loop
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

# get column names #-----------------
file_folder <- here("test_get_parquet/data_parquet_loop/")
dataset_csv <- open_dataset(sources = file_folder,
                            format = "csv")

(column_names <- names(dataset_csv))

# test for loop #-----------
file_path <- here("test_get_parquet/data_parquet_loop/inflation.csv")

chunk_no <- 0:3

chunk <- vector("list", length(chunk_no))
nrows_to_read <- 2e1
for (a in seq_along(chunk_no)) {
        
        chunk[[a]] <- fread(file_path,
                       skip = nrows_to_read*chunk_no[[a]]+1,
                       nrows = nrows_to_read) %>%
                rename_with(~column_names)
        
        arrow::write_dataset(
                dataset = chunk[[a]],
                format = "parquet",
                path = file_folder,
                max_rows_per_file = 1e7,
                basename_template = paste0("part", chunk_no[[a]], "-{i}.parquet"))
        
}

# test function #---------------------
convert2_parquet_chunk <- function(file_folder,
                                   file_path,
                                   chunk_no,
                                   nrows_to_read,
                                   column_names,
                                   max_rows_per_file = 1e7){
        
        chunk <- vector("list", length(chunk_no))
        for (a in seq_along(chunk_no)) {
                
                chunk[[a]] <- data.table::fread(
                        file_path,
                        skip = nrows_to_read*chunk_no[[a]]+1,
                        nrows = nrows_to_read) %>%
                        rename_with(~column_names)
                
                arrow::write_dataset(
                        dataset = chunk[[a]],
                        format = "parquet",
                        path = file_folder,
                        max_rows_per_file = max_rows_per_file,
                        basename_template = paste0("part", chunk_no[[a]], "-{i}.parquet"))
                
        }
}

file_folder <- here("test_get_parquet/data_parquet_loop_func/")
file_path <- here("test_get_parquet/data_parquet_loop_func/inflation.csv")

dataset_csv <- open_dataset(sources = file_folder,
                            format = "csv")
(column_names <- names(dataset_csv))

convert2_parquet_chunk(file_folder = file_folder,
                       file_path = file_path,
                       chunk_no = 0:6,
                       nrows_to_read = 1e1,
                       column_names = column_names)


# delete csv file
fs::file_delete(file_path)


