library(vroom)
library(dplyr)
library(lubridate)

all_trips <- vroom::vroom("data_clean/all_trips_2024.csv", delim = ",", col_types = cols(.default = col_character()))

all_trips <- all_trips %>%
  mutate(
    started_at = ymd_hms(started_at, quiet = TRUE),
    ended_at = ymd_hms(ended_at, quiet = TRUE),
    ride_length = difftime(ended_at, started_at, units = "mins"),
    ride_length = as.numeric(ride_length)
  )

cat("✅ File loaded and key columns converted successfully!\n")
cat("Rows and Columns:\n")
print(dim(all_trips))
cat("\nSample Preview:\n")
print(head(all_trips, 3))