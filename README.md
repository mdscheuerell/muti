muti
====

`muti` is an `R` package that computes the mutual information (MI) between two discrete random variables *X* and *Y*. `muti` was developed with time series analysis in mind, but there is nothing tying the methods to a time index *per se*.

You can install the development version using `devtools`.

    if(!require("devtools")) {
      install.packages("devtools")
      library("devtools")
    }
    devtools::install_github("mdscheuerell/muti")

Background
----------

MI estimates the amount of information about one variable contained in another; it can be thought of as a nonparametric measure of the covariance between the two variables. MI is a function of entropy, which is the expected amount of information contained in a variable. If *P*(*X*) is the probability mass function of *X*, then the entropy of *X* is

*H*(*X*) = E\[-ln(P(X))\].

The MI between *X* and *Y* is then

MI(*X*,*Y*) = *H*(*X*) + *H*(*Y*) - *H*(*X*,*Y*)

where *H*(*X*,*Y*) is the joint entropy between *X* and *Y*. `muti` uses base-2 logarithms for calculating the entropies, so MI measures information content in units of "bits".

Data discretization
-------------------

`muti` computes MI based on 1 of 2 possible discretizations of the data:

1.  **Symbolic**. In this case the *i*-th datum is converted to 1 of 5 symbolic representations (*i.e.*, "peak", "decreasing", "same", "trough", "increasing") based on its value relative to the *i*-1 and *i*+1 values (see [Cazelles 2004](https://doi.org/10.1111/j.1461-0248.2004.00629.x) for details). Thus, the resulting symbolic vector is 2 values shorter than its original vector. For example, if the original vector was `c(1.2,2.1,3.3,1.1,3.1,2.2)`, then its symbolic vector for values 2-5 would be `c("increasing","peak","trough","peak")`.

2.  **Binned**. In this case each datum is placed into 1 of *n* equally spaced bins. If the number of bins is not specified, then it is calculated according to Rice's Rule whereby `n = ceiling(2*length(x)^(1/3))`.

I/O
---

At a minimum `muti` requires two vectors of class `numeric` or `integer`. See `?muti` for all of the other function arguments.

The primary output of `muti` is a data frame with the MI `MI_xy` and respective significance threshold `MI_ci` at different lags. Additionally, `muti` produces plots of the original data, symbolic data (if that option is chosen), and the MI values and associated threshold values at different lags. The significance thresholds are based on bootstraps of the original data. That process is relatively slow, so please be patient if asking for more than the default `mc=100` samples.

Examples
--------

### Ex 1: Real values as symbolic

Here's an example with significant correlation between two numeric vectors. Notice that none of the symbolic values are the "same".

``` r
set.seed(123)
TT <- 30
x <- rnorm(TT)
y <- x + rnorm(TT)
muti(x,y)
```

![](README_files/figure-markdown_github/ex_1-1.png)

    ##       lag     MI_xy     MI_ci
    ##  [1,]  -4 0.3122401 0.6396689
    ##  [2,]  -3 0.5477111 0.5896470
    ##  [3,]  -2 0.4896244 0.5868193
    ##  [4,]  -1 0.6133082 0.5400706
    ##  [5,]   0 0.7759290 0.6117563
    ##  [6,]   1 0.4590565 0.6097824
    ##  [7,]   2 0.1663024 0.5748355
    ##  [8,]   3 0.2815102 0.5654351
    ##  [9,]   4 0.4795740 0.6188139

### Ex 2: Integer values as symbolic

Here's an example with significant correlation between two integer vectors.

``` r
x2 <- rpois(TT,4)
y2 <- x2 + sample(c(-1,1),TT,replace=TRUE)
muti(x,y)
```

![](README_files/figure-markdown_github/ex_2-1.png)

    ##       lag     MI_xy     MI_ci
    ##  [1,]  -4 0.3122401 0.6140055
    ##  [2,]  -3 0.5477111 0.5114544
    ##  [3,]  -2 0.4896244 0.6018144
    ##  [4,]  -1 0.6133082 0.5067642
    ##  [5,]   0 0.7759290 0.5208218
    ##  [6,]   1 0.4590565 0.5890482
    ##  [7,]   2 0.1663024 0.5583886
    ##  [8,]   3 0.2815102 0.5220552
    ##  [9,]   4 0.4795740 0.5085026

### Ex 3: Real values as symbolic with normalized MI

Same as Ex 1 with MI normalized to \[0,1\]. In this case MI'(*X*,*Y*) = MI(*X*,*Y*)/sqrt(*H*(*X*)\**H*(*Y*)).

``` r
muti(x,y,normal=TRUE)
```

![](README_files/figure-markdown_github/ex_3-1.png)

    ##       lag      MI_xy     MI_ci
    ##  [1,]  -4 0.16712589 0.3708226
    ##  [2,]  -3 0.28904789 0.3110627
    ##  [3,]  -2 0.26046030 0.3079110
    ##  [4,]  -1 0.32544694 0.3009047
    ##  [5,]   0 0.41446439 0.2560790
    ##  [6,]   1 0.24575105 0.3055651
    ##  [7,]   2 0.08846611 0.3158044
    ##  [8,]   3 0.14856359 0.3202974
    ##  [9,]   4 0.25457125 0.3779873

### Ex 4: Real values with binning

Same as Ex 1 with regular binning instead of symbolic.

``` r
muti(x,y,sym=FALSE)
```

![](README_files/figure-markdown_github/ex_4-1.png)

    ##       lag     MI_xy    MI_ci
    ##  [1,]  -4 0.8820883 1.055511
    ##  [2,]  -3 0.8889416 1.041745
    ##  [3,]  -2 1.1275134 1.018997
    ##  [4,]  -1 0.8990155 1.010916
    ##  [5,]   0 1.0098951 1.033755
    ##  [6,]   1 0.7625273 1.050959
    ##  [7,]   2 1.0095443 1.006130
    ##  [8,]   3 0.8754405 1.099812
    ##  [9,]   4 0.9009431 1.178713

### Ex 5: Autocorrelation

Here's an example of examining the MI of a single time series at multiple time lags.

``` r
x <- cumsum(rnorm(TT))
muti(x,x,sym=FALSE)
```

![](README_files/figure-markdown_github/ex_5-1.png)

    ##       lag    MI_xy     MI_ci
    ##  [1,]  -4 1.115811 1.1148577
    ##  [2,]  -3 1.433014 1.0737790
    ##  [3,]  -2 1.475204 1.0152812
    ##  [4,]  -1 1.440723 1.0719487
    ##  [5,]   0 2.634197 1.0677397
    ##  [6,]   1 1.440723 1.0666590
    ##  [7,]   2 1.475204 0.9446771
    ##  [8,]   3 1.433014 1.1042051
    ##  [9,]   4 1.115811 1.1753826
