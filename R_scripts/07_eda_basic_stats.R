library(vroom)
library(dplyr)
library(lubridate)

# تحميل البيانات الجاهزة للتحليل
all_trips <- vroom::vroom("data_clean/all_trips_features.csv", delim = ",", col_types = cols(.default = col_character()))

# تحويل بعض الأعمدة
all_trips <- all_trips %>%
  mutate(
    ride_length_min = as.numeric(ride_length_min),
    start_month_label = factor(start_month_label, levels = month.abb),
    day_of_week = factor(day_of_week, levels = c("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"))
  )

cat("✅ Data ready for EDA!\n")

# 1️⃣ إجمالي عدد الرحلات حسب نوع المستخدم
total_rides <- all_trips %>%
  count(member_casual, name = "total_rides")

# 2️⃣ متوسط مدة الرحلة بالدقايق لكل نوع مستخدم
avg_ride_length <- all_trips %>%
  group_by(member_casual) %>%
  summarise(
    avg_ride_length_min = mean(ride_length_min, na.rm = TRUE),
    median_ride_length_min = median(ride_length_min, na.rm = TRUE)
  )

# 3️⃣ دمج النتائج مع بعض
summary_basic <- left_join(total_rides, avg_ride_length, by = "member_casual")

cat("\n--- Basic EDA Summary ---\n")
print(summary_basic)

# حفظ النتائج كملف CSV صغير
vroom::vroom_write(summary_basic, "data_clean/eda_summary_basic.csv", delim = ",")

cat("\n💾 Saved EDA summary to data_clean/eda_summary_basic.csv\n")