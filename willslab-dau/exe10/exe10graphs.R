trainplot <- function(line_a,line_b,accl=TRUE) {
  wid <- .025
  xlen <- nrow(line_a)
  if(accl) {
      ylbl <- 'accuracy'
      spc <- 0
  } else {
      ylbl <- 'consistency'
      spc <- .1
  }
  plot(
    cbind(1:xlen-spc,line_a[,2])
    , axes = FALSE
    , xlim = c(.9,4.1)
    , ylim = c(0.5,1)
    , xlab = 'block'
    , ylab = ylbl
    , bty = 'l'
    , mgp = c(2,1,0)
    , type = 'b'
    , pch = 1
    , lty = 'solid'
  )
  box(bty='l')
  axis(1,at=1:xlen)
  axis(2,at=c(0.5,0.6,0.7,0.8,0.9,1))
  lines(cbind(1:xlen+spc,line_b[,2]),type = 'b', pch=16)
  legend("bottom",c('rule','sim'), pch = c(1,16),inset=0.05,cex=1)
  arrows(1:xlen-spc,line_a[,3],1:xlen-spc,line_a[,1],angle=90,length=wid,code=3)
  arrows(1:xlen+spc,line_b[,3],1:xlen+spc,line_b[,1],angle=90,length=wid,code=3)
}

testplot.ce <- function(ij,mn,legloc='top',ce = 'c') {
  spc <- .025
  line.ij <- ij[,2]
  line.mn <- mn[,2]
  plot(line.ij  
    , axes = FALSE
    , xlim = c(.9,2.1) # inset a bit
    , ylim = c(0,1)
    , xlab = 'group'
    , ylab ='P(allergy response)'
    , bty = 'l'
    , mgp = c(2,1,0)
    , type = 'b'
    , pch = 0
    , lty = 'solid'
  )
  box(bty='l')
  axis(1,at=c(1,2),labels = c('rule','sim'))
  axis(2,at=c(0,0.5,1))
  lines(line.mn,type = 'b', pch=16)
  if(ce == 'c') {
      legend(legloc,c('IJ','MN'), pch = c(0,16),inset=0.05,cex=.75,
             ncol=1) 
  } else {
      legend(legloc,c('O/P','K/L'), pch = c(0,16),inset=0.05,cex=.75,
             ncol=1)       
  }
  arrows(1,ij[1,3],1,ij[1,1],angle=90, length=spc,code=3)
  arrows(2,ij[2,3],2,ij[2,1],angle=90, length=spc,code=3)
  arrows(1,mn[1,3],1,mn[1,1],angle=90, length=spc,code=3)
  arrows(2,mn[2,3],2,mn[2,1],angle=90, length=spc,code=3)
}


# add_label by Sean Anderson, 2013-10-21
# http://seananderson.ca/2013/10/21/panel-letters.html
add_label <- function(xfrac, yfrac, label, pos = 4, ...) {
  u <- par("usr")
  x <- u[1] + xfrac * (u[2] - u[1])
  y <- u[4] - yfrac * (u[4] - u[3])
  text(x, y, label, pos = pos, ...)
}
