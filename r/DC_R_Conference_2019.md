# DC R Conference 2019

Full topics & speakers:
https://dc.rstats.ai/agenda/

Slides: will be added to the site above in several weeks, after the site rebuild

DC Data Community email list:  http://www.datacommunitydc.org/


## Friday Highlights

### R cloud and Google
packages:
- googleAnalyticsR: Google analytics api access
- ggmap: maps layer for ggplots
- rcurl: curl for web scraping. (trick for correcting spelling using Google search) 

### pagedown

Presentation: bit.ly/TynerDCR19

package allows you to create paged html documents that look like PDFs and print nicely. handles LaTeX well. cannot knit normally, need a web server, see slides for example. 

disadvantages: immature, strict templates, fiddly with zoom, harder to customize than writing normal CSS or using a word doc, LaTeX is more widely used in many fields

see 2019 NYC R conference for package that converts between RMD and Word (useful for track changes and collaboration). 


### optimizing topic models for classification tasks

textmineR package + classification model e. g. random forest + **SigOpt to tune model parameters**. SigOpt has R api. 

in-q-tel invests in SigOpt developer. Has data science internships. 


### Funnel Join

tidy grammar of funnels in R, e.g. web ecommerce step conversion rates, or last page viewed before coming to product page, or advertisement attribution logic. 

on github, not CRAN. in development for 1.5 years. https://github.com/robinsones/funneljoin

https://hookedondata.org/about/

https://www.manning.com/books/build-a-career-in-data-science?a_aid=buildcareer&a_bid=76784b6a


### Raising Baby with R

use pipe() inside read_csv() to pre-clean with Linux commands, e. g. grep to skip section dividers

tsibble package (sic) for the series analysis

index_by() like group by for time series

fable.prophet to find regime changes in a time series


### R and Python/Pandas in the same environment

make pipeline with dot notation 

reticulate package to run python in r

parsnip library for SVM algorithms in python 

sklearn library for many modeling tools in python

access python variables inside r chunk with `py$`.  `r.` for the opposite

things they didn't teach you about r:
https://rstats.wtf/

don't mix conda environment with R (?) 

### managing your cloud: working with APIs

packages: httr, curl (don't use rcurl) , jsonlite (converts between json and lists)

 
### dashboarding

examples and templates :
https://github.com/maloriejhughes

rmd + flexdashboard instead of hdml output. use presenter's suggested defaults 

library printr() improves default print() function

summarytools library is WIP and has some good presentation features, stay tuned for plot-in-table support 

stargazer for summarizing model outputs 

DT library, datatable() improves interactive data views. and audience can download your data 

highcharter for interactive plots. similar grammar to ggplot.  makes Tableau - style plots. 

leaflets library for map plotting

### NetworkD3 and R to visualize relationships 

interactive network diagrams (example: twitter topics). find nodes with max betweenness (e. g. terrorist network key person).  identify communities. 


### Coursedown: automating course delivery and management

Slides package:  `xaringan`

Course ntoes: `bookdown`

Formatting links from variables:  `glue()`

Students upload homework assignments via Dropbox link.  Retrieve files with Dropbox Python API.

Send feedback to students:  `gmailr`

Workflow manager:  `drake`

github.com/webbedfeet/coursedown

### Plot Animation

https://github.com/skirmer/animating_dataviz
www.stephaniekirmer.com
twitter.com/data_stephanie

Reasons to animate:
- I have 4 or more meaningful dimensions
- I want to display many levels of a single dimension

Packages: ggplot2, gganimate, gifski

Example:  Race plots. Frame is the basic bar chart for a given year.  State is the year.  Animation moves through each value of state.  code regular ggplot, add 1 line for animation.


### ggplot2 enhancements and tricks

funny explanation of competing Python visualization options:
https://dsaber.com/2016/10/02/a-dramatic-tour-through-pythons-data-visualization-landscape-including-ggplot-and-altair/

`sf` package: beautiful bivariate maps easily.  Don't have to read in shape files.

`ggtext` package: pass markdown formatting to text on plots.  bold, color, etc.  Can also pass images to ggplot text objects e.g. to the axis labels.

`gghighlight` package: color logic based on filters.  e.g. color top 5 lines ranked by some variable.

`annotate_custom` package: overlay one chart on another.  E.g. map plot of counties for continuous variable, plus histogram summarizing distribution.  Can also create 'magnifying glass' effect to show zoomed-in region laid over a full map plot.

`facet_geo` to show facet graphs organized based on spatial position.  E.g. state-by-state plots arranged by the spatial position of the state.

`ray_shader` to rotate contour plots or 3d maps with shadows



### Citation Networks

`stringr` package with regex to extract citations from document (e.g. tweets, emails, academic papers).

store relationships as edge lists.  relationship matrices are not scalable.

visualize with gephi (not part of R).

Analyze the graph:
- visual: look for clusters and isolates.
- quantitatively: identify central nodes.  Use igraphy, tidygraph, and statnet packages.
- model network statistically.  like logistic regression to predict relationship between two nodes, but not quite because of interdependence across nodes.  ERGM package instead.

## Saturday Highlights

### Topic Modeling Consumer Complaints at the Federal Reserve & CFPB

https://github.com/bjbloom

Goal: measure trends in most common consumer complaints

Key packages packages: textmineR, stm.  Also in stack: tidytext, quanteda, udpipes, textreuse, text2vec, SnowballC, textrank, tm (tm is not recommended)

Approach:
- tidytext for filtering and building doc-term matrix
- textmineR to fit multiple LDA models at different values of K
- purrr and ggplot2 to review diagnostics and decide best LDA model

### Spatial Analysis

packages: rgdal, rgeos, Sp, Spatstat, Kernlab

Plotly or Tableau for presentations due to dynamic zoom.


### 10 Tidyverse Tricks

Speaker:  
- http://varianceexplained.org/about/
- https://github.com/dgrtwo

TidyTuesday Project:  https://thomasmock.netlify.com/post/tidytuesday-a-weekly-social-data-project-in-r/

Tips:

- count() has sort, weight, and name arguments
- count() argument can create variables (I missed this one?)
- add_count() for one-line count of groups.  add filter(n>...) for quick top-n summary
- summarize() can create lists. Use case: list all scores for each grouping in order to run a t-test using these scores
- count() + fct_reorder() + geom_col() + coord_flip() to create a sorted bar chart with easy-to-read category labels
- fct_lump() to combine least-common levels of a factor into an 'other' level
- scale_x / y_log10() because logs of real world data is log-normally distributed
- crossing() to make cross-tabs.  input vectors, output every combination of vectors
- separate() to un-concatenate column into several columns.  Supports regex.
- extract() to pull out substring from string.  Supports regex. Can convert data types within function.



### Spatial Data

bit.ly/dc-spatial-2019

Put parentheses around variable assignment also outputs a print, e.g. `(df <- read_excel('filename.xlsx'))`

Academic libraries sometimes have GIS services to batch-convert locations (e.g. addresses) to coordinates.

Common data types: .shp, .geojson (common for web-based apps), .gpkg (new and good, not common yet), .csv, .tiff (for raster data)

`library(sf) st(filename)' to ingest many common formats

Googling stuff:  boundaries, shapefile, polygons, geometries, file extensions

Packages: sf (like tidyr, dplyr, readr), tmap (like ggplot2 but has interactive zoom/pan), spdep (like glmnet), sp (like data.table)

RGeoda alpha available now for R Studio



### DevOps - how to deploy your Shiny App inside your organization

Use shinyloadtest (to performance test) and profvis (to find cause of slow code) to verify shiny app is production-ready.  Don't annoy IT with unscalable apps.


### Visualizing the Environmental Impact of Beef Consumption using Plotly and Shiny

(author's note: oops, I stopped taking notes at this point, anyways here are the headings so you can decide if you want to review the presentations on your own)

### Creating arcosr (DEA drug distribution data)


### RBERT for NLP


### Defense Analysis


### Renewables, Reproucibility, and RMarkdown


### Metric Design and Dashboarding with tidymetrics and shinybones


