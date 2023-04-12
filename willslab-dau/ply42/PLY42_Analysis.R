print("DAU: PLY42: Core analysis")
print("CC BY-SA 4.0")
print("Author: Charlotte E.R. Edmunds")

## Set up ----------------------------------------------------------------------

rm(list=ls())

## Import packages
library(effsize)
library(ggplot2)
library(Rmisc)
library(ez)
library(lsmeans)
library(nlme)

## Define functions 
source('PLY42 Functions.R')

## Load and pre-process data ---------------------------------------------------
trialData <- read.csv("PLY42longData.csv", header=TRUE)
trialData <- trialData[trialData$Condition != "AllAll",]
trialData <- droplevels(trialData)

# Formatting of factor levels
trialData$Condition <- revalue(trialData$Condition, 
                               c("EasyAll"="Easy-to-all",
                                 "HardAll"="Hard-to-all"))
trialData$Difficulty <- relevel(trialData$Difficulty, "Medium")
trialData$Difficulty <- relevel(trialData$Difficulty, "Easy")
trialData$Category <- factor(trialData$Category)

trialData <- trialData[trialData$RT<5000,]

trialData <- trialData[!trialData$Condition=="AllAll",]
data <- aggregate(list(trialData$Correct, trialData$RT),
                  list(trialData$Participant, trialData$Condition,
                       trialData$Block),
                  mean)
colnames(data) <- c("Participant", "Condition", "Block", "Accuracy", "RT")
data$Block <- factor(data$Block)

## Get Figure 4 ----------------------------------------------------------------
summaryData <- summarySE(data, measurevar="Accuracy", 
                         groupvars=c("Condition", "Block"), 
                         na.rm=T)
summaryData["CI_DA"] <- NA
summaryData <- summaryData[with(summaryData, order(Block, Condition)), ]
for (i in 1:2){
    data_subset <- data[data$Block==i,]
    output <- bsci(data.frame=data_subset, group.var="Condition",
                   dv.var="Accuracy", 
                   difference=T, pooled.error=FALSE, conf.level=0.95)    
    summaryData$CI_DA[summaryData$Block==i] <- output[,3]-output[,2]
}

summaryData["Type"] <- "Accuracy"
levels(summaryData$Type) <- c("Accuracy", "Reaction time (ms)")

summaryData_rt <- summarySE(data, measurevar="RT", 
                            groupvars=c("Condition", "Block"), 
                            na.rm=T)
summaryData_rt["CI_DA"] <- NA
summaryData_rt <- summaryData_rt[with(summaryData_rt, order(Block,
                                                            Condition)), ]

for (i in 1:2){
    data_subset <- data[data$Block==i,]
    output <- bsci(data.frame=data_subset, group.var="Condition", dv.var="RT", 
                   difference=T, pooled.error=F, conf.level=0.95)    
    summaryData_rt$CI_DA[summaryData$Block==i] <- output[,3] - output[,2]
}

summaryData_rt <- rename(summaryData_rt, c("RT"="Accuracy"))

summaryData_rt["Type"] <- "Reaction time (ms)"
combined <- rbind(summaryData, summaryData_rt)
dummy <- data.frame("Condition"=
    c("Easy-to-all","Easy-to-all","Hard-to-all","Hard-to-all"),
    "Block"=c(1,1,1,1),
    "Accuracy"=c(0.5,1,0,1000),
    "Type"=c("Accuracy","Accuracy","Reaction time (ms)","Reaction time (ms)"))

plot_combined <- ggplot(
    combined, aes(y=Accuracy, x=as.factor(Block), group=Condition,
                  shape=Condition)) +
    geom_path(size = 0.8) + 
    geom_blank(data=dummy) +
    geom_errorbar(aes(
        ymax = Accuracy + CI_DA,
        ymin=Accuracy - CI_DA),
        width=0.2,
        linetype="solid",
        position=position_dodge(width=0.15)) +
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
# Output graph
print("Displaying Figure 4.")
print(plot_combined)

## Get Figure 5 ----------------------------------------------------------------
dataDiff <- aggregate(list(trialData$Correct, trialData$RT),
                      list(trialData$Participant, trialData$Condition,
                           trialData$Difficulty, trialData$Block), 
                      mean)
colnames(dataDiff) <- c("Participant", "Condition","Difficulty","ExpPhase",
                        "Accuracy", "RT")
levels(dataDiff$Difficulty) <- c("Easy", "Moderate", "Hard")
dataDiff$Condition <- factor(dataDiff$Condition)
dataDiff <- dataDiff[dataDiff$ExpPhase==2,]

summaryDiff <- summarySEwithin(dataDiff, measurevar="Accuracy",
                               betweenvars=c("Condition"),
                               withinvars=c("Difficulty"),
                               idvar="Participant", na.rm=T)
summaryDiff["CI_DA"] <- NA
summaryDiff <- summaryDiff[with(summaryDiff, order(Condition, Difficulty)), ]
for (i in 1:2){
    data_subset <- dataDiff[dataDiff$Condition==levels(dataDiff$Condition)[i],]
    output <- bsci(
        data.frame=data_subset, group.var="Difficulty", dv.var="Accuracy",
        difference=T, pooled.error=T, conf.level=0.95)
    summaryDiff$CI_DA[summaryDiff$Condition==levels(dataDiff$Condition)[i]] <-
        output[,3]-output[,2]
}

plot_summary <- ggplot(
    summaryDiff, 
    aes(x=Difficulty, y=Accuracy, group=Condition, linetype=Condition,
        shape=Condition)) +
    geom_line(size = 0.8) +
    geom_errorbar(aes(ymax = Accuracy + CI_DA, ymin=Accuracy - CI_DA), 
                  width=0.2, linetype="solid", 
                  position=position_dodge(width=0.09)) +
    geom_point(size=3, fill = "white", position=position_dodge(width=0.09)) +
    scale_shape_manual(values=c(19,21,13)) +
    scale_linetype_manual(values=c("solid", "solid", "solid")) +
    labs(x="Stimulus Type", y="Mean Proportion Accuracy") + 
    theme_bw(base_size = 18) + coord_cartesian(ylim=c(0.5,1)) +
    theme(legend.justification=c(1,0), 
          legend.position=c(1,0),
          legend.title=element_blank(),
          plot.title = element_text(family="sans", size=18, hjust=0),
          axis.text.x  = element_text(family="sans", size=9), 
          axis.title.x = element_text(size=10),
          axis.text.y  = element_text(family="sans", size=9), 
          axis.title.y = element_text(size=10),
          legend.text = element_text(size = 9),
          strip.text.x = element_text(size=10, colour="white"), 
          strip.background = element_rect(colour="black", fill="black"),        
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.border = element_rect(size = 1, colour = "black"),
          legend.key = element_blank(),
          legend.background = element_rect(fill="transparent"))

## Output graph
print("Displaying Figure 5.")
print(plot_summary)

## Null-hypothesis significance testing ----------------------------------------

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

## t-test and Cohen's d
TT_B2 <- t.test(Accuracy ~ Condition, test_data_B2, var.equal=T) # Sig.

print(TT_B2)
print(cohen.d(test_data_B2$Accuracy ~ test_data_B2$Condition))

print("Bayes Factor")

mean_diff <- TT_B2$estimate[1] - TT_B2$estimate[2]
sd_err <- mean_diff / TT_B2$statistic

print(paste("Sample mean difference:",round(mean_diff,3)))

print(paste("Standard error:", round(sd_err,3)))

print(Bf(sd=sd_err, obtained=mean_diff, uniform=0,
         meanoftheory=-0.139, sdtheory=0.07, tail=2))

print("Bayes Factor under 3/4ths reduction:")

print(Bf(sd=sd_err, obtained=mean_diff, uniform=0,
         meanoftheory=-0.139*1/4, sdtheory=0.07*1/4, tail=2))

## Reaction times --------------------------------------------------------------
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

## Additional between stimulus type analysis -----------------------------------
print("Mixed ANOVA results")
dataDiff$Participant <- as.factor(dataDiff$Participant)
diffANOVA <- ezANOVA(
    data = dataDiff[dataDiff$ExpPhase==2,],
    dv = Accuracy,
    wid = Participant, 
    within = Difficulty,
    type = 3,
    between = Condition
)
print(diffANOVA)

lme_difficulty <- lme(Accuracy ~ Difficulty*Condition, 
                      dataDiff[dataDiff$ExpPhase==2,], random = ~1|Participant)
print("Simple main effects analysis")
print(lsmeans(lme_difficulty, pairwise ~ Condition | Difficulty))
