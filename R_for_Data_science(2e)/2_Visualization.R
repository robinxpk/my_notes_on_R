library(tidyverse)
library(palmerpenguins)
library(ggthemes)

# Book: https://r4ds.hadley.nz/data-visualize.html

penguins = palmerpenguins::penguins
glimpse(penguins)
penguins

# 2.2

ggplot(data = penguins, mapping = aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(mapping = aes(color = species, shape = species)) + 
  geom_smooth(method = "lm") + 
  labs(
    title = "Body mass and flipper length",
    subtitle = "Dimensions for Adelie, Chinstrap and Gentoo",
    x = "Flipper length (mm)",
    y = "Body mass (g)",
    color = "Species", shape = "Species"
  ) + 
  scale_color_colorblind()

# Exercises:

dim(penguins)
?penguins

ggplot(penguins, aes(x = bill_length_mm, y = bill_depth_mm)) + 
  geom_point(aes(color = species, shape = species)) + 
  labs(
    title = "Bill depth and length",
    subtitle = "Dimensions for Adeilie, Chinstrap and Gentoo",
    y = "Bill depth (mm)",
    x = "Bill length (mm)", 
    color = "Species", shape = "Species"
  )

# This is not a good plot because there is one categorical variable. 
# Barplot would make more sense here!!
ggplot(penguins, aes(x = bill_depth_mm, y = species)) + 
  geom_point(aes(color = species))

# na.rm = remove NAs
ggplot(penguins, aes(x = bill_length_mm, y = bill_depth_mm)) + 
  geom_point( na.rm = T, aes(color = species, shape = species))

ggplot(penguins, aes(x = bill_length_mm, y = bill_depth_mm)) + 
  geom_point(aes(color = species, shape = species)) + 
  labs(
    title = "Bill depth and length",
    subtitle = "Dimensions for Adeilie, Chinstrap and Gentoo",
    caption = "This is a caption. It is a title of brief explanation accompanying an illustration.",
    y = "Bill depth (mm)",
    x = "Bill length (mm)", 
    color = "Species", shape = "Species"
  )

ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g, color = bill_depth_mm)) +
  geom_point() + 
  geom_smooth(method = "loess")


# 2.4

ggplot(penguins, aes(x = fct_infreq(species))) +
  geom_bar() + 
  labs(
    title = "Barplot for species", 
    subtitle = "Use Barplots in case of categorical data",
    x = "Species"
    )

ggplot(penguins, aes(x = body_mass_g)) + 
  geom_histogram(binwidth = 200) +
  labs(
    title = "Histogram for body mass (g)",
    subtitle = "Use histogram in case of numerical data",
    x = "Body mass (g)"
  )

ggplot(penguins, aes(x = body_mass_g)) + 
  geom_density()

# Excercises

ggplot(penguins, aes(y = fct_infreq(species))) + 
  geom_bar() + 
  labs(
    y = "Species"
  )

ggplot(penguins, aes(x = fct_infreq(species))) + 
  geom_bar(color = "red")

ggplot(penguins, aes(x = fct_infreq(species))) + 
  geom_bar(fill = "red")

ggplot(diamonds, aes(x = carat)) + 
  geom_histogram(binwidth = 0.01)

# 2.5

# Visualize relationship: Numerical and categorical
ggplot(penguins, aes(x = species, y = body_mass_g)) + 
  geom_boxplot() + 
  labs(
    title = "Relation body mass (g) and species",
    subtitle = "Use boxplots to examine/visualize the relationship between a numerical and a categorical variable", 
    x = "Species", 
    y = "Body mass (g)"
  )
ggplot(penguins, aes(x = body_mass_g, color = species, fill = species)) + 
  geom_density(linewidth = 1, alpha = 0.5) + 
  labs(
    title = "Densities of body mass (g) by species",
    subtitle = "Alternative to boxploxts",
    x = "Body mass (g)",
    y = "Density"
  )

# Visualize relationship: Both categorical
ggplot(penguins, aes(x = island, fill = species)) + 
  geom_bar() + 
  labs(
    title = "Stacked frequency barplots island and species",
    subtitle = "Use stacked barplots to visualize the relationship between two categorical variables",
    x = "Island",
    y = "Count",
    fill = "Species"
  )

ggplot(penguins, aes(x = island, fill = species)) + 
  geom_bar(position = "fill") + 
  labs(
    title = "Stacked rel. frequency barplots island and species",
    y = "Rel. frequency", 
    x = "Island"
  )

# Bisualize relationship: Both numerical
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) + 
  geom_point(aes(color = species, shape = island)) + 
  labs(
    title = "Body mass (g) vs. flipper length (mm)",
    subtitle = "Adding too many variables is confusing; use facets!",
    x = "Flipper length (mm)",
    y = "Body mass (g)",
    color = "Species", 
    shape = "Island"
  )

ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) + 
  geom_point(aes(color = species)) + 
  facet_wrap(~island) + 
  labs(
    title = "Body mass (g) vs. flipper length (mm) by island and species",    
    x = "Flipper length (mm)",
    y = "Body mass (g)",
    color = "Species"
  )

# Exercises

?mpg
glimpse(mpg)

ggplot(mpg, aes(x = displ, y = hwy, color = cyl, size = cyl, linewidth = cyl)) + 
  geom_point() + 
  labs(
    title = "Miles per gallon vs engine display (liters)",
    x = "Engine displacement (liters)",
    y = "Highway miles per gallon",
    color = "Cylinder", size = "Cylinder"
  ) + 
  facet_wrap(~year)

ggplot(penguins, aes(x = island, fill = species)) +
  geom_bar(position = "fill") + 
  labs(y = "Rel. frequency")
ggplot(penguins, aes(x = species, fill = island)) +
  geom_bar(position = "fill") + 
  labs(y = "Rel. frequency")

# 2.6

ggsave(
  width = 10,
  height = 8,
  filename = "visualize_relationship_categorical_variables.png",
  path = "C:\\Users\\robin\\Desktop\\Desktop\\R\\R for Data Science"
  )
?ggsave
