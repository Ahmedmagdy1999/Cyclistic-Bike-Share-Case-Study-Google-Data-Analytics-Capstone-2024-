# R
# scripts/01_merge_files.R
# Purpose: Combine all monthly CSV files (data_raw) into one CSV (data_clean/all_trips_2024.csv)

# --- 0. (Optional) set working directory to project root if needed ---
# setwd("C:/path/to/your/cyclistic_project")   # ضع مسار مشروعك لو لم تفتح المشروع في RStudio

# --- 1. Load libraries (install once if necessary) ---
if (!requireNamespace("vroom", quietly = TRUE)) install.packages("vroom")
if (!requireNamespace("dplyr", quietly = TRUE)) install.packages("dplyr")
library(vroom)
library(dplyr)

# --- 2. Ensure folders exist for outputs ---
if (!dir.exists("data_clean")) dir.create("data_clean", recursive = TRUE)

# --- 3. Define the folder that contains the 12 CSV files ---
data_folder <- "data_raw"

# --- 4. List CSV files (full paths) ---
all_files <- list.files(path = data_folder, pattern = "\\.csv$", full.names = TRUE)
cat("Found", length(all_files), "CSV files in", data_folder, "\n")

# --- 5. Quick guard: if no files found, stop with message ---
if (length(all_files) == 0) stop("No CSV files found in data_raw. Please check the folder path.")

# --- 6. Read and bind rows efficiently using vroom + bind_rows ---
# We read them into a list of tibbles then stack them.
list_of_dfs <- lapply(all_files, vroom::vroom, col_types = cols(.default = col_character()))
# Note: read as characters now to avoid parsing issues; we'll parse datetimes later in cleaning step.

all_trips <- bind_rows(list_of_dfs)

# --- 7. Print basic info to console for inspection ---
cat("Combined dataset dimensions (rows, cols):\n")
print(dim(all_trips))    # dim = c(rows, cols)
cat("\nColumn names:\n")
print(colnames(all_trips))
cat("\nFirst 3 rows (raw preview):\n")
print(head(all_trips, 3))

# --- 8. Save combined CSV (as UTF-8) ---
output_file <- "data_clean/all_trips_2024.csv"
vroom::vroom_write(all_trips, output_file, delim = ",")

cat("\n✅ Saved combined file to:", output_file, "\n")