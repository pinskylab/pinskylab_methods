Pinsky Lab Cookbook
================

This document exists to share institutional knowledge for obstacles that
are commonly run into by Pinsky Lab Members. The struggle is real\!

# Github

## Archiving a Git repo with Zenodo for a publication
This will likely evolve, but our current approach is to

1. Mint a version in github with the latest state
2. Clean out all the extraneous stuff
3. Make sure the Readme is very, very clear about which files were used to create which figures, tables, results, etc., and where to get any data not in the repo.
4. Mint a publication-ready version and link this to Zenodo (instructions [here](https://guides.github.com/activities/citable-code/))

Some of our examples: 
- https://github.com/pinskylab/hotWater
- https://github.com/pinskylab/ClimateAndMSP
- https://github.com/pinskylab/Clownfish_persistence

## How to add undergrads to the Pinsky Lab github.

1.  Make sure the undergrad has signed up for github and note whatever
    email they used to sign up.
2.  Create the repository on github, this should be the project that
    they are working on.
3.  Invite the undergrad as a collaborator.

## How to get RStudio and github to talk to each other

1.  Create a repository on github, copy the URL.
2.  Create a new project in RStudio and paste in the URL from github

## How to move an existing project on github into RStudio

1.  Copy the URL from github for your repository.
2.  On your computer, add “\_old” to the end of the name of your folder.
3.  Create a new project in Rstudio and paste in the URL from github
    with the normal folder name.
4.  Open the “old” folder, copy all, open the new folder, paste
all.

## How to transfer ownership of a repository from personal to pinskylab in github

1.  Click on the repository in github
2.  Click on “settings” in the upper middle right.
3.  Scroll down to click on “transfer ownership”.

## How to connect to one script in someone else’s github repo

1.  Go to the webpage that contains the script.
2.  Click on RAW and then copy the URL.
3.  In
R:

<!-- end list -->

``` r
script <- RCurl::getURL("https://raw.githubusercontent.com/pinskylab/pinskylab_methods/master/genomics/scripts/field_helpers.R", ssl.verifypeer = FALSE)
eval(parse(text = script))
```

## How to connect amphiprion Rstudio server to existing github repo

1.  Follow githubs directions for setting up [SSH
    keys](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/).
2.  On the command line on amphiprion, type the SSH connection:

<!-- end list -->

``` bash
git clone git@github.com:user_name/repo_name.git
```

1.  Open the the project file in the RStudio server for amphiprion in
    your web browser. If you need the web address for the RStudio
    server, email Michelle.

## If RStudio is not recognizing git on your machine

[Try this helpful set of
steps](https://happygitwithr.com/rstudio-see-git.html)

## How to use the command line to connect your current folder to an existing github repo.

1.  Open command line and navigate to the folder you want to connect to
    your github repo.
2.  On the command line, type:

<!-- end list -->

``` bash
# set the new remote
git remote add origin url_of_github_repo

# verify that it worked
git remote -v 

# pull from the remote
git pull origin master

# put to the remote
git push origin master
```

## If you made a commit that won’t push to Github (too large files or something else)…

  - Make a copy of your new files/versions and put the copy in a
    different folder, like your Desktop.

  - on the command line, type `git reset --soft origin/master` or `git
    reset --mixed` or `git reset --hard` depending on how nuclear you
    need to go with your reset, “hard” will delete the most information.
    
      - replace master with whatever branch you are working on if it is
        not the master.
      - This command restores your local version of the repository to be
        identical with the web version.
      - You still need to figure out what to do with the new versions
        that won’t push to github.  
      - Good advice [about the 3 trees of
        git](https://www.atlassian.com/git/tutorials/undoing-changes/git-reset).

## Call data from a GitHub repo directly into R

The url was copied by right clicking on “View Raw” for the data file in
question and selecting “Copy Link”

``` r
# download the file
download.file(url = "https://github.com/pinskylab/genomics/blob/master/data/fish-obs.RData?raw=true", destfile = "fish-obs.RData")

# read in the data
fish_obs <- readRDS("fish-obs.RData")

# delete the file
file.remove("fish-obs.RData")
```

## Allow others to view html versions of your code.

If you want to share plots with collaborators quickly, one way is using
an Rmarkdown (Rmd) document and html output. 1. Create a branch called
gh-pages.  
2\. Checkout that branch in RStudio.  
3\. Knit your Rmd to html using output: html\_document or
html\_notebook. 4. Push your html document to github. 5. Wait for github
to process the new web page (this could take 5 minutes). 6. Go to
your-github-username.github.io/your-repo-name/html-file-name.html.

# R

## How to install an older version of a package than the one currently installed.

Based on this
[article](https://support.rstudio.com/hc/en-us/articles/219949047-Installing-older-versions-of-packages)

``` r
devtools::install_version("ggplot2", version = "0.9.1", repos = "http://cran.us.r-project.org")

packageurl <- "https://github.com/thomasp85/gganimate/archive/v0.1.1.tar.gz"
install.packages(packageurl, repos=NULL, type="source")

packageloc <- "~/Downloads/gganimate-0.1.1/"
install.packages(packageloc, repos = NULL, type="source")
```

## Install new version of R in your local directory on Amphiprion using miniconda

Based on an email from Rob Muldowney to Malin about getting the rstan
package to run on Amphiprion

The installation will change your `.bashrc` file if you allow it which
will always open your login in the conda environment. Personally I don’t
like this so I recommend backing up the file and then restoring it. So…

Download:
<https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh>

``` bash
cp .bashrc  .bashrc_orig
bash https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
(say yes to the .bashrc change)
cp .bashrc .bashrc_conda
cp .bashrc_orig .bashrc
```

When you want to run conda:

``` bash
source .bashrc_conda
```

While in conda:

``` bash
(sudo)apt install R
```

Say yes to everything- this will install all the necessary dependencies.

When done type R to start R. This will display some text and give you an
R prompt.

While in R:

``` r
install.packages('rstan')
```

This will take a while.

When done- while in R:

``` r
library('rstan')
```

## Convert a table from long format to wide format or vice versa

Tutorial slides are
[here](https://speakerdeck.com/yutannihilation/a-graphical-introduction-to-tidyrs-pivot-star).

More info
[here](http://www.storybench.org/pivoting-data-from-columns-to-rows-and-back-in-the-tidyverse/)

Make sure you are running at least tidyr 1.0.0 to use this version,
which is an update from spread and gather. This is great if you want to
convert row values into column headers or column headers into row
values. MRS is testing using it to add absence data in presence absence
data sets.

## Working with strings

How to find and replace a digit/character combination using stringr (in
the tidyverse library). In this example, we have used parentheses to
create 2 groups and we are replacing the whole with only the second
group

``` r
library(stringr)
str_view(fruit, "(..)\\1", match = T)

#test <- "0_5" - should return 5
test <- "10_15" - should return 15

str_replace(test, "(\\d+\\_)(\\d+)", "\\2")

# Can use str_view(test, "(\\d+\\_)(\\d+)") to see what stringr is seeing.
```

# R Spatial

## How to calculate the distance between two sets of points

``` r
# create pairwise distance matrix between two sets of points (list1, list2) in meters using the function distVincentyEllipsoid
# the WGS84 ellipsoid is used by default, as it's the best available global ellipsoid
# can change the a, b, and f parameters for a desired ellipsoid
# see ?distVincentyEllipsoid for details
library(geosphere)
mat <- distm(list1[,c('longitude','latitude')], list2[,c('longitude','latitude')], fun=distVincentyEllipsoid)

# Create a distance column in meters from a data.frame that has both points 
loc.df$dist <- distGeo(loc.df[,c('lon1', 'lat1')], loc.df[,c('lon2', 'lat2')])
```

See
[script](https://github.com/pinskylab/Phils_GIS_R/blob/master/scripts/calc_distance_matrix.R)

# Plots

## How to change the angle of your x-axis labels in ggplot

MRS found the answer
[here](https://www.datanovia.com/en/blog/ggplot-axis-ticks-set-and-rotate-text-labels/)
where p is the plot you’ve been working on

``` r
p + theme(axis.text.x = element_text(angle = 90))
```

## How to save an R plot as a pdf (when using ggplot) - 3 different ways

  - Save the last plot created into working directory.

<!-- end list -->

``` r
ggplot2::ggsave("filename.pdf")
```

  - Save the object called plot into the working directory.

<!-- end list -->

``` r
ggplot2::ggsave(plot, "filename.pdf")
```

  - Save the object called plot into the plots folder that is closest to
    your working directory.

<!-- end list -->

``` r
ggplot2::ggsave(plot, here::here("plots", "filename.pdf"))
```

# Sequencing

## How to calculate sequencing coverage

The calculation is slightly different if you are doing RADSeq vs. whole
genome sequencing.

For whole genome sequencing, number of base pairs is important. To
determine the number of runs needed for whole genome
sequencing:

![{number<sub>of</sub>individuals<sub>\*</sub>number<sub>of</sub>bp<sub>in</sub>the<sub>genome</sub>\*<sub>coverage</sub>\*<sub>}\\frac{1}{number</sub>of<sub>bp</sub>per<sub>read}</sub>\*<sub>\\frac{1}{number</sub>of<sub>reads</sub>per<sub>run}</sub>=<sub>number</sub>of~runs](https://latex.codecogs.com/png.latex?%7Bnumber~of~individuals~%2A~number~of~bp~in~the~genome~%2A~coverage~%2A~%7D%5Cfrac%7B1%7D%7Bnumber~of~bp~per~read%7D~%2A~%5Cfrac%7B1%7D%7Bnumber~of~reads~per~run%7D~%3D~number~of~runs
"{number~of~individuals~*~number~of~bp~in~the~genome~*~coverage~*~}\\frac{1}{number~of~bp~per~read}~*~\\frac{1}{number~of~reads~per~run}~=~number~of~runs")

For ddRADSeq or other partial sequencing techniques where the sequencer
always starts at the beginning of the contig of interest, number of
reads replaces basepair numbers. To determine the number of
runs:

![{number<sub>of</sub>individuals<sub>\*</sub>coverage<sub>\*</sub>}\\frac{1}{number<sub>of</sub>bp<sub>per</sub>read}<sub>\*</sub>\\frac{1}{number<sub>of</sub>reads<sub>per</sub>run}<sub>=</sub>number<sub>of</sub>runs](https://latex.codecogs.com/png.latex?%7Bnumber~of~individuals~%2A~coverage~%2A~%7D%5Cfrac%7B1%7D%7Bnumber~of~bp~per~read%7D~%2A~%5Cfrac%7B1%7D%7Bnumber~of~reads~per~run%7D~%3D~number~of~runs
"{number~of~individuals~*~coverage~*~}\\frac{1}{number~of~bp~per~read}~*~\\frac{1}{number~of~reads~per~run}~=~number~of~runs")

Also, [check out this
pdf](https://github.com/pinskylab/pinskylab_methods/blob/master/genomics/coverage_calculation.pdf)

# Video Conferencing

## google hangout for lab meetings

<https://bit.ly/fishbaste>

## How to set up the ENR 145 TV for video conference.

  - Turn on the computer (on the shelf below the TV)  
  - Turn on the TV
  - Switch the source using the input button on the remote to HDMI1 (the
    top port is broken as of March 2019, so you may have to move the
    cord to the bottom port)
  - Log in to the DEENR admin or Online user account. You can find the
    password on our Pinsky Lab Meeting Google Sheet.
  - Open chrome and navigate to the fish baste link. You can find the
    link on our Pinksy Lab Meeting Google Sheet. Other video
    conferencing software is also available.
  - Be sure to log out of Skype/Google/etc when you’re done.
  - Log out of the Windows user account.
  - Turn off computer and TV.

# Remote access to lab computers

## How to access a lab computer from a chromebook

On lab desktop: - Open Chrome and go to chrome.google.con/remotedesktop
- Select “Add to Chrome” and “Add app.” - Log onto the Admin account and
open the Chrome Remote Desktop app. This will be under “Chrome Apps” in
“All Programs.” - Two windows will open - go to the smaller of the two
that says “Chrome Remote Desktop” and click “Continue” in order to
authorize sharing access. - Under “My Computers,” click “Enable remote
connections.”

On chromebook: - Open Chrome Remote Desktop app.

# Using Rutgers Box for storage to use on cluser computers

**Instructions for annotate [here](https://box.rutgers.edu/linux/)**

Hi,

As you may know, storage in box.rutgers.edu is unlimited, but the max size for files stored there is 15 GB (see the bottom portion of this message for a way to deal with that). The pace of data transfer to Box from Amarel’s login nodes isn’t fast (about 10-12 MB/sec), but if you’re not in a rush, it’s a good place to store data long-term.
 
There are a few different ways to move data to/from box.rutgers.edu. I use a utility named rclone and below I’ve detailed how I set it up and use it from Amarel. You’ll need to open the Firefox browser on Amarel as part of the setup procedure, so connecting via ssh with the -X or -Y option will be needed. Alternatively, if you can’t tunnel a GUI through SSH to your terminal, you can complete the setup within an Amarel Desktop session using OnDemand. This procedure may seem a bit long and complicated. If it seems like you need help, we’d be happy to sit beside you and walk through it with you.

Galen
 
*Setting-up rclone:*

## First, connect to Amarel with X11 tunneling enabled (i.e., using the -X or -Y option). If you’re off-campus, you’ll need to connect to the campus VPN first (see https://soc.rutgers.edu/vpn for details):
 
ssh -Y [NetID]@amarel.rutgers.edu
 
## Launch Firefox on Amarel. Doing this now ensures that this part works before you get too far along in these instructions. Be sure to include the “&” so you can continue using your terminal window.
 
firefox &
 
## When the Firefox browser window appears on your local desktop, it may be unresponsive for a few moments (maybe minutes). Just let it sit there and finish loading. Go back to your terminal window.
 
## Next, load the rclone module by running these commands in your terminal window,
 
module use /projects/community/modulefiles
module load rclone/1.49.5-188-g8c1edf41-beta-gc56
 
## Setup a new remote connection:
 
rclone config
 
# Enter the letter “n” for new and provide a name for your connection. For this example, I’ve named mine “amarel-box”
# For the storage type, enter “6" for Box:
Storage> 6
 
# You’ll be asked for a Box client ID and secret word. Just press “Enter” to leave these fields blank:
client_id>
client_secret>
 
# Edit advanced config? (y/n) Choose “No”
y) Yes
n) No
y/n> n
 
# Use auto config? Choose “Yes”
y) Yes
n) No
y/n> y
 
## Now, rclone will be waiting for an access code. You’ll have to go to your Firefox browser window in your OnDemand Desktop session to retrieve it. The http://127.0.0.1:53682/auth page should load automatically (just wait for it).
 
## Firefox will open a Box/rclone “Customer Login Page” (see attached). Displaying the Firefox window on your local machine may be slow. Be patient.
## When it appears, choose “Use Single Sign On (SSO)” then enter you e-mail address. I used my galen.collier@rutgers.edu address. Then click “Authorize.” You’ll be redirected to the Rutgers Central Authentication Service page where you’ll enter your NetID and password.
 
## If that process is successful, you’ll then see a button in that browser window for “Grant access to Box.” If you see the “Success!” message, you can close that browser window and return to the terminal.
 
## In the terminal, you’ll see that an access token has been provided. Enter “y” to accept that token.
 
## At this point, you’re done and can enter “q” to quit the connection setup.
 
## Now, you’re ready to use rclone for moving file to/from your box.rutgers.edu account. Note: data transfer performance when using rclone will likely be best on the Amarel login nodes. Here are some example commands where the name of my remote Box connection is “amarel-box”:
 
# List directories in top level of your Box (note the “:” at the end)
rclone lsd amarel-box:
 
# List all the files in your Box (note the “:” at the end)
rclone ls amarel-box:
 
# To copy a local (Amarel) directory to Box and name it “my-work-dir-backup”:
rclone copy my-work-dir amarel-box:my-work-dir-backup
 
## There is a full list of rclone commands here: https://rclone.org/commands/
 

*The 15 GB file size limit imposed by Box can be accommodated by splitting large files. For example,*
 
## Here’s how I split-up a large file that’s too big for Box into ~10 GB chunks:
split -b 10GB --additional-suffix=-foo file.txt
 
## Creates a series of smaller files named as follows:
## xaa-foo xab-foo xac-foo xad-foo xae-foo xaf-foo ...
 
## Generate a SHA512 checksum for verifying file integrity later:
sha512sum file.txt > file.txt.sha512
 
## Move those files (the split files and the checksum file) to Box using rclone for long-term storage
## Now, the original can be deleted
rm file.txt
 
## When ready to use that big file again, move the split files and the checksum back using rclone, then reassemble:
cat xa* > file.txt
 
## Now check that the reassembled file matches the original:
sha512sum --check file.txt.sha512
 
This approach requires some scripting to make it a tractable procedure for large collections of big files, but it gets the job done reliably.

# Ryan’s Advice

## Analysis

Accessing a PostgreSQL database from R on a Mac

PostgreSQL is a widely used, open-source database, and R is a widely
used, open-source statistical program. So it would be natural to put
them together, such as when working with data like these. If you work on
a Mac, though, it’s not obvious from a web search how to do so. Here’s
what worked for
us:

``` r
> install.packages(“RPpostgreSQL”) # install R package > require(“RPostgreSQL”) # load it > drv <- dbDriver(“PostgreSQL”) # start the driver for a postgreSQL database > conn = dbConnect(drv, …) # fill in the … with your database connection
```

These instructions may also be helpful:
<http://blog.chrischou.org/2010/09/07/install-rpostgresql-in-mac/>

## Configuring TextMate2 on a Mac for use with R

From Ryan Batt, our postdoc R guru extraordinaire: If you’re on a Mac
and are looking for a new text editor, I recommend TextMate 2. I know
many of you know and love RStudio – if it works for you, that’s fine,
keep using it. I’ve been using TextMate2 since alpha, and it recently
entered beta. It’s free and open source. But it’s also in development,
so there are some less-than-intuitive steps you need to take to get it
working nicely. Because I loved TextMate 1 so much, I took those steps.
I’ve compiled a set of instructions that detail the basic adjustments I
recommend you make to TextMate 2 in order to do comfortable programming
in R. A tip: I recommend making use of the project drawer:
control+alt+command+d. From there you can use Git (command+Y), create
and edit files, etc, just like you would in Finder. For the other
features, I’ll let you discover those yourself. One more tip: in the
project drawer, select any file and hit the space bar for a nice
preview. Very helpful when creating figures. Works for most file/
document types, not just images. Here are the files mentioned below, as
a .zip file. Basics

Download Textmate2 Copy from Download folder to Applications (may have
to rename or delete Textmate original) Give permission to open
Aesthetics

Add Custom Theme

Copy file “RyanMedium.tmTheme” Open TextMate, go to Bundles –\> Bundle
Editor Hit ⌘N (command+N) to create a new bundle Name bundle (right
panel, in dialog box for Name:), save with ⌘S In left panel, Right click
bundle name (eg., RyanThme), and click “show info.plist in Finder”
(note: can get there library -\> app support -\> avian -\> bundles,
right click on bundle, show pack contents) Paste file
“RyanMedium.tmTheme” Set Theme

View –\> Theme –\> RyanMedium Change Font: View –\> Font –\> Show Fonts
–\> All Fonts –\> Monaco (adjust size with hotkeys in script) Prepare
for R

Install R Bundle

Go to Preferences (command+,) and … Bundles, install R (check the box)
Under files, new document type = R Send Line/ Selection to R & Step

This is main command, lots of edits, but worth it Go to Bundles –\> Edit
Bundles, then click “R” on the left hand side, then click “Menu Actions”
to the right of that Click “Run Document / Selection in R” – on the far
right, in the “Key Equivalent” dialogue box, hit the little “x” to
remove the hotkey (note: we are going to remap this hotkey to a more
useful action) In the 3rd panel from left, click “Send Selection/Line
to”, then in the next panel to the right click “R.app & Step” Change
Key Equivalent to ⌘R In the code below that, copy in the code located in
the file “RappStep.txt” note: I recently added a changed to fix a bug
with this command losing focus, the correction was to add this to Line
16: -e ‘tell application “TextMate” to activate’
 <http://jimbarritt.com/non-random/2010/11/16/using-textmate-with-r/comment-page-1/>
Change Word Characters

Bundles –\> Edit Bundles –\> Source –\> Settings –\> ⌘N –\> select
“Settings” In far right panel, as name enter “Character Class:
wordCharacters” In text editor box, enter this exactly (without the
outer “quotes”): “{ wordCharacters = ‘.’; }” note: mind spaces, etc. If
something doesn’t work, try *not* copying from this document, and typing
yourself. hit ⌘S to save the edits to the bundle Edit R Language Grammar

Specifically, these changes will make sure TextMate recognizes
data.table as a data structure, just like matrix or data.frame Bundles
–\> Edit Bundles –\> R –\> Language Grammars –\> R Replace bottom text
with that in “rLanguageGrammar.txt” Save with ⌘S note: if you have
trouble, make sure you expand the window width when you open the .txt
file to avoid any wrapping Fix Annoying R Indenting (especially with
if(){}else{})

Bundles –\> Edit Bundles –\> R –\> Settings –\> ⌘N –\> Settings –\>
Create In the far right, in the dialogue box called “Name:”, change to
“fixIndent” In the far right, in the dialogue box called “Scope
Selector:”, type "\*" (that’s an asterisk) In the text box at the
bottom, enter the following exactly (without the outer quotes): “{
disableIndentCorrections = :true; }” ⌘S to save note: try typing
yourself isntead of copy-paste if you have problems Ensure that Focus
Returns to TextMate after ⌘R

I seem to only need to make this correction in Yosemite, but might be a
general fix if you have problem Bundles –\> Edit Bundles –\> R –\>
Language Grammars –\> R –\> Send Selection/Line to –\> R.app & Step In
the bottom text box, enter “-e ‘tell application “TextMate” to activate’
" (without the”quotes"); Save with ⌘S If you have problems, try copy and
pasting the contents of the file RappStep2.txt note: I’m not making this
change by default b/c the correction doesn’t seem to be necessary for
all setups
