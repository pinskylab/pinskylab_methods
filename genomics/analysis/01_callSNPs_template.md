Calling SNPs on all APCL seqs as of 20181127
================

-   [Find and replace each 20181127 with the current date and replace the "template" in this call\_SNPs document filename with your analysis date.](#find-and-replace-each-20181127-with-the-current-date-and-replace-the-template-in-this-call_snps-document-filename-with-your-analysis-date.)
    -   [Make a folder to hold samples and intermediate files](#make-a-folder-to-hold-samples-and-intermediate-files)
    -   [Symlink the sample files into the folder](#symlink-the-sample-files-into-the-folder)
    -   [Remove the \* file with fetch](#remove-the-file-with-fetch)
        -   [Removing this is important, don't skip it](#removing-this-is-important-dont-skip-it)
    -   [Make a directory at home to store this notebook and filtering files](#make-a-directory-at-home-to-store-this-notebook-and-filtering-files)
-   [Trim](#trim)
-   [Map](#map)
    -   [Replace mapped bed with baits only mapped bed](#replace-mapped-bed-with-baits-only-mapped-bed)
    -   [Replace full mapped.bed with baits only mapped.bed](#replace-full-mapped.bed-with-baits-only-mapped.bed)
    -   [Create coverage stats](#create-coverage-stats)
    -   [create instances](#create-instances)
    -   [create a population file](#create-a-population-file)
-   [Create the split.\*.bam files - takes about 1/2 hour](#create-the-split..bam-files---takes-about-12-hour)
-   [Index the splits - takes less than a minute](#index-the-splits---takes-less-than-a-minute)
-   [Call SNPs with freebayes - this should take a little over a day for the last 2 to finish](#call-snps-with-freebayes---this-should-take-a-little-over-a-day-for-the-last-2-to-finish)
-   [Rename the single digit raw.vcf files](#rename-the-single-digit-raw.vcf-files)
-   [Combine all of the raw vcfs into a total raw snps file](#combine-all-of-the-raw-vcfs-into-a-total-raw-snps-file)
-   [Move all of the raw vcfs into their own folder](#move-all-of-the-raw-vcfs-into-their-own-folder)
-   [TotalRawSNPs.vcf should be ready for filtering](#totalrawsnps.vcf-should-be-ready-for-filtering)

Starting from the very beginning of trim, map, SNP call to see if I can produce an error free data set.

Find and replace each 20181127 with the current date and replace the "template" in this call\_SNPs document filename with your analysis date.
=============================================================================================================================================

Make a folder to hold samples and intermediate files
----------------------------------------------------

``` bash
mkdir /data/apcl/all_samples/20181127
```

Symlink the sample files into the folder
----------------------------------------

``` bash
ln -s /data/apcl/03seq/samples/APCL_*.F.fq.gz /data/apcl/all_samples/20181127
ln -s /data/apcl/04seq/samples/APCL_*.F.fq.gz /data/apcl/all_samples/20181127
ln -s /data/apcl/05seq/samples/APCL_*.F.fq.gz /data/apcl/all_samples/20181127
ln -s /data/apcl/07seq/samples/APCL_*.F.fq.gz /data/apcl/all_samples/20181127
ln -s /data/apcl/08seq/samples/APCL_*.F.fq.gz /data/apcl/all_samples/20181127
ln -s /data/apcl/09seq/samples/APCL_*.F.fq.gz /data/apcl/all_samples/20181127
ln -s /data/apcl/12seq/samples/APCL_*.F.fq.gz /data/apcl/all_samples/20181127
ln -s /data/apcl/13seq/samples/APCL_*.F.fq.gz /data/apcl/all_samples/20181127
ln -s /data/apcl/15seq/samples/APCL_*.F.fq.gz /data/apcl/all_samples/20181127
ln -s /data/apcl/16seq/samples/APCL_*.F.fq.gz /data/apcl/all_samples/20181127
ln -s /data/apcl/17seq/samples/APCL_*.F.fq.gz /data/apcl/all_samples/20181127
ln -s /data/apcl/28seq/samples/APCL_*.F.fq.gz /data/apcl/all_samples/20181127
ln -s /data/apcl/29seq/samples/APCL_*.F.fq.gz /data/apcl/all_samples/20181127
ln -s /data/apcl/30seq/samples/APCL_*.F.fq.gz /data/apcl/all_samples/20181127
ln -s /data/apcl/31seq/samples/APCL_*.F.fq.gz /data/apcl/all_samples/20181127
```

``` bash
ls /data/apcl/all_samples/20181127
```

Remove the \* file with fetch
-----------------------------

##### Removing this is important, don't skip it

Make a directory at home to store this notebook and filtering files
-------------------------------------------------------------------

``` bash
mkdir ~/02-apcl-ddocent/APCL_analysis/20181127

## Copy over the reference fasta

cp ~/02-apcl-ddocent/jonsfiles/reference.fasta /data/apcl/all_samples/20181127/

## Create a namelist

cd /data/apcl/all_samples/20181127
ls *.F.fq.gz > namelist
sed -i'' -e 's/.F.fq.gz//g' namelist
```

Trim
====

STACKS adds a strange \_1 or \_2 character to the end of processed reads, this looks for checks for errant characters and replaces them.

``` bash
cd /data/apcl/all_samples/20181127
mkdir trim_reports
    
    NAMES=( `cat "namelist" `)
    STACKS=$(cat namelist| parallel --load 75% --joblog ./trim_reports/stacksF.log "gunzip -c {}.F.fq.gz | head -1" | mawk '$0 !~ /\/1$/ && $0 !~ /\/1[ ,   ]/ && $0 !~ / 1:.*[A-Z]*/' | wc -l )
    
    if [ $STACKS -gt 0 ]; then
        
        echo "Removing the _1 character and replacing with /1 in the name of every sequence"
        cat namelist | parallel --load 75% --joblog ./trim_reports/stacksF.log "gunzip -c {}.F.fq.gz | sed -e 's:_1$:/1:g' > {}.F.fq"
        rm -f *.F.fq.gz
        cat namelist | parallel --load 75% --joblog ./trim_reports/stacksF.log "gzip {}.F.fq"
    fi

    if [ -f "${NAMES[@]:(-1)}".R.fq.gz ]; then
    
        STACKS=$(cat namelist| parallel --load 75% --joblog ./trim_reports/stacksR.log "gunzip -c {}.R.fq.gz | head -1" | mawk '$0 !~ /\/2$/ && $0 !~ /\/2[ ,   ]/ && $0 !~ / 2:.*[A-Z]*/'| wc -l )

        if [ $STACKS -gt 0 ]; then
            echo "Removing the _2 character and replacing with /2 in the name of every sequence"
            cat namelist | parallel --load 75% --joblog ./trim_reports/stacksR.log "gunzip -c {}.R.fq.gz | sed -e 's:_2$:/2:g' > {}.R.fq"
            rm -f *.R.fq.gz
            cat namelist | parallel --load 75% --joblog ./trim_reports/stacksR.log "gzip {}.R.fq"
        fi
    fi



    #cat namelist | parallel --load 75% --joblog ./trim_reports/trim.log  "gunzip -c {}.F.fq.gz | head -2 | tail -1 >> lengths.txt"
    #MLen=$(mawk '{ print length() | "sort -rn" }' lengths.txt| head -1)
  #MLen=$(($MLen / 2))
    #TW="--length_required $MLen"
    # MRS changed this portion of the code to be hard coded for 104.  All of our contigs are ~211 and 104 is 1/2 of that.
    
    trim_reads(){ 
    fastp -i $1.F.fq.gz -o $1.R1.fq.gz --cut_by_quality5 20 --cut_by_quality3 20 --cut_window_size 5 --cut_mean_quality 15 -q 15 -u 50  --length_required 104 -j $1.json -h $1.html &> $1.trim.log
    mv $1.html ./trim_reports  && mv $1.json ./trim_reports
    }
    
export -f trim_reads
cat namelist | parallel --env trim_reads --load 75% --joblog ./trim_reports/trimreads.log trim_reads {}
```

Map
===

Need an indexed fasta reference

``` bash
cd /data/apcl/all_samples/20181127/

samtools faidx reference.fasta &> index.log
bwa index reference.fasta >> index.log 
```

Make sure trimmed reads are present

``` bash
cd /data/apcl/all_samples/20181127/
ls *.R1.*
```

BWA for mapping for all samples. As of version 2.0 can handle SE or PE reads by checking for PE read files.

-   To use the script version of the mapping command: <!-- ```{bash eval=FALSE} --> <!-- cd /data/apcl/all_samples/20181127/ --> <!-- cat namelist | parallel --load 75% --joblog ./map.log ~/02-apcl-ddocent/APCL_analysis/scr/map.sh --> <!-- ``` -->

-   Instead of using an external script, turned it into a function.

This should take about a day to run.

``` bash
cd /data/apcl/all_samples/20181127/
map(){
bwa mem -L 20,5 -t 30 -a -M -T 10 -A 1 -B 4 -O 6 -R "@RG\tID:$1\tSM:$1\tPL:Illumina" reference.fasta $1.R1.fq.gz 2> bwa.$1.log | mawk '$6 !~/[2-9].[SH]/ && $6 !~ /[1-9][0-9].[SH]/' | samtools view -@30 -q 1 -SbT reference.fasta - > $1.bam 2>$1.bam.log

samtools sort -@30 $1.bam -o $1.bam 2>>$1.bam.log

mv $1.bam $1-RG.bam

samtools index $1-RG.bam
}

export -f map

cat namelist | parallel --load 75% --joblog ./map.log map 
```

Replace mapped bed with baits only mapped bed
---------------------------------------------

``` bash
cd /data/apcl/all_samples/20181127/
#mv mapped.bed logfiles/orig_mapped.bed
mv /local/home/michelles/02-apcl-ddocent/APCL_analysis/20181127/mapped.bed ./
```

Creating mapping intervals if needed, CreateIntervals function is defined later in script If mapping is being performed, intervals are created automatically

Does mapped.bed exits?

``` bash
cd /data/apcl/all_samples/20181127/
ls mapped.bed
ls bamlist.list
```

If mapped.bed does not exist, run this chunk, otherwise move on to the next.

``` bash
cd /data/apcl/all_samples/20181127/

ls *-RG.bam > bamlist.list

samtools merge -b bamlist.list -f cat-RRG.bam

parallel --load 75% --joblog ./interval.log "samtools index" ::: cat-RRG.bam

bedtools merge -i cat-RRG.bam -bed >  mapped.bed
```

Replace full mapped.bed with baits only mapped.bed
--------------------------------------------------

Filter out targeted SNPs *This chunk contains the same code as the script contig\_list.Rmd in the procedural notebook directory on the laptop.*

``` r
library(readr)
library(dplyr)
library(tidyr)
# get list of our selected contigs
raw_fasta <- read_lines("/local/home/michelles/02-apcl-ddocent/APCL_analysis/Pinsky_contigs1050.fasta")
names<- tibble(full = raw_fasta) %>%
  filter(grepl("dDocent", full)) %>%
  mutate(full = substr(full, 2, 100))

# get list of mapped contigs from the dDocent run
raw_bed <- read_lines("/data/apcl/all_samples/20181127/mapped.bed")
bed <- tibble(full = raw_bed) %>%
  separate(full, into = c("full", "start", "end"), sep = "\t")

# Filter mapped bed file to only keep the lines that are in the contig list
yes_bed <- bed %>%
  filter(full %in% names$full)
no_bed <- bed %>%
  filter(!full %in% names$full)

# Write the new data to a mapped.bed file
write_delim(yes_bed, path = "mapped.bed", delim = "\t", col_names = F)
write_delim(no_bed, path = "exclude.bed", delim = "\t", col_names = F)
```

Create coverage stats
---------------------

``` bash
cd /data/apcl/all_samples/20181127/
cat namelist | parallel --load 75% --joblog ./coverage.log "coverageBed -abam {}-RG.bam -b mapped.bed -counts > {}.cov.stats"

cat *.cov.stats | sort -k1,1 -k2,2n | bedtools merge -i - -c 4 -o sum > cov.stats
```

create instances
----------------

``` bash
cd /data/apcl/all_samples/20181127/
NUMProc=40

DP=$(mawk '{print $4}' cov.stats | sort -rn | perl -e '$d=.001;@l=<>;print $l[int($d*@l)]')

CC=$( mawk -v x=$DP '$4 < x' cov.stats | mawk '{len=$3-$2;lc=len*$4;tl=tl+lc} END {OFMT = "%.0f";print tl/"'$NUMProc'"}')

mawk -v x=$DP '$4 < x' cov.stats | sort -V -k1,1 -k2,2 | mawk -v cutoff=$CC 'BEGIN{i=1} 
    {
    len=$3-$2;lc=len*$4;cov = cov + lc
    if ( cov < cutoff) {x="mapped."i".bed";print $1"\t"$2"\t"$3 > x}
    else {i=i+1; x="mapped."i".bed"; print $1"\t"$2"\t"$3 > x; cov=0}
    }'
```

create a population file
------------------------

``` bash
cd /data/apcl/all_samples/20181127/

cut -f1 -d "_" namelist > p
paste namelist p > popmap
rm p
```

Create the split.\*.bam files - takes about 1/2 hour
====================================================

``` bash
cd /data/apcl/all_samples/20181127/

seq 40 | parallel --joblog ./split.log --load 75% 'samtools view -b -1 -L mapped.{}.bed -o split.{}.bam cat-RRG.bam'
```

Index the splits - takes less than a minute
===========================================

``` bash
cd /data/apcl/all_samples/20181127

seq 40 | parallel --joblog ./index.log --load 75% 'samtools index split.{}.bam'
```

Call SNPs with freebayes - this should take a little over a day for the last 2 to finish
========================================================================================

``` bash
cd /data/apcl/all_samples/20181127

# testing memfree to see if sigterm 9 can be avoided
seq 40 | parallel --joblog ./freebayes.log --load 75% --memfree 75G 'freebayes -b split.{}.bam -t mapped.{}.bed -v raw.{}.vcf -f reference.fasta -m 5 -q 5 -E 3 --min-repeat-entropy 1 -V --populations popmap -n 10'
```

Rename the single digit raw.vcf files
=====================================

``` bash
# move to the working directory
cd /data/apcl/all_samples/20181127

  mv raw.1.vcf raw.01.vcf 
    mv raw.2.vcf raw.02.vcf 
    mv raw.3.vcf raw.03.vcf 
    mv raw.4.vcf raw.04.vcf 
    mv raw.5.vcf raw.05.vcf 
    mv raw.6.vcf raw.06.vcf 
    mv raw.7.vcf raw.07.vcf 
    mv raw.8.vcf raw.08.vcf 
    mv raw.9.vcf raw.09.vcf 
```

Combine all of the raw vcfs into a total raw snps file
======================================================

``` bash
# move to the working directory
cd /data/apcl/all_samples/20181127

vcfcombine raw.*.vcf | sed -e 's/   \.\:/   \.\/\.\:/g' > TotalRawSNPs.vcf
```

Move all of the raw vcfs into their own folder
==============================================

``` bash
# move to the working directory
cd /data/apcl/all_samples/20181127

mkdir raw.vcf
mv raw.*.vcf ./raw.vcf
```

TotalRawSNPs.vcf should be ready for filtering
==============================================
