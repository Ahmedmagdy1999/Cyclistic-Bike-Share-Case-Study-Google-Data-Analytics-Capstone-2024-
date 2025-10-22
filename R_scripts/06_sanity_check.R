# R
library(vroom)
library(dplyr)
library(lubridate)

# تحميل الملف النهائي
all_trips <- vroom::vroom("data_clean/all_trips_features.csv", delim = ",", col_types = cols(.default = col_character()))

# نحول الأعمدة الزمنية لتواريخ حقيقية (في حالة القراءة كـ نص)
all_trips <- all_trips %>%
  mutate(
    started_at = ymd_hms(started_at, quiet = TRUE),
    ended_at = ymd_hms(ended_at, quiet = TRUE),
    ride_length_min = as.numeric(ride_length_min),
    start_year = as.numeric(start_year),
    start_month = as.numeric(start_month),
    start_day = as.numeric(start_day),
    start_hour = as.numeric(start_hour)
  )

cat("✅ Data loaded successfully for sanity checks!\n")

# 1️⃣ تأكد من عدد الأعمدة وعدد الصفوف
cat("\n--- Basic Structure ---\n")
print(dim(all_trips))
print(colnames(all_trips))

# 2️⃣ تأكد إن مافيش شهور أو أيام ناقصة
cat("\n--- Check unique months ---\n")
print(sort(unique(all_trips$start_month)))

cat("\n--- Check unique years ---\n")
print(sort(unique(all_trips$start_year)))

# 3️⃣ تأكد من القيم الغريبة في نوع المستخدم
cat("\n--- Check member_casual values ---\n")
print(table(all_trips$member_casual, useNA = "ifany"))

# 4️⃣ تأكد من التوزيع العام للرحلات
cat("\n--- Trip count by user type ---\n")
print(all_trips %>% count(member_casual))

cat("\n--- Average ride length by user type (mins) ---\n")
print(all_trips %>%
        group_by(member_casual) %>%
        summarise(mean_length = mean(ride_length_min, na.rm = TRUE)))

# 5️⃣ تأكد إن مافيش ride_length سالب أو أكبر من يوم
cat("\n--- Invalid ride lengths ---\n")
print(sum(all_trips$ride_length_min <= 0 | all_trips$ride_length_min > 1440, na.rm = TRUE))

cat("\n✅ Sanity checks complete!\n")