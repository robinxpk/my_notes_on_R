# p. 110ff

library(MASS)
library(ISLR2)
library(ggplot2)
library(car) # vif-function is part of this package (vif = variance inflation functio p.102n)

boston = ISLR2::Boston
head(boston)

# *univariate* linear regression medv onto lstat
# medv = "median value of owner-occupied homes in $1000s"
# lstat = "lower status of the population (percent)"
ggplot(boston, aes(x = lstat, y = medv)) +
  geom_point() +
  geom_smooth(method = "lm", se = F)
# store the linear fit into a variable
fit = lm(medv ~ lstat, boston)
# display content of fit
fit
summary(fit)
# show attributes of fit
names(fit)
# confidene interval for the parameters
confint(fit)
# predict gives confidence as well as prediction intervals for (conditional) average / predicted values
# prediction intervals are broader because they also account for the random error (epsilon): f(x) + \epsilon
values_for_lstat = c(5, 10, 15)
predict(fit, 
        data.frame(lstat = values_for_lstat),
        interval = "confidence"
        )
predict(fit,
        data.frame(lstat = values_for_lstat),
        interval = "predict"
        )
# # plot in book:
# plot(x = boston$lstat, y = boston$medv, col = "red")
# abline(fit, lwd = 3)
# diagnostics:
# plot() creates multiple diagnostic plots when the argument is lm()-output
# plot(fit)
# split screen to display multiple plots
par(mfrow = c(2, 2))
plot(fit)
# calculate residuals
residuals(fit)
matrix(residuals(fit))
matrix(boston$medv) - matrix(predict(fit))
plot(x = predict(fit), y = residuals(fit))
# studentized residuals 
rstudent(fit)
plot(predict(fit), rstudent(fit))
par(mfrow = (c(1, 1)))
# leverage statistics
hatvalues(fit)
plot(hatvalues(fit))
max(hatvalues(fit))
which.max(hatvalues(fit)) # index of highest value

# *multivariate* linear regression
rm(list = ls())
boston = ISLR2::Boston
# medv onto lstat and age
# age = "proportion of owner-occupied units built prior to 1940"
ggplot(boston, aes(y = medv, x = lstat)) +
  geom_point()
ggplot(boston, aes(y = medv, x = age)) + 
  geom_point()
# library(plotly)
# plot_ly(x=boston$lstat, y=boston$age, z=boston$medv, type="scatter3d", mode="markers")
# fit model
lm.fit = lm(medv ~ lstat + age, data = boston)
lm.fit
summary(lm.fit)
# lm with  all variables
lm.allvar = lm(medv ~ ., data = boston)
lm.allvar
summary(lm.allvar)
# see names(summary(lm) or ?summary.lm for attributes)
# use vif-function (variable inflation function; p.102)
vif(lm.allvar)
max(vif(lm.allvar))
which.max(vif(lm.allvar))
# remove certain variables
# update existing lm
lm.multi_fit = update(lm.allvar, ~ . - tax - nox - age)
lm.multi_fit
which.max(vif(lm.multi_fit))
# create new lm
lm.multi_fit = lm(medv ~ . -  tax - nox - age, data = boston)

# Interaction term
# An interaction term between two variables is: var1:var2
lm.inter = lm(medv ~ lstat + age + lstat:age, data = boston) #long
lm.inter = lm(medv ~ lstat * age, data = boston) #short
summary(lm.inter)

# Non-linear transformations
lm.quad = lm(medv ~ lstat + I(lstat^2), data = boston)
summary(lm.quad)
ggplot(boston, aes(x = lstat, y = medv)) + 
  geom_point() +
  geom_smooth(method = "lm", 
              formula = y ~ x + I(x^2)
  )
par(mfrow = c(2, 2))
plot(lm.quad)
par(mfrow = c(1, 1))
# For higher polynomial, one can use the poly-function:
lm.poly5 = lm(medv ~ poly(lstat, 5), data = boston)
summary(lm.poly5)
ggplot(boston, aes(x = lstat, y = medv)) +
  geom_point() + 
  geom_smooth(method = "lm",
              formula = y ~ poly(x, 5, raw = TRUE)
              )
# Compare poly(..., raw= TRUE / FALSE)
lm.poly5
lm(medv ~ poly(lstat, 5, raw =TRUE), data = boston)
ggplot(boston, aes(y = medv, x = lstat)) +
  geom_point() + 
  geom_smooth(method = "lm", formula = y ~ poly(x, 5, raw = TRUE)) 
  # geom_smooth(method = "lm", formula = y ~ poly(x, 5)) 
ggplot(boston, aes(y = medv, x = lstat)) +
  geom_point() + 
  geom_smooth(method = "lm", formula = y ~ log(x))
# Comparing model fit using anova():
lm.uni = lm(medv ~ lstat, data = boston)
anova(lm.uni, lm.quad)
anova(lm.quad, lm.poly5)
anova(
  lm.poly5, 
  lm(medv ~ poly(lstat, 10), data = boston)
  )

# Qualitative predictors
rm(list = ls())
head(Carseats)
summary(Carseats)
names(Carseats)
lm.fit = lm(Sales ~ . + Income:Advertising + Price:Age, data = Carseats)
summary(lm.fit)
attach(Carseats)
contrasts(ShelveLoc)

# Writing functions:
LoadLibraries = function() {
  library(ISLR2)
  library(MASS)
  print("Libraries have been loaded")
}
LoadLibraries
LoadLibraries()
