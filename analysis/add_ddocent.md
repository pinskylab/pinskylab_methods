Based on the previous steps taken, at this point there should be a working directory called "samples" that contains all of the renamed output of process_radtags in the format of APCL_L3041.fq.gz.

1. Copy in reference.fasta from original dataset

`cp ~/02-apcl-ddocent/APCL_analysis/16-03seq/reference.fasta ./samples`

2. Type dDocent on the command line of your working directory

`dDocent`
    - You will be asked a series of questions.
    
    - ## individuals are detected. Is this correct? Enter yes or no and press [ENTER]
    
    - Please enter the maximum number of processors to use for this analysis.

        - We have 40 total processors on amphiprion.   Be kind to others who may want to use amphiprion and only use 20 (unless you know for sure you are the only one currently using the machine, but never use more than 35).
    
    - Please enter the maximum memory to use for this analysis.

        - 0
    
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

4. Symlink the *.F.fq.gz, *.R1.fq.gz, *-RG.bam, and *-RG.bam.bai files to the main analysis folder from the final destination APCL_analysis/17_03seq - **Symlinking must be done from within the destination directory**

`mkdir 17-03seq`

`ln -s ../../17seq/samples/APCL* ./`

`ln -s ../../16seq/samples/APCL* ./`

`ln -s ../../15seq/samples/APCL* ./`

`ln -s ../../13seq/samples/APCL* ./`
 
`ln -s ../../12seq/samples/APCL* ./`

`ln -s ../../09seq/samples/APCL* ./`

`ln -s ../../08seq/samples/APCL* ./`

`ln -s ../../07seq/samples/APCL* ./`

`ln -s ../../05seq/samples/APCL* ./`

`ln -s ../../04seq/samples/APCL* ./`

`ln -s ../../03seq/samples/APCL* ./`


5. Run the script [call_SNPs.sh](https://github.com/stuartmichelle/Genetics/blob/master/code/call_SNPs.sh) which calls freebayes from the command line instead of using dDocent.  Currently, dDocent is creeping up in memory usage as it goes through the files until the system crashes after 8 days.  This alternate script only uses 4G of memory and finishes in about 2 days.

        
[Return to analysis protocol](./hiseq_ddocent.md)

