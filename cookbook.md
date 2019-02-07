Pinsky Lab Cookbook
================

-   [How to add undergrads to the Pinsky Lab github.](#how-to-add-undergrads-to-the-pinsky-lab-github.)
-   [How to get RStudio and github to talk to each other](#how-to-get-rstudio-and-github-to-talk-to-each-other)
-   [How to move an existing project on github into RStudio](#how-to-move-an-existing-project-on-github-into-rstudio)
-   [How to transfer ownership of a repository from personal to pinskylab in github](#how-to-transfer-ownership-of-a-repository-from-personal-to-pinskylab-in-github)
-   [How to save an R plot as a pdf (when using ggplot) - 3 different ways](#how-to-save-an-r-plot-as-a-pdf-when-using-ggplot---3-different-ways)
-   [How to connect to one script in someone else's github repo](#how-to-connect-to-one-script-in-someone-elses-github-repo)
-   [How to calculate sequencing coverage](#how-to-calculate-sequencing-coverage)

This document exists to share institutional knowledge for obstacles that are commonly run into by Pinsky Lab Members. The struggle is real!

How to add undergrads to the Pinsky Lab github.
===============================================

1.  Make sure the undergrad has signed up for github and note whatever email they used to sign up.
2.  Create the repository on github, this should be the project that they are working on.
3.  Invite the undergrad as a collaborator.

How to get RStudio and github to talk to each other
===================================================

1.  Create a repository on github, copy the URL.
2.  Create a new project in RStudio and paste in the URL from github

How to move an existing project on github into RStudio
======================================================

1.  Copy the URL from github for your repository.
2.  On your computer, add "\_old" to the end of the name of your folder.
3.  Create a new project in Rstudio and paste in the URL from github with the normal folder name.
4.  Open the "\_old" folder, copy all, open the new folder, paste all.

How to transfer ownership of a repository from personal to pinskylab in github
==============================================================================

1.  Click on the repository in github
2.  Click on "settings" in the upper middle right.
3.  Scroll down to click on "transfer ownership".

How to save an R plot as a pdf (when using ggplot) - 3 different ways
=====================================================================

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

How to connect to one script in someone else's github repo
==========================================================

1.  Go to the webpage that contains the script.
2.  Click on RAW and then copy the URL.
3.  In R:

``` r
script <- RCurl::getURL("https://raw.githubusercontent.com/pinskylab/pinskylab_methods/master/genomics/scripts/field_helpers.R", ssl.verifypeer = FALSE)
eval(parse(text = script))
```

How to calculate sequencing coverage
====================================

[Check out this pdf](https://github.com/pinskylab/pinskylab_methods/blob/master/genomics/coverage_calculation.pdf)
