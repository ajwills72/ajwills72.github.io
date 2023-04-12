## Title:   PLY147 analysis (TPL4)
## Author:  Tina Seabrooke

## Setup ----
library(plyr)    # provides 'ddply'
library(Rmisc)   # provides 'summarySE'
library(ez)      # provides 'ezANOVA'
library(ggplot2) # provides 'ggplot'
library(pastecs) # provides 'stat.desc'
library(pwr)     # provides 'pwr.t.test'

## Load custom functions
source('TPL4Functions.R')

## Read data file
data <- read.csv("TPL4_LongData.csv",
                 stringsAsFactors = F)

## Remove practice trials
prac <- c("PracticeStudy", "PracticeMeaning", "TestPrac")
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
  paste("Familiar foils:",
        sum(oneRow$Test == "Familiar foils")),
  paste("Unfamiliar foils:",
        sum(oneRow$Test == "Unfamiliar foils"))
)
print(demog)

## Age info
print("Summary of ages:")
age <- data.frame(stat.desc(oneRow$Age))
age$variable <- rownames(age)
keep <- c("min", "max", "mean", "SE.mean")
age  <- data.frame(age[keep, ])
print(age)
rm(age, demog, oneRow)

## Power calculations

print("Power on basis of Exp. 1 effect size")
print(pwr.t.test(n = 46, d = .51, sig.level = .05, type = 'paired'))

print("Power on basis of Exp. 3 effect size")
print(pwr.t.test(n = 46, d = .71, sig.level = .05, type = 'paired'))

## Correct generations during encoding ----

print("Correct answers during encoding phase")
corrAns <- data[data$Running == "Meaning" & data$Acc == 1,]
print(corrAns)

## Subset test data
test <- data[data$Running == "Test",]

## Remove targets that were correctly generated during encoding
errors <- test[! paste(test$Subject, test$Target) %in% 
                 c(paste(corrAns$Subject, corrAns$Target),
                   paste(corrAns$Target, corrAns$Subject)),]

## Remove foils that were correctly generated during encoding
errors <- errors[! paste(errors$Subject, errors$FoilTarget) %in% 
                   c(paste(corrAns$Subject, corrAns$Target),
                     paste(corrAns$Target, corrAns$Subject)),]

#### IN ORDER TO PRODUCE THE SUPP. MAT. 1 (ALL TRIALS) ANALYSES
#### uncomment the following line:
## errors <- test

## Test phase ----

## Meaning vs Study scores per Subject
summary <- ddply(errors, c("Subject", "Test", "Condition"),
                 summarise,
                 trialnum   = length(Running),
                 countAcc   = sum(Acc),
                 percentAcc = 100*(countAcc/trialnum),
                 rt         = mean(RT))

## Convert columns to factor for ezANOVA
cols <- c("Subject", "Condition", "Test")
summary[cols] <- lapply(summary[cols], factor)

## Condition x Test mixed ANOVA
errors.ez = ezANOVA(data     = summary,
                    dv       = percentAcc,
                    wid      = Subject,
                    within   = Condition,
                    between  = Test,
                    detailed = T,
                    type     = 3)
print(errors.ez)

## Create a list for 'tests' function
pairwise <- list(
  familiar <- subset(summary, Test == "Familiar foils"),
  unfamiliar <- subset(summary, Test == "Unfamiliar foils")
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
              data = subset(summary, Test == "Familiar foils")
              )
ob <- res$estimate
se <- ob/res$statistic
mot <- 11.67
bf <- Bf(sd = se, obtained = ob, uniform = FALSE,
         meanoftheory = mot, sdtheory = mot/2, tail = 2)
print(paste("Obs. mean diff.:",ob))
print(paste("SEM:",se))
print(paste("BF:",bf$BayesFactor))

print("BF (Prior: 2.2% difference)")
mot <- 2.2
bf <- Bf(sd = se, obtained = ob, uniform = FALSE,
         meanoftheory = mot, sdtheory = mot/2, tail = 2)
print(paste("BF:",bf$BayesFactor))

## Graph (Figure 5) ----

## Familiar foil  group
## Convert long to wide
fam <- summary[summary$Test == "Familiar foils",
               c('Subject', 'Condition', 'percentAcc')]

fam <- reshape(fam, direction = "wide",
               timevar = "Condition", idvar = "Subject")

fam <- fam[,2:3]
colnames(fam) <- c("Meaning", "Study")

## Calc CI
fam <- cm.ci(fam)

## Unfamiliar foil group
## Convert long to wide
unf <- summary[summary$Test == "Unfamiliar foils",
               c('Subject', 'Condition', 'percentAcc')]

unf <- reshape(unf, direction = "wide",
               timevar = "Condition", idvar = "Subject")

unf <- unf[,2:3]
colnames(unf) <- c("Meaning", "Study")

## Calc CI
unf <- cm.ci(unf)

## Combine
percentAcc <-
  cbind(rep(c("Familiar foils", "Unfamiliar foils"),
            each = 2), rbind(fam, unf))

colnames(percentAcc) <- c(
  "Test", "Condition", "lower", "av",
  "upper")
rm(fam, unf)

## Define Figure 5
plot <- 
  ggplot(percentAcc, aes(x = Test, y = av, fill = Condition))+
  standard_geombar+
  geom_errorbar(
    aes(ymin = lower, ymax = upper),
    width = .3,
    size = 1,
    position = position_dodge(.9))+
  scale_x_discrete("Foil familiarity")+
  scale_y_continuous("Percent correct", expand=c(0,0))+
  coord_cartesian(ylim=c(50,100))+
  theme_APA

## Grayscale colour scheme
plot <- plot + scale_fill_grey(start = .3, end = .7)
print(plot)

## Save plot
ggsave(plot = plot, "plot.png", width = 15, height = 15, units = "cm")
ggsave(plot = plot, "plot.pdf", width = 15, height = 15, units = "cm") 


## Supplementary materials ----
## Reaction times

## Condition x Test mixed ANOVA
rt.ez = ezANOVA(data     = summary,
                dv       = rt,
                wid      = Subject,
                within   = Condition,
                between  = Test,
                detailed = T,
                type     = 3)
print("Reaction time ANOVA")
print(rt.ez)

rt.ez = ezStats(data     = summary,
                dv       = rt,
                wid      = Subject,
                within   = Condition,
                between  = Test,
                type     = 3)
SEM <- rt.ez$SD/sqrt(rt.ez$N)
rt.ez <- cbind(rt.ez,SEM)
print(rt.ez)


## Summary scores for main effect of Test
print("Reaction time Means and SEMs")
summarySE(data=summary, measurevar="rt", groupvars="Test")

## Function to apply to each item on the list
tests <- function (p){
  ## t-test
  tt <- t.test(rt ~ Condition, paired = T, data = p)
  ## Cohen's d_z
  dz <- p[,c("Subject", "Condition", "rt")]     
  colnames(dz) <- c('id', 'cond', 'dv')
  cd <- cohen.dz(dz)
  ret <- list(tt, cd)
  
}

## Apply function to each item in list
print("Pairwise comparisons")
print(lapply(pairwise, tests))
