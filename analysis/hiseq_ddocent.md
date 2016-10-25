It is good to be comfortable with command line processes before beginning sequencing analysis. Codecademy ([https://www.codecademy.com/en/courses/learn-the-command-line]) has a very great introductory command line tutorial that will help you dive into these processes.  The python tutorial is also great for learning how to develop your own scripts.

Jon Puritz has a great tutorial that explains the inner workings of the dDocent pipeline, but that also has great tools for command line analysis of sequencing files and graphing on his github, to download it into your amphiprion account, type:
`curl -L -O https://github.com/jpuritz/dDocent/raw/master/tutorials/RefTut`

1. [Prepare the analysis space on the server](./prep_seq_space.md) - takes about 1.5 hours


    - If this is a miseq run, you can skip barcode splitter and move on to process radtags.  If this data is from hiseq, run barcode splitter

2. [Barcode splitter](./barcode_splitter.md) - takes about 8 hours for 2 lanes and 192 samples

    - If this is a paired end sequencing run, the inputs of process radtags will be different from the ones listed below.  A paired end run hasn’t been done in long enough time that a discussion should be had before proceeding.  If the current run is of single end reads, proceed with confidence.
    
3. [Process radtags](./process_radtags.md) - use esc-R or ctrl-\ to "find and replace" in nano - takes about 2.5 hours for 4 pools and 192 samples

