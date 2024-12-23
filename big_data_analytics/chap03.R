#'---
#' title: Problems big P & big N
#' output: github_document
#'---

#+ message=FALSE
pacman::p_load(
        rio,            # import and export files
        here,           # locate files 
        tidyverse,      # data management and visualization
        gamlr           # lasso estimation
)

#' ## **big P** problem
# big P #-------------------------------------------

#' ### Data
## data #-------------------------------------------
#' Import data from GitHub
ga <- rio::import("https://bda-examples.s3.eu-central-1.amazonaws.com/ga.csv")

ga <- tibble(ga)

ga

ga %>% count(source, sort = TRUE)

#' `baseR` model matrix
## model selection #-------------------------------
mm <- model.matrix(purchase~source, data = ga)

head(mm)

#' `Matrix::` `CsparseMatrix` R object
# create sparse model matrix
mm_sparse <- sparse.model.matrix(purchase~source, data = ga)

head(mm_sparse)

#' Compare object's sizes
as.numeric(object.size(mm)/object.size(mm_sparse))
# => traditional matrix object is about 7.5 times larger than the sparse version

#' Run the lasso estimation with k-fold cross-validation
cvpurchase <- cv.gamlr(mm_sparse, ga$purchase, family="binomial")

summary(cvpurchase) %>% tibble()


# rmarkdown::render()
