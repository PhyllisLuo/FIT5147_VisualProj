#   ____________________________________________________________________________
#   UI                                                                      ####

library(shiny)
library(plotly)
library(shinyjs)
library(shinyBS)

source("appParts.R")
source("readData.R")


shinyUI(navbarPage(title = "Rental Properties near Monash Uni",
                   theme = "style/style.css",
                   fluid = TRUE, 
                   collapsible = TRUE,
                   
                   # ----------------------------------
                   # tab panel 1 - Home
                   tabPanel("Home",
                            includeHTML("home.html"),
                            tags$script(src = "plugins/scripts.js"),
                            tags$head(
                              tags$link(rel = "stylesheet", 
                                        type = "text/css", 
                                        href = "plugins/font-awesome-4.7.0/css/font-awesome.min.css")
                              # ,
                              # # tags$link(rel = "icon", 
                              # #           type = "image/png", 
                              # #           href = "images/logo_icon.png")
                            )
                   ),
                   
                   # ----------------------------------
                   # tab panel 2 - Neighborhood Browser
                   tabPanel("Know about VIC",
                            KnowaboutVIC()
                   ),
                   
                   # ----------------------------------
                   # tab panel 3 - Location Comparison
                   tabPanel("Rental properties near Campus",
                            Property()
                   ),
                   
                   # ----------------------------------
                   # tab panel 4 - About
                   tabPanel("About",
                            About(),
                            shinyjs::useShinyjs(),
                            tags$head(
                              tags$link(rel = "stylesheet", 
                                        type = "text/css", 
                                        href = "plugins/carousel.css"),
                              tags$script(src = "plugins/holder.js")
                            ),
                            tags$style(type="text/css",
                                       ".shiny-output-error { visibility: hidden; }",
                                       ".shiny-output-error:before { visibility: hidden; }"
                            )
                   )
                   
))