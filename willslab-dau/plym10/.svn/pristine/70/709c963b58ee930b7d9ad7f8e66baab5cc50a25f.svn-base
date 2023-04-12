binplot <-function(z) {
  plot(
    z[z$cond == 'amctrl',4]
    , axes = FALSE
    , ylim = c(40,100)
    , xlab = ''
    , ylab = '% correct'
    , mgp = c(2,1,0)
    , type = 'b'
    , pch = 16
    , lty = 'solid'
  )
  box(bty='l')
  axis(1,at=1:4,labels = c('Proto','Low-Dist','High-Dist','Rand'))
  axis(2,at=c(40,50,60,70,80,90,100))
  lines(z[z$cond == 'exp',4], type = 'b', pch = 1)
  arrows(1:4,z[z$cond == 'amctrl',5],1:4,z[z$cond == 'amctrl',3],angle=90,length=0.1,code=3)
  arrows(1:4,z[z$cond == 'exp',5],1:4,z[z$cond == 'exp',3],angle=90,length=0.1,code=3)
  legend('bottomleft',c('control','HL'), pch = c(16,1),inset=.05)
}

