print("DAU: PLY12: Core analysis")
print("CC BY-SA 4.0")
print("Author: Charlotte E.R. Edmunds")

## Set up
## ------
rm(list=ls())

## Import packages
library(effsize)
library(ggplot2)
library(Rmisc)

## Define functions 
source('PLY12 Functions.R')

## Load and pre-process data
## -------------------------
trialData <- read.csv("PLY12longData.csv", header=TRUE)

## Formatting of data
trialData$Condition <- revalue(trialData$Condition, 
                               c("EasyMed"="Easy-to-moderate",
                                 "HardMed"="Hard-to-moderate"))

trialData$Difficulty <- relevel(trialData$Difficulty, "Medium")
trialData$Difficulty <- relevel(trialData$Difficulty, "Easy")
trialData$Category <- factor(trialData$Category)
trialData$RT <- trialData$RT*1000

## Remove trials for with RT is >= 5000ms
print("Removed trials where RT >= 5000 ms.")
trialData <- trialData[trialData$RT<5000,]

## Produce Figure 3 ------------------------------------------------------------
trialData <- trialData[!trialData$Condition=="MedMed",]
data <- aggregate(list(trialData$Correct, trialData$RT),
                  list(trialData$Participant, trialData$Condition,
                       trialData$Block),
                  mean)
colnames(data) <- c("Participant", "Condition", "Block", "Accuracy", "RT")
data$Block <- factor(data$Block)
data$Condition <- factor(data$Condition)

summaryData <- summarySE(data, measurevar="Accuracy", 
                         groupvars=c("Condition", "Block"), 
                         na.rm=T)
summaryData["CI_DA"] <- NA
summaryData <- summaryDataL[with(summaryData, order(Block, Condition)), ]
for (i in 1:2){
    data_subset <- data[data$Block==i,]
    output <- bsci(data.frame=data_subset, group.var="Condition", dv.var="Accuracy", 
                   difference=T, pooled.error=FALSE, conf.level=0.95)
    summaryData$CI_DA[summaryData$Block==i] <- output[,3]-output[,2]
}
summaryData["Type"] <- "Accuracy"
levels(summaryData$Type) <- c("Accuracy", "Reaction time (ms)")

summaryData_rt <- summarySE(data, measurevar="RT", 
                            groupvars=c("Condition", "Block"), 
                            na.rm=T)
summaryData_rt["CI_DA"] <- NA
summaryData_rt <- summaryData_rt[with(summaryData_rt, order(Block, Condition)), ]
for (i in 1:2){
    data_subset <- data[data$Block==i,]
    output <- bsci(data.frame=data_subset, group.var="Condition", dv.var="RT", 
                   difference=T, pooled.error=F, conf.level=0.95)
    summaryData_rt$CI_DA[summaryData$Block==i] <- output[,3] - output[,2]
}

summaryData_rt$Condition <- revalue(summaryData_rt$Condition,
                                    c("EasyHard"="Easy-to-hard",
                                      "HardEasy"="Hard-to-easy"))

summaryData_rt <- rename(summaryData_rt, c("RT"="Accuracy", "RT_norm"="Accuracy_norm"))
summaryData_rt["Type"] <- "Reaction time (ms)"
combined <- rbind(summaryData, summaryData_rt)
dummy <- data.frame("Condition"=c("Easy-to-moderate","Easy-to-moderate","Hard-to-moderate","Hard-to-moderate"),
                    "Block"=c(1,1,1,1),
                    "Accuracy"=c(0.5,1,500,1300),
                    "Type"=c("Accuracy","Accuracy","Reaction time (ms)","Reaction time (ms)"))

plot_combined <- ggplot(combined, aes(y=Accuracy, x=as.factor(Block), group=Condition, shape=Condition)) + 
    geom_path(size = 0.8) + 
    geom_blank(data=dummy) +
    geom_errorbar(aes(ymax = Accuracy + CI_DA, ymin=Accuracy - CI_DA), width=0.2, linetype="solid", position=position_dodge(width=0.15)) +
    geom_point(size=3, fill = "white", position=position_dodge(width=0.15)) +
    scale_shape_manual(values=c(19,21)) +
    facet_wrap(~ Type, scales = "free_y") +
    labs(x="Block",y="") + theme_bw(base_size = 18) +
    theme(legend.justification=c(1,1), 
          legend.position=c(1,1.05),
          legend.title=element_blank(),
          plot.title = element_text(family="sans", size=18),
          axis.text.x  = element_text(family="sans", size=9), 
          axis.title.x = element_text(size=10),
          axis.text.y  = element_text(family="sans", size=9), 
          axis.title.y = element_text(size=0),
          legend.text = element_text(size = 9),
          strip.text.x = element_text(size=10, colour="white"),
          strip.background = element_rect(colour="black", fill="black"),        
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.border = element_rect(size = 1, colour = "black"),
          legend.key = element_blank(),
          legend.background = element_rect(fill="transparent"))

## Output graph
print("Displaying Figure 3.")
print(plot_combined)

## Null-hypothesis significance testing
## ------------------------------------

## Get test data 

test_data_B1 <- data[data$Block==1,]
test_data_B2 <- data[data$Block==2,]

## Accuracy
print("Block 1: Accuaracy")
TT_B1 <- t.test(Accuracy ~ Condition, test_data_B1, var.equal=T) # Sig.

## t-test and Cohen's d
print(TT_B1)
print(cohen.d(test_data_B1$Accuracy ~ test_data_B1$Condition))

print("Bayes Factor")

mean_diff <- TT_B1$estimate[1] - TT_B1$estimate[2]
sd_err <- mean_diff / TT_B1$statistic

print(paste("Sample mean difference:",round(mean_diff,3)))
print(paste("Standard error:", round(sd_err,3)))

print(Bf(sd=sd_err, obtained=mean_diff, uniform=0, 
         meanoftheory=0.101, sdtheory=0.054, tail=2))

## Block 2: Accuaracy

print("Block 2: Accuracy")

TT_B2 <- t.test(Accuracy ~ Condition, test_data_B2, var.equal=T) 
print(TT_B2)
print(cohen.d(test_data_B2$Accuracy ~ test_data_B2$Condition))

print("Bayes Factor")

mean_diff <- TT_B2$estimate[1] - TT_B2$estimate[2]
sd_err <- mean_diff / TT_B2$statistic

print(paste("Sample mean difference:",round(mean_diff,3)))

print(paste("Standard error:", round(sd_err,3)))

print(Bf(sd=sd_err, obtained=mean_diff, uniform=0,
         meanoftheory=-0.139, sdtheory=0.07, tail=2))

print("Bayes Factor under 6/7ths reduction:")

print(Bf(sd=sd_err, obtained=mean_diff, uniform=0,
         meanoftheory=-0.139*1/7, sdtheory=0.07*1/7, tail=2))

## Reaction times
## Block 1: RT
print("Block 1: RT")

TT_B1_RT <- t.test(RT ~ Condition, test_data_B1, var.equal=T) 
print(TT_B1_RT)
print(cohen.d(test_data_B1$RT ~ test_data_B1$Condition))

## Block 2: RT
print("Block 2: RT")
TT_B2_RT <- t.test(RT ~ Condition, test_data_B2, var.equal=T) 
print(TT_B2_RT)
print(cohen.d(test_data_B2$RT ~ test_data_B2$Condition))


