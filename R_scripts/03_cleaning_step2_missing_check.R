library(vroom)
library(dplyr)
library(lubridate)

all_trips <- vroom::vroom("data_clean/all_trips_2024.csv", delim = ",", col_types = cols(.default = col_character()))

# حاول قراءة الأعمدة بعدة تنسيقات
all_trips <- all_trips %>%
  mutate(
    started_at = parse_date_time(started_at, orders = c("Ymd HMS", "Y-m-d H:M:S", "m/d/Y H:M", "m/d/Y H:M:S")),
    ended_at   = parse_date_time(ended_at, orders = c("Ymd HMS", "Y-m-d H:M:S", "m/d/Y H:M", "m/d/Y H:M:S"))
  ) %>%
  mutate(
    ride_length = as.numeric(difftime(ended_at, started_at, units = "mins"))
  )

cat("✅ Dates parsed successfully and ride_length calculated!\n")
cat("Rows and Columns:\n")
print(dim(all_trips))
cat("\nSample Preview:\n")
print(head(all_trips, 3))