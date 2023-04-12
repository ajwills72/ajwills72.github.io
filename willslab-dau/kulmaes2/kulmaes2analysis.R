print('DAU: KULMAES2')
print('Date: 2015-02-16')
print('Author: Andy J. Wills')
print('---------------------')
print('Loading data...')
dta <- read.table("kulmaes2data.txt",stringsAsFactors = FALSE, sep = "\t", header=TRUE)
print('Phase 1, part 3')
# Extract data
p1 <- dta[dta$phase == '1c',]
# Code trial types
p1$type[p1$stim == 'A'] <- 'A/B'
p1$type[p1$stim == 'B'] <- 'A/B'
p1$type[p1$stim == 'C'] <- 'C/D'
p1$type[p1$stim == 'D'] <- 'C/D'
p1$type[p1$stim == 'AB'] <- 'AB'
p1$type[p1$stim == 'CD'] <- 'CD'


# Aggregate across trial types
p1ag <- aggregate(p1$resp,list(p1$cond,p1$subj,p1$type),mean)
colnames(p1ag) <-c('cond','subj','type','resp')

print('Figure 4, means')
p1av <- aggregate(p1ag$resp,list(p1ag$type),mean)
colnames(p1av) <- c('stim','resp')
print(p1av)

# Create reinforced vs. nonreinforced trial coding
p1ag$type2[p1ag$type == 'A/B'] <- 'R'
p1ag$type2[p1ag$type == 'C/D'] <- 'U'
p1ag$type2[p1ag$type == 'AB'] <- 'U'
p1ag$type2[p1ag$type == 'CD'] <- 'R'
# Aggregate across this coding
p1ru <- aggregate(p1ag$resp,list(p1ag$cond,p1ag$subj,p1ag$type2),mean)
colnames(p1ru) <-c('cond','subj','type2','resp')
print('Phase 1 t-test')
p1result <- t.test(resp ~ type2,data=p1ru, paired = TRUE)
print(p1result)
# Convert to wide for comparison with Elisa's file
#p1r <- p1ru[p1ru$type2 == 'R',]
#p1u <- p1ru[p1ru$type2 == 'U',]
#wide <- cbind(p1r$subj,p1r$resp,p1u$resp)
# Load ELisa's file
#elisa <- read.table("maesfile1.csv",stringsAsFactors = FALSE, sep = ",", header=TRUE)
#cmp <- elisa-wide

print('---------------------')
print('Phase 2')
# Extract Phase 2
p2 <- dta[dta$phase == '2',]
# Now extract just E and F trial types
p2 <- p2[p2$stim == 'E' | p2$stim == 'F',]
# Now aggregate
p2ag <- aggregate(p2$resp,list(p2$cond,p2$subj),mean)
colnames(p2ag) <- c('cond','subj','resp')
print('t test')
p2result <- t.test(resp ~ cond, data=p2ag, paired = FALSE, var.equal = FALSE)
print(p2result)
print('---------------------')
print('Phase 3 group level')
# Extrat Phase 3, part 2, trial 1 (which is always EF)
p3 <- dta[dta$phase == '3b' & dta$trial == 1,]
print('t test')
p3result <- t.test(resp ~ cond, data=p3, paired = FALSE, var.equal = FALSE)
print(p3result)
print('---------------------')
print('Phase 3 individual level')

# PP transfer condition - Rule-based prediction is EF > E/F. 
# E/F is nonreinforced. Work out SD of responses to non-reinforced 
# trials (2 AB-, 1 C-, 1 D-, 1 E-, 1 F-) from phase 3 part 1. 
# Work out what 1 SD above the phase 3, part 1, E/F rate would be. 
# Compare that to first observed EF responses (phase 3, part 2, presentation 1). 

# Extract Phase 3, part 1, PP condition
p3pp <- dta[dta$phase == '3a' & dta$cond == 'PP',]
# Extract unreinforced trials thereof
p3ppu <- p3pp[p3pp$stim == 'AB' |
            p3pp$stim == 'C' |
            p3pp$stim == 'D' |
            p3pp$stim == 'E' |
            p3pp$stim == 'F', ]
# Calculate SD of these nonreinforced trials
p3ppu <- subset(p3ppu,select=c('subj','stim','resp'))
p3ppsd <- aggregate(p3ppu$resp,list(p3ppu$subj),sd)
colnames(p3ppsd) <- c('subj','stdev')
# Extract Phase 3, part 1, E/F 
p3eof <- p3pp[p3pp$stim == 'E' | p3pp$stim == 'F',]
p3eof <- subset(p3eof,select=c('subj','stim','resp'))
# Calculate mean response to E/F
p3eofav <- aggregate(p3eof$resp,list(p3eof$subj),mean)
colnames(p3eofav) <- c('subj','eof')
# Extract Phase 3, part 2, presentation 1
p3ef <- dta[dta$cond == 'PP' & dta$phase == '3b' & dta$trial == 1,]
# Compile table
tab <- cbind(p3ppsd,p3eofav$eof,p3ef$resp)
colnames(tab) <- c('subj','stdev','eof','ef')
tab$crit <- tab$eof + tab$stdev
tab$rule <- 'not'
tab$rule[tab$crit < tab$ef] <- 'rule'
pprule <- length(tab$rule[tab$rule=='rule'])
totpp <- length(tab$rule)
print(paste0('Number of PP rule participants: ',pprule,' of ',totpp))

# NP transfer condition - Rule-based prediction is EF < E/F. E/F is reinforced. 
# Work out SD of responses to reinforced trials (1 A+, 1 B+, 2 CD+, 1 E+, 1 F+). 
# Work out what 1 SD below phase 3 part 1, E/F rate would be. Compare that to first 
# observed EF responses (phase 3, part 2, presentation 1)

# Extract Phase 3, part 1, NP condition
p3np <- dta[dta$phase == '3a' & dta$cond == 'NP',]
# Extract reinforced trials thereof
p3npu <- p3np[p3np$stim == 'A' |
                p3np$stim == 'B' |
                p3np$stim == 'CD' |
                p3np$stim == 'E' |
                p3np$stim == 'F', ]
# Calculate SD of these reinforced trials
p3npu <- subset(p3npu,select=c('subj','stim','resp'))
p3npsd <- aggregate(p3npu$resp,list(p3npu$subj),sd)
colnames(p3npsd) <- c('subj','stdev')
# Extract Phase 3, part 1, E/F 
p3eof <- p3np[p3np$stim == 'E' | p3np$stim == 'F',]
p3eof <- subset(p3eof,select=c('subj','stim','resp'))
# Calculate mean response to E/F
p3eofav <- aggregate(p3eof$resp,list(p3eof$subj),mean)
colnames(p3eofav) <- c('subj','eof')
# Extract Phase 3, part 2, presentation 1
p3ef <- dta[dta$cond == 'NP' & dta$phase == '3b' & dta$trial == 1,]
# Compile table
tabnp <- cbind(p3npsd,p3eofav$eof,p3ef$resp)
colnames(tabnp) <- c('subj','stdev','eof','ef')
tabnp$crit <- tabnp$eof - tabnp$stdev
tabnp$rule <- 'not'
tabnp$rule[tabnp$crit > tabnp$ef] <- 'rule'
nprule <- length(tabnp$rule[tabnp$rule=='rule'])
totnp <- length(tabnp$rule)
print(paste0('Number of NP rule participants: ',nprule,' of ',totnp))
print('Chi-square contingency test')
ctab <- rbind(c(0,24),c(26,22)) # Hand coded for speed.
colnames(ctab) <- c('rule','not')
rownames(ctab) <- c('rats','humans')
print(ctab)
print(chisq.test(ctab,correct=FALSE))


