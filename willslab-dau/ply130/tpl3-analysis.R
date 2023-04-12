## Title:   PLY130 analysis (TPL3)
## Author:  Tina Seabrooke, Andy Wills

## Setup ----
library(plyr)    # provides 'ddply'
library(Rmisc)   # provides 'summarySE'
library(ez)      # provides 'ezANOVA'
library(ggplot2) # provides 'ggplot'
library(cowplot) # provides 'plot_grid'
library(pastecs) # provides 'stat.desc'
library(dplyr)   # provides '%>%'
library(pwr)     # provides 'pwr.t.test'

## Load custom functions
source('TPL3Functions.R')

## Read data file
data <- read.csv("TPL3_LongData.csv",
                 stringsAsFactors = F)

## Remove practice trials
prac <- c("PracticeStudy","PracticeMeaning",
          "AssociativePrac", "ItemPrac")
data <- subset(data, subset = !Running %in% prac)

## Participant details ----
print("participant details")
print(paste("Total number of participants:",
            length(unique(data$Subject))))

## Biographic info as one line per participant
oneRow <- data[!duplicated(data$Subject), 1:7]

## Number of males, females, participants in
## each group
demog <- list (
  paste("Males:", sum(oneRow$Sex == "male")),
  paste("Females:", sum(oneRow$Sex == "female")),
  paste("Associative recognition:",
        sum(oneRow$Test == "Associative Recognition")),
  paste("Item recognition:",
        sum(oneRow$Test == "Item Recognition"))
)
print(demog)

## Age info
print("Summary of ages:")
age <- data.frame(stat.desc(oneRow$Age))
age$variable <- rownames(age)
keep <- c("min", "max", "mean", "SE.mean")
age  <- data.frame(age[keep, ])
print(age)

## Power analysis ----
## Target recognition group (using our Exp. 1 effect size)
pwr.t.test(n = 28, d = .51, sig.level = .05, type = 'paired',
           alternative = "greater")

## Correct generations in encoding ----
## Identify  correct answers during encoding phase
corrAns <- data[data$Running == "Meaning" & data$Acc == 1,]

## Subset test phases and remove foils
test <- data[(data$Running == "ItemRecognition" |
                data$Running == "AssociativeRecognition") &
               data$Condition != "Foil",]

## Convert Congruency column to a factor
test$Congruency <- factor(test$Congruency)

## Rename 'Matched' and 'Unmatched' to 'Paired' and 'Repaired'
levels(test$Congruency)[match(
  "Matched",levels(test$Congruency))] <- "Paired"

levels(test$Congruency)[match(
  "Unmatched",levels(test$Congruency))] <- "Repaired"

## Get correctly generated items from encoding
errors <- test[ paste(test$Subject, test$Target) %in%
                  c(paste(corrAns$Subject, corrAns$Target),
                    paste(corrAns$Target, corrAns$Subject)),]

## Remove repaired trials in Associative Recog test, where
## the cue was part of a correctly guessed trial in encoding
## First subset data to just the repaired trials
repaired <- subset(test, Congruency=="Repaired")



## Get test trials involving the cue that was originally guessed
repaired <- repaired[paste(repaired$Subject, repaired$Cue) %in%
                       c(paste(corrAns$Subject, corrAns$Cue),
                         paste(corrAns$Cue, corrAns$Subject)),]

## Combine correctly guessed encoding trials
errors <- rbind(errors, repaired)
print(paste("Number of correctly generated items:",
            nrow(errors)))

## Report the items affected by correct answers at encoding
print("Items removed due to correct answer at encoding:")
print(errors)

## Remove correctly guessed items from test data
errors <- test %>% setdiff(errors)
rm(repaired) # Remove unneeded objects

## Test phase ----
## Foils in item recognition test
foils <- data[data$Condition == "Foil",]

# Foil accuracy per subject
foils <- ddply(foils, c("Running", "Subject"),
               summarise,
               n          = length(Acc),
               countAcc   = sum(Acc),
               percentAcc = 100*(countAcc/n),
               rt         = mean(RT))

## Mean accuracy, SEM
summarySE(foils, measurevar = "percentAcc")

##### TO PRODUCE SUPP MAT 1 ANALYSES, UNCOMMENT THE FOLLOWING LINE
## errors <- test

## Meaning vs Study scores per Subject
scores <- ddply(errors, c("Subject", "Test", "Condition"), 
                summarise,
                trialnum   = length(Running),
                countAcc   = sum(Acc),
                percentAcc = 100*(countAcc/trialnum),
                rt         = mean(RT))

## Convert columns to factors for ezANOVA
cols <- c("Subject", "Condition", "Test")
scores[cols] <- lapply(scores[cols], factor)

## Encoding condition x Recog Test mixed ANOVA
test_ez = ezANOVA(data     = scores,
                  wid      = Subject,
                  dv       = percentAcc,
                  within   = Condition,
                  between  = Test,
                  detailed = TRUE,
                  type     = 3)
print("Recognition Test x Condition ANOVA")
print(test_ez)

## Create a list for 'tests' function
pairwise <- list(
  item <- subset(scores, Test == "Item Recognition"),
  associative <- subset(scores, Test == "Associative Recognition")
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

## Bayes factor ----

print("Bayes Factor, associative recognition (Prior: 11.67% difference)")
res <- t.test(percentAcc ~ Condition,
              paired = T,
              data = subset(scores, Test == "Associative Recognition")
              )
ob <- res$estimate
se <- ob/res$statistic
mot <- 11.67
bf <- Bf(sd = se, obtained = ob, uniform = FALSE,
         meanoftheory = mot, sdtheory = mot/2, tail = 2)
print(paste("Obs. mean diff.:",ob))
print(paste("SEM:",se))
print(paste("BF:",bf$BayesFactor))

print("BF (Prior: 2.8% difference)")
mot <- 2.8
bf <- Bf(sd = se, obtained = ob, uniform = FALSE,
         meanoftheory = mot, sdtheory = mot/2, tail = 2)
print(paste("BF:",bf$BayesFactor))

## Paired vs Re-paired analysis ----
print("Paired vs re-paired analysis")

## Subset associative recognition test data
congruency <- subset(errors, Test ==
                       "Associative Recognition")

## Aggregrate accuracy scores per subject/condition
print("DV = percentage of 'Yes' responses")
congruency <- ddply(congruency,
                    c("Subject", "Condition", "Congruency"),
                    summarise,
                    trialnum   = length(Running),
                    countYes   = sum(Resp == "Yes"),
                    percentYes = 100*(countYes/trialnum),
                    rt         = mean(RT))

## Convert columns to factors for ezANOVA
cols <- c("Subject", "Condition", "Congruency")
congruency[cols] <- lapply(congruency[cols], factor)

congruency.ez = ezANOVA(data     = congruency,
                        wid      = Subject,
                        dv       = percentYes,
                        within   = c(Condition, Congruency),
                        detailed = TRUE,
                        type     = 3)
print(congruency.ez)

print("Mean, SEM for main effect of Condition")
summarySE(data = congruency,
          measurevar='percentYes',
          groupvars = 'Condition')

print("Mean, SEM for main effect of Congruency")
summarySE(data = congruency,
          measurevar='percentYes',
          groupvars = 'Congruency')

## Figure 3 ----

## Figure 3a (Accuracy plot)
## Associative recognition group
## Convert long to wide
associative <- scores[scores$Test == "Associative Recognition",
                      c('Subject', 'Condition', 'percentAcc')]
associative <- reshape(associative, direction = "wide",
                       timevar = "Condition", idvar = "Subject")
associative <- associative[,2:3]
colnames(associative) <- c("Meaning", "Study")
## Calc CI
associativeAcc <- cm.ci(associative)
rm(associative)

## Item recognition group
## Convert long to wide
item <- scores[scores$Test == "Item Recognition",
               c('Subject', 'Condition', 'percentAcc')]
item <- reshape(item, direction = "wide",
                timevar = "Condition", idvar = "Subject")
item <- item[,2:3]
colnames(item) <- c("Meaning", "Study")
## Calc CI
itemAcc <- cm.ci(item)
rm(item)

## Combine
percentAcc <-
  cbind(rep(c("Associative Recognition", "Item Recogntition"),
            each = 2), rbind(associativeAcc, itemAcc))

colnames(percentAcc) <- c(
  "Test", "Condition", "lower", "av",
  "upper")
rm(itemAcc, associativeAcc)

## Replace "Item Recognition" with "Target recognition" 
percentAcc$Test <- gsub("Item","Target", percentAcc$Test)

## Define Figure 3a (Accuracy plot)
testplot <- 
  ggplot(percentAcc, aes(x = Test, y = av, fill = Condition))+
  standard_geombar+
  geom_errorbar(
    aes(ymin = lower, ymax = upper),
    width = .3,
    size = 1,
    position = position_dodge(.9))+
  scale_x_discrete("Test format")+
  scale_y_continuous("Percent correct",
                     expand=c(0,0),
                     limits = c(0, 100),
                     breaks=seq(0, 100, by=10))+
  theme_APA

## Grayscale colour scheme
testplot <- testplot + scale_fill_grey(start = .3, end = .7)

## Figure 3b (Congruency plot)
## Meaning condition
## Convert long to wide
meaning <- congruency[congruency$Condition == "Meaning",
                      c('Subject','Congruency', 'percentYes')]
meaning <- reshape(meaning, direction = "wide", timevar = "Congruency",
                   idvar = "Subject")
meaning <- meaning[,2:3]
colnames(meaning) <- c("Paired", "Re-paired")
## Calc CI
meaningAcc <- cm.ci(meaning)
rm(meaning)

## Study condition
## Convert long to wide
study <- congruency[congruency$Condition == "Study", 
                    c('Subject', 'Congruency', 'percentYes')]
study <- reshape(study, direction = "wide", timevar = "Congruency",
                 idvar = "Subject")
study <- study[,2:3]
colnames(study) <- c("Paired", "Re-paired")
## Calc CI
studyAcc <- cm.ci(study)
rm(study)

## Combine
PercentYes <-
  cbind(rep(c("Meaning", "Study"), each = 2),
        rbind(meaningAcc, studyAcc))

colnames(PercentYes) <- c(
  "Condition", "Congruency", "lower", "av",
  "upper")
rm(studyAcc, meaningAcc)

## Define Figure 3b
YesNoPlot <-
  ggplot(PercentYes, aes(x = Condition, y = av, fill = Congruency))+
  standard_geombar+
  geom_errorbar(
    aes(ymin = lower, ymax = upper),
    width = .3,
    size = 1,
    position = position_dodge(.9))+
  scale_x_discrete("Encoding condition")+
  scale_y_continuous(
    "Percentage of 'Yes' responses",
    expand=c(0,0),
    limits = c(0, 100),
    breaks=seq(0, 100, by=10)) +
  theme_APA

## Grayscale colour scheme
YesNoPlot <- YesNoPlot + scale_fill_grey(start = .3, end = .7) 

## Combine graphs and save
p <- plot_grid(
  testplot,
  YesNoPlot,
  labels = c("a", "b"),
  label_size = 18,
  ncol = 2)
print(p)

ggsave(filename = "fig3.jpg", plot = p, width = 30, height = 15, units
       = "cm")
ggsave(filename = "fig3.pdf", plot = p, width = 30, height = 15, units
       = "cm")


print("Supplementary Materials")
print("Reaction times")
print("Condition x Test ANOVA")
rt.ez = ezANOVA(data     = scores,
                wid      = Subject,
                dv       = rt,
                within   = Condition,
                between  = Test,
                detailed = TRUE,
                type     = 3)
print(rt.ez)

## Means, SEMs for main effect of Test
print("Mean values for main effect of test")
summarySE(scores, measurevar = "rt", groupvars = "Test")

