---
layout: page
title: willslab-ply
subtitle: Lab compute workstation
---

Willslab-Ply is a 12-thread multiuser workstation for moderately CPU-intensive simulations; it was installed in Feb 2019 as part of the University fleet refresh.


## Specifications

- i7-8700 @ 3.2GHz, 64GB (12 threads)

- Nvidia Quadro P2000 5GB 

- 64GB RAM (upgraded from 32GB)

- 1TB SSD system drive

- 1TB SSD dataset drive (mounted at `/mnt/datasets`)


## Configuration

- Ubuntu 20.04.3; CUDA 11.4; cuDNN 8.2.2

- R 4.1.2; R packages: MRAN 2022-01-18

- Python 3.8.10; Tensorflow 2.5.0 (GPU enabled)

_Note:_ Configuring CUDA/cuDNN/Tensorflow is fiddly; this [Medium](https://medium.com/@harishmasand/installing-tensorflow-with-gpu-cuda-and-cudnn-in-ubuntu-20-04-ab2208c06c4a) post by Harish Masand from August 2021 was helpful.


## Datasets

`/mnt/datasets/objectnet` (190GB) - The [ObjectNet](https://objectnet.dev/) image set.

`/mnt/datasets/imagenet/` (171GB) - The [ImageNet 2012](https://image-net.org/challenges/LSVRC/index.php) image set. 

## Logging on

Request access to [private github repo](https://github.com/ajwills72/deepsim) with log-in instructions from Andy Wills.

### Using tensorflow

In order to use Tensforflow, you must edit your `.bashrc` file. Each user must do this once. Specifically, add this to the end of your file:

```
export LD_LIBRARY_PATH=/usr/local/cuda-11.4/lib64:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
```

save, exit, and then `source ~/.bashrc`

### Remote reboot

Only AW has the SSH key required to gain access to this functionality, and only AW knows the password to decrypt the drive once access is granted. Send an SMS to AW in case of emergency. 
