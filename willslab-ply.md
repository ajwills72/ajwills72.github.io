---
layout: page
title: willslab-ply
subtitle: Lab compute server
---

## Specifications

- i7-8700 @ 3.2GHz, 32GB 

- Nvidia Quadro P200 5GB 

- 2 x 1TB SSD


## Configuration

- Ubuntu 20.04; CUDA 11.4

- R 4.1.0; R packages: MRAN 2021-05-19

- Python 3.8.10; Tensorflow 2.5.0 (GPU enabled)


## Logging on

1. Be on campus, or connect to the campus network via the VPN.

2. Log on via SSH: `user@10.224.46.144` 


## Remote reboot

Remote reboot via SSH was set up following [these instructions](https://freundschafter.com/research/how-to-create-and-open-an-encrypted-ubuntu-linux-18-04-server-with-dropbear-through-ssh/) concerning `dropbear-initramfs`. Currently, only AW has the SSH key required to gain access to this functionality, and only AW knows the password to decrypt the drive once access is granted. Send an SMS to AW in case of emergency. 

There are three steps

1. Reboot: `sudo reboot`

2. Unlock drive: `ssh root@10.224.46.144 -p 8022 -i ~/.ssh/id_rsa`, wait until you see the "please unlock" dialog including the final colon, type in the password that was used to encrypt the drive. 

3. Now you can log in normally, as per above.

