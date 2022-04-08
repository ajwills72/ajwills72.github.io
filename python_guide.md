---
layout: page
title: Python Guide
subtitle: A set of inchoate notes that might one day be useful to others
---


## [numpy](https://numpy.org/)

Provides core functions for dealing with multidimensional arrays; this provides R, or MATLAB, like vectorization. Also provides a bunch of other useful functions, such as random number generation, argmax

### Arrays

- `numpy.arange(4)` returns `array([0, 1, 2, 3])` - so an array of size 4 whose components count up from zero. 

- `numpy.argmax([3,1,9]` returns `2` i.e. the index of the largest value.

### Random numbers

- `numpy.random.rand(2)` returns two values from a random uniform distribution in range 0 to 1. 

- `numpy.random.randn(3)` returns three values from a random normal distribution (i.e. mean = 0, variance = 1, Gaussian) e.g. `array([ 1.13611657, -1.0426574 ,  0.64690621])`



## [matplotlib](https://matplotlib.org/) 

Can be used for making a range of plots (cf. R: base, ggplot). The `pyplot` feature is designed to give a MATLAB-like interface. 

## [tqdm](https://tqdm.github.io/)

Easily add a progress bar to a loop.
