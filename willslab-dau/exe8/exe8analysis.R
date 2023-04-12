print("DAU: EXE8")
# Andy Wills - 27 Oct 2014
print("Classic analysis")

sp <- read.csv("exe8classic.csv")
print("OSPAN by sort strategy (1st block)")
print(t.test(sp$ospan~sp$block1, var.equal = TRUE))

print("Objective sort analysis")
# Define sort strategies
ud1 <- c(1,2,1,1,1,2,1,2,2,2)
ud2 <- c(1,1,2,1,1,2,2,1,2,2)
ud3 <- c(1,1,1,2,1,2,2,2,1,2)
ud4 <- c(1,1,1,1,2,2,2,2,2,1)
oss <- c(1,1,1,1,1,2,2,2,2,2)
# Load data
w <- read.csv("exe8data.csv")

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
op <- array(0,c(8,11,46))
colnames(op) <- c('subj','block','ud.win','os.win','ot.win','fit.ud1','fit.ud2','fit.ud3','fit.ud4','fit.oss','mdl.win')
# Set up summary array containing proportion of UD, OS, and Other sorts for each participant
kd <- array(0,c(46,4))
colnames(kd) <- c('ud','os','ot','subj')

for (ppt in 1:46) { 
    block <- 1
		st <- 1 + (block-1) * 10 + (ppt-1) * 80 # First row in data file for this block
		nd <- 10 + (block-1) * 10 + (ppt-1) * 80 # Last row in data file for this block
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
		kd[ppt,] <- c(op[block,'ud.win',ppt],op[block,'os.win',ppt],op[block,'ot.win',ppt], w[st,"subj"])
}
kd <- data.frame(kd)

kd$ospan <- sp$ospan # Add OSPAN scores
kd <- kd[!is.na(kd$ud),] # Remove people ambiguous on objective sort
print("OSPAN by sort strategy (1st block)")
print(t.test(kd$ospan~kd$ud, var.equal = TRUE))



