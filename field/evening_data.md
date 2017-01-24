- Every evening, datasheets should be entered into the excel spreadsheet.
- Every evening, the PIT scanner should be uploaded to the computer.
- Once data has been entered and excel spreadsheet has been saved, open the QGIS RStudio project which will automatically "munge" the data by running through a series of scripts in the order that the files are numbered:
  1. 01_pitCompare.R - compares the scanned tags for the day with the tag numbers enetered in the excel spreadsheet
  2. 02_trim_gpx_csv.R - trims the GPX files to tracks that are only the length of the dive based on dive start and end time
  3. 03_trackoncat.R - concatenates both trimmed and untrimmed tracks for loading into QGIS
  4. 04_extractanem.R - pulls anemone data from the excel file and joins with GPX data to plot anemone locations in QGIS.
  5. 05_diveSummary.R - adds the day's site and fish numbers to a running text file and a table to describe the field season.
  6. 06_collections.R - separates fish into separate lines of data to prepare for import into the database and loads into a local database until a connection can be made with amphiprion.
