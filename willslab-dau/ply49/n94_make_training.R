library(catlearn)
data(shj61)

### DEFINE 100 TRAINING ORDERS ###
# It is important to do this here, rather than during optimization,
# for two reasons. First, optimization is based on the premise that 
# the output for a given output is precisely known. If the trial 
# order is different on each function evaluation, this will not be
# true. Second, it's a lot faster.

bigtr <- array(0,dim=c(25600,11,6))
trmat <- NULL
for(i in 1:100) trmat <- rbind(trmat,shj61train(1))
bigtr[,,1] <- trmat
trmat <- NULL
for(i in 1:100) trmat <- rbind(trmat,shj61train(2))
bigtr[,,2] <- trmat
trmat <- NULL
for(i in 1:100) trmat <- rbind(trmat,shj61train(3))
bigtr[,,3] <- trmat
trmat <- NULL
for(i in 1:100) trmat <- rbind(trmat,shj61train(4))
bigtr[,,4] <- trmat
trmat <- NULL
for(i in 1:100) trmat <- rbind(trmat,shj61train(5))
bigtr[,,5] <- trmat
trmat <- NULL
for(i in 1:100) trmat <- rbind(trmat,shj61train(6))
bigtr[,,6] <- trmat
colnames(bigtr) <- c('ctrl','blk','stim','x1','x2','x3','t1','t2',
                     'm1','m2','m3')

# For replicability, this set of training orders has to be saved out
save(bigtr,file='n94training')
rm(shj61,trmat,bigtr,i)
