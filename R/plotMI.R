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
#' @export
plotMI <- function(x,y,MI,sym,n_bins) {
  ## function to plot original & symbolic ts (is desired), plus mutual info
  ## between 2 ts at varying lags
  clr <- c("orangered2", "blue2")
  xy <- cbind(x,y)
  ## get length of ts
  n <- dim(xy)[1]
  ## set up plot region
  ## fig1 is raw data
  ## fig2 is symbolic/discrete data
  ## fig3 is mutual info
  layout(matrix(c(1,2,0,3),2,2), c(lcm(10),lcm(7)), c(lcm(7),lcm(7)), TRUE)
  ## top panel: orig ts
  par(mai=c(1,1.5,0,0.1))
  matplot(seq(n), xy, type="b", pch=c('x','y'), lty="solid", col=clr,
          xlab="Time", cex.axis=0.8,
          ylab="")
  ytxt <- expression(paste("Raw data (",italic(x[t]) *","* italic(y[t]),")",sep=""))
  mtext(ytxt,2,line=3)
  if(sym) {
    ## bottom panel: symbolic ts
    par(mai=c(1,1.5,0,0.1))
    matplot(seq(n), symbolize(xy), type="b", pch=c('s','u'), lty="solid", col=clr,
            xlab="Time", cex.axis=0.8,
            ylab="", yaxt="n")
    axis(2, at=seq(5), c("Trough", "Decreasing", "Same", "Increasing", "Peak"), las=1, cex.axis=0.9)
    ytxt <- expression(paste("Symbolic data (",italic(s[t]) *","* italic(u[t]),")",sep=""))
    mtext(ytxt,2,line=6)
  } else {
    ## bottom panel: discretized ts
    par(mai=c(1,1.5,0,0.1))
    x <- transM(x,n_bins)$xn[,"hin"]
    y <- transM(y,n_bins)$xn[,"hin"]
    matplot(seq(n), cbind(x,y), type="b", pch=c('s','u'), lty="solid", col=clr,
            xlab="Time", cex.axis=0.8,
            ylab="", yaxt="n")
    axis(2,at=seq(1,n_bins,2), las=2, cex.axis=0.9)
    ytxt <- expression(paste("Discrete data (",italic(s[t]) *","* italic(u[t]),")",sep=""))
    mtext(ytxt,2,line=3)
  }
  ## right panel: mutual info
  par(mai=c(1,1,0,0.1))
  ylm <- c(0,ceiling(max(MI[,c("Ixy","Ici")]/0.1,na.rm=TRUE))*0.1)
  if(dim(MI)[1] > 1) {
    matplot(MI[,"lag"],MI[,c("Ixy","Ici")],type="l",lty=c("solid","dashed"),
            lwd=c(2,1),ylim=ylm,col="black",
            xlab="Lag", cex.axis=0.8,
            ylab="")
  } else {
    plot(MI[,"lag"],MI[,"Ixy"], pch=16,
         ylim=ylm, col="black",
         xlab="Lag", cex.axis=0.8,
         ylab="")
    abline(h=MI[,"Ici"], lty="dashed")
  }
  if(sym) {
    ytxt <- expression(paste("Mutual information (",italic(MI[su]),")",sep=""))
  } else {
    ytxt <- expression(paste("Mutual information (",italic(MI[xy]),")",sep=""))
  }
  mtext(ytxt,2,line=3)
} ## end function
