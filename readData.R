library(tidyverse)
library(readxl)
library(sf)
library(geosphere)

#   ____________________________________________________________________________
#   Read Data

#LGA intro
intro_lga <- read_excel("data/population/LGA_intro.xlsx")

#population
population_lga <- read_excel("data/population/abs_ERP_2020.xlsx",
                             sheet = "LGA") %>% 
  mutate(`LGA code` = as.character(`LGA code`))
population_poa <-
  read_excel("data/population/abs_ERP_2020.xlsx",
                             sheet = "POA")
#boundary data
vic_lga <- read_sf("data/boundary_vic/AD_LGA_AREA_POLYGON.shp") %>% 
  filter(STATE == "VIC")
vic_poa <- read_sf("data/boundary_vic/POSTCODE_POLYGON.shp") %>% 
  filter(POSTCODE %in% c(population_poa$POAcode))

#rental property
rental_prop <- read_excel("data/rentalprop_vic.xlsx") %>% 
  mutate(room = as.character(room),
         postalCode = as.character(postalCode),
         LGA = as.character(LGAcode)) %>% 
  filter(room != 0)

#Area 15 km
monash_poa_15km <- population_poa %>% 
  mutate(dist_monash =
           distHaversine(
             matrix(c(lng_poa,lat_poa), 
                    ncol = 2),
             matrix(c(145.1349,
                      -37.91054), 
                    ncol = 2))/1000) %>% 
  filter(dist_monash <= 15) %>% 
  dplyr::select(3:5, 25:27) %>% 
  mutate(`LGA code` = as.character(`LGA code`))

vic_lga_15km <- vic_lga %>% 
  mutate(`LGA code` = ABSLGACODE) %>% 
  left_join(monash_poa_15km) %>% 
  filter(!is.na(`LGA name`))

vic_lga_name <- vic_lga %>% 
  mutate(`LGA code` = ABSLGACODE) %>% 
  left_join(population_lga) %>% 
  filter(!is.na(`LGA name`)) %>% 
  select(1:15, `LGA name`)

  print("Data is ready!")
