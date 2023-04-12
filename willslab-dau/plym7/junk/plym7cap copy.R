plym7cap <- function(crittype = 2, antype = 0) { 
  # Apply learning criterion
  pass <- subset(bigdta, phase == 3 & stim < 9 & blk < blktype+1)
  trls <- 8 * blktype # Number of trials making up the criterion-passing test
  pass.sc <- (2/3) * (blktype * 10) # Note, * 10 rather than * 8, due to double-weighting of prototype.
  # Work out training item score
  o <- 0
  corr <- array(0, dim=c(ppts,4))
  colnames(corr) <- c('subj','cond','cb','correct') 
  for (j in 1:ppts) {
    for (i in 1:trls) {
      if ( pass[i+o,'stim'] == 1 | pass[i+o,'stim'] == 5 ) inc <- 2 else inc <- 1
      if ( pass[i+o,'stim'] < 5 & pass[i+o,'resp'] == 1 ) corr[j,4] = corr[j,4] + inc
      if ( pass[i+o,'stim'] > 4 & pass[i+o,'resp'] == 0 ) corr[j,4] = corr[j,4] + inc	
    }
    corr[j,1] <- pass[o+1,'subj']
    corr[j,2] <- pass[o+1,'cond']
    corr[j,3] <- pass[o+1,'cb']
    o <- o + trls
  }
  corr <- as.data.frame(corr)
  # If appropriate, select only passing participants
  if (crittype == 2) {passes <- subset(corr, correct >= pass.sc)} else {passes <- corr}
  passdta <- NULL
  for (i in passes$subj) {
    passdta <- rbind(passdta, subset(bigdta, subj == i & phase == 3))
  }			
  # Now examine scores on the critical stimuli
  # Extract test phase critical stimuli
  critstim <- subset(passdta, stim > 8 & stim < 11)
  ppts <- length(passes$subj)
  trls <- 16
  #Run loop to count how many times participants made judgements of FR or CA on critical items
  o <- 0
  count <- array(0, dim=c(ppts,5))
  colnames(count) <- c('ppt','cond','cb','famres','critatt')
  for (j in 1:ppts) {
    for (i in 1:trls) {
      if (critstim[i + o, 'stim'] == 9 & critstim[i + o, 'resp'] == 1) count[j,4] = count[j,4] + 1
      if (critstim[i + o, 'stim'] == 9 & critstim[i + o, 'resp'] == 0) count[j,5] = count[j,5] + 1
      if (critstim[i + o, 'stim'] == 10 & critstim[i + o, 'resp'] == 1) count[j,5] = count[j,5] + 1
      if (critstim[i + o, 'stim'] == 10 & critstim[i + o, 'resp'] == 0) count[j,4] = count[j,4] + 1
    }
    count[j,1] <- critstim[o+1,'subj']
    count[j,2] <- critstim[o+1,'cond']
    count[j,3] <- critstim[o+1,'cb']
    o <- o + trls
  }
  count <- as.data.frame(count)
  count$famres <- count$famres / 16
  count$critatt <- count$critatt / 16
  print("Total participants per condition")
  print(paste("Load: ",length(corr$subj[corr$cond == 1])))
  print(paste("Full attention: ",length(corr$subj[corr$cond == 2])))
  print("Participants passing criterion, per condition")
  print(paste("Load: ",length(passes$subj[passes$cond == 1])))
  print(paste("Full attention: ",length(passes$subj[passes$cond == 2])))
  print("Traditional analysis")
  print("OS by condition t-test")
  print(t.test(famres~cond, data = count,var.equal=TRUE))
  print("Response-set analysis")
  if (antype == 0) {
    trls <- 128  
  } else {
    trls <- 80
    passdta <- subset(passdta, stim < 11)
  } 
  bigmod <- array(0, dim=c(ppts,12))
  colnames(bigmod) <- c("pptno","cond","cb","fr", "ca", "nca1", "nca2", "nca3", "lk", "rk", "model", "consist")
  o <- 0
  for (j in 1:ppts) {
    mdl <- c(0,0,0,0,0,0,0)
    for(i in 1:trls) {
      # This first part deals with the fact that some stimulus are ambiguous on an FR strategy.
      if (code[passdta[i+o,'stim'],'fr'] == 0.5) {
        mdl[1]= mdl[1] + 0.5
      } else { 
        if (code[passdta[i+o,'stim'],'fr'] == passdta[i+o,'resp']) mdl[1] = mdl[1] + 1
      }
      if (code[passdta[i+o,'stim'], 'ca'] == passdta[i+o,'resp']) mdl[2] = mdl[2] + 1
      if (code[passdta[i+o,'stim'], 'nca1'] == passdta[i+o,'resp']) mdl[3] = mdl[3] + 1
      if (code[passdta[i+o,'stim'], 'nca2'] == passdta[i+o,'resp']) mdl[4] = mdl[4] + 1
      if (code[passdta[i+o,'stim'], 'nca3'] == passdta[i+o,'resp']) mdl[5] = mdl[5] + 1
      if (code[passdta[i+o,'stim'], 'lk'] == passdta[i+o,'resp']) mdl[6] = mdl[6] + 1
      if (code[passdta[i+o,'stim'], 'rk'] == passdta[i+o,'resp']) mdl[7] = mdl[7] + 1
    }
    bigmod[j,'pptno'] <- passdta[o+1,'subj']
    bigmod[j,'cond'] <- passdta[o+1,'cond']
    bigmod[j,'cb'] <- passdta[o+1,'cb']
    bigmod[j,4:10] = mdl
    bigmod[j,'model'] = which.max(mdl)
    bigmod[j,'consist'] = max(mdl)
    o = o + trls
  }
  # Model: 1-FR; 2-CA; 3-5-NCA; 6-7-KEY
  
  print("Response-set descriptives")
  mbt <- table(bigmod[,'cond'],bigmod[,'model'])
  
  # Hand-code fudge: FR never occurs, so no level on mbt for it...
  # This has to be changed by hand therefore.
  if (antype == 0) {
    # Hand-code fudge: FR never occurs, so no level on mbt for it...
    # This has to be changed by hand therefore.
    fr <- c(0,0) 
    ca <- mbt[,1]
    nca <- mbt[,2] + mbt[,3] + mbt[,4]   
  }
  
  if (antype == 1) {
    fr <- mbt[,1] 
    ca <- mbt[,2]
    nca <- mbt[,3] + mbt[,4] + mbt[,5]   
  }
  
  mbts <- cbind(fr,ca,nca)
  row.names(mbts) <- c('LOAD','FULL')
  mbts[1,] <- mbts[1,]/sum(mbts[1,])
  mbts[2,] <- mbts[2,]/sum(mbts[2,])
  print(mbts)
  print("Consistency by condition (only the means are reported in paper)") # Look at consistency, removing the position bias people
  bigmex <- bigmod[bigmod[,'model'] < 6,]
  bigmfex <- as.data.frame(bigmex)
  bigmfex$consist <- bigmfex$consist/trls
  tdta <- subset(bigmfex, cond == 1 | cond == 2, select=c('cond','consist'))
  print(t.test(consist ~ cond, data = tdta,var.equal=TRUE))
  # Back to counts for chi-square
  mbts <- cbind(fr,ca,nca)
  row.names(mbts) <- c('LOAD','FULL')
  # More fudge coding to deal with absence of OS.
  if (antype == 0) {
    print("NCA vs CA")
    c <- rbind(c(mbts[1,'nca'],mbts[1,'fr']+mbts[1,'ca']),c(mbts[2,'nca'],mbts[2,'fr']+mbts[2,'ca']))
    print(chisq.test(c,correct=FALSE))    
  }
  if (antype == 1) {
    print("NCA vs Other")
    c <- rbind(c(mbts[1,'nca'],mbts[1,'fr']+mbts[1,'ca']),c(mbts[2,'nca'],mbts[2,'fr']+mbts[2,'ca']))
    print(chisq.test(c,correct=FALSE))
    print("CA vs other")
    c <- rbind(c(mbts[1,'ca'],mbts[1,'fr']+mbts[1,'nca']),c(mbts[2,'ca'],mbts[2,'fr']+mbts[2,'nca']))
    print(chisq.test(c,correct=FALSE))
  }
}
