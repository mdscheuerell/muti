#' Plot original data plus the mutual information at multiple lags.
#'
#' \code{plotMI} plots original data plus the mutual information at multiple
#' lags.
#'
#' @param x First vector of data
#' @param y Second vector of data
#' @param MI A \code{list} with the mutual information as output by \code{muti}.
#' @param sym A boolean indcator as to whether symbolic dynamics (TRUE) were used.
#' @param n_bins The number of bins used for computing the MI.
#'
#' @return Plots of original vectors, (potential) symbolic values, and the mutual information at multiple lags.
#'
#' @importFrom graphics abline axis close.screen layout lcm matplot mtext par plot screen split.screen
#'
#' @export
plotMI <- function(x,y,MI,sym,n_bins) {
  ## function to plot original & symbolic ts (is desired), plus mutual info
  ## between 2 ts at varying lags
  clr <- c("orangered2", "blue2")
  xy <- cbind(x,y)
  ## get length of ts
  n <- dim(xy)[1]
  ## set up plot region with 3 panels
  ## 1) top panel is raw data
  ## 2) middle panel is symbolic/discrete data
  ## 3) bottom panel is mutual info
  split.screen(c(3,1))
  split.screen(c(1,2),screen=3)
  ## top panel: orig ts
  screen(1)
  par(mai=c(0.8,1.1,0.3,0.1), omi=rep(0.1,4))
#  par(mai=c(1,1.5,0.1,0.1), omi=rep(0.1,4))
  matplot(seq(n), xy, type="b", pch=c('x','y'), lty="solid", col=clr,
          xlab="", cex.axis=0.8, cex=0.8, las=1,
          ylab="")
  mtext("Time", side=1, adj=1, line=2.2)
  mtext("Raw data", side=3, adj=0, line=0.3)
#  ytxt <- expression(paste("Raw data (",italic(x[t]) *","* italic(y[t]),")",sep=""))
#  mtext(ytxt,2,line=3)
  if(sym) {
    ## middle panel: symbolic ts
    screen(2)
    par(mai=c(0.8,1.1,0.3,0.1), omi=rep(0.1,4))
#    par(mai=c(1,1.5,0,0.1), omi=rep(0.1,4))
    matplot(seq(n), symbolize(xy), type="b", pch=c('x','y'), lty="solid", col=clr,
            xlab="", cex.axis=0.8, cex=0.8,
            ylab="", yaxt="n")
    axis(2, at=seq(5), c("Trough", "Decreasing", "Same", "Increasing", "Peak"), las=1, cex.axis=0.8)
    mtext("Time", side=1, adj=1, line=2.2)
    mtext("Symbolic form", side=3, adj=0, line=0.3)
#    ytxt <- expression(paste("Symbolic data (",italic(s[t]) *","* italic(u[t]),")",sep=""))
#    mtext(ytxt,2,line=6)
  } else {
    ## middle panel: discretized ts
    screen(2)
    par(mai=c(0.8,1.1,0.3,0.1), omi=rep(0.1,4))
#    par(mai=c(1,1.5,0.1,0.1), omi=rep(0.1,4))
    x <- transM(x,n_bins)$xn[,"hin"]
    y <- transM(y,n_bins)$xn[,"hin"]
    matplot(seq(n), cbind(x,y), type="b", pch=c('x','y'), lty="solid", col=clr,
            xlab="", cex.axis=0.8, cex=0.8,
            ylab="", yaxt="n")
    axis(2,at=seq(1,n_bins,2), las=2, cex.axis=0.9)
    mtext("Time", side=1, adj=1, line=2.2)
    mtext("Discretized form", side=3, adj=0, line=0.3)
#    ytxt <- expression(paste("Discrete data (",italic(s[t]) *","* italic(u[t]),")",sep=""))
#    mtext(ytxt,2,line=3)
  }
  ## bottom panel: mutual info
  screen(4)
  par(mai=c(0.8,1.1,0.3,0.1), omi=rep(0.1,4))
#  par(mai=c(1,1.5,0.1,0.1), omi=rep(0.1,4))
  ylm <- c(0,ceiling(max(MI[,c("MI_xy","MI_tv")]/0.2,na.rm=TRUE))*0.2)
  if(dim(MI)[1] > 1) {
    matplot(MI[,"lag"],MI[,c("MI_xy","MI_tv")],type="l",lty=c("solid","dashed"),
            lwd=c(2,1), ylim=ylm, col="black",
            xlab="", cex.axis=0.8, las=1,
            ylab="")
  } else {
    plot(MI[,"lag"], MI[,"MI_xy"], pch=16,
         ylim=ylm, col="black",
         xlab="", cex.axis=0.8,
         ylab="")
    abline(h=MI[,"MI_tv"], lty="dashed")
  }
  mtext("Lag", side=1, line=2.2)
  mtext("MI (bits)", side=3, adj=0, line=0.3)
  close.screen(all.screens = TRUE)
} ## end function
