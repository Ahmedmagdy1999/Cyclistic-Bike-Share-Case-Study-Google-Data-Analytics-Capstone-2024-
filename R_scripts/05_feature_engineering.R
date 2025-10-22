library(vroom)
library(dplyr)
library(lubridate)

all_trips <- vroom::vroom("data_clean/all_trips_cleaned.csv", delim = ",", col_types = cols(.default = col_character()))

all_trips <- all_trips %>%
  mutate(
    started_at = ymd_hms(started_at, quiet = TRUE),
    ended_at   = ymd_hms(ended_at, quiet = TRUE),
    ride_length_min = as.numeric(ride_length),
    start_date = as_date(started_at),
    start_year = year(started_at),
    start_month = month(started_at),
    start_month_label = month(started_at, label = TRUE, abbr = TRUE),
    start_day = day(started_at),
    start_hour = hour(started_at),
    day_of_week = wday(started_at, label = TRUE, abbr = TRUE),
    weekday_or_weekend = if_else(wday(started_at) %in% c(1,7), "weekend", "weekday"),
    season = case_when(
      month(started_at) %in% c(12, 1, 2) ~ "Winter",
      month(started_at) %in% c(3, 4, 5) ~ "Spring",
      month(started_at) %in% c(6, 7, 8) ~ "Summer",
      month(started_at) %in% c(9, 10, 11) ~ "Fall",
      TRUE ~ "Unknown"
    )
  )

cat("✅ Derived columns created successfully!\n")
print(head(all_trips, 3))

vroom::vroom_write(all_trips, "data_clean/all_trips_features.csv", delim = ",")
cat("\n💾 Saved enriched dataset to data_clean/all_trips_features.csv\n")