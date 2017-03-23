# muti
`muti` computes the mutual information (MI) between two vectors, which is based upon their individual and joint entropies. The entropy $H$ of a discrete random variable $X$ with probabiloity mass function $P(X)$ is

$$
H(X) = -\displaystyle\sum_{i=1}^{n} P(x_i) \ \text{log}_b P(x_i).
$$

The joint entropy between two variables $X$ and $Y$ is then 

$$
H(X,Y) = - \displaystyle\sum_{x} \displaystyle\sum_{y} P(x,y) \ \text{log}_b P(x,y)
$$

where the $P(x,y)$ is the joint probability of $x$ and $y$ occuring together. The MI between $X$ and $Y$ is then

$$
I(X;Y) = H(X) + H(Y) - H(X,Y).
$$

MI can be based on 1 of 2 possible discretizations of the data:

1. __Symbolic__. In this case the _i_^th^ datum is converted to 1 of 5 symbolic representations (_i.e._, "peak", "decrease", "same", "trough", "increase") based on the _i_-1 and _i_+1 values (see [Cazelles (2004)](https://doi.org/10.1111/j.1461-0248.2004.00629.x) for details). Thus, the resulting symbolic vectors are 2 values shorter than their respective original vectors. For example, if the original vector was `c(1,2,3,1,3,2)`, then the resulting symbolic vector would be `c("increase","peak","trough","peak")`.

2. __Binned__. In this case each datum is placed into 1 of _n_ equally spaced bins. If the number of bins is not specified, then Rice's Rule is used to compute it whereby `n = ceiling(2*length(x)^(1/3))`.


