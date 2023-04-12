print("DAU: PLY49")
print("19-May-2015")
print("Andy Wills")
print("----------")
library(catlearn) # Developed with package version 0.1
library(reshape2)
source('n94func.R')
data(shj61) # Results of Nosofsky et al. (1994)
load('n94training')
print("----------")

## Model parameters 
init.state <- list( 
  colskip = 3, r = 1, q = 1, alpha = c(1,1,1), 
  w = array(0,dim=c(2,8)),
  h = cbind( c(0,0,0), c(0,0,1), c(0,1,0), c(0,1,1), 
             c(1,0,0), c(1,0,1), c(1,1,0), c(1,1,1)),
  c = 1.666, phi = 1.825, la = 0.990, lw = 0.0956
)

print("Best-fitting model parameters: ")
print(init.state)
print("SSE: ")
sres <- alcove.shj(init.state)
print(sres)