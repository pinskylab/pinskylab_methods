This protocol assumes that you have read and understand the manufacturer’s instructions attached below.  Please read the full manufacturer’s instructions before using this abbreviated protocol.

When a new package of Quant-IT PicoGreen dsDNA assay (Fisher P7589)	is opened, make the 20x TE buffer into 1x TE buffer.
(Always measure the provided TE in a graduated cylinder, don’t assume the number on the bottle is correct!)

Example calculation:
12.7 mL 20x TE  = 254mL 1x TE

254-12.7=241.3mL dH2O

See PCR worksheet “quantification” in google drive for the math below: (https://docs.google.com/spreadsheets/d/1LGt2WziwmGoJMluBcwmKfhZrGjZOlJLkVHf59-5cOV4/edit?usp=sharing)

Example table:

lambda DNA (ug/ml)|volume of standard needed (uL)|number of plates
---|---|---
100|600|3


STD| initial conc (ug/ml)|initial volume (ul)|	add TE (ul)|	final conc in lab (ug/ml)	|final volume in lab (ul)	|final conc in plate (ug/ml)
---|---|---|---|---|---|---
STD 1|	100	|24	|1176|	2	|1200|	1
STD 2 |	2|	120|	1080|	0.2|	1200|	0.1
STD 3	|2	|12|	1188|	0.02|	1200|	0.01
STD 4	|0|	0|	1200|0	|	1200|	0


						
number of samples|	10% error|	# of standards	|10% error|	total wells with error|	total amount of TE buffer for analysis
---|---|---|---|---|---
152	|167|	24|	26|	194	|40460	
						
amount of pico dilution|	amount of pure pico|	amount of 1x TE buffer for pico	
---|---|---
19360|	96.8|	19263				



- [ ] Make TX STD #1 according to table above

- [ ] Make Pico dilution (1/200) for all wells according to table above

- [ ] Make STD #2 according to table above

- [ ] Make STD #3 according to table above

- [ ] Make STD #4 according to table above

- [ ] Add 99µL 1xTE to **sample** wells of plate

- [ ] Add 100µL STDs to first free column of plate (1,2,3,4,1,2,3,4)

- [ ] Add 1µL sample to sample wells

- [ ] Add 100µL 1/200 pico dilution to all wells; pipet up and down to mix

- [ ] Incubate at room temp 5 minutes in the dark

At the plate reader:

- Turn on the unit and let warm up for at least 5 min
- Open SoftMax Pro
- Open Michelle's folder (Desktop>bidle>My Documents>Michelle) and open the saved protocol "Pico"
- Double check that the standards are correct by clicking on the Plate in the navigation tree, clicking on the "plate" icon (just after the wand and the orange bubbles), clicking on the blue standard wells and making sure the values match the way you set up the plate.
- Click Read - if it isn't there, make sure the spectramax is detected
- It will ask you if you want to replace data in plate 1, click OK
- When it is done, check standard curves to make sure the plate ran ok, if you can eliminate a bad standard and re-run, do so.
- click save as...and then export...and then pop in your new plate and hit read again.

Back at the lab, processing the data:

- Upload files to Plate Reader folder in Google Drive (you cannot work with them through Google Drive, this is just for storage)
- Open .txt files in Numbers (or even better, Excel)
- Open Sample_Data file in Google Drive
- Copy AdjConc column from the Numbers file into the appropriate sample’s Quant_ng/ul column
- Set up the Digests sheet to receive these samples, conditional format for samples that will not produce 1µg DNA and samples that will produce more than 5µg.

To set up a new protocol on a new plate reader using SoftMaxPro software:
Click settings:
Click FL (flourescence) for Read Mode
Read type is endpoint
Wavelengths:  1 pair
Excitation: 490
Emission cutoff (not auto): 515
Emission: 525

Plate type: 96 well standard opaque

PMT and optics:
PMT gain: automatic
Flashes per read: 6
Shake before first read 10 sec

Click the wand to configure plate layout:
1st column, standards:
Highlight the first 4 cells, click series
Make sure the plate direction is top to bottom, x and y directions are 1 well each,
Standard value is checked
Starting value is 1.0ug/ml
Step by / 10
Change well 4 to zero (and well 8)

Highlight all of the sample cells, Make sure it says unknowns, click series, make sure it is top to bottom and the x and y directions are 1 well each
check dilution factor
Starting value 200, step by / 1 and click ok

Plate reader software:
click on the little plate grid to edit plate layout
Select first cell and make standard
2nd std
3rd std
4th std
copy and paste the 4 standards down into the next 4 wells

highlight all of the sample wells
select series, 1 x 1, 200 dilution factor / 1
Run
Save as
Export
For next plate hit run, it will ask you if you want to overwrite data, select yes

