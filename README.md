# muti
`muti` is an `R` package that computes the mutual information (MI) between two discrete random variables _X_ and _Y_. MI is a function of their individual and joint entropies, _H_(.), such that

MI(_X_,_Y_) = _H_(_X_) + _H_(_Y_) - _H_(_X_,_Y_).

MI can be based on 1 of 2 possible discretizations of the data:

1. __Symbolic__. In this case the _i_-th datum is converted to 1 of 5 symbolic representations (_i.e._, "peak", "decrease", "same", "trough", "increase") based on the _i_-1 and _i_+1 values (see [Cazelles 2004](https://doi.org/10.1111/j.1461-0248.2004.00629.x) for details). Thus, the resulting symbolic vectors are 2 values shorter than their respective original vectors. For example, if the original vector was `c(1,2,3,1,3,2)`, then the resulting symbolic vector would be `c(NA,"increase","peak","trough","peak",NA)`.

2. __Binned__. In this case each datum is placed into 1 of _n_ equally spaced bins. If the number of bins is not specified, then it is calculated according to Rice's Rule whereby `n = ceiling(2*length(x)^(1/3))`.

