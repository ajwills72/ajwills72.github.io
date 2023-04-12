# DAU: EXE1
# Author: Andy Wills
# Date (Version 1): 2014-03-25
# Date (Version 2): 2014-10-07
cde <- read.table("exe1code.txt", header = TRUE, sep = "\t")
dta <- read.table("exe1data.txt", header = TRUE, sep = "\t")
# The raw data file reuses subject numbers across different conditions.
# This is potentially confusing in some analyses so is fixed here.
dta$subj[dta$cond == 1024] <- dta$subj[dta$cond == 1024] + 1000 
dta$subj[dta$cond == 2048] <- dta$subj[dta$cond == 2048] + 2000 
dta$subj[dta$cond == 3072] <- dta$subj[dta$cond == 3072] + 3000 
dta$subj[dta$cond == 7500] <- dta$subj[dta$cond == 7500] + 7000 

# Model-based analysis
bigm <- array(0, dim=c(145,12))
colnames(bigm) <- c("cond","subj","hull","sail","os","ident","top1","left2","right3","model","consist","rt")
o <- 0
for (j in 1:145) {
	mdl <-c(0,0,0,0,0,0,0)
	tio <-0
	for (i in 1:48) { 
		if (cde[dta[i+o,'triad'],'hull'] == dta[i+o,'resp']) mdl[1] = mdl[1] + 1
		if (cde[dta[i+o,'triad'],'sail'] == dta[i+o,'resp']) mdl[2] = mdl[2] + 1
		if (cde[dta[i+o,'triad'],'os'] == dta[i+o,'resp']) mdl[3] = mdl[3] + 1
		if (cde[dta[i+o,'triad'],'ident'] == dta[i+o,'resp']) mdl[4] = mdl[4] + 1
		if (1 == dta[i+o,'resp']) mdl[5] = mdl[5] + 1
		if (2 == dta[i+o,'resp']) mdl[6] = mdl[6] + 1
		if (3 == dta[i+o,'resp']) mdl[7] = mdl[7] + 1
		if (0 == dta[i+o,'resp']) tio = tio + 1
	}
	mdl = mdl / (48-tio)
	bigm[j,'cond'] = dta[o+1,'cond']
	bigm[j,'subj'] = dta[o+2,'subj']
	bigm[j,3:9] = mdl
	bigm[j,'model'] = which.max(mdl)
	bigm[j,'consist'] = max(mdl)
	bigm[j,'rt'] = sum(dta[(1+o):(48+o),'rt']) / (48-tio)
	o = o + 48
}

# Traditional descriptives (For model consistency, see below)
library(psych)
bigmf <- as.data.frame(bigm)
describeBy(bigmf,bigmf$cond) 
#Model-based descriptives
mbt <- table(bigm[,'cond'],bigm[,'model'])
ud <- mbt[,1] + mbt[,2]
os <- mbt[,3]
id <- mbt[,4]
pos <- mbt[,5] + mbt[,6] + mbt[,7]
mbts <- cbind(ud,os,id)
mbts[1,] <- mbts[1,]/sum(mbts[1,])
mbts[2,] <- mbts[2,]/sum(mbts[2,])
mbts[3,] <- mbts[3,]/sum(mbts[3,])
mbts[4,] <- mbts[4,]/sum(mbts[4,])
mbts[5,] <- mbts[5,]/sum(mbts[5,])
# Traditional analysis Part 1
# 1024ms vs 3072ms t-test
tdta <- subset(bigmf, cond == 1024 | cond == 3072, select=c('cond','os','ident'))
t.test(os ~ cond, data = tdta,var.equal=TRUE)
# 1024ms vs 7500ms t-test
tdta <- subset(bigmf, cond == 1024 | cond == 7500, select=c('cond','os','ident'))
t.test(os ~ cond, data = tdta,var.equal=TRUE)
# 1024ms vs 2048ms t-test
tdta <- subset(bigmf, cond == 1024 | cond == 2048, select=c('cond','os','ident'))
t.test(os ~ cond, data = tdta,var.equal=TRUE)
# 3072 ms vs 7500 ms t-test
tdta <- subset(bigmf, cond == 3072 | cond == 7500, select=c('cond','os','ident'))
t.test(os ~ cond, data = tdta,var.equal=TRUE)
# Model-based analysis Part 1
mbts <- cbind(ud,os,id)
# 1024ms vs 3072ms UD vs other.
c <- rbind(c(mbts['1024','ud'],mbts['1024','os']+mbts['1024','id']),c(mbts['3072','ud'],mbts['3072','os']+mbts['3072','id']))
chisq.test(c,correct=FALSE)
# 1024ms vs 7500ms UD vs other.
c <- rbind(c(mbts['1024','ud'],mbts['1024','os']+mbts['1024','id']),c(mbts['7500','ud'],mbts['7500','os']+mbts['7500','id']))
chisq.test(c,correct=FALSE)
# 1024ms vs 3072ms OS vs other.
c <- rbind(c(mbts['1024','os'],mbts['1024','ud']+mbts['1024','id']),c(mbts['3072','os'],mbts['3072','ud']+mbts['3072','id']))
chisq.test(c,correct=FALSE)
# 1024ms vs 7500ms OS vs other.
c <- rbind(c(mbts['1024','os'],mbts['1024','ud']+mbts['1024','id']),c(mbts['7500','os'],mbts['7500','ud']+mbts['7500','id']))
chisq.test(c,correct=FALSE)
# 1024ms vs 2048ms OS vs other.
c <- rbind(c(mbts['1024','os'],mbts['1024','ud']+mbts['1024','id']),c(mbts['2048','os'],mbts['2048','ud']+mbts['2048','id']))
chisq.test(c,correct=FALSE)
# 3072ms vs 2048ms OS vs other.
c <- rbind(c(mbts['3072','os'],mbts['3072','ud']+mbts['3072','id']),c(mbts['2048','os'],mbts['2048','ud']+mbts['2048','id']))
chisq.test(c,correct=FALSE)
# Traditional analysis Part 2
# 1024ms vs 640ms UD vs other.
c <- rbind(c(mbts['1024','ud'],mbts['1024','os']+mbts['1024','id']),c(mbts['640','ud'],mbts['640','os']+mbts['640','id']))
chisq.test(c,correct=FALSE)
# 1024ms vs 640ms OS vs other.
c <- rbind(c(mbts['1024','os'],mbts['1024','ud']+mbts['1024','id']),c(mbts['640','os'],mbts['640','ud']+mbts['640','id']))
chisq.test(c,correct=FALSE)
# 1024ms vs 640ms t-tests
tdta <- subset(bigmf, cond == 1024 | cond == 640, select=c('cond','os','ident'))
t.test(os ~ cond, data = tdta,var.equal=TRUE)
# Model-based analysis Part 2
# 1024ms vs 640ms UD vs other.
c <- rbind(c(mbts['1024','ud'],mbts['1024','os']+mbts['1024','id']),c(mbts['640','ud'],mbts['640','os']+mbts['640','id']))
chisq.test(c,correct=FALSE)
# 1024ms vs 640ms OS vs other.
c <- rbind(c(mbts['1024','os'],mbts['1024','ud']+mbts['1024','id']),c(mbts['640','os'],mbts['640','ud']+mbts['640','id']))
chisq.test(c,correct=FALSE)

#### CONSISTENCY ANALYSES
# Look at consistency, removing the position bias people...
bigm <- bigm[bigm[,'model'] < 5,]
bigmf <- as.data.frame(bigm)
# ...and combining the two UD strategies
bigmf$model[bigmf$model == 1] <- 'ud'
bigmf$model[bigmf$model == 2] <- 'ud'
bigmf$model[bigmf$model == 3] <- 'os'
bigmf$model[bigmf$model == 4] <- 'id'
# Closest competitor analysis
# Create a ud column, selecting the better of the two UD fits
bigmf$ud <- pmax(bigmf$hull,bigmf$sail)
bigmf$win.margin <- 0
for (i in 1:nrow(bigmf)) {
  tmp <- c(bigmf[i,'ud'],bigmf[i,'os'],bigmf[i,'ident'])
  tmp <- tmp[order(tmp)]
  bigmf$win.margin[i] <- tmp[3] - tmp[2]
}

# Quick descriptives (consistency)
aggregate(consist ~ model,data=bigmf,mean)
aggregate(consist ~ model,data=bigmf,length)

# Quick descriptives (win margin)
aggregate(win.margin ~ model,data=bigmf,mean)
aggregate(win.margin ~ model,data=bigmf,length)

# ANOVAs (consistency)
library(ez)

# Any analysis of consistency by response set AND condition is complicated by the fact that there are no ID responders
# at 1024 ms, and only 1 ID responder at 640 ms. 
# What are the options here? One could exclude ID from the analysis, but that doesn't sound quite right because
# ID is not that rare overall, just at high time pressure. One could exclude 640 and 1024 ms, but that loses part
# of the picture. So perhaps do 2 ANOVA - one from 2048ms up, the other for 640/1024, the latter excluding ID.


bigmf.slow <- bigmf[bigmf$cond > 2000,]

bigmf.slow$cond <- as.character(bigmf.slow$cond)
consist.desc <- ezStats( data = bigmf.slow
                         , dv = consist
                         , wid = subj
                         , between = list(cond,model)
                         , type = 3)
consist.desc

consist.out <- ezANOVA( data = bigmf.slow
                         , dv = consist
                         , wid = subj
                         , between = list(cond,model)
                         , type = 3)
consist.out

# So, over 2048 - 7500 ms, there's an effect of consistency, and an effect of model, but no interaction.
# Both effects have more than two levels, so post-hocs...

# Model
a1 <- aov(consist ~ model, data = bigmf.slow)
summary(a1)
TukeyHSD(a1)
# All differences significant.

# Condition
a1 <- aov(consist ~ cond, data = bigmf.slow)
summary(a1)
TukeyHSD(a1)
# Biggest difference significant.

bigmf.fast <- bigmf[bigmf$cond < 2000,]
bigmf.fast <- bigmf.fast[bigmf.fast$model != 'id',]


bigmf.fast$cond <- as.character(bigmf.fast$cond)
consist.desc <- ezStats( data = bigmf.fast
                         , dv = consist
                         , wid = subj
                         , between = list(cond,model)
                         , type = 3)
consist.desc

consist.out <- ezANOVA( data = bigmf.fast
                        , dv = consist
                        , wid = subj
                        , between = list(cond,model)
                        , type = 3)
consist.out

# So, only model significant over 640ms-1024ms, and only two levels, so no need for post-hocs.

# ANOVAs (win margin)
bigmf.slow$cond <- as.character(bigmf.slow$cond)
consist.desc <- ezStats( data = bigmf.slow
                         , dv = win.margin
                         , wid = subj
                         , between = list(cond,model)
                         , type = 3)
consist.desc

consist.out <- ezANOVA( data = bigmf.slow
                        , dv = win.margin
                        , wid = subj
                        , between = list(cond,model)
                        , type = 3)
consist.out

consist.out <- ezANOVA( data = bigmf.slow
                        , dv = win.margin
                        , wid = subj
                        , between = list(model)
                        , type = 3)
consist.out



# So, over 2048 - 7500 ms, there's an effect of consistency, and an effect of model, but no interaction.
# Both effects have more than two levels, so post-hocs...

# Model
a1 <- aov(win.margin ~ model, data = bigmf.slow)
summary(a1)
TukeyHSD(a1)
# All differences significant (although ud-os, p = .0503)

# Condition
a1 <- aov(win.margin ~ cond, data = bigmf.slow)
summary(a1)
TukeyHSD(a1)
# Biggest difference significant.

