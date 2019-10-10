# Setup

Set working directory: 

```r
setwd('C:/Users/cbett/Dropbox/Everything/Journal/Academics/GWSB-MSBA/2019-S3-Fall/Programming-For-Analytics/w07-midterm')
```

Packages:

```r
library(dplyr)
library(tidyr)
library(ggplot2)
library(GGally)
library(forecast)
library(stringr)
```

Data:

```r
df <- read.csv("path_or_url")
str(df)
glimpse(df)
head(df)
names(df)
summary(df)
```


# Data Wrangling

|       Action       |                            Commands                             |
| ------------------ | --------------------------------------------------------------- |
| Filter rows        | filter, distinct, sample_frac, sample_n, slice, top_n, top_frac |
| Select columns     | select                                                          |
| Add/change columns | mutate, transmute                                               |
| Sort rows          | arrange                                                         |
| Summarise          | group_by(df) %>% summarise()                                    |
| Wide -> Long       | gather                                                          |
| Long -> Wide       | spread                                                          |
| Concatenate        | unite                                                           |
| Un-Concatenate     | separate                                                        |

Matrix-like referencing:

```r
df[1,2]   # first row, 2nd col
df[1,]    # first fow, all col
df[,2]    # all rows, 2nd col
df[1,1:2] # first row, cols 1-2
```

Split strings into letters or sub strings:

```r
strsplit(input, '') # separates string into letters
```


# Loops

```r
for (i in 1:10) {
    #do something
}

if (condition is true) {
    #do something
} else {        # more cases: `else if ()`
    #do something else
}

while (condition is true) { #example: i < 20
    #do something           #example: i <- i + 1
}
```


# Functions

```r
function_name <- function(input_arguments) {
    #do something
    return(new_variable)
}
```

Recursive example:
```r
recursive.factorial <- function(x) {
if (x == 0) {
    return (1)
} else {
    return (x * recursive.factorial(x-1))
}
```


# Plots

General:

```r
ggplot(df, aes()) +
    xlab('label') + ylab('label') + ggtitle('title') +
    xlim(0,10) + ylim(0,10) +
    theme_light()
```

Histogram:

```r
ggplot(df, aes(x=x_variable)) +
    geom_histogram()
```

Scatter plot:

```r
ggplot(df, aes(x=x_variable, y=y_variable),color=color_variable) +
    geom_point() +
    geom_smooth(method=lm)
```

Box plot:

```r
ggplot(df, aes(x=x_variable, y=y_variable) +
    geom_boxplot()
```

Bar plot:

```r
ggplot(df, aes(x=dimension_variable, fill=measure_variable) +
    geom_bar(stat='identity')
```

Cross tab of counts:

```r
table(var1,var2)
```

Facets:

```r
plotVar + facet_grid(.~var1)    # columns based on var1
plotVar + facet_grid(var2~.)    # rows based on var2
plotVar + facet_grid(var1~var2) # rows & cols

```

# Readline

```r
userInput <- readline("UserPrompt")
```

# Regression

Logistic regression (binary outcome):

```r
df.glm <- glm(outcome~predictor, data=df, family='binomial')
predict(df.glm, newdata, type='response')
```

Multiple Logistic Regression:

```r
df.glm <- glm(outcome~predictor1+predictor2, data=df, family='binomial')

df.glm <- glm(outcome~., data=df, family='binomial') #all vars as predictors
```

Linear Regression (continuous outcome)

```r
df.lm <- lm(outcome~predictors, data=df)
```

Model / variables review:

```r
summary(df.modelname)
summary(df.modelname)$coefficients
plot(df.modelname)
cor(df$var1, df$var2)
GGally::ggpairs(df)
```


# Shiny

## Shiny UI
*name file ui.r*

```r
library(shiny)
library(markdown)  # needed if using shinyapps.io

shinyUI(fluidPage(
    titlePanel("Title"),

    sidebarLayout(
        sidebarPanel(
            fileInput('fileInputName', label='userInstructions', accept=c('text/csv','text/comma-separated-values,text/plain', '.csv')),
            
            radioButtons('choiceInputName', label='userInstructions', choices=c('visible1'='code1','visible2'='code2'), selected='code1'),

            br()  # whitespace

            # actionButton("goButton", "Go!") # for non-reactive apps
        ),

        # Tabbed:
        mainPanel(
                  tabsetPanel(#type='tabs',
                      tabPanel('Data Table',tableOutput('dataTable')),
                      tabPanel('Plot',plotOutput('dataPlot')),
                      tabPanel('About',includeMarkdown('about.md'))  # no corresponding server.ui code. Store md in same directory as ui.r.
                  )
        )

        ## Untabbed:
        # mainPanel(
        #     tableOutput('dataTable')
        # )
        
    )
))
```


## Shiny Server
*name file server.r*

```r
library(shiny)
library(ggplot2)
library(dplyr)

shinyServer(function(input, output) {
    
    output$dataTable <- renderTable({
        
        # ETL:
        d_input = input$fileInputName
        dataPath = d_input$datapath[1]
        if (!is.null(dataPath)) {
            
            # Load:
            d_full = read.csv(dataPath)
            d_full = tbl_df(d_full)

            # Transform (optional):
            filter1 <- input$choiceInputName
            d <- filter(d_full, filterVar==filter1)
        } else {}
        
        # Render:
        print(d) #normal R code here
    })

    output$dataPlot <- renderPlot({
        
        # ETL:
        d_input = input$fileInputName
        dataPath = d_input$datapath[1]
        if (!is.null(dataPath)) {
            
            # Load:
            d_full = read.csv(dataPath)
            d_full = tbl_df(d_full)

            # Transform (optional):
            filter1 <- input$choiceInputName
            d <- filter(d_full, filterVar==filter1)
        } else {}
        
        # Render:
        ggplot(d, aes(x=xVar, y=yVar)) + geom_histogram() #normal R code here
    })
})

# To make output non-reactive:
#
# shinyServer(function(input, output) {
#   output$myplot <- renderPlot({
#     input$goButton
#    
#     isolate({
#       # everything else inside renderPlot
#    })
#   })
# })
```

## Shiny Publishing

Put .zip containing server.r and ui.r in a public git repo, then:

```r
library(shiny) + runGitHub('project-name','repo-owner',subdir='folder-path-not-file',ref='master')
```

# Time Series Forecasting

```r
library(forecast)
decompose(df)$figure  # seasonally adjusted values
```


# Matrix Stuff

```r
m <- matrix(data, ncol, nrows)
```