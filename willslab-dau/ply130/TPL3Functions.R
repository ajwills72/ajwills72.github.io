## Quick function to calculate Cohen's d_z
## Code based on
## http://jakewestfall.org/blog/index.php/2016/03/25/five-different-cohens-d-statistics-for-within-subject-designs/

## Requires a data frame with the following columns
## id - Subject number
## cond - Within-subjects condition (must have exactly 2 levels)
## dv - The dependent variable

cohen.dz <- function(dat) {
  dat$id <- factor(dat$id)
  dat$dv <- as.numeric(dat$dv)
  dat$cond <- factor(dat$cond)
  means <- with(dat, tapply(dv, cond, mean))
  md <- abs(diff(means))
  sub_means <- with(dat, tapply(dv, list(id, cond), mean))
  dz <- md / sd(sub_means[,2] - sub_means[,1])
  names(dz) <- "Cohen's d_z"
  dz
}

# ## set the font
# windowsFonts(Times=windowsFont("TT Times New Roman"))
# windowsFonts(Calibri=windowsFont("Calibri"))

## APA settings for graphs
theme_APA <- theme_bw()+
  theme(panel.grid.major=element_blank(), #remove vertical background lines
        panel.grid.minor=element_blank(), #remove horizontal background lines
        panel.border=element_blank(), #remove the box around graph
        axis.line=element_line(size = 1), #show the x and y axis, set line thickness
        text=element_text(size = 16, face="bold"), # set font and size
        axis.text = element_text(size = 16, face="plain", colour="black"),
        legend.title=element_blank(), #don't show title for legend
        legend.position = c(.8, .9), #x and y coordinates for legend, but could just say "top", "right" etc`
        legend.text=element_text(face="plain", colour="black", size=16),
        strip.text.x = element_text(size = 16, face = "bold"),
        panel.background=element_rect(fill='white', colour='white'),
        strip.background=element_rect(fill='white', colour='white'),
        axis.title.x = element_text(margin = margin(t = 10)),
        plot.margin=grid::unit(c(5, 5, 5, 5), "mm"))

standard_geombar <- geom_bar(position=position_dodge(), stat="identity", colour="black", size=1)

## Difference-adjusted w/subj error bars
## Slight update of code from Baguley (2012)
cm.ci <- function(data.frame, conf.level = 0.95, difference = TRUE) {
  #cousineau-morey within-subject CIs
  k = ncol(data.frame)
  if (difference == TRUE) {
    diff.factor = 2^0.5/2
  } else {
    diff.factor = 1
  }
  n <- nrow(data.frame)
  df.stack <- stack(data.frame)
  index <- rep(1:n, k)
  p.means <- tapply(df.stack$values, index, mean)
  norm.df <- data.frame - p.means + (sum(data.frame)/(n * k))
  t.mat <- matrix(, k, 1)
  mean.mat <- matrix(, k, 1)
  for (i in 1:k) t.mat[i, ] <- t.test(norm.df[i])$statistic[1]
  for (i in 1:k) mean.mat[i, ] <- mean(as.vector(t(norm.df[i])))
  c.factor <- (k/(k - 1))^0.5
  moe.mat <- mean.mat/t.mat * qt(1 - (1 - conf.level)/2, n - 1) * c.factor * 
    diff.factor
  ci.mat <- matrix(, k, 3)
  for (i in 1:k) {
    ci.mat[i, 1] <- mean.mat[i] - moe.mat[i]
    ci.mat[i, 2] <- mean.mat[i]
    ci.mat[i, 3] <- mean.mat[i] + moe.mat[i]
  }
  ci <- data.frame(ci.mat)
  ci <- cbind(names(data.frame), ci)
  colnames(ci) <- c("Condition", "lower", "av", "upper")
  ci
}

## Bayes factor code
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



