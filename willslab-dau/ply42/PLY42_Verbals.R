print("DAU: PLY42: Strategy report analysis")
print("CC BY-SA 4.0")
print("Author: Charlotte E.R. Edmunds")

## Set up ----------------------------------------------------------------------
rm(list=ls())

## Import packages
library(irr)

## Define functions 
source('PLY42 Functions.R')

## Load data
verbals <- read.csv("PLY42verbalReports.csv", header=TRUE)

verbals$Condition <- factor(verbals$Condition, 
                            labels=c("EasyAll","AllAll","HardAll"))
verbals <- verbals[verbals$Condition!="AllAll",]
verbals$Condition <- factor(verbals$Condition)

## Print verbal information ----------------------------------------------------
## Number of participants that reported strategies
print("Table 2 (Exp.3) no strategy N")
print(table(verbals$Condition, verbals$AgreedYes))

## Cohen's Kappa for listing a strategy
print("Table 2 (Exp.3) Presence of Strategy")
kappa<-kappa2(verbals[,c("CEREyes","GWyes")], weight="unweighted", 
              sort.levels = FALSE)
print(kappa)

## Cohen's Kappa for strategy type
print("Table 2 (Exp.3) Type of Strategy")
kappa<-kappa2(verbals[,c("CERE","GW")], weight="unweighted", 
              sort.levels = FALSE) 
print(kappa)

counts <- table(verbals[,'Condition'], verbals[,'simpStrat'])

## Gives the proportions in terms of total responses for each
## condition

print("Table 3 (Exp.3)")
proportions <- prop.table(counts,1)
row.names(proportions) <- c("Easy-to-all", "Hard-to-all")
print(round(proportions,2))
