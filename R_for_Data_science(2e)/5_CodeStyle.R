# https://r4ds.hadley.nz/workflow-style.html
# Tidyverse Style Guide:


# Automatically generated -------------------------------------------------
# -> press: Strg + Shift + R


# Navigation test ---------------------------------------------------------

# Sections can reduced to one line (see small arrow in corresponding line)
# Sections can be jumped to by using the panel on the bottom of the source code window


# 5.6 Exercises -----------------------------------------------------------
library(tidyverse)
library(nycflights13)

flights |>
  filter(
    dest=="IAH"
    ) |>
  group_by(year, month, day) |>
  summarize(
    n = n(),
    delay = mean(arr_delay, na.rm = TRUE)
    ) |>
  filter( n > 10)

flights |>
  filter(
    carrier == "UA",
    dest %in% c("IAH","HOU"),
    sched_dep_time > 900,
    sched_arr_time < 2000
    )|>
  group_by(flight) |>
  summarize(
    delay = mean(arr_delay, na.rm = TRUE),
    cancelled = sum(is.na(arr_delay)), 
    n = n()
    )|>
  filter( n > 10)

