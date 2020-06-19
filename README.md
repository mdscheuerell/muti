[![Build
Status](https://travis-ci.org/mdscheuerell/muti.svg?branch=master)](https://travis-ci.org/mdscheuerell/muti)

------------------------------------------------------------------------

muti
====

**muti** computes the mutual information (MI) contained in two vectors
of discrete random variables. Click
[here](https://mdscheuerell.github.io/muti) for the package website and
vignette.

Installation
------------

You can install the development version using `devtools`.

    if(!require("devtools")) {
      install.packages("devtools")
      library("devtools")
    }
    devtools::install_github("mdscheuerell/muti")

Usage
-----

At a minimum **muti** requires two equal-length vectors of class
`numeric` or `integer`. See `?muti` for all of the other function
arguments.

    muti(x, y)

------------------------------------------------------------------------

[![DOI](https://zenodo.org/badge/85351399.svg)](https://zenodo.org/badge/latestdoi/85351399)
