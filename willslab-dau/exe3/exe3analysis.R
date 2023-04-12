print("DAU: EXE3")
print("Author: Andy Wills")
print("Date: 2015-03-19")
dta <- read.table("exe3data.txt", header = TRUE, stringsAsFactors = FALSE, sep = "\t")
bnam <- c("At","Ax","Bw","Fe","He","Mo","Ta")

print("Phase 1 - Last two sessions, with accuracy")
for (bird in 1:7) {
  p <- subset(dta,phase.name == "T1" & subj == bird)
  summary <- tapply(p$acc,list(p$sess),mean)
  print(bnam[bird])
  print(summary[(length(summary)-1):length(summary)])
}

print("Phase 2 - 1st session accuracy")
for (bird in 1:7) {
  p <- subset(dta,phase.name == "T2" & subj == bird & sess == 1)
  print(paste(bnam[bird],": ",mean(p$acc)))
}

print("Phase 2 - Last two sessions, with accuracy")
for (bird in 1:7) {
  p <- subset(dta,phase.name == "T2" & subj == bird)
  summary <- tapply(p$acc,list(p$sess),mean)
  print(bnam[bird])
  print(summary[(length(summary)-1):length(summary)])
}

print("Phase 3 - Last two sessions, with accuracy")
for (bird in 2:7) {
  p <- subset(dta,phase.name == "T3" & subj == bird)
  summary <- tapply(p$acc,list(p$sess),mean)
  print(bnam[bird])
  print(summary[(length(summary)-1):length(summary)])
  print(paste0('N correct across last two blocks: ',128*mean(summary[(length(summary)-1):length(summary)])))
}
print("")
print("Lowest N correct across last two blocks is 88,")
print("so minimum chi-square is: ")
chnce <- c(88,128-88)
names(chnce) <- c('pass','fail')
print(chisq.test(chnce))

print("Phase 4 - Last two sessions, with accuracy")
for (bird in 2:7) {
  p <- subset(dta,phase.name == "T4" & subj == bird)
  summary <- tapply(p$acc,list(p$sess),mean)
  print(bnam[bird])
  print(summary[(length(summary)-1):length(summary)])
  print(paste0('N correct across last two blocks: ',128*mean(summary[(length(summary)-1):length(summary)])))
}
print("")
print("Lowest N correct across last two blocks is 87,")
print("so minimum chi-square is: ")
chnce <- c(87,128-87)
names(chnce) <- c('pass','fail')
print(chisq.test(chnce))

print("Phase 5 - 1st session, accuracy by trial type (familiar, novel)")
outb <- NULL
for (bird in 2:7) {
  p <- subset(dta,phase.name == "T5" & subj == bird & sess == 1)
  summary <- tapply(p$acc,list(p$stimtype),mean)
  cpat <- (summary['A'] + summary['B'] + summary['AB'] + summary['BA'] +
             summary['C'] + summary['D'] + summary['CD'] + summary['DC']
             ) / 8
  ipat <- (summary['E'] + summary['F'] + summary['GH'] + summary['HG'] +
             summary['IJ'] + summary['JI'] + summary['K'] + summary['L']) / 8
  
  famil <- (cpat + ipat) / 2
  
  novel <- ( summary['EF'] + summary['FE'] + summary['I'] + summary['J'] +
              summary['G'] + summary['H'] + summary['KL'] + summary['LK']) / 8
  out <- cbind(famil,novel)
  row.names(out) <- bnam[bird]
  outb <- rbind(outb,out)
}
print(outb)

print("All six birds are below")
print("0.5 on the novel items. Being above or below 0.5 is")
print("equally likely by chance. Hence,the probability of them all being")
print("below 0.5 by chance is 0.5^6 = 0.015, 1-tailed, ")
print(", or 0.03, 2-tailed")
print("Same logic for familiar items performance being above 0.5.")

print("Phase 5 - Last two sessions, with accuracy")
for (bird in 2:7) {
  p <- subset(dta,phase.name == "T5" & subj == bird)
  summary <- tapply(p$acc,list(p$sess),mean)
  print(bnam[bird])
  print(summary[(length(summary)-1):length(summary)])
}
