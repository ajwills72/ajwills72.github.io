print("Analysis of CAM 1 data set")
print("26-Aug-2014, Andy Wills.")
print("Original analysis c. 1999, using Acorn BBC BASIC and Mac Statview.")
print("Analyses replicated in R when preparing DAU.")
print("----")
dta <- read.table("cam1data.txt", header = TRUE, sep = "\t")
# Extract test phase
tstfull <- dta[dta$phase == 2,]
tst <- tstfull[tstfull$catordist < 10,] # Remove dummy stimuli
tst$catordist <- tst$catordist - 1 # Convert 'catordist' to number of elements
rm(tstfull) # Housekeeping
# Create separate column for each response
tst$resp1 <- 0
tst$resp2 <- 0
tst$resp3 <- 0
tst$resp1[tst$resp == 1] <- 1
tst$resp2[tst$resp == 2] <- 1
tst$resp3[tst$resp == 3] <- 1
# Name conditions for readability
tst$cond[tst$cond == 1] <- "Three-choice"
tst$cond[tst$cond == 2] <- "Two-choice"
tst$cond[tst$cond == 3] <- "Novel-elements"
# Aggregate across 10 presentations at each level of the IV.
tstag <- aggregate(list(tst$resp1,tst$resp2,tst$resp3),list(tst$catordist,tst$subj,tst$cond,tst$fixed),mean) 
colnames(tstag) <- c('v2','subj','cond','fixed','prob1','prob2','prob3')
tstag$v1 <- 8 - tstag$v2
# Recoding due to counterbalance conditions.
tstag$rp1 <- NA
tstag$rp1[tstag$fixed == 1] <- tstag$prob2[tstag$fixed == 1]
tstag$rp1[tstag$fixed == 2] <- tstag$prob1[tstag$fixed == 2]
tstag$rp1[tstag$fixed == 3] <- tstag$prob1[tstag$fixed == 3]
tstag$rp2 <- NA
tstag$rp2[tstag$fixed == 1] <- tstag$prob3[tstag$fixed == 1]
tstag$rp2[tstag$fixed == 2] <- tstag$prob3[tstag$fixed == 2]
tstag$rp2[tstag$fixed == 3] <- tstag$prob2[tstag$fixed == 3]
tstag$pa <- NA
tstag$pa[tstag$fixed == 1] <- tstag$prob1[tstag$fixed == 1]
tstag$pa[tstag$fixed == 2] <- tstag$prob2[tstag$fixed == 2]
tstag$pa[tstag$fixed == 3] <- tstag$prob3[tstag$fixed == 3]
tstag$nb <- NA
tstag$nb[tstag$fixed == 1] <- tstag$v1[tstag$fixed == 1]
tstag$nb[tstag$fixed == 2] <- tstag$v2[tstag$fixed == 2]
tstag$nb[tstag$fixed == 3] <- tstag$v1[tstag$fixed == 3]
print("Figure 4A: means")
# Aggregate across subjects
fig4a <- aggregate(tstag$pa,list(tstag$nb,tstag$cond),mean)
colnames(fig4a) <- c('catb','cond','pa')
fig4a <- fig4a[fig4a$cond != 'Two-choice',]
#Display data for Figure 4A
print(fig4a)
print("P(A:A,B,C) 2nd-order polynomial regression: Three-choice condition")
threec <- fig4a[fig4a$cond == "Three-choice",]
fit3c <- lm(threec$pa ~ poly(threec$catb,2,raw=TRUE))
print(summary(fit3c))
print("Note: Paper reports p < .05 for 2nd order co-efficient.")
print("More properly, this is p = .05 (to 2 sig. fig.)")
print("P(A:A,B,C) 2nd-order polynomial regression: Novel-elements condition")
novelc <- fig4a[fig4a$cond == "Novel-elements",]
fitnovelc <- lm(novelc$pa ~ poly(novelc$catb,2,raw=TRUE))
print(summary(fitnovelc))
print("---")

print("Figure 4B: means")
### NOTE ###
# 1. Although covered in the paper, it's probably worth
# emphasizing that each line in Figure 4B is the mean of two
# generalization gradients - (1) the probability of choosing category 
# lower-case b as a function of the number of category lower-case b
# elements, and (2) the probability of choosing category lower-case c
# as a function of the number of category lower-case c elements.
# This averaging is performed at an individual-subject level, and
# the average function for each participant is subsequently averaged
# to produce Figure 4B.

# Create the two generalization functions
rp1 <- aggregate(tstag$rp1,list(tstag$v1,tstag$subj,tstag$cond),mean)
colnames(rp1) <- c('catap','subj','cond','rp1')
rp2 <- aggregate(tstag$rp2,list(tstag$v2,tstag$subj,tstag$cond),mean)
colnames(rp2) <- c('catap','subj','cond','rp2')
# Average them
rp <- cbind(rp1,rp2)
rp$rp <- (rp1$rp1+rp2$rp2)/2
# Now aggregate across subjects
fig4b <- aggregate(rp$rp,list(rp$catap,rp$cond),mean)
colnames(fig4b) <- c('catap','cond','rp')
print(fig4b)
print("---")
print("Figure 4C: means")
three <- fig4b$rp[fig4b$cond == "Three-choice"]
two <- fig4b$rp[fig4b$cond == "Two-choice"]
novel <- fig4b$rp[fig4b$cond == "Novel-elements"]
q <- (two-three)/three
qprime <- (novel-three)/three
fig4c <- rbind(q,qprime)
colnames(fig4c) <- c(0:8)
print(fig4c)
print("q-statistic 2nd-order polynomial regression")
fitq <- lm(q ~ poly(0:8,2,raw=TRUE))
print(summary(fitq))
print("Note: F for model estimate, and 2nd-order term, slightly different to paper, due to rounding.")
print("q-prime-statistic 2nd-order polynomial regression")
print(qprime)
fitqprime <- lm(qprime ~ poly(0:8,2,raw=TRUE))
print(summary(fitqprime))
print("---END---")
