print("DAU: PLYM9")
print("Author: Andy Wills")
print("Date: 2014-11-21")
load('exe1sum2.RData')
exe1 <- subset(bigmf,select = c('exp','cond','subj','model','consist','win.margin'))
load('plym1sum2.RData')
plym1 <- subset(bigmf,select = c('exp','cond','subj','model','consist','win.margin'))
load('plym2sum2.RData')
plym2 <- subset(bigmf,select = c('exp','cond','subj','model','consist','win.margin'))
load('plym3sum2.RData')
plym3 <- subset(bigmf,select = c('exp','cond','subj','model','consist','win.margin'))
rm(bigmf)
bigmf <- rbind(exe1,plym1,plym2,plym3)
rm(plym1,plym2,plym3,exe1)

print("Mean consistency")
mean(bigmf$consist)
print("Mean margin")
mean(bigmf$win.margin)

print('Table S4')

print('N (collapse condition)')
print(aggregate(consist ~ model,data=bigmf,length))

print('Consistency (collapse condition)')
print(aggregate(consist ~ model,data=bigmf,mean))

print('Margin (collapse condition)')
print(aggregate(win.margin ~ model,data=bigmf,mean))

print('Response model type effect on consistency')
a1 <- aov(consist ~ model, data = bigmf)
print(summary(a1))
print(TukeyHSD(a1))

print('Response model type effect on margin')
a1 <- aov(win.margin ~ model, data = bigmf)
print(summary(a1))
print(TukeyHSD(a1))

print('***END***')


