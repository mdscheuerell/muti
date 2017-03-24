muti
====

`muti` is an `R` package that computes the mutual information (MI) between two discrete random variables *X* and *Y*.

You can install the development version with

    if(!require("devtools")) {
      install.packages("devtools")
      library("devtools")
    }
    devtools::install_github("mdscheuerell/muti")

Background
----------

MI is the amount of information about one variable contained in the other; it can be thought of as a nonparametric measure of the covariance between the two variables. MI is a function of entropy, which is the expected amount of information contained in a variable. If *P*(*X*) is the probability mass function of *X*, then the entropy of *X* is

*H*(*X*) = E\[-ln(P(X))\].

The MI between *X* and *Y* is then

MI(*X*,*Y*) = *H*(*X*) + *H*(*Y*) - *H*(*X*,*Y*)

where *H*(*X*,*Y*) is the joint entropy between *X* and *Y*.

Data discretization
-------------------

`muti` computes MI based on 1 of 2 possible discretizations of the data:

1.  **Symbolic**. In this case the *i*-th datum is converted to 1 of 5 symbolic representations (*i.e.*, "peak", "decrease", "same", "trough", "increase") based on its value relative to the *i*-1 and *i*+1 values (see [Cazelles 2004](https://doi.org/10.1111/j.1461-0248.2004.00629.x) for details). Thus, the resulting symbolic vector is 2 values shorter than its original vector. For example, if the original vector was `c(1.2,2.1,3.3,1.1,3.1,2.2)`, then its symbolic vector for values 2-5 would be `c("increase","peak","trough","peak")`.

2.  **Binned**. In this case each datum is placed into 1 of *n* equally spaced bins. If the number of bins is not specified, then it is calculated according to Rice's Rule whereby `n = ceiling(2*length(x)^(1/3))`.

Examples
--------

The primary output of `muti` is a data frame with the MI and associated critical value at different lags. Additionally, `muti` produces plots of the original data, symbolic data (if that option is chosen), and the MI values and associated critical value at different lags.

### 2 random variables

``` r
set.seed(123)
TT <- 30
x <- rnorm(TT)
y <- rnorm(TT)
#muti(x,y)
```

### 2 correlated variables

``` r
set.seed(123)
TT <- 30
x <- rnorm(TT)
y <- x + rnorm(TT,0,0.1)
muti(x,y)
```

<img src="README_files/figure-markdown_github/ex_2-1.svg" width="50%" height="50%" />

    ##       lag     MI_xy     MI_ci
    ##  [1,]  -4 0.2196129 0.4125676
    ##  [2,]  -3 0.2375794 0.3161066
    ##  [3,]  -2 0.2722575 0.3586554
    ##  [4,]  -1 0.4176067 0.3448750
    ##  [5,]   0 0.6166387 0.3364973
    ##  [6,]   1 0.3996744 0.3055931
    ##  [7,]   2 0.1807963 0.3928385
    ##  [8,]   3 0.2162810 0.4098452
    ##  [9,]   4 0.2416187 0.3762782
