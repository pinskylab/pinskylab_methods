Processing HiSEQ data
================

-   [Prepare the analysis space on the server](#prepare-the-analysis-space-on-the-server)
-   [Barcode splitter](#barcode-splitter)
-   [Process radtags](#process-radtags)
-   [Rename the output of process\_radtags](#rename-the-output-of-process_radtags)
-   [Trim and map reads using dDocent](#trim-and-map-reads-using-ddocent)
-   [Call SNPs](#call-snps)
-   [Filter output to refine data](#filter-output-to-refine-data)
    -   [Footnote: Details of process\_radtags options](#footnote-details-of-process_radtags-options)

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

``` r
# read baits table
baits <- lab %>%
  tbl("baits") %>%
  collect() %>%
  select(baits_id, seq)

# read PCR table
pcr <- lab %>% 
  tbl("pcr") %>% 
  collect() %>% 
  filter(SEQ %in% params$seq) %>% 
  select(pcr_id, bait_id, index)

# join pcr_id and index to seq id
pools <- left_join(pcr, baits, by = c("bait_id" = "baits_id")) %>% 
  select(seq, pcr_id, index)

# pull in the barcodes for illumina indexes
index <- lab %>% 
  tbl("illumina") %>% 
  collect()

# join the barcodes to the seq and pcr ids
pools <- left_join(pools, index, by = c("index" = "index_num")) %>% 
  select(seq, pcr_id, index_code)

# create a list of the multiple seqs
seqs <- select(pools, seq) %>% 
  distinct()
for(i in seq(seqs$seq)){
  x <- pools %>% 
  filter(seq == seqs$seq[i]) %>% 
  select(pcr_id, index_code)

# write the files for amphiprion
# readr::write_tsv(x, path = paste0("index-", seqs$seq[i], ".tsv"), col_names = F)
}
```

1.  Create a names file in R
    The names have to be species, underscore and then the sample identifier, so APCL\_L5432 for ligation\_id L5432

``` r
# read the ligations
ligs <- lab %>% 
  tbl("ligation") %>% 
  filter(pool %in% pools$pcr_id) %>% 
  select(ligation_id, barcode_num, pool) %>% 
  collect()

# read the barcodes
barcode <- lab %>% 
  tbl("barcodes") %>% 
  collect()

# join the ligation_id and pool ids to the barcodes
ligs <- left_join(ligs, barcode, by = "barcode_num")

# join the ligs to the seq_ids
ligs <- left_join(ligs, pools, by = c("pool" = "pcr_id")) %>% 
  # adjust the ligation name for dDocent
  mutate(name = paste0("APCL_", ligation_id)) %>% 
  select(seq, pool, name, barcode) %>% 
# reduce the pool to only a number
    mutate(pool = substr(pool, 2,5))

# for seq04, the seq column is empty.  Replace it.
ligs <- ligs %>% 
  mutate(seq = params$seq)

# write files for amphiprion
# create a list of the multiple seqs
names <- select(ligs, pool) %>% 
  distinct()

# loop through all of the pools
for(i in seq(names$pool)){
  x <- ligs %>% 
  filter(pool == names$pool[i]) %>% 
  select(name, barcode)

# write the files for amphiprion
readr::write_tsv(x, path = paste0("names_", names$pool[i], ".tsv"), col_names = F)
}
```

1.  Copy barcodes file in your logs directory from the logs directory of the last sequencing run only if you used the same barcodes, don't include barcodes you didn't use.

``` bash
cp /local/home/michelles/02-apcl-ddocent/16seq/logs/barcodes /local/home/michelles/02-apcl-ddocent/17seq/logs/barcodes
```

Barcode splitter
================

-   takes about 8 hours for 2 lanes and 192 samples

-   If this is a paired end sequencing run, the inputs of process radtags will be different from the ones listed below. A paired end run hasn’t been done in long enough time that a discussion should be had before proceeding. If the current run is of single end reads, proceed with confidence.

When a sequencing run is done at Princeton, the data we get back must be split out by indexed Pool before it can be put into process\_radtags to separate samples by barcode.
Barcode splitter has to be run on pass 1 and pass 2 of each lane.
From the previous step ("Prepare the analysis space on the server""), you already have a bcsplit directory in your working directory containing lane1 and lane2 directories. Lanes 1 and 2 have to be run in separate directories otherwise their outputs will overwrite each other. It saves time to run these lanes simultaneously.

The command line of barcode splitter consists of: - barcode\_splitter.py - the program - -bcfile ../../logs/03seq-index - the location and name of the index file created above - -idxread 2 - the number of the read that contains the index - - suffix .fastq.gz - the suffix of the input files

These options are followed by the location and name of lane \# read 1, a space and then the location and name of lane \# read 2

Run barcode splitter on 1st lane with nohup - notice the only difference between the filenames is at the very end.

``` bash
cd /local/home/michelles/02-apcl-ddocent/17seq/bcsplit/lane1

nohup ~/14_programs/paired_sequence_utils/barcode_splitter.py --bcfile ../../logs/index-seq17.tsv --idxread 2 --suffix .fastq.gz /local/shared/pinsky_lab/sequencing/hiseq_2016_10_25_SEQ17/SEQ17-ddRAD-APCL-DNA-for-158-cycles-H37YFBCXY_1_Read_1_passed_filter.fastq.gz /local/shared/pinsky_lab/sequencing/hiseq_2016_10_25_SEQ17/SEQ17-ddRAD-APCL-DNA-for-158-cycles-H37YFBCXY_1_Read_2_Index_Read_passed_filter.fastq.gz &
```

-   note\[1\] 37325 - job number for 10/25/2016

Run barcode splitter on 2nd lane with nohup

``` bash
cd /local/home/michelles/02-apcl-ddocent/17seq/bcsplit/lane2

nohup ~/14_programs/paired_sequence_utils/barcode_splitter.py --bcfile ../../logs/index-seq17.tsv --idxread 2 --suffix .fastq.gz /local/shared/pinsky_lab/sequencing/hiseq_2016_10_25_SEQ17/SEQ17-ddRAD-APCL-DNA-for-158-cycles-H37YFBCXY_2_Read_1_passed_filter.fastq.gz /local/shared/pinsky_lab/sequencing/hiseq_2016_10_25_SEQ17/SEQ17-ddRAD-APCL-DNA-for-158-cycles-H37YFBCXY_2_Read_2_Index_Read_passed_filter.fastq.gz &
```

-   \[2\] 37341 - job number for 10/25/2016

The nohup.out should be saved as a .tsv in the logs directory and can be used to gather useful information about the number of reads that were assigned to each pool.

``` bash
cd /local/home/michelles/02-apcl-ddocent/17seq/bcsplit/lane1

mv nohup.out ../../logs/bcsplit1.tsv

cd ../lane2

mv nohup.out ../../logs/bcsplit2.tsv
```

The output of barcode splitter consists a log file, the names of all of the pools split into read-1 and read-2 fastq.gz files and unnamed reads that the program was unable to assign to an index. Read-2 and unnamed read files can be deleted.

Cat the 2 lanes into one file for process radtags

``` bash
cd /local/home/michelles/02-apcl-ddocent/17seq/bcsplit/

cat ./lane2/Pool069-read-1.fastq.gz ./lane1/Pool069-read-1.fastq.gz > P069.fastq.gz

cat ./lane2/Pool070-read-1.fastq.gz ./lane1/Pool070-read-1.fastq.gz > P070.fastq.gz

cat ./lane2/Pool071-read-1.fastq.gz ./lane1/Pool071-read-1.fastq.gz > P071.fastq.gz

cat ./lane2/Pool072-read-1.fastq.gz ./lane1/Pool072-read-1.fastq.gz > P072.fastq.gz
```

Process radtags
===============

-   use esc-R or ctrl- to "find and replace" in nano
-   takes about 2.5 hours for 4 pools and 192 samples
-   Move the Pools into separate directories

``` bash
cd /local/home/michelles/02-apcl-ddocent/17seq/bcsplit/

mv P069.fastq.gz ../Pool1/

mv P070.fastq.gz ../Pool2/

mv P071.fastq.gz ../Pool3/

mv P072.fastq.gz ../Pool4/
```

Copy the [process radtags script](https://github.com/stuartmichelle/Genetics/blob/master/code/processr.sh) and the [readprocess.py script](https://github.com/stuartmichelle/Genetics/blob/master/code/readprocesslog.py) into the scripts directory.
\* In this example I am copying the scripts from the last sequencing run scripts folder into the current sequencing run folder.\*

``` bash
cd /local/home/michelles/02-apcl-ddocent/17seq/
cp ../16seq/scripts/68process.sh ./scripts/

cp ../16seq/scripts/readprocesslog.py ./scripts/
```

Run the processr.sh script on each pool in its own directory. This script calls up the process\_radtags program from stacks but ensures that all of the options specific to our project are used consistently. All of the options available in process\_radtags are listed in the footnotes below. Jon doesn’t use -c or -q for his dDocent runs but we do.

Nano the script to adjust for pool name and whether or not you are going to use the -r option (rescue barcodes); ctrl  will search and replace.

``` bash
cd /local/home/michelles/02-apcl-ddocent/17seq/bcsplit/
  
nano ../scripts/68process.sh

# change permissions
chmod u+x ../scripts/69process.sh

# start the process
nohup ../scripts/69process.sh



# here is an example of how the script looks.  In this script, the 68 was changed to 69 and then saved as 69process.sh

#\#!/bin/bash

#process_radtags -b ../logs/barcodes_48 -c -q --renz_1 pstI --renz_2 mluCI \

#-i gzfastq --adapter_1 ACACTCTTTCCCTACACGACGCTCTTCCGATCT \

#-f ./P069.fastq.gz -o ./

#mv process_radtags.log ../logs/69process.log
```

The nohup.out file does not contain any information that is not in the process\_radtags.log and can be deleted.

Output log of process radtags provides the number of reads per barcode. Convert all of the process.out files into tsvs using the readprocesslog.py script. Download the tsvs and use the R script [process\_read\_data.R](https://github.com/stuartmichelle/Genetics/blob/master/code/process_read_data.R) to analyze the number of reads and add it to the running total.

Process radtags also produces files that appear as “sample\_AATCGA.fq.gz” where AATCGA is the barcode.

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

### Footnote: Details of process\_radtags options

process\_radtags 1.29 isn’t different from 1.28 but is very different from 1.12. process\_radtags \[-f in\_file | -p in\_dir \[-P\] \[-I\] | -1 pair\_1 -2 pair\_2\] -b barcode\_file -o out\_dir -e enz \[-c\] \[-q\] \[-r\] \[-t len\] \[-D\] \[-w size\] \[-s lim\] \[-h\] f: path to the input file if processing single-end sequences. i: input file type, either 'bustard' for the Illumina BUSTARD format, 'bam', 'fastq' (default), or 'gzfastq' for gzipped FASTQ. y: output type, either 'fastq', 'gzfastq', 'fasta', or 'gzfasta' (default is to match the input file type). p: path to a directory of files. P: files contained within directory specified by '-p' are paired. I: specify that the paired-end reads are interleaved in single files. 1: first input file in a set of paired-end sequences. 2: second input file in a set of paired-end sequences. o: path to output the processed files. b: path to a file containing barcodes for this run. c: clean data, remove any read with an uncalled base. q: discard reads with low quality scores. r: rescue barcodes and RAD-Tags. t: truncate final read length to this value. E: specify how quality scores are encoded, 'phred33' (Illumina 1.8+, Sanger, default) or 'phred64' (Illumina 1.3 - 1.5). D: capture discarded reads to a file. w: set the size of the sliding window as a fraction of the read length, between 0 and 1 (default 0.15). s: set the score limit. If the average score within the sliding window drops below this value, the read is discarded (default 10). h: display this help messsage.

Barcode options: --inline\_null: barcode is inline with sequence, occurs only on single-end read (default). --index\_null: barcode is provded in FASTQ header, occurs only on single-end read. --inline\_inline: barcode is inline with sequence, occurs on single and paired-end read. --index\_index: barcode is provded in FASTQ header, occurs on single and paired-end read. --inline\_index: barcode is inline with sequence on single-end read, occurs in FASTQ header for paired-end read. --index\_inline: barcode occurs in FASTQ header for single-end read, is inline with sequence on paired-end read.

Restriction enzyme options: -e <enz>, --renz\_1 <enz>: provide the restriction enzyme used (cut site occurs on single-end read) --renz\_2 <enz>: if a double digest was used, provide the second restriction enzyme used (cut site occurs on the paired-end read). Currently supported enzymes include: 'apeKI', 'apoI', 'bamHI', 'bgIII', 'bstYI', 'claI', 'dpnII', 'eaeI', 'ecoRI', 'ecoRV', 'ecoT22I', 'hindIII', 'kpnI', 'mluCI', 'mseI', 'mspI', 'ndeI', 'nheI', 'nlaIII', 'notI', 'nsiI', 'pstI', 'sacI', 'sau3AI', 'sbfI', 'sexAI', 'sgrAI', 'speI', 'sphI', 'taqI', 'xbaI', or 'xhoI'

Adapter options: --adapter\_1 <sequence>: provide adaptor sequence that may occur on the single-end read for filtering. --adapter\_2 <sequence>: provide adaptor sequence that may occur on the paired-read for filtering. --adapter\_mm <mismatches>: number of mismatches allowed in the adapter sequence.

Output options: --merge: if no barcodes are specified, merge all input files into a single output file.

Advanced options: --filter\_illumina: discard reads that have been marked by Illumina's chastity/purity filter as failing. --disable\_rad\_check: disable checking if the RAD site is intact. --len\_limit <limit>: specify a minimum sequence length (useful if your data has already been trimmed). --barcode\_dist\_1: the number of allowed mismatches when rescuing single-end barcodes (default 1). --barcode\_dist\_2: the number of allowed mismatches when rescuing paired-end barcodes (defaults to --barcode\_dist\_1).

process\_radtags 1.12 process\_radtags \[-f in\_file | -p in\_dir \[-P\] | -1 pair\_1 -2 pair\_2\] -b barcode\_file -o out\_dir -e enz \[-c\] \[-q\] \[-r\] \[-t len\] \[-D\] \[-w size\] \[-s lim\] \[-h\] f: path to the input file if processing single-end sequences. i: input file type, either 'bustard' for the Illumina BUSTARD output files, 'fastq', or 'gzfastq' for gzipped Fastq (default 'fastq'). p: path to a directory of files. P: files contained within directory specified by '-p' are paired. 1: first input file in a set of paired-end sequences. 2: second input file in a set of paired-end sequences. o: path to output the processed files. y: output type, either 'fastq' or 'fasta' (default fastq). b: path to a file containing barcodes for this run. c: clean data, remove any read with an uncalled base. q: discard reads with low quality scores. r: rescue barcodes and RAD-Tags. t: truncate final read length to this value. E: specify how quality scores are encoded, 'phred33' (Illumina 1.8+, Sanger, default) or 'phred64' (Illumina 1.3 - 1.5). D: capture discarded reads to a file. w: set the size of the sliding window as a fraction of the read length, between 0 and 1 (default 0.15). s: set the score limit. If the average score within the sliding window drops below this value, the read is discarded (default 10). h: display this help messsage.

Barcode options: --inline\_null: barcode is inline with sequence, occurs only on single-end read (default). --index\_null: barcode is provded in FASTQ header, occurs only on single-end read. --inline\_inline: barcode is inline with sequence, occurs on single and paired-end read. --index\_index: barcode is provded in FASTQ header, occurs on single and paired-end read. --inline\_index: barcode is inline with sequence on single-end read, occurs in FASTQ header for paired-end read. --index\_inline: barcode occurs in FASTQ header for single-end read, is inline with sequence on paired-end read.

Restriction enzyme options: -e <enz>, --renz\_1 <enz>: provide the restriction enzyme used (cut site occurs on single-end read) --renz\_2 <enz>: if a double digest was used, provide the second restriction enzyme used (cut site occurs on the paired-end read). Currently supported enzymes include: 'apeKI', 'bamHI', 'claI', 'dpnII', 'eaeI', 'ecoRI', 'ecoT22I', 'hindIII', 'mluCI', 'mseI', 'mspI', 'ndeI', 'nheI', 'nlaIII', 'notI', 'nsiI', 'pstI', 'sau3AI', 'sbfI', 'sexAI', 'sgrAI', 'sphI', 'taqI', or 'xbaI' .

Adapter options: --adapter\_1 <sequence>: provide adaptor sequence that may occur on the single-end read for filtering. --adapter\_2 <sequence>: provide adaptor sequence that may occur on the paired-read for filtering. --adapter\_mm <mismatches>: number of mismatches allowed in the adapter sequence.

Output options: --merge: if no barcodes are specified, merge all input files into a single output file.

Advanced options: --filter\_illumina: discard reads that have been marked by Illumina's chastity/purity filter as failing. --disable\_rad\_check: disable checking if the RAD site is intact. --len\_limit <limit>: specify a minimum sequence length (useful if your data has already been trimmed). --barcode\_dist: provide the distace between barcodes to allow for barcode rescue (default 2) Processing Sequence files using stacks
