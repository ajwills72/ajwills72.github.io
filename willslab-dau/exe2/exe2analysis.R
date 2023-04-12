# Analysis of EXE 2 data set
# 06-May-2014, Andy Wills.
# Analysis originally perfomed October 2010 using E Data Aid, Excel, and SPSS
# Analyses replicated in R when preparing DAU.

# Read in raw data
dta <- read.table("exe2data.txt", header = TRUE, sep = "\t")
code <- read.table("exe2code.txt", header = TRUE, sep = "\t",stringsAsFactors = FALSE)
# NB: This script assumes that the 'code' array is ordered by stimulus ID number, ascending.

# Add in the extra columns we'll need
stimcode <- array(NA,length(dta$cond))
stimcorr <- array(NA,length(dta$cond))
stimacc <- array(NA,length(dta$cond))
stimtype <- array(NA,length(dta$cond))
dta <- cbind(dta,stimcode,stimtype,stimcorr,stimacc)
rm(stimcode, stimtype,stimcorr,stimacc)

# Code logical trial types
dta$stimcode[dta$cb == 1] <- code$CB1code[dta$stim[dta$cb == 1]]
dta$stimcode[dta$cb == 2] <- code$CB2code[dta$stim[dta$cb == 2]]
# Code stimulus type
dta$stimtype[dta$cb == 1] <- code$CB1type[dta$stim[dta$cb == 1]]
dta$stimtype[dta$cb == 2] <- code$CB2type[dta$stim[dta$cb == 2]]
# Code food correct answers
dta$stimcorr[dta$cb == 1] <- code$CB1corr[dta$stim[dta$cb == 1]]
dta$stimcorr[dta$cb == 2] <- code$CB2corr[dta$stim[dta$cb == 2]]
# Code accuracy on food responses
dta$stimacc[dta$resp == dta$stimcorr] <- 1
dta$stimacc[dta$resp != dta$stimcorr] <- 0

#### Analysis of training phase ####
traindta <- dta[dta$phase == 2,]

# Determine accuracy by block
tracc <- aggregate(traindta$stimacc,list(traindta$blk,traindta$subj),mean)
colnames(tracc) <- c('blk','subj','acc')
# Determine maximum accuracy by subject
trmaxacc <- aggregate(tracc$acc,list(tracc$subj),max)
colnames(trmaxacc) <- c('subj','acc')
# Determine last block 
trmax <- aggregate(traindta$blk,list(traindta$subj),max)
colnames(trmax) <- c('subj','maxblk')
# Create a condition column (bit kludgy, but works)
cond <- aggregate(traindta$cond,list(traindta$subj),mean)
colnames(cond) <- c('subj','cond')
# Compile an overall summary array
summary <- cbind(cond,trmaxacc$acc,trmax$maxblk)
colnames(summary) <- c('subj','cond','lastacc','lastblk')

## RESULT 1: N of failure to meet criterion
summary[summary$lastacc < 32/36,]
passed <- summary[summary$lastacc >= 32/36,]
library(psych)
## RESULT 2: Stats for last block accuracy on those passing criterion
describeBy(passed$lastacc,passed$cond,mat=TRUE)
t.test(passed$lastacc ~ passed$cond,var.equal=TRUE)
## RESULT 3: Stats for last block on those passing criterion.
describeBy(passed$lastblk,passed$cond,mat=TRUE)
t.test(passed$lastblk ~ passed$cond,var.equal=TRUE)

## SUPPLEMENTRARY RESULT 1: Positive versus negative patterning
# E.Maes asked whether +ve patterning and -ve patterning problesm
# were learned at same rate. This seems best addressed with all
# participants (including non-learners), and with the variable length
# of training phase, easiest measure seems to be mean accuracy

elisa <- aggregate(traindta$stimacc,list(traindta$stimcode,traindta$subj),mean)
# Create a condition column (bit kludgy, but works)
cond <- aggregate(traindta$cond,list(traindta$stimcode,traindta$subj),mean)
colnames(cond) <- c('stim','subj','cond')
ppnp <- array('incomplete',length(cond$cond))
elisa <- cbind(cond$cond,ppnp,elisa)
colnames(elisa) <- c('cond','ppnp','stim','subj','acc')
# Create new set of labels to define NP and PP problems
elisa$ppnp[elisa$stim == 'A'] <- 'NP'
elisa$ppnp[elisa$stim == 'B'] <- 'NP'
elisa$ppnp[elisa$stim == 'AB'] <- 'NP'
elisa$ppnp[elisa$stim == 'C'] <- 'NP'
elisa$ppnp[elisa$stim == 'D'] <- 'NP'
elisa$ppnp[elisa$stim == 'CD'] <- 'NP'
elisa$ppnp[elisa$stim == 'E'] <- 'PP'
elisa$ppnp[elisa$stim == 'F'] <- 'PP'
elisa$ppnp[elisa$stim == 'EF'] <- 'PP'
elisa$ppnp[elisa$stim == 'G'] <- 'PP'
elisa$ppnp[elisa$stim == 'H'] <- 'PP'
elisa$ppnp[elisa$stim == 'GH'] <- 'PP'
# Aggregate on these new labels
elisasum <- aggregate(elisa$acc,list(elisa$ppnp,elisa$subj,elisa$cond),mean)
colnames(elisasum) <- c('ppnp','subj','cond','acc')
# Remove incomplete triplets (e.g. I, J)
elisasum <- elisasum[elisasum$ppnp != 'incomplete',]
library(ez)
elisasum$cond[elisasum$cond==1] <- 'load'
elisasum$cond[elisasum$cond==2] <- 'noload'
ezStats(data = elisasum, dv = acc, wid = subj, within = ppnp, between = cond, type = 3)
elout <- ezANOVA(data = elisasum, dv = acc, wid = subj, within = ppnp, between = cond, type = 3,detailed=TRUE)
elout

#### Analysis of test phase ####

# First, construct an array only containing those who passed
passdta <- NULL
for(i in passed$subj) {
  passdta <-rbind(passdta,dta[dta$subj == i,])
}
# Now, limit to test phase data
testdta <- passdta[passdta$phase == 3,]
# Now, aggregate over stimulus types
tsum <- aggregate(testdta$stimacc,list(testdta$stimtype,testdta$subj),mean)
colnames(tsum) <- c('stim','subj','acc')
# Create a condition column (bit kludgy, but works)
cond <- aggregate(testdta$cond,list(testdta$stimtype,testdta$subj),mean)
colnames(cond) <- c('stim','subj','cond')
tsum <- cbind(cond$cond,tsum)
colnames(tsum) <- c('cond','stim','subj','acc')
#Turn 'cond' to character label
#This is important as ezANOVA does not cope well with numeric factors.
tsum$cond[tsum$cond==1] <- 'load'
tsum$cond[tsum$cond==2] <- 'noload'

## RESULT 4: Familiar items ANOVA
fam <- tsum[tsum$stim == 'famN' | tsum$stim == 'famP',]
# The DV is P(allergy response), this requires conversion from the accuracy DV calculated above:
fam$acc[fam$stim == 'famN'] <- 1 - fam$acc[fam$stim == 'famN']
library(ez)
#fam$acc <- round(fam$acc,2)
# 2x2 ANOVA
famout <- ezANOVA(data = fam, dv = acc, wid = subj, within = stim, between = cond, type = 3,detailed=TRUE)
famout
# Familiar item performance, collapsing across condition:
ezStats(data = fam, dv = acc, wid = subj, within = stim, type = 3)

## RESULT 5: Novel compounds ANOVA
nc <- tsum[tsum$stim == 'MN' | tsum$stim == 'IJ',]
# The DV is P(allergy response), this requires conversion from the accuracy DV calculated above:
nc$acc[nc$stim == 'IJ'] <- 1 - nc$acc[nc$stim == 'IJ']
# 2x2 ANOVA
ncout <- ezANOVA(data = nc, dv = acc, wid = subj, within = stim, between = cond, type = 3,detailed=TRUE)
ncout
ezStats(data = nc, dv = acc, wid = subj, within = stim, between = cond, type = 3)

## RESULT 6: Novel elements ANOVA
ne <- tsum[tsum$stim == 'K/L' | tsum$stim == 'O/P',]
# The DV is P(allergy response), this requires conversion from the accuracy DV calculated above:
ne$acc[ne$stim == 'O/P'] <- 1 - ne$acc[ne$stim == 'O/P']
# 2x2 ANOVA
neout <- ezANOVA(data = ne, dv = acc, wid = subj, within = stim, between = cond, type = 3,detailed=TRUE)
neout
# N.B. In Wills et al. (2011), the F-ratio for 'stim' is reported as 0.69.
# This is a typographical error introduced somewhere in the publication process. 
# Both the original SPSS analysis and this reconstruction
# report 2.69. 
ezStats(data = ne, dv = acc, wid = subj, within = stim, between = cond, type = 3)

## RESULT 7: Novel compounds,load, t-test
ncnoload <- nc[nc$cond=='noload',]
describeBy(ncnoload$acc,ncnoload$stim,mat=TRUE)
t.test(ncnoload$acc ~ ncnoload$stim,var.equal=TRUE,paired=TRUE)

## RESULT 8: Novel compounds,load, t-test
ncload <- nc[nc$cond=='load',]
describeBy(ncload$acc,ncload$stim,mat=TRUE)
t.test(ncload$acc ~ ncload$stim,var.equal=TRUE,paired=TRUE)

## RESULT 9: Novel elements,no load, t-test
nenoload <- ne[ne$cond=='noload',]
describeBy(nenoload$acc,nenoload$stim,mat=TRUE)
t.test(nenoload$acc ~ nenoload$stim,var.equal=TRUE,paired=TRUE)

## RESULT 10: Novel elements,load, t-test
neload <- ne[ne$cond=='load',]
describeBy(neload$acc,neload$stim,mat=TRUE)
t.test(neload$acc ~ neload$stim,var.equal=TRUE,paired=TRUE)

## RESULT 11: Rule-following index, no load condition
rfinoload <- (ncnoload$acc[ncnoload$stim=='MN'] - ncnoload$acc[ncnoload$stim=='IJ'] + nenoload$acc[nenoload$stim=='K/L'] - nenoload$acc[nenoload$stim=='O/P'])/2
describe(rfinoload)
t.test(rfinoload,mu=0)

## RESULT 12: Rule-following index, load condition
rfiload <- (ncload$acc[ncload$stim=='MN'] - ncload$acc[ncload$stim=='IJ'] + neload$acc[neload$stim=='K/L'] - neload$acc[neload$stim=='O/P'])/2
describe(rfiload)
t.test(rfiload,mu=0)
