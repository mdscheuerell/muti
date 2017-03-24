#' Helper function for creating new vector based on resampling the original data.
#'
#' \code{newZ} creates new vector based on transition matrix.
#'
#' @param tM The outputs from \code{transM}; a \code{list} with elements \code{xn} and \code{MM}.
#' @param n_bins The number of bins to use; passed from \code{muti}.
#'
#' @return A vector of resampled values.
#'
#' @importFrom stats rmultinom
#'
#' @export
newZ <- function(tM, n_bins) {
  ## helper function for creating new ts based on resampling
  ## the original data
  ## number of bins
  # n_bins <- dim(tM$MM)[1]
  ## length of ts
  tt <- dim(tM$xn)[1]
  ## random start index
  tin <- sample(tt,1)
  ## init zz
  zz <- matrix(NA,tt,2)
  ## get first sample
  zz[1,] <- tM$xn[tin,]
  ## loop over remaining samples
  for(t in 2:tt) {
    ## random transition bin
    zz[t,2] <- seq(n_bins)[rmultinom(1,1,tM$MM[zz[t-1,2],])==1]
    ## possible set of real values
    pset <- tM$xn[tM$xn[,2] %in% zz[t,2],1]
    if(length(pset)==0) { pset <- NA }
    ## get next sample
    zz[t,1] <- pset[sample(length(pset),1)]
  }
  return(zz[,1])
} ## end function
