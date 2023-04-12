print('DAU:    PLYM10')
print('Date:   2015-04-04')
print('Author: Andy J. Wills')
print("Note:   Based on scripts and analysis by Garret O'Connell")

# Load CRAN packages
library(ez)
library(perm)

# Load custom functions
source('bsci.R')
source('plym10plot.R')

# Load unmatched control trial-level data file
udta <- read.table('plym10umctrl.csv',sep=',',stringsAsFactors = FALSE,header=TRUE)

# Calculate training performance
u_train <- udta[udta$phase == 1,]
u_train$acc <- 0
u_train$acc[u_train$resp == u_train$stim] <- 1
u_tr_sum <- aggregate(u_train$acc,list(u_train$subj),sum)
colnames(u_tr_sum) <- c('subj','ph1error')
u_tr_sum$ph1error <- 60 - u_tr_sum$ph1error
u_tr_sum <- data.frame(u_tr_sum$subj,'ctrl',u_tr_sum$ph1error)
colnames(u_tr_sum) <- c('subj','grp','value')
rm(u_train)

# Calculate test performance
utest <- udta[udta$phase == 2,]
rm(udta)
utest$respA <- 0
utest$respA[utest$resp == 'A'] <- 1
u_test_sum <- aggregate(utest$respA,list(utest$subj,utest$stim),sum)
colnames(u_test_sum) <- c('subj','datum','value')
u_test_sum$datum <- as.numeric(u_test_sum$datum)
u_test_sum$datum <- 12 - u_test_sum$datum
u_test_sum$datum <- paste0('a',u_test_sum$datum)
u_test_sum <- data.frame(u_test_sum$subj,'uctrl',u_test_sum$datum,u_test_sum$value)
colnames(u_test_sum) <- c('subj','grp','datum','value')
rm(utest)

# Load patient and matched control summary data file
dta <- read.table('plym10pat.csv',sep=',',stringsAsFactors = FALSE,header=TRUE)
# Extract ages
ages <- dta[dta$datum == 'age',]
dta <- dta[dta$datum !='age',]

# Extract training phase
tdta <- dta[dta$datum=='ph1error',]
tdta <- subset(tdta,select=c('subj','grp','value'))
dta <- dta[dta$datum != 'ph1error',]

# Combine test data from unmatched controls
dta <- rbind(dta,u_test_sum)
rm(u_test_sum)

# Recode test data into bins...
dta$bin[dta$datum=='a12'] <- '1-proto'
dta$bin[dta$datum=='a11'] <- '2-low'
dta$bin[dta$datum=='a10'] <- '2-low'
dta$bin[dta$datum=='a9'] <- '2-low'
dta$bin[dta$datum=='a8'] <- '3-high'
dta$bin[dta$datum=='a7'] <- '3-high'
dta$bin[dta$datum=='a6'] <- '4-rand'
dta$value[dta$datum=='a5'] <- 10 - dta$value[dta$datum=='a5']
dta$bin[dta$datum=='a5'] <- '3-high'
dta$value[dta$datum=='a4'] <- 10 - dta$value[dta$datum=='a4']
dta$bin[dta$datum=='a4'] <- '3-high'
dta$value[dta$datum=='a3'] <- 10 - dta$value[dta$datum=='a3']
dta$bin[dta$datum=='a3'] <- '2-low'
dta$value[dta$datum=='a2'] <- 10 - dta$value[dta$datum=='a2']
dta$bin[dta$datum=='a2'] <- '2-low'
dta$value[dta$datum=='a1'] <- 10 - dta$value[dta$datum=='a1']
dta$bin[dta$datum=='a1'] <- '2-low'
dta$value[dta$datum=='a0'] <- 10 - dta$value[dta$datum=='a0']
dta$bin[dta$datum=='a0'] <- '1-proto'

# ... and aggregate into those bins
dta_bins_all <- aggregate(dta$value,list(dta$grp,dta$subj,dta$bin),mean)
colnames(dta_bins_all) <- c('cond','subj','datum','value')
# Convert to percentage
dta_bins_all$value <- dta_bins_all$value * 10

# ... make a subset excluding unmatched controls
dta_bins <- dta_bins_all[dta_bins_all$cond != 'uctrl',]
rm(dta)

# ... and, in dta_bins_all, put all ctrls into same condition
dta_bins_all$cond[dta_bins_all$cond == 'uctrl'] <- 'ctrl'

print('Patients and age-matched controls')
print('---------------------------------')
print('')
print('Training performance t-test')
print('---------------------------')
print(t.test(value ~ grp,data=tdta))
print('')
print('Figure 2C: Means and b/subj confidence interval')
print('-----------------------------------------------')
mci <- NULL
tmp <- data.frame(bsci(dta_bins[dta_bins$datum=='1-proto',], 
                  group.var=1, dv.var=4, pooled.error=TRUE, difference=TRUE))
tmp <- cbind('proto',c('amctrl','exp'),tmp)
colnames(tmp) <- c('datum','cond','lower','mean','upper')
mci <- rbind(mci,tmp)
tmp <- data.frame(bsci(dta_bins[dta_bins$datum=='2-low',], 
                  group.var=1, dv.var=4, pooled.error=TRUE, difference=TRUE))
tmp <- cbind('low dist',c('amctrl','exp'),tmp)
colnames(tmp) <- c('datum','cond','lower','mean','upper')
mci <- rbind(mci,tmp)
tmp <- data.frame(bsci(dta_bins[dta_bins$datum=='3-high',], 
                  group.var=1, dv.var=4, pooled.error=TRUE, difference=TRUE))
tmp <- cbind('high dist',c('amctrl','exp'),tmp)
colnames(tmp) <- c('datum','cond','lower','mean','upper')
mci <- rbind(mci,tmp)
tmp <- data.frame(bsci(dta_bins[dta_bins$datum=='4-rand',], 
                       group.var=1, dv.var=4, pooled.error=TRUE, difference=TRUE))
tmp <- cbind('rand',c('amctrl','exp'),tmp)
colnames(tmp) <- c('datum','cond','lower','mean','upper')
mci <- rbind(mci,tmp)
row.names(mci) <- NULL
print(mci)
rm(tmp)
print('Produce Figure 2C (to PDF)')
pdf(file='fig2C.pdf'
    , width= 3
    , height = 3
    , pointsize = 8
    , title = '')
binplot(mci)
dev.off()

print('')

print('Test phase ANOVA')
print('----------------')
print('')
print('Drop Random (6A, 6B) stimuli...')
dta_bins <- dta_bins[dta_bins$datum != '4-rand',]
print('...and perform ANOVA on other 3 levels')
tstout <- ezANOVA( data = dta_bins
                   , dv = value
                   , wid = subj
                   , within = c('datum')
                   , between = cond
                   , type = 3)
print(tstout$ANOVA)
print('')

print('Test phase permutation test')
print('---------------------------')

print(
permTS(value~cond,
       data=dta_bins,
       subset= datum=='3-high',
       alternative="less",
       method="pclt")
)

se <- function(x) sqrt(var(x)/length(x))

tmp <- dta_bins$value[dta_bins$datum=='3-high' & dta_bins$cond == 'exp']
print('HL: mean: ')
print(mean(tmp))
print('HL: SE: ')
print(se(tmp))

tmp <- dta_bins$value[dta_bins$datum=='3-high' & dta_bins$cond == 'ctrl']
print('ctrl: mean: ')
print(mean(tmp))
print('ctrl: SE: ')
print(se(tmp))

print('Test phase ANCOVA')
print('-----------------')

# Extract high-distortion stimuli
adta <- dta_bins[dta_bins$datum == '3-high',]
# Add ages
adta$age <- 300
adta$age[1:9] <- ages$value[10:18]
adta$age[10:18] <- ages$value[1:9]
# Do ANCOVA
results = lm(value ~ age + cond, data = adta)
print(anova(results))
# House keeping
rm(adta,ages)

print('Patients and all controls')
print('-------------------------')
print('')
print('Training performance t-test')
print('---------------------------')
tall <- rbind(tdta,u_tr_sum)
print(t.test(value ~ grp,data=tall))

print('')

print('Test phase permutation test')
print('---------------------------')

print(
  permTS(value~cond,
         data=dta_bins_all,
         subset= datum=='3-high',
         alternative="less",
         method="pclt")
)

