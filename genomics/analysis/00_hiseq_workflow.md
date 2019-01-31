Processing HiSEQ data
================

-   [Prepare the analysis space on the server](#prepare-the-analysis-space-on-the-server)
-   [Barcode splitter](#barcode-splitter)
-   [Process radtags](#process-radtags)
-   [Rename the output of process\_radtags](#rename-the-output-of-process_radtags)
-   [Trim and map reads using dDocent](#trim-and-map-reads-using-ddocent)
-   [Call SNPs](#call-snps)
-   [Filter output to refine data](#filter-output-to-refine-data)

This method is designed to import and process hiseq output through calling SNPs.

It is good to be comfortable with command line processes before beginning sequencing analysis. Codecademy (\[<https://www.codecademy.com/en/courses/learn-the-command-line>\]) has a very great introductory command line tutorial that will help you dive into these processes. The python tutorial is also great for learning how to develop your own scripts.

Jon Puritz has a great tutorial that explains the inner workings of the dDocent pipeline, but that also has great tools for command line analysis of sequencing files and graphing on his github. Check out his website (<http://ddocent.com>) for tutorials under the "Documentation" menu.

Prepare the analysis space on the server
========================================

-   takes about \# 1.5 hours

    -   If this is a miseq run, you can skip barcode splitter and move on to process radtags. If this data is from hiseq, run barcode splitter

1.  Create a directory for the files (mkdir) in the pinsky\_lab/sequencing folder, use the naming scheme type\_of\_sequencer\_year\_month\_day\_SEQ\#\#: hiseq\_2014\_08\_07\_SEQ04

-   EXAMPLE:

``` bash
mkdir /local/shared/pinsky_lab/sequencing/hiseq_2016_10_25_SEQ17
```

-   Change the group permission on the newly made folder so that other people can write to it:

``` bash
cd /local/shared/pinsky_lab/sequencing/hiseq_2016_10_25_SEQ17
chgrp -R pinsky_lab hiseq_2016_10_25_SEQ17
```

1.  Enter the newly made directory

``` bash
cd /local/shared/pinsky_lab/sequencing/hiseq_2016_10_25_SEQ17
```

1.  Retrieve files from the sequencer

-   Princeton now emails a link to the data (you must sign in with credentials)

    1.  Click the link

    2.  Click on the sequencing run of interest in the box on the left that says “Recently Entered Samples"

    3.  In the box titled Sample Provenance, click on the link following "This library was utilized within the following output(s):” - repeat for each lane

    4.  In the “Data and Statistics” box, in the bottom right corner is a green button that says “Batch Download Data Files"

    5.  Click checkmarks next to the \#\_read\_1\_passed\_filter.fastq.gz and \#\_read\_2\_passed\_filter.fastq.gz

    6.  Click “Prepare selected files for download” and copy the link

    7.  In amphiprion, in the directory you made in the previous step, paste the link

-   Repeat for all lanes

-   Count raw reads (optional) - that is an L behind the wc

``` bash
cd /local/shared/pinsky_lab/sequencing/hiseq_2016_10_25_SEQ17
zcat clownfish-ddradseq-seq08-for-231-cycles-h3mgvbcxx_1_read_1_passed_filter.fastq.gz | wc -l | awk '{print$1/4}'
```

-   If you like you can count the number of reads that begin with your barcodes

``` bash
cd /local/shared/pinsky_lab/sequencing/hiseq_2016_10_25_SEQ17
zcat clownfish-ddradseq-seq08-for-231-cycles-h3mgvbcxx_1_read_1_passed_filter.fastq.gz | awk '^ACGTTT' | wc -l

#  alternative command line  
zcat XXXXX.fastq.gz | grep -c "^AAACGA"
```

1.  Update where files are saved on amphiprion in the sequencing table of the sql database, enter data by hand

2.  Make a working directory
    -   make separate pool directories to keep the process radtags output separate

-   EXAMPLE - please don't make folders in my michelles folder

``` r
mkdir /local/home/michelles/02-apcl-ddocent/17seq
    
cd 17seq

mkdir bcsplit Pool1 Pool2 Pool3 Pool4 logs scripts samples
   
cd bcsplit
    
mkdir lane1 lane2
```

1.  Create an index file in R

[create\_index.R](https://github.com/stuartmichelle/Genetics/blob/master/code/create_index.R). Upload the resulting file to amphiprion into the logs directory. 7. Create a names file in R using the script [create\_names.R](https://github.com/stuartmichelle/Genetics/blob/master/code/create_names.R). Upload the resulting files to amphiprion into the logs directory. 8. Copy barcodes file in your logs directory from the logs directory of the last sequencing run only if you used the same barcodes, don't include barcodes you didn't use.

[Return to analysis protocol](./0.hiseq_ddocent.md)

Barcode splitter
================

-   takes about 8 hours for 2 lanes and 192 samples

    -   If this is a paired end sequencing run, the inputs of process radtags will be different from the ones listed below. A paired end run hasn’t been done in long enough time that a discussion should be had before proceeding. If the current run is of single end reads, proceed with confidence.

Process radtags
===============

-   use esc-R or ctrl- to "find and replace" in nano
-   takes about 2.5 hours for 4 pools and 192 samples

Rename the output of process\_radtags
=====================================

-   takes a few minutes

Trim and map reads using dDocent
================================

-   takes about 3 hours

Call SNPs
=========

-   takes about 3-4 days depending on how many threads are used

Filter output to refine data
============================

-   takes about 4 hours
