---
layout: page
title: DeepSim
subtitle: School of Psychology Deep Learning Workstation
---

DeepSim is a multi-user workstation for CPU- and GPU-intensive compute jobs, which first came available in April 2022. [history](deep-sim-history.md).

Further details, including how to log on, are on the private github repo [deepsim](https://github.com/ajwills72/deepsim). Request access to this repo from Andy Wills.

## Specifications

- CPU: 64 thread; 3.5/4.2 GHz (Threadripper PRO)

- RAM: 128GB (8 x 16GB)

- 2 x GPU: RTX3090 24GB

- 2TB M.2 SSD (system + home directories)

- 4TB Seagate IronWolf Pro 3.5 (large datasets - access on request)

- Ubunutu 20.04 (CUDA 11.4)

## Benchmarking

- **Training ResNet50 on Imagenet**: 25 minutes / epoch (both GPUs, all GPU memory used, batch = 256, tensorflow/keras). This is a _45X speedup_ relative to willslab_ply (batch = 16).




