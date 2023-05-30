# First Step
`rm(list = ls())`

# libraries
- `install.packages("name")`
- `library(name)`

# Linear Model `lm(formula, data, ...)`

### Syntax
Simple linear regression\
`lm(y ~ x, data = data)`

Fit on all variables\
`lm(y ~ ., data)`

Fit lm onto all variable except certain others
1. update an instance of a lm fit onto all variables:
`update(lm.fit, ~ . - var1 - var2)`
where
`lm.fit = lm(y ~ ., data = data)`
2. `lm.fit = lm(y ~ . - var1 - var2, data = data)`

### Informations
With `lm.fit = lm(y ~ ., data = data)`:
- `summary(lm.fit)`; `?summary(lm.fit)` bzw. `?summary.lm`
- `names(lm.fit)` returns attribute
- `coef(lm.fit)` returns coefficients
- `confint(lm.fit)` returns confidence interval
- `predict(lm.fit)` for confidence and prediction intervals; see p. 113 
- `plot(lm.fit)` creates 4 diagnostics plot; iterate through them by `cntrl + enter` or adjust number of displayed plots\
(Adjust number of plots:
`par(mfrow = c(rows, columns))` Matrix of displayed plots)
- `residuals(lm.fit)`
- `rstudent(lm.fit)` studentized residuals
- `hatvalues(lm.fit)` gives leverage statistic; p.99; but more general: Hatmatrix
- `vif(lm.fit)`REQUIRES to load the `car`-library; variance inflation function p.102

### Interaction terms
1. `var1:var2` denotes an interaction term between var1 and var2: `lm(y ~ var1 + var2 + var1:var2, data = data)`
2. another way to implement a `lm` with an interaction term: `lm(y ~ var1 * var2, data = data)`
		concludes to `lm(y ~ var1 + var2 + var1:var2, data = data)`
    
### The `I()`-function
Use `I`(capital i) as in `I((z-1)^2)` in the `lm()` function to instruct R to interprete `-`, `^` as the arithmetic operators\
Otherwise:
- `-` means to leave out the named variable
- `^` concludes to an interaction term; e.g.: x^2 = x * x = x + x + x:x

### The `poly(var, n, raw)`-function
For polynomial of higher order, it may be convenient to use the poly-function\
e.g.: `lm(y ~ poly(x, order, raw = TRUE), data = data)` is equivalent to: `y ~ x + I(x^2) + I(x^3) + I(x^4) + I(x^5)`\
This function will use the variable to build a polynomial of degree n\
`Note:`By default, the `poly`-function orthogonalizes the predictors. That is, x^1, ..., x^n are orthogonalized! 
Thus, the polynom is **not** just a sequence of powers of the variable. Therefore it is **not** "raw" linear regression:
While the fitted values are the **same**, the coefficients as well as standard errors and p-values differ from "raw" linear regression
To obtain the `raw` regression estimates, use `poly(..., raw = TRUE)`


### Comparing two model's fit with `anova()`
`anova(model1, model2)`\
Note: ANOVA may always be interpreted as comparison of two **nested** models; e.g.:
1. model<sub>1</sub> = b<sub>0</sub>
2. model<sub>2</sub> = b<sub>0</sub> + dummy<sub>0</sub> * x<sub>1</sub>

Under the null, the models fit the data equally well; i.e.: dummy = 0\
Otherwise, models<sub>2</sub> describes the data better because there is a significant difference (on average) between the considered groups\
Output:
> Analysis of Variance Table\
\
Model 1: medv ~ lstat\
Model 2: medv ~ lstat + I(lstat^2)\
  Res.Df &emsp;   RSS &emsp;     Df &emsp;    Sum of Sq &emsp;      F &emsp;        Pr(>F)    \
1    504 &emsp;   19472  &emsp;                                 \
2    503 &emsp;    15347 &emsp;   1 &emsp;     4125.1 &emsp;         135.2 &emsp;    < 2.2e-16 ***\
Signif. codes:  0 ‘\*\*\*’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Interpretation:\
H<sub>0</sub>: dummy = 0 / same average / both models fit data equally well **--> use parsimonious model**\
H<sub>1</sub>: More complex model is superior **--> low p-value: more complex model is reasonably better**

### `plot()`
`par(mfrow = c(rows, columns))` Matrix of displayed plots

### Miscellaneous
- `max()` returns max value 
- `which.max()` returns index of max value
- `attach(data_frame)` The database is attached to the R search path. This means that the database is searched by R when evaluating a variable, so objects in the database can be accessed by simply giving their names.
- `contrasts(var_name)` returns the coding that R uses for the dummy variables

Example:\
`library(ISLR2)`\
`attach(Carseats)`\
`contrasts(ShelveLoc)`\

Output:
>&emsp;&emsp;&emsp; Good&emsp; Medium\
Bad&emsp;&emsp;&emsp;       0&emsp;      0\
Good&emsp;&emsp;      1&emsp;      0\
Medium&emsp;    0&emsp;      1
