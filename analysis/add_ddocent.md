Based on the previous steps taken, at this point there should be a working directory called "samples" that contains 

- copy in reference.fasta from original dataset
- Type dDocent on the command line of your working directory

- $ dDocent
- You will be asked a series of questions.
    - ## individuals are detected. Is this correct? Enter yes or no and press [ENTER]
    - Please enter the maximum number of processors to use for this analysis.

        - We have 40 total processors on amphiprion.   Be kind to others who may want to use amphiprion and only use 20 (unless you know for sure you are the only one currently using the machine, but never use more than 35).
    - Please enter the maximum memory to use for this analysis.

        - We have 264G memory total.  If you enter 0, it will use all available memory that it needs to complete the task. Leaving 50G available for others is being a good community member.
    - Do you want to quality trim your reads?

        - Yes
    - Do you want to perform an assembly?

        - No
    - Do you want to map reads?

        - Yes
    - BWA will be used to map reads.  You may need to adjust -A -B and -O parameters for your taxa.Would you like to enter a new parameters now? Type yes or no and press [ENTER]

        - no
    - Calling_SNPs?

        - No
    - Email

        - your.email@rutgers.edu

When dDocent has finished, change directories to the main analysis folder which contains all of the symlinks for all of the seq files in the project and call SNPS:

symlink the *.F.fq.gz, *.R1.fq.gz, *-RG.bam, and *-RG.bam.bai files to the main analysis folder from the final destination
APCL_analysis/16_03seq $ ln -s ../../03seq/samples/APCL* ./

If dDocent 2.23 is installed on the system,

- In the main analysis folder where there are symlinks to all of the files for all of the individuals in your analysis type:

    - $dDocent

- You will be asked a series of questions.
    - ## individuals are detected. Is this correct? Enter yes or no and press [ENTER]
    - Please enter the maximum number of processors to use for this analysis.

        - We have 40 total processors on amphiprion.   Be kind to others who may want to use amphiprion and only use 20 unless you know for sure you are the only one currently using the machine, but never use more than 35.
    - Please enter the maximum memory to use for this analysis.

        - Enter 0.
    - Do you want to quality trim your reads?

        - No
    - Do you want to perform an assembly?

        - No
    - Do you want to map reads?

        - No
    - Calling_SNPs?

        - Yes
    - Email

        - your.email@rutgers.edu

If dDocent 2.18 is installed on the system,

- Make sure a copy of the reference.fasta file is in the analysis directory
- make a popmap
    - michelles 2016-06-28 09:47:02 28-06-2016 $ cut -f1 -d "_" namelist > p

        - for APCL, it is better to use cut -f1 -d “1” namelist >p (this preserves the pinsky lab way of naming samples)
    - michelles 2016-06-28 09:48:1028-06-2016$paste namelist p > popmap
    - michelles 2016-06-28 09:48:1128-06-2016$rm p
- Make a bamlist (instant) (making a bamlist from symlinks causes strange characters to appear in the bamlist.list, this can be avoided by appending the *-RG.bam onto preexisting bamlist.list (code not shown here):
    - michelles 2016-06-28 09:51:59 28-06-2016 $ ls *-RG.bam > bamlist.list
- Create the intervals - updated July 2016 -
    - bamtools merge -list bamlist.list -out cat-RRG.bam &>/dev/null
samtools index cat-RRG.bam
wait
bamToBed -i cat-RRG.bam > map.bed
bedtools merge -i map.bed > mapped.bed
- estimate the coverage of reference intervals and remove intervals in 0.01% depth
    - coverageBed -abam cat-RRG.bam -b mapped.bed -counts > cov.stats
- create mapped.*.bed files - this code chops up the mapped.bed file into ~1000 smaller files based on the coverage statistics.  Chopping into a larger number did not use less memory:
    - DP=$(mawk '{print $4}' cov.stats | sort -rn | perl -e '$d=.005;@l=<>;print $l[int($d*@l)]')
CC=$( mawk -v x=$DP '$4 < x' cov.stats | mawk '{len=$3-$2;lc=len*$4;tl=tl+lc} END {OFMT = "%.0f";print tl/1000}')

    -  mawk -v x=$DP '$4 < x' cov.stats |sort -V -k1,1 -k2,2 | mawk -v cutoff=$CC 'BEGIN{i=1}
        {
        len=$3-$2;lc=len*$4;cov = cov + lc
        if ( cov < cutoff) {x="mapped."i".bed";print $1"\t"$2"\t"$3 > x}
        else {i=i+1; x="mapped."i".bed"; print $1"\t"$2"\t"$3 > x; cov=0}
        }'

- Run freebayes using parallel and threads - for APCL, we have found that running -n 4 is faster than running -n 10 and that -n 10 might be overkill.  -n is the number of best SNPs that are evaluated during an interval for each contig? - For the APCL dataset, it was found that using -L bamlist.list used 70G of memory for each interval, however using -b cat-RRG.bam (a merge of bam files) only uses ~4G of memory per interval.
    - $ ls mapped.*.bed | sed 's/mapped.//g' | sed 's/.bed//g' | shuf | parallel -j 3 --no-notice --delay 1 freebayes -b cat-RRG.bam -t mapped.{}.bed -v raw.{}.vcf -f reference.fasta -m 5 -q 5 -E 3 --min-repeat-entropy 1 -V --populations popmap -n 4 &
    - disown -h to be able to close the window, or ctrl-Z, bg, disown-h.
- To run individual intervals, use (replace with your own email address), for APCL these currently take about 1 hour 20 minutes:
- $ freebayes -b cat-RRG.bam -t mapped.580.bed -v raw.580.vcf -f reference.fasta -m 5 -q 5 -E 3 --min-repeat-entropy 1 -V --populations popmap -n 10 | mail -s "Process Done" michelle.stuart@rutgers.edu &

It is now safe to remove all of the interval files (although it might be best to store them away in a folder somewhere)
rm mapped.*.bed
or
mv mapped.*.bed ./mapped.bed_files/

Change all of the single digit vcf files to double digit files:
    mv raw.1.vcf raw.01.vcf
    mv raw.2.vcf raw.02.vcf
    mv raw.3.vcf raw.03.vcf
    mv raw.4.vcf raw.04.vcf
    mv raw.5.vcf raw.05.vcf
    mv raw.6.vcf raw.06.vcf
    mv raw.7.vcf raw.07.vcf
    mv raw.8.vcf raw.08.vcf
    mv raw.9.vcf raw.09.vcf

Combine all of the vcf files into one large file  (takes more than an hour):
vcfcombine raw.*.vcf | sed -e 's/    \.\:/    \.\/\.\:/g' > TotalRawSNPs.vcf

Make a raw.vcf directory and add the raw.vcf files to it:
        mkdir raw.vcf
    mv raw.*.vcf ./raw.vcf

Parse SNPS.vcf for SNPs that are called in at least 90% of individuals
    vcftools --vcf TotalRawSNPs.vcf --geno 0.9 --out Final --counts --recode --non-ref-af 0.001 --max-non-ref-af 0.9999 --mac 1 --minQ 30 --recode-INFO-all &>VCFtools.log

Check for possible errors
ERROR1=$(mawk '/developer/' bwa* | wc -l 2>/dev/null)
ERROR2=$(mawk '/error/' *.bam.log | wc -l 2>/dev/null)
ERRORS=$(($ERROR1 + $ERROR2))

Move various log files to own directory
mkdir logfiles
mv *.txt *.log log ./logfiles 2> /dev/null

Now it is time to filter the output
Filtering dDocent output Protocol
Processing Sequence files using dDocent
