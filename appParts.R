#   ____________________________________________________________________________
#   Know about VIC                                                          ####

KnowaboutVIC <- function() {
    tagList(
        div(class = "container",
            h1("Know about Victoria", class = "title fit-h1"),
            h3("Know about Local Government Areas(LGAs) in VIC"),
            p("Victoria consists of 79 local government areas (LGAs). Monash University Clayton Campus is located in Monash. 13 LGAs (highlighted in deep blue) reached a radius of 15 km from Clayton Campus Center."),
            p("Put mouse on the map or zoom in/out to learn the LGA name, select a LGA to get the LGA's introduction."),
            fluidRow(
                column(6,
                       offset = 1,
                       selectizeInput("lga1", "Select a Local Government Area",
                                      choices = c(unique(population_lga$`LGA name`)),
                                      multiple = FALSE, selected = "Monash (C)"
                                      )
                       )
                ),
            plotlyOutput(outputId = "maplga", width = "100%", height = "400"),
            hr(),
            h3("Introduction about LGA"),
            p("Learn about the brief introduction about selected LGA, know about the area, density, population and age distribution."),
            fluidRow(
                column(7,
                       htmlOutput("kable", width = "100%", height = "400")
                       ),
                column(5,
                       plotlyOutput(outputId = "age", width = "100%", height = "400")
                       )
                )
            )
        )
}


#   ____________________________________________________________________________
#   Rental Property                                                         ####

Property <- function(){
    tagList(
        div(class = "container",
            h1("Properties near Monash Clayton Campus", class = "title fit-h1"),
            h3("The quantity of rental properties"),
            p("select one or several LGA(s) to learn about quantity and price of the rental properties in the area(s)."),
            fluidRow(
                column(6,
                offset = 1,
                # also possible to use plotly here
                selectizeInput("lga2", "Select Local Government Area(s)",
                               choices = c(unique(rental_prop$LGAname)),
                               multiple = TRUE, selected = "Monash (C)")
                )
                ),
            fluidRow(
                column(8,
                       plotlyOutput(outputId = "qty", width = "100%", height = "500")
                       ),
                column(4,
                       plotlyOutput(outputId = "map15km", width = "80%", height = "300")
                       )
                ),
            hr(),
            h3("Prices of rental properties"),
            p("Learn about the average price of property, average price per room and quantity in selected on or several LGA(s) by different property type and number of rooms."),
            plotlyOutput(outputId = "price", width = "100%", height = "400"),
            hr(),
            h3("Rental property data"),
            p("Below list detail information of rental properties in each LGA."),
            DT::dataTableOutput("dt", width = "100%")
            )
    )
}

#   ____________________________________________________________________________
#   About                                                                   ####

About <- function(){
    tagList(
        div(class = "container",
            h1("Data Source and creator", class = "title fit-h1"),
            h3("Data source"),
            p("- Digital boundary files from",
              a(href = "https://www.abs.gov.au/statistics/standards/australian-statistical-geography-standard-asgs-edition-3/jul2021-jun2026/access-and-downloads/digital-boundary-files",
                "Australian Bureau of Statistics")),
            p("- Population estimates by age, by selected geographies, 2020 from",
              a(href = "https://www.abs.gov.au/statistics/people/population/regional-population-age-and-sex/latest-release#data-download",
                "Australian Bureau of Statistics")),
            p("- Rental property data scraped from",
              a(href = "https://www.domain.com.au/?mode=rent",
                "www.domain.com.au")),
            p("- Victoria LGA introduction collected from",
              a(href = "https://en.wikipedia.org/wiki/Wiki",
                "Wikipedia")),
            hr(),
            p("The app is created by Yu Luo, student ID: 32361351"),
            p("E-mail: yluo0065@student.monash.edu")
            
        )
    )
}
