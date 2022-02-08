---
layout: page
title: Docker and Jupyter
subtitle: Some introductory notes
---

## Summary

Maintaining a working, GPU-enabled, copy of tensorflow is a pain the ass; one alternative is to use docker and jupyter:

1. Do a base install of Ubuntu 20.04, including NVIDIA drivers (just the driver, no need for CUDA etc).

1. Install docker: `sudo snap install docker`

1. Follow [these instructions](https://www.tensorflow.org/install) to install tensorflow as a docker image. 

1. Follow [these instructions](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker) to install _tensorflow-gpu_. 

From here, operate as root (or use `sudo`)

1. Create a docker volume to keep your files in: `docker volume create tensorflow-vol`

1. Start your docker instance `docker run --gpus all -d -p 8888:8888 -v tensorflow-vol:/tf/objnt tensorflow/tensorflow:latest-gpu-jupyter`

1. This will return a hash e.g. `91c4ed2a15bed01eeecdcc6a993a474f10868718b694d5e752502f46bfa520e6`.

1. Use the first few characters to get the URL for the jupyter notebook: `docker exec 91 jupyter notebook list`

1. Open the notebook in your browser.

**Make sure you save your files in your volume (which will appear as the `objnt` directory in this example**. Any other location may be lost. 

- You can get a command into the container like this: `docker exec -i -t 91 /bin/bash`

## Future stuff

- While everything here assumes your browser is on the same physical machine as your docker container, it should be possible to run the notebook from a remote machine, using an SSH tunnel (see tutorial provided by [anaconda](https://docs.anaconda.com/anaconda/user-guide/tasks/remote-jupyter-notebook/)).

