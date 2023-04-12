# Read in raw data
dta <- read.table("exe10data.txt", header = TRUE, sep = "\t")
code <- read.table("exe10code.csv", header = TRUE, sep = ",",
                   stringsAsFactors = FALSE)
# NB: This script assumes that the 'code' array is ordered by 
# stimulus ID number, ascending.

# Add in the extra columns we'll need
stimcode <- array(NA,length(dta$cond))
stimcorr <- array(NA,length(dta$cond))
stimacc <- array(NA,length(dta$cond))
stimtype <- array(NA,length(dta$cond))
dta <- cbind(dta,stimcode,stimtype,stimcorr,stimacc)
rm(stimcode, stimtype,stimcorr,stimacc)

# Code logical trial letter codes
dta$stimcode[dta$cb == 1] <- code$CB1code[dta$stim2[dta$cb == 1]]
dta$stimcode[dta$cb == 2] <- code$CB2code[dta$stim2[dta$cb == 2]]
# Code stimulus type
dta$stimtype[dta$cb == 1] <- code$CB1type[dta$stim2[dta$cb == 1]]
dta$stimtype[dta$cb == 2] <- code$CB2type[dta$stim2[dta$cb == 2]]
# Code food correct answers
dta$stimcorr[dta$cb == 1] <- code$CB1corr[dta$stim2[dta$cb == 1]]
dta$stimcorr[dta$cb == 2] <- code$CB2corr[dta$stim2[dta$cb == 2]]
# Code accuracy on food responses
dta$stimacc[dta$resp == dta$stimcorr] <- 1
dta$stimacc[dta$resp != dta$stimcorr] <- 0

rm(code) # Housekeeping

# Recode TOs RT as arbitrarily large (10 seconds)
dta$rt[dta$resp == -1] <- 10000
