print("DAU: EXE10")
print("Andy Wills")
print("----")
source('exe10graphs.R') ## Custom plotting functions
source('bsci.R') ## diff-adj b/subj conf. intervals
source('exe10preprocess.R') ## Load and preprocess raw data
source('dienes2008.R')
library(ez)
print('Method, participants')
print('--------------------')
print('Removing non-learners, participant ID: ')
# Criterion: Not significantly above chance on run 2 (blocks 4-6)
# 65/108 is above chance.
# chisq.test(c(65,43))
tr.end <- dta[dta$blk > 3 & dta$blk < 7,]
tracc <- aggregate(tr.end$stimacc,list(tr.end$cond,tr.end$subj),mean)
colnames(tracc) <- c('cond','subj','acc')
rm(tr.end)
failed <- tracc$subj[tracc$acc < 65/108]
for(i in failed) {
  dta <- dta[dta$subj != i,]
}
print(failed)
rm(tracc,failed,i)

print('Removing indeterminate generalizers, participant ID: ')
# Criterion: Not significantly different from chance across 
# the 48 novel test items.
# 31/48 is different from chance. Symmetrically 17/48 is.  
# chisq.test(c(31,17))
# So exclusion zone is 31 > x > 17

# Select novel test items, exclude timeouts
test.rf <- dta[
                dta$stimtype != 'famP' & 
                dta$stimtype != 'famN' &
                dta$blk > 6 &
                dta$resp > -1,
                ]

test.rf.subj <- aggregate(
  test.rf$stimacc,list(test.rf$cond,test.rf$subj),mean)
colnames(test.rf.subj) <- c('cond','subj','rf')

failed <- test.rf.subj$subj[ test.rf.subj$rf < 31/48 & test.rf.subj$rf > 17/48]
for(i in failed) {
  dta <- dta[dta$subj != i,]
}
print(failed)

print('Re-classify participants on basis of generalization performance.')
passed <-
    test.rf.subj[test.rf.subj$rf >= 31/48 | test.rf.subj$rf <= 17/48,]
passed$gencond[passed$rf >= 31/48] <- 'rule-con'
passed$gencond[passed$rf <= 17/48] <- 'sim-con'
#table(passed$cond,passed$gencond)

for(i in passed$subj) {
  dta$gencond[dta$subj == i] <- passed$gencond[passed$subj == i]
}

rm(test.rf, test.rf.subj,failed,i)

print('List of participants to include in fMRI analysis:')
print(passed)
print('Number of rule-based and similarity-based responders:')
nums<-table(passed$cond)
print(nums)
print(chisq.test(nums))
rm(passed,nums)

##### Training phase #####

print('Behavioural results, training phase')

traindta <- dta[dta$phase == 1,]
train.timeouts <- traindta[traindta$resp == -1,]

print('Timeouts:')

trto <- aggregate(
  train.timeouts$resp,
  list(train.timeouts$gencond, train.timeouts$subj),
  sum)
colnames(trto) <- c('gencond','subj','nto')
trto$nto <- as.numeric(-trto$nto)
trto$nto <- trto$nto / (36*6)
# Subjects 37, 56 produced no timeouts
# 'aggregate' misses these so they have to be added manually
trto <- rbind(trto,c('sim-con',37,0), c('rule-con',56,0))
trto$nto <- as.numeric(trto$nto)

print(t.test(nto ~ gencond, data=trto, paired=FALSE, var.equal=FALSE))

print('Rule consistent (SD): ')
print(
sd(trto$nto[trto$gencond == 'rule-con'])
)
print('Similarity consistent (SD): ')
print(
sd(trto$nto[trto$gencond == 'sim-con'])
)
rm(trto,train.timeouts)

print('Difference from chance in run 2:')
traindta <- traindta[traindta$blk > 3,]
tracc <- aggregate(traindta$stimacc,
                   list(traindta$gencond,traindta$subj),mean)
colnames(tracc) <- c('gencond','subj','acc')
print('Rule-consistent condition:')
tmp <- tracc$acc[tracc$gencond=='rule-con']
print(t.test(tmp,mu=.5))
print('SD:')
print(sd(tmp))

print('Similarity-consistent condition:')
tmp <- tracc$acc[tracc$gencond=='sim-con']
print(t.test(tmp,mu=.5))
print('SD:')
print(sd(tmp))

print('Difference between conditions in run 2')

print(
    t.test(acc ~ gencond, data = tracc, paired = FALSE, var.equal =
    FALSE)
)

print('RTs by condition in run 2')

trrt <- aggregate(traindta$rt, list(traindta$gencond, traindta$subj), median)
colnames(trrt) <- c('gencond','subj','rt')

print(
    t.test(rt ~ gencond, data = trrt, paired = FALSE, var.equal =
    FALSE)
    )

rm(tracc,trrt,traindta,tmp)

#### Test phase ####

print('Test phase')
testdta <- dta[dta$phase == 2,]
testdta$blk <- testdta$blk - 6
test.timeouts <- testdta[testdta$resp == -1,]

print("Timeouts")

trto <- aggregate(
  test.timeouts$resp,list(test.timeouts$gencond,test.timeouts$subj),sum)
colnames(trto) <- c('gencond','subj','nto')
trto$nto <- as.numeric(-trto$nto)
trto$nto <- trto$nto / (30*4)

# Some participants produce no timeouts
# They have to be added manually as zeros.
subadd <- rbind(
  c('sim-con',  7,0), c('sim-con',  9,0), c('rule-con',	10,0),
  c('rule-con',	21,0), c('sim-con',	31,0), c('rule-con',	38,0), 
  c('sim-con',	40,0), c('rule-con',	41,0), c('rule-con',	49,0), 
  c('rule-con',	53,0), c('rule-con',	56,0), c('rule-con',	61,0), 
  c('rule-con',	63,0), c('rule-con',	66,0), c('sim-con',	68,0)
)
colnames(subadd) <- c('gencond','subj','nto')
trto <- rbind(trto,subadd)
trto$nto <- as.numeric(trto$nto)

print(t.test(nto ~ gencond,data=trto,paired=FALSE))
print('rule-con SD:')
print(sd(trto$nto[trto$gencond == 'rule-con']))
print('sim-con SD:')
print(sd(trto$nto[trto$gencond == 'sim-con']))

rm(trto,subadd,test.timeouts)

# Figure 2A calculations - plot later to make single Figure 2
test.fam <- testdta[testdta$stimtype == 'famN' | testdta$stimtype == 'famP',]
test.fam <- test.fam[test.fam$resp > -1,]

test.fam.subj <- aggregate(
  test.fam$stimacc,list(test.fam$gencond,test.fam$blk,test.fam$subj),mean)
colnames(test.fam.subj) <- c('gencond','blk','subj','acc') 

rule.fam <- bsci(test.fam.subj[test.fam.subj$gencond =='rule-con',]
                 , group.var=2, dv.var=4, pooled.error=FALSE, difference=TRUE)

sim.fam <- bsci(test.fam.subj[test.fam.subj$gencond =='sim-con',]
                 , group.var=2, dv.var=4, pooled.error=FALSE, difference=TRUE)

print('Familiar items above chance')

fam.sum <- aggregate(
  test.fam$stimacc,list(test.fam$gencond,test.fam$subj),mean)
colnames(fam.sum) <- c('gencond','subj','acc') 

print('Rule-consistent condition:')
tmp <- fam.sum$acc[fam.sum$gencond=='rule-con']
print(t.test(tmp,mu=.5))
print('SD:')
print(sd(tmp))

print('Similarity-consistent condition:')
tmp <- fam.sum$acc[fam.sum$gencond=='sim-con']
print(t.test(tmp,mu=.5))
print('SD:')
print(sd(tmp))

print('Difference between conditions:')
famt <- t.test(acc ~ gencond, data = fam.sum, paired = FALSE, var.equal = FALSE)
print(famt)
rm(fam.sum)

print('Familiar RT by condition')
famrt.sum <- aggregate(
  test.fam$rt,list(test.fam$gencond,test.fam$subj),median)
colnames(famrt.sum) <- c('gencond','subj','rt') 
famrt <- t.test(rt ~ gencond, data = famrt.sum, paired = FALSE,
                var.equal = FALSE)
print(famrt)
rm(famrt,famrt.sum)

print('Figure 2 (output to PDF)')

print('Prepare plot')

test.crit <- testdta[testdta$stimtype == 'MN' | 
                     testdta$stimtype == 'IJ' |
                     testdta$stimtype == 'K/L' |
                     testdta$stimtype == 'O/P' 
                       ,]

test.crit <- test.crit[test.crit$resp > -1,] # Timeouts as missing data

# stimacc codes critical trials as correct if response
# is rule-consistent. This needs to be reversed for 
# sim-consistent participants to get a strategy-consistency DV
test.crit$stimacc[test.crit$gencond == 'sim-con' & test.crit$stimacc == 0] <- 100
test.crit$stimacc[test.crit$gencond == 'sim-con' & test.crit$stimacc == 1] <- 0
test.crit$stimacc[test.crit$stimacc == 100] <- 1

crit.subj <- aggregate(test.crit$stimacc,
                       list(test.crit$gencond,test.crit$blk,test.crit$subj),
                       mean)
colnames(crit.subj) <- c('gencond','blk','subj','acc') 

rule.crit <- bsci(crit.subj[crit.subj$gencond =='rule-con',]
                , group.var=2, dv.var=4, pooled.error=FALSE, difference=TRUE)

sim.crit <- bsci(crit.subj[crit.subj$gencond =='sim-con',]
               , group.var=2, dv.var=4, pooled.error=FALSE, difference=TRUE)

lx <- .02
ly <- .04
pdf(file='fig2.pdf'
    , width= 3.5
    , height = 3
    , pointsize = 8
    , title = '')
par(mfrow=c(1,2))
trainplot(rule.fam,sim.fam,TRUE)
add_label(lx,ly,'(A) familiar')
trainplot(rule.crit,sim.crit,FALSE)
add_label(lx,ly,'(B) critical')
dev.off()

rm(test.fam,test.fam.subj)

print('Critical items:')

crit.sum <- aggregate(
  test.crit$stimacc,list(test.crit$gencond,test.crit$subj),mean)
colnames(crit.sum) <- c('gencond','subj','acc') 

print('Difference between conditions:')
critt <- t.test(acc ~ gencond, data = crit.sum, paired = FALSE, var.equal = FALSE)
print(critt)

print('Rule-consistent:')
tmp <- crit.sum$acc[crit.sum$gencond=='rule-con']
#print(t.test(tmp,mu=.5))
print('SD:')
print(sd(tmp))

print('Sim-consistent:')
tmp <- crit.sum$acc[crit.sum$gencond=='sim-con']
#print(t.test(tmp,mu=.5))
print('SD:')
print(sd(tmp))

### Bayes Factor

meandiff <- critt$estimate[1] - critt$estimate[2]
names(meandiff) <- 'meandiff'
SE <- meandiff / critt$statistic
names(SE) <- 'SE'
# What magnitude of difference is expected? 
# One reasonable possibility is to use the
# observed size of the difference for the 
# familiar test items
ediff <- famt$estimate[1] - famt$estimate[2]
names(ediff) <- 'ediff'
# Following Dienes (2014), use a 2-tailed
# normal distribution with an SD of half
# the mean.
esd <- ediff / 2
names(esd) <- 'esd'

print('Bayes Factor:')

print(
    Bf(SE, meandiff, uniform = FALSE, meanoftheory = ediff,
       sdtheory = esd, tail = 2)
)

print('Critical items RT by condition')

critrt.sum <- aggregate(
  test.crit$rt,list(test.crit$gencond,test.crit$subj),median)
colnames(critrt.sum) <- c('gencond','subj','rt') 

critrt <- t.test(rt ~ gencond, data = critrt.sum, paired = FALSE,
                 var.equal = FALSE)
print(critrt)
rm(critrt.sum,critrt)

print("Novel compounds: responses - prepare plot...")

test.nc <- testdta[testdta$stimtype == 'MN' |
                   testdta$stimtype == 'IJ',]
test.nc <- test.nc[test.nc$resp > -1,] # Timeouts as missing data

test.nc.subj <- aggregate(
  test.nc$resp,list(test.nc$stimtype,test.nc$gencond, test.nc$subj),
  mean)
colnames(test.nc.subj) <- c('stim','gencond','subj','pall')    

ij <- bsci(test.nc.subj[test.nc.subj$stim =='IJ',] ,
                 group.var=2, dv.var=4, pooled.error=FALSE,
                 difference=TRUE)

mn <- bsci(test.nc.subj[test.nc.subj$stim =='MN',] ,
                 group.var=2, dv.var=4, pooled.error=FALSE,
                 difference=TRUE)

print("Novel elements: responses -prepare  plot...")

test.ne <- testdta[testdta$stimtype == 'O/P' |
                   testdta$stimtype == 'K/L',]
test.ne <- test.ne[test.ne$resp > -1,] # Timeouts as missing data

test.ne.subj <- aggregate(
  test.ne$resp,list(test.ne$stimtype,test.ne$gencond, test.ne$subj),
  mean)
colnames(test.ne.subj) <- c('stim','gencond','subj','pall')    

op <- bsci(test.ne.subj[test.ne.subj$stim =='O/P',] ,
                 group.var=2, dv.var=4, pooled.error=FALSE,
                 difference=TRUE)

kl <- bsci(test.ne.subj[test.ne.subj$stim =='K/L',] ,
                 group.var=2, dv.var=4, pooled.error=FALSE,
                 difference=TRUE)
print('Output Figure 3 (to PDF)')
pdf(file='fig3.pdf'
    , width= 3.5
    , height = 2.5
    , pointsize = 8
    , title = '')
par(mfrow=c(1,2))
testplot.ce(ij,mn,'bottom','c')
add_label(lx,ly,'(C) compounds')
testplot.ce(op,kl,'bottom','e')
add_label(lx,ly,'(D) elements')
dev.off()

print('Novel compounds - ANOVA')

eza <- ezANOVA( data = test.nc.subj
                , dv = .(pall)
                , wid = .(subj)
                , within = .(stim)
                , between = .(gencond)
                , type = 3)
print(eza)

print('Rule group: t-test')
rulet <- test.nc.subj[test.nc.subj$gencond == 'rule-con',]
print(
    t.test(pall ~ stim, data = rulet, paired = TRUE)
)
print('Similarity group: t-test')
simt <- test.nc.subj[test.nc.subj$gencond == 'sim-con',]
print(
    t.test(pall ~ stim, data = simt, paired = TRUE)
)
rm(eza,test.nc.subj)

print("Novel compounds: RT ANOVA")
# Re-include timeouts in the RT analysis
test.nc <- testdta[testdta$stimtype == 'MN' | testdta$stimtype == 'IJ',]

test.nc.sum <- aggregate(
  test.nc$rt,list(test.nc$stimtype,test.nc$gencond),median)
colnames(test.nc.sum) <- c('stim','gencond','rt')    

test.nc.subj <- aggregate(
  test.nc$rt,list(
    test.nc$gencond,test.nc$stimtype,test.nc$subj),median)
colnames(test.nc.subj) <- c('gencond','stim','subj','rt')

eza <- ezANOVA( data = test.nc.subj
                , dv = .(rt)
                , wid = .(subj)
                , within = .(stim)
                , between = .(gencond)
                , type = 3)
print(eza)

print('Novel compounds: RT means by condition')
print(
t.test(rt ~ gencond,data = test.nc.subj, paired = FALSE, var.equal = FALSE)
)
rm(eza,test.nc.subj,test.nc.sum)
rm(test.nc)

print('Novel elements - ANOVA')

eza <- ezANOVA( data = test.ne.subj
                , dv = .(pall)
                , wid = .(subj)
                , within = .(stim)
                , between = .(gencond)
                , type = 3)
print(eza)

print('Rule group: t-test')
rulet <- test.ne.subj[test.ne.subj$gencond == 'rule-con',]
print(
    t.test(pall ~ stim, data = rulet, paired = TRUE)
)
print('Similarity group: t-test')
simt <- test.ne.subj[test.ne.subj$gencond == 'sim-con',]
print(
    t.test(pall ~ stim, data = simt, paired = TRUE)
)
rm(eza,test.nc.subj)

print("Novel elements: RT ANOVA")
# Re-include timeouts in the RT analysis
test.ne <- testdta[testdta$stimtype == 'K/L' | testdta$stimtype == 'O/P',]

test.ne.sum <- aggregate(
  test.ne$rt,list(test.ne$stimtype,test.ne$gencond),median)
colnames(test.ne.sum) <- c('stim','gencond','rt')    

test.ne.subj <- aggregate(
  test.ne$rt,list(
    test.ne$gencond,test.ne$stimtype,test.ne$subj),median)
colnames(test.ne.subj) <- c('gencond','stim','subj','rt')

eza <- ezANOVA( data = test.ne.subj
                , dv = .(rt)
                , wid = .(subj)
                , within = .(stim)
                , between = .(gencond)
                , type = 3)
print(eza)

print('Novel elements: RT means by condition')

eza <- ezStats( data = test.ne.subj
                , dv = .(rt)
                , wid = .(subj)
                , within_full = .(stim)
                , between = .(gencond)
                , type = 3)
print(eza)

# END



