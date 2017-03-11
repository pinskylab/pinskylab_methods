Use the readprocesslog.py script in ~/13… to create tsv files to import into google:

- copy the script into the seq script folder
- run the script, it will ask for user input (the path to the log file that is output of process radtags)
- the script will show on the screen but also create a .tsv in the logs folder
- repeat for all pools
- in Fetch, grab the tsv’s and move them to google docs; also grab the names files (TODO: this could instead be brought into R (or run with R on amphiprion) to do the same following steps)
- In the Sequencing info APCL spreadsheet, the data is kept on the reads tab, but copy and paste each tsv into the process.log tab
- copy the names file into the far right columns (TODO: really need to write an R script to do this)
- copy the process.out data into the second column from the left (with the barcodes).  The names will automatically populate into the farthest left column
- On the reads page, fill in the seq and pool number and make the first blank cell =process.log!A1.  Drag down.    Copy and paste as values
- Fill in the totals_by_pool page
