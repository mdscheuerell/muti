[![Build Status](https://travis-ci.org/mdscheuerell/muti.svg?branch=master)](https://travis-ci.org/mdscheuerell/muti)

muti
====

This is the development repo for `muti`, an `R` package that computes the mutual information (MI) between two discrete random variables. Click [here](https://mdscheuerell.github.io/muti) for the full vignette.

Installation
------------

You can install the development version using `devtools`.

    if(!require("devtools")) {
      install.packages("devtools")
      library("devtools")
    }
    devtools::install_github("mdscheuerell/muti")
