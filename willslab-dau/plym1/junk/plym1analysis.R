print("DAU: PLYM1")
print("Author: Andy Wills")
print("Date: 2014-05-30")
library(psych)
cde <- read.table("plym1code.txt", header = TRUE, sep = "\t")
bigdta <- read.table("plym1data.txt", header = TRUE, sep = "\t")
dta <- subset(bigdta, phase == 1)
ppts <- 80
trls <- 96
print("Preparing response set analysis...")
bigm <- array(0, dim=c(ppts,11))
colnames(bigm) <- c("cond","subj","bright","size","os","ident","left1","mid2","right3","model","consist")
o <- 0
for (j in 1:ppts) {
	mdl <-c(0,0,0,0,0,0,0)
	tio <-0
	for (i in 1:trls) { 
		if (cde[dta[i+o,'stim'],'bright'] == dta[i+o,'resp']) mdl[1] = mdl[1] + 1
		if (cde[dta[i+o,'stim'],'size'] == dta[i+o,'resp']) mdl[2] = mdl[2] + 1
		if (cde[dta[i+o,'stim'],'os'] == dta[i+o,'resp']) mdl[3] = mdl[3] + 1
		if (cde[dta[i+o,'stim'],'ident'] == dta[i+o,'resp']) mdl[4] = mdl[4] + 1	
		if (1 == dta[i+o,'resp']) mdl[5] = mdl[5] + 1
		if (2 == dta[i+o,'resp']) mdl[6] = mdl[6] + 1
		if (3 == dta[i+o,'resp']) mdl[7] = mdl[7] + 1
		if (0 == dta[i+o,'resp']) tio = tio + 1
	}
	mdl = mdl / (trls-tio)
	bigm[j,'cond'] = dta[o+1,'cond']
	bigm[j,'subj'] = dta[o+1,'subj']
	bigm[j,3:9] = mdl
	bigm[j,'model'] = which.max(mdl)
	bigm[j,'consist'] = max(mdl)
	o = o + trls 
}
print("Traditional analysis")
bigmf <- as.data.frame(bigm)
tdta <- subset(bigmf, cond == 1 | cond == 2, select=c('cond','os','ident'))
print(t.test(os ~ cond, data = tdta,var.equal=TRUE))
print("Response-set descriptives - proportions")
mbt <- table(bigm[,'cond'],bigm[,'model'])
ud <- mbt[,1] + mbt[,2]
os <- mbt[,3]
id <- mbt[,4]
pos <- mbt[,5] # Note, this line only works because there are no left or right key position bias winners.
mbts <- cbind(ud,os,id)
mbts[1,] <- mbts[1,]/sum(mbts[1,])
mbts[2,] <- mbts[2,]/sum(mbts[2,])
print(mbts)
print("Response-set descriptives - consistency")
bigmex <- bigm[bigm[,'model'] < 5,]
bigmfex <- as.data.frame(bigmex)
print(describeBy(bigmfex$consist,bigmfex$cond))
print("Response-set analysis")
mbts <- cbind(ud,os,id)
print("UD vs other")
c <- rbind(c(mbts[1,'ud'],mbts[1,'os']+mbts[1,'id']),c(mbts[2,'ud'],mbts[2,'os']+mbts[2,'id']))
print(chisq.test(c,correct=FALSE)) # Yates correction not used as assumptions of correction not met.
print("OS vs other")
c <- rbind(c(mbts[1,'os'],mbts[1,'ud']+mbts[1,'id']),c(mbts[2,'os'],mbts[2,'ud']+mbts[2,'id']))
print(chisq.test(c,simulate.p.value=TRUE)) # Monte Carlo used due to low expected values.
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
bigmf[,'exp'] <- 'PLYM1'
save(bigmf,file='plym1sum.RData')

