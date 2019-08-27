# Guides / Resources
[SW Carpentry tutorial](https://swcarpentry.github.io/r-novice-gapminder/)
[DataExplorer](https://cran.r-project.org/web/packages/DataExplorer/vignettes/dataexplorer-intro.html)


# Setup

Packages:
```r
install.packages("devtools")
install.packages("dplyr")
install.packages("tidyr")
install.packages("GGally")    # ggplot2 extension. especially for modeling
install.packages("ProjectTemplate")
install_github("StatsWithR/statsr")
```

Libraries:
```r
library(devtools)
library(plyr)
library(dplyr)
library(tidyr)
library(utils)
library(ggplot2)
library(knitr)
library(GGally)
library(shiny)
library(ProjectTemplate)
library(statsr)
```

Download and load data:
```r
load ("somefile.RData")
download.file("https://raw.githubusercontent.com/swcarpentry/r-novice-gapminder/gh-pages/_episodes_rmd/data/gapminder_data.csv", destfile = "data/gapminder_data.csv")
dataframename <- read.csv("data/gapminder_data.csv")
```

Load functions into session from a source file:
IDEA: use roxygen2 and testthat packages to document and test functions
```r
source("functions/functions-lesson.R")
```

# Data Frame Exploration
Data structure and sample:
```r
dim(gapminder)
str(gapminder)
head(gapminder, n=10)
tail(gapminder, n=10)
gapminder[sample(nrow(gapminder),5),]
tbl_df(gapminder)
glimpse(gapminder)
View(gapminder)
```

Variable distribution:
```r
summary(gapminder)
```

# Data Wrangling
Filter columns:
```r
gapminder_pop <- select(gapminder, country, year, pop, continent)

gapminder_lifeExp <- select(gapminder, -pop, -gdp, -gdpPercap, -gdp_millions)
```

Filter rows:
```r
filter(gapminder, country=='China')

seAsia <- c("Myanmar","Thailand","Cambodia","Vietnam","Laos")
filter(gapminder, country %in% seAsia)
```

Add column:
```r mutate
gapminder <- mutate(gapminder, gdp=gdpPercap * pop)
gapminder$gdp_millions <- gapminder$gdp / 1e6
```

Sort:
```r
arrange(gapminder, year, country)
```

Group by and perform operation:
```r
group_by(gapminder, year) %>% summarise(sum(pop), sum(gdp))


ddply(                          # dd (dataframe in, dataframe out) ply
 .data = calcGDP(gapminder),
 .variables = "continent",      # split criteria
 .fun = function(x) mean(x$gdp)
)
```

Cross tab:
```r
daply(                          # da (dataframe in, array out) ply
 .data = calcGDP(gapminder),
 .variables = c("continent", "year"),
 .fun = function(x) mean(x$gdp)
)

# Alternative:
with(mydf, table(sex,grp))
```

Convert wide to long with gather:
```r
gap_long <- gap_wide %>%
    gather( obstype_year,               # name for new key column
            obs_values,                 # name for new value column
            starts_with('pop'),         # columns to turn in to keys
            starts_with('lifeExp'), 
            starts_with('gdpPercap'))   # Column identification supports `-` to exclude and use all other
str(gap_long)
```

Convert long to wide with unite and spread:
```r
gap_wide_new <- gap_long %>%
    unite(ID_var,continent,country,sep="_") %>%
    unite(var_names,obs_type,year,sep="_") %>%
    spread(var_names,obs_values)
```


Separate a concatenated colunn:
```r
gap_long <- gap_long %>% separate(obstype_year,into=c('obs_type','year'),sep="_")
gap_long$year <- as.integer(gap_long$year)
```

Convert numbers to factors:

```r
grp_fac <- factor(grp, levels = c(1,2,3),  labels = c('Red','Blue','Green')) 
```

Create dataframe from vectors:
```r
sal <- c(1000, 1200, 1345, 1234)
fcst <- c(1200, 1300, 1300, 1200)
df <- data.frame(sales = sal, forecast = fcst)
```

# User Defined Functions (UDF)
Convert f to kelvin:
```r
fahr_to_kelvin <- function(temp) {
  stopifnot(is.numeric(temp))   # stop if ANY condition is false
  kelvin <- ((temp - 32) * (5 / 9)) + 273.15
  return(kelvin)
}
```

Calculate metric from a data frame:
```r
# Takes a dataset and multiplies the population column with the GDP per capita column.
# Note: arguments can take vectors or single values
calcGDP <- function(dat, year=NULL, country=NULL) {
  if(!is.null(year)) {  # if argument is provided, then run code
    dat <- dat[dat$year %in% year, ]
  }
  if (!is.null(country)) {
    dat <- dat[dat$country %in% country,]
  }
  gdp <- dat$pop * dat$gdpPercap
  new <- cbind(dat, gdp=gdp)
  return(new)
}
```

Access like a matrix:
```r
gapminder[1,2]  # first row, 2nd col
gapminder[1,]   # first fow, all col
gapminder[,2]   # all rows, 2nd col
gapmider[1,1:2] # first row, cols 1-2
```

# Loops

For loop:
```r
for (y in x) {
  print(y)
} 
```




# Resampling
Simple random sample:
```r
n <- 60
samp <- sample_n(ames, n)
```
Resample with replacement and calculate statistic:
```r sample_stat_with_replacement
sample_means15 <- ames %>%
    rep_sample_n(size=15, reps=2000, replace=TRUE) %>%
    summarise(x_bar=mean(price))
```

# Summary Statistics
Distribution of continuous variable:
```r
summary(nc$gained)
```

Customized summary statistics:
```r
sample_means15 %>%
    summarise(
        count=n(),
        mean = mean(x_bar), 
        sd = sd(x_bar), 
        min = min(x_bar), 
        q1 = quantile(x_bar, 0.25),
        med = median(x_bar), 
        q3 = quantile(x_bar, 0.75),
        max = max(x_bar),
        iqr = IQR(x_bar)
        )
```

Calculate proportion satisfying a condition:
```r
brfss2013 %>%
  group_by(flushot6) %>%
  summarise(total_count=n(), never_sick_rate=sum(never_sick == TRUE, na.rm=TRUE) / total_count)
```

# Inference
Set critical value:
```r 
z_star_95 <- qnorm(0.975)
z_star_95
```

Confidence interval:
```r
samp %>%
  summarise(lower = mean(area) - z_star_95 * (sd(area) / sqrt(n)),
            upper = mean(area) + z_star_95 * (sd(area) / sqrt(n)))
```

Hypothesis test (various):
```r hypothesis_test, tidy=FALSE
inference(y = weight, x = habit, data = nc, statistic = "mean", type = "ht", null = 0, 
          alternative = "twosided", method = "theoretical", conf_level=0.95)
```

Confidence interval for difference in means:
```r confidence_interval_difference_in_means, tidy=FALSE
inference(y = weight, x = habit, data = nc, statistic = "mean", type = "ci", 
          method = "theoretical", order = c("smoker","nonsmoker"), conf_level=0.95)
```

Confidence interval for difference in proportions:
```r
n1 <- 273
n2 <- 171
p1_hat <- .238
p2_hat <- .304
z_star <- qnorm(.975)

point_estimate <- p2_hat - p1_hat
standard_error <- sqrt( p1_hat*(1-p1_hat)/n1 +
                        p2_hat*(1-p2_hat)/n2 )
margin_of_error <- z_star * standard_error

#CI Lower Bound
point_estimate - margin_of_error
#CI Upper Bound
point_estimate + margin_of_error
```

Hypothesis test for difference in proportions:
```r
n1 <- 273
n2 <- 171
p1_hat <- .238
p2_hat <- .304

point_estimate <- p2_hat - p1_hat
pooled_proportion <- (n1*p1_hat + n2*p2_hat) / (n1 + n2)
standard_error <- sqrt( pooled_proportion*(1-pooled_proportion)/n1 +
                        pooled_proportion*(1-pooled_proportion)/n2 )
z_score <- point_estimate / standard_error

2*(1-pnorm(z_score))        # for 2-tailed test
```

# Plots
Histogram:
```r 
ggplot(data=sample_means15, aes(x=x_bar)) +
    geom_histogram(binwidth=5000)
```

Scatterplot:
```r
ggplot(mlb11, aes(x=explanatory_data,y=response_data)) +
  geom_point()
```

Box plot:
```r 
ggplot(nycflights, aes(x = factor(month), y = dep_delay)) +
    geom_boxplot()
```

Bar plot:
```r 
ggplot(data = nycflights, aes(x = origin, fill = dep_type)) +
  geom_bar()
```

Trend lines:
```r
polviews_vs_natenvir_by_year <- gss %>%
  filter(!is.na(polviews_2),!is.na(natenvir)) %>%
  group_by(polviews_2, year) %>%
  summarise(total_count=n(), too_much_natenvir_spending_rate=sum(natenvir=='Too Much') / total_count) 
ggplot(data=polviews_vs_natenvir_by_year, aes(x=year, y=too_much_natenvir_spending_rate, color=polviews_2)) +
  geom_line() +
  scale_color_manual(values = c('red','blue','black'), limits=c('Conservative','Liberal','Moderate')) +
  theme_minimal()
```

Confidence interval plot:
```r
ggplot(data = ci_data, aes(
  x = ci_bounds, y = ci_id, 
  group = ci_id, color = capture_mu)) +
  geom_point(size = 2) +
  geom_line() +
  geom_vline(xintercept = params$mu, color = "darkgray") # draw vertical line
```

# Publishing / Exporting

Exporting Result as a PNG:
```r
lifeExp_plot <- ggplot(data = az.countries, mapping = aes(x = year, y = lifeExp, color=continent)) +
  geom_line() + facet_wrap( ~ country) +
  labs(
    x = "Year",              # x axis title
    y = "Life expectancy",   # y axis title
    title = "Figure 1",      # main title of figure
    color = "Continent"      # title of legend
  ) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

ggsave(filename = "results/lifeExp.png", plot = lifeExp_plot, width = 12, height = 10, dpi = 300, units = "cm")
```

Save plots as a PDF (similar commands for other formats)
```r
pdf("results/Life_Exp_vs_time.pdf", width = 12, height = 4)
p <- ggplot(data = gapminder, aes(x = year, y = lifeExp, colour = country)) +
  geom_line() +
  theme(legend.position = "none")
p
p + facet_grid(. ~continent)
dev.off()
```

Write data to CSV:
```r
write.table(
  gapminder[gapminder$country == "Australia",],
  file="cleaned-data/gapminder-aus.csv",
  sep=",", quote=FALSE, row.names=FALSE
)
```


# Linear Regression
Correlation coefficient:
```r
sometable %>%
  summarise(cor(response_data, explanatory_data))
```

All correlation pairs:
```r
numerical_columns <- c("var1", "var2", "var3")
ggpairs(dataname, columns = numerical_columns, columnLabels = c("var1", "var2", "var3"))
```

Create linear model:
```r
m1 <- lm(response_data ~ explanatory_data, data = sometable)

summary(m1)
```

Scatter plot with best fit line:
```r
ggplot(data = sometable, aes(x = explanatory_data, y = response_data)) +
  geom_point() +
  stat_smooth(method = "lm", se = FALSE)
```

Residuals plot:
```r
ggplot(data = some_model, aes(x = .fitted, y = .resid)) +
  geom_point() +
  geom_hline(yintercept = 0, linetype = "dashed") +
  xlab("Fitted values") +
  ylab("Residuals")
```

Residuals histogram:
```r
ggplot(data = some_model, aes(x = .resid)) +
  geom_histogram() +
  xlab("Residuals")
```

Residuals normal probability plot (QQ):
```r
ggplot(data = m1, aes(sample = .resid)) +
  stat_qq()
```

Multiple Linear Regression (MLR):
```r
pov_mlr = lm(poverty ~ female_house + white, data=states)
summary(pov_mlr)
anova(pov_lmr)
```

MLR Diagnostics:
```r
plot(modelname$residuals ~ dataname$variablename) #want to see random scatter around 0 (means linearity). variablename is a predictor.
hist(modelname$residuals)                         #want to see normal distribution
qqnorm(modelname$residuals)                       #want to see normal distribution
qqline(modelname$residuals)                       # ^
plot(modelname$residuals ~ modelname$fitted)      #want to see constant variability, not fan shape
plot(abs(modelname$residuals) ~ modelname$fitted) #want to see constant variability, not triangle shape
plot(modelname$residuals)                         #want to see no pattern tied to sample or time order
```

MLR Correlations:
```r
#correlation of 2 variables:
dataname %>% 
  summarise(cor(var1name, var2name))

#correlation of many variable pairs:
ggpairs(dataname, columns = 13:19)
```

MLR Prediction:
```r
newdatapoint <- data.frame(var1 = "male", var2 = 3)
predict(modelname, newdatapoint, interval = "prediction", level = 0.95)
```

Print a specific model output:
```r
print(paste("Adjusted R²: ", summary(modelname)$adj.r.squared))
```