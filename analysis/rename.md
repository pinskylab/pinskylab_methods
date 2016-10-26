In order to make the popmap,  dDocent looks for the "\_" in a name and everything before that is the pop name. The code used is:

`cut -f1 -d “1" namelist > p`

`paste namelist p > popmap`

`rm p`

where it takes everything before “\_” and places it in p.

dDocent requires that the name follow the format of Population_sample info, so the naming scheme of L4532 has to be converted to APCL_L4532 as an example for the clownfish project.  When creating the names file, make sure to account for this.

Rename the files using the names file in the logs directory - the names file is the sample name tab separated from the barcode assigned to that sample.  

`sh rename.for.dDocent_se_gz ../logs/names_12`

If final barcode is not getting assigned, nano the names file, get rid of the final end of line character (go to the end and backspace), and re-run.  It will look like it might not be working but “ls” will show that the final file was not renamed.

Move the named samples into the samples directory 

`mv APCL* ../samples/`

Here is an example of 4 pools being renamed, moved and the pool directories and bcsplit directories deleted:

`sh rename.for.dDocent_se_gz ../logs/names_61`

`mv A* ../samples/`

`mv process_radtags.log ../logs/process61.log`

`cd ..`

`rm -r Pool1`

`rm -r bcsplit/`

[Return to analysis protocol](./hiseq_ddocent.md)
