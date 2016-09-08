- In Windows,
- Log in to windows using the larva password
- Start Cervus
- Click on Tools>Convert Genotype File>Genepop to Cervus

    - 2 digit format
    - do not use first ID as population name

        - "Converted 192 individuals in one population at 1132 loci"
- Click on Analysis>Allele Frequency Analysis

    - Choose the cervus file just created by conversion
    - top two options stay checked (header row, read locus names)
    - ID in column 2
    - First allele in column 3
    - Number of loci listed in the conversion step
    - Save as input_file_name_AF
    - OK
- Now run a simulation of parentage analysis

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
- Create parent and offspring files: To make an adult/juvenile file
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
- run identity and eliminate individuals that have 2 APCL ID’s in the parent/offspring files (???) - this is from the note 2015-05-14 Thursday

    - Click on Analysis -> Identity Analysis

        - Gene pop file and allele frequency info will be automatically populated, should match what you’ve done for those steps
        - Save as input_filename_ID
        - Minimum number of matching loci 80% of the total loci
        - Allow fuzzy matching with 10% of the total loci
- filter by ID and count the number of offspring a fish has
