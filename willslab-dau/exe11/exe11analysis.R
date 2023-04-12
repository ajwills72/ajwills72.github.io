print('DAU: EXE11')
print('2015-12-04')
print('Andy Wills')
print('')
print('DAU: EXE11 by Andy Wills is licensed under a Creative Commons')
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

# Load data file
dta <- read.table('exe11data.csv',header=T,sep=",",as.is=T)
print('Removing participant 13.')
print('(Technical error)')

dta <- dta[dta$subj != 13,]

print('')

print('Phase 1')
print('-------')

ph1dta <- dta[dta$phase == 1,]

# Recode response for analysis convenience
ph1dta$pk1acc[ph1dta$pk1acc == '*'] <- 1
ph1dta$pk1acc[ph1dta$pk1acc == '+'] <- 0
ph1dta$pk1acc <- as.numeric(ph1dta$pk1acc)
# Classify stimuli by dimension presented
ph1dta$dim <- 0
ph1dta$dim[ph1dta$stim == 'S1000' | ph1dta$stim == 'S2000'] <- 1
ph1dta$dim[ph1dta$stim == 'S0100' | ph1dta$stim == 'S0200'] <- 2
ph1dta$dim[ph1dta$stim == 'S0010' | ph1dta$stim == 'S0020'] <- 3
ph1dta$dim[ph1dta$stim == 'S0001' | ph1dta$stim == 'S0002'] <- 4

# Accuracy by dimension, block, and subject
ph1sum <- aggregate(ph1dta$pk1acc,list(ph1dta$dim,ph1dta$block,ph1dta$subj),mean)
colnames(ph1sum) <- c('dim','block','subj','acc')
# Classify each dimension as pass or fail
ph1sum$pass <- 1
ph1sum$pass[ph1sum$acc < 0.75] <- 0
# Number of dimensions passed
ph1npass <- aggregate(ph1sum$pass,list(ph1sum$block,ph1sum$subj),sum)
colnames(ph1npass) <- c('block','subj','n')

# Participants failing criterion (fewer than 3 dimensions at 75%+ accuracy)
ph1fail <- aggregate(ph1npass$n,list(ph1npass$subj),max)
colnames(ph1fail) <- c('subj','npass')
ph1fails <- ph1fail$subj[ph1fail$npass < 3]

#Block to criterion, by participant
#ph1blks <- aggregate(ph1npass$block,list(ph1npass$subj),max)
#colnames(ph1blks) <- c('subj','n')

print('Participants failing Phase 1 criterion: ')
print(ph1fails)

rm(ph1dta,ph1fail,ph1npass,ph1sum) #Housekeeping

print('')
print('Phase 2')
print('-------')
ph2dta <- dta[dta$phase == 2,]
# Recode response for analysis convenience
ph2dta$pk1acc[ph2dta$pk1acc == '*'] <- 1
ph2dta$pk1acc[ph2dta$pk1acc == '+'] <- 0
ph2dta$pk1acc <- as.numeric(ph2dta$pk1acc)
# Recode stimulus for analysis convenience
ph2dta$bar <- 0
ph2dta$chk <- 0
ph2dta$don <- 0
ph2dta$loz <- 0
for(i in 1:nrow(ph2dta)) {
  ph2dta[i,15:18] <- decode.stim2(ph2dta$stim[i])
}

# Accuracy by subject (only one block was ever run)
ph2sum <- aggregate(ph2dta$pk1acc,list(ph2dta$subj),mean)
colnames(ph2sum) <- c('subj','acc')

# Phase 2 fails
ph2fails <- ph2sum$subj[ph2sum$acc < .75]
print('Participants failing Phase 2 criterion: ')
print(ph2fails)

print('')
print('Removing participants 14,15')
print('')
dta <- dta[dta$subj != 14,]
dta <- dta[dta$subj != 15,]
ph2dta <- ph2dta[ph2dta$subj != 14,]
ph2dta <- ph2dta[ph2dta$subj != 15,]

# Dropped dimension
drp.bar <- aggregate(ph2dta$bar,list(ph2dta$subj),min)
drp.chk <- aggregate(ph2dta$chk,list(ph2dta$subj),min)
drp.don <- aggregate(ph2dta$don,list(ph2dta$subj),min)
drp.loz <- aggregate(ph2dta$loz,list(ph2dta$subj),min)
kept <- data.frame(drp.bar,drp.chk$x,drp.don$x,drp.loz$x)
rm(drp.bar,drp.chk,drp.don,drp.loz)
colnames(kept) <- c('subj','bar','chk','don','loz')

print('')
print('Dimensions kept in prototype, by participant:')
print(kept)

rm(ph2dta,ph2sum) # Housekeeping

print('')
print('Phase 3 (test stimuli)')
print('----------------------')
ph3dta <- dta[dta$phase == 3 & (dta$pk1acc == 'L' | dta$pk1acc == 'R'),]
# Recode stimulus for analysis convenience
ph3dta$bar <- 0
ph3dta$chk <- 0
ph3dta$don <- 0
ph3dta$loz <- 0
for(i in 1:nrow(ph3dta)) {
  ph3dta[i,15:18] <- decode.stim2(ph3dta$stim[i])
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
ph3mds$win[2] = 'os/chk'
ph3mds$win[6] = 'os/chk/don'
# Conversion to proportions
ph3mds$bar <- ph3mds$bar / 16
ph3mds$chk <- ph3mds$chk / 16
ph3mds$don <- ph3mds$don / 16
ph3mds$loz <- ph3mds$loz / 16
ph3mds$os <- ph3mds$os / 16
# Replace proportions with blanks, for neatness
ph3mds$loz[ph3mds$loz == 0] <- ' '
ph3mds$bar[ph3mds$bar == 0] <- ' '
ph3mds$chk[ph3mds$chk == 0] <- ' '
ph3mds$don[ph3mds$don == 0] <- ' '

print(ph3mds)

rm(ph3dta) # Housekeeping
