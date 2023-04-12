print("DAU: PLYM5 supplementary")
print("Author: Andy Wills")
print("Credits: Developed from script by Angus Inkster")
print("Date: 2014-12-01")
bigdta <- read.table("plym5data.txt", header = TRUE, sep = "\t")
code <- read.table("plym5code.txt", header = TRUE, sep = "\t",stringsAsFactors = FALSE)
ppts <- 106
blktype <- 3
crittype = 2
antype = 0


