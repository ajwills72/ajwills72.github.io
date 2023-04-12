## DAU 49: 19-May-2015: Andy Wills
## Functions for fitting ALCOVE to Nosofsky et al. (1994)

## alcove.shj.oneprob ##
# Sets up list for 100 runs through the problem, all in one big list.
# (each run is a different random order)
# Returns by-block error rate for one SHJ61 problem.
##
alcove.shj.oneprob <- function(problem,init.state) {
  # Run simulation
  out <- alcovelp(init.state,bigtr[,,problem])
  # Combine output to training list
  colnames(out) <- c('p1','p2')
  out <- data.frame(cbind(bigtr[,,problem],out))
  # Calculate response accuracy
  out$pc <- 0
  out$pc[out$t1 == 1] <- out$p1[out$t1 == 1]
  out$pc[out$t2 == 1] <- out$p2[out$t2 == 1]  
  # Summarize table for SSD purposes
  sim.out.ag <- aggregate(out$pc,list(out$blk),mean) 
  return(1-sim.out.ag[,2]) # Return as error rate
}

## alcove.shj
# Calls alcove.shj.oneprob six times - once for each Type.
# Prints a graph of model results by block.
# Returns SSE across all problems
##
alcove.shj <- function(init.state, plotit = TRUE) {
  pout <- sapply(1:6,alcove.shj.oneprob,init.state=init.state,simplify=TRUE)
  colnames(pout) <- c('1','2','3','4','5','6')
  tout <- melt(pout,measure.vars=c('1','2','3','4','5','6'),value.name='error')
  colnames(tout) <- c('block','type','error')
  if(plotit) n94plot(tout,'ALCOVE: Nosofsky (1994)')
  return(ssecl(tout$error,shj61$error))
}  

## alcove.shj.optim
# Wrapper function for alcove.shj that allows just the arbitrarily 
# variable parameters to be the subject of the optimization routine.
## 
alcove.shj.optim <- function(params) {
  init.state$c <- params['c']
  init.state$phi <- params['phi']
  init.state$la <- params['la']
  init.state$lw <- params['lw']
  sse.out <- alcove.shj(init.state, plotit = FALSE)
  #print(params)
  #print(paste('SSE: ',sse.out))
  return(sse.out)  
}
