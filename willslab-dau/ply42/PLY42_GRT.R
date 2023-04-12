print("DAU: PLY42: GRT analysis")
print("CC BY-SA 4.0")
print("Author: Charlotte E.R. Edmunds")

## Set up  ---------------------------------------------------------------------
rm(list=ls())

## Import packages
library(grt)

## Define functions 
source('PLY42 Functions.R')

## Load data -------------------------------------------------------------------
trialData <- read.csv("PLY42longData.csv", header=TRUE)
trialData <- trialData[trialData$Condition != "AllAll",]
trialData <- droplevels(trialData)


## Formatting of factor levels
trialData$Condition <- revalue(trialData$Condition, 
                               c("EasyAll"="Easy-to-all",
                                 "HardAll"="Hard-to-all"))

trialData$Difficulty <- relevel(trialData$Difficulty, "Medium")

trialData$Difficulty <- relevel(trialData$Difficulty, "Easy")

trialData$Category <- factor(trialData$Category)

## Remove trials for which RT >= 5000ms
trialData <- trialData[trialData$RT<5000,]

## GRT model-based analysis ----------------------------------------------------
resultsGRT <- aggregate(list(trialData$Correct, trialData$RT),
                        list(trialData$Participant, trialData$Condition,
                             trialData$Block), mean)

colnames(resultsGRT) <- c("Participant", "Condition", "Block",
                          "Accuracy", "RT")

resultsGRT [c('Model','minBIC','wBIC','BIC.RND','BIC.RND_BIAS','BIC.UDF',
              'BIC.UDO','BIC.CJ_UR','BIC.CJ_UL','BIC.CJ_LL','BIC.CJ_LR',
              'BIC.GLC','w.RND','w.RND_BIAS','w.UDF','w.UDO','w.CJ_UR',
              'w.CJ_UL','w.CJ_LL','w.CJ_LR','w.GLC')] <- NA

print("Find best-fitting GRT model for each block of each participant.")
print("NOTE: May take a while...")

for(i in 1:nrow(resultsGRT)){
    cat(paste(i,".."))
    data_onesub <- subset(trialData,
                          Participant==resultsGRT$Participant[i] &
                          Block==resultsGRT$Block[i])
    data_onesub <- data_onesub[!is.na(data_onesub$Response),]
    resultsGRT[i,c(6:26)] <- grtmodel(data_onesub)
}
print("...finished.")

resultsGRT$Model <- revalue(resultsGRT$Model, 
                            c("UDF"="UD","UDO"="UD","CJ_UL"="CJ"))

counts <- table(resultsGRT$Block,resultsGRT$Model,
                resultsGRT$Condition)[,c(2,1,4,3),]
results <- prop.table(counts,c(3,1))

resultsGRT[,c(7:26)] <- apply(resultsGRT[,c(7:26)], 2, 
                              function(x) as.numeric(as.character(x)))
resultsGRT["wBICprop"] <- resultsGRT$w.GLC/apply(resultsGRT[,
   c("w.GLC","w.CJ_UL","w.CJ_UR","w.CJ_LL","w.CJ_LR",
     "w.UDF","w.UDO")], 1, sum)

print("Table 1 (Experiment 3):")
table_wBICprop <- aggregate(list(resultsGRT$wBICprop),
                            list(resultsGRT$Condition, resultsGRT$Block),
                            mean)
table_wBICprop <- table_wBICprop[table_wBICprop$Group.1!="AllAll",]
colnames(table_wBICprop) <- c("Condition", "Block", "NormProb")
print(table_wBICprop)

print("Appendix Table  (Experiment 3):")

wBIC <- aggregate(list(as.numeric(resultsGRT$wBIC)),
                  list(resultsGRT$Condition, resultsGRT$Model, 
                       resultsGRT$Block), mean)
colnames(wBIC) <- c("Condition","Model","Block","wBIC")
wBIC$wBIC <- round(wBIC$wBIC, 2)

print("Easy-to-all")
print("Strategy proportions:")
print(round(t(results[,,'Easy-to-all']),2))
print("wBICs:")
print(wBIC[wBIC$Condition=="Easy-to-all",])

print("Hard-to-all")
print("Strategy proportions:")
print(round(t(results[,,'Hard-to-all']),2))
print("wBICs:")
print(wBIC[wBIC$Condition=="Hard-to-all",])

