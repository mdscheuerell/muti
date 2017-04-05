#' Convert numeric vectors to symbolic vectors.
#'
#' \code{symbolize} converts numeric vectors to symbolic vectors. It is a helper
#'   function for \code{muti}.
#'
#' @param xy An n x 2 \code{matrix} or \code{data.frame} containing the two
#'   vectors of interest.
#'
#' @return An (n-2) x 2 \code{matrix} of integer symbols that indicate whether
#'   the i-th value, based on the i-1 and i+1 values, is a "trough" (=1),
#'   "decrease" (=2), "same" (=3), "increase" (=4), or "peak" (=5).
#'
symbolize <- function(xy) {
  ## of interest and converts them from numeric to symbolic.
  ## check input for errors
  if(dim(xy)[2] != 2) {
    stop("xy must be an [n x 2] matrix \n\n", call.=FALSE)
  }
  ## get ts length
  TT <- dim(xy)[1]
  ## init su matrix
  su <- matrix(NA, TT, 2)
  ## convert to symbols
  ## loop over 2 vars
  for(i in 1:2) {
    for(t in 2:(TT-1)) {
      ## if xy NA, also assign NA to su
      if(any(is.na(xy[(t-1):(t+1),i]))) { su[t,i] <- NA }
      ## else get correct symbol
      else {
        if(xy[t,i] == xy[t-1,i] & xy[t,i] == xy[t+1,i]) {
          ## same
          su[t,i] <- 3
          }
        if(xy[t,i] > xy[t-1,i]) {
          ## peak
          if(xy[t,i] > xy[t+1,i]) { su[t,i] <- 5 }
          ## increase
          else { su[t,i] <- 4 }
        }
        if(xy[t,i] < xy[t-1,i]) {
          ## trough
          if(xy[t,i] < xy[t+1,i]) { su[t,i] <- 1 }
          ## decrease
          else { su[t,i] <- 2 }
        }
      } ## end else
    } ## end t loop
  } ## end i loop
  ## return su matrix
  return(su)
}
