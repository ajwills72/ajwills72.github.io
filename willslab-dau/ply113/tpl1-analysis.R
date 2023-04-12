## Title:   PLY113 analysis
## Author:  Tina Seabrooke, Andy Wills
## Licence: CC-BY-SA 4.0

## Setup
library(plyr)    # provides 'ddply'
library(Rmisc)   # provides 'summarySE'
library(ez)      # provides 'ezANOVA'
library(ggplot2) # provides 'ggplot'
library(cowplot) # provides 'plot_grid'
library(pastecs) # provides 'stat.desc'
library(pwr)     # provides 'pwr.t.test'
library(psych)   # provides 'describeBy'

## Load custom functions
source('tpl1functions.R') 

## Power calculations

## This takes a weighted average of the d in P+S2014, Exp. 1, 2A, 2B,
## and 3. Exp. 2B is not included because it's Euskara rather than
## English, with a much lower d that the other experiments.
est.d <- (.47*24+.40*30+.56*40) / (24+30+40)

print(paste("Effect size estimated from Potts & Shanks (2014):",
            est.d))

print("Estimated power at our chosen sample size:")
print(pwr.t.test(n = 48, d = est.d, sig.level = .05, type =
                                                         'paired'))

## Read data file
data <- read.csv("PLY113longData.csv", stringsAsFactors = F)

## Remove practice trials
prac <- c("PracticeStudy", "PracticeMeaning", "PracticeFirstWord",
          "RecallPractice", "RecognitionPractice")

data <- subset(data, subset = !Running %in% prac)

print("Participant details")

print(paste("Total number of participants:",
            length(unique(data$Subject))))

## Biographic info as one line per participant
oneRow <- data[!duplicated(data$Subject), 1:4]

## Number of males and females
print(paste("Males:", sum(oneRow$Sex == "male")))
print(paste("Females:", sum(oneRow$Sex == "female")))

## Number of participants in each group
print(paste("N (recognition):", sum(oneRow$Group == "Recognition")))
print(paste("N (recall):", sum(oneRow$Group == "Recall")))

## Age info
print("Summary of ages:")
age <- data.frame(stat.desc(oneRow$Age))
age$variable <- rownames(age)
keep <- c("min", "max", "mean", "SE.mean")
age  <- data.frame(age[keep, ])
print(age)

## Identify  correct answers during encoding phase
corrAns <- data[(data$Running == "Meaning" | data$Running ==
                 "First Word") & data$Acc==1,]

print("List of correct answers at encoding:")
print(corrAns)

## Subset data to retrieval phase
test <- data[data$Running == "Recall" | data$Running ==
             "Recognition",]

## remove retrieval trials whose cues were correctly generated at
## encoding.
errors <- test[! paste(test$Subject, test$Cue) %in% 
                 c(paste(corrAns$Subject, corrAns$Cue),
                   paste(corrAns$Cue, corrAns$Subject)),]

## Aggregate test scores to a by-subject level
## numcomissions - Number of commissions (trials where a response was
## made) in the recall test.
## percomissions - percentage of commissions
## Replace "errors" with "test" to get the results with the correct
## generations included (found in Supplementary Materials 1). 

#### IN ORDER TO PRODUCE THE SUPP. MAT. 1 (ALL TRIALS) ANALYSES
#### uncomment the following line:
## errors <- test

## N.B.: Do NOT uncomment the above line to reproduce the Supp. Mat. 2
## (Reaction time) analyses 

scores <- ddply(
    errors,
    c("Subject", "Group", "Condition", "WordType"),
    summarise,
    trialnum    = length(Running),
    countAcc    = sum(Acc),
    percentAcc  = 100*(countAcc/trialnum),
    rt          = mean(RT),
    numcommissions = sum(Resp!=""), 
    percommissions = 100*(numcommissions/trialnum)
)

## Foil/lure trials
foils <- scores[scores$Condition == "Foil",]

print("Accuracy on foil trials")
print(summarySE(foils, measurevar = "percentAcc",
                groupvars = c("Group", "WordType")))
    
## Split the two groups & remove the foil trials
recall <- scores[scores$Group == "Recall" & scores$Condition !=
                 "Foil",]

recognition <- scores[scores$Group == "Recognition" &
                      scores$Condition != "Foil",]
    
## Convert columns to factors for ezANOVA
cols <- c("Subject", "Condition", "WordType")
recall[cols]      <- lapply(recall[cols], factor)
recognition[cols] <- lapply(recognition[cols], factor)
    
## RECOGNITION ANALYSIS
## Encoding condition x Cue/Target ANOVA
print("ANOVA: Recognition percent correct")
recog_ez = ezANOVA(data     = recognition,
                   wid      = Subject,
                   dv       = percentAcc,
                   within   = .(Condition, WordType),
                   detailed = TRUE,
                   type     = 3)
print(recog_ez)

## To report group means, uncomment the following lines:
## gm <- describeBy(recognition$percentAcc,
##                 list(recognition$Condition, recognition$WordType),
##                 mat = TRUE)
## print(gm[,c('group1', 'group2', 'mean', 'se')])

## Create a list of pairwise comparisons
pairwise <- list(
    Cue_Meaning_Study = # Meaning v. study
        subset(recognition, Condition != "First Word" & WordType
               == "Cue"),
    Cue_FW_Study = # First word v. study
        subset(recognition, Condition != "Meaning" & WordType ==
                            "Cue"),
    Cue_FW_Meaning = # First word v. meaning
        subset(recognition, Condition != "Study" & WordType ==
                            "Cue"),
    Targ_Meaning_Study = # Meaning v. study
        subset(recognition, Condition != "First Word" & WordType
               == "Target"),
    Targ_FW_Study = # First word v. study
        subset(recognition, Condition != "Meaning" & WordType ==
                            "Target"),
    Targ_FW_Meaning = # First word v. meaning
        subset(recognition, Condition != "Study" & WordType ==
                            "Target")
)
    
## Function to apply to each item on the list
tests <- function (p){
    ## t-test
    tt <- t.test(percentAcc ~ Condition, paired = T, data = p)
    ## Cohen's d_z
    dz <- p[,c("Subject", "Condition", "percentAcc")]     
    colnames(dz) <- c('id', 'cond', 'dv')
    cd <- cohen.dz(dz)
    ret <- list(tt, cd)
}
    
## Apply function to each item in list
print("Pairwise comparisons")
print(lapply(pairwise, tests))

## SECONDARY ANALYSES
print("SECONDARY ANALYSES")
    
## FW vs Study
fw_s <- subset(recognition, Condition != "Meaning") 
    
## Meaning vs Study
m_s  <- subset(recognition, Condition != "First Word") 
    
## Refactor Condition column of dataframes to eliminate error
## messages
fw_s$Condition <- factor(fw_s$Condition) 
m_s$Condition  <- factor(m_s$Condition)  
    
## 2 x 2 ANOVA function
secAnalysis <- function(p){
    print(deparse(substitute(p))) # print data.frame name
    subset.ez <- ezANOVA(dat      = p,
                         wid      = Subject,
                         dv       = percentAcc,
                         within   = .(Condition, WordType),
                         detailed = TRUE,
                         type     = 3)
    print(subset.ez)
}

print("ANOVA: First word vs. study")
secAnalysis(fw_s)
print("ANOVA: Meaning vs. study")
secAnalysis(m_s)
    
## RECALL ANALYSIS

## percentage of commissions in recall group (foils excluded)
print(paste0("percentage of commissions in recall = ",
(mean(recall$percommissions)))) 
    
## One-way ANOVA on Condition
print("Recall: one-way ANOVA on Condition")
recall_ez = ezANOVA(data     = recall,
                    wid      = Subject,
                    dv       = percentAcc,
                    within   = Condition,
                    detailed = TRUE,
                    type     = 3)
print(recall_ez)

recall_ez = ezStats(data     = recall,
                    wid      = Subject,
                    dv       = percentAcc,
                    within   = Condition,
                    type     = 3)
print("Descriptives")
print(recall_ez)

## Mean percent accuracy
print("Mean percent accuracy")
print("(collapsed across encoding condition)")

acc <- subset(errors, Group=="Recall" & 
                Condition != "Foil")

acc <- ddply(acc, "Subject", summarise,
             trialnum = length(Running),
             countAcc = sum(Acc==1), 
             percentAcc = 100*(countAcc/trialnum)
)

acc$dummy <- 1
acc <- ddply(acc, "dummy", summarise,
             n = length(Subject),
             m = mean(percentAcc),
             sd = sd(percentAcc),
             sem = sd/sqrt(n))

print(acc)

## Bayes Factor calculations for meaning v. study
## (uses results of t-test)
print("Bayes Factor, meaning vs. study (Prior: 5% difference)")
res <- t.test(percentAcc ~ Condition, paired = T, data = recall,
              subset = Condition != "First Word")
ob <- res$estimate
se <- ob/res$statistic
mot <- 5
bf <- Bf(sd = se, obtained = ob, uniform = FALSE,
         meanoftheory = mot, sdtheory = mot/2, tail = 2)
print(paste("Obs. mean diff.:",ob))
print(paste("SEM:",se))
print(paste("BF:",bf$BayesFactor))

print("BF (Prior: 2.6% difference)")
mot <- 2.6
bf <- Bf(sd = se, obtained = ob, uniform = FALSE,
         meanoftheory = mot, sdtheory = mot/2, tail = 2)
print(paste("BF:",bf$BayesFactor))

## LIBERAL SCORING CRITERIA IN RECALL TEST
print("Analysis of recall using liberal scoring citeria.")
## Get the recall data and remove the foil trials
spellings <- errors[errors$Running == "Recall" & errors$Condition !=
                    "Foil", ]

## Take the first 5 letters of each Target and Response
spellings$TargetShort <- substr(spellings$Target, 1, 5)
spellings$RespShort   <- substr(spellings$Resp, 1, 5)

## Assign new correct answers as 1, incorrect answers as 0
spellings$NewCorrect  <- ifelse(spellings$TargetShort ==
                                spellings$RespShort, 1, 0)

## Summary scores per subject
spellings <- ddply(spellings, c("Subject", "Condition"), summarise,
                   trialnum   = length(NewCorrect),
                   countAcc   = sum(NewCorrect),
                   percentAcc = 100*(countAcc/trialnum))

# Convert multiple columns to factors for the ANOVA
cols <- c("Subject", "Condition")
spellings[cols] <- lapply(spellings[cols], factor)

spell.aov = ezANOVA(data     = spellings, 
                    dv       = percentAcc,
                    wid      = Subject,
                    within   = Condition,
                    detailed = T,
                    type     = 3)
print("One-way ANOVA by Condition")
print(spell.aov)


## Bayes Factor calculations for meaning v. study
## (uses results of t-test)
print("Bayes Factor, meaning vs. study (Prior: 5% difference)")
res <- t.test(percentAcc ~ Condition, paired = T, data = spellings,
              subset = Condition != "First Word")
ob <- res$estimate
se <- ob/res$statistic
mot <- 5
bf <- Bf(sd = se, obtained = ob, uniform = FALSE,
         meanoftheory = mot, sdtheory = mot/2, tail = 2)
print(paste("Obs. mean diff.:",ob))
print(paste("SEM:",se))
print(paste("BF:",bf$BayesFactor))

print("BF (Prior: 2% difference)")
mot <- 2
bf <- Bf(sd = se, obtained = ob, uniform = FALSE,
         meanoftheory = mot, sdtheory = mot/2, tail = 2)
print(paste("BF:",bf$BayesFactor))

## Figure 1 ----

## RECALL GRAPH

## Convert long to wide
recall.sel <- recall[,c('Subject', 'Condition', 'percentAcc')]
recall.w <- reshape(recall.sel, direction = "wide",
                    timevar = "Condition", idvar = "Subject")
recall.w <- recall.w[,c(2:4)]
colnames(recall.w) <- c("First Word", "Meaning", "Study")

## Compute difference-adjusted w/subj confidence intervals
recallAcc <- cm.ci(recall.w)
rm(recall.sel, recall.w)

## Define recall graph
recall.graph <-
    ggplot(recallAcc, aes(x = Condition, y = av)) +
    standard_geombar +
    geom_errorbar(
        aes(ymin = lower, ymax = upper),
        width = .3,
        size = 1,
        position = position_dodge(.9)
    ) +
    scale_x_discrete("Encoding condition") +
    scale_y_continuous(
        "Percent correct",
        expand=c(0,0),
        limits = c(0, 100),
        breaks=seq(0, 100, by=10)
    ) +
    theme_APA

## RECOGNITION GRAPH

## Cues
## Convert long to wide
cue <- recognition[recognition$WordType == "Cue", c('Subject',
                                                    'Condition',
                                                    'percentAcc')]
cue <- reshape(cue, direction = "wide", timevar = "Condition",
               idvar = "Subject")
cue <- cue[,2:4]
colnames(cue) <- c("First Word", "Meaning", "Study")
## Calc CI
cueAcc <- cm.ci(cue)

## Targets
## Convert long to wide
tar <- recognition[recognition$WordType == "Target", c('Subject',
                                                    'Condition',
                                                    'percentAcc')]
tar <- reshape(tar, direction = "wide", timevar = "Condition",
               idvar = "Subject")
tar <- tar[,2:4]
colnames(tar) <- c("First Word", "Meaning", "Study")
## Calc CI
tarAcc <- cm.ci(tar)

## Combine
recogAcc <-
    cbind(rep(c("Cue", "Target"), each = 3), rbind(cueAcc, tarAcc))

colnames(recogAcc) <- c("WordType", "Condition", "lower", "av",
                        "upper")

## Define recognition graph
recog.graph <-
    ggplot(recogAcc, aes(x = WordType, y = av, fill = Condition)) +
    standard_geombar +
    geom_errorbar(
        aes(ymin = lower, ymax = upper),
        width = .3,
        size = 1,
        position = position_dodge(.9)) +
    scale_x_discrete("Item") +
    scale_y_continuous(
        "Percent correct",
        expand=c(0,0),
        limits = c(0, 100),
        breaks=seq(0, 100, by=10)) +
    theme_APA

## Grayscale colour scheme
recog.graph <- recog.graph + scale_fill_grey(start = .3, end = .7)

## Combine graphs and save to PDF
p <- plot_grid(
    recog.graph,
    recall.graph,
    labels = c("a", "b"),
    label_size = 18,
    ncol = 2)
print(p)

ggsave(filename = "fig1.pdf", plot = p, width = 30, height = 15, units
       = "cm")
ggsave(filename = "fig1.jpg", plot = p, width = 30, height = 15, units
       = "cm")

## Supplementary Materials
print("Supplementary materials")
print("Reaction time analysis")
print("Recognition ANOVA")

rt.ez <- ezANOVA(data     = recognition,
                 wid      = Subject,
                 dv       = rt,
                 within   = .(Condition, WordType),
                 detailed = TRUE,
                 type     = 3)
print(rt.ez)

rt.ez <- ezStats(data     = recognition,
                 wid      = Subject,
                 dv       = rt,
                 within   = .(Condition, WordType),
                 type     = 3)
SEM <- rt.ez$SD/sqrt(rt.ez$N)
rt.ez <- cbind(rt.ez,SEM)
print(rt.ez)

print("Descriptives for item type:")
print(
    summarySE(data = recognition, measurevar='rt',
              groupvars = 'WordType'))

print("Descriptives for condition:")
print(
    summarySE(data = recognition, measurevar='rt',
              groupvars = 'Condition'))

print("Pairwise comparisons")
RTs <- list(
  FW_M = subset(recognition, Condition != 'Study'),
  FW_S = subset(recognition, Condition != 'Meaning'),
  M_S  = subset(recognition, Condition != 'First Word'),
  Cue_FW_S = subset(recognition, Condition != 'Meaning' & WordType == 'Cue')
)

tests <- function (p){
    ## t-test
    tt <- t.test(rt ~ Condition, paired = T, data = p)
    ## Cohen's d_z
    dz <- p[,c("Subject", "Condition", "rt")]     
    colnames(dz) <- c('id', 'cond', 'dv')
    cd <- cohen.dz(dz)
    ret <- list(tt, cd)
}

print(lapply(RTs, tests))

print("Recall reaction times ANOVA")
recall.RTs <- ezANOVA(data     = recall,
                      wid      = Subject,
                      dv       = rt,
                      within   = Condition,
                      detailed = TRUE,
                      type     = 3)
print(recall.RTs)

print("Descriptives")
print(
    summarySE(data = recall, measurevar='rt', groupvars =
                                                  'Condition'))

print("Pairwise tests")
recall.lists <- list(
  FW_M = subset(recall, Condition != 'Study'),
  FW_S = subset(recall, Condition != 'Meaning'),
  M_S  = subset(recall, Condition != 'First Word')
)

print(lapply(recall.lists, tests))

