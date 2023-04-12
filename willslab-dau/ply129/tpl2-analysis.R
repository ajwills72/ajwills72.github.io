## Title:   ply129 analysis (TPL2)
## Author:  Tina Seabrooke, Andy Wills

## Setup ----
library(plyr)    # provides 'ddply'
library(ez)      # provides 'ezANOVA'
library(ggplot2) # provides 'ggplot'
library(pastecs) # provides 'stat.desc'

## Load custom functions
source('TPL2Functions.R') 

## Power calculations
## The same calculations as for ply113 apply, please refer to that DAU.

## Read data file
data <- read.csv("TPL2_LongData.csv",
                 stringsAsFactors = F)

## Remove practice trials
prac <- c("PracticeStudy", "PracticeMeaning",
          "PracticeFirstWord", "PracticeRecall")

data <- subset(data, subset = !Running %in% prac)

## Remove scientific notation
options(scipen = 999)

## Participant details ----

print(paste("Total number of participants:",
            length(unique(data$Subject))))

## Biographic info as one line per participant
oneRow <- data[!duplicated(data$Subject), 1:5]

## Number of males and females
print(paste("Males:", sum(oneRow$Gender == "male")))
print(paste("Females:", sum(oneRow$Gender == "female")))

## Age info
print("Summary of ages:")
age <- data.frame(stat.desc(oneRow$Age))
age$variable <- rownames(age)
keep <- c("min", "max", "mean", "SE.mean")
age  <- data.frame(age[keep, ])
print(age)

## Recall test ----

## Identify  correct answers during encoding phase
corrAns <- data[(data$Running == "Meaning" | 
                   data$Running == "First Word")
                & data$Acc == 1,]

print("List of correct answers at encoding:")
print(corrAns)

## Subset data to recall test phase
recall <- data[data$Running=="Recall",]

## remove retrieval trials whose cues were correctly generated at
## encoding.
errors <- recall[! paste(recall$Subject, recall$Cue) %in% 
                   c(paste(corrAns$Subject, corrAns$Cue),
                     paste(corrAns$Cue, corrAns$Subject)),]

## Aggregate test scores to a by-subject level
## numcomissions - Number of commissions (trials where a response was
## made) in the recall test.
## percomissions - percentage of commissions

#### UNCOMMENT THE FOLLOWING LINE TO GET THE ANALYSES REPORTED IN
#### SUPP. MAT. 1
## errors <- recall

summary <- ddply(
  errors, 
  c("Subject", "Condition"),
  summarise,
  trialnum   = length(Running),
  countAcc   = sum(Acc),
  percentAcc = 100*(countAcc/trialnum),
  rt         = mean(RT),
  numcommissions = sum(Resp!=""),
  percommissions = 100*(numcommissions/trialnum)
)

## percentage of commissions in recall group (foils excluded)
print(paste("percentage of commissions in recall = ",
             (mean(summary$percommissions)))) 

## Convert columns to factors for ezANOVA
cols <- c("Subject", "Condition")
summary[cols] <- lapply(summary[cols], factor)

## One-way ANOVA on Condition
print("Recall: one-way ANOVA on Condition")
recall.aov = ezANOVA(data     = summary,
                     dv       = percentAcc,
                     wid      = Subject,
                     within   = Condition,
                     detailed = T,
                     type     = 3)
print(recall.aov)

## Mean percent accuracy  (collapsed
## across encoding condition
acc <- ddply(errors, "Subject", summarise,
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

print("Mean percent accuracy (collapsed across conditions)")
print(acc)

## Liberal scoring approach ----
print("Analysis of recall using liberal scoring citeria.")
errors$TargetShort <- substr(errors$Target, 1, 5)
errors$RespShort   <- substr(errors$Resp, 1, 5)

# Assign new correct answers as 1, incorrect answers as 0
errors$LiberalAcc <- ifelse(errors$TargetShort
                            == errors$RespShort, 1, 0)

spellings <- ddply(errors, c("Subject", "Condition"), summarise,
                   trialnum   = length(Running),
                   countAcc   = sum(LiberalAcc),
                   percentAcc = 100*(countAcc/trialnum),
                   rt         = mean(RT))

## Convert columns to factors for ezANOVA
cols <- c("Subject", "Condition")
spellings[cols] <- lapply(spellings[cols], factor)

## One-way ANOVA on Condition
print("Liberal scoring: one-way ANOVA on Condition")
spellings.ez = ezANOVA(data     = spellings,
                       dv       = percentAcc,
                       wid      = Subject,
                       within   = Condition,
                       detailed = T,
                       type     = 3)
print(spellings.ez)

## Bayes factor ----

## Strict coding
print("Strict coding")
print("Bayes Factor, meaning vs. study (Prior: 11.67% difference)")
res <- t.test(percentAcc ~ Condition,
              paired = T,
              data = subset(summary, Condition !=
                                     "First Word")
              )
ob <- res$estimate
se <- ob/res$statistic
mot <- 11.67
bf <- Bf(sd = se, obtained = ob, uniform = FALSE,
         meanoftheory = mot, sdtheory = mot/2, tail = 2)
print(paste("Obs. mean diff.:",ob))
print(paste("SEM:",se))
print(paste("BF:",bf$BayesFactor))

print("BF (Prior: 1.98% difference)")
mot <- 1.98
bf <- Bf(sd = se, obtained = ob, uniform = FALSE,
         meanoftheory = mot, sdtheory = mot/2, tail = 2)
print(paste("BF:",bf$BayesFactor))

## Lenient coding
print("Liberal coding")
print("Bayes Factor, meaning vs. study (Prior: 11.67% difference)")
res <- t.test(percentAcc ~ Condition,
              paired = T,
              data = subset(spellings, Condition !=
                                     "First Word")
              )
ob <- res$estimate
se <- ob/res$statistic
mot <-11.67
bf <- Bf(sd = se, obtained = ob, uniform = FALSE,
         meanoftheory = mot, sdtheory = mot/2, tail = 2)
print(paste("Obs. mean diff.:",ob))
print(paste("SEM:",se))
print(paste("BF:",bf$BayesFactor))

print("BF (Prior: 1.75% difference)")
mot <- 1.75
bf <- Bf(sd = se, obtained = ob, uniform = FALSE,
         meanoftheory = mot, sdtheory = mot/2, tail = 2)
print(paste("BF:",bf$BayesFactor))

## Figure 2 ----
  
## Convert long to wide
recall.sel <- summary[,c('Subject', 'Condition', 'percentAcc')]
recall.w <- reshape(recall.sel, direction = "wide",
                    timevar = "Condition", idvar = "Subject")
recall.w <- recall.w[,c(2:4)]
colnames(recall.w) <- c("First Word", "Meaning", "Study")
  
## Compute difference-adjusted w/subj confidence intervals
recallAcc <- cm.ci(recall.w)
rm(recall.sel, recall.w)

# Define recall graph
recall.graph <-
  ggplot(recallAcc, aes(x = Condition, y = av))+
  standard_geombar+
  geom_errorbar(
    aes(ymin = lower, ymax = upper),
    width = .3,
    size = 1,
    position = position_dodge(.9)
  )+
  scale_x_discrete("Encoding condition")+
  scale_y_continuous(
    "Percent correct",
    expand = c(0,0),
    limits = c(0, 100),
    breaks = seq(0, 100, by = 10))+ 
  theme_APA

## Save graph
ggsave(plot = recall.graph, "fig2.png", width = 15, height = 15, units
       = "cm")
ggsave(plot = recall.graph, "fig2.pdf", width = 15, height = 15, units
       = "cm")

## Supplementary materials 2 (RTs) ----
print('Reaction times')

## One-way ANOVA on Condition
print("Reaction times: one-way ANOVA on Condition")
recall.RTs <- ezANOVA(data     = summary,
                      wid      = Subject,
                      dv       = rt,
                      within   = Condition,
                      detailed = TRUE,
                      type     = 3)
print(recall.RTs)



