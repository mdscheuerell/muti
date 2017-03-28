#' Estimates the transition matrix for confidence intervals on mutual information.
#'
#' \code{mutual_info} is a helper function for estimating the transition matrix
#' used in creating resampled vectors for the (1 - alpha)% confidence
#' interval on the mutual info.
#'
#' @param x A \code{vector} of values.
#' @param n_bins The number of bins for the entropy calculation
#'
#' @return A list with the following components:
#' \describe{
#' \item{\code{xn}}{An [n x 2] matrix of the original and discretized vectors.}
#' \item{\code{MM}}{Transition probability matrix from bin-i to bin-j.}
#' }
#'
#' @importFrom stats runif
#'
transM <- function(x,n_bins) {
  ## helper function for estimating transition matrix used in
  ## creating resampled ts for the CI on mutual info
  ## replace NA with runif()
  x[is.na(x)] <- runif(length(x[is.na(x)]),min(x,na.rm=TRUE),max(x,na.rm=TRUE))
  ## length of ts
  tt <- length(x)
  ## get bins via slightly extended range
  bins <- seq(min(x)-0.001,max(x),length.out=n_bins+1)
  ## discretize ts
  hin <- vector("numeric",tt)
  for(b in 1:n_bins) {
    hin[x > bins[b] & x <= bins[b+1]] <- b
  }
  ## matrix of raw-x & discrete-x
  xn <- cbind(x,hin)
  ## transition matrix from bin-i to bin-j
  MM <- matrix(0,n_bins,n_bins)
  for(i in 1:n_bins) {
    for(j in 1:n_bins) {
      MM[i,j] <- sum(hin[-tt]==i & hin[-1]==j)
    }
    if(sum(MM[i,])>0) { MM[i,] <- MM[i,]/sum(MM[i,]) }
    else { MM[i,] <- 1/n_bins }
  }
  return(list(xn=xn,MM=MM))
} ## end function
