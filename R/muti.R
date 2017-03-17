#' Calculate mutual information between two vectors and plot results.
#'
#' \code{muti} calculates the mutual information between two vectors and plots
#' the results at multiple lags.
#'
#' @param x First vector of data
#' @param y Second vector of data
#' @param n_bins [optional] Specify the number of bins to use for calculating
#'   the entropy. If \code{NULL} (default), the data are discretized based on
#'   the "Rice Rule" where \code{n_bins = ceiling(2*length(x)^(1/3))}.
#' @param sym Boolean indicator of whether to use symbolic dynamics (default).
#'   If \code{FALSE}, the data are discretized based on \code{n_bins}.
#' @param lags Vector of \code{integer} indicating what lags to use. Can be
#'   positive and/or negative.
#' @param mc The number of Monte Carlo simulations for estimating the
#'   confidence interval on the mutual information.
#' @param alpha The $\alpha$ value for the upper (1-$\alpha$)% confidence bound
#'   on the mutual information (lower bound is 0).
#' @param normal Boolean indicator of whether to normalize the mutual
#'   information based on the entropies. See 'Details."
#'
#' @return A \code{data.frame} with columns for lag (\code{lag}), mutual
#'   information between x & y (\code{MI_xy}), and the upper confidence bound
#'   (\code{MI_ci}). Note that the lower bound for MI is 0. Plots of x & y,
#'   their symbolic values (if desired), and the mutual information at multiple
#'   lags.
#'
#' @examples
#' set.seed(123)
#'
#' ## number of time steps
#' TT <- 30
#' ## create vector 1
#' x <- rnorm(TT)
#'
#' ## CASE 1: no mutual info at any lag
#' y <- rnorm(TT)
#' muti(x,y)
#'
#' ## CASE 2: mutual info at lag 1
#' y <- x + rnorm(TT,0,0.1)
#' muti(x,y)
#'
#' @export
muti <- function(x,y,n_bins=NULL,sym=TRUE,lags=seq(-5,5),mc=100,alpha=0.05,normal=TRUE) {
  if(is.null(n_bins)) {
    ## Sturges
    ## ceiling(log(n,2)) + 1
    ## Scott
    ## 3.5*sd(x)/n^(1/3)
    ## Friedman-Diaconis
    ## 2*IQR(x)/n^(1/3)
    ## Rice
    n_bins <- ceiling(2*length(x)^(1/3))
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
  colnames(MI) <- c("lag","MI_xy","MI_ci")
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
    if(!is.null(mc)) {
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
      MI[cnt,"MI_ci"] <- sort(mcr)[round((1-alpha)*mc)]
    }
    ## increment counter
    cnt <- cnt + 1
  } ## end loop over lags
  plotMI(px,py,MI,sym,n_bins)
  return(MI)
} ## end function
