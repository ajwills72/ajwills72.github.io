print("DAU: PLY49")
print("19-May-2015")
print("Andy Wills")
print("----------")
library(catlearn)
library(reshape2)
source('n94func.R')
data(shj61) # Results of Nosofsky et al. (1994)
load('n94training')

### Define model parameters ####
init.state <- list( 
  colskip = 3, r = 1, q = 1, alpha = c(1,1,1), 
  w = array(0,dim=c(2,8)),
  h = cbind( c(0,0,0), c(0,0,1), c(0,1,0), c(0,1,1), 
             c(1,0,0), c(1,0,1), c(1,1,0), c(1,1,1)),
  c = 0, phi = 0, la = 0, lw = 0
) # Variable parameters are set below.

### Replicate process by which best-fitting parameters were found

print('Parameter optimization')
print('----------------------')
optmeth = "L-BFGS-B"
lb <- c(0.0001,0.0001,0.0001,0.0001)
ub <- c(20,20,.99,.99)
ctrl <- list(trace=6)
print('Optimization function: optim')
print(paste0('Optimization method:',optmeth))
print('Upper bounds: ')
print(ub)
print('Lower bounds: ')
print(lb)
print('Control parameters (see ?optim)')
print(ctrl)

params <- c(1,1,0.01,0.5); names(params) <- c('c','phi','la','lw')
iter <<- 0
result2 <- optim(params, alcove.shj.optim, method = optmeth, 
                 lower = lb, upper = ub, control = ctrl )
print(result2)
print('-----------------')
print('Note: 15 other starting points were tried, see comments')
print('in source code.')

### Optimization across multiple starting conditions.

#This one crashed the optimization routine.
#params <- c(1,1,0.01,0.01); names(params) <- c('c','phi','la','lw')
#iter <<- 0
#result1 <- optim(params, alcove.shj.optim, method = optmeth, 
#                 lower = lb, upper = ub, control = ctrl )

# This one did not complete
#params <- c(1,1,0.5,0.01); names(params) <- c('c','phi','la','lw')
#result3 <- optim(params, alcove.shj.optim, method = optmeth, 
#                 lower = lb, upper = ub, control = ctrl )

#params <- c(1,1,0.5,0.5); names(params) <- c('c','phi','la','lw')
#result4 <- optim(params, alcove.shj.optim, method = optmeth, 
#                 lower = lb, upper = ub, control = ctrl )

# This one did not complete
#params <- c(1,10,0.01,0.01); names(params) <- c('c','phi','la','lw')
#result5 <- optim(params, alcove.shj.optim, method = optmeth, 
#                 lower = lb, upper = ub, control = ctrl )

#params <- c(1,10,0.01,0.5); names(params) <- c('c','phi','la','lw')
#result6 <- optim(params, alcove.shj.optim, method = optmeth, 
#                 lower = lb, upper = ub, control = ctrl )

# This one did not complete.
#params <- c(1,10,0.5,0.01); names(params) <- c('c','phi','la','lw')
#result7 <- optim(params, alcove.shj.optim, method = optmeth, 
#                 lower = lb, upper = ub, control = ctrl )

#params <- c(1,10,0.5,0.5); names(params) <- c('c','phi','la','lw')
#result8 <- optim(params, alcove.shj.optim, method = optmeth, 
#                 lower = lb, upper = ub, control = ctrl )

#params <- c(10,1,0.01,0.01); names(params) <- c('c','phi','la','lw')
#result9 <- optim(params, alcove.shj.optim, method = optmeth, 
#                 lower = lb, upper = ub, control = ctrl )

#params <- c(10,1,0.01,0.5); names(params) <- c('c','phi','la','lw')
#result10 <- optim(params, alcove.shj.optim, method = optmeth, 
#                 lower = lb, upper = ub, control = ctrl )

#params <- c(10,1,0.5,0.01); names(params) <- c('c','phi','la','lw')
#result11 <- optim(params, alcove.shj.optim, method = optmeth, 
#                 lower = lb, upper = ub, control = ctrl )

#params <- c(10,1,0.5,0.5); names(params) <- c('c','phi','la','lw')
#result12 <- optim(params, alcove.shj.optim, method = optmeth, 
#                 lower = lb, upper = ub, control = ctrl )

#params <- c(10,10,0.01,0.01); names(params) <- c('c','phi','la','lw')
#result13 <- optim(params, alcove.shj.optim, method = optmeth, 
#                 lower = lb, upper = ub, control = ctrl )

#params <- c(10,10,0.01,0.5); names(params) <- c('c','phi','la','lw')
#result14 <- optim(params, alcove.shj.optim, method = optmeth, 
#                 lower = lb, upper = ub, control = ctrl )

#params <- c(10,10,0.5,0.01); names(params) <- c('c','phi','la','lw')
#result15 <- optim(params, alcove.shj.optim, method = optmeth, 
#                 lower = lb, upper = ub, control = ctrl )

#params <- c(10,10,0.5,0.5); names(params) <- c('c','phi','la','lw')
#result16 <- optim(params, alcove.shj.optim, method = optmeth, 
#                 lower = lb, upper = ub, control = ctrl )

#result2$value
#result4$value
#result8$value
#result6$value
#result9$value
#result10$value
#result11$value
#result12$value
#result13$value
#result14$value
#result15$value
#result16$value

# Results 2,4, and 11, all report same SSE of 0.1585874
#result2$par
#result4$par
#result11$par
#...and all return the same parameters

