**This protocol assumes that you have read and understand the manufacturer’s instructions attached below.  Please read the full manufacturer’s instructions before using this abbreviated protocol.**

## Day 1
*It takes about 2 hours to load fins into a plate.*

Make a plan/map of where samples will be in a 96-well plate, either by hand or using the [plan extraction script](https://github.com/mstuart1/laboratory/blob/master/scripts/1_prep_samples_for_extraction.R) 

Place 2 vial blocks together and put the samples to be extracted in the vial blocks relative to the location they will hold on 
the plate.  It may help to tape off the wells that correspond to a 96 well plate. Remember to leave room for 2 negative controls!!!

Label the front of the blue collection vial tray as well as the front of the collection vials 1-12.  These vials do come out of the tray and can get mixed up. It’s also good to be able to tell the front of the tube strip from the back (the A row from the H row).

Turn on the incubator (56˚C).

Prepare lysis buffer - see [PCR worksheet](https://docs.google.com/spreadsheets/d/1LGt2WziwmGoJMluBcwmKfhZrGjZOlJLkVHf59-5cOV4/edit?usp=sharing)

Example table:

number of samples|10% error|ml proteinase K|ml ATL buffer
---|---|---|---
192|211.2|4.224|38.016

Double check the sample numbers, comparing to map/plan as you go.

Place tube strip in an extra plate holder so that you can easily see the fins in the tubes.

Add fin clips, sterilizing forceps between each sample by placing in a beaker of EtOH, removing from beaker, and passing through flame. 

Add 200µL lysis buffer as soon as each strip is finished, make sure fins are completely submerged (cut if necessary, wash scissors between each sample).

Cap tubes immediately after adding buffer, place tab of cap strip to the back of the plate.

When plate is finished, roll caps with plate roller, push down with force.

When 2 plates are finished, double check that caps are firmly in place, invert to mix, spin down

Place in 56˚C incubator overnight.  Placing 5 lab notebooks on top of plate still allowed caps to raise out of tubes while incubating.

*After proteinase K digestion, tissue samples can also be stored in Buffer ATL for up 6 months at ambient temperature without any reduction in DNA quality.*

When done wipe down forceps and scissors with bleach and put in drawer

## Day 2
Set the centrifuge temp to 40˚C

Check AL buffer, AW1 buffer and AW2 buffer - add EtOH if needed

After overnight lysis, make sure caps are firmly in place.  Most often the caps will have lifted out of the tubes so handle the plate carefully
and gently replace caps.  Allowing the plate to cool to room temperature sometimes helps the caps fit back into the tubes.

Shake tightly sealed plate vigorously for 15s, quick spin down.

Carefully remove caps to avoid contamination and add 410µL (2x205) AL buffer

Add new caps, make sure they are on firmly, and shake vigorously 15s, quick spin to 3000rpm

Label spin column plates and set on top of s-blocks

Transfer samples from collection tubes to spin columns, including any white ppt that formed.

Seal plates and spin 10 min at 6000rpm (if any liquid remains in the spin column, spin another 10 minutes)

Add 500µL AW1, seal w/ tape, spin  5 min @ 6000rpm

Add 500µL AW2, do not seal with tape, spin 15 min @ 6000rpm

Place spin plate on blue elution plate, add 200µL AE buffer

Incubate at room temp 1 min

Spin 2 min @ 6000 rpm

Place spin filter plate on a sterile, fresh 96 well plate 

Transfered elute from blue elution plate back up to spin column

Incubate @ room temp 1min, spin 2 min at 6000 rpm

Transfer samples from the qiagen elution plates into 96 well plates, seal with PCR film, label the plate with Extraction Numbers, date, and initials, and store in the fridge.

Discard solution in S-plate and 3x rinse

## Afterwards

Update the database with the date of extraction and removing the "waiting to be extracted" notes using the [changedb.R script](https://github.com/mstuart1/laboratory/blob/master/scripts/changedb.R) 

[Run a gel]  to check quality of DNA extraction.  Use the changedb.R script above to add the date of gel to the database.

Use the plate reader to check the quantity of DNA extraction.  Use the platereadertodb.R script to add the quantity to the database.
