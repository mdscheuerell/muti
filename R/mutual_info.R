#' Calculate the mutual information between two vectors.
#'
#' \code{mutual_info} calculates the mutual information between two vectors. It
#'   is a helper function for \code{muti}.
#'
#' @param su An n x 2 \code{matrix} containing two discrete vectors.
#' @param normal A logical indicator as to whether the mutual information
#'   should be normalized to [0,1].
#'
#' @return A scalar of class `numeric` of the (possibly normalized) mutual
#'   information.
#'
mutual_info <- function(su,normal) {
  ## function to calculate mutual information between 2 time series
  ## need to remove obs with NA's b/c they don't contribute to info
  su <- su[!apply(apply(su,1,is.na),2,any),]
  ## get number of bins
  bb <- max(su)
  ## get ts length
  TT <- dim(su)[1]
  ## init entropies
  H_s <- H_u <- H_su <- 0
  for(i in 1:bb) {
    ## calculate entropy for 1st series
    p_s <- sum(su[,1] == i)/TT
    if(p_s != 0) { H_s <- H_s - p_s*log(p_s, 2) }
    ## calculate entropy for 2nd series
    p_u <- sum(su[,2] == i)/TT
    if(p_u != 0) { H_u <- H_u - p_u*log(p_u, 2) }
    for(j in 1:bb) {
      ## calculate joint entropy
      p_su <- sum(su[,1]==i & su[,2]==j)/TT
      if(p_su != 0) { H_su <- H_su - p_su*log(p_su, 2) }
    } ## end j loop
  } ## end i loop
  ## calc mutual info
  MI <- H_s + H_u - H_su
  if(!normal) { return(MI) } else { return(MI/sqrt(H_s*H_u)) }
}
