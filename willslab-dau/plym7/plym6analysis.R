print("DAU: PLYM6")
print("Author: Andy Wills")
print("Credits: Developed from script by Angus Inkster")
print("Date: 2014-12-02")
source("plym6cap.R")
bigdta <- read.table("plym6data.txt", header = TRUE, sep = "\t")
code <- read.table("plym6code.txt", header = TRUE, sep = "\t",stringsAsFactors = FALSE)
ppts <- 75
blktype <- 3
print("PRIMARY ANALYSIS - Nonlearners excluded")
plym6cap(crittype = 2)
print("ANALYSIS 2 - All participants")
plym6cap(crittype = 0)

