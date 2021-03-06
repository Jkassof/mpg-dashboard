library(shiny);library(shinydashboard) ; library(ISLR) 
require(rCharts); library(dplyr)
data(Auto)
auto <- tbl_df(Auto)
auto <- auto %>% filter(cylinders>3) %>%
     mutate(Origin = as.factor(ifelse(origin == 1, "American", ifelse(origin == 2, "European", "Japanese")))) %>%
     rename(      MPG = mpg,
                  Cylinders = cylinders,
                  Displacement = displacement,
                  Horsepower = horsepower,
                  Weight = weight,
                  Acceleration = acceleration,
                  Year = year) %>%
     select(-origin, -name)
header <- dashboardHeader(title = "Cars Data Visualization")
homebody <- "Today we are going to be looking at some visual and numerical analysis of the fuel efficiency of
various motor vehicles made from 1970-1982.  The data set we are using can be found for free in the R package
ISLR. There are 392 different observations across the 12 years. Check out the chart below to explore the general
relationship between Weight and MPG of a vehicle. The cylinders found in the engine are color coded. If you click
the circle next to 'Magnify' you will be able to zoom in on the chart by hovering your mouse over the area of interest
. Clearly there is generally a negative relationship betwen weigh and MPG. We can also see that overall, the less cylinders 
car has, the lighter and more fuel efficient it is. By zooming in on the border areas between differeny cylinders, we can see that
there is some overlap. Interesting! This chart is from the very impressive R library rCharts.
Check out the other tabs for truly interactive graphics!"

#########################################################

sidebar <- dashboardSidebar(
     sidebarMenu(
          menuItem("Home", tabName = "Home", icon = icon("home")),
          menuItem("Weight", tabName = "Weight", icon = icon("bar-chart")),
          menuItem("Custom", tabName = "Custom", icon = icon("area-chart"))
     )
)

#######################################################

body <- dashboardBody(
     tabItems(
          tabItem(tabName = "Home",
                  h2("Introduction"),
                  br(),
                  p(homebody),
                  br(),
                  showOutput("myChart", "nvd3")
                  ),
          
          tabItem(tabName = "Weight",
                  h2("Plot of Weight vs MPG, Engine Type Color Coded"), br(),
                  p("By sliding the Year slider bar below around and clicking Submit, you are able to change what year of vehicles
                    you are seeing plotted. I have added trendlines for each type of engine. As we can see, the three engines appear
                    to have relatively varied profiles in fuel efficiency. It is apparent that there is a general increase in 
                    fuel efficiency over this timeframe, look at year 1970, then switch to 1982."),
                  fluidRow(column(12, offset = 3, align = 'center', box(
                       title = "Year", status = "primary", solidHeader = TRUE,
                       sliderInput("Year", label = "Year", min = 70, max = 82, step = 1, value = 70),
                       submitButton("Submit New Year")
                       ))),
                  fluidRow(column(12, align = "center", plotOutput('WeightMPGPlot', width = "70%")))
                  ),
          
          tabItem(tabName = "Custom",
                  h2("Fully-Customizable Graphing"), br(),
                  p("Pick from any variables for the X and Y axis as well as select your own color coded factor variable. Be warned
                    that not all the possible plots below are necessarily meaningful. I hope you are enjoying using this customizable
                    data product. The interactivity of this makes Shiny an incredible tool for data scientists. There are limitless
                    applications of a quickly deployed interactive dashboard! Enjoy!"),
                  box(
                         selectInput("X", label = "X-Axis", 
                                  choices = names(auto), selected = "Weight"),
                         selectInput("Y", label = "Y-Axis", 
                                  choices = names(auto), selected ="MPG")),
                  box(
                         selectInput("Factor", label = "Factor", 
                                  choices = c("Cylinders", "Year", "Origin")), 
                         submitButton("Submit Changes")),
                  br(), br(), br(),
                  fluidRow(column(12, align = "center", plotOutput('linechart', width ="70%")))
                  )
          
          ))

ui <- dashboardPage(header,sidebar,body)