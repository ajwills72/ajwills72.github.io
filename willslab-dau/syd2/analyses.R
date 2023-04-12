## DAU: SYD2
## Jessica Lee
## 2014-11-27

# Load raw data
data.train <- read.table("aus1dataTRAIN.txt", header=TRUE, sep="\t")
data.rats <- read.table("aus1dataRATS.txt", header=TRUE, sep="\t")
data.srt <- read.table("aus1dataSRT.txt", header=TRUE, sep="\t")
data.predict <- read.table("aus1dataPREDICT.txt", header=TRUE, sep="\t")
data.fchoice <- read.table("aus1dataFCHOICE.txt", header=TRUE, sep="\t")
data.rec <- read.table("aus1dataREC.txt", header=TRUE, sep="\t")

# Converting all ratings to be out of 100
data.rats$rating <- data.rats$rating/6

######## EXCLUSION CRITERIA ########
# Calculating tally
tally <- aggregate(data.train$acc,list(data.train$group,data.train$subj),sum)
colnames(tally) <- c('group', 'subj', 'tally')
# describeBy(tally,tally$group)   or this also works to look at means
# aggregate(tally,list(tally$group),mean)
# Excluding those on negative tally
excludelist <- NULL
for(i in 1:nrow(tally)) {
  if(tally$tally[i] < 0) {
    excludelist[i] <- tally$subj[i]
  } else {
    excludelist[i] <- NA
  }
}
excludelist <- excludelist[!is.na(excludelist)] # List of subjects to be excluded
hinttally <- subset(tally,group==3)
nohinttally <- subset(tally,group==2)
tallyRESULT <- t.test(hinttally$tally,nohinttally$tally,paired=FALSE)

######## PRIMARY TASK TRAINING ########

# Creating a new column with actual bet
data.train$bet <- abs(data.train$acc)
# Creating a new column with 'accuracy' (correct if 100 on win trial, 1 on lose trial - this is just one way)
data.train$accur <- '' 
for(i in 1:dim(data.train)[1]) {
  if(data.train$outcome[i] == 1 && data.train$resp[i] == 3) {
    data.train$accur[i] = 1
  } else if(data.train$outcome[i] == 1 && data.train$resp[i] == 1) {
    data.train$accur[i] = 0
  } else if(data.train$outcome[i] == 2 && data.train$resp[i] == 1) {
    data.train$accur[i] = 1
  } else if(data.train$outcome[i] == 2 && data.train$resp[i] == 3) {
    data.train$accur[i] = 0}
  else {
    data.train$accur[i] = 0 # Timeout
  }
}

data.train$accur <- as.numeric(data.train$accur)
# Exclusions
for(i in 1:length(excludelist)) {
  data.train$accur[data.train$subj == excludelist[i]] <- NA
}
data.train <- data.train[complete.cases(data.train),]

# Calculate accuracy per block, per group
blockacc <- aggregate(data.train$accur,list(data.train$subj,data.train$group),mean)
colnames(blockacc) <- c('subj', 'group', 'blockacc')
trainH <- subset(blockacc,group==3)
trainNH <- subset(blockacc,group==2)
trainRESULT <- t.test(trainH$blockacc,trainNH$blockacc,paired=FALSE,na.rm=TRUE)

# Calculating terminal accuracy 
blockacc <- aggregate(data.train$accur,list(data.train$subj,data.train$group,data.train$block),mean)
colnames(blockacc) <- c('subj', 'group', 'block', 'termacc')
termacc <- subset(blockacc,block==6)
termaccH <- subset(termacc,group==3)
termaccNH <- subset(termacc,group==2)
termaccRESULT <- t.test(termaccH$termacc,termaccNH$termacc,paired=FALSE,na.rm=TRUE)


######## RATINGS TEST ########

ratingdata <- aggregate(data.rats$rating,list(data.rats$subj,data.rats$stimtype,data.rats$group),mean)
colnames(ratingdata) <- c('subj', 'stimtype', 'group', 'rating')
# IJ vs. MN
ijmn <- subset(ratingdata, stimtype == 19 | stimtype == 22)
ijmn$stimtype[ijmn$stimtype == 19] <- 'IJ'
ijmn$stimtype[ijmn$stimtype == 22] <- 'MN'
# Exclusions
for(i in 1:length(excludelist)) {
  ijmn$rating[ijmn$subj == excludelist[i]] <- NA
}
# Interaction
ijmn$stimtype <- as.character(ijmn$stimtype)
ijmn$group <- as.character(ijmn$group)
ijmn <- ijmn[complete.cases(ijmn),]
ijmnRESULT <- ezANOVA(data=ijmn, dv=rating, wid=subj, within=stimtype, between=group,type=3)
# Simple effects
ijH <- subset(ijmn,group==3 & stimtype=='IJ')
mnH <- subset(ijmn,group==3 & stimtype=='MN')
ijNH <- subset(ijmn,group==2 & stimtype=='IJ')
mnNH <- subset(ijmn,group==2 & stimtype=='MN')
ijmnHRESULT <- t.test(ijH$rating,mnH$rating,paired=TRUE) # Hint
ijmnNHRESULT <- t.test(ijNH$rating,mnNH$rating,paired=TRUE)  # No Hint

# O/P vs. K/L
opkl <- subset(ratingdata, stimtype == 23 | stimtype == 24 | stimtype == 20 | stimtype == 21)
# Exclusions
for(i in 1:length(excludelist)) {
  opkl$rating[opkl$subj == excludelist[i]] <- NA
}
opkl <- opkl[complete.cases(opkl),]
# Calculate mean of K/L and O/P
avopkl <- data.frame("subj"=numeric(), "stimtype"=character(), "group"=character(), "rating"=numeric())
o <- subset(opkl,stimtype == 23 )
p <- subset(opkl,stimtype == 24)
k <- subset(opkl,stimtype == 20)
l <- subset(opkl,stimtype == 21)

for(i in 1:nrow(o)) {
  oprow <- ''
  oprow <- o[i,]
  oprow[2] <- "O/P"
  meanop <- (o$rating[i] + p$rating[i])/2
  oprow[4] <- meanop
  avopkl <- rbind(avopkl,oprow)
  klrow <- ''
  klrow <- k[i,]
  klrow[2] <- "K/L"
  meankl <- (k$rating[i] + l$rating[i])/2
  klrow[4] <- meankl
  avopkl <- rbind(avopkl,klrow)
}
rm(o,p,k,l,oprow,meanop,klrow,meankl)

# Interaction
opklRESULT <- ezANOVA(data=avopkl, dv=rating, wid=subj, within=stimtype, between=group,type=3)

# Simple effects
opH <- subset(avopkl,group==3 & stimtype=='O/P')
klH <- subset(avopkl,group==3 & stimtype=='K/L')
opNH <- subset(avopkl,group==2 & stimtype=='O/P')
klNH <- subset(avopkl,group==2 & stimtype=='K/L')
opklHRESULT <- t.test(opH$rating,klH$rating,paired=TRUE) 
opklNHRESULT <- t.test(opNH$rating,klNH$rating,paired=TRUE) 

# Single index of generalization (+ indicates rule, - indicates feature)
IJ <- subset(ijmn,stimtype == 'IJ')
MN <- subset(ijmn,stimtype == 'MN')
KL <- subset(avopkl,stimtype == 'K/L')
OP <- subset(avopkl,stimtype == 'O/P')
testratings <- cbind(MN, IJ$rating, KL$rating, OP$rating)
testratings$stimtype = NULL
colnames(testratings) <- c('subj', 'group', 'MN', 'IJ', 'KL', 'OP')
# Compute index for each participant
for(i in 1:nrow(testratings)) {
  testratings$index[i] <- (testratings$MN[i]-testratings$IJ[i]+testratings$KL[i]-testratings$OP[i])/2/100
}
indexH <- subset(testratings,group==3)
indexNH <- subset(testratings,group==2)
indexRESULT <- t.test(indexH$index, indexNH$index, paired=FALSE) 
# Simple effects
indexHRESULT <- t.test(indexH$index,mu=0)
indexNHRESULT <- t.test(indexNH$index,mu=0)

# Creating a new column that codes for the correct outcome
data.rats$coroutcome <- array(NA,nrow(data.rats))
for(i in 1:nrow(data.rats)) {
  if(data.rats$stimtype[i] == 1||data.rats$stimtype[i] == 2||data.rats$stimtype[i] == 6||data.rats$stimtype[i] == 7||data.rats$stimtype[i] == 8||data.rats$stimtype[i] == 12||data.rats$stimtype[i] == 13||data.rats$stimtype[i] == 14||data.rats$stimtype[i] == 18) {
    data.rats$coroutcome[i] <- 'win'
  } else {
    data.rats$coroutcome[i] <- 'no win'
  }
}
# Exclusions
for(i in 1:length(excludelist)) {
  data.rats$coroutcome[data.rats$subj == excludelist[i]] <- NA
}
data.rats <- data.rats[complete.cases(data.rats),]
# Calculating difference in rating for familiar win (+) and no win (-) cues
familiartest <- aggregate(data.rats$rating,list(data.rats$subj,data.rats$group,data.rats$coroutcome),mean)
colnames(familiartest) <- c('subj', 'group', 'coroutcome', 'rating')
familiarRESULT <- ezANOVA(data=familiartest, dv=rating, wid=subj, within=coroutcome, between=group,type=3)
                          

######## SRT TRAINING ########

# Mean accuracy per group
# aggregate(data.srt$acc,list(data.srt$group),mean)
# Mean RT per group overall (before excluding long RTs)
# aggregate(data.srt$rt,list(data.srt$group),mean)

# Exclusions
for(i in 1:length(excludelist)) {
  data.srt$rt[data.srt$subj == excludelist[i]] <- NA
}
data.srt <- data.srt[complete.cases(data.srt),]

# Excluding RTs for incorrect trials
data.srt$corRT <- array(NA,nrow(data.srt))
data.srt$RT <- array(NA,nrow(data.srt))
# This takes forever!
for(i in 1:nrow(data.srt)) {
  if(data.srt$acc[i]==1) {
    data.srt$corRT[i] <- data.srt$rt[i]
  } else {
    data.srt$corRT[i] <- NA
  }
}
# Excluding RTs > 1 sec
for(i in 1:nrow(data.srt)) {
  if(is.na(data.srt$corRT[i])==TRUE) {
    data.srt$RT[i] <- NA
  } else if(data.srt$corRT[i] <1) {
    data.srt$RT[i] <- data.srt$corRT[i]
  } else {
    data.srt$RT[i] <- NA
  }
}

# Coding into cued and miscued
data.srt$dir <- array(NA,nrow(data.srt))
data.srt$dir[data.srt$trialtype < 10] <- 'cued'
data.srt$dir[data.srt$trialtype > 10] <- 'miscued'
# Insert NA into first trial for each participant
# data.srt$dir[data.srt$trial < 2] <- NA (Aggregate not working, change the RTs instead)
 
# Coding into XYZ and ZYZ
data.srt$ssq <- array(NA,nrow(data.srt))
for(i in 3:nrow(data.srt)) {
  if(data.srt$pos[i]==data.srt$pos[i-2]) {
    data.srt$ssq[i] <- 'ZYZ'
  } else {
    data.srt$ssq[i] <- 'XYZ'
  }
}
data.srt$ssq[1] <- 'XYZ' # Using these as fillers (doesn't really matter what they are since we won't count these trials in the ANOVA)
data.srt$ssq[2] <- 'XYZ'
# Insert NAs into first 2 trials for each participant
# data.srt$ssq[data.srt$trial < 3] <- NA (Aggregate not working, change the RTs instead)

# Excluding first 2 trials for each participant
data.srt$RT[data.srt$trial < 3] <- NA
cueingdata <- aggregate(data.srt$RT,list(data.srt$subj,data.srt$group,data.srt$dir,data.srt$ssq),mean, na.rm=TRUE)
colnames(cueingdata) <- c('subj', 'group', 'dir', 'ssq', 'RT')

# Testing whether the cueing effect is different between groups (XYZ and ZYZ weighted equally)
srtRESULT <- ezANOVA(data=cueingdata, dv=RT, wid=subj, within=dir, between=group,type=3)
# describeBy(cueingdata$RT,list(cueingdata$group,cueingdata$dir))



# Still need to look at error data
...

######## PREDICTION TEST ########
# Exclusions
for(i in 1:length(excludelist)) {
  data.predict$acc[data.predict$subj == excludelist[i]] <- NA
}
data.predict <- data.predict[complete.cases(data.predict),]

predict <- aggregate(data.predict$acc,list(data.predict$subj,data.predict$group),mean)
colnames(predict) <- c('subj', 'group', 'acc')
predictH <- subset(predict,group==3)
predictNH <- subset(predict,group==2)
predictRESULT <- t.test(predictH$acc, predictNH$acc, paired=TRUE)
# describeBy(predict$acc,predict$group)


######## FORCED-CHOICE QUESTION ########
# Exclusions
for(i in 1:length(excludelist)) {
  data.fchoice$fchoice[data.fchoice$subj == excludelist[i]] <- NA
}
data.fchoice <- data.fchoice[complete.cases(data.fchoice),]

# Working out correct direction for each participant

sortpredict <- data.predict[order(data.predict$stim),] 
stim1 <- subset(sortpredict,stim==1)
for(i in 1:nrow(stim1)) {
  if(stim1$resp[i]==3 & stim1$acc[i]==1) {
    data.fchoice$cueddir[i] <- 2
  } else if(stim1$resp[i]==3 & stim1$acc[i]==0) {
    data.fchoice$cueddir[i] <- 1
  } else if(stim1$resp[i]==2 & stim1$acc[i]==1) {
    data.fchoice$cueddir[i] <- 1
  } else if(stim1$resp[i]==2 & stim1$acc[i]==0) {
    data.fchoice$cueddir[i] <- 2
  }
}

# This is just to check that the above is correct
# stim2 <- subset(sortpredict,stim==2)
# for(i in 1:nrow(stim2)) {
#   if(stim2$resp[i]==3 & stim2$acc[i]==1) {
#     stim2$dir[i] <- 1
#   } else if(stim2$resp[i]==3 & stim2$acc[i]==0) {
#     stim2$dir[i] <- 2
#   } else if(stim2$resp[i]==1 & stim2$acc[i]==1) {
#     stim2$dir[i] <- 2
#   } else if(stim2$resp[i]==1 & stim2$acc[i]==0) {
#     stim2$dir[i] <- 1
#   }
# }
# data.fchoice$cueddir==stim2$dir

# Coding accuracy for each participant
data.fchoice$acc[data.fchoice$fchoice==data.fchoice$cueddir] <- 1
data.fchoice$acc[data.fchoice$fchoice!=data.fchoice$cueddir] <- 0
# describeBy(data.fchoice$acc,data.fchoice$group)

fcH <- subset(data.fchoice,group==3)
fcNH <- subset(data.fchoice,group==2)
fcRESULT <- chisq.test(fcH$acc, fcNH$acc) # Don't know if this is correct (warning msg)
