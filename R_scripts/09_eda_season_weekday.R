# R
library(vroom)
library(dplyr)
library(lubridate)

# تحميل البيانات النهائية للتحليل
all_trips <- vroom::vroom("data_clean/all_trips_features.csv", delim = ",", col_types = cols(.default = col_character()))

# تجهيز الأعمدة
all_trips <- all_trips %>%
  mutate(
    ride_length_min = as.numeric(ride_length_min),
    season = as.factor(season),
    weekday_or_weekend = as.factor(weekday_or_weekend)
  )

cat("✅ Data ready for season & weekday analysis!\n")

# 1️⃣ عدد الرحلات حسب الموسم
rides_by_season <- all_trips %>%
  group_by(member_casual, season) %>%
  summarise(total_rides = n(),
            avg_ride_length = mean(ride_length_min, na.rm = TRUE),
            .groups = "drop")

# 2️⃣ عدد الرحلات حسب نوع اليوم (Weekday / Weekend)
rides_by_daytype <- all_trips %>%
  group_by(member_casual, weekday_or_weekend) %>%
  summarise(total_rides = n(),
            avg_ride_length = mean(ride_length_min, na.rm = TRUE),
            .groups = "drop")

# طباعة النتائج
cat("\n--- Rides by Season ---\n")
print(rides_by_season)

cat("\n--- Rides by Day Type ---\n")
print(rides_by_daytype)

# حفظ النتائج للـ Tableau
vroom::vroom_write(rides_by_season, "data_clean/eda_rides_by_season.csv", delim = ",")
vroom::vroom_write(rides_by_daytype, "data_clean/eda_rides_by_daytype.csv", delim = ",")

cat("\n💾 Saved seasonal and day-type summaries successfully!\n")