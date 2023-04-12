print("DAU: PLYM5")
print("Author: Andy Wills")
print("Credits: Developed from script by Angus Inkster")
print("Date: 2014-12-03")
source("plym5cap.R")
bigdta <- read.table("plym5data.txt", header = TRUE, sep = "\t")
code <- read.table("plym5code.txt", header = TRUE, sep = "\t",stringsAsFactors = FALSE)
ppts <- 106
blktype <- 3

print("PRIMARY ANALYSIS - Nonlearners excluded, all stimuli analysed")
plym5cap(crittype = 2, antype = 0, msave = FALSE)
print("ANALYSIS 2 - All participants, all stimuli analysed")
plym5cap(crittype = 0, antype = 0, msave = FALSE)
print("ANALYSIS 3 - All participants, OS-ambiguous test stimuli excluded")
plym5cap(crittype = 0, antype = 1, msave = TRUE)

