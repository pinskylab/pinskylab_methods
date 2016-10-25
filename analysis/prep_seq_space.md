
1. create a directory for the files (mkdir), use the naming scheme type_of_sequencer_year_month_day_SEQ##: hiseq_2014_08_07_SEQ04
    - EXAMPLE: `mkdir /local/shared/pinsky_lab/sequencing/hiseq_2015_07_08_SEQ09`
2. Enter the newly made directory
- `cd hiseq_2015_07_08_SEQ09`
3. Retrieve files from the sequencer
- Receive files from sequencer
    - https://htseq.princeton.edu/cgi-bin/login.pl?redirect_url=https://htseq.princeton.edu/cgi-bin/dashboard.pl
    - Click on the sequencing run of interest in the box on the left that says “Recently Entered Samples"
    - In the box titled Sample Provenance, click on the link following "This library was utilized within the following output(s):” - repeat for each lane
    - In the “Data and Statistics” box, in the bottom right corner is a green button that says “Batch Download Data Files"
    - Click checkmarks next to the #_read_1_passed_filter.fastq.gz and #_read_2_passed_filter.fastq.gz
    - Click “Prepare selected files for download” and copy the link
    - In amphiprion, in the directory you made in the previous step, paste the link
    - Repeat for all lanes
- Count raw reads
    - $ zcat clownfish-ddradseq-seq08-for-231-cycles-h3mgvbcxx_1_read_1_passed_filter.fastq.gz | wc -l | awk '{print$1/4}'
- If you like you can count the number of reads that begin with your barcodes
    - $ zcat clownfish-ddradseq-seq08-for-231-cycles-h3mgvbcxx_1_read_1_passed_filter.fastq.gz | awk ‘^ACGTTT' | wc -l
    - alternative command line
        - ]$ zcat XXXXX.fastq.gz | grep -c "^AAACGA"
- Update where files are saved on amphiprion in sample_data file, Sequencing sheet, amphiprion folder column
- Make a working directory - make separate pool directories to keep the process radtags output separate
    - $ mkdir 02-seq03
    - $ cd 02-seq03/
    - 02-seq03]$ mkdir bcsplit Pool1 Pool2 Pool3 Pool4 logs scripts samples
    - 02-seq03]$ cd bcsplit
    - bcsplit]$ mkdir lane1 lane2
- In your logs directory, create an index file that is the Pool name tab separated from the index used on that pool.  The easiest way to do this is copy and paste from google sheets into a nano document: In the sample_data file, on the Names tab, type the pool numbers into the Pool ID column in the format below.  The spreadsheet will look up the proper indexes for you.  Then copy and paste into a blank nano document, save as index-seq##
    - P012    ATCACG
    - P013    TGACCA
    - P014    CAGATC
    - P015    TAGCTT
- Create a names file with the sample name tab separated from the barcode assigned to that sample.  The easiest way to make a names file is to copy and paste from google sheets. Copy the ligation ID’s from the pool and paste them into the names tab, copy and paste the result into a nano document in the logs directory.
- Create a barcodes file in your logs directory: from the sample_data file, highlight the barcodes column only on the barcodes sheet and paste into nano, do not hit enter after the final barcode, save as “barcodes”.
- If you are adding samples to an already existing reference.fasta, copy the reference.fasta over to your working directory (APCL_analysis > date of dDocent run) - this won’t really be ready yet
