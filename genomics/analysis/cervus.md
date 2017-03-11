In Windows,

1. Log in to windows

2. Import the genepop file onto the machine and place it in a folder named appropriately for the project

3. Start Cervus

3. Click on Tools > Convert Genotype File>Genepop to Cervus (takes seconds)

    - 2 digit format
    
    - do not use first ID as population name
    
    - "Converted 1816 individuals in one population at 1038 loci"

4. Click on Analysis > Allele Frequency Analysis (takes seconds)

    - Choose the cervus file just created by conversion
    
    - top two options stay checked (header row, read locus names)
    
    - ID in column 2
    
    - First allele in column 3
    
    - Number of loci listed in the conversion step
    
    - Save as input_file_name_AF
    
    - Do not do Hardy Weinberg
    
    - Do not estimate null allele frequency
    
    - OK

5.  Run Identity Analysis to find recaptured fish - Click on Analysis > Identity Analysis - takes 30 seconds

    - Genotype file and allele frequency info will be automatically populated, should match what you’ve done for those steps.
    
    - Header should be checked
    
    - ID in column 2
    
    - First allele in column 3
    
    - Do not test sexes separately
    
    - Save summary output file using the same naming scheme
    
    - Minimum number of matching loci 80% of the total loci - 830
    
    - Allow fuzzy matching with 10% of the total loci - 103
    
    - Do not show all comparisons
    
6. Use the identity analysis to curate the genepop file and remove recaptured fish before running parentage.
    
    
Now run a simulation of parentage analysis

    - Click on analysis>simulation of parentage analysis>sexes of pair unknown
    - 20k offspring
    - 1000 parents
    - prop sampled 0.1
    - prop loci typed 0.75
    - mistyped 0.001
    - min typed loci 30% of total = 293
    - use LOD (not Delta)
    - relaxed 80%, strict 95%
    - options: Distributions tab:

        - LOD distrbution 100 categories, 0-100
        - table of LOD scores
    - Liklihood tab:

        - use mistyping rate as error rate in calculations
- Create parent and offspring files: [To make an adult/juvenile file](https://github.com/mpinsky/pinskylab_methods/blob/master/analysis/parentjuv.md)
- Run parentage analysis in Cervus - make sure the csv’s have unix line endings in komodo (if only 1 offspring runs, this is the problem).

    - Select Parent Pair - Sexes Unknown
    - Select the juvenile file created above

        - Does not include header row
        - Offspring ID in column 1
        - Does not include candidate parents
        - Next
    - Select parent file created above

        - Does not include header row
        - Candidate parent IDs appear as: One column for all offspring
        - Candidate ID in column 1
        - next
    - Double check that it is pointing to the correct parent_sim data
    - Save as same naming scheme you’ve been using “seq_parent"
    - For each offspring include the two most likely parents
    - Sort by Joint LOD score
    - Do not include non-exclusion probabilities
- When it is done analyze parentage csv:

    - if there is a star in the trio, pull lat long of both parents and get distances between parents as well as offspring
    - if no star in trio, look for star in either pair confidence and get distance between that parent and offspring

        - filtered first candidate pair column for stars
        - added column for offspring sample_ID and used the formula =CONCATENATE(left(A6,4),mid(A6,6,2),"_",mid(A6,8,3)) to generate sample ID from dDocent ID
        - repeated this procedure for parent candidates
        - copied and pasted values only to harden
        - copied sheet into Sample_Data to retrieve the lat longs
        - added columns for lat and long for the offspring and parent candidates
        - used the formula =index(Samples!B:B, MATCH(B55,Samples!A:A,0)) to find lat and longs for the sample ids
        - add anemone numbers

- filter by ID and count the number of offspring a fish has
