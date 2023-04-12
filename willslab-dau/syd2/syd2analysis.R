print('DAU: SYD2')
print('Jessica Lee')
print('2014-11-27')
print('Loading "ez" package for ANOVA...')
library(ez)
print('Loading raw data and preprocessing...')

#### Shanks-Darby training - preprocessing
data.train <- read.table("syd2dataTRAIN.txt", header=TRUE, sep="\t")
# Make data fram slightly more human readable.
data.train$group[data.train$group == 2] <- 'nohint'
data.train$group[data.train$group == 3] <- 'hint'
letcodes1 <- factor(c('A','B','AB','C','D','CD','E','F','EF','G','H','GH',
                     'I','J','KL','M','N','OP'))
data.train$stimtype <- letcodes1[ match(data.train$stimtype, 1:18)]
# Create a new column with actual bet
data.train$bet <- abs(data.train$acc)
# Create a new column with 'accuracy' 
# (correct if bet 100 on win trial, or bet 1 on lose trial
# incorrect otherwise) 
data.train$accur <- 0
data.train$accur[data.train$outcome == 1 & data.train$resp == 3] <- 1
data.train$accur[data.train$outcome == 2 & data.train$resp == 1] <- 1
data.train$accur[data.train$resp == 2] <- 0.5 # I added
# Calculate overall win/loss by participant
tally <- aggregate(data.train$acc,list(data.train$group,data.train$subj),sum)
colnames(tally) <- c('group', 'subj', 'tally')
# Define failing participants as those with a non-negative tally
fail <- tally[tally$tally < 0,]
# Remove non-passing participants from data set
data.train <- data.train[!(data.train$subj %in% fail$subj),]

#### Shanks-Darby ratings - preprocessing
data.rats <- read.table("syd2dataRATS.txt", header=TRUE, sep="\t")
# Make data fram slightly more human readable.
data.rats$group[data.rats$group == 2] <- 'nohint'
data.rats$group[data.rats$group == 3] <- 'hint'
letcodes2 <- factor(c('A','B','AB','C','D','CD','E','F','EF','G','H','GH',
                      'I','J','KL','M','N','OP',
                      'IJ','K','L','MN','O','P'))
data.rats$stimtype <- letcodes2[ match(data.rats$stimtype, 1:24)]

# Convert contingency ratings to be out of 100
data.rats$rating <- data.rats$rating/6

# Add column classifying stimulus as 'familiar win', 'familiar no win', or 'novel'.
letcat <- factor(c('win','win','nowin','nowin','nowin','win','win','win','nowin','nowin','nowin','win',
                      'win','win','nowin','nowin','nowin','win',
                      'novel','novel','novel','novel','novel','novel'))
data.rats$coroutcome <- letcat[ match(data.rats$stimtype, letcodes2)]

# Remove non-passing participants from data set
data.rats <- data.rats[!(data.rats$subj %in% fail$subj),]

print('Commencing analyses...')

print('SHANKS-DARBY TRAINING')

print('Terminal accuracy by group')
blockacc <- aggregate(data.train$accur,list(data.train$subj,data.train$group,data.train$block),mean)
colnames(blockacc) <- c('subj', 'group', 'block', 'termacc')
termacc <- subset(blockacc,block==6)
print(t.test(termacc~group, data=termacc, paired=FALSE))

print('SHANKS-DARBY RATINGS')

print('Familiar item performance: ANOVA')
familiar.rats <- data.rats[data.rats$coroutcome != 'novel',]

# Calculating difference in rating for familiar win (+) and no win (-) cues
familiartest <- aggregate(familiar.rats$rating,
                          list(familiar.rats$subj,familiar.rats$group,familiar.rats$coroutcome)
                          ,mean)
colnames(familiartest) <- c('subj', 'group', 'coroutcome', 'rating')
print(ezStats(data=familiartest, dv=rating, wid=subj, within=coroutcome, between=group,type=3))
print(ezANOVA(data=familiartest, dv=rating, wid=subj, within=coroutcome, between=group,type=3))
print('Familiar item: Hint condition')
fam.hint <- subset(familiartest, group == 'hint')
print(t.test(rating~coroutcome, data=fam.hint,paired=TRUE))
print('Familiar item: No hint condition')
fam.hint <- subset(familiartest, group == 'hint')
print(t.test(rating~coroutcome, data=fam.hint,paired=TRUE))

print('IJ v MN: ANOVA')
ijmn <- subset(data.rats, stimtype == 'IJ' | stimtype == 'MN')
print(ezStats(data=ijmn, dv=rating, wid=subj, within=stimtype, between=group,type=3))
print(ezANOVA(data=ijmn, dv=rating, wid=subj, within=stimtype, between=group,type=3))
print('IJ vs MN: hint condition')
ijmn.hint <- subset(ijmn, group == 'hint')
print(t.test(rating~stimtype, data=ijmn.hint,paired=TRUE))
print('IJ vs MN: no hint condition')
ijmn.nohint <- subset(ijmn, group == 'nohint')
print(t.test(rating~stimtype, data=ijmn.nohint,paired=TRUE))

print('K/L v O/P: ANOVA')
# Combine K/L and O/P
klop <- subset(data.rats, stimtype == 'K' | stimtype == 'L' | stimtype == 'O' | stimtype == 'P' )
klop$klop[klop$stimtype == 'K'] <- 'K/L'
klop$klop[klop$stimtype == 'L'] <- 'K/L'
klop$klop[klop$stimtype == 'O'] <- 'O/P'
klop$klop[klop$stimtype == 'P'] <- 'O/P'
klop <- aggregate(klop$rating,list(klop$subj,klop$group,klop$klop),mean)
colnames(klop) <- c('subj','group','stimtype','rating')
# Do the ANOVA
print(ezStats(data=klop, dv=rating, wid=subj, within=stimtype, between=group,type=3))
print(ezANOVA(data=klop, dv=rating, wid=subj, within=stimtype, between=group,type=3))
print('K/L vs O/P: hint condition')
klop.hint <- subset(klop, group == 'hint')
print(t.test(rating~stimtype, data=klop.hint,paired=TRUE))
print('K/L vs O/P: no hint condition')
klop.nohint <- subset(klop, group == 'nohint')
print(t.test(rating~stimtype, data=klop.nohint,paired=TRUE))

print('Rule-following index')
ij <- ijmn[ijmn$stimtype == 'IJ',]
mn <- ijmn[ijmn$stimtype == 'MN',]
knl <- klop[klop$stimtype == 'K/L',]
onp <- klop[klop$stimtype == 'O/P',]
rfi <- ij
rfi$rfi <- ( mn$rating - ij$rating + knl$rating - onp$rating ) / 2
print('RFI: Hint versus no hint')
print(aggregate(rfi$rfi,list(rfi$group),mean))
print(t.test(rfi~group,data=rfi,paired=TRUE))
print('RFI: Hint versus ZERO')
rfi.hint <- rfi[rfi$group=='hint',]
print(t.test(rfi.hint$rfi,mu=0))
print('RFI: No hint versus ZERO')
rfi.nohint <- rfi[rfi$group=='nohint',]
print(t.test(rfi.nohint$rfi,mu=0))
