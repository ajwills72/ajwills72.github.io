print("DAU: PLY75: Core analysis")
print("CC BY-SA 4.0")
print("Author: Charlotte E.R. Edmunds")

## Set up
## ------
rm(list=ls())

## Import packages
library(effsize)
library(ggplot2)
library(Rmisc)
library(plyr)
library(ez)

## Define functions 
source('PLY75 Functions.R')

## Load and pre-process data
## -------------------------
trialData <- read.csv("PLY75longData.csv", header=TRUE)

## Formatting of data
trialData$Condition <- revalue(trialData$Condition, 
                               c("EasyHard"="Easy-to-hard",
                                 "HardEasy"="Hard-to-easy"))
trialData$Difficulty <- relevel(trialData$Difficulty, "Medium")
trialData$Difficulty <- relevel(trialData$Difficulty, "Easy")
trialData$Category <- factor(trialData$Category)
trialData$Block <- factor(trialData$Block)

## Produce Figure 6
## ----------------

## Get data summary
data <- aggregate(list(trialData$Correct, trialData$RT),
                  list(trialData$Participant, trialData$Condition,
                       trialData$Block),
                  mean)
colnames(data) <- c("Participant", "Condition", "Block", "Accuracy",
                    "RT")

nonLearners <- data[data$Accuracy<0.3,]
nonLearners <- nonLearners[nonLearners$Block==2,] 

data <-data[!data$Participant %in% nonLearners$Participant,]

summaryData <- summarySEwithin(data, measurevar="Accuracy",
                               withinvars="Block",
                               betweenvars="Condition",
                               idvar="Participant", na.rm=T,
                               conf.interval=.95)

## Create plot
summaryData["CI_DA"] <- NA
summaryData <- summaryData[with(summaryData, order(Block, Condition)), ]
for (i in 1:4){
    data_subset <- data[data$Block==i,]
    output <- bsci(data.frame=data_subset, group.var="Condition",
                   dv.var="Accuracy", difference=T,
                   pooled.error=FALSE, conf.level=0.95)
    summaryData$CI_DA[summaryData$Block==i] <- output[,3]-output[,2]
}

summaryData["Type"] <- "Accuracy"
levels(summaryData$Type) <- c("Accuracy", "Reaction time (ms)")

summaryData_rt <- summarySEwithin(data, measurevar="RT",
                                  betweenvars=c("Condition"),
                                  withinvars="Block",
                                  idvar="Participant", na.rm=T)
summaryData_rt["CI_DA"] <- NA
summaryData_rt <-
    summaryData_rt[with(summaryData_rt, order(Block, Condition)), ]
for (i in 1:4){
    data_subset <- data[data$Block==i,]
    output <- bsci(data.frame=data_subset, group.var="Condition",
                   dv.var="RT", difference=T, pooled.error=F,
                   conf.level=0.95)
    summaryData_rt$CI_DA[summaryData$Block==i] <- output[,3] -
        output[,2]
}

colnames(summaryData_rt) <- c("Condition","Block","N","Accuracy","sd",
                              "se","ci","CI_DA")
summaryData_rt["Type"] <- "Reaction time (ms)"

combined <- rbind(summaryData, summaryData_rt)

dummy <- data.frame(
    "Condition"=
        c("Easy-to-hard","Easy-to-hard","Hard-to-easy","Hard-to-easy"),
    "Block"=c(1,1,1,1),
    "Accuracy"=c(0.5,1,500,1750),
    "Type"=
        c("Accuracy","Accuracy","Reaction time (ms)",
          "Reaction time (ms)")
)

plot_combined <- ggplot(
    combined,
    aes(y=Accuracy, x=as.factor(Block), group=Condition,
        shape=Condition)) + 
    geom_path(size = 0.8) + 
    geom_blank(data=dummy) +
    geom_errorbar(
        aes(ymax = Accuracy + CI_DA,
            ymin=Accuracy - CI_DA),
        width=0.2,
        linetype="solid",
        position=position_dodge(width=0.15)) +
    geom_point(size=3, fill = "white",
               position=position_dodge(width=0.15)) +
    scale_shape_manual(values=c(19,21)) +
    facet_wrap(~ Type, scales = "free_y") +
    labs(x="Block",y="") + theme_bw(base_size = 18) +
    theme(legend.justification=c(1.1,1.1), legend.position=c(1,1.05),
          legend.title=element_blank(),
          plot.title = element_text(family="sans", size=18),
          axis.text.x  = element_text(family="sans", size=9),
          axis.title.x = element_text(size=10),
          axis.text.y  = element_text(family="sans", size=9),
          axis.title.y = element_text(size=0),
          legend.text = element_text(size = 9),
          strip.text.x = element_text(size=10, colour="white"),
          strip.background = element_rect(colour="black",
                                          fill="black"),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.border = element_rect(size = 1, colour = "black"),
          legend.key = element_blank(),
          legend.background = element_rect(fill="transparent"))

## Output graph
print("Displaying Figure 6.")
print(plot_combined)

dataDiff <- aggregate(list(trialData$Correct, trialData$RT),
                      list(trialData$Participant, trialData$Condition,
                           trialData$Difficulty, trialData$Block), 
                      mean)
colnames(dataDiff) <- c("Participant", "Condition","Difficulty",
                        "Block", "Accuracy", "RT")
dataDiff <-
    dataDiff[!dataDiff$Participant %in% nonLearners$Participant,]
levels(dataDiff$Difficulty) <- c("Easy", "Moderate", "Hard")
dataDiff["ExpPhase"] <- ifelse(as.numeric(dataDiff$Block)<=3,1,2)
dataDiff$ExpPhase <-
    factor(dataDiff$ExpPhase, labels=c("Training","Test"))

summaryDiff <- summarySEwithin(dataDiff, measurevar="Accuracy",
                               betweenvars=c("Condition"),
                               withinvars=c("Difficulty","ExpPhase"),
                               idvar="Participant", na.rm=T)
summaryDiff["CI_DA"] <- NA
summaryDiff <- summaryDiff[
    with(summaryDiff, order(ExpPhase, Condition, Difficulty)), ]

for (j in 1:2){
    for (i in 1:2){
        data_subset <- dataDiff[
            dataDiff$Condition==levels(dataDiff$Condition)[i] &
            dataDiff$ExpPhase==levels(dataDiff$ExpPhase)[j] ,]
        
        output <- bsci(
            data.frame=data_subset,
            group.var="Difficulty",
            dv.var="Accuracy", 
            difference=T,
            pooled.error=T,
            conf.level=0.95)
        
        summaryDiff$CI_DA[
            summaryDiff$Condition==levels(dataDiff$Condition)[i] &
            summaryDiff$ExpPhase==levels(dataDiff$ExpPhase)[j]] <-
            output[,3]-output[,2]
        
    }
}
plot_summary <- ggplot(
    summaryDiff[summaryDiff$ExpPhase=="Test",],
    aes(
        x=Difficulty,
        y=Accuracy,
        group=Condition,
        linetype=Condition,
        shape=Condition)) +
    geom_line(size = 0.8) +
    geom_errorbar(
        aes(ymax = Accuracy + CI_DA,
            ymin=Accuracy - CI_DA),
        width=0.2, linetype="solid",
        position=position_dodge(width=0.15)) +
    geom_point(
        size=3,
        fill = "white",
        position=position_dodge(width=0.15)) +
    scale_shape_manual(
        values=c(19,21,13)) +
    scale_linetype_manual(
        values=c("solid", "solid", "solid")) +
    labs(
        x="Stimulus Type",
        y="Mean Proportion Accuracy") + 
    theme_bw(base_size = 18) +
    coord_cartesian(ylim=c(0.5,1)) +
    theme(legend.justification=c(1,0), 
          legend.position=c(1,0),
          legend.title=element_blank(),
          plot.title = element_text(
              family="sans", size=18, hjust=0),
          axis.text.x  = element_text(family="sans", size=9), 
          axis.title.x = element_text(size=10),
          axis.text.y  = element_text(family="sans", size=9), 
          axis.title.y = element_text(size=10),
          legend.text = element_text(size = 9),
          strip.text.x = element_text(size=10, colour="white"), 
          strip.background = element_rect(
              colour="black", fill="black"),        
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.border = element_rect(size = 1, colour = "black"),
          legend.key = element_blank(),
          legend.background = element_rect(fill="transparent")) 

print("Displaying Figure 7.")
print(plot_summary)

## Null-hypothesis significance testing
## ------------------------------------

test_data_B1 <- data[data$Block==1,]
test_data_B2 <- data[data$Block==2,]
test_data_B3 <- data[data$Block==3,]
test_data_B4 <- data[data$Block==4,]

## Block 1
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
TT_B2 <- t.test(Accuracy ~ Condition, test_data_B2, 
                var.equal=T) # N.s.

print("Block 2: Accuracy")
print(TT_B2)
print(cohen.d(test_data_B2$Accuracy ~ test_data_B2$Condition))

print("Bayes Factor")

mean_diff <- TT_B2$estimate[1] - TT_B2$estimate[2]
sd_err <- mean_diff / TT_B2$statistic

print(paste("Sample mean difference:",round(mean_diff,3)))

print(paste("Standard error:", round(sd_err,3)))

print(Bf(sd=sd_err, obtained=mean_diff, uniform=0,
         meanoftheory=-0.139, sdtheory=0.07, tail=2))

print("Bayes Factor under 1/2 reduction:")

print(Bf(sd=sd_err, obtained=mean_diff, uniform=0,
         meanoftheory=-0.139*1/2, sdtheory=0.07*1/2, tail=2))

## Reaction times
## --------------

## Block 1: RT
print("Block 1: RT")

TT_B1_RT <- t.test(RT ~ Condition, test_data_B1, 
                   var.equal=T) # Sig.

print(TT_B1_RT)
print(cohen.d(test_data_B1$RT ~ test_data_B1$Condition))

# Block 2
print("Block 2: RT")
TT_B2_RT <- t.test(RT ~ Condition, test_data_B2, 
                   var.equal=T)
print(TT_B2_RT)
print(cohen.d(test_data_B2$RT ~ test_data_B2$Condition))

## Block 4
## Accuracy
print("Block 4: Accuaracy")

TT_B4 <- t.test(Accuracy ~ Condition, test_data_B4, 
                var.equal=T) # N.s.
print(TT_B4)
print(cohen.d(test_data_B4$Accuracy ~ test_data_B4$Condition))

print("Bayes Factor")

mean_diff <- TT_B4$estimate[1] - TT_B4$estimate[2]
sd_err <- mean_diff / TT_B4$statistic

print(paste("Sample mean difference:",round(mean_diff,3)))

print(paste("Standard error:", round(sd_err,3)))

print(Bf(sd=sd_err, obtained=mean_diff, uniform=0,
         meanoftheory=-0.15, sdtheory=0.075, tail=2))

## Additional between stimulus type analysis
## -----------------------------------------
print("Mixed ANOVA results")

aov <- ezANOVA(dataDiff[dataDiff$ExpPhase=="Test",], dv=Accuracy,
               wid=Participant, between=Condition, within=Difficulty, 
               type=3)
print(aov)
