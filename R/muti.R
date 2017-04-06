#' Calculate the mutual information between two vectors.
#'
#' \code{muti} calculates the mutual information between two vectors at multiple
#' lags and plots the results.
#'
#' @param x First vector of data. Must be \code{integer} or \code{numeric}.
#' @param y Second vector of data. Must be \code{integer} or \code{numeric}.
#' @param sym Logical indicator of whether to use symbolic representation of the
#'   data when calculating the MI. If \code{FALSE}, the data are discretized
#'   based on \code{n_bins}.
#' @param n_bins The number of bins to use for discretizing the data when
#'   \code{sym = FALSE}. When \code{n_bins = NULL} (default), the data are
#'   discretized based on the Rice rule where
#'   \code{n_bins = ceiling(2*length(x)^(1/3))}.
#' @param normal Logical indicator of whether to normalize the mutual
#'   information to [0,1].
#' @param lags One or more integers indicating at what lags to calculate the MI.
#'   Note that a negative (positive) lag means \code{x} leads (trails) \code{y}.
#' @param mc The number of Monte Carlo simulations for estimating the critical
#'   threshold value on the mutual information, above which the MI is
#'   significant at the specified `alpha`. Must be a non-negative integer.
#' @param alpha The alpha value for estimating the upper (1-alpha)\% critical
#'   threshold on the mutual information.
#'
#' @return A \code{data.frame} with columns for lag (\code{lag}), mutual
#'   information between x & y (\code{MI_xy}), and the threshold value
#'   (\code{MI_tv}) above which the MI is signficant at the specified
#'   \code{alpha}. Note that the lower bound for MI is 0. Also returns plots of
#'   x & y (top panel), their discrete values (middle panel), and the mutual
#'   information at specified lags (bottom panel).
#'
#' @examples
#' TT <- 30
#' x <- rnorm(TT)
#' y <- x + rnorm(TT)
#' muti(x, y)
#'
#' @export
muti <- function(x,y,sym=TRUE,n_bins=NULL,normal=FALSE,lags=seq(-4,4),mc=100,alpha=0.05) {
  ## simple error checking
  if(length(x)!=length(y)) {
    stop("The vectors 'x' and 'y' must be the same length.\n\n")
  }
  if(class(x)!="integer" & class(x)!="numeric") {
    stop("The vector 'x' must be either 'integer' or 'numeric'.\n\n")
  }
  if(class(y)!="integer" & class(y)!="numeric") {
    stop("The vector 'y' must be either 'integer' or 'numeric'.\n\n")
  }
  if(is.null(n_bins)) {
    n_bins <- ceiling(2*length(x)^(1/3))
  } else {
    if((n_bins-round(n_bins))!=0) {
      stop("'n_bins' must be NULL or an integer.\n\n")
    }
    if(n_bins>=length(x)) {
      stop("'n_bins' must be less than the length of the data.\n\n")
    }
  }
  if(class(sym)!="logical") {
    stop("'sym' must be TRUE or FALSE.\n\n")
  }
  if(length(lags)==0 | any((lags-round(lags))!=0)) {
    stop("'lags' must be a single integer or a series of integers.\n\n")
  }
  if(any(abs(lags)>=length(x))) {
    stop("The min/max of 'lags' must be less than the length of 'x' and 'y'.\n\n")
  }
  if(mc<0 | (mc-round(mc))!=0) {
    stop("'mc' must be a non-negative integer.\n\n")
  }
  if(alpha<=0 | alpha>=1) {
    stop("'alpha' must be between 0 and 1.")
  }
  if(class(normal)!="logical") {
    stop("'normal' must be TRUE or FALSE.\n\n")
  }
  ## save x & y for later plotting
  px <- x
  py <- y
  ## if not symbolic, then discretize
  if(!sym) {
    x <- transM(x,n_bins)$xn[,"hin"]
    y <- transM(y,n_bins)$xn[,"hin"]
  }
  ## init results matrix
  MI <- matrix(NA,length(lags),3)
  colnames(MI) <- c("lag","MI_xy","MI_tv")
  MI[,"lag"] <- lags
  ## init counter
  cnt <- 1
  ## loop over time lags
  for(i in lags) {
    ## shift y to left for neg lags
    if(i < 0) {
      yy <- y[(-1:i)]
      xx <- x[-((length(x)-abs(i)+1):length(x))]
    }
    ## no-shift for lag=0
    if(i == 0) {
      yy <- y
      xx <- x
    }
    ## shift y to right for pos lags
    if(i > 0) {
      yy <- y[-((length(y)-i+1):length(y))]
      xx <- x[-(1:i)]
    }
    ## compute mutual info
    if(sym) { MI[cnt,"MI_xy"] <- mutual_info(symbolize(cbind(xx,yy)),normal) }
    else { MI[cnt,"MI_xy"] <- mutual_info(cbind(xx,yy),normal) }
    ## compute (1-alpha)% CI, if desired
    if(mc>0) {
      ## get trans probs for x & y
      xm <- transM(xx,n_bins)
      ym <- transM(yy,n_bins)
      ## init mc samples
      mcr <- vector()
      ## loop over mc samples
      for(j in 1:mc) {
        xy <- cbind(newZ(xm,n_bins),newZ(ym,n_bins))
        if(sym) { mcr[j] <- mutual_info(symbolize(xy),normal) }
        else { mcr[j] <- mutual_info(xy,normal) }
      }
      MI[cnt,"MI_tv"] <- sort(mcr)[round((1-alpha)*mc)]
    } else {
      MI[cnt,"MI_tv"] <- NA
    }
    ## increment counter
    cnt <- cnt + 1
  } ## end loop over lags
  plotMI(px,py,MI,sym,n_bins,normal)
  MI[,-1] <- round(MI[,-1],3)
  return(as.data.frame(MI))
} ## end function
