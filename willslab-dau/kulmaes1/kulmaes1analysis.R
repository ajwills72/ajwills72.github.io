print('DAU: KULMAES1')
print('Date: 2015-05-13')
print('Author: Andy J. Wills')
print('---------------------')
print('Note: Analysis in Phases 1 and 2 uses')
print('linear-contrast within-subjects ANOVA.')
print('This is not supported by the "ez" package.')
print('The workaround in this script is to export')
print('data files to SPSS for analysis.')
# Note: It would be better to update the 'ez' package to do this
# or use GLM within R to build the appropriate model.
print('---------------------')
print('Loading data...')
dta <- read.table("kulmaes1data.txt",stringsAsFactors = FALSE, sep = "\t", header=TRUE)
######
# Extract phase 1
p1 <- dta[dta$phase ==1,]
# Extract pre-stimulus responding
p1pre <- p1[p1$period == 'pre',]
p1 <- p1[p1$period == 'stim',]
# Average acros trial types
p1$type <- NULL
p1$type[p1$stim == 'A+' | p1$stim == 'B+'] <- 'A+/B+'
p1$type[p1$stim == 'C-' | p1$stim == 'D-'] <- 'C-/D-'
p1$type[p1$stim == 'AB-'] <- 'AB-'
p1$type[p1$stim == 'CD+'] <- 'CD+'
p1ag <- aggregate(p1$resp,list(p1$group,p1$subj,p1$type,p1$sess),mean)
colnames(p1ag) <-c('group','subj','type','sess','resp')
# Aggregate pre-CS responding
p1pre.av <- aggregate(p1pre$resp,list(p1pre$sess),mean)
p1pre.av <- rbind(c(1,0),c(2,0),c(3,0),c(4,0),c(5,0),c(6,0),c(7,0),p1pre.av)

print('Figure 1 means')
p1av <- aggregate(p1$resp,list(p1$type,p1$sess),mean)
colnames(p1av) <-c('type','sess','resp')
p1av.wide <- reshape(p1av,direction="wide",timevar="type",idvar="sess")
p1av.wide <- cbind(p1av.wide, p1pre.av$x)
colnames(p1av.wide) <- c('sess','A+/B+','AB-','C-/D-','CD+','preCS')
print(p1av.wide)

print('Plot Figure 1 (without error bars)')
# Plot Figure 1
plot(p1av.wide[,'A+/B+'],type='o',pch=16,
     axes = FALSE,
     xlab = 'Days',
     ylim = c(0,18), ylab = 'Mean responses',
)
box(bty='l')
axis(1,at=seq(1,27,2))
axis(2,at=seq(0,18,2))
lines(p1av.wide[,'AB-'],type='o',pch=1)
lines(p1av.wide[,'C-/D-'],type='o',pch=2)
lines(p1av.wide[,'CD+'],type='o',pch=17)
lines(p1av.wide[,'preCS'],type='o',pch=4)
legend('topleft',c('A+/B+','AB-','C-/D-','CD+','preCS'), pch = c(16,1,2,17,4),inset=.05)

print('Save Phase 1 reinforced vs. nonreinforced data file for analysis by SPSS')
# Now average across reinforcement type 
p1ag$type2 <- NULL
p1ag$type2[p1ag$type == 'A+/B+' ] <- 'R'
p1ag$type2[p1ag$type == 'C-/D-' ] <- 'U'
p1ag$type2[p1ag$type == 'AB-' ] <- 'U'
p1ag$type2[p1ag$type == 'CD+' ] <- 'R'
p1ag2 <- aggregate(p1ag$resp,list(p1ag$group,p1ag$subj,p1ag$type2,p1ag$sess),mean)
colnames(p1ag2) <-c('group','subj','type2','sess','resp')
# SPSS syntax analysis has Sess 1 as Session 15. Convert...
p1ag2$sess <- p1ag2$sess + 14
# Convert to wide format 
p1ag2$tv <- paste0(p1ag2$type2,'_',p1ag2$sess)
spss.wide <- subset(p1ag2,select=c('group','subj','resp','tv'))
spss.wide <- reshape(spss.wide,direction="wide",timevar="tv",idvar=c("subj","group"))
# Set column headings to match SPSS syntax file
vnam <- c('group','subj')
for(i in 15:41) {
  vnam <- c(vnam,paste0('R_',i),paste0('U_',i))
}
colnames(spss.wide) <- vnam
# Round output to match E.Maes SAV file
for(i in 3:56) {
  spss.wide[,i] <- round(spss.wide[,i],9)
}
# Export as text file
write.table(spss.wide,file="kulmaes1phase1.txt",sep="\t",row.names=FALSE)

print('Save Phase 1 PP vs NP data file for analysis by SPSS')
# Recode trial types
p1ag$type3 <- NULL
p1ag$type3[p1ag$type == 'A+/B+' ] <- 'NP+'
p1ag$type3[p1ag$type == 'C-/D-' ] <- 'PP-'
p1ag$type3[p1ag$type == 'AB-' ] <- 'NP-'
p1ag$type3[p1ag$type == 'CD+' ] <- 'PP+'
p1ag3 <- aggregate(p1ag$resp,list(p1ag$group,p1ag$subj,p1ag$type3,p1ag$sess),mean)
colnames(p1ag3) <-c('group','subj','type3','sess','resp')
# Take differences
npdiff <- p1ag3$resp[p1ag3$type3 == 'NP+'] - p1ag3$resp[p1ag3$type3 == 'NP-']
ppdiff <- p1ag3$resp[p1ag3$type3 == 'PP+'] - p1ag3$resp[p1ag3$type3 == 'PP-']
subjs <- rep(levels(factor(p1ag3$subj)),times=27)
sessions <- rep(levels(factor(p1ag3$sess)),each=24)
p1ag4 <- data.frame(subjs,sessions,npdiff,ppdiff)
colnames(p1ag4) <-c('subj','sess','npdiff','ppdiff')
# Convert to wide format 
spss2.wide <- reshape(p1ag4,direction="wide",timevar="sess",idvar="subj")
# Set column headings to match SPSS syntax file
vnam <- c('subj')
for(i in 15:41) {
  vnam <- c(vnam,paste0('mdiff_NP_',i),paste0('mdiff_PP_',i))
}
colnames(spss2.wide) <- vnam
# Round output to match E.Maes SAV file
for(i in 2:55) {
  spss2.wide[,i] <- round(spss2.wide[,i],9)
}
# Export as text file
write.table(spss2.wide,file="kulmaes1phase1ppnp.txt",sep="\t",row.names=FALSE)

# Housekeeping
rm(p1,p1ag,p1ag2,spss.wide,i,vnam,p1av,p1av.wide)
rm(p1ag3,p1ag4,p1pre,p1pre.av,spss2.wide)
rm(npdiff,ppdiff,sessions,subjs)

####  PHASE 2 ##### 

print('Phase 2, Day 28 analysis')
# Calculate preCS rate

print('preCS responding')
# This is a bit fiddly, as the data file represents E and F at
# a trial level but the other cues at a session level...

# Extract E,F trial level data first, and aggregate across trials
precs.ef <- dta[dta$sess == 28 & (dta$stim == 'E' | dta$stim == 'F') & dta$period == 'pre',]
precs.ef <- aggregate(precs.ef$resp,list(precs.ef$subj,precs.ef$stim),mean)
colnames(precs.ef) <- c('subj','stim','preCS')
# Now extract other trial ypes
precs.ot <- dta[dta$sess == 28 & dta$stim != 'E' & dta$stim != 'F' & dta$period == 'pre',]
precs.ot <- data.frame(precs.ot$subj,precs.ot$stim,precs.ot$resp)
colnames(precs.ot) <- c('subj','stim','preCS')
# Combine these two sets
precs <- rbind(precs.ef,precs.ot)
# Take mean
print(mean(precs$preCS))

# Now the analysis of elevation scores
# Extract E and F trials from phase 2
p2 <- dta[dta$phase == 2 & (dta$stim == 'E' | dta$stim == 'F'),]
# Extract Day 28
p2day28 <- p2[p2$sess==28,]
# Calculate elevation score
p2day28el <- subset(p2day28,select=c('group','subj','subsess','period','stim','resp'))
p2day28el <- reshape(p2day28el,direction='wide',timevar='period',idvar=c('group','subj','subsess','stim'))
p2day28el$elev <- p2day28el$resp.stim - p2day28el$resp.pre

print('Figure 2, lower panel, means')
av <- aggregate(p2day28el$elev,list(p2day28el$group,p2day28el$subsess),mean)
colnames(av) <- c('group','trial','elev')
avfig <- reshape(av,direction='wide',timevar='group',idvar='trial')
rm(av)
colnames(avfig) <- c('trial','NP','PP')
print(avfig)

print('Plot Figure 2, lower panel (without error bars)')
plot(avfig[,2],type='o',pch=16,
     axes = FALSE,
     xlab = 'Trial',
     ylim = c(0,12), ylab = 'Elevation score',
)
box(bty='l')
axis(1,at=seq(1,8,1))
axis(2,at=seq(0,12,2))
lines(avfig[,3],type='o',pch=1)
legend('topleft',c('NP transfer','PP transfer'), pch = c(16,1),inset=.05)
rm(avfig)

print('Save phase 2, day 28, data file for SPSS analysis')
# Aggregate across stim type
ag <- aggregate(p2day28el$elev,list(p2day28el$group, p2day28el$subj, p2day28el$subsess),mean)
colnames(ag) <- c('group','subj','subsess','elev')
# Convert to wide for SPSS
ag.wide <- reshape(ag,direction='wide',timevar='subsess',idvar=c('group','subj'))
rm(ag)
# Set column headings to match SPSS syntax file
colnames(ag.wide) <- c('group','subj','ESA_B_1','ESA_B_2','ESA_B_3','ESA_B_4'
          ,'ESA_B_5','ESA_B_6','ESA_B_7','ESA_B_8')
# Export as text file
write.table(ag.wide,file="kulmaes1phase2.txt",sep="\t",row.names=FALSE)
rm(ag.wide)
rm(p2day28el)
print('Figure 2, upper panel, means')
# Aggregate Day 28 (this day, E & F data is at trial level)
p2day28ag <- aggregate(p2day28$resp,list(p2day28$group,p2day28$subj,p2day28$sess,
                                         p2day28$period,p2day28$stim),mean)
colnames(p2day28ag) <- c('group','subj','sess','period','stim','resp')
rm(p2day28)
# Extract Day 29+
p2days <- p2[p2$sess>28,]
p2days <- subset(p2days,select=c('group','subj','sess','period','stim','resp'))
# Combined with aggregated Day 28
p2days <- rbind(p2day28ag,p2days)
rm(p2day28ag)
# Calculate elevation score
p2days <- reshape(p2days,direction='wide',timevar='period',idvar=c('group','subj','sess','stim'))
p2days$elev <- p2days$resp.stim - p2days$resp.pre
# Calculate means
av <- aggregate(p2days$elev,list(p2days$group,p2days$sess),mean)
colnames(av) <- c('group','sess','elev')
avfig <- reshape(av,direction='wide',timevar='group',idvar='sess')
colnames(avfig) <- c('sess','NP','PP')
print(avfig)
print('Plot Figure 2, upper panel (without error bars)')
plot(cbind(28:36,avfig[,2]),type='o',pch=16,
     axes = FALSE,
     xlab = 'Day',
     ylim = c(0,14), ylab = 'Elevation score',
)
box(bty='l')
axis(1,at=28:36)
axis(2,at=seq(0,14,2))
lines(cbind(28:36,avfig[,3]),type='o',pch=1)
legend('right',c('NP transfer','PP transfer'), pch = c(16,1),inset=.05)
rm(p2,p2days,av,avfig)
rm(precs,precs.ef,precs.ot)

#### PHASE 3 #####

print('Phase3, preCS responding')
precs.l <- dta[dta$phase == 3 & dta$period == 'pre',]
# Aggregate across trials
precs <- aggregate(precs.l$resp,list(precs.l$subj,precs.l$stim),mean)
colnames(precs) <- c('subj','stim','preCS')
# Aggregate across stimuli
precs.ag <- aggregate(precs$preCS,list(precs$subj),mean)
colnames(precs.ag) <- c('subj','preCS')
print(mean(precs.ag$preCS))
# Housekeeping
rm(precs,precs.ag,precs.l)

# Extract first presentation of EF compound
p3 <- dta[dta$phase == 3 & dta$part == 2 & dta$subsess == 1,]
p3 <- subset(p3,select=c('group','subj','period','resp'))
p3 <- reshape(p3,direction='wide',timevar='period',idvar=c('group','subj'))

# Calculate elevation score
p3$elev <- p3$resp.stim - p3$resp.pre
p3 <- subset(p3,select=c('group','subj','elev'))
print('Figure 3, means and t-test')
print(t.test(elev ~ group,data=p3))

print('---------------------')
print('Phase 3 individual level')
# PP transfer condition - Rule-based prediction is EF > E/F. 
# E/F is nonreinforced. Work out SD of responses to non-reinforced 
# trials (2 AB-, 1 C-, 1 D-, 1 E-, 1 F-) from phase 3 part 1. 
# Work out what 1 SD above the phase 3, part 1, E/F rate would be. 
# Compare that to first observed EF responses (phase 3, part 2, presentation 1). 
# Extract Phase 3, part 1, PP condition
p3pp <- dta[dta$phase == 3 & dta$part == 1 & dta$group == 'PP' & dta$period == 'stim',]
# Extract unreinforced trials thereof
p3ppu <- p3pp[p3pp$stim == 'AB-' |
                p3pp$stim == 'C-' |
                p3pp$stim == 'D-' |
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
p3ef <- dta[dta$group == 'PP' & dta$phase == 3 & dta$part == 2 & dta$subsess == 1 & dta$period == 'stim',]
# Compile table
tab <- cbind(p3ppsd,p3eofav$eof,p3ef$resp)
colnames(tab) <- c('subj','stdev','eof','ef')
tab$crit <- tab$eof + tab$stdev
tab$rule <- 'not'
tab$rule[tab$crit < tab$ef] <- 'rule'
pprule <- length(tab$rule[tab$rule=='rule'])
totpp <- length(tab$rule)
print(paste0('Number of NP rule participants: ',pprule,' of ',totpp))

# NP transfer condition - Rule-based prediction is EF < E/F. E/F is reinforced. 
# Work out SD of responses to reinforced trials (1 A+, 1 B+, 2 CD+, 1 E+, 1 F+). 
# Work out what 1 SD below phase 3 part 1, E/F rate would be. Compare that to first 
# observed EF responses (phase 3, part 2, presentation 1)

# Extract Phase 3, part 1, NP condition
p3np <- dta[dta$phase == 3 & dta$part == 1 & dta$group == 'NP' & dta$period == 'stim',]
# Extract reinforced trials thereof
p3npu <- p3np[p3np$stim == 'A+' |
                p3np$stim == 'B+' |
                p3np$stim == 'CD+' |
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
p3ef <- dta[dta$group == 'NP' & dta$phase == 3 & dta$part == 2 & dta$subsess == 1 & dta$period == 'stim',]
# Compile table
tabnp <- cbind(p3npsd,p3eofav$eof,p3ef$resp)
colnames(tabnp) <- c('subj','stdev','eof','ef')
tabnp$crit <- tabnp$eof - tabnp$stdev
tabnp$rule <- 'not'
tabnp$rule[tabnp$crit > tabnp$ef] <- 'rule'
nprule <- length(tabnp$rule[tabnp$rule=='rule'])
totnp <- length(tabnp$rule)
print(paste0('Number of NP rule participants: ',nprule,' of ',totnp))
