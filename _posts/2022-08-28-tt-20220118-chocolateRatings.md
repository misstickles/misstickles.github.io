---
title: "Chocolate Ratings"
description: "Tidy Tuesday from 2022-01-18, chocolate ratings."
output: html_document
category: tidytuesday
tags: [r, tidytuesday]
layout: post

# This file is also first use of `|>` pipe (over dplyr's `%>%`).  Expect mishaps.
---

`tidytuesday's` _Chocolate Ratings_ from 18th January 2022, <https://github.com/rfordatascience/tidytuesday/tree/master/data/2022/2022-01-18>.

Using the data provided, we can investigate a few attributes of chocolate, including its rating vs characteristics; source location and manufacturer.





First, we import the data and visualise the type of data that we have.


```
##       ref       company_manufacturer company_location    review_date  
##  Min.   :   5   Length:2530          Length:2530        Min.   :2006  
##  1st Qu.: 802   Class :character     Class :character   1st Qu.:2012  
##  Median :1454   Mode  :character     Mode  :character   Median :2015  
##  Mean   :1430                                           Mean   :2014  
##  3rd Qu.:2079                                           3rd Qu.:2018  
##  Max.   :2712                                           Max.   :2021  
##  country_of_bean_origin specific_bean_origin_or_bar_name cocoa_percent     
##  Length:2530            Length:2530                      Length:2530       
##  Class :character       Class :character                 Class :character  
##  Mode  :character       Mode  :character                 Mode  :character  
##                                                                            
##                                                                            
##                                                                            
##  ingredients        most_memorable_characteristics     rating     
##  Length:2530        Length:2530                    Min.   :1.000  
##  Class :character   Class :character               1st Qu.:3.000  
##  Mode  :character   Mode  :character               Median :3.250  
##                                                    Mean   :3.196  
##                                                    3rd Qu.:3.500  
##                                                    Max.   :4.000
```

## Which characteristics are used to describe the chocolate?

![plot of chunk characteristics](/figure/R/tidytuesday/2022-08-28-tt-20220118-chocolateRatings/characteristics-1.png)

## Are these characteristics related to the review given?

![plot of chunk char_review](/figure/R/tidytuesday/2022-08-28-tt-20220118-chocolateRatings/char_review-1.png)

This plot suggestst that `3.0` is the most common rating (523 ratings), but `3.5` is most rated overall (565 ratings).  It is likely that a lot of other characteristics have few ratings each at `3.5`.  People seem a bit indifferent to their chocolate!

## Is the mention of `cocoa` preferred high % or low %?

![plot of chunk popular_cocoa](/figure/R/tidytuesday/2022-08-28-tt-20220118-chocolateRatings/popular_cocoa-1.png)

This is a strange plot - I agree!  Area just wasn't working, and line seems to be missing a few points...  `¯\_(ツ)_/¯`

- The percentage of cocoa in a bar, where _cocoa_ is a memorable characteristic, seems to follow the total number of available with that percentage of cocoa.
- `70%` cocoa is both the most available, and the most memorable with _cocoa_.
- There is even a bar with 100% cocoa (seriously??), but _cocoa_ was only memorable in `4.8%` of them!
- It's interesting that in general, percentage tends to peak when divisible by 5 (eg, 70%, 75%, 80%).  Perhaps this is rounded on behalf of consumers; or because (eg) 73% suggests accuracy that cannot be achieved; or because round numbers are actually more tasty; or something else...
- The highest proportion of memorable _cocoa_ to the number of bars available is `50%` at `56%`, `71%`, `73%` cocoa percent.

So - cocoa seems to be preferred around 70% - 75%.  Sounds a lot.  Testers may have been chocolate "connoisseurs"!  More chart(s) would be needed to discover if these are well rated. 
