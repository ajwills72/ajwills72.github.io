---
layout: page
title: willslab-ply
subtitle: Lab compute server
---

## Specifications

- i7-8700 @ 3.2GHz, 32GB 

- Nvidia Quadro P200 5GB 

- 1TB SSD system drive

- 1TB SSD dataset drive (mounted at `/mnt/datasets`)


## Configuration

- Ubuntu 20.04; CUDA 11.4; cuDNN 8.2.2

- R 4.1.0; R packages: MRAN 2021-05-19

- Python 3.8.10; Tensorflow 2.5.0 (GPU enabled)

_Note:_ Configuring CUDA/cuDNN/Tensorflow is fiddly; this [Medium](https://medium.com/@harishmasand/installing-tensorflow-with-gpu-cuda-and-cudnn-in-ubuntu-20-04-ab2208c06c4a) post by Harish Masand from August 2021 was helpful.


## Datasets

`/mnt/datasets/objectnet` (190GB) - The [ObjectNet](https://objectnet.dev/) image set.


## Logging on

1. Be on campus, or connect to the campus network via the VPN.

2. Log on via SSH: `user@10.224.46.144`. If you want to be able to e.g. view images, you can `ssh -X user@10.224.46.144` and use the `eog` command.

## Using tensorflow

In order to use Tensforflow, you must edit your `.bashrc` file. Each user must do this once. Specifically, add this to the end of your file:

```
export LD_LIBRARY_PATH=/usr/local/cuda-11.4/lib64:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
```

save, exit, and then `source ~/.bashrc`

## Remote reboot

Remote reboot via SSH was set up following [these instructions](https://freundschafter.com/research/how-to-create-and-open-an-encrypted-ubuntu-linux-18-04-server-with-dropbear-through-ssh/) concerning `dropbear-initramfs`. Currently, only AW has the SSH key required to gain access to this functionality, and only AW knows the password to decrypt the drive once access is granted. Send an SMS to AW in case of emergency. 

There are three steps

1. Reboot: `sudo reboot`

2. Unlock drive: `ssh root@10.224.46.144 -p 8022 -i ~/.ssh/id_rsa`, wait until you see the "please unlock" dialog including the final colon, type in the password that was used to encrypt the drive. 

3. Now you can log in normally, as per above.

