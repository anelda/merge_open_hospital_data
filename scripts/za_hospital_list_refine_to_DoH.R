## INSTALL DEVELOPMENT VERSION OF DPLYR TO ACCESS RELOCATE (uncomment if installation is required)
devtools::install_github("tidyverse/dplyr")

## LOAD REQUIRED LIBRARIES ----
library(tidyverse, warn.conflicts = FALSE)

## LOAD DATA ----

# Load hospital list file from OpenRefine (see readme_za_hospital_list.txt) 
hospital_list <- read_csv('data/za_hospital_list_refine.csv')

# Load district names/codes file (see readme_za_hospital_district_names.txt)
district_names <- read_csv('data/za_hospital_district_names.csv')

## MERGE DATA ----

# Add column to table showing full name of district
updated_hospital_list <- hospital_list %>% 
  # This way we'll ensure that the province column doesn't occur twice in the final dataset
  merge(district_names, by = c('province', 'district_mdb')) %>% 
  # Move the newly added district_names column to just after the district_mdb column 
  relocate('district_name', .after = district_mdb) %>% 
  mutate(province = as.factor(province),
         district_mdb = as.factor(district_mdb),
         district_name = as.factor(district_name),
         org_unit_type = as.factor(org_unit_type)
         )

## EXPORT DATA ----
write_csv(updated_hospital_list, 'data/za_hospital_list_DoH.csv')
