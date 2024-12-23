Problems big P & big N
================

``` r
pacman::p_load(
        rio,            # import and export files
        here,           # locate files 
        tidyverse,      # data management and visualization
        gamlr           # lasso estimation
)
```

## **big P** problem

``` r
# big P #-------------------------------------------
```

### Data

``` r
## data #-------------------------------------------
```

Import data from GitHub

``` r
ga <- rio::import("https://bda-examples.s3.eu-central-1.amazonaws.com/ga.csv")

ga <- tibble(ga)

ga
```

    ## # A tibble: 51,935 × 8
    ##    visits source   browser isMobile city          country       channelGrouping purchase
    ##     <int> <chr>    <chr>   <lgl>    <chr>         <chr>         <chr>              <int>
    ##  1      1 google   Chrome  TRUE     San Jose      United States (Other)                1
    ##  2      1 (direct) Edge    FALSE    Charlotte     United States Direct                 1
    ##  3      1 (direct) Safari  TRUE     San Francisco United States Direct                 1
    ##  4      1 (direct) Safari  TRUE     Los Angeles   United States Direct                 1
    ##  5      1 (direct) Chrome  FALSE    Chicago       United States Direct                 1
    ##  6      1 (direct) Chrome  FALSE    Sunnyvale     United States Direct                 1
    ##  7      1 (direct) Chrome  FALSE    New York      United States Direct                 1
    ##  8      1 (direct) Chrome  FALSE    San Bruno     United States Direct                 1
    ##  9      1 (direct) Chrome  FALSE    Mountain View United States Direct                 1
    ## 10      1 (direct) Chrome  FALSE    New York      United States Direct                 1
    ## # ℹ 51,925 more rows

``` r
ga %>% count(source, sort = TRUE)
```

    ## # A tibble: 69 × 2
    ##    source                   n
    ##    <chr>                <int>
    ##  1 (direct)             27208
    ##  2 google               11521
    ##  3 youtube.com           8691
    ##  4 analytics.google.com  1013
    ##  5 Partners               953
    ##  6 dfa                    476
    ##  7 sites.google.com       272
    ##  8 mail.google.com        165
    ##  9 m.facebook.com         161
    ## 10 google.com             156
    ## # ℹ 59 more rows

`baseR` model matrix

``` r
## model selection #-------------------------------
mm <- model.matrix(purchase~source, data = ga)

head(mm)
```

    ##   (Intercept) source(not set) sourceadwords.google.com sourceanalytics.google.com sourcearstechnica.com sourceask sourcebaidu sourcebing sourceblog.golang.org sourcebusinessinsider.com sourceconnect.googleforwork.com
    ## 1           1               0                        0                          0                     0         0           0          0                     0                         0                               0
    ## 2           1               0                        0                          0                     0         0           0          0                     0                         0                               0
    ## 3           1               0                        0                          0                     0         0           0          0                     0                         0                               0
    ## 4           1               0                        0                          0                     0         0           0          0                     0                         0                               0
    ## 5           1               0                        0                          0                     0         0           0          0                     0                         0                               0
    ## 6           1               0                        0                          0                     0         0           0          0                     0                         0                               0
    ##   sourcedatastudio.google.com sourcedealspotr.com sourcedfa sourcedocs.google.com sourceduckduckgo.com sourcefacebook.com sourcefeedly.com sourceflipboard.com sourcegithub.com sourcegoogle sourcegoogle.co.jp
    ## 1                           0                   0         0                     0                    0                  0                0                   0                0            1                  0
    ## 2                           0                   0         0                     0                    0                  0                0                   0                0            0                  0
    ## 3                           0                   0         0                     0                    0                  0                0                   0                0            0                  0
    ## 4                           0                   0         0                     0                    0                  0                0                   0                0            0                  0
    ## 5                           0                   0         0                     0                    0                  0                0                   0                0            0                  0
    ## 6                           0                   0         0                     0                    0                  0                0                   0                0            0                  0
    ##   sourcegoogle.co.uk sourcegoogle.com sourcegoogle.com.au sourcegoogle.de sourcegoogle.ru sourcegoogleads.g.doubleclick.net sourcegophergala.com sourcegroups.google.com sourceh.yandex-team.ru sourceimages.google
    ## 1                  0                0                   0               0               0                                 0                    0                       0                      0                   0
    ## 2                  0                0                   0               0               0                                 0                    0                       0                      0                   0
    ## 3                  0                0                   0               0               0                                 0                    0                       0                      0                   0
    ## 4                  0                0                   0               0               0                                 0                    0                       0                      0                   0
    ## 5                  0                0                   0               0               0                                 0                    0                       0                      0                   0
    ## 6                  0                0                   0               0               0                                 0                    0                       0                      0                   0
    ##   sourcekeep.google.com sourcel.facebook.com sourcel.messenger.com sourcelearn.colorado.edu sourcelearn.temple.edu sourcelinkedin.com sourcelm.facebook.com sourcelunametrics.com sourcem.baidu.com sourcem.facebook.com
    ## 1                     0                    0                     0                        0                      0                  0                     0                     0                 0                    0
    ## 2                     0                    0                     0                        0                      0                  0                     0                     0                 0                    0
    ## 3                     0                    0                     0                        0                      0                  0                     0                     0                 0                    0
    ## 4                     0                    0                     0                        0                      0                  0                     0                     0                 0                    0
    ## 5                     0                    0                     0                        0                      0                  0                     0                     0                 0                    0
    ## 6                     0                    0                     0                        0                      0                  0                     0                     0                 0                    0
    ##   sourcem.mg.mail.yahoo.com sourcem.reddit.com sourcem.youtube.com sourcemail.google.com sourcemessenger.com sourceonline-metrics.com sourceoptimize.google.com sourceoutlook.live.com sourcePartners sourcephandroid.com
    ## 1                         0                  0                   0                     0                   0                        0                         0                      0              0                   0
    ## 2                         0                  0                   0                     0                   0                        0                         0                      0              0                   0
    ## 3                         0                  0                   0                     0                   0                        0                         0                      0              0                   0
    ## 4                         0                  0                   0                     0                   0                        0                         0                      0              0                   0
    ## 5                         0                  0                   0                     0                   0                        0                         0                      0              0                   0
    ## 6                         0                  0                   0                     0                   0                        0                         0                      0              0                   0
    ##   sourcepinterest.com sourceplus.google.com sourceplus.url.google.com sourceproductforums.google.com sourceqiita.com sourcequora.com sourcereddit.com sources0.2mdn.net sourcesashihara.jp sourceseroundtable.com
    ## 1                   0                     0                         0                              0               0               0                0                 0                  0                      0
    ## 2                   0                     0                         0                              0               0               0                0                 0                  0                      0
    ## 3                   0                     0                         0                              0               0               0                0                 0                  0                      0
    ## 4                   0                     0                         0                              0               0               0                0                 0                  0                      0
    ## 5                   0                     0                         0                              0               0               0                0                 0                  0                      0
    ## 6                   0                     0                         0                              0               0               0                0                 0                  0                      0
    ##   sourcesg.search.yahoo.com sourcesiliconvalley.about.com sourcesites.google.com sourcet.co sourceuk.search.yahoo.com sourceyahoo sourceyoutube.com
    ## 1                         0                             0                      0          0                         0           0                 0
    ## 2                         0                             0                      0          0                         0           0                 0
    ## 3                         0                             0                      0          0                         0           0                 0
    ## 4                         0                             0                      0          0                         0           0                 0
    ## 5                         0                             0                      0          0                         0           0                 0
    ## 6                         0                             0                      0          0                         0           0                 0

`Matrix::` `CsparseMatrix` R object

``` r
# create sparse model matrix
mm_sparse <- sparse.model.matrix(purchase~source, data = ga)

head(mm_sparse)
```

    ## 6 x 69 sparse Matrix of class "dgCMatrix"

    ##   [[ suppressing 69 column names '(Intercept)', 'source(not set)', 'sourceadwords.google.com' ... ]]

    ##                                                                                                                                            
    ## 1 1 . . . . . . . . . . . . . . . . . . . 1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
    ## 2 1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
    ## 3 1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
    ## 4 1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
    ## 5 1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
    ## 6 1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

Compare object’s sizes

``` r
as.numeric(object.size(mm)/object.size(mm_sparse))
```

    ## [1] 7.524862

``` r
# => traditional matrix object is about 7.5 times larger than the sparse version
```

Run the lasso estimation with k-fold cross-validation

``` r
cvpurchase <- cv.gamlr(mm_sparse, ga$purchase, family="binomial")

summary(cvpurchase) %>% tibble()
```

    ## 
    ## 5-fold binomial cv.gamlr object

    ## # A tibble: 100 × 3
    ##    lambda   par  oos.r2
    ##     <dbl> <dbl>   <dbl>
    ##  1 0.0599     1 0      
    ##  2 0.0572     2 0.00338
    ##  3 0.0546     2 0.00672
    ##  4 0.0521     2 0.00987
    ##  5 0.0498     2 0.0128 
    ##  6 0.0475     2 0.0156 
    ##  7 0.0453     2 0.0183 
    ##  8 0.0433     2 0.0207 
    ##  9 0.0413     2 0.0231 
    ## 10 0.0394     2 0.0253 
    ## # ℹ 90 more rows

``` r
# rmarkdown::render()
```
