# https://r4ds.hadley.nz/data-transform.html

library(nycflights13)
library(tidyverse)

# 4.2
flights |> 
  filter(dep_delay > 240)

flights |> 
  filter(month >= 4 & month <= 6)
flights |>
  filter(month %in% c(4, 5, 6))


flights |>
  arrange(dep_delay)
flights |> 
  arrange(desc(dep_delay))
# flights |>
#   arrange(desc(dep_delay)) |>
#   select(year:day, dep_delay) |>
#   mutate(dep_delay_h = dep_delay / 60) |>
#   rename(dep_delay_min = dep_delay) 

flights |>
  distinct()
flights |>
  distinct(carrier)
flights |>
  distinct(carrier, .keep_all = TRUE)

flights |>
  count(carrier)
flights |>
  count(carrier, sort = TRUE)

# Exercises

flights |>
  filter(
    dep_delay > 120,
    dest == "IAH" | dest == "HOU",
    carrier %in% c("UA", "DL"),
    month %in% c(7, 8, 9)
    )

flights |>
  filter(
    dep_delay == 0 & arr_delay > 120
  ) |>
  select(year:day, dep_delay, arr_delay)

flights |>
  filter(
   dep_delay >= 60,
   dep_delay - arr_delay > 30
  ) |>
  select(year:day, dep_delay, arr_delay) |>
  arrange(desc(dep_delay - arr_delay)) |>
  mutate(made_up_during_flight_min = dep_delay - arr_delay)

flights |>
  arrange(desc(dep_delay)) |>
  select(year:arr_time)
flights |>
  arrange(distance / air_time) |>
  mutate(speed_miles_per_min = distance / air_time) |>
  select(year:day, air_time, speed_miles_per_min)

flights |>
  distinct(month, day)

flights |>
  arrange(distance) |>
  select(flight, distance) |>
  rename(flight_num = flight) |>
  distinct()
flights |>
  arrange(desc(distance)) |>
  select(flight, distance) |>
  rename(flight_num = flight) |>
  distinct()


# 4.3 COlumns

flights |>
  mutate(
    gain = dep_delay - arr_delay, 
    speed = distance / air_time * 60,
    .before = 1
  )
flights |>
  mutate(
    gain = dep_delay - arr_delay, 
    speed = distance / air_time * 60,
    .after = day
  )
flights |>
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60,
    .keep = "used"
  )


flights |>
  select(year, month, day)
flights |>
  select(year:day)
flights |>
  select(!year:day)
flights |>
  select(where(is.character))
flights |>
  select(last_col())
flights |>
  select(starts_with("dep"))
flights |>
  select(contains("_"))

flights |>
  select(Year = year, Month = month, Day = day)


flights |>
  rename(Year = year, Month = month, Day = day)
# For multiple columns with bad names: 
library(janitor)
clean_names(flights)


flights |>
  relocate(time_hour, air_time)
flights |>
  relocate(time_hour, air_time, .after = day)

# Exercise 

flights |>
  select(dep_time_h = dep_time, sched_dep_time_h = sched_dep_time, dep_delay_min = dep_delay) |>
  mutate(dep_time_min = floor(dep_time_h / 100) * 60 + dep_time_h %% 100, .after = dep_time_h) |>
  mutate(sched_dep_time_min = floor(sched_dep_time_h / 100) * 60 + sched_dep_time_h %% 100, .after = sched_dep_time_h) |>
  ggplot(aes(x = dep_time_min - sched_dep_time_min , y = dep_delay_min)) + 
  geom_point() + 
  labs(
    x = "Calculated delay",
    y = "Tibble delay"
  )
flights |>
  select(time_hour, origin, dest, dep_time_h = dep_time, sched_dep_time_h = sched_dep_time, dep_delay_min = dep_delay) |>
  mutate(dep_time_min = floor(dep_time_h / 100) * 60 + dep_time_h %% 100, .after = dep_time_h) |>
  mutate(sched_dep_time_min = floor(sched_dep_time_h / 100) * 60 + sched_dep_time_h %% 100, .after = sched_dep_time_h) |>
  mutate(dep_delay_calc = dep_time_min - sched_dep_time_min) |>
  filter(dep_delay_calc != dep_delay_min)

flights |>
  select(
    dep_time, 
    dep_delay, 
    arr_time, 
    arr_delay
    )
flights |>
  select(
    contains("dep_") | contains("arr_")
  ) |>
  select(
    !contains("sched")
  )

flights |>
  select(dep_time)
flights |>
  select(dep_time, dep_time)

variables = c("year", "month", "day", "dep_delay", "arr_delay")
flights |>
  select(
    any_of(variables)
  )

flights |>
  select(
    contains("TIME")
  )
flights |>
  select(
    contains("TIME", ignore.case = FALSE)
  )

flights |>
  rename(air_time_min = air_time)


# 4.5

flights |>
  group_by(month) |>
  summarize(
    avg_delay_min = mean(dep_delay, na.rm = TRUE),
    n = n()
    )
# flights |>
#   ggplot(aes(x = month, y = dep_delay, group = month)) +
#   geom_boxplot()

flights |>
  slice_head(n = 1)
flights |>
  slice_tail(n = 1)
flights |>
  slice_min(dep_delay, n = 5)
flights |>
  slice_max(dep_delay, n = 5)
flights |>
  slice_sample(n = 1)

flights |>
  group_by(month) |>
  slice_max(dep_delay, n = 1) |>
  relocate(dep_delay)

flights |>
  slice_max(dep_delay, prop = 0.01)

flights |>
  group_by(month, day) |>
  summarize(count = n()) 

flights |>
  group_by(month, day) |>
  summarize(avg_del = mean(dep_delay, na.rm = TRUE))
flights |>
  group_by(month, day) |>
  summarize(avg_del = mean(dep_delay, na.rm = TRUE)) |>
  ungroup() |>
  summarize(avg_del = mean(avg_del))
flights |>
  summarize(avg_del = mean(dep_delay, na.rm = TRUE))

#Exercises

flights |>
  group_by(carrier) |>
  summarize(avg_delay = mean(dep_delay, na.rm = TRUE)) |>
  arrange(desc(avg_delay))
# ******************FOLLOWING IS BASED ON 
# http://varianceexplained.org/r/empirical_bayes_baseball/
### Copy Pasta Code:
estBetaParams <- function(mu, var) {
  alpha <- ((1 - mu) / var - 1 / mu) * mu ^ 2
  beta <- alpha * (1 / mu - 1)
  return(params = list(alpha = alpha, beta = beta))
}
### Copy Pasta Code Ende
# Reduce flights tibble to the important features
# Also, turn delayed into a boolean so that I can use it similiar to the hitting rate in the article
test = flights |>
  group_by(carrier, dest) |>
  mutate(delayed = dep_delay > 0) |>
  summarize(
    n = n(),
    delayed = sum(delayed, na.rm = TRUE),
    delayed_rate = delayed / n
  ) |>
  ungroup() |>
  filter(n > 10) |>
  arrange(desc(delayed_rate)) 
test
# Given the data, use the copy pasta function to fit the beta distribution
beta_distribution_estimates = estBetaParams(mean(test$delayed_rate), var(test$delayed_rate))
# Show fit
test |>
  ggplot(aes(x = delayed_rate)) +
  geom_histogram(binwidth = 0.01) + 
  stat_function(fun = function(x) dbeta(x, beta_distribution_estimates$alpha, beta_distribution_estimates$beta), 
                color = "red",
                size = 1) + 
  labs(
    x = "Delayed rate",
    y = "Counts",
    title = "Histrogram with fitted beta distribution",
    subtitle = "Not a good fit but sufficient to play around with",
    caption = "Note: Only considered carrier and destination combinations with n > 100"
  )
# Update delayed rate based on delays
test |>
  mutate(
    posterior_delayed_rate = (delayed + beta_distribution_estimates$alpha) /  (n + beta_distribution_estimates$beta + beta_distribution_estimates$alpha )
    ) |>
  arrange(desc(posterior_delayed_rate))

flights |>
  group_by(dest) |>
  summarize(max_dep_delay = max(dep_delay, na.rm = TRUE)) |>
  arrange(desc(max_dep_delay))

flights |>
  mutate(delayed = dep_delay > 0) |>
  group_by(hour) |>
  summarize(
    n = n(),
    total_delayed = sum(delayed, na.rm = TRUE),
    frac_delayed = sum(delayed, na.rm = TRUE) / n()
    ) |>
  arrange(desc(total_delayed))
#Plot 
# Relative
flights |>
  mutate(delayed = dep_delay > 0) |>
  ggplot(aes(x = hour)) +
  geom_bar(position = "fill", aes(fill = delayed)) + 
  labs(y = "Rel. frequency")
# Absolute
flights |>
  mutate(delayed = dep_delay > 0) |>
  ggplot(aes(x = hour)) + 
  geom_bar(aes(fill = delayed))
# Use cut to differentiate among the possible degrees of delay;
# i.e. differentiate between the number of delayed minutes not just delayed or not
flights |>
  mutate(
    delayed = dep_delay > 0, .before = 1,
    delay_degree = cut(
      dep_delay,
      breaks = c(-Inf, 0, 5, 10, 30, 60, Inf),
      labels = c("on_time", "0<x<5min", "5<x<10min", "10<x<30min", "30<x<60min", ">60min")
    )
         ) |>
  ggplot(aes(x = hour)) + 
  geom_bar(aes(fill = delay_degree))
  
flights |>
  slice_head(n = -336775)
flights |>
  slice_head(n = 1)

flights |>
  slice_max(dep_delay, n = 1)
flights |>
  slice_max(dep_delay, n = -336775)

flights |>
  group_by(origin, dest) |>
  count(sort = TRUE)
flights |>
  count(origin, dest, sort = TRUE)

df <- tibble(
  x = 1:5,
  y = c("a", "b", "a", "a", "b"),
  z = c("K", "K", "L", "L", "K")
)
df |>
  group_by(y)
df |>
  arrange(y)
df |>
  group_by(y) |>
  summarize(mean_x = mean(x))
df |>
  group_by(y, z) |>
  summarize(mean_x = mean(x))
df |>
  group_by(y, z) |>
  summarize(mean_x = mean(x), .groups = "keep") |>
  summarize(overall_mean_x = mean(mean_x), .groups = "drop")
df |>
  group_by(y, z) |>
  summarize(mean_x = mean(x))
df |>
  group_by(y, z) |>
  mutate(mean_x = mean(x))

Lahman::Batting |>
  group_by(playerID) |>
  summarize(
    performance = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE),
    n = sum(AB, na.rm = TRUE)
  ) |>
  filter(n > 100) |>
  ggplot(aes(x = n, y = performance)) +
  geom_point(alpha = 0.1) +
  geom_smooth(se = FALSE) 
