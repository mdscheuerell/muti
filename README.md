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
par(omi=rep(0.1,4))
muti(x,y)
```

<img src="README_files/figure-markdown_github/ex_1-1.png" width="100%" height="100%" />

    ##       lag      MI_xy     MI_ci
    ##  [1,]  -5 0.08322984 0.3778558
    ##  [2,]  -4 0.06800523 0.3269938
    ##  [3,]  -3 0.02230546 0.3857086
    ##  [4,]  -2 0.02816403 0.3426943
    ##  [5,]  -1 0.04561370 0.3438173
    ##  [6,]   0 0.06997917 0.3032215
    ##  [7,]   1 0.10937351 0.2795474
    ##  [8,]   2 0.09965162 0.3470183
    ##  [9,]   3 0.02230546 0.3344613
    ## [10,]   4 0.06044060 0.3512004
    ## [11,]   5 0.06156946 0.3807038

### 2 correlated variables

``` r
set.seed(123)
TT <- 30
x <- rnorm(TT)
y <- x + rnorm(TT,0,0.1)
par(omi=rep(0.1,4))
muti(x,y)
```

<img src="README_files/figure-markdown_github/ex_2-1.png" width="100%" height="100%" />

    ##       lag     MI_xy     MI_ci
    ##  [1,]  -5 0.2780756 0.4023652
    ##  [2,]  -4 0.2196129 0.3381732
    ##  [3,]  -3 0.2375794 0.3387626
    ##  [4,]  -2 0.2722575 0.3431813
    ##  [5,]  -1 0.4176067 0.3332385
    ##  [6,]   0 0.6166387 0.2824207
    ##  [7,]   1 0.3996744 0.3104196
    ##  [8,]   2 0.1807963 0.3326402
    ##  [9,]   3 0.2162810 0.3788712
    ## [10,]   4 0.2416187 0.3505441
    ## [11,]   5 0.1783442 0.3472656
