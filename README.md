# muti
`muti` computes the mutual information (MI) between two vectors. The vectors can be either symbolic (_e.g._, "peak", "decrease") _sensu_ [Cazelles (2004)](doi: 10.1111/j.1461-0248.2004.00629.x), or real values. If real values are chosen, they are discretized internally based on a binning algorithm as in `graphics:::hist`.
