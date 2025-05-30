print("DAU: EXE6")
# Andy Wills - 27 Oct 2014

print("Classic analysis")
# Load data
cdta <- read.csv("exe6classic.csv")
# Express as proportion
cdta$ud <- cdta$ud / 12
cdta$os <- cdta$os / 12
cdta$other <- cdta$other / 12
print("Effect of load on OS prevalence")
print(t.test(cdta$os~cdta$cond, var.equal = TRUE))
print("Effect of load on OTHER prevalence")
print(t.test(cdta$other~cdta$cond, var.equal = TRUE))
print("Effect of load on UD prevalence")
print(t.test(cdta$ud~cdta$cond, var.equal = TRUE))

print("Objective sort analysis")
# Define sort strategies
ud1 <- c(1,2,1,1,1,2,1,2,2,2)
ud2 <- c(1,1,2,1,1,2,2,1,2,2)
ud3 <- c(1,1,1,2,1,2,2,2,1,2)
ud4 <- c(1,1,1,1,2,2,2,2,2,1)
oss <- c(1,1,1,1,1,2,2,2,2,2)
# Load data
w <- read.csv("exe6data.csv")
# Set up array containing details of model fits for each block of each participant
# This is a 3D array. Third dimension is participants. Rows are blocks. Columns are various
# calculations about that block
# ud.win - UD strategy selected (1 = Yes, 0 = No)
# os.win - OS strategy selected
# ot.win - OTHER strategy selected
# fit.ud1 - Number of responses predicted by a strategy of responding on the basis of the first stimulus dimension
# fit.ud2 - ... 2nd stimulus dimension 
# fit.ud3 - ... 3rd stimulus dimension
# fit.ud4 - ... 4th stimulus dimension.
# fit.oss - ... overall similarity
# mdl.win - Used by program to populate other columns.

op <- array(0,c(12,11,42))
colnames(op) <- c('subj','block','ud.win','os.win','ot.win','fit.ud1','fit.ud2','fit.ud3','fit.ud4','fit.oss','mdl.win')
# Set up summary array containing proportion of UD, OS, and Other sorts for each participant
kd <- array(0,c(42,5))
colnames(kd) <- c('cond','ud','os','ot','subj')

for (ppt in 1:42) { 
	for (block in 1:12) { 
		st <- 1 + block * 10 + (ppt-1) * 130 # First row in data file for this block
		nd <- 10 + block * 10 + (ppt-1) * 130 # Last row in data file for this block
		obju <- cbind(w[st:nd,"stim"],w[st:nd,"resp"]) # Extract classification decisions for this block
		obj <- obju[order(obju[,1]),] # Order by stimulus number
    # Compare matches to specified strategies
		fit <- c(sum(ud1==obj[,2]),sum(ud2==obj[,2]),sum(ud3==obj[,2]),sum(ud4==obj[,2]),sum(oss==obj[,2]))
		# Set winning model to one with highest score 
    # (unless highest score is less than 9, in which case select 'other' as winner. The mdl number for other is 0)
		if(max(fit) > 8) {mdl <- which.max(fit)} else {mdl <-0}
    # Where the highest score is less than 10, sometimes more than one model fits equally well.
    # These are treated as missing data (mdl number is set to 99)
		if(max(fit) == 9 && sum(fit==9) > 1) {mdl <- 99}
    # Classify models as UD, OS, or Other, and indicate whether that model class has won (1) or lost (0)
		if(mdl==0) {ot <- 1} else {ot <- 0}
		if(mdl==5) {os <- 1} else {os <- 0}
		if(mdl > 0 && mdl < 5) {ud <-1} else {ud <-0}
    # Where the model is 99 (a tie), set to NA (not a number) in order to code as missing data.
		if(mdl==99) {
			ot <- NA
			os <- NA
			ud <- NA
		}
		op[block,,ppt] <- c(w[st,'subj'],w[st,'block'],ud, os, ot, fit,mdl)
    cond <- w$cond[st]
		kd[ppt,] <- c(cond, mean(op[,'ud.win',ppt],na.rm = TRUE),mean(op[,'os.win',ppt], na.rm = TRUE),mean(op[,'ot.win',ppt], na.rm = TRUE), w[st,"subj"])
	}
}
kd <- data.frame(kd)
print("Effect of load on OS prevalence")
print(t.test(kd$os~kd$cond, var.equal = TRUE))
print("Effect of load on OTHER prevalence")
print(t.test(kd$ot~kd$cond, var.equal = TRUE))
print("Effect of load on UD prevalence")
print(t.test(kd$ud~kd$cond, var.equal = TRUE))


