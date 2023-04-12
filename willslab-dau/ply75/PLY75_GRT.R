print("DAU: PLY75: GRT analysis")
print("CC BY-SA 4.0")
print("Author: Charlotte E.R. Edmunds")

## Set up
## ------
rm(list=ls())

## Import packages
library(grt)

## Define functions 
source('PLY75 Functions.R')

## Load data
## ---------
trialData <- read.csv("PLY75longData.csv", header=TRUE)

# Formatting of factor levels
trialData$Difficulty <- relevel(trialData$Difficulty, "Medium")
trialData$Difficulty <- relevel(trialData$Difficulty, "Easy")

trialData$Xvalue <- trialData$Xvalue*500

## GRT model-based analysis
## ------------------------

## Model fitting

print("Find best-fitting GRT model for each block of each participant.")
print("NOTE: May take a while...")

resultsGRT <- aggregate(list(trialData$Correct, trialData$RT),
                        list(trialData$Participant, trialData$Condition,
                             trialData$Block),
                        mean)
colnames(resultsGRT) <- c("Participant","Condition","Block","Accuracy","RT")

## Exclude non-learners
print("Remove participants with accuracy <= 0.3")
resultsGRT <- resultsGRT[resultsGRT$Accuracy>0.3,]

resultsGRT$Participant <- factor(resultsGRT$Participant)
resultsGRT [c('Model','minBIC','wBIC','BIC.RND','BIC.RND_BIAS','BIC.UDF',
              'BIC.UDO','BIC.CJ_UR','BIC.CJ_UL','BIC.CJ_LL','BIC.CJ_LR',
              'BIC.GLC','w.RND','w.RND_BIAS','w.UDF','w.UDO','w.CJ_UR',
              'w.CJ_UL','w.CJ_LL','w.CJ_LR','w.GLC')] <- NA
for(i in 1:nrow(resultsGRT)){
    cat(paste0(i,".."))
    onesub <- subset(trialData,
                     Participant==resultsGRT$Participant[i] & Block==
                     resultsGRT$Block[i])
    resultsGRT[i, c(6:26)] <- grtmodel(onesub)
}
print("Finished.")

resultsGRT$Model <- revalue(resultsGRT$Model, 
                            c("CJ_LR"="CJ","CJ_UL"="CJ",
                              "UDF"="UD","UDO"="UD"))
counts <- table(resultsGRT$Block, resultsGRT$Model,
                resultsGRT$Condition)[,c(2,1,5,3,4),]

results <- prop.table(counts, c(3,1))

resultsGRT[,c(7:26)] <- apply(resultsGRT[,c(7:26)], 2, 
                              function(x) as.numeric(as.character(x)))

wBIC <- aggregate(list(as.numeric(resultsGRT$wBIC)),
                  list(resultsGRT$Condition, resultsGRT$Model, 
                       resultsGRT$Block), mean)
colnames(wBIC) <- c("Condition","Model","Block","wBIC")
wBIC$wBIC <- round(wBIC$wBIC, 2)

print("Table 1 (Experiment 4):")

resultsGRT["wBICprop"] <- resultsGRT$w.GLC/
    apply(resultsGRT[,c("w.GLC","w.CJ_UL","w.CJ_UR","w.CJ_LL",
                        "w.CJ_LR", "w.UDF","w.UDO")], 1, sum)

table_wBICprop <- aggregate(list(resultsGRT$wBICprop),
                            list(resultsGRT$Condition,
                                 resultsGRT$Block),
                            mean)
colnames(table_wBICprop) <- c("Condition", "Block", "NormProb")
print(table_wBICprop)

print("Appendix Table  (Experiment 4):")

print("Easy-to-hard")
print("Strategy proportions:")
print(round(t(results[,,'EasyHard']),2))
print("wBICs:")
print(wBIC[wBIC$Condition=="EasyHard",])

print("Hard-to-easy")
print("Strategy proportions:")
print(round(t(results[,,'HardEasy']),2))
print("wBICs:")
print(wBIC[wBIC$Condition=="HardEasy",])

