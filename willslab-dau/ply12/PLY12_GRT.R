print("DAU: PLY12: GRT analysis")
print("CC BY-SA 4.0")
print("Author: Charlotte E.R. Edmunds")

## Set up
## ------
rm(list=ls())

## Import packages
library(grt)

## Define functions 
source('PLY12 Functions.R')

## Load data
## ---------
trialData <- read.csv("PLY12longData.csv", header=TRUE)

## Formatting of factor levels
trialData$Condition <- revalue(trialData$Condition, 
                               c("EasyMed"="Easy-to-medium",
                                 "HardMed"="Hard-to-medium"))

trialData$Difficulty <- relevel(trialData$Difficulty, "Medium")

trialData$Difficulty <- relevel(trialData$Difficulty, "Easy")

trialData$Category <- factor(trialData$Category)

trialData$RT <- trialData$RT*1000

## Remove trials for which RT >= 5000ms
trialData <- trialData[trialData$RT<5000,]

resultsGRT <- aggregate(list(trialData$Correct, trialData$RT),
                        list(trialData$Participant, trialData$Condition,
                             trialData$Block),
                        mean)
colnames(resultsGRT) <- c("Participant", "Condition", "Block", "Accuracy", "RT")

## Model fitting
print("Find best-fitting GRT model for each block of each participant.")
print("NOTE: May take a while...")

resultsGRT[c('Model','minBIC','wBIC','BIC.RND','BIC.RND_BIAS','BIC.UDF',
             'BIC.UDO','BIC.CJ_UR','BIC.CJ_UL','BIC.CJ_LL','BIC.CJ_LR',
             'BIC.GLC','w.RND','w.RND_BIAS','w.UDF','w.UDO','w.CJ_UR',
             'w.CJ_UL','w.CJ_LL','w.CJ_LR','w.GLC')] <- NA

for(i in 1:nrow(resultsGRT)){
    print(i)
    data_onesub <- subset(trialData,
                          Participant==resultsGRT$Participant[i] & 
                              Block==resultsGRT$Block[i])
    data_onesub <- data_onesub[!is.na(data_onesub$Response),]
    resultsGRT[i,c(6:26)] <- grtmodel(data_onesub)
}

resultsGRT$Model <- revalue(resultsGRT$Model, 
                            c("UDF"="UD","UDO"="UD",
                              "CJ_UL"="CJ","CJ_UR"="CJ"))

counts <- table(resultsGRT$Block, resultsGRT$Model, 
                resultsGRT$Condition)[,c(2,1,5,3,4),]
results <- prop.table(counts, c(3,1))

wBIC <- aggregate(list(as.numeric(resultsGRT$wBIC)),
                  list(resultsGRT$Condition, resultsGRT$Model, 
                       resultsGRT$Block), mean)
colnames(wBIC) <- c("Condition","Model","Block","wBIC")
wBIC$wBIC <- round(wBIC$wBIC, 2)

print("Table 1 (Experiment 2):")
resultsGRT[,c(7:26)] <- apply(resultsGRT[,c(7:26)], 2, 
                              function(x) as.numeric(as.character(x)))
resultsGRT["wBICprop"] <- resultsGRT$w.GLC/apply(resultsGRT[,c("w.GLC",
                          "w.CJ_UL","w.CJ_UR","w.CJ_LL","w.CJ_LR","w.UDF",
                          "w.UDO")], 1, sum)
table_wBICprop <- aggregate(list(resultsGRT$wBICprop),
                            list(resultsGRT$Condition, resultsGRT$Block),
                            mean)
table_wBICprop <- table_wBICprop[table_wBICprop$Group.1!="MedMed",]
colnames(table_wBICprop) <- c("Condition", "Block", "NormProb")
print(table_wBICprop)

print("Appendix Table  (Experiment 2):")

print("Easy-to-moderate")
print("Strategy proportions:")
print(round(t(results[,,'Easy-to-medium']),2))
print("wBICs:")
print(wBIC[wBIC$Condition=="Easy-to-medium",])

print("Hard-to-moderate")
print("Strategy proportions:")
print(round(t(results[,,'Hard-to-medium']),2))
print("wBICs:")
print(wBIC[wBIC$Condition=="Hard-to-medium",])
