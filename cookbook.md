Pinsky Lab Cookbook
================

-   [Github](#github)
    -   [How to add undergrads to the Pinsky Lab github.](#how-to-add-undergrads-to-the-pinsky-lab-github.)
    -   [How to get RStudio and github to talk to each other](#how-to-get-rstudio-and-github-to-talk-to-each-other)
    -   [How to move an existing project on github into RStudio](#how-to-move-an-existing-project-on-github-into-rstudio)
    -   [How to transfer ownership of a repository from personal to pinskylab in github](#how-to-transfer-ownership-of-a-repository-from-personal-to-pinskylab-in-github)
    -   [How to connect to one script in someone else's github repo](#how-to-connect-to-one-script-in-someone-elses-github-repo)
    -   [How to connect amphiprion Rstudio server to existing github repo](#how-to-connect-amphiprion-rstudio-server-to-existing-github-repo)
-   [R](#r)
    -   [How to install an older verison of a package than the one currently installed.](#how-to-install-an-older-verison-of-a-package-than-the-one-currently-installed.)
-   [Plots](#plots)
    -   [How to save an R plot as a pdf (when using ggplot) - 3 different ways](#how-to-save-an-r-plot-as-a-pdf-when-using-ggplot---3-different-ways)
-   [Sequencing](#sequencing)
    -   [How to calculate sequencing coverage](#how-to-calculate-sequencing-coverage)

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

1.  Open the the project file in the RStudio server for amphiprion in your web browser. If you need the webaddress for the RStudio server, email Michelle.

R
=

How to install an older verison of a package than the one currently installed.
------------------------------------------------------------------------------

Based on this [article](https://support.rstudio.com/hc/en-us/articles/219949047-Installing-older-versions-of-packages)

``` r
devtools::install_version("ggplot2", version = "0.9.1", repos = "http://cran.us.r-project.org")

packageurl <- "https://github.com/thomasp85/gganimate/archive/v0.1.1.tar.gz"
install.packages(packageurl, repos=NULL, type="source")

packageloc <- "~/Downloads/gganimate-0.1.1/"
install.packages(packageloc, repos = NULL, type="source")
```

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
