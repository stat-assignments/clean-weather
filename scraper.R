# reads data from forecast.weather.gov and returns a data object
require(xml2)
require(dplyr)
require(purrr)

get_forecast <- function(latitude, longitude) {
  url <- sprintf("https://forecast.weather.gov/MapClick.php?lat=%f&lon=%f&FcstType=digitalDWML", latitude, longitude)
  # Read XML
  xml_data <- read_xml(url)
  write_xml(xml_data, file = "download.xml")
  all_params <- xml_find_all(xml_data, ".//parameters/*")

  parameters <- all_params %>% xml_name()

  units_df <- data.frame(
    parameter = xml_name(all_params),
    type = xml_attr(all_params, "type"),
    units = xml_attr(all_params, "units")
  )
  units_df <- filter(units_df, !is.na(type))
  # extract times
  times <- xml_text(xml_find_all(xml_data, ".//time-layout//start-valid-time"))

  # extract all observations in a list object:
  get_param_type <- function(param, type) {
    search_string <- sprintf(".//%s[@type='%s']//value", param, type)
    value <- xml_text(xml_find_all(xml_data, search_string))
    value
  }

  observations <- units_df |> mutate(
    values = purrr::map2(.x = parameter, .y = type, get_param_type)
  )
  observations <- observations |> tidyr::unnest(values)
  observations$times <- rep(times, nrow(units_df))


  observations$latitude <- gsub(".*lat=([^&]*).*", "\\1", url)
  observations$longitude <- gsub(".*lon=([^&]*).*", "\\1", url)

  # weather conditions
  weather <- xml_find_all(xml_data, ".//weather-conditions")

#  observations <- observations |> mutate(
  conditions = weather |> map(.f = function(x) {
      type = xml_attr(xml_children(x), attr = "weather-type")
      probability = xml_attr(xml_children(x), attr = "coverage")
      dframe <- data.frame(type, probability)
      if (nrow(dframe) == 0) return("")
   #   browser()
      with(dframe, sprintf("%s (%s)", type, probability)) |> paste(collapse = "; ")
    })
#  )
  observations$conditions <- rep(unlist(conditions), nrow(units_df))

  production <- xml_data |> xml_find_all(".//source/*") |> xml_text()
  observations$source <- production[1]


  observations
}
