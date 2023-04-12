print('DAU:EXE13')
print('Andy Wills')
print('2016-02-22')
print('')
print('DAU: EXE13 by Andy Wills is licensed under a Creative Commons')
print('Attribution-ShareAlike 4.0 International License.')
print('http://creativecommons.org/licenses/by-sa/4.0/')
print('')

decode.stim2 <- function(dum) {
  a <- c(0,0,0)
  a[1] <- substr(dum,2,2) #top (peck zone 1)
  a[2] <- substr(dum,3,3) #left (peck zone 2)
  a[3] <- substr(dum,4,4) #right (peck zone 3)
  a <- as.numeric(a)
  b <- c(0,0,0,0) # bar,checks,donught,lozenge
  if(1 %in% a) b[4] <- 1
  if(2 %in% a) b[3] <- 1
  if(3 %in% a) b[1] <- 1
  if(4 %in% a) b[2] <- 1
  if(5 %in% a) b[4] <- 2
  if(6 %in% a) b[3] <- 2
  if(7 %in% a) b[1] <- 2
  if(8 %in% a) b[2] <- 2
  return(b)
}

# Load raw data
dta <- read.csv('exe13data.csv', header = TRUE, stringsAsFactors = FALSE)

# Remove empty and missing sessions
dta <- dta[dta$fc != 'empty',]
dta <- dta[dta$fc != 'missing',]

print('Phase 1')
print('-------')

ph1dta <- dta[dta$phase == 1,]

# Recode response for analysis convenience
ph1dta$pk1acc[ph1dta$pk1acc != '*'] <- 0
ph1dta$pk1acc[ph1dta$pk1acc == '*'] <- 1
ph1dta$pk1acc <- as.numeric(ph1dta$pk1acc)

### Number of sessions in Phase 1, by bird
ph1blks <- aggregate(ph1dta$sess,list(ph1dta$subj),max)
colnames(ph1blks) <- c('subj','n')

### Performance on last session, by bird

# Extract final block performance
ph1lblk <- NULL
for(i in 1:nrow(ph1blks)) {
    ph1lblk <- rbind(ph1lblk, ph1dta[ph1dta$subj == ph1blks$subj[i] &
                                     ph1dta$sess == ph1blks$n[i],]
                     )
}
# Calculate accuracies
ph1lacc <- aggregate(ph1lblk$pk1acc,list(ph1lblk$subj),mean)
colnames(ph1lacc) <- c('subj','acc')

### Performance on last session, by bird, and dimension

# Accuracy by stimulus, and subject
ph1sum <- aggregate(
    ph1lblk$pk1acc,list(ph1lblk$stim,ph1lblk$subj),mean)
colnames(ph1sum) <- c('stim','subj','acc')
# Classify stimuli by dimension presented
ph1sum$dim <- 0
ph1sum$dim[ph1sum$stim == 'S1000' | ph1sum$stim == 'S2000'] <- 1
ph1sum$dim[ph1sum$stim == 'S0100' | ph1sum$stim == 'S0200'] <- 2
ph1sum$dim[ph1sum$stim == 'S0010' | ph1sum$stim == 'S0020'] <- 3
ph1sum$dim[ph1sum$stim == 'S0001' | ph1sum$stim == 'S0002'] <- 4
# Classify each stimulus as pass or fail
ph1sum$pass <- 1
ph1sum$pass[ph1sum$acc < 0.75] <- 0
# Count passes by dimension
ph1pass <- aggregate(ph1sum$pass,
                    list(ph1sum$dim,ph1sum$subj),sum)
colnames(ph1pass) <- c('dim','subj','n')
# Classify two passes as a pass
# (hence, both levels of the dimension passed the criterion).
ph1pass$pass <- 0
ph1pass$pass[ph1pass$n == 2] <- 1
# Number of dimensions passed
ph1npass <- aggregate(ph1pass$pass,list(ph1pass$subj),sum)
colnames(ph1npass) <- c('subj','n')

print('Number of sessions, final session accuracy, and number')
print('of dimensions for which accuracy for both stimuli is')
print('at least 75%. By bird.')
print('')

ph1tbl <- cbind(ph1blks,ph1lacc$acc,ph1npass$n)
colnames(ph1tbl) <- c('subj','sess','final_acc','n_dim')
print(ph1tbl)

# Housekeeping at end of phase 1
rm(i,ph1blks,ph1dta,ph1lacc,ph1lblk,ph1npass,ph1pass,ph1sum)

print('Phase 2')
print('-------')

#Extract phase 2 data
ph2dta <- dta[dta$phase==2,]

# Recode response for analysis convenience
ph2dta$pk1acc[ph2dta$pk1acc != '*'] <- 0
ph2dta$pk1acc[ph2dta$pk1acc == '*'] <- 1
ph2dta$pk1acc <- as.numeric(ph2dta$pk1acc)

### Number of sessions in Phase 2, by bird

# Largest session number in phase 2
ph2blks <- aggregate(ph2dta$sess,list(ph2dta$subj),max)
colnames(ph2blks) <- c('subj','nmax')
# Subtract sessions already completed.
ph2blks$n <- ph2blks$nmax - ph1tbl$sess

# I don't think I'm gonna like this, but accuracy by block
# ph2acc <- aggregate(ph2dta$pk1acc,list(ph2dta$sess,ph2dta$subj),mean)
# Actually, it was OK

# Extract final block performance
ph2lblk <- NULL
for(i in 1:nrow(ph2blks)) {
    ph2lblk <- rbind(ph2lblk, ph2dta[ph2dta$subj == ph2blks$subj[i] &
                                     ph2dta$sess == ph2blks$nmax[i],]
                     )
}

# Calculate accuracy
ph2acc <- aggregate(ph2lblk$pk1acc,list(ph2lblk$subj),mean)
colnames(ph2acc) <- c('subj','acc')
# Compile summary table
ph2tbl <- data.frame(ph2blks$subj,ph2blks$n,ph2acc$acc)
colnames(ph2tbl) <- c('subj','n','acc')
#
print('Number of sessions to criterion, and accuracy on final session')
print(', by bird.')
print(ph2tbl)
# Housekeeping
rm(i,ph2acc,ph2blks,ph2dta,ph2lblk)

print('Test stimuli')
print('-----------')

ph3dta <- dta[dta$phase %in% c(3,5,7,9,11,13) & dta$pk1acc %in% c('L','R'),]

## There are some excess test sessions.
## In order to maintain counterbalancing, these have to be ignored.

# Atal session 76 was accidentally run as a test session
# (log book records as Phase 2b, but data file is a test session)
# Session 75 is the best fit to results reported in Table 1.
# Atal is Checks, whether one analyses 75, 76, or both.
# To preserve c/bal, it is best to lose one of these sessions
# Lose session 76
ph3dta <- ph3dta[!(ph3dta$subj == 'At' & ph3dta$sess == 76),]

# Iorek, sessions 63-64. Log book records only one session on this day
# Iorek (2006-10-27), but there are two non-identical data files.
# Session 64 is the best fit to the results reported in Table 1.
# Whether one uses session 63, sesion 64, or both, Iorek is still an
# OS classifier.
# To preserve c/bal, it is best to lose one of these sessions.
# Lose session 63...
ph3dta <- ph3dta[!(ph3dta$subj == 'Io' & ph3dta$sess == 63),]

# Lyra, sessions 67-68. From log book, both are test sessions.
# The best fit to Table 1 comes from combining the two sessions.
# Lyra is OS in the combined analysis, and also in session 67 is
# dropped. If session 68 is dropped, Lyra is Checks.
# Irrespective of what was reported in Table 1, to preserve
# c/bal, it is best to lose one of these sessions. Given 2 out
# of 3 assessments put Lyra as OS, selecting the single session
# that also does this seems most appropraite.
# Lose session 67.
ph3dta <- ph3dta[!(ph3dta$subj == 'Ly' & ph3dta$sess == 67),]

#View(ph3dta[ph3dta$subj == 'At' & ph3dta$phase ==3,])
#View(ph3dta[ph3dta$subj == 'At' & ph3dta$phase ==5,])

#View(ph3dta[ph3dta$subj == 'Io' & ph3dta$phase ==3,])
#View(ph3dta[ph3dta$subj == 'Io' & ph3dta$phase ==5,])

#View(ph3dta[ph3dta$subj == 'Ly' & ph3dta$phase ==7,])
#View(ph3dta[ph3dta$subj == 'Ly' & ph3dta$phase ==5,])

# Recode stimulus for analysis convenience
ph3dta$bar <- 0
ph3dta$chk <- 0
ph3dta$don <- 0
ph3dta$loz <- 0
for(i in 1:nrow(ph3dta)) {
  ph3dta[i,20:23] <- decode.stim2(ph3dta$stim[i])
}

# Recode response for analysis convenience
ph3dta$pk1acc[ph3dta$pk1acc == 'L' & ph3dta$keyb == 'left'] <- 1
ph3dta$pk1acc[ph3dta$pk1acc == 'R' & ph3dta$keyb == 'left'] <- 2
ph3dta$pk1acc[ph3dta$pk1acc == 'L' & ph3dta$keyb == 'right'] <- 2
ph3dta$pk1acc[ph3dta$pk1acc == 'R' & ph3dta$keyb == 'right'] <- 1
# Add OS strategy
ph3dta$sm <- ph3dta$bar + ph3dta$chk + ph3dta$don + ph3dta$loz
ph3dta$os <- 1
ph3dta$os[ph3dta$sm > 4] <- 2
# Remove prototype stimuli
ph3dta <- ph3dta[ph3dta$sm != 3,]
ph3dta <- ph3dta[ph3dta$sm != 6,]

# Score each strategy
ph3dta$bar.sc <- 0
ph3dta$bar.sc[ph3dta$bar == ph3dta$pk1acc] <- 1
ph3dta$chk.sc <- 0
ph3dta$chk.sc[ph3dta$chk == ph3dta$pk1acc] <- 1
ph3dta$don.sc <- 0
ph3dta$don.sc[ph3dta$don == ph3dta$pk1acc] <- 1
ph3dta$loz.sc <- 0
ph3dta$loz.sc[ph3dta$loz == ph3dta$pk1acc] <- 1
ph3dta$os.sc <- 0
ph3dta$os.sc[ph3dta$os == ph3dta$pk1acc] <- 1
#Total score by participant
ph3bar <- aggregate(ph3dta$bar.sc,list(ph3dta$subj),sum)
ph3chk <- aggregate(ph3dta$chk.sc,list(ph3dta$subj),sum)
ph3don <- aggregate(ph3dta$don.sc,list(ph3dta$subj),sum)
ph3loz <- aggregate(ph3dta$loz.sc,list(ph3dta$subj),sum)
ph3os <- aggregate(ph3dta$os.sc,list(ph3dta$subj),sum)
ph3mds <- data.frame(ph3bar,ph3chk$x,ph3don$x,ph3loz$x,ph3os$x)
colnames(ph3mds) <- c('subj','bar','chk','don','loz','os')
rm(ph3bar,ph3chk,ph3don,ph3loz,ph3os)

ph3mds$win <- 'dud'
for(i in 1:nrow(ph3mds)) {
  ph3mds$win[i] <- names(which.max(ph3mds[i,2:6]))
}

# Manual resolution of ties
ph3mds$win[7] = 'os/don'
# Conversion to proportions, and round
ph3mds$bar <- round(ph3mds$bar *100 / 72)
ph3mds$chk <- round(ph3mds$chk *100 / 72)
ph3mds$don <- round(ph3mds$don *100 / 72)
ph3mds$loz <- round(ph3mds$loz *100 / 72)
ph3mds$os <- round(ph3mds$os *100 / 72)

# Replace proportions with blanks, for neatness
ph3mds$loz[ph3mds$loz == 0] <- ' '
ph3mds$bar[ph3mds$bar == 0] <- ' '
ph3mds$chk[ph3mds$chk == 0] <- ' '
ph3mds$don[ph3mds$don == 0] <- ' '

# Rearrange rows for comparability to Table 1
ph3mds <- subset(ph3mds, select=c('subj','bar','chk','loz','don','os','win'))
print('Table 1 replacement')
print('-------------------')
print(ph3mds)

rm(ph3dta) # Housekeeping
