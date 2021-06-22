---
title: World GNI
description: Some very high level looking at a selection of countries's GNI since 1971, with a global map plot.
output: html_document
category: "population data"
tags: [r, gni, map]
---

# Global GNI

## GNI (formerly GNP)

Is the sum of value added by all resident producers plus any product taxes (less subsidies) not included in the valuation of output plus net receipts of primary income (compensation of employees and property income) from abroad.

All data are in current U.S. dollars.

## Source

All data is from the *[World Bank](https://www.worldbank.org/)* and uses a [Creative Commons](https://datacatalog.worldbank.org/public-licenses#cc-by) licence.  Current at 2021-06-21.  Data is found here:

<https://databank.worldbank.org/reports.aspx?source=2&series=NY.GNP.PCAP.CD&country=>



## Load the Data

Read the raw data from *World Bank*.  We replace `..` with `NA` as this is easier to work with in R and remove *Series Name* and *Series Code* columns, as we will not need these.


{% highlight r %}
gni_raw <- read_csv(
  "../data/global_gni.csv",
  na = c("..")
) %>%
  select(-`Series Name`, -`Series Code`)

str(gni_raw)
{% endhighlight %}



{% highlight text %}
## tibble [269 x 52] (S3: tbl_df/tbl/data.frame)
##  $ Country Name : chr [1:269] "Afghanistan" "Albania" "Algeria" "American Samoa" ...
##  $ Country Code : chr [1:269] "AFG" "ALB" "DZA" "ASM" ...
##  $ 1971 [YR1971]: num [1:269] 1.87e+09 NA 5.04e+09 NA NA ...
##  $ 1972 [YR1972]: num [1:269] 1.63e+09 NA 6.74e+09 NA NA ...
##  $ 1973 [YR1973]: num [1:269] 1.77e+09 NA 8.64e+09 7.56e+07 NA ...
##  $ 1974 [YR1974]: num [1:269] 2.20e+09 NA 1.31e+10 7.70e+07 NA ...
##  $ 1975 [YR1975]: num [1:269] 2.42e+09 NA 1.54e+10 6.77e+07 NA ...
##  $ 1976 [YR1976]: num [1:269] 2.61e+09 NA 1.74e+10 6.85e+07 NA ...
##  $ 1977 [YR1977]: num [1:269] 3.02e+09 NA 1.98e+10 7.92e+07 NA ...
##  $ 1978 [YR1978]: num [1:269] 3.37e+09 NA 2.51e+10 8.47e+07 NA ...
##  $ 1979 [YR1979]: num [1:269] 3.78e+09 NA 3.15e+10 1.06e+08 NA ...
##  $ 1980 [YR1980]: num [1:269] 3.72e+09 NA 4.05e+10 1.27e+08 NA ...
##  $ 1981 [YR1981]: num [1:269] 3.55e+09 NA 4.23e+10 1.39e+08 NA ...
##  $ 1982 [YR1982]: num [1:269] NA NA 4.32e+10 1.51e+08 NA ...
##  $ 1983 [YR1983]: num [1:269] NA NA 4.70e+10 1.66e+08 NA ...
##  $ 1984 [YR1984]: num [1:269] NA 1.86e+09 5.20e+10 1.78e+08 NA ...
##  $ 1985 [YR1985]: num [1:269] NA 1.90e+09 5.64e+10 1.90e+08 NA ...
##  $ 1986 [YR1986]: num [1:269] NA 2.1e+09 6.2e+10 NA NA ...
##  $ 1987 [YR1987]: num [1:269] NA 2.08e+09 6.48e+10 NA NA ...
##  $ 1988 [YR1988]: num [1:269] NA 2.05e+09 5.66e+10 NA NA ...
##  $ 1989 [YR1989]: num [1:269] NA 2.25e+09 5.36e+10 NA NA ...
##  $ 1990 [YR1990]: num [1:269] NA 2.03e+09 5.98e+10 NA NA ...
##  $ 1991 [YR1991]: num [1:269] NA 1.08e+09 4.32e+10 NA NA ...
##  $ 1992 [YR1992]: num [1:269] NA 6.17e+08 4.58e+10 NA NA ...
##  $ 1993 [YR1993]: num [1:269] NA 1.22e+09 4.82e+10 NA NA ...
##  $ 1994 [YR1994]: num [1:269] NA 1.89e+09 4.08e+10 NA NA ...
##  $ 1995 [YR1995]: num [1:269] NA 2.44e+09 3.96e+10 NA NA ...
##  $ 1996 [YR1996]: num [1:269] NA 3.27e+09 4.44e+10 NA NA ...
##  $ 1997 [YR1997]: num [1:269] NA 2.31e+09 4.60e+10 NA NA ...
##  $ 1998 [YR1998]: num [1:269] NA 2.62e+09 4.62e+10 NA NA ...
##  $ 1999 [YR1999]: num [1:269] NA 3.29e+09 4.64e+10 NA NA ...
##  $ 2000 [YR2000]: num [1:269] NA 3.59e+09 5.21e+10 NA NA ...
##  $ 2001 [YR2001]: num [1:269] NA 4.07e+09 5.31e+10 NA NA ...
##  $ 2002 [YR2002]: num [1:269] NA 4.48e+09 5.45e+10 NA NA ...
##  $ 2003 [YR2003]: num [1:269] NA 5.78e+09 6.52e+10 NA NA ...
##  $ 2004 [YR2004]: num [1:269] NA 7.36e+09 8.17e+10 NA NA ...
##  $ 2005 [YR2005]: num [1:269] NA 8.23e+09 9.81e+10 NA NA ...
##  $ 2006 [YR2006]: num [1:269] NA 9.16e+09 1.12e+11 NA NA ...
##  $ 2007 [YR2007]: num [1:269] NA 1.10e+10 1.33e+11 NA NA ...
##  $ 2008 [YR2008]: num [1:269] NA 1.29e+10 1.70e+11 NA NA ...
##  $ 2009 [YR2009]: num [1:269] 1.24e+10 1.19e+10 1.36e+11 NA NA ...
##  $ 2010 [YR2010]: num [1:269] 1.59e+10 1.18e+10 1.61e+11 NA NA ...
##  $ 2011 [YR2011]: num [1:269] 1.78e+10 1.29e+10 1.98e+11 NA NA ...
##  $ 2012 [YR2012]: num [1:269] 2.00e+10 1.22e+10 2.05e+11 NA NA ...
##  $ 2013 [YR2013]: num [1:269] 2.06e+10 1.30e+10 2.05e+11 NA NA ...
##  $ 2014 [YR2014]: num [1:269] 2.05e+10 1.34e+10 2.09e+11 NA NA ...
##  $ 2015 [YR2015]: num [1:269] 2.01e+10 1.15e+10 1.62e+11 NA NA ...
##  $ 2016 [YR2016]: num [1:269] 1.82e+10 1.21e+10 1.58e+11 NA NA ...
##  $ 2017 [YR2017]: num [1:269] 1.91e+10 1.31e+10 1.68e+11 NA NA ...
##  $ 2018 [YR2018]: num [1:269] 1.85e+10 1.51e+10 1.71e+11 NA NA ...
##  $ 2019 [YR2019]: num [1:269] 1.96e+10 1.51e+10 1.67e+11 NA NA ...
##  $ 2020 [YR2020]: logi [1:269] NA NA NA NA NA NA ...
{% endhighlight %}

We see from the `str()` that this data is in a wide format, with 'strange' year column names.

### Tidy the Data

To work best in R, we should use a long table format - giving one observation per row.

Here, we:

- rename the `nnnn [YRnnnn]` columns to `nnnn`
- remove all spaces in column names
- pivot the data to create `year` and gni `values` columns, each row having one one year per country


{% highlight r %}
# prefix first 4 digits with `y`; remove ` [YRdddd]`
# remove ` `
gni <- gni_raw %>%
  rename_with(~ sub("(^\\d{4}).*$", "\\1", .x)) %>%
  rename_with(~ sub("\\s", "", .x))

gni <- gni %>%
  pivot_longer(matches("\\d{4}"), names_to = "year", values_to = "gni")

str(gni)
{% endhighlight %}



{% highlight text %}
## tibble [13,450 x 4] (S3: tbl_df/tbl/data.frame)
##  $ CountryName: chr [1:13450] "Afghanistan" "Afghanistan" "Afghanistan" "Afghanistan" ...
##  $ CountryCode: chr [1:13450] "AFG" "AFG" "AFG" "AFG" ...
##  $ year       : chr [1:13450] "1971" "1972" "1973" "1974" ...
##  $ gni        : num [1:13450] 1.87e+09 1.63e+09 1.77e+09 2.20e+09 2.42e+09 ...
{% endhighlight %}

### Select Countries

We're not doing anything major here, just being curious, so just work with a few countries.


{% highlight r %}
countries <- c(
  "GBR", "USA", "NZL", "AUS", "DEU", "CHN", "JPN", "CAN", "WLD"
)
{% endhighlight %}

## Plot GNI Data

A plot of GNI in current United States Dollars (USD).


{% highlight r %}
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
{% endhighlight %}

![center](/figure/R/2021-06-16-global-gni/plot-actual-1.png)

The vertical line represents the year 2008, when the "global financial crisis" occurred.

It is interesting to see that it actually helped Japan and (apart from a quick, small fall) Australia.

The United Kingdom fared the worse, but appears to have been in decline before the event.

The United States only flattened out.

Zooming out to the World data, there clearly is a dip in GNI, but also in approx. 2015 which can also be seen in the chosen country charts.

## Percentage Change

Perhaps a "fairer" approach for comparison, is to compare the percentage increase since the first observed year.

This code will select the minimum year and create a new column (`first`) containing that data for each country.


{% highlight r %}
first_observation <- gni %>%
  drop_na() %>%
  arrange(CountryCode, year) %>%
  group_by(CountryCode) %>%
  slice_min(year) %>%
  rename(first = gni)
{% endhighlight %}

Join our first observation data to the original GNI data.

Also create a `percent` column which takes each GNI observation and creates a percentage increase since the first observation...


{% highlight r %}
gni_pct <- gni %>%
  left_join(
    select(first_observation, CountryCode, first),
    by = "CountryCode"
  ) %>%
  drop_na() %>%
  mutate(percent = (gni - first) / first * 100)

head(gni_pct)
{% endhighlight %}



{% highlight text %}
## # A tibble: 6 x 6
##   CountryName CountryCode year          gni       first percent
##   <chr>       <chr>       <chr>       <dbl>       <dbl>   <dbl>
## 1 Afghanistan AFG         1971  1868886653. 1868886653.    0   
## 2 Afghanistan AFG         1972  1631108938. 1868886653.  -12.7 
## 3 Afghanistan AFG         1973  1771108944. 1868886653.   -5.23
## 4 Afghanistan AFG         1974  2202222229. 1868886653.   17.8 
## 5 Afghanistan AFG         1975  2417777778. 1868886653.   29.4 
## 6 Afghanistan AFG         1976  2611111162. 1868886653.   39.7
{% endhighlight %}

... and plot.


{% highlight r %}
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
{% endhighlight %}

![center](/figure/R/2021-06-16-global-gni/plot-pc-1.png)

This now clearly shows almost all seemed to suffer during the late 1970s into early 1980s (including the "winter of discontent").

## Fun Stats

### Biggest Increase


{% highlight r %}
biggest <- gni_pct[which.max(gni_pct$percent), ]
{% endhighlight %}

So it seems that Qatar has and increase of 55,261.22% in 2014.

Let's plot it.


{% highlight r %}
gni_pct %>%
  filter(CountryCode == biggest$CountryCode) %>%
  ggplot(aes(year, percent, group = CountryCode, colour = CountryCode)) +
  geom_vline(xintercept = biggest$year, colour = "green3", size = 0.5) +
  geom_vline(
    xintercept = "2008",
    colour = "red3",
    size = 0.6,
    linetype = "dotted"
  ) +
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
    caption = "dashed line marks the 2008 'financial crisis'\n
      green line is the year 2014"
  ) +
  theme(legend.position = "none")
{% endhighlight %}

![center](/figure/R/2021-06-16-global-gni/biggest-pc-1.png)

WOW!  'Something' happened in about 2001, which led to exponential increases each year.  Even Qatar didn't escape the 2008 financial crises, nor the losses in 2015 (see above) - which occur the year after the highest GNI.

## Getting Percent Increase Each Year

Hmmmm....


{% highlight r %}
# gni_pct$percent %>%
#  mutate_all(funs(. - lag(.))) %>%
#  na.omit()

# gni_diff <- gni_pct %>%
#   group_by(CountryCode) %>%
#   mutate(diff = FrequencyLag(percent, default = first(percent)))
#   mutate(diff = percent = lag(percent))
#   summarise_at(vars(percent), diff)
#   mutate(diff = c(0, apply(gni_pct[6], 2, diff)))

# gni_diff <- gni_pct %>%
#  mutate(
#    diff = ave(
#      percent,
#      factor(CountryCode),
#      FUN = function(x) c(NA, diff(x))


#   filter(CountryCode %in% countries) %>%
#   ggplot(aes(year, diff, group = CountryCode, colour = CountryCode)) +
#   geom_vline(xintercept = "2008", colour = "red3", size = 0.1) +
#   geom_line(stat = "identity") +
#   geom_point() +
#   geom_smooth(method = "loess") +
#   facet_wrap(~CountryName, scales = "free") +
#   scale_x_discrete(breaks = seq(1971, 2021, 10)) +
#   # scale_y_log10() +
#   labs(
#     title = "GNI Percentage increase since 1971",
#     subsitle = "percent increase in GNI, since the previous year",
#     x = "Year",
#     y = "Percent Increase (log10)",
#     caption = "vertical line marks the 2008 'financial crisis'"
#   ) +
#   theme(legend.position = "none")
{% endhighlight %}

## Gosh - We Need a Map!

Normally, you may want to take population into account when displaying the "value" of a country.  I don't intend to do that here, so this is one of many, many approaches that could be used to demonstrate the distribution of wealth around the world.

Randomly, I'm selecting 2019 data.  Most countries should have a value (for the interested reader to confirm if this is true!); and the value will not be impacted by the Covid-19 global epidemic.

### Arrange World Data and Create Map Data


{% highlight r %}
world_map <- map_data(map = "world")
world_map$region <- iso.alpha(world_map$region)

gni_map <- gni %>%
  filter(year == 2019) %>%
  na.omit() %>%
  mutate(
    iso2 = countrycode(CountryCode, origin = "iso3c", destination = "iso2c")
  )

gni_map %>%
  filter(iso2 == "NA") %>%
  distinct(CountryCode)
{% endhighlight %}



{% highlight text %}
## # A tibble: 1 x 1
##   CountryCode
##   <chr>      
## 1 NAM
{% endhighlight %}



{% highlight r %}
# Namibia's code is "NA" - load it properly (not being R's NA)
gni_map$iso2[gni_map$CountryCode == "NAM"] <- "<NA>"
{% endhighlight %}

In this code, we obtain a range (I'm sure this can be done 'automatically', but enough for now!).  Dividing into 8 groups, each group has 22/23 countries - each being within the same range of GNI.  On another project, we could first remove the regions (groups of countries) that are in the data, which may skew the result...

We manually create the list of breaks and labels, based on the result.


{% highlight r %}
split(gni_map, cut2(gni_map$gni, g = 8))
{% endhighlight %}



{% highlight text %}
## $`[6.53e+07,3.28e+09)`
## # A tibble: 29 x 5
##    CountryName              CountryCode year          gni iso2 
##    <chr>                    <chr>       <chr>       <dbl> <chr>
##  1 Antigua and Barbuda      ATG         2019  1582208562. AG   
##  2 Belize                   BLZ         2019  1721313600  BZ   
##  3 Bhutan                   BTN         2019  2300999286. BT   
##  4 Burundi                  BDI         2019  3019539459. BI   
##  5 Cabo Verde               CPV         2019  1939454972. CV   
##  6 Central African Republic CAF         2019  2386023522. CF   
##  7 Comoros                  COM         2019  1170987117. KM   
##  8 Curacao                  CUW         2019  3234078212. CW   
##  9 Djibouti                 DJI         2019  3230790007. DJ   
## 10 Dominica                 DMA         2019   573346766. DM   
## # ... with 19 more rows
## 
## $`[3.28e+09,1.36e+10)`
## # A tibble: 28 x 5
##    CountryName       CountryCode year           gni iso2 
##    <chr>             <chr>       <chr>        <dbl> <chr>
##  1 Bahamas, The      BHS         2019  13114074100  BS   
##  2 Barbados          BRB         2019   5030074650  BB   
##  3 Bermuda           BMU         2019   7587978000  BM   
##  4 Chad              TCD         2019  11140998595. TD   
##  5 Congo, Rep.       COG         2019   9534724557. CG   
##  6 Equatorial Guinea GNQ         2019   8329917011. GQ   
##  7 Eswatini          SWZ         2019   4018702284. SZ   
##  8 Fiji              FJI         2019   5045408258. FJ   
##  9 Guinea            GIN         2019  12180561102. GN   
## 10 Guyana            GUY         2019   5127159528. GY   
## # ... with 18 more rows
## 
## $`[1.36e+10,2.57e+10)`
## # A tibble: 28 x 5
##    CountryName            CountryCode year           gni iso2 
##    <chr>                  <chr>       <chr>        <dbl> <chr>
##  1 Afghanistan            AFG         2019  19597763437. AF   
##  2 Albania                ALB         2019  15077445950. AL   
##  3 Armenia                ARM         2019  13900535496. AM   
##  4 Benin                  BEN         2019  14247234409. BJ   
##  5 Bosnia and Herzegovina BIH         2019  20151944937. BA   
##  6 Botswana               BWA         2019  16946994059. BW   
##  7 Brunei Darussalam      BRN         2019  13830513708. BN   
##  8 Burkina Faso           BFA         2019  15326472488. BF   
##  9 Cambodia               KHM         2019  25525556830. KH   
## 10 Cyprus                 CYP         2019  23946675249. CY   
## # ... with 18 more rows
## 
## $`[2.57e+10,6.55e+10)`
## # A tibble: 28 x 5
##    CountryName      CountryCode year           gni iso2 
##    <chr>            <chr>       <chr>        <dbl> <chr>
##  1 Azerbaijan       AZE         2019  45986633059. AZ   
##  2 Bahrain          BHR         2019  36313430851. BH   
##  3 Belarus          BLR         2019  61210714648. BY   
##  4 Bolivia          BOL         2019  40080303995. BO   
##  5 Cameroon         CMR         2019  38259800550. CM   
##  6 Congo, Dem. Rep. COD         2019  48961721244. CD   
##  7 Costa Rica       CRI         2019  58190318731. CR   
##  8 Cote d'Ivoire    CIV         2019  56975603680. CI   
##  9 Croatia          HRV         2019  59830033764. HR   
## 10 El Salvador      SLV         2019  25716490000  SV   
## # ... with 18 more rows
## 
## $`[6.55e+10,2.71e+11)`
## # A tibble: 29 x 5
##    CountryName        CountryCode year            gni iso2 
##    <chr>              <chr>       <chr>         <dbl> <chr>
##  1 Algeria            DZA         2019  166891289782. DZ   
##  2 Angola             AGO         2019   81299397793. AO   
##  3 Bulgaria           BGR         2019   67445642244. BG   
##  4 Czech Republic     CZE         2019  235270023657. CZ   
##  5 Dominican Republic DOM         2019   84666208178. DO   
##  6 Ecuador            ECU         2019  104407196200  EC   
##  7 Ethiopia           ETH         2019   95322999765. ET   
##  8 Finland            FIN         2019  270598259035. FI   
##  9 Ghana              GHA         2019   65527306781. GH   
## 10 Greece             GRC         2019  203644992868. GR   
## # ... with 19 more rows
## 
## $`[2.71e+11,8.01e+11)`
## # A tibble: 28 x 5
##    CountryName          CountryCode year            gni iso2 
##    <chr>                <chr>       <chr>         <dbl> <chr>
##  1 Argentina            ARG         2019  427609245336. AR   
##  2 Austria              AUT         2019  447294996188. AT   
##  3 Bangladesh           BGD         2019  316907374622. BD   
##  4 Belgium              BEL         2019  539738514469. BE   
##  5 Chile                CHL         2019  270972766317. CL   
##  6 Colombia             COL         2019  313494121786. CO   
##  7 Denmark              DNK         2019  360446396646. DK   
##  8 Egypt, Arab Rep.     EGY         2019  292082655125. EG   
##  9 Hong Kong SAR, China HKG         2019  384620528593. HK   
## 10 Ireland              IRL         2019  308373471052. IE   
## # ... with 18 more rows
## 
## $`[8.01e+11,3.66e+12)`
## # A tibble: 28 x 5
##    CountryName CountryCode year      gni iso2 
##    <chr>       <chr>       <chr>   <dbl> <chr>
##  1 Australia   AUS         2019  1.35e12 AU   
##  2 Brazil      BRA         2019  1.79e12 BR   
##  3 Canada      CAN         2019  1.72e12 CA   
##  4 France      FRA         2019  2.77e12 FR   
##  5 India       IND         2019  2.84e12 IN   
##  6 Indonesia   IDN         2019  1.09e12 ID   
##  7 Italy       ITA         2019  2.02e12 IT   
##  8 Korea, Rep. KOR         2019  1.66e12 KR   
##  9 Mexico      MEX         2019  1.23e12 MX   
## 10 Netherlands NLD         2019  9.11e11 NL   
## # ... with 18 more rows
## 
## $`[3.66e+12,8.77e+13]`
## # A tibble: 28 x 5
##    CountryName                                 CountryCode year      gni iso2 
##    <chr>                                       <chr>       <chr>   <dbl> <chr>
##  1 China                                       CHN         2019  1.42e13 CN   
##  2 Germany                                     DEU         2019  3.97e12 DE   
##  3 Japan                                       JPN         2019  5.27e12 JP   
##  4 United States                               USA         2019  2.17e13 US   
##  5 Early-demographic dividend                  EAR         2019  1.18e13 <NA> 
##  6 East Asia & Pacific                         EAS         2019  2.70e13 <NA> 
##  7 East Asia & Pacific (excluding high income) EAP         2019  1.71e13 <NA> 
##  8 East Asia & Pacific (IDA & IBRD countries)  TEA         2019  1.70e13 <NA> 
##  9 Euro area                                   EMU         2019  1.34e13 <NA> 
## 10 Europe & Central Asia                       ECS         2019  2.27e13 <NA> 
## # ... with 18 more rows
{% endhighlight %}



{% highlight r %}
gni_map$ranges <- cut(
  gni_map$gni,
  breaks = c(
    0, 2.7e9,
    1.2e10, 1.7e10,
    3.75e10, 7.1e10,
    2.5e11, 4.5e11,
    2.2e13, Inf
  ),
  labels = c(
    "Under 2.7", "2.7 - 12",
    "12 - 17", "17 - 37.5",
    "37.5 - 71", "71 - 250",
    "250 - 450", "450 - 2,200",
    "Over 2,200"
  )
)
{% endhighlight %}

### Plot the World


{% highlight r %}
world <- gni_map %>%
  ggplot() +
  geom_map(aes(map_id = iso2, fill = (ranges)), map = world_map) +
  geom_polygon(
    data = world_map, aes(
      x = long,
      y = lat,
      group = group
    ),
    colour = "black",
    fill = NA
  ) +
  scale_fill_manual(
    name = "GNI Range",
    values = (brewer.pal(9, name = "Reds"))
  ) +
  theme_void() +
  theme(legend.position = "bottom") +
  labs(
    title = "World map of GNI in 2019",
    subtitle = "current USD ($) all values in billion dollars (10e9)\n"
  )

world
{% endhighlight %}

![center](/figure/R/2021-06-16-global-gni/world-plot-1.png)

### Zoom in to Europe


{% highlight r %}
world +
  scale_x_continuous(limits = c(-13, 40), expand = c(0, 0)) +
  scale_y_continuous(limits = c(33, 73), expand = c(0, 0))
{% endhighlight %}

![center](/figure/R/2021-06-16-global-gni/europe-plot-1.png)

Clearly, North America, much of Europe and Asia are all in the top 23 countries of GNI.  For some, this is the sheer size of the country, and others actually have higher wealth.

## Conclusion

... Much more to do ...
Many more places to go.  This has been great learning for **R**, but perhaps I should write more conclusions!!
