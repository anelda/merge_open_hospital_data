Source: File = http://www.health.gov.za/index.php/2014-03-17-09-09-38/reports/category/424-reports-2017# District HealthBarometer info 2016 2017 06 Feb 2018 (a spreadsheet)
Sheet:   ‘Hospitals’
New temp files: za_hospital_list_temp.csv, za_hospital_list_refine.csv
New final file: za_hospital_list_DoH.csv

Steps to get from Source file to New file:

1.  In sheet = ‘Hospitals’ select OrgUnitCategor = ‘All’ and Level = ‘All’ in  http://www.health.gov.za/index.php/2014-03-17-09-09-38/reports/category/424-reports-2017# District HealthBarometer info 2016 2017 06 Feb 2018 (a spreadsheet)
2.  Copy/paste table (from row 8 – 9346, column A – D)
3.  Add columns for day/month/year last updated
4.  Insert 6 February 2018 as last updated date (from file name)
5.  Add columns for source information
6.  Add columns with information about copyright ownership
7.  Export za_hospital_temp.csv for import into OpenRefine 3.2
8.  Open za_hospital_temp.csv in Openrefine 3.2
9a) Rename project to za_hospital_list_refine
9b) In undo/redo tab, select applyan za_hospital_list_temp_to_refine.json
9c) Paste contents from za_hospital_list_temp_to_refine.json and click on ‘Perform Operations’
  ** JSON script will do the following automatically
10a)  Remove rows that has provincial totals in
10b)  Fill cells down so that every cell has province, district, orgunittype
10c)  Change column header names
10d)  Remove leading province code from facility names
11. Export za_hospital_list_refine.csv from OpenRefine
12. Run za_hospital_list_refine_to_DoH.R in Rstudio
  ** R script will do the following:
13a)  Load za_hospital_refine.csv and za_hospital_district_names.csv (see readme_za_hospital_district_names.txt)
13b)  Merge the two tables in the files to create a new table with all the columns from za_hospital_list_refine.csv and a new column “district_name” from za_hospital_district_names.csv
13c)  Re-order the columns to make sense
13d) Export a new CSV file called za_hospital_list_DoH.csv
14. The final file contains the following columns:
  province  :  Province
  district_mdb  :  District code (from original source file)
  district_name : District name (from original source file)
  org_unit_type : Organisational Unit Type e.g. clinic, Community Day Centre, etc
  facility_name : Hospital/clinic etc name
  date_updated_day  :  From source file name
  date_updated_month  :  From source file name
  date_updated_year : From source file name
  source  :  URL for source file
  source_name : Organisation that provided the file (South African Dep of Health)
  copyright : Who owns the data if not in public domain or under open license
