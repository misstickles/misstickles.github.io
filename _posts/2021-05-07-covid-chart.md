---
title: Covid-19 Charts
output: html_document
category: covid
tags: [r, covid]
---

# Playing with UK Covid data





Now we can get a summary of the `cases` data:


```r
summary(cases)
```

```
##    areaCode           areaName           areaType              date           
##  Length:162762      Length:162762      Length:162762      Min.   :2020-01-30  
##  Class :character   Class :character   Class :character   1st Qu.:2020-06-22  
##  Mode  :character   Mode  :character   Mode  :character   Median :2020-10-07  
##                                                           Mean   :2020-10-07  
##                                                           3rd Qu.:2021-01-22  
##                                                           Max.   :2021-05-09  
##                                                                               
##  newCasesBySpecimenDate newDeaths28DaysByDeathDate
##  Min.   :   0.00        Min.   : 0.000            
##  1st Qu.:   2.00        1st Qu.: 0.000            
##  Median :   7.00        Median : 0.000            
##  Mean   :  26.94        Mean   : 0.817            
##  3rd Qu.:  26.00        3rd Qu.: 1.000            
##  Max.   :1700.00        Max.   :37.000            
##  NA's   :3              NA's   :14354
```

This shows that we have *162382* observations, with a dates between 2020-01-30 and 2021-05-09.

## Wrangling the Data

To aide simplicity, we first choose a selected number of areas for data to compare and wrangle the data slightly to provide what we''ll be needing.


```r
selected <- cases %>%
  filter(areaName %in% c("Crawley", "Mid Sussex", "Horsham")) %>%
  select(areaName, date, newCasesBySpecimenDate, newDeaths28DaysByDeathDate) %>%
  mutate(
    cases7 = rollmean(newCasesBySpecimenDate, 7, na.pad = TRUE),
    deaths7 = rollmean(newDeaths28DaysByDeathDate, 7, na.pad = TRUE)
  )
```

1. Filter our areas.
1. Select the columns we are interested in.
1. Mutate the data to add columns for 7-day Rolling Average of cases and deaths.

### Crudely Plot our Data

Using the 7 day rolling average, to avoid a jagged chart, we show deaths and cases.


```r
selected %>%
  ggplot(aes(date, deaths7, colour = areaName)) +
  geom_line() +
  labs(y = "# Deaths (7 day rolling average)", x = "Death Date") +
  theme_classic()
```

![plot of chunk deaths by date](/figure/R/2021-05-07-covid-chart/deaths by date-1.png)

The `Death Date` is the date of death, given that they had **Covid-19** within the past 28 days.


```r
selected %>%
  ggplot(aes(date, cases7, colour = areaName)) +
  geom_line() +
  theme_classic()
```

```
## Warning: Removed 6 row(s) containing missing values (geom_path).
```

![plot of chunk unnamed-chunk-3](/figure/R/2021-05-07-covid-chart/unnamed-chunk-3-1.png)

```r
selected %>%
  ggplot(aes(date, cases7, fill = areaName)) +
  geom_bar(position = "fill", stat = "identity") +
  theme_classic()
```

```
## Warning: Removed 6 rows containing missing values (position_stack).
```

![plot of chunk unnamed-chunk-3](/figure/R/2021-05-07-covid-chart/unnamed-chunk-3-2.png)

## Chart for Cases and Deaths

Not the best way to display this data, but it shows the number of cases at a given time, and how the death rates followed the cases.


```r
selected %>%
  ggplot(aes(date, newCasesBySpecimenDate, colour = areaName)) +
  geom_line(aes(y = cases7)) +
  geom_line(aes(y = deaths7)) +
  #  geom_point() +
  #  geom_smooth(method = loess) +
  scale_y_continuous(trans = "log10") +
  labs(y = "# Cases", x = "Case Specimin Date", title = "7 Day rolling average of cases and deaths in selected areas at 07 May 2021") +
  theme_classic()
```

![plot of chunk 7 day cases and deaths](/figure/R/2021-05-07-covid-chart/7 day cases and deaths-1.png)


```r
selected %>%
  ggplot(aes(areaName, newCasesBySpecimenDate, colour = areaName)) +
  geom_boxplot(outlier.shape = NA) +
  labs(y = "# Cases", x = "Area", title = "Cases in selected areas at 07 May 2021") +
  geom_jitter(width = 0.3, alpha = 0.4, stroke = 0) +
  theme_bw()
```

![Boxplot with jitter for cases in selected areas](/figure/R/2021-05-07-covid-chart/box plot cases-1.png)
