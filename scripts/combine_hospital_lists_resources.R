## LOAD REQUIRED LIBRARIES ----
library(filesstrings)
library(stringdist)
library(lubridate)
library(readr)
library(dplyr)
library(purrr)
library(readxlsb)


## LOAD DATA ----

# Load hospital resources data from Angela Dell's research
resources <- read_csv('data/za_hospital_resources.csv') %>% 
  mutate(province = as.factor(province),
         region = as.factor(region),
         hosp_class = as.factor(hosp_class),
         hosp_type = as.factor(hosp_type)
  )

# Load cleaned-up hospital list from and district data data from DoH District Health Barometer file

# Load hospital list file from OpenRefine (see readme_za_hospital_list.txt) 
hospital_list <- read_csv('data/za_hospital_list_refine.csv')

# Load district names/codes file (see readme_za_hospital_district_names.txt)
district_names <- read_csv('data/za_hospital_district_names.csv')

# Merge data

# Add column to table showing full name of district
dhb_2016_df <- hospital_list %>% 
  # This way we'll ensure that the province column doesn't occur twice in the final dataset
  merge(district_names, by = c('province', 'district_mdb')) %>% 
  # Move the newly added district_names column to just after the district_mdb column 
  relocate('district_name', .after = district_mdb) %>% 
  mutate(province = as.factor(province),
         district_mdb = as.factor(district_mdb),
         district_name = as.factor(district_name),
         org_unit_type = as.factor(org_unit_type)
  ) %>% 
  rename(prov_abb = province,
         ou3abb = district_mdb,
         ou3short = district_name,
         type = org_unit_type,
         fac_name = facility_name
         )

remove(hospital_list, district_names)


# Load data from health barometer 2018/2019

dhb_2018_df <- read_xlsb('data/DHB2019_19Feb2020.xlsb', sheet = 'Fac_list') %>% 
  # Add province long name to make comparable with other datasets
  mutate(province = case_when(Prov == 'EC' ~'Eastern Cape',
                              Prov == 'FS' ~'Free State',
                              Prov == 'GP' ~ 'Gauteng',
                              Prov == 'KZ' ~ 'KwaZulu Natal',
                              Prov == 'LP' ~ 'Limpopo',
                              Prov == 'MP' ~ 'Mpumulanga',
                              Prov == 'NC' ~ 'Northern Cape',
                              Prov == 'NW' ~ 'North West',
                              Prov == 'WC' ~ 'Western Cape')) %>%
  # Move new province abbreviation column to after the column containing province name for ease of reference
  relocate('province', .after = Prov) %>% 
  # Remove unwanted columns
  select( -c(OrgUnit5_ID, OU5UID)) %>% 
  # Clean up columns we'll use in analysis later on
  # Remove leading province abbreviation and space
  mutate(OrgUnit5 = str_replace(OrgUnit5, ('^\\w\\w\\s'), ''),
         OrgUnitType = as.factor(OrgUnitType),  
         Prov = as.factor(Prov),
         province = as.factor(province),
         dm2016 = as.factor(dm2016),
         Date_open = ymd(Date_open),
         Date_Closed = ymd(Date_Closed),
         OrgLevel = as.factor(OrgLevel),
         lm2016_sd = as.factor(lm2016_sd)
         ) %>% 
  # Rename columns to be more friendly for coding
  rename(fac_name = OrgUnit5,
         type = OrgUnitType,  
         prov_abb = Prov,
         ou3_short = dm2016,
         date_open = Date_open,
         date_close = Date_Closed,
         org_level = OrgLevel,
         ou4short = lm2016_sd,
         comment = OrgUnitComment,
         lat = Latitude,
         long = Longitude
  )


# Load data dictionary data from DoH
### Important note - data downloaded at 10:38 am on 4 April 2020
### All provinces downloaded at level 5 as single file
### Manual download from https://dd.dhmis.org/orgunits.html?file=NIDS%20Integrated&source=nids
### Save csv file za_ou5_doh.csv (operational unit 5) doh (department of health)

za_ou5_doh <- read_csv('data/za_ou5_doh.csv') %>% 
  # Drop unused columns
  select(-c(OU2uid, OU2name, OU2code, OU3uid, OU3name, OU3code, OU4uid, OU4name, OU4code,
            OU4uid, OU4name, OU4code, OU5uid, OU5short, OU5code, `STI Sentinel`)) %>% 
  # Add abbreviations for provinces to be able to comparet o other datasets
  mutate(prov_abb = case_when(OU2short == 'Eastern Cape' ~ 'EC',
                              OU2short == 'Free State' ~ 'FS',
                              OU2short == 'Gauteng' ~ 'GP',
                              OU2short == 'KwaZulu Natal' ~ 'KZ',
                              OU2short == 'Limpopo' ~ 'LP',
                              OU2short == 'Mpumulanga' ~ 'MP',
                              OU2short == 'Northern Cape' ~ 'NC',
                              OU2short == 'North West' ~ 'NW',
                              OU2short == 'Western Cape' ~ 'WC')) %>%
  # Move new province abbreviation column to after the column containing province name for ease of reference
  relocate('prov_abb', .after = OU2short) %>% 
  # Clean up columns we'll use in analysis later on
  mutate(OU2short = as.factor(OU2short),
    OU3short = as.factor(OU3short),
    OU4short = as.factor(OU4short),
    # Remove leading province abbreviation and space
    OU5name = str_replace(OU5name, ('^\\w\\w\\s'), ''),
    prov_abb = as.factor(prov_abb),
    openingdate = ymd(openingdate),
    closeddate = ymd(closeddate),
    OrgUnitOwnership = as.factor(OrgUnitOwnership),
    OrgUnitRuralUrban = as.factor(OrgUnitRuralUrban),
    OrgUnitType = as.factor(OrgUnitType),
    lastupdated = ymd_hms(lastupdated)
  ) %>% 
    rename(province = OU2short,
           ou3short = OU3short,
           ou4short = OU4short,
           fac_name = OU5name,
           date_open = openingdate,
           date_close = closeddate,
           long = longitude,
           lat = latitude,
           org_owner = OrgUnitOwnership,
           org_rural_urban = OrgUnitRuralUrban,
           type = OrgUnitType,
           last_update = lastupdated
    )

# Load shapefile from Healthsites.io


# Load KEMRI/WHO data

kemri_who_df <- read_excel('data/who-cds-gmp-2019-01-eng.xlsx')

kemri_who_df <- kemri_who_df %>% 
  # Extract only facilities for South Africa
  filter(Country == 'South Africa') %>% 
  select(-Country) %>% 
  mutate(Admin1 = as.factor(Admin1),
         `Facility type` = as.factor(`Facility type`),
         Ownership = as.factor(Ownership),
         `LL source` = as.factor(`LL source`)
         ) %>% 
  rename(ou2name = Admin1,
         fac_name = `Facility name`,
         type = `Facility type`,
         org_owner = Ownership,
         lat = Lat,
         long = Long,
         source = `LL source`
         ) 
  

  
## CLEAN UP FACILITY NAMES IN RESOURCES TIBBLE TO MATCH DOH DATA ----

# Compare facility names from resources to doh facility names (ou5name)
name_match_resources_doh_pos <- amatch(str_to_lower(resources$hosp_name), str_to_lower(za_ou5_doh$OU5name), method = 'cosine')

name_match_resources_doh <- resources %>% 
  bind_cols(OU5position = name_match_resources_doh_pos) %>% 
  mutate(OU5name = za_ou5_doh$OU5name[OU5position]) %>% 
  relocate(OU5name, .after = hosp_name) %>% 
  select(-OU5position)

name_match_resources_doh %>% 
  filter(is.na(OU5name))


# Compare names from the two DoH datasets
name_match_doh_dd_pos <- amatch(str_to_lower(hosp_list$facility_name), str_to_lower(za_ou5_doh$OU5name), method = 'cosine')

name_match_doh_dd <- hosp_list %>% 
  bind_cols(OU5position = name_match_doh_dd_pos) %>% 
  mutate(OU5name = za_ou5_doh$OU5name[OU5position]) %>% 
  relocate(OU5name, .after = facility_name)

name_match_dd_doh <- amatch(str_to_lower(za_ou5_doh$OU5name), str_to_lower(hosp_list$facility_name), method = 'cosine')

un <- za_ou5_doh %>% 
  bind_cols(facility_pos = unmatched_doh) %>% 
  mutate(facility_name = hosp_list$facility_name[facility_pos]) %>% 
  relocate(facility_name, .after = OU5name) %>% 
  filter(is.na(facility_name))
