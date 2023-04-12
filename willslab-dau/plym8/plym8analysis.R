print("DAU: PLYM8")
print("Author: Andy Wills")
print("Date: 2015-05-09")
dta <- read.table("plym8data.txt", header = TRUE, stringsAsFactors = FALSE, sep = "\t")
# Define custom function for blocks to criterion analyses in Phases 1-4
dosum <- function(phasenum,crit) {
  print(paste("Phase ",phasenum))
  bigsum <- array(0,dim=c(length(subs),3))
  colnames(bigsum) <- c('subj','blks','acc')
  i <- 0
  for (hum in subs) {
    i <- i + 1
    p <- subset(dta,phase == phasenum & subj == hum)
    summary <- tapply(p$acc,list(p$blk),mean)
    bigsum[i,'subj'] <- hum
    bigsum[i,'blks'] <- length(summary)
    bigsum[i,'acc'] <- summary[length(summary)]
  }
  bigsum <- as.data.frame(bigsum)
  #bigsum <- bigsum[bigsum$acc >= crit,]
  #print("Blocks to criterion (learners)")
  #print(paste("N: ",nrow(bigsum)))  
  #print(paste("Mean: ",mean(bigsum$blks)))
  #print(paste("S.D.: ",sd(bigsum$blks)))
  #print(paste("Min: ",min(bigsum$blks)))
  #print(paste("Max: ",max(bigsum$blks)))
  return(bigsum)
}
print("Exclude non-completers from analysis")
subs <- as.numeric(levels(factor(dta$subj[dta$phase==4])))
p1 <- dosum(1,.8)
p2 <- dosum(2,.8)
p3 <- dosum(3,.8)
p4 <- dosum(4,.75)

print("Phase 5 - Familiar and novel item accuracy, by subject")
bigsum <- array(0,dim=c(length(subs),3))
colnames(bigsum) <- c('subj','famil','novel')
i <- 0
for (hum in subs) {
  i <- i + 1
  p <- subset(dta,phase == 5 & subj == hum)
  summary <- tapply(p$acc,list(p$stimtype),mean)
  cpat <- (summary['A'] + summary['B'] + summary['AB'] + summary['BA'] +
             summary['C'] + summary['D'] + summary['CD'] + summary['DC']) / 8
  ipat <- (summary['E'] + summary['F'] + summary['GH'] + summary['HG'] +
             summary['IJ'] + summary['JI'] + summary['K'] + summary['L']) / 8
  bigsum[i,'subj'] <- subs[i] - 28000
  bigsum[i,'famil'] <- (cpat + ipat) / 2
  bigsum[i,'novel'] <- ( summary['EF'] + summary['FE'] + summary['I'] + summary['J'] +
               summary['G'] + summary['H'] + summary['KL'] + summary['LK']) / 8
}
p5 <- as.data.frame(bigsum)
print(round(p5[order(p5$novel,p5$famil,decreasing=TRUE),],2))

print("Species comparison")
ch <- rbind(c(0,6),c(16,9))
print(chisq.test(ch,simulate.p.value=TRUE, B = 1000000))

print("Species comparison (exclude all failures)")
ch <- rbind(c(0,6),c(15,8))
print(chisq.test(ch,simulate.p.value=TRUE, B = 1000000))

print("Species comparison (include all, & noncompleters as similarity)")
ch <- rbind(c(0,6),c(16,13))
print(chisq.test(ch,simulate.p.value=TRUE, B = 1000000))

print("Proportion of rule and similarity responders")
ch <- c(16,9)
print(chisq.test(ch))

print('Correlational analysis (reported in General Discussion)')
fullsum <- data.frame(cbind(p5$subj,p1$blks,p1$acc,p2$blks,p2$acc,p3$blks,p3$acc,p4$blks,p4$acc,p5$famil,p5$novel))
colnames(fullsum) <- c('subj','p1blks','p1acc','p2blks','p2acc','p3blks','p3acc','p4blks','p4acc','famil','novel')
fullsum$trblks <- p1$blks + p2$blks + p3$blks + p4$blks
fullsum$rs[fullsum$novel > .5] = 'rule'
fullsum$rs[fullsum$novel < .5] = 'sim'
plot(fullsum$trblks,fullsum$novel)
print(cor.test(fullsum$trblks,fullsum$novel))
