---
title: "Reading a Git log in R"
description: "Using R to read a git log file"
output: html_document
category: code
tags: [r, code]
layout: post
---





Occasionally, for reasons that noone really knows, it is necessary to visualise data from repository logs.

This could include understanding who the frequent authors are, or the most often changed code file, or which files are changed together, or anything else a manager could dream up.

## Retrieve Git Data

Using `git log`, we can retrieve various log data from each commit in our repo.  Information on the command structure can be found on the [git-scm.com](https://git-scm.com/docs/git-log) site.

Here, we have chosen to get data for inserts/deletions for each file (`--numstat`); the short hash; the strict-ISO date, name, email for the author; the subject.  The output is saved to a log file.

```bash
git log --all --numstat --pretty=format:'%h~~%aI~~%aN~~%aE~~%s' --no-renames --since=2022-10-14 > logfile.log
```

Having generated our file using the command above, we can use `readr::read_lines(logfile)`\* to read each log file line to a list.

The example output below is a random selection of commits from the [Jekyll repo](https://github.com/jekyll/jekyll).

> \* for large files, `read_lines` may not be very efficient, but it works for us here...


```r
commits.raw <- readr::read_lines(logfile.log)

commits.raw |> head(10)
```

```
##  [1] "6448700552~~2022-10-16T09:13:22-07:00~~Basil Crow~~me@basilcrow.com~~Wait for inbound agent to go offline in tests (#7261)"                                                          
##  [2] "1\t1\ttest/pom.xml"                                                                                                                                                                  
##  [3] "5\t1\ttest/src/test/java/hudson/bugs/JnlpAccessWithSecuredHudsonTest.java"                                                                                                           
##  [4] "10\t6\ttest/src/test/java/hudson/slaves/JNLPLauncherRealTest.java"                                                                                                                   
##  [5] "6\t2\ttest/src/test/java/jenkins/agents/WebSocketAgentsTest.java"                                                                                                                    
##  [6] "6\t2\ttest/src/test/java/jenkins/security/Security218Test.java"                                                                                                                      
##  [7] "5\t1\ttest/src/test/java/jenkins/slaves/restarter/JnlpSlaveRestarterInstallerTest.java"                                                                                              
##  [8] ""                                                                                                                                                                                    
##  [9] "bb4061e23d~~2022-10-15T11:31:13-07:00~~dependabot[bot]~~49699333+dependabot[bot]@users.noreply.github.com~~Bump JUnit plugin from 1150.v5c2848328b_60 to 1153.v1c24f1a_d2553 (#7260)"
## [10] "1\t1\ttest/pom.xml"
```

## Wrangling

To convert this list to a tibble, we can create a new one, and parse in the data, and also filter out blank lines.

There are a number of ways to turn this into a tidy table, but I have added a `commit_number` column which adds a counter to each row.  The counter only increments when it finds our delimiter from the `git log` command (`~~`).  This means that all data for each commit can be uniquly identified, and we can use this value later on.

The data is the same as before, except it's in a 'proper' tibble and each commit has a unique way to identify it.


```r
commits.records <- tibble::tibble(data = commits.raw) |>
  dplyr::filter(data != "") |>
  dplyr::mutate(commit_number = cumsum(grepl("[~~]+", .data$data)))

commits.records |> head(10)
```

```
## # A tibble: 10 × 2
##    data                                                                  commi…¹
##    <chr>                                                                   <int>
##  1 "6448700552~~2022-10-16T09:13:22-07:00~~Basil Crow~~me@basilcrow.com…       1
##  2 "1\t1\ttest/pom.xml"                                                        1
##  3 "5\t1\ttest/src/test/java/hudson/bugs/JnlpAccessWithSecuredHudsonTes…       1
##  4 "10\t6\ttest/src/test/java/hudson/slaves/JNLPLauncherRealTest.java"         1
##  5 "6\t2\ttest/src/test/java/jenkins/agents/WebSocketAgentsTest.java"          1
##  6 "6\t2\ttest/src/test/java/jenkins/security/Security218Test.java"            1
##  7 "5\t1\ttest/src/test/java/jenkins/slaves/restarter/JnlpSlaveRestarte…       1
##  8 "bb4061e23d~~2022-10-15T11:31:13-07:00~~dependabot[bot]~~49699333+de…       2
##  9 "1\t1\ttest/pom.xml"                                                        2
## 10 "d2b6473c1a~~2022-10-15T15:30:15-03:00~~Fernando Boaglio~~boaglio@gm…       3
## # … with abbreviated variable name ¹​commit_number
```

## Tidying

So...  How do we make the commit file stats and commit information tidy?

This is one way...

Create a table with only commit information and use `tidyr::separate()` to split the string on our delimiter and create new columns.


```r
commits.info <- commits.records |>
  dplyr::filter(grepl("[~~]+", data)) |>
  tidyr::separate(data, c("commit", "ad", "an", "ae", "s"), sep = "[~~]+")

commits.info |> head(4)
```

```
## # A tibble: 4 × 6
##   commit     ad                        an               ae         s     commi…¹
##   <chr>      <chr>                     <chr>            <chr>      <chr>   <int>
## 1 6448700552 2022-10-16T09:13:22-07:00 Basil Crow       me@basilc… Wait…       1
## 2 bb4061e23d 2022-10-15T11:31:13-07:00 dependabot[bot]  49699333+… Bump…       2
## 3 d2b6473c1a 2022-10-15T15:30:15-03:00 Fernando Boaglio boaglio@g… Upda…       3
## 4 9ae07ce2cd 2022-10-15T20:29:34+02:00 Stefan Spieker   S.Spieker… Repl…       4
## # … with abbreviated variable name ¹​commit_number
```

Do similar for the file stats, in a different table.  By default the log's `numstat` separates its values with a tab `\t`.


```r
commits.stats <- commits.records |>
  dplyr::filter(!grepl("[~~]+", data)) |>
  tidyr::separate(data, c("insertions", "deletions", "filename"), sep = "[\t]+")

commits.stats |> head(10)
```

```
## # A tibble: 10 × 4
##    insertions deletions filename                                         commi…¹
##    <chr>      <chr>     <chr>                                              <int>
##  1 1          1         test/pom.xml                                           1
##  2 5          1         test/src/test/java/hudson/bugs/JnlpAccessWithSe…       1
##  3 10         6         test/src/test/java/hudson/slaves/JNLPLauncherRe…       1
##  4 6          2         test/src/test/java/jenkins/agents/WebSocketAgen…       1
##  5 6          2         test/src/test/java/jenkins/security/Security218…       1
##  6 5          1         test/src/test/java/jenkins/slaves/restarter/Jnl…       1
##  7 1          1         test/pom.xml                                           2
##  8 11         7         core/src/main/resources/hudson/Messages_pt_BR.p…       3
##  9 3          2         core/src/main/resources/hudson/PluginManager/ad…       3
## 10 3          2         core/src/main/resources/hudson/PluginManager/av…       3
## # … with abbreviated variable name ¹​commit_number
```

For both info and stats, we have kept our `commit_number` column.

We can use this to join stats to info.


```r
commits <- commits.info |>
  dplyr::left_join(commits.stats, by = "commit_number") |>
  dplyr::mutate(ad = as.Date(ad))

commits |> head(10)
```

```
## # A tibble: 10 × 9
##    commit     ad         an          ae    s     commi…¹ inser…² delet…³ filen…⁴
##    <chr>      <date>     <chr>       <chr> <chr>   <int> <chr>   <chr>   <chr>  
##  1 6448700552 2022-10-16 Basil Crow  me@b… Wait…       1 1       1       test/p…
##  2 6448700552 2022-10-16 Basil Crow  me@b… Wait…       1 5       1       test/s…
##  3 6448700552 2022-10-16 Basil Crow  me@b… Wait…       1 10      6       test/s…
##  4 6448700552 2022-10-16 Basil Crow  me@b… Wait…       1 6       2       test/s…
##  5 6448700552 2022-10-16 Basil Crow  me@b… Wait…       1 6       2       test/s…
##  6 6448700552 2022-10-16 Basil Crow  me@b… Wait…       1 5       1       test/s…
##  7 bb4061e23d 2022-10-15 dependabot… 4969… Bump…       2 1       1       test/p…
##  8 d2b6473c1a 2022-10-15 Fernando B… boag… Upda…       3 11      7       core/s…
##  9 d2b6473c1a 2022-10-15 Fernando B… boag… Upda…       3 3       2       core/s…
## 10 d2b6473c1a 2022-10-15 Fernando B… boag… Upda…       3 3       2       core/s…
## # … with abbreviated variable names ¹​commit_number, ²​insertions, ³​deletions,
## #   ⁴​filename
```

We now have a tidy table of git logs, that we can use to observe patterns within repo commits.

Phew!

Obvious that it may seem, it took me quite a while to come up with this solution.  On the way, I have learned to use `grepl` and `separate` more, which will be useful for my other projects.

---

Inspiration was taken from these two blogs: <https://www.feststelltaste.de/reading-a-git-log-file-output-with-pandas/> and <https://www.r-bloggers.com/2018/03/guide-to-tidy-git-analysis/>.
