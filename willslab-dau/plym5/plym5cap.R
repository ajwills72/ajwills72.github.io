plym5cap <- function(crittype = 2, antype = 0, msave = FALSE) { 
  # Apply learning criterion
  pass <- subset(bigdta, phase == 2 & stim < 9 & blk < blktype+1)
  trls <- 8 * blktype # Number of trials making up the criterion-passing test
  pass.sc <- (2/3) * (blktype * 10) # Note, * 10 rather than * 8, due to double-weighting of prototype.
  # Work out training item score
  o <- 0
  corr <- array(0, dim=c(ppts,5))
  colnames(corr) <- c('subj','cond','cb','keyb','correct') 
  for (j in 1:ppts) {
    for (i in 1:trls) {
      if ( pass[i+o,'stim'] == 1 | pass[i+o,'stim'] == 5 ) inc <- 2 else inc <- 1
      if ( pass[i+o,'stim'] < 5 & pass[i+o,'resp'] == 1 ) corr[j,5] = corr[j,5] + inc
      if ( pass[i+o,'stim'] > 4 & pass[i+o,'resp'] == 0 ) corr[j,5] = corr[j,5] + inc  
    }
    corr[j,1] <- pass[o+1,'subj']
    corr[j,2] <- pass[o+1,'cond']
    corr[j,3] <- pass[o+1,'cb']
    corr[j,4] <- pass[o+1,'keyb']
    o <- o + trls
  }
  corr <- as.data.frame(corr)
  # If appropriate, select only passing participants
  if (crittype == 2) {passes <- subset(corr, correct >= pass.sc)} else {passes <- corr}
  passdta <- NULL
  for (i in passes$subj) {
    passdta <- rbind(passdta, subset(bigdta, subj == i & phase == 2))
  }  		
  # Now examine scores on the critical stimuli
  # Extract test phase critical stimuli
  critstim <- subset(passdta, stim > 8 & stim < 11)
  ppts <- length(passes$subj)
  trls <- 16
  #Run loop to count how many times participants made judgements of FR or CA on critical items
  o <- 0
  count <- array(0, dim=c(ppts,6))
  colnames(count) <- c('ppt','cond','cb','keyb','famres','critatt')
  for (j in 1:ppts) {
    for (i in 1:trls) {
      if (critstim[i + o, 'stim'] == 9 & critstim[i + o, 'resp'] == 1) count[j,5] = count[j,5] + 1
      if (critstim[i + o, 'stim'] == 9 & critstim[i + o, 'resp'] == 0) count[j,6] = count[j,6] + 1
      if (critstim[i + o, 'stim'] == 10 & critstim[i + o, 'resp'] == 1) count[j,6] = count[j,6] + 1
      if (critstim[i + o, 'stim'] == 10 & critstim[i + o, 'resp'] == 0) count[j,5] = count[j,5] + 1
    }
    count[j,1] <- critstim[o+1,'subj']
    count[j,2] <- critstim[o+1,'cond']
    count[j,3] <- critstim[o+1,'cb']
    count[j,4] <- critstim[o+1,'keyb']
    o <- o + trls
  }
  count <- as.data.frame(count)
  count$famres <- count$famres / 16
  count$critatt <- count$critatt / 16
  print("Total participants per condition")
  print(paste("Intentional: ",length(corr$subj[corr$cond == 1])))
  print(paste("Incidental: ",length(corr$subj[corr$cond == 2])))
  print("Participants passing criterion, per condition")
  print(paste("Intentional: ",length(passes$subj[passes$cond == 1])))
  print(paste("Incidental: ",length(passes$subj[passes$cond == 2])))
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
  bigmod <- array(0, dim=c(ppts,13))
  colnames(bigmod) <- c("pptno","cond","cb","keyb","fr", "ca", "nca1", "nca2", "nca3", "lk", "rk", "model", "consist")
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
    bigmod[j,'keyb'] <- passdta[o+1,'keyb']
    bigmod[j,5:11] = mdl
    bigmod[j,'model'] = which.max(mdl)
    bigmod[j,'consist'] = max(mdl)
    o = o + trls
  }
  # Model: 1-FR; 2-CA; 3-5-NCA; 6-7-KEY
  print("Response-set descriptives")
  mbt <- table(bigmod[,'cond'],bigmod[,'model'])
  fr <- mbt[,1]
  ca <- mbt[,2]
  nca <- mbt[,3] + mbt[,4] + mbt[,5] 
  mbts <- cbind(fr,ca,nca)
  row.names(mbts) <- c('CAT','INC')
  mbts[1,] <- mbts[1,]/sum(mbts[1,])
  mbts[2,] <- mbts[2,]/sum(mbts[2,])
  print(mbts)
  
  # Back to counts for chi-square
  mbts <- cbind(fr,ca,nca)
  row.names(mbts) <- c('CAT','INC')
  print("OS vs other")
  c <- rbind(c(mbts[1,'fr'],mbts[1,'nca']+mbts[1,'ca']),c(mbts[2,'fr'],mbts[2,'nca']+mbts[2,'ca']))
  print(chisq.test(c,simulate.p.value=TRUE))
  print("NCA vs other")
  c <- rbind(c(mbts[1,'nca'],mbts[1,'fr']+mbts[1,'ca']),c(mbts[2,'nca'],mbts[2,'fr']+mbts[2,'ca']))
  print(chisq.test(c,correct=FALSE))
  print("CA vs other")
  c <- rbind(c(mbts[1,'ca'],mbts[1,'fr']+mbts[1,'nca']),c(mbts[2,'ca'],mbts[2,'fr']+mbts[2,'nca']))
  print(chisq.test(c,correct=FALSE))
  
  
  print("SUPPLEMENTARY ANALYSES")
  # Removing the position bias people...
  bigmod <- bigmod[bigmod[,'model'] < 5,]
  bigmf <- as.data.frame(bigmod)
  # ...and combining the three NCA strategies
  bigmf$model[bigmf$model == 1] <- 'fr'
  bigmf$model[bigmf$model == 2] <- 'ca'
  bigmf$model[bigmf$model == 3] <- 'nca'
  bigmf$model[bigmf$model == 4] <- 'nca'
  bigmf$model[bigmf$model == 5] <- 'nca'
  
  # Create a NCA column, selecting the best of the three UD fits
  bigmf$nca <- pmax(bigmf$nca1,bigmf$nca2,bigmf$nca3)
  
  # Closest competitor analysis
  bigmf$win.margin <- 0
  for (i in 1:nrow(bigmf)) {
    tmp <- c(bigmf[i,'fr'],bigmf[i,'ca'],bigmf[i,'nca'])
    tmp <- tmp[order(tmp)]
    bigmf$win.margin[i] <- tmp[3] - tmp[2]
  }
  
  #Convert to proportions
  bigmf$consist <- bigmf$consist / trls
  bigmf$fr <- bigmf$fr / trls
  bigmf$ca <- bigmf$ca / trls
  bigmf$nca <- bigmf$nca / trls
  bigmf$win.margin <- bigmf$win.margin / trls
  
  #Relabel conditions for ease
  bigmf$cond[bigmf$cond==1] <- 'intentional'
  bigmf$cond[bigmf$cond==2] <- 'incidental'
  
  #Dump out model data for analysis across experiments.
  if(msave == TRUE) save(bigmf, file='plym5models.RData')
  
  print('Table S4')
  
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
  
  if(antype == 0) {
    print('Remove OS (sample too small)')
    bigmfnoos <- bigmf[bigmf$model != 'fr',]
    print('Response model type effect on consistency')
    print(t.test(consist ~ model, data = bigmfnoos,var.equal=TRUE))
    print('Response model type effect on margin')
    print(t.test(win.margin ~ model, data = bigmfnoos,var.equal=TRUE))   
  }
  
  if(antype == 1) {
    print('Response model type effect on consistency')
    a1 <- aov(consist ~ model, data = bigmf)
    print(summary(a1))
    print(TukeyHSD(a1))
    print('Response model type effect on margin')
    a1 <- aov(win.margin ~ model, data = bigmf)
    print(summary(a1))
    print(TukeyHSD(a1))
  }
  print('Intentional/incidental effect on consistency')
  print(t.test(consist ~ cond, data = bigmf,var.equal=TRUE))
  print('Intentional/incidental effect on margin')
  print(t.test(win.margin ~ cond, data = bigmf,var.equal=TRUE)) 

}
