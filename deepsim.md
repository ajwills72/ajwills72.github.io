---
layout: page
title: DeepSim
subtitle: School of Psychology Deep Learning Workstation
---

DeepSim is a multi-user workstation for CPU- and GPU-intensive compute jobs. Only sysadmins have `sudo` on this system; some users have non-root access to `docker`. DeepSim is currently open to a limited number of experienced users, for the purposes of testing. [sysadmin notes](deepsim-config.md).

DeepSim was first requested in Jun 2021, with funding agreed in January 2022, and early-access testing in April 2022. [history](deep-sim-history.md) .


## Specifications

- CPU: 64 thread; 3.5/4.2 GHz (Threadripper PRO)

- RAM: 128GB (8 x 16GB)

- 2 x GPU: RTX3090 24GB

- 2TB M.2 SSD (system + home directories)

- 4TB Seagate IronWolf Pro 3.5 (large datasets - access on request)

- Ubunutu 20.04 (CUDA 11.4)


## Logging on

1. Be on campus, or connect to the campus network via the VPN.

2. Log on via SSH: `user@10.224.46.142`. If you want to be able to e.g. view images, you can `ssh -X user@10.224.46.142` and use the `eog` command.



