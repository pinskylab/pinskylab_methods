Pinsky Lab Cookbook
================



-   [Github](#github)
    -   [How to add undergrads to the Pinsky Lab github.](#how-to-add-undergrads-to-the-pinsky-lab-github.)
    -   [How to get RStudio and github to talk to each other](#how-to-get-rstudio-and-github-to-talk-to-each-other)
    -   [How to move an existing project on github into RStudio](#how-to-move-an-existing-project-on-github-into-rstudio)
    -   [How to transfer ownership of a repository from personal to pinskylab in github](#how-to-transfer-ownership-of-a-repository-from-personal-to-pinskylab-in-github)
    -   [How to connect to one script in someone else's github repo](#how-to-connect-to-one-script-in-someone-elses-github-repo)
    -   [How to connect amphiprion Rstudio server to existing github repo](#how-to-connect-amphiprion-rstudio-server-to-existing-github-repo)
    -   [How to use the command line to connect your current folder to an existing github repo.](#how-to-use-the-command-line-to-connect-your-current-folder-to-an-existing-github-repo.)
    -   [If you made a commit that won't push to Github (too large files or something else)...](#if-you-made-a-commit-that-wont-push-to-github-too-large-files-or-something-else...)
    -   [Roll back a git repository to a previous commit](https://stackoverflow.com/questions/4372435/how-can-i-rollback-a-github-repository-to-a-specific-commit/4372501#4372501)
    -   [Call data from a GitHub repo directly into R](#call-data-from-a-github-repo-directly-into-R)

-   [R](#r)
    -   [How to install an older verison of a package than the one currently installed.](#how-to-install-an-older-version-of-a-package-than-the-one-currently-installed)
    -   [Install new version of R in your local directory on Amphiprion using miniconda](#install-new-version-of-R-in-your-local-directory-on-Amphiprion-using-miniconda)
    -   [Working with strings](#working-with-strings)

-   [R Spatial](#r-spatial)
    -   [How to calculate the distance between two sets of points.](#how-to-calc-distance-between-points)

    
-   [Plots](#plots)
    -   [How to save an R plot as a pdf (when using ggplot) - 3 different ways](#how-to-save-an-r-plot-as-a-pdf-when-using-ggplot---3-different-ways)
-   [Sequencing](#sequencing)
    -   [How to calculate sequencing coverage](#how-to-calculate-sequencing-coverage)
-   [Video Conferencing](#video-conferencing)
    -   [google hangout for lab meetings](#google-hangout-for-lab-meetings)
    -   [How to set up the ENR 145 TV for video conference.](#how-to-set-up-the-enr-145-tv-for-video-conference.)
-   Zotero
     -  [Change keyboard shortcut in Google Docs](https://forums.zotero.org/discussion/comment/328345#Comment_328345)
- [Remote access to lab computers](#remote-access-to-lab-computers)
    - [From a chromebook](#how-to-access-a-lab-computer-from-a-chromebook)
     
This document exists to share institutional knowledge for obstacles that are commonly run into by Pinsky Lab Members. The struggle is real!

Github
======

How to add undergrads to the Pinsky Lab github.
-----------------------------------------------

1.  Make sure the undergrad has signed up for github and note whatever email they used to sign up.
2.  Create the repository on github, this should be the project that they are working on.
3.  Invite the undergrad as a collaborator.

How to get RStudio and github to talk to each other
---------------------------------------------------

1.  Create a repository on github, copy the URL.
2.  Create a new project in RStudio and paste in the URL from github

How to move an existing project on github into RStudio
------------------------------------------------------

1.  Copy the URL from github for your repository.
2.  On your computer, add "\_old" to the end of the name of your folder.
3.  Create a new project in Rstudio and paste in the URL from github with the normal folder name.
4.  Open the "\_old" folder, copy all, open the new folder, paste all.

How to transfer ownership of a repository from personal to pinskylab in github
------------------------------------------------------------------------------

1.  Click on the repository in github
2.  Click on "settings" in the upper middle right.
3.  Scroll down to click on "transfer ownership".

How to connect to one script in someone else's github repo
----------------------------------------------------------

1.  Go to the webpage that contains the script.
2.  Click on RAW and then copy the URL.
3.  In R:

``` r
script <- RCurl::getURL("https://raw.githubusercontent.com/pinskylab/pinskylab_methods/master/genomics/scripts/field_helpers.R", ssl.verifypeer = FALSE)
eval(parse(text = script))
```

How to connect amphiprion Rstudio server to existing github repo
----------------------------------------------------------------

1.  Follow githubs directions for setting up [SSH keys](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/).
2.  On the command line on amphiprion, type the SSH connection:

``` bash
git clone git@github.com:user_name/repo_name.git
```

1.  Open the the project file in the RStudio server for amphiprion in your web browser. If you need the web address for the RStudio server, email Michelle.

How to use the command line to connect your current folder to an existing github repo.
--------------------------------------------------------------------------------------

1.  Open command line and navigate to the folder you want to connect to your github repo.
2.  On the command line, type:

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

If you made a commit that won't push to Github (too large files or something else)...
-------------------------------------------------------------------------------------

-   Make a copy of your new files/versions and put the copy in a different folder, like your Desktop.
-   on the command line, type `git reset --hard origin/master`

    -   replace master with whatever branch you are working on if it is not the master.
    -   This command restores your local version of the repository to be identical with the web version.
    -   You still need to figure out what to do with the new versions that won't push to github.

Call data from a GitHub repo directly into R
-------------------------------------------------------------------------------------
The url was copied by right clicking on "View Raw" for the data file in question and selecting "Copy Link"
```
# download the file
download.file(url = "https://github.com/pinskylab/genomics/blob/master/data/fish-obs.RData?raw=true", destfile = "fish-obs.RData")

# read in the data
fish_obs <- readRDS("fish-obs.RData")

# delete the file
file.remove("fish-obs.RData")
```


R
=

How to install an older version of a package than the one currently installed.
------------------------------------------------------------------------------

Based on this [article](https://support.rstudio.com/hc/en-us/articles/219949047-Installing-older-versions-of-packages)

``` r
devtools::install_version("ggplot2", version = "0.9.1", repos = "http://cran.us.r-project.org")

packageurl <- "https://github.com/thomasp85/gganimate/archive/v0.1.1.tar.gz"
install.packages(packageurl, repos=NULL, type="source")

packageloc <- "~/Downloads/gganimate-0.1.1/"
install.packages(packageloc, repos = NULL, type="source")
```

Install new version of R in your local directory on Amphiprion using miniconda
----------------------------------------------------------------------
Based on an email from Rob Muldowney to Malin about getting the rstan package to run on Amphiprion

The installation will change your `.bashrc` file if you allow it which will always open your login in the conda environment.  Personally I don't like this so I recommend backing up the file and then restoring it.  So...

Download: https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
```
cp .bashrc  .bashrc_orig
bash https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
(say yes to the .bashrc change)
cp .bashrc .bashrc_conda
cp .bashrc_orig .bashrc
```
When you want to run conda:
```
source .bashrc_conda
```

While in conda:
```
(sudo)apt install R
```
Say yes to everything- this will install all the necessary dependencies.

When done type R to start R. This will display some text and give you an R prompt.

While in R:
```
install.packages('rstan')
```
This will take a while.

When done- while in R:
```
library('rstan'
```

Working with strings
--------------------
How to find and replace a digit/character combination using stringr (in the tidyverse library).  In this example, we have used parentheses to create 2 groups and we are replacing the whole with only the second group
```
library(stringr)
str_view(fruit, "(..)\\1", match = T)

#test <- "0_5" - should return 5
test <- "10_15" - should return 15

str_replace(test, "(\\d+\\_)(\\d+)", "\\2")

# Can use str_view(test, "(\\d+\\_)(\\d+)") to see what stringr is seeing.
```

R Spatial
=========

How to calculate the distance between two sets of points
--------------------------------------------------------
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
See [script](https://github.com/pinskylab/Phils_GIS_R/blob/master/scripts/calc_distance_matrix.R)

Plots
=====

How to save an R plot as a pdf (when using ggplot) - 3 different ways
---------------------------------------------------------------------

-   Save the last plot created into working directory.

``` r
ggplot2::ggsave("filename.pdf")
```

-   Save the object called plot into the working directory.

``` r
ggplot2::ggsave(plot, "filename.pdf")
```

-   Save the object called plot into the plots folder that is closest to your working directory.

``` r
ggplot2::ggsave(plot, here::here("plots", "filename.pdf"))
```

Sequencing
==========

How to calculate sequencing coverage
------------------------------------

The calculation is slightly different if you are doing RADSeq vs. whole genome sequencing.

For whole genome sequencing, number of base pairs is important. To determine the number of runs needed for whole genome sequencing:

![{number~of~individuals~\*~number~of~bp~in~the~genome~\*~coverage~\*~}\\frac{1}{number~of~bp~per~read}~\*~\\frac{1}{number~of~reads~per~run}~=~number~of~runs](https://latex.codecogs.com/png.latex?%7Bnumber~of~individuals~%2A~number~of~bp~in~the~genome~%2A~coverage~%2A~%7D%5Cfrac%7B1%7D%7Bnumber~of~bp~per~read%7D~%2A~%5Cfrac%7B1%7D%7Bnumber~of~reads~per~run%7D~%3D~number~of~runs "{number~of~individuals~*~number~of~bp~in~the~genome~*~coverage~*~}\frac{1}{number~of~bp~per~read}~*~\frac{1}{number~of~reads~per~run}~=~number~of~runs")

For ddRADSeq or other partial sequencing techniques where the sequencer always starts at the beginning of the contig of interest, number of reads replaces basepair numbers. To determine the number of runs:

![{number~of~individuals~\*~coverage~\*~}\\frac{1}{number~of~bp~per~read}~\*~\\frac{1}{number~of~reads~per~run}~=~number~of~runs](https://latex.codecogs.com/png.latex?%7Bnumber~of~individuals~%2A~coverage~%2A~%7D%5Cfrac%7B1%7D%7Bnumber~of~bp~per~read%7D~%2A~%5Cfrac%7B1%7D%7Bnumber~of~reads~per~run%7D~%3D~number~of~runs "{number~of~individuals~*~coverage~*~}\frac{1}{number~of~bp~per~read}~*~\frac{1}{number~of~reads~per~run}~=~number~of~runs")

 Also, [check out this pdf](https://github.com/pinskylab/pinskylab_methods/blob/master/genomics/coverage_calculation.pdf)

Video Conferencing
==================

google hangout for lab meetings
-------------------------------

[HERE](https://hangouts.google.com/call/lgyfvg5ysbhhbhyjpdmj447mcqe)

How to set up the ENR 145 TV for video conference.
--------------------------------------------------

-   Turn on the computer (on the shelf below the TV)
-   Switch the source using the input button on the remote to HDMI1 (the top port is broken as of March 2019, so you may have to move the cord to the bottom port)
-   Log in to the DEENR admin or Online user account. You can find the password on our Pinsky Lab Meeting Google Sheet.
-   Open chrome and navigate to the fish baste link. You can find the link on our Pinksy Lab Meeting Google Sheet. Other video conferencing software is also available.
-   Be sure to log out of Skype/Google/etc when you're done.
-   Log out of the Windows user account.
-   Turn off computer and TV.

Remote access to lab computers

How to access a lab computer from a chromebook
--------------------------------------------------

On lab desktop:
-   Open Chrome and go to chrome.google.con/remotedesktop
-   Select "Add to Chrome" and "Add app."
-   Log onto the Admin account and open the Chrome Remote Desktop app. This will be under "Chrome Apps" in "All Programs."
-   Two windows will open - go to the smaller of the two that says "Chrome Remote Desktop" and click "Continue" in order to authorize sharing access.
-   Under "My Computers," click "Enable remote connections."

On chromebook:
-   Open Chrome Remote Desktop app.

Ryan's Advice
---------------------------------------------------
Analysis

Accessing a PostgreSQL database from R on a Mac

PostgreSQL is a widely used, open-source database, and R is a widely used, open-source statistical program. So it would be natural to put them together, such as when working with data like these. If you work on a Mac, though, it’s not obvious from a web search how to do so.
Here’s what worked for us:
```r
> install.packages(“RPpostgreSQL”) # install R package > require(“RPostgreSQL”) # load it > drv <- dbDriver(“PostgreSQL”) # start the driver for a postgreSQL database > conn = dbConnect(drv, …) # fill in the … with your database connection
```

These instructions may also be helpful: http://blog.chrischou.org/2010/09/07/install-rpostgresql-in-mac/

Configuring TextMate2 on a Mac for use with R
-------------------------------------------------------------------
From Ryan Batt, our postdoc R guru extraordinaire:
If you're on a Mac and are looking for a new text editor, I recommend TextMate 2. I know many of you know and love RStudio – if it works for you, that's fine, keep using it. I've been using TextMate2 since alpha, and it recently entered beta. It's free and open source. But it's also in development, so there are some less-than-intuitive steps you need to take to get it working nicely. Because I loved TextMate 1 so much, I took those steps. I've compiled a set of instructions that detail the basic adjustments I recommend you make to TextMate 2 in order to do comfortable programming in R. A tip: I recommend making use of the project drawer: control+alt+command+d. From there you can use Git (command+Y), create and edit files, etc, just like you would in Finder. For the other features, I'll let you discover those yourself. One more tip: in the project drawer, select any file and hit the space bar for a nice preview. Very helpful when creating figures. Works for most file/ document types, not just images. Here are the files mentioned below, as a .zip file.
Basics

Download Textmate2
Copy from Download folder to Applications (may have to rename or delete Textmate original)
Give permission to open
Aesthetics

Add Custom Theme

Copy file "RyanMedium.tmTheme"
Open TextMate, go to Bundles –> Bundle Editor
Hit ⌘N (command+N) to create a new bundle
Name bundle (right panel, in dialog box for Name:), save with ⌘S
In left panel, Right click bundle name (eg., RyanThme), and click "show info.plist in Finder" (note: can get there library -> app support -> avian -> bundles, right click on bundle, show pack contents)
Paste file "RyanMedium.tmTheme"
Set Theme

View –> Theme –> RyanMedium
Change Font: View –> Font –> Show Fonts –> All Fonts –> Monaco (adjust size with hotkeys in script)
Prepare for R

Install R Bundle

Go to Preferences (command+,) and ...
Bundles, install R (check the box)
Under files, new document type = R
Send Line/ Selection to R & Step

This is main command, lots of edits, but worth it
Go to Bundles –> Edit Bundles, then click "R" on the left hand side, then click "Menu Actions" to the right of that
Click "Run Document / Selection in R" – on the far right, in the "Key Equivalent" dialogue box, hit the little "x" to remove the hotkey (note: we are going to remap this hotkey to a more useful action)
In the 3rd panel from left, click "Send Selection/Line to", then in the next panel to the right click "R.app & Step"
Change Key Equivalent to ⌘R
In the code below that, copy in the code located in the file "RappStep.txt"
note: I recently added a changed to fix a bug with this command losing focus, the correction was to add this to Line 16: -e 'tell application "TextMate" to activate' \ http://jimbarritt.com/non-random/2010/11/16/using-textmate-with-r/comment-page-1/
Change Word Characters

Bundles –> Edit Bundles –> Source –> Settings –> ⌘N –> select "Settings"
In far right panel, as name enter "Character Class: wordCharacters"
In text editor box, enter this exactly (without the outer "quotes"): "{ wordCharacters = '.'; }"
note: mind spaces, etc. If something doesn't work, try *not* copying from this document, and typing yourself.
hit ⌘S to save the edits to the bundle
Edit R Language Grammar

Specifically, these changes will make sure TextMate recognizes data.table as a data structure, just like matrix or data.frame
Bundles –> Edit Bundles –> R –> Language Grammars –> R
Replace bottom text with that in "rLanguageGrammar.txt"
Save with ⌘S
note: if you have trouble, make sure you expand the window width when you open the .txt file to avoid any wrapping
Fix Annoying R Indenting (especially with if(){}else{})

Bundles –> Edit Bundles –> R –> Settings –> ⌘N  –> Settings –> Create
In the far right, in the dialogue box called "Name:", change to "fixIndent"
In the far right, in the dialogue box called "Scope Selector:", type "*" (that's an asterisk)
In the text box at the bottom, enter the following exactly (without the outer quotes): "{ disableIndentCorrections = :true; }"
⌘S to save
note: try typing yourself isntead of copy-paste if you have problems
Ensure that Focus Returns to TextMate after ⌘R

I seem to only need to make this correction in Yosemite, but might be a general fix if you have problem
Bundles –> Edit Bundles –> R –> Language Grammars –> R –> Send Selection/Line to –> R.app & Step
In the bottom text box, enter "-e 'tell application "TextMate" to activate' \" (without the "quotes");
Save with ⌘S
If you have problems, try copy and pasting the contents of the file RappStep2.txt
note: I'm not making this change by default b/c the correction doesn't seem to be necessary for all setups

