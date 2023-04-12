print("DAU: PLYM2")
print("Author: Andy Wills")
print("Date: 2014-05-30")
library(psych)
cde <- read.table("plym2code.txt", header = TRUE, sep = "\t")
bigdta <- read.table("plym2data.txt", header = TRUE, sep = "\t")
dta <- subset(bigdta, phase == 1)
ppts <- 107
trls <- 96
print("Preparing response set analysis...")
bigm <- array(0, dim=c(ppts,12))
colnames(bigm) <- c("cond","subj","dot","leng","os","ident","left1","mid2","right3","nbr","model","consist")
o <- 0
for (j in 1:ppts) {
	mdl <-c(0,0,0,0,0,0,0,0)
	tio <-0
	for (i in 1:trls) { 
		if (cde[dta[i+o,'stim'],'dot'] == dta[i+o,'resp']) mdl[1] = mdl[1] + 1
		if (cde[dta[i+o,'stim'],'leng'] == dta[i+o,'resp']) mdl[2] = mdl[2] + 1
		if (cde[dta[i+o,'stim'],'os'] == dta[i+o,'resp']) mdl[3] = mdl[3] + 1
		if (cde[dta[i+o,'stim'],'ident'] == dta[i+o,'resp']) mdl[4] = mdl[4] + 1	
		if (1 == dta[i+o,'resp']) mdl[5] = mdl[5] + 1
		if (2 == dta[i+o,'resp']) mdl[6] = mdl[6] + 1
		if (3 == dta[i+o,'resp']) mdl[7] = mdl[7] + 1
		if (cde[dta[i+o,'stim'],'nbr'] == dta[i+o,'resp']) mdl[8] = mdl[8] + 1	
		if (0 == dta[i+o,'resp']) tio = tio + 1
	}
	mdl = mdl / (trls-tio)
	bigm[j,'cond'] = dta[o+1,'cond']
	bigm[j,'subj'] = dta[o+1,'subj']
	bigm[j,3:10] = mdl
	bigm[j,'model'] = which.max(mdl)
	bigm[j,'consist'] = max(mdl)
	o = o + trls 
}
print("Traditional analysis")
bigmf <- as.data.frame(bigm)
tdta <- subset(bigmf, cond == 1 | cond == 2, select=c('cond','os','ident'))
print("BC proportion by condition")
print(t.test(os ~ cond, data = tdta,var.equal=TRUE))
print("AB proportion by condition (paper reports means by not t-test")
print(t.test(ident ~ cond, data = tdta,var.equal=TRUE))


print("Response-set descriptives - proportions")
mbt <- table(bigm[,'cond'],bigm[,'model'])
ud <- mbt[,1] + mbt[,2]
os <- mbt[,3]
id <- mbt[,4]
mbts <- cbind(ud,os,id)
mbts[1,] <- mbts[1,]/sum(mbts[1,])
mbts[2,] <- mbts[2,]/sum(mbts[2,])
print(mbts)

print("Response-set analysis")
mbts <- cbind(ud,os,id)
print("OS vs other")
c <- rbind(c(mbts[1,'os'],mbts[1,'ud']+mbts[1,'id']),c(mbts[2,'os'],mbts[2,'ud']+mbts[2,'id']))
print(chisq.test(c,correct=FALSE)) # Monte Carlo used due to low expected values.

print("UD vs other")
c <- rbind(c(mbts[1,'ud'],mbts[1,'os']+mbts[1,'id']),c(mbts[2,'ud'],mbts[2,'os']+mbts[2,'id']))
print(chisq.test(c,correct=FALSE)) # Yates correction not used as assumptions of correction not met.

print("Save out model summary table, including impulsivity scores")
bdt <- subset(bigdta, phase == 2)
key <- read.table("barrattkey.txt", header = TRUE, sep = "\t")
sc <- array(0,dim=c(ppts,5))
colnames(sc) <- c("exp","att","mot","non","bis")
for (cp in 1:ppts) {
  for (i in 1:30) {
    for (j in 1:3) {
      if ( key[i,(j+1)] == 1 ) { 
        sc[cp,(j+1)] <- sc[cp,(j+1)] + bdt[i+(cp-1)*30,'resp']  
      }
      if ( key[i,(j+1)] == -1 ) { 
        sc[cp,(j+1)] <- sc[cp,(j+1)] + 5 - bdt[i+(cp-1)*30,'resp']  
      }
    }
  }
  sc[cp,'bis'] <- sum(sc[cp,2:4])
}
bigm <- cbind(bigm,sc)
bigmf <- as.data.frame(bigm)
bigmf[,'exp'] <- 'PLYM2'
save(bigmf,file='plym2sum.RData')

####

print("SUPPLEMENTARY ANALYSES (RESPONSE SET)")
# Removing the position bias people...
bigm <- bigm[bigm[,'model'] < 5,]
bigmf <- as.data.frame(bigm)
# ...and combining the two UD strategies
bigmf$model[bigmf$model == 1] <- 'ud'
bigmf$model[bigmf$model == 2] <- 'ud'
bigmf$model[bigmf$model == 3] <- 'os'
bigmf$model[bigmf$model == 4] <- 'id'
# Create a ud column, selecting the better of the two UD fits
bigmf$ud <- pmax(bigmf$dot,bigmf$leng)

# Closest competitor analysis
bigmf$win.margin <- 0
for (i in 1:nrow(bigmf)) {
  tmp <- c(bigmf[i,'ud'],bigmf[i,'os'],bigmf[i,'ident'])
  tmp <- tmp[order(tmp)]
  bigmf$win.margin[i] <- tmp[3] - tmp[2]
}

#Relabel conditions for ease
bigmf$cond[bigmf$cond==1] <- '2000 ms'
bigmf$cond[bigmf$cond==2] <- '5000 ms'

print('Table S3')

print('N (all cells)')
print(aggregate(consist ~ model + cond,data=bigmf,length))

print('Consistency (all cells)')
print(aggregate(consist ~ model + cond,data=bigmf,mean))

print('Margin (all cells)')
print(aggregate(win.margin ~ model + cond,data=bigmf,mean))

print('Consistency (collapse condition)')
print(aggregate(consist ~ model,data=bigmf,mean))

print('Margin (collapse condition)')
print(aggregate(win.margin ~ model,data=bigmf,mean))

print('Consistency (collapse models)')
print(aggregate(consist ~ cond,data=bigmf,mean))

print('Margin (collapse models)')
print(aggregate(win.margin ~ cond,data=bigmf,mean))

print('Response model type effect on consistency')
a1 <- aov(consist ~ model, data = bigmf)
print(summary(a1))

print('Response model type effect on margin')
a1 <- aov(win.margin ~ model, data = bigmf)
print(summary(a1))
print(TukeyHSD(a1))

print('Stimulus presentation time effect on consistency')
print(t.test(consist ~ cond, data = bigmf,var.equal=TRUE))

print('Stimulus presentation time effect on margin')
print(t.test(win.margin ~ cond, data = bigmf,var.equal=TRUE))

print('Remove ID for interaction test (sample too small)')
bigmfnoid <- bigmf[bigmf$model != 'id',]

library(ez)

print("Interaction analysis (consistency) ")
eza <- ezANOVA( data = bigmfnoid
                , dv = consist
                , wid = subj
                , between = c('cond','model')
                , type = 3)
print(eza)

print("Interaction analysis (margin) ")
eza <- ezANOVA( data = bigmfnoid
                , dv = win.margin
                , wid = subj
                , between = c('cond','model')
                , type = 3)
print(eza)

print('***END***')


