---
title: World GNI
description: Some very high level of global GNI since 1971
output: html_document
category: "population data"
tags: [r, gni, map]
---

# Global GNI

## GNI (formerly GNP)

Is the sum of value added by all resident producers plus any product taxes (less subsidies) not included in the valuation of output plus net receipts of primary income (compensation of employees and property income) from abroad.

Data are in current U.S. dollars., "World Bank national accounts data, and OECD National Accounts data files.",

Economic Policy & Debt: National accounts: US$ at current prices: Aggregate indicators,Annual,Gap-filled total,"Because development encompasses many factors - economic, environmental, cultural, educational, and institutional - no single measure gives a complete picture. However, the total earnings of the residents of an economy, measured by its gross national income (GNI), is a good measure of its capacity to provide for the well-being of its people.",https://datacatalog.worldbank.org/public-licenses#cc-by

## Source

<https://datacatalog.worldbank.org/public-licenses#cc-by>



## Load the Data

Read the raw data from *World Bank*.  We replace `..` with `NA` as this is easier to work with in R and remove *Series Name* and *Series Code* columns, as we will not need these.


```r
gni_raw <- read_csv(
  "data/global_gni.csv",
  na = c("..")
) %>%
  select(-`Series Name`, -`Series Code`)
```

```
## Error: 'data/global_gni.csv' does not exist in current working directory ('D:/dev/projects/misstickles.github.io/_R').
```

```r
str(gni_raw)
```

```
## Error in str(gni_raw): object 'gni_raw' not found
```

We see from the `str()` that this data is in a wide format, with 'strange' year column names.

### Tidy the Data

To work best in R, we should use a long table format - giving one observation per row.

Here, we:

- rename the `nnnn [YRnnnn]` columns to `nnnn`
- remove all spaces in column names
- pivot the data to create `year` and gni `values` columns, each row having one one year per country


```r
# prefix first 4 digits with `y`; remove ` [YRdddd]`
# remove ` `
gni <- gni_raw %>%
  rename_with(~ sub("(^\\d{4}).*$", "\\1", .x)) %>%
  rename_with(~ sub("\\s", "", .x))
```

```
## Error in rename_with(., ~sub("(^\\d{4}).*$", "\\1", .x)): object 'gni_raw' not found
```

```r
gni <- gni %>%
  pivot_longer(matches("\\d{4}"), names_to = "year", values_to = "gni")
```

```
## Error in pivot_longer(., matches("\\d{4}"), names_to = "year", values_to = "gni"): object 'gni' not found
```

```r
str(gni)
```

```
## Error in str(gni): object 'gni' not found
```

### Select Countries

We're not doing anything major here, just being curious, so just work with a few countries.


```r
countries <- c(
  "GBR", "USA", "NZL", "AUS", "DEU", "CHN", "JPN", "CAN", "WLD"
)
```

## Plot GNI Data

A plot of GNI in current United States Dollars (USD).


```r
gni %>%
  filter(CountryCode %in% countries) %>%
  mutate(bln = gni / 1000000000) %>%
  ggplot(aes(year, bln, group = CountryCode, colour = CountryCode)) +
  geom_vline(xintercept = "2008", colour = "red3", size = 0.1) +
  geom_line(stat = "identity") +
  geom_point() +
  geom_smooth(method = "loess") +
  facet_wrap(~CountryName, scales = "free") +
  scale_x_discrete(breaks = seq(1971, 2021, 10)) +
  scale_y_continuous(expand = c(0, 0), labels = label_comma()) +
  labs(
    title = "GNI Actual Values between 1971 and 2000",
    subtitle = "current USD, billions (1e+9)",
    x = "Year",
    y = "Value (billion USD)",
    caption = "vertical line marks the 2008 'financial crisis'"
  ) +
  theme(legend.position = "none")
```

```
## Error in filter(., CountryCode %in% countries): object 'gni' not found
```

The vertical line represents the year 2008, when the "global financial crisis" occurred.

It is interesting to see that it actually helped Japan and (apart from a quick, small fall) Australia.

The United Kingdom fared the worse, but appears to have been in decline before the event.

The United States only flattened out.

Zooming out to the World data, there clearly is a dip in GNI, but also in approx. 2015 which can also be seen in the chosen country charts.

## Percentage Change

Perhaps a "fairer" approach for comparison, is to compare the percentage increase since the first observed year.

This code will select the minimum year and create a new column (`first`) containing that data for each country.


```r
first_observation <- gni %>%
  drop_na() %>%
  arrange(CountryCode, year) %>%
  group_by(CountryCode) %>%
  slice_min(year) %>%
  rename(first = gni)
```

```
## Error in drop_na(.): object 'gni' not found
```

Join our first observation data to the original GNI data.

Also create a `percent` column which takes each GNI observation and creates a percentage increase since the first observation...


```r
gni_pct <- gni %>%
  left_join(
    select(first_observation, CountryCode, first),
    by = "CountryCode"
  ) %>%
  drop_na() %>%
  mutate(percent = (gni - first) / first * 100)
```

```
## Error in left_join(., select(first_observation, CountryCode, first), by = "CountryCode"): object 'gni' not found
```

```r
head(gni_pct)
```

```
## Error in head(gni_pct): object 'gni_pct' not found
```

... and plot.


```r
gni_pct %>%
  filter(CountryCode %in% countries) %>%
  ggplot(aes(year, percent, group = CountryCode, colour = CountryCode)) +
  geom_vline(xintercept = "2008", colour = "red3", size = 0.1) +
  geom_line(stat = "identity") +
  geom_point() +
  geom_smooth(method = "loess") +
  facet_wrap(~CountryName, scales = "free") +
  scale_x_discrete(breaks = seq(1971, 2021, 10)) +
#  scale_y_log10() +
  labs(
    title = "GNI Percentage increase since 1971",
    subsitle = "percent increase in GNI, since the previous year",
    x = "Year",
    y = "Percent Increase (log10)",
    caption = "vertical line marks the 2008 'financial crisis'"
  ) +
  theme(legend.position = "none")
```

```
## Error in filter(., CountryCode %in% countries): object 'gni_pct' not found
```

This now clearly shows almost all seemed to suffer during the late 1970s into early 1980s (including the "winter of discontent").

## Fun Stats

### Biggest Increase


```r
biggest <- gni_pct[which.max(gni_pct$percent), ]
```

```
## Error in eval(expr, envir, enclos): object 'gni_pct' not found
```

So it seems that `{r biggest$CountryName}` has and increase of `{r biggest$percent}` in `{r biggest$year}`.

Let's plot it.


```r
gni_pct %>%
  filter(CountryCode == biggest$CountryCode) %>%
  ggplot(aes(year, percent, group = CountryCode, colour = CountryCode)) +
  geom_vline(xintercept = "2008", colour = "red3", size = 0.1) +
  geom_line(stat = "identity") +
  geom_point() +
  geom_smooth(method = "loess") +
  facet_wrap(~CountryName, scales = "free") +
  scale_x_discrete(breaks = seq(1971, 2021, 10)) +
  labs(
    title = "GNI Percentage increase since 1971",
    subsitle = "percent increase in GNI, since the previous year",
    x = "Year",
    y = "Percent Increase",
    caption = "vertical line marks the 2008 'financial crisis'"
  ) +
  theme(legend.position = "none")
```

```
## Error in filter(., CountryCode == biggest$CountryCode): object 'gni_pct' not found
```

WOW!  'Something' happened in about 2001, which led to exponential increases each year.  Even `{r biggest$CountryName}` didn't escape the 2008 financial crises, nor the losses in 2015.


```r
gni_pct$percent %>%
  mutate_all(funs(. - lag(.))) %>%
  na.omit()

gni_diff <- gni_pct %>%
  group_by(CountryCode) %>%
  mutate(diff = FrequencyLag(percent, default = first(percent)))
  mutate(diff = percent = lag(percent))
  summarise_at(vars(percent), diff)
  mutate(diff = c(0, apply(gni_pct[6], 2, diff)))

gni_diff <- gni_pct %>%
  mutate(
    diff = ave(
      percent,
      factor(CountryCode),
      FUN = function(x) c(NA, diff(x))

gni_diff %>%
  filter(CountryCode %in% countries) %>%
  ggplot(aes(year, diff, group = CountryCode, colour = CountryCode)) +
  geom_vline(xintercept = "2008", colour = "red3", size = 0.1) +
  geom_line(stat = "identity") +
  geom_point() +
  geom_smooth(method = "loess") +
  facet_wrap(~CountryName, scales = "free") +
  scale_x_discrete(breaks = seq(1971, 2021, 10)) +
  # scale_y_log10() +
  labs(
    title = "GNI Percentage increase since 1971",
    subsitle = "percent increase in GNI, since the previous year",
    x = "Year",
    y = "Percent Increase (log10)",
    caption = "vertical line marks the 2008 'financial crisis'"
  ) +
  theme(legend.position = "none")
```

```
## Error: <text>:8:25: unexpected '='
## 7:   mutate(diff = FrequencyLag(percent, default = first(percent)))
## 8:   mutate(diff = percent =
##                            ^
```

## Gosh - We Need a Map!

Normally, you may want to take population into account when displaying the "value" of a country.  I don't intend to do that here, so this is one of many, many approaches that could be used to demonstrated the distribution of wealth around the world.

Randomly, I'm selecting 2019 data.  Most countries should have a value (for the interested reader to confirm if this is true!); and the value will not be impacted with the Covid-19 global epidemic.


```r
library(rworldmap)
```

```
## Error in library(rworldmap): there is no package called 'rworldmap'
```

```r
library(countrycode)

map("world")
```

```
## Error in as_mapper(.f, ...): argument ".f" is missing, with no default
```

```r
world_map <- map_data(map = "world")
world_map$region <- iso.alpha(world_map$region)

gni_map <- gni %>%
  filter(year == 2019) %>%
  na.omit() %>%
  mutate(
    iso2 = countrycode(CountryCode, origin = "iso3c", destination = "iso2c"))
```

```
## Error in filter(., year == 2019): object 'gni' not found
```

```r
gni_map %>%
  filter(iso2 == "NA") %>%
  distinct(CountryCode)
```

```
## Error in filter(., iso2 == "NA"): object 'gni_map' not found
```

```r
# Namibia's code is "NA" - load it properly (not being R's NA)
gni_map$iso2[gni_map$CountryCode == "NAM"] <- "<NA>"
```

```
## Error in gni_map$iso2[gni_map$CountryCode == "NAM"] <- "<NA>": object 'gni_map' not found
```

```r
# this is a helper to equally divide up our values into 8 equal groups
split(gni_map, cut2(gni_map$gni, g = 8))
```

```
## Error in split(gni_map, cut2(gni_map$gni, g = 8)): object 'gni_map' not found
```

```r
gni_map$ranges <- cut(
  gni_map$gni, 
      breaks = c(-Inf, 2.7e9, 1.2e10, 1.7e10, 3.75e10, 7.1e10, 2.5e11, 4.5e11, 2.2e13, Inf),
      labels = c("<2.7", "2.7-12", "12-17", "17-37.5", "37.5-71", "71-250", "250-450", "450-2,200", ">2,200"))
```

```
## Error in cut(gni_map$gni, breaks = c(-Inf, 2.7e+09, 1.2e+10, 1.7e+10, : object 'gni_map' not found
```

```r
world <- gni_map %>%
  ggplot() +
  geom_map(aes(map_id = iso2, fill = (ranges)), map = world_map) +
  geom_polygon(data = world_map, aes(x = long, y = lat, group = group), colour = 'black', fill = NA) +
  scale_fill_manual(name = "GNI Range", values = (brewer.pal(8, name = "Reds"))) +
  theme_bw() +
  theme(legend.position = "bottom") +
  coord_fixed() +
  labs(
    title = "World map of GNI in 2019",
    subtitle = "current USD ($) all values in billion dollars (10e9)\n"
  )
```

```
## Error in ggplot(.): object 'gni_map' not found
```

```r
world
```

```
## Error in eval(expr, envir, enclos): object 'world' not found
```


```r
world +
  scale_x_continuous(limits = c(-13, 40), expand = c(0, 0)) +
  scale_y_continuous(limits = c(33, 73), expand = c(0, 0))
```

```
## Error in eval(expr, envir, enclos): object 'world' not found
```

Also in this code, is the obtaining of a range (I'm sure this can be done 'automatically', but enough for now!).  Each range has 22/23 countries - each being within the same range of GNI.

Clearly, North America, much of Europe and Asia are all in the top 23 countries of GNI.  For some, this is the sheer size of the country, and others actually have higher wealth.
