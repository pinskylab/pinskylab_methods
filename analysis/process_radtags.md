Run [process radtags script](https://github.com/stuartmichelle/Genetics/blob/master/code/processr.sh) on each pool in its own directory.  This script calls up the process_radtags program from stacks but ensures that all of the options specific to our project are used consistently.  All of the options available in process_radtags are listed below. Jon doesn’t use -c or -q for his dDocent runs.

Nano the script to adjust for pool name and whether or not you are going to use the -r option (rescue barcodes), ctrl \ will search and replace

`nano ../scripts/processr.sh`

\#!/bin/bash

process_radtags -b ../logs/barcodes -c -q -r --renz_1 pstI --renz_2 mluCI

-i gzfastq --adapter_1 ACACTCTTTCCCTACACGACGCTCTTCCGATCT \

-f ../bcsplit/P012.fastq.gz -o ./

mv process_radtags.log ../logs/12processr.log

`nohup ../scripts/12processr.sh`

The nohup.out file does not contain any information that is not in the process_radtags.log and can be deleted.

Output log of process radtags provides the number of reads per barcode.  Process radtags also produces files that appear as “sample_AATCGA.fq.gz” where AATCGA is the barcode.


##Details of process_radtags options

process_radtags 1.29 isn’t different from 1.28 but is very different from 1.12.
process_radtags [-f in_file | -p in_dir [-P] [-I] | -1 pair_1 -2 pair_2] -b barcode_file -o out_dir -e enz [-c] [-q] [-r] [-t len] [-D] [-w size] [-s lim] [-h]
  f: path to the input file if processing single-end sequences.
  i: input file type, either 'bustard' for the Illumina BUSTARD format, 'bam', 'fastq' (default), or 'gzfastq' for gzipped FASTQ.
  y: output type, either 'fastq', 'gzfastq', 'fasta', or 'gzfasta' (default is to match the input file type).
  p: path to a directory of files.
  P: files contained within directory specified by '-p' are paired.
  I: specify that the paired-end reads are interleaved in single files.
  1: first input file in a set of paired-end sequences.
  2: second input file in a set of paired-end sequences.
  o: path to output the processed files.
  b: path to a file containing barcodes for this run.
  c: clean data, remove any read with an uncalled base.
  q: discard reads with low quality scores.
  r: rescue barcodes and RAD-Tags.
  t: truncate final read length to this value.
  E: specify how quality scores are encoded, 'phred33' (Illumina 1.8+, Sanger, default) or 'phred64' (Illumina 1.3 - 1.5).
  D: capture discarded reads to a file.
  w: set the size of the sliding window as a fraction of the read length, between 0 and 1 (default 0.15).
  s: set the score limit. If the average score within the sliding window drops below this value, the read is discarded (default 10).
  h: display this help messsage.

  Barcode options:
    --inline_null:   barcode is inline with sequence, occurs only on single-end read (default).
    --index_null:    barcode is provded in FASTQ header, occurs only on single-end read.
    --inline_inline: barcode is inline with sequence, occurs on single and paired-end read.
    --index_index:   barcode is provded in FASTQ header, occurs on single and paired-end read.
    --inline_index:  barcode is inline with sequence on single-end read, occurs in FASTQ header for paired-end read.
    --index_inline:  barcode occurs in FASTQ header for single-end read, is inline with sequence on paired-end read.

  Restriction enzyme options:
    -e <enz>, --renz_1 <enz>: provide the restriction enzyme used (cut site occurs on single-end read)
    --renz_2 <enz>: if a double digest was used, provide the second restriction enzyme used (cut site occurs on the paired-end read).
    Currently supported enzymes include:
      'apeKI', 'apoI', 'bamHI', 'bgIII', 'bstYI', 'claI', 'dpnII', 'eaeI',
      'ecoRI', 'ecoRV', 'ecoT22I', 'hindIII', 'kpnI', 'mluCI', 'mseI', 'mspI',
      'ndeI', 'nheI', 'nlaIII', 'notI', 'nsiI', 'pstI', 'sacI', 'sau3AI',
      'sbfI', 'sexAI', 'sgrAI', 'speI', 'sphI', 'taqI', 'xbaI', or 'xhoI'

  Adapter options:
    --adapter_1 <sequence>: provide adaptor sequence that may occur on the single-end read for filtering.
    --adapter_2 <sequence>: provide adaptor sequence that may occur on the paired-read for filtering.
      --adapter_mm <mismatches>: number of mismatches allowed in the adapter sequence.

  Output options:
    --merge: if no barcodes are specified, merge all input files into a single output file.

  Advanced options:
    --filter_illumina: discard reads that have been marked by Illumina's chastity/purity filter as failing.
    --disable_rad_check: disable checking if the RAD site is intact.
    --len_limit <limit>: specify a minimum sequence length (useful if your data has already been trimmed).
    --barcode_dist_1: the number of allowed mismatches when rescuing single-end barcodes (default 1).
    --barcode_dist_2: the number of allowed mismatches when rescuing paired-end barcodes (defaults to --barcode_dist_1).

process_radtags 1.12
process_radtags [-f in_file | -p in_dir [-P] | -1 pair_1 -2 pair_2] -b barcode_file -o out_dir -e enz [-c] [-q] [-r] [-t len] [-D] [-w size] [-s lim] [-h]
  f: path to the input file if processing single-end sequences.
  i: input file type, either 'bustard' for the Illumina BUSTARD output files, 'fastq', or 'gzfastq' for gzipped Fastq (default 'fastq').
  p: path to a directory of files.
  P: files contained within directory specified by '-p' are paired.
  1: first input file in a set of paired-end sequences.
  2: second input file in a set of paired-end sequences.
  o: path to output the processed files.
  y: output type, either 'fastq' or 'fasta' (default fastq).
  b: path to a file containing barcodes for this run.
  c: clean data, remove any read with an uncalled base.
  q: discard reads with low quality scores.
  r: rescue barcodes and RAD-Tags.
  t: truncate final read length to this value.
  E: specify how quality scores are encoded, 'phred33' (Illumina 1.8+, Sanger, default) or 'phred64' (Illumina 1.3 - 1.5).
  D: capture discarded reads to a file.
  w: set the size of the sliding window as a fraction of the read length, between 0 and 1 (default 0.15).
  s: set the score limit. If the average score within the sliding window drops below this value, the read is discarded (default 10).
  h: display this help messsage.

  Barcode options:
    --inline_null:   barcode is inline with sequence, occurs only on single-end read (default).
    --index_null:    barcode is provded in FASTQ header, occurs only on single-end read.
    --inline_inline: barcode is inline with sequence, occurs on single and paired-end read.
    --index_index:   barcode is provded in FASTQ header, occurs on single and paired-end read.
    --inline_index:  barcode is inline with sequence on single-end read, occurs in FASTQ header for paired-end read.
    --index_inline:  barcode occurs in FASTQ header for single-end read, is inline with sequence on paired-end read.

  Restriction enzyme options:
    -e <enz>, --renz_1 <enz>: provide the restriction enzyme used (cut site occurs on single-end read)
    --renz_2 <enz>: if a double digest was used, provide the second restriction enzyme used (cut site occurs on the paired-end read).
    Currently supported enzymes include:
      'apeKI', 'bamHI', 'claI', 'dpnII', 'eaeI', 'ecoRI',
      'ecoT22I', 'hindIII', 'mluCI', 'mseI', 'mspI', 'ndeI',
      'nheI', 'nlaIII', 'notI', 'nsiI', 'pstI', 'sau3AI',
      'sbfI', 'sexAI', 'sgrAI', 'sphI', 'taqI', or 'xbaI'
      .

  Adapter options:
    --adapter_1 <sequence>: provide adaptor sequence that may occur on the single-end read for filtering.
    --adapter_2 <sequence>: provide adaptor sequence that may occur on the paired-read for filtering.
      --adapter_mm <mismatches>: number of mismatches allowed in the adapter sequence.

  Output options:
    --merge: if no barcodes are specified, merge all input files into a single output file.

  Advanced options:
    --filter_illumina: discard reads that have been marked by Illumina's chastity/purity filter as failing.
    --disable_rad_check: disable checking if the RAD site is intact.
    --len_limit <limit>: specify a minimum sequence length (useful if your data has already been trimmed).
    --barcode_dist: provide the distace between barcodes to allow for barcode rescue (default 2)
Processing Sequence files using stacks
