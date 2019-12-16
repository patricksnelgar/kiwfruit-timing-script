This is a small script to simplify the process of filling out the flower
timing data sets. The process involves swapping NAs for 0 and carrying
over the maximum count for canes that finished early so that there is a
numerical value for each cane in each column.

A log of unusual events is kept and appended to the final data frame. At
this point in dev the only observation that is ‘caught’ is when the
value in the current column is smaller than the maximum value seen so
far, this is done to make sure the percentage open cannot go *down*.

The final step is to `gather` the matrix into long format with the
column names as the key factor.

Example
-------

Raw data file

    head(rawG11)

    ## # A tibble: 6 x 23
    ##   CaneID `30-Oct` `1-Nov` `5-Nov` `7-Nov` `11-Nov` `14-Nov`    X8 `18-Nov` X10  
    ##    <dbl> <lgl>    <lgl>     <dbl>   <dbl>    <dbl>    <dbl> <dbl>    <dbl> <chr>
    ## 1   1001 NA       NA           NA      NA       12       18     9       25 3    
    ## 2   1002 NA       NA           NA      NA        0        3    NA       12 <NA> 
    ## 3   1003 NA       NA           NA      NA        3       13    NA       23 5    
    ## 4   1004 NA       NA           NA      NA        0        0    NA        3 <NA> 
    ## 5   1005 NA       NA           NA      NA        0       13    NA       17 x    
    ## 6   1006 NA       NA           NA      NA        1        6    NA       11 2    
    ## # ... with 13 more variables: `21-Nov` <dbl>, X12 <chr>, `25-Nov` <dbl>,
    ## #   X14 <chr>, `28-Nov` <dbl>, X16 <chr>, `2-Dec` <dbl>, X18 <chr>, X19 <lgl>,
    ## #   X20 <lgl>, X21 <lgl>, X22 <lgl>, X23 <lgl>

After processing:

    head(processedG11_flowering)

    ## # A tibble: 6 x 5
    ## # Groups:   CaneID [1]
    ##   CaneID Date       FlowerCount FlowerPercentage information
    ##    <dbl> <date>           <dbl>            <dbl> <fct>      
    ## 1   1001 2019-10-30           0            0     <NA>       
    ## 2   1001 2019-11-01           0            0     <NA>       
    ## 3   1001 2019-11-05           0            0     <NA>       
    ## 4   1001 2019-11-07           0            0     <NA>       
    ## 5   1001 2019-11-11          12            0.444 <NA>       
    ## 6   1001 2019-11-14          18            0.667 <NA>
