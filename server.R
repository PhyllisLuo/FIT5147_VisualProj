#   ____________________________________________________________________________
#   Server                                                                  ####

library(shiny)
library(tidyverse)
library(readxl)
library(sf)
library(leaflet)
library(ggthemes)
library(geosphere)
library(plotly)
library(DT)
library(kableExtra)

shinyServer(function(input, output) {
    
 #####--------------Tab2--------------#####
    # -------------Filtered Data------------- #
    # Filter - LGA - Age
    age_filter <- reactive({
        data1 <- population_lga %>% 
            filter(`LGA name` == input$lga1)
        
        data1
    })
    
    # Filter - LGA - Map
    lga_filter1 <- reactive({
      data2 <- vic_lga_name %>% 
        filter(`LGA name` == input$lga1)
      
      data2
    })
    
    # Filter - LGA - Intro
    lga_intro <- reactive({
        data3 <- intro_lga %>% 
            filter(`Local Government Area` == input$lga1) 
        data3
    })
    
      
    # -------------Output------------- #
    #Tab2 - Map
    output$maplga <- renderPlotly({
        p_map <- vic_lga %>% 
            ggplot(aes(text = paste("LGA:", NAME))) +
            geom_sf(fill = "lightblue2", colour = "white") + 
            geom_sf(data = vic_lga_15km,
                    fill = "steelblue", colour = "white") +
            geom_sf(data = lga_filter1(),
                    fill = "lightsalmon", colour = "white") +
            geom_point(x = 145.133957, y = -37.907803, 
                       color = "red", size = 0.8)
        
        ggplotly(p_map)
    })
    
    #Tab2 - Kable
    output$kable <- renderText({
        intro_kbl <- lga_intro() %>% 
            mutate(`LGA code` = as.character(`LGA code`),
                   `Estimated Resident Population 2020` =
                       as.character(`Estimated Resident Population 2020`),
                   `Area (km2)` =  as.character(`Area (km2)`),
                   `Density (persons/km2)` = 
                       as.character(`Density (persons/km2)`)) %>% 
            pivot_longer(
                cols = 1:6,
                names_to = "Info Category",
                values_to = "Info Details"
            ) %>% 
            kableExtra::kbl() %>% 
            kable_paper("hover", full_width = F)
        
        intro_kbl
    })
    
    # Tab2 - Age
    output$age <- renderPlotly({
        p_pop <- age_filter() %>% 
            pivot_longer(cols = -c(`S/T code`, `S/T name`, `LGA code`, `LGA name`),
                         names_to = "Age",
                         values_to = "Population") %>% 
            filter(Age != "Total") %>% 
            ggplot() +
            geom_col(aes(x = Age,
                         y = Population),
                     fill = "steelblue") +
            coord_flip() +
            theme(
                # get rid of the 'major' y grid lines
                panel.grid.major.y = element_blank()) 
        
        ggplotly(p_pop)
    })
    
 #####--------------Tab3--------------#####
    # -------------Filtered Data------------- #
    # Filtered - LGA
    lga_filter2 <- reactive({
      
      data4 <- vic_lga_name %>% 
          filter(`LGA name` %in% c(input$lga2))
      
      data4
    })
    
    # Filtered - Property
    prop_filter <- reactive({
      
      if(is.null(input$lga2)){
        data5 <- rental_prop
      }
      
      if(!is.null(input$lga2)){
        data5 <- rental_prop %>%
        filter(LGAname %in% c(input$lga2))
      }
      
        data5
    })

    # -------------Output------------- #
    # Tab3 - Map
    output$map15km <- renderPlotly({
        p_15km <-vic_lga %>%
            ggplot(aes(text = paste("LGA:", NAME))) +
            geom_sf(fill = "lightblue2", colour = "white") +
            geom_sf(data = vic_lga_15km,
                    fill = "steelblue", colour = "white") +
            geom_sf(data = lga_filter2(),
                    fill = "lightsalmon", colour = "white") +
            geom_point(x = 145.133957, y = -37.907803, 
                       color = "red", size = 0.8) +
            theme_map()
        
        ggplotly(p_15km)
    })
    
    # Tab3 - Property Qty
    output$qty <- renderPlotly({
        p_qty <- prop_filter() %>%
            group_by(type, room) %>% 
            count()%>% 
            rename(`Number of rooms` = room,
                   Quantity = n,
                   Type = type) %>% 
            ggplot(aes(x = Type,
                       y = Quantity,
                       fill = `Number of rooms`)) +
            geom_col(position = "stack") +
            labs(x = "Property Type")
        
        ggplotly(p_qty)
    })
    
    # Tab3 - Property Price
    output$price <- renderPlotly({
        p_price <- prop_filter() %>%
            group_by(type, room) %>% 
            summarise(Quantity = n(),
                      `Avg price` = round(mean(price), 0)) %>% 
            mutate(room = as.numeric(room),
                   `Avg price per rooms` = round(`Avg price` / room, 0)) %>%
            mutate(room = as.character(room)) %>% 
            rename(Type = type,
                   `Number of rooms` = room) %>%
            ggplot(aes(x = `Avg price`,
                       y = Quantity,
                       size = `Avg price per rooms`,
                       color = `Number of rooms`)) +
            geom_point(alpha=0.5) +
            scale_size_continuous(guide = 'none') +
            facet_wrap(~Type, nrow = 1) +
            labs(x = "Average price",
                 y = "Quantity")
        
        ggplotly(p_price)
    })
    
    # Tab3 - Table
    output$dt <- renderDataTable({
        rental_prop_dt <- rental_prop %>% 
            select(2, 5:9, 1)  
        
        DT::datatable(rental_prop_dt,
                      filter = 'top',
                      options = 
                          list(columnDefs = 
                                   list(list(className = 'dt-right', targets = 3:5))),
                      colnames =
                          c('Local Government Area',
                            'Postcode',
                            'Rooms',
                            'Bathrooms',
                            'Carpark',
                            'Property Type',
                            'Price'))
    })

})
