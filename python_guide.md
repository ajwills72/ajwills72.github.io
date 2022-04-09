---
layout: page
title: Python Guide
subtitle: A set of inchoate notes that might one day be useful to others
---

## Reproducibility

- [`requirements.txt`](https://learnpython.com/blog/python-requirements-file/): Specifying the packages your script needs.

## Base Python

`\` is a line continuation (allows one to split one logical line of code over multiple actual lines). 

## [numpy](https://numpy.org/)

Provides core functions for dealing with multidimensional arrays; this provides R, or MATLAB, like vectorization. Also provides a bunch of other useful vectorized functions, such as random number generation, taking an exponent, 

By convention, one does `import numpy as np`, and thus commands are refernced e.g. `np.zeros(4)`.  

### Arrays

#### Creating arrays

- `np.arange(4)` returns `array([0, 1, 2, 3])` - an array of size 4 whose components count up from zero. 

- `np.array([[1,2],[3,4]])` returns a numpy array with those numbers in. 

- `np.zeros(4)` returns `array([0, 0, 0, 0])` 

#### Querying arrays

- `np.argmax([3,1,9])` returns `2` i.e. the index of the largest value.

- `np.max([3, 1, 9])` returns `9`, i.e. the value of the largest value. 

- `np.shape([[1,3]])` returns `(1, 2)` i.e. one row, three columns

- ` np.where(UCB_estimation == q_best)[0]` , where `UCB_estimation` is a 1D array and `q_best` is a scalar returns an array of indices of UCB_estimation which are equal to q_best. 

### Random numbers

- `np.randon.choice([4, 7, 2])` randomly returns 4, 7, or 2. 

- `np.random.rand(2)` returns two values from a random uniform distribution in range 0 to 1. 

- `np.random.randn(3)` returns three values from a random normal distribution (i.e. mean = 0, variance = 1, Gaussian) e.g. `array([ 1.13611657, -1.0426574 ,  0.64690621])`

### Scientific calculator

- `np.exp([1, 2, 3])` returns `array([ 2.71828183,  7.3890561 , 20.08553692])` i.e. e to the power 1, 2, 3. 

### Basic stats

- `nparray.mean()` returns the mean of the numpy array `nparray`. 


## [matplotlib](https://matplotlib.org/) 

Can be used for making a range of plots (cf. R: base, ggplot). The `pyplot` feature is designed to give a MATLAB-like interface. Some interesting ones:

- `violinplot`

## [tqdm](https://tqdm.github.io/)

Easily add a progress bar to a loop.
