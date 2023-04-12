print("DAU: PLYM7")
print("Author: Andy Wills")
print("Credits: Developed from script by Angus Inkster")
print("Date: 2014-12-03")
source("plym7cap.R")
bigdta <- read.table("plym7data.txt", header = TRUE, sep = "\t")
code <- read.table("plym7code.txt", header = TRUE, sep = "\t",stringsAsFactors = FALSE)
ppts <- 82
blktype <- 3
print("PRIMARY ANALYSIS - Nonlearners excluded, all stimuli analysed")
plym7cap(crittype = 2, antype = 0, msave = FALSE)
print("ANALYSIS 2 - All participants, all stimuli analysed")
plym7cap(crittype = 0, antype = 0, msave = FALSE)
print("ANALYSIS 3 - All participants, OS-ambiguous test stimuli excluded")
plym7cap(crittype = 0, antype = 1, msave = TRUE)

