Source: https://figshare.com/articles/SURGICAL_RESOURCES_latestmarch2016_xlsx/12066711
New file: za_hospital_resources.csv
Steps to recreate:

1.  Create new file with two sheets - one for public hospital information and one for private hospital information
2.  Copy the primary table in each sheet into the relevant sheet in the new file (each province one under the other to create a single table in each sheet)
3.  Insert column for province
4.  Insert column for public/private
5.  Remove secondary phone numbers for ease of analysis
6.  Replace tel: with ‘ to keep 0 at beginning of phone numbers (some tel: has 1 space between colon and 0)
7.  Remove spaces from phone numbers for ease of comparison later on
8.  Remove coordinates for GP hospitals as it was for regions not individual hospitals
9.  Change kz Matatiele Private hospital from EC private hospitals to ec Matatiele Private hospital (Googled to confirm it is in EC)
10. Change ns Mediclinic Kimberley to NC Mediclinic Kimberley
11. Remove preceding province code from hospital names with replace ^\w\w\s
12. Remove all districts with nil private hospitals
13. Remove coordinate columns (will add later)
14. Change column headers for public hospitals:
  PROVINCE,province
  REGION,region
  GPS,[removed]
  HOSPITAL TYPE,hosp_class
  HOSPITAL,hosp_name
  USABLE BEDS,beds_usable
  APPROVED BEDS,beds_approved
  USABLE SB,beds_surgical_usable
  APP SURG BEDS,beds_surgical_approved
  SURGEONS (QUAL),surgeons_qualified
  SURGEONS (UNQUAL),sugeons_unqualified
  THEATRES,theatres
  CONTACT,hosp_contact
  TYPE,hosp_type
12. Change column headers for private hospitals
  PROVINCE,province
  GPS,[removed]
  REGION,region
  HOSPITAL TYPE,hosp_class
  HOSPITAL,hosp_name
  USABLE BEDS,beds_usable
  USE SUR BED,beds_surgical_usable
  THEATRES,theatres
  TYPE,hosp_type
13. Combine private/public data into a single spreadsheet
14. Add columns for source_date_day, source_date_month, source_date_year to keep track of when data was last updated
15. Add source column with link to original dataset in Figshare
16. Add column for source_name, source_surname
17. Add column for source_email
18. Add column for source_phone
19. Export to za_hospital_resources.csv
