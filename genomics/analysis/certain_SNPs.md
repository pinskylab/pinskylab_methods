To pull a certain list of SNPs out of a vcf file:

1. Open a text file of dDocent contig names and make sure the format is:
dDocent_Contig_2432 136
If it isn’t, if there are commas, search for comma and replace with nothing.  If there is an underscore between the final 2 numbers, regex search: (_)(\d+\n) and replace with  /2 (there is a space in front of the /2).  That will split out the position from the name regardless of the number of digits present.

2. In the amphiprion folder that contains your TotalRawSNPs.vcf file, open a nano and copy and paste the contig names into the nano, save as **some_name.txt**
3. Run the command line: vcftools --vcf TotalRawSNPs.vcf --positions **some_name.txt** --recode --recode-INFO-all --out **some_out_name**
4. Convert the output vcf to a genepop by using the command line: vcf2genepop.pl vcf=**some_out_name.recode.vcf** > **some_out_name.gen**
