## DAU: PLY22: Support functions

## bsci
## Author: Baguley (2012)

bsci <- function(data.frame, group.var=1, dv.var=2, difference=FALSE,
                 pooled.error=FALSE, conf.level=0.95) {
    
    # Difference-adjusted confidence intervals.
    # This code was written by Thom Baguley 2012-03-18
    # and is available here:
    # https://seriousstats.wordpress.com/2012/03/18/cis-for-anova/
    # The above link describes the rationale for this approach.

    # Where pooled.error=TRUE, this function should produce the
    # same output as the bs.ci() from the Supplementary Materials of
    # the following peer-reviewed article:

    # Baguley, T. (2012b). Calculating and graphing within-subject
    # confidence intervals for ANOVA. Behavior Research Methods,
    # 44, 158-175.

    # Note: Although the title of the above paper mentions only
    # within-subject CI, it also contains routines for between-subject
    # CI.

    data <- subset(data.frame, select=c(group.var, dv.var))
    fact <- factor(data[[1]])
    dv <- data[[2]]
    J <- nlevels(fact)
    N <- length(dv)
    ci.mat <- matrix(,J,3, dimnames=list(levels(fact), c('lower', 'mean', 'upper')))
    ci.mat[,2] <- tapply(dv, fact, mean)
    n.per.group <- tapply(dv, fact, length)
    if(difference==TRUE) diff.factor= 2^0.5/2 else diff.factor=1
    if(pooled.error==TRUE) {
        for(i in 1:J) {
            moe <- summary(lm(dv ~ 0 + fact))$sigma/(n.per.group[[i]])^0.5 * qt(1-(1-conf.level)/2,N-J) * diff.factor
            ci.mat[i,1] <- ci.mat[i,2] - moe
            ci.mat[i,3] <- ci.mat[i,2] + moe
        }
    }
    if(pooled.error==FALSE) {
        for(i in 1:J) {
            group.dat <- subset(data, data[1]==levels(fact)[i])[[2]]
            moe <- sd(group.dat)/sqrt(n.per.group[[i]]) * qt(1-(1-conf.level)/2,n.per.group[[i]]-1) * diff.factor
            ci.mat[i,1] <- ci.mat[i,2] - moe
            ci.mat[i,3] <- ci.mat[i,2] + moe
        }
    }
    ci.mat
}

## Bf
## Author: Baguley & Kaye (2010)

Bf<-function(sd, obtained, uniform, lower=0, upper=1, meanoftheory=0, sdtheory=1, tail=2)
{
  #Authors Danny Kaye & Thom Baguley
  #Version 1.0
  #19/10/2009
  #test data can be found starting at p100
  #
  area <- 0
  if(identical(uniform, 1)){
    theta <- lower
    range <- upper - lower
    incr <- range / 2000
    for (A in -1000:1000){
      theta <- theta + incr
      dist_theta <- 1 / range
      height <- dist_theta * dnorm(obtained, theta, sd)
      area <- area + height * incr
    }
  }else{
    theta <- meanoftheory - 5 * sdtheory
    incr <- sdtheory / 200
    for (A in -1000:1000){
      theta <- theta + incr
      dist_theta <- dnorm(theta, meanoftheory, sdtheory)
      if(identical(tail, 1)){
        if (theta <= 0){
          dist_theta <- 0
        } else {
          dist_theta <- dist_theta * 2
        }
      }
      height <- dist_theta * dnorm(obtained, theta, sd)
      area <- area + height * incr
    }
  }
  LikelihoodTheory <- area
  Likelihoodnull <- dnorm(obtained, 0, sd)
  BayesFactor <- LikelihoodTheory / Likelihoodnull
  ret <- list("LikelihoodTheory" = LikelihoodTheory, "Likelihoodnull" = Likelihoodnull, "BayesFactor" = BayesFactor)
  ret
}

## get_BIC
## CC BY-SA 4.0
## Author: Andy J. Wills and Charlotte E. R. Edmunds
get_BIC <- function(log_likelihood, no_data_points, no_parameters){
    BIC <- -2.0*log_likelihood + no_parameters*log(no_data_points)
}

## grtmodel
## CC BY-SA 4.0
## Author: Andy J. Wills and Charlotte E. R. Edmunds
grtmodel <- function(onesub,ic="BIC"){
    require('grt')
    N <- nrow(onesub)
    ## Function to fit strategy models to each participants' data
    fit.rnd <- grg(onesub$Response, fixed=TRUE)
    fit.rndBias <- grg(onesub$Response, fixed=FALSE)
    fit.1dfreq <- glc(Response ~ Length, data=onesub,  zlimit=7) # Fit UD (length)
    fit.1dori <- glc(Response ~ Orientation, data=onesub,  zlimit=7) # Fit UD (angle)
    fit.cjur <- gcjc(Response ~ Length + Orientation, data=onesub, config=1,
                     zlimit=7, equal.noise=TRUE) # CJ (top left conjunction)
    fit.cjul <- gcjc(Response ~ Length + Orientation, data=onesub, config=2,
                     zlimit=7, equal.noise=TRUE) # CJ (top left conjunction)
    fit.cjll <- gcjc(Response ~ Length + Orientation, data=onesub, config=3,
                     zlimit=7, equal.noise=TRUE) # CJ (bottom right conjunction)
    fit.cjlr <- gcjc(Response ~ Length + Orientation, data=onesub, config=4,
                     zlimit=7, equal.noise=TRUE) # CJ (bottom right conjunction)
    fit.glc <- glc(Response ~ Length + Orientation, data=onesub,  zlimit=7,
                   covstruct="diagonal")
    
    if(ic=="BIC"){
        bic.rnd <- get_BIC(fit.rnd$logLik, N, 0)
        bic.rndBias <- get_BIC(fit.rndBias$logLik, N, 1)
        bic.1dfreq <- get_BIC(fit.1dfreq$logLik, N, 2)
        bic.1dori <- get_BIC(fit.1dori$logLik, N, 2)
        bic.cjur <- get_BIC(fit.cjur$logLik, N, 3)
        bic.cjul <- get_BIC(fit.cjul$logLik, N, 3)
        bic.cjll <- get_BIC(fit.cjll$logLik, N, 3)
        bic.cjlr <- get_BIC(fit.cjlr$logLik, N, 3)
        bic.glc <- get_BIC(fit.glc$logLik, N, 3)
        bics <- c(bic.rnd,bic.rndBias,bic.1dfreq,bic.1dori,bic.cjur,bic.cjul,
                  bic.cjll,bic.cjlr,bic.glc)
    }
    
    decode <- c('RND','RND_BIAS','UDF','UDO','CJ_UR','CJ_UL','CJ_LL',
                'CJ_LR','GLC')
    winModel <- decode[which.min(bics)]   # Establish winning model
    minBIC <- min(bics)
    delta.BIC <- bics-minBIC
    L.BIC <- exp(-0.5*delta.BIC)
    wBIC <- L.BIC/sum(L.BIC)
    winModelwBIC <- wBIC[which.min(bics)]
    return(c(winModel,minBIC,winModelwBIC,bics,wBIC))
}
