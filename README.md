# Cleaning the Weather Forecast

The National Weather Service provides an hour-by-hour forecast for the
next seven days at the website `forecast.weather.gov`.

The file `scraper.R` contains the function `get_forecast` which
downloads hourly forecast for the specified location, and converts the
xml format into an R data frame.

    source("scraper.R", verbose=F)

    head(get_forecast)

    ##                                                                                                      
    ## 1 function (latitude, longitude)                                                                     
    ## 2 {                                                                                                  
    ## 3     url <- sprintf("https://forecast.weather.gov/MapClick.php?lat=%f&lon=%f&FcstType=digitalDWML", 
    ## 4         latitude, longitude)                                                                       
    ## 5     xml_data <- read_xml(url)                                                                      
    ## 6     write_xml(xml_data, file = "download.xml")

The `get_forecast` function can be used to get data for Lincoln, NE or
Ames, IA as shown below. Note that this code chunk is set to not
automatically evaluate `eval = FALSE`, since we do not want to download
new data every single time we render the current document. Instead, the
results are saved in `rds` format and loaded in the next code chunk.

    lincoln <- get_forecast(40.8164, -96.6882)
    saveRDS(lincoln, "lincoln.rds")

    ames <- get_forecast(42.04, -93.68)
    saveRDS(ames, "ames.rds")

Load previously saved data for Lincoln:

    lincoln <- readRDS("lincoln.rds")
    head(lincoln)

    ## # A tibble: 6 × 9
    ##   parameter   type   units values times     latitude longitude conditions source
    ##   <chr>       <chr>  <chr> <chr>  <chr>     <chr>    <chr>     <chr>      <chr> 
    ## 1 temperature hourly <NA>  70     2025-08-… 40.8164… -96.6882… rain (cha… WFO O…
    ## 2 temperature hourly <NA>  72     2025-08-… 40.8164… -96.6882… rain (cha… WFO O…
    ## 3 temperature hourly <NA>  73     2025-08-… 40.8164… -96.6882… rain (cha… WFO O…
    ## 4 temperature hourly <NA>  74     2025-08-… 40.8164… -96.6882… rain (cha… WFO O…
    ## 5 temperature hourly <NA>  74     2025-08-… 40.8164… -96.6882… thunderst… WFO O…
    ## 6 temperature hourly <NA>  74     2025-08-… 40.8164… -96.6882… thunderst… WFO O…

# TODO

Your job is to get a handle on the data structure.

1.  Create a Quarto document called `index.qmd`, add it to the
    repository and include all of your answers and code in that file.
    Make sure to structure it such that it is obvious, which question
    you are addressing in which section of the file.

2.  Pick a place of your choice in the US and identify its latitude and
    longitude. Use the function `get_forecast` to get the 7-day forecast
    for that location. Save the data you scraped in an `rds` file and
    add the file to the homework repo.

3.  Find examples in the data for violations of two different principles
    of tidy data. Describe which principle they violate and how.

4.  Is the set of variables `latitude, longitude, times, parameter` a
    key to the data? Show (with code) why or why not.

5.  You are charged with re-structuring the data set such that the
    variables `latitude, longitude,` and `times` are a key.

    1.  describe in words the format of the data set that has
        `latitude, longitude,` and `times` as key.
    2.  write the code that reshapes the data set and execute it. Name
        the result `data_lat_long_times`
    3.  validate (with code) that `latitude, longitude,` and `times` are
        the key of the `data_lat_long_times` data set.

6.  Why is `data_lat_long_times` not in 2nd normal form? Find at least
    two problems with split keys.

7.  Address the split key problems by separating the
    `data_lat_long_times` data set into three:

    1.  pick suitable names for each of the three data sets and specify
        which variables should go into each.
    2.  write the code to split the `data_lat_long_times` data into
        three data sets.
    3.  discuss if the three data sets are in 2nd normal form.

8.  The choice of using `latitude` and `longitude` as part of the key is
    potentially problematic. Discuss why and suggest a solution.

## Submission

Make sure that your file `index.qmd` includes all details to make your
answers fully reproducible. Ensure that the file renders properly. Add
all relevant(!) files to the repository, commit, and push!
