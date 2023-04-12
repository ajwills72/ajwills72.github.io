print("Analysis of CAM 2 data set")
print("01-Sep-2014, Andy Wills.")
print("Original analysis c. 2000, using Acorn BBC BASIC and Mac Statview.")
print("Analyses replicated in R when preparing DAU.")
print("NOTE: Wills (2002) reports three conditions. The 'no deadline'")
print("condition is data from Wills & McLaren (1997). That raw data")
print("set did not survive. Some stats in this analysis script are")
print("therefore different to the paper, as they include only two")
print("conditions - 1000 ms and 2500 ms.")
print("----")
print("Loading packages (ez, e1071)")
print("If you get an error here, install these packaages.")
library(e1071)
library(ez)
print("Loading raw data...")
dta <- read.table("cam2data.txt", header = TRUE, sep = "\t")
print("Pre-processing...")
# Name conditions for readability
dta$cond[dta$cond == 1] <- "2500 ms"
dta$cond[dta$cond == 2] <- "1000 ms"
# Create a column identifying time outs
dta$to <- 0
dta$to[dta$rt == -255] <- 1
# Extract test phase
tst <- dta[dta$phase == 2,]
# Recode resp as P(correct)
tst$pc <- 0
tst$pc[tst$resp == 1 & tst$catordist > 6] <- 1 #Correct to respond A where Aelem > Belem
tst$pc[tst$resp == 2 & tst$catordist < 6] <- 1 #Correct to respond B where Aelem < Belem
# Recode 'catordist' as difficulty
tst$diff <- 0
tst$diff[tst$catordist == 0] <- 1
tst$diff[tst$catordist == 1] <- 2
tst$diff[tst$catordist == 2] <- 3
tst$diff[tst$catordist == 3] <- 4
tst$diff[tst$catordist == 4] <- 5
tst$diff[tst$catordist == 5] <- 6
tst$diff[tst$catordist == 6] <- 7
tst$diff[tst$catordist == 7] <- 6
tst$diff[tst$catordist == 8] <- 5
tst$diff[tst$catordist == 9] <- 4
tst$diff[tst$catordist == 10] <- 3
tst$diff[tst$catordist == 11] <- 2
tst$diff[tst$catordist == 12] <- 1
# Remove difficulty level 7
tst <- tst[tst$diff !=7,]
print("Time out percentage, by condition") 
tof <- aggregate(tst$to,list(tst$subj,tst$cond),mean)
colnames(tof) <- c('subj','cond','pto')
print(t.test(pto ~ cond, data = tof,paired=FALSE,var.equal=TRUE))
# Set RTs for timeouts to an arbitrarily high number
tst$rt[tst$rt == -255] <- 1000
# Remove 4 slowest responses at each difficulty level for each subject.
trimt <- NULL
for(s in 101:132) {
    for(d in 1:6) {
      fast <- tst[tst$subj == s & tst$diff == d,]
      tmp <- order(fast$rt)
      fastout <- fast[tmp[1:16],]
      trimt <- rbind(trimt,fastout)
    }
}
# Note: In the original analysis, I failed to notice one difficulty
# level for one subject had 5 timeouts. 
# This one data point (out of 3072) has to be removed for comparability with original analysis.
trimt <- trimt[trimt$resp != 255,]
# House keeping
rm(fast,fastout,tof)
# Aggregate accuracy across 16 presentations at each level of IV
accag <- aggregate(trimt$pc,list(trimt$diff,trimt$subj,trimt$cond),mean)
colnames(accag) <- c('diff','subj','cond','acc')
# Now aggregate across participants
accsum <- aggregate(accag$acc,list(accag$diff,accag$cond),mean)
colnames(accsum) <- c('diff','cond','acc')
print("Accuracy scores (Figure 2, top row)")
print(accsum)
print("Accuracy ANOVA")
accag$diff <- as.character(accag$diff)
accout <- ezANOVA( data = accag
                   , dv = acc
                   , wid = subj
                   , within = c('diff')
                   , between = cond
                   , type = 3)
print(accout)
print("Note: Same pattern of results as when no-deadline included.")

# Aggregate mean RT across 16 presentations at each level of IV
rtag <- aggregate(trimt$rt,list(trimt$diff,trimt$subj,trimt$cond),mean)
colnames(rtag) <- c('diff','subj','cond','rt')
# Now aggregate across participants
rtsum <- aggregate(rtag$rt,list(rtag$diff,rtag$cond),mean)
colnames(rtsum) <- c('diff','cond','rt')
print("Mean RT scores (Figure 2, middle row)")
print(rtsum)
print("Mean RT ANOVA")
rtag$diff <- as.character(rtag$diff)
rtout <- ezANOVA( data = rtag
                   , dv = rt
                   , wid = subj
                   , within = c('diff')
                   , between = cond
                   , type = 3)
print(rtout)
print("Same pattern of results as when no-deadline included.")

# Aggregate stdev RT across 16 presentations at each level of IV
sdag <- aggregate(trimt$rt,list(trimt$diff,trimt$subj,trimt$cond),sd)
colnames(sdag) <- c('diff','subj','cond','stdev')
# Now aggregate across participants
sdsum <- aggregate(sdag$stdev,list(sdag$diff,sdag$cond),mean)
colnames(sdsum) <- c('diff','cond','stdev')
sdsum
print("Std. dev. of RT scores (Figure 2, bottom row)")
print(sdsum)
print("NOTE: 1000 ms condition, Difficulty level 6, Figure 2 -- plot error.")
print("Std. dev. RT ANOVA")
sdag$diff <- as.character(sdag$diff)
sdout <- ezANOVA( data = sdag
                  , dv = stdev
                  , wid = subj
                  , within = c('diff')
                  , between = cond
                  , type = 3)
print(sdout)
print("NOTE: Removal of no-deadline condition renders")
print("diff x cond interaction non-significant.")
print("Otherwise, pattern is similar.")

# Aggregate skew RT across 16 presentations at each level of IV
skewag <- aggregate(trimt$rt,list(trimt$diff,trimt$subj,trimt$cond),skewness, type = 1 )
colnames(skewag) <- c('diff','subj','cond','skew')
# Now aggregate across participants
skewsum <- aggregate(skewag$skew,list(skewag$cond),mean)
colnames(skewsum) <- c('diff','skew')
print("RT skewness scores (Figure 3)")
print(skewsum)
print("NOTE: Slight difference from Wills (2002) is due to rounding in original analysis.")
print("RT skewness ANOVA")
skewag$diff <- as.character(skewag$diff)
skewout <- ezANOVA( data = skewag
                  , dv = skew
                  , wid = subj
                  , within = c('diff')
                  , between = cond
                  , type = 3)
print(skewout)
print("Similar pattern to Wills (2002)")
print("Skew RT t-tests")
skewagt <- aggregate(skewag$skew,list(skewag$subj,skewag$cond),mean)
colnames(skewagt) <- c('subj','cond','skew')
skew25 <- skewagt$skew[skewagt$cond == "2500 ms"]
print("2500 ms condition:")
print(t.test(skew25,mu=0))
print("1000 ms condition:")
skew10 <- skewagt$skew[skewagt$cond == "1000 ms"]
print(t.test(skew10,mu=0))
print("Similar pattern to Wills (2002)")
print("---END---")
