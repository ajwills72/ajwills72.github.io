print("DAU: PLY22: Strategy report analysis")
print("CC BY-SA 4.0")
print("Author: Charlotte E.R. Edmunds")

## Set up
## ------
rm(list=ls())

## Import packages
library(irr)

## Define functions 
source('PLY22 Functions.R')

## Load data
verbals <- read.csv("PLY22verbalReports.csv", header=TRUE)

nonLearners <- c(22006, 22019, 22020)
verbals <- verbals[!verbals$Participant %in% nonLearners,]
verbals$Condition <- factor(verbals$Condition, labels=c("EasyHard","HardEasy"))

verbals["CEREyes"] <- ifelse(is.na(verbals$CERE), 0, 1)
verbals["GWyes"] <- ifelse(is.na(verbals$GW), 0, 1)

## Number of participants that reported strategies
print("Table 2 (Exp.1) no strategy N")
print(table(verbals$Condition, verbals$AgreedYes))

## Cohen's Kappa for listing a strategy
print("Table 2 (Exp.1) Presence of Strategy")
kappa<-kappa2(verbals[,c("CEREyes","GWyes")], weight="unweighted", 
              sort.levels = FALSE)
print(kappa)

## Cohen's Kappa for strategy type
print("Table 2 (Exp.1) Type of Strategy")
kappa<-kappa2(verbals[,c("CERE","GW")], weight="unweighted", 
              sort.levels = FALSE) 
print(kappa)

counts <- table(verbals[,'Condition'], verbals[,'simpStrat'])

## Gives the proportions in terms of total responses for each
## condition

print("Table 3 (Exp.1)")
proportions <- prop.table(counts,1)
row.names(proportions) <- c("Easy-to-moderate", "Hard-to-moderate")
print(round(proportions,2))
