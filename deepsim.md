---
layout: page
title: DeepSim
subtitle: School of Psychology Deep Learning Workstation
---

This system has budgetary approval (£9.8K), and entered the final spec /
purchasing phase on 2022-01-17.

## Planning for operation

For stability and usability, the way forward may be a docker container running tensorflow and jupyter. Some [initial notes](docker.md)


## Specifications

The spec requested to TIS is [this machine](https://www.scan.co.uk/products/3xs-dbp-g2-32t-amd-ryzen-threadripper-3970x-128gb-ram-2x-24gb-nvidia-rtx-3090-2tb-m2-ssd-4tb-hdd), which is a 64-thread CPU, 128GB RAM, 2 x RTX3090 for a total of ~20K CUDA cores and 48GB GPU memory. The (retail) cost of components is around £7,500 (see below). They want **£8,500**, which is quite a mark up, but when we previously looked at Lenovo, they wanted £13K for a less-good system. An even less good MacPro system costs around £15K. 

What follows is a justification of the primary spec. The goal here was to get a system with a 3-5 year usable life, that was the best within budget, without getting too far off the price-performance sweet spot.

### Choice of GPU

| Card | CUDA cores  | Memory (GB) | Price (GBP)  |
| ---- | ----------- | ----------- | ---------------- | 
| GTX 1060 (isaac) | 1280 | 3 | 3 | 180 (Dec 2017) |
| [Quadro P2000][1]  (willslab-ply) | 1024 | 5 | 330 |
| [RTX 3080][2] | 8960 | 12 |  900 |
| [RTX 3090][3] | 10496 | 24 |  1900 |

[Recent benchmarking][5] indicates that for 2-GPU systems running ResNet152 with a 64 batch size, you can't even do this at 32-bit precision. At 16-bit precision, RTX3090 is about twice as fast as RTX3080. Training even 5-year-old models, like ResNet152, in reasonable time needs at least 18GB of GPU memory (see below). For this workstation to have a 3-5-year useful life, two graphics cards each with 24GB does not seem overkill.

#### GPU memory calculations

Training ResNet50 with a batch size of 32 needs [7.5GB of memory][4]. The heuristic they used to work this out is (in bytes) is

( N_weights + N_nodes ) * 4 * batch_size * mask_elements

The `4` comes from 32-bit precision (so 4 bytes per number). `mask elements` is the number of elements in the convolution mask (typically 3x3 =9); this comes from the limitations of GPUs - we want them to do convolutions but they are inefficient at these, so they're converted into matrix-matrix multiplications, which are faster but use more memory. 

Using this same heuristic, and noting from `model.summary()` in tensorflow than ResNet152 has 2.3x as many parameters as ResNet50, we get an estimate of **17.25GB to train ResNet152 at a batch size of 32.** 


[1]: https://www.nvidia.com/content/dam/en-zz/Solutions/design-visualization/documents/Quadro-P2000-US-03Feb17.pdf

[2]: https://www.nvidia.com/en-gb/geforce/graphics-cards/30-series/rtx-3080-3080ti/

[3]: https://www.nvidia.com/en-gb/geforce/graphics-cards/30-series/rtx-3090/

[4]: https://www.graphcore.ai/posts/why-is-so-much-memory-needed-for-deep-neural-networks

[5]: https://bizon-tech.com/blog/best-gpu-for-deep-learning-rtx-3090-vs-rtx-3080-vs-titan-rtx-vs-rtx-2080-ti

### Choice of CPU

| CPU | threads | GHz | Price (GBP) |
| --- | ------- | --- | ----------- |
| Ryzen 5 1600X (isaac) | 12 | 2.6 | 180 (Dec 2017) |
| i7-8700 (willslab-ply) | 12 | 3.2 | 200 (Dec 2017) |
| Ryzen 9 5900X | 24 | 3.7 | 490 | 
| Ryzen Threadripper 3970X | 64 | 3.7 | 1900 |

Our CPU loads are mainly Parameter Space Partioning. Even today, we're running 96-CPU simulations on HPC systems that take days to run. The current workstations are woefully inadequate (same jobs would take weeks, and memory is inadequate). The last two options are from typical Scan Deep Learning workstations. While there is a cost premium here (2.7x the threads for 3.9x the cost), even the best available within budget is far from overkill.

### Cost of components

| Component | Price (GBP) |
| --------- | ----------- |
| RTX3090 x 2 |  3800 |
| Threadripper 3970X | 1900 |
| 128 GB RAM | 600 |
| 2TB SSD | 320 |
| 4TB HDD | 115 |
| Case    | 150 |
| 1200W PSU | 200 |
| Motherboard | 400 |

