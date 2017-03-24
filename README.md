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

The primary output of `muti` is a data frame with the MI (`MI_xy`) and respective significance threshold (`MI_ci`) at different lags. Additionally, `muti` produces plots of the original data, symbolic data (if that option is chosen), and the MI values and associated critical value at different lags.

### Ex 1: random variables as symbolic

Here's a case where there should be very little mutual information between *X* and *Y*.

``` r
set.seed(123)
TT <- 30
x <- rnorm(TT)
y <- rnorm(TT)
muti(x,y)
```

![](README_files/figure-markdown_github/ex_1-1.png)

    ##       lag      MI_xy     MI_ci
    ##  [1,]  -4 0.11924284 0.6845677
    ##  [2,]  -3 0.03907957 0.7561248
    ##  [3,]  -2 0.04917229 0.6597224
    ##  [4,]  -1 0.08017767 0.6634594
    ##  [5,]   0 0.12264835 0.6689929
    ##  [6,]   1 0.19056470 0.6668210
    ##  [7,]   2 0.17398431 0.7129562
    ##  [8,]   3 0.03907957 0.7355923
    ##  [9,]   4 0.10472136 0.7153542

### Ex 2: correlated variables as symbolic

Here's a case where there should be significant mutual information between *X* and *Y*.

``` r
y <- x + rnorm(TT,0,0.5)
muti(x,y)
```

![](README_files/figure-markdown_github/ex_2-1.png)

    ##       lag     MI_xy     MI_ci
    ##  [1,]  -4 0.8055540 0.7313243
    ##  [2,]  -3 0.6561231 0.7026832
    ##  [3,]  -2 0.3088701 0.7169027
    ##  [4,]  -1 0.6538114 0.6796273
    ##  [5,]   0 0.7660774 0.6262150
    ##  [6,]   1 0.6794669 0.5874984
    ##  [7,]   2 0.4783460 0.5527717
    ##  [8,]   3 0.3679923 0.6996187
    ##  [9,]   4 0.3640055 0.5812106

### Ex 3: correlated variables with binning

Same as Ex 2 with regular binning instead of symbolic.

``` r
muti(x,y,sym=FALSE)
```

![](README_files/figure-markdown_github/ex_3-1.png)

    ##       lag     MI_xy    MI_ci
    ##  [1,]  -4 0.8294704 1.100902
    ##  [2,]  -3 0.9811721 1.079506
    ##  [3,]  -2 1.0291246 1.111500
    ##  [4,]  -1 0.8342897 1.093894
    ##  [5,]   0 1.2513074 1.046136
    ##  [6,]   1 1.1072603 1.047516
    ##  [7,]   2 0.9046000 1.141455
    ##  [8,]   3 1.2774684 1.102911
    ##  [9,]   4 0.8875386 1.116076

### Ex 4: correlated variables as symbolic with normalized MI.

Same as Ex 2 with MI normalized to \[0,1\].

``` r
muti(x,y,normal=TRUE)
```

![](README_files/figure-markdown_github/ex_4-1.png)

    ##       lag     MI_xy     MI_ci
    ##  [1,]  -4 0.4152936 0.3587841
    ##  [2,]  -3 0.3398746 0.3619371
    ##  [3,]  -2 0.1608100 0.3255315
    ##  [4,]  -1 0.3386468 0.3332333
    ##  [5,]   0 0.3985352 0.3080167
    ##  [6,]   1 0.3613144 0.3135927
    ##  [7,]   2 0.2531284 0.3256593
    ##  [8,]   3 0.1938644 0.3270083
    ##  [9,]   4 0.1932648 0.3297892
