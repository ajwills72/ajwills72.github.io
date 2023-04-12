print("PLYM6 - Logistic regression")
print("Author: Andy Wills")
print("Date: 2014-12-05")
print("NB: Use of this method is not appropriate")
print("as the stimulus dimensions are correlated")
print("I ran it because I was curious.")

# Define custom function
featcon <- function(dataset) {
  require(logistf)
  firth.model <- logistf(resp ~ ca + nca1 + nca2 + nca3 + ca,data=dataset)
  resul <- c(firth.model$coeff,firth.model$prob)
  names(resul) <- c('intercept.coef','ca.coef','nca1.coef','nca2.coef','nca3.coef','intercept.p','ca.p','nca1.p','nca2.p','nca3.p')
  return(resul)  
}

# Load data file and decode file
code <- read.table("plym6code.txt", header = TRUE, sep = "\t",stringsAsFactors = FALSE,row.names=NULL)
dta <- read.table("plym6data.txt", header = TRUE, sep = "\t")

# Add stimulus dimensions to data file.
decode <- code[dta$stim,4:7]
dta <- cbind(dta,decode)
tstdta <- dta[dta$phase==2,]
rm(dta,decode,code)

# Name conditions for readability
tstdta$cond[tstdta$cond == 1] <- 'intentional'
tstdta$cond[tstdta$cond == 2] <- 'incidental'

# Run through subjects
subjs <- as.numeric(levels(as.factor(tstdta$subj)))
results <- array(0,dim=c(length(subjs),18))
results <- data.frame(results)
colnames(results) <- c('subj','cond','ndim','intercept.coef','ca.coef','nca1.coef','nca2.coef','nca3.coef',
                       'intercept.p','ca.p','nca1.p','nca2.p','nca3.p','coef4','coef3','coef2','coef1','strongca')
i <- 0
for(subindex in subjs) {
  i <- i + 1
  onesub <- tstdta[tstdta$subj == subindex,]
  results[i,1] <- subindex
  results[i,4:13] <- featcon(onesub)
  results[i,3] <- sum(results[i,10:13] < .05) # This counts number of features where p < .05
  tmp <- results[i,5:8]
  results[i,14:17] <- tmp[order(abs(tmp))]
  if (results[i,5] == results[i,17]) results[i,18] <- 1 # Is strongest dimension criterial?
  results[i,2] <- onesub$cond[1] 
}

# Remove those with no dimensions controlling behavior
results <- results[results$ndim != 0,]

print('Dimensions DV descriptives')
tbl <- table(results$ndim,results$cond)
props <- tbl
props[,1] <- props[,1]/sum(props[,1])
props[,2] <- props[,2]/sum(props[,2])
print(props)

print('Criterial DV descriptives')
crit <- table(results$strongca,results$cond)
rownames(crit) <- c('NCA','CA')
critprops <- crit
critprops[,1] <- critprops[,1]/sum(critprops[,1])
critprops[,2] <- critprops[,2]/sum(critprops[,2])
print(critprops)

print('Criterial DV chi-square test')
print(chisq.test(crit,correct=FALSE))

print('Dimensions DV chi-square test')
print(chisq.test(tbl,simulate.p.value=TRUE, B = 200000))

print('Dimensions DV Bayesian contingency table')
library(conting)
#Reshape data
y <- c(tbl[,1],tbl[,2])
cond <- c(rep('incidental',4),rep('intentional',4))
ndim <- c(rep(c(1,2,3,4),2))
mb <- data.frame(cond,ndim,y)

print("MC methods, 10k iterations (not stable with fewer)")
test <- bcct(formula=y~(ndim+cond)^2,data=mb,n.sample=10000,prior="UIP")
summary(test)
print("Bayes Factor")
print(.75/.24) # Done manually for simplicity (could read test structure directly)
