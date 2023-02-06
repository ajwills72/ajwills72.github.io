---
layout: page
title: Linux - Setup
subtitle: Cheat sheet for setting up a under Linux server (tested on Ubuntu)
---

## Making boot media

- Download [ISO](https://releases.ubuntu.com/)

- Use [Etcher](https://www.balena.io/etcher#download-etcher) to burn ISO to a USB stick.

## Gotchas

- Don't install graphics drivers with the Ubutnu 22.04 installer, it breaks with i915 chip. 

## Expand volume to fill drive

Annoyingly, Ubuntu 22.04 server at install will leave most of a large drive unused. To fix this, following these [instructions](https://askubuntu.com/questions/1269493/ubuntu-server-20-04-1-lts-not-all-disk-space-was-allocated-during-installation).

## Additional drives

If you have additional hard drives, you will probably want to mount these at boot time. You do this by editing `/etc/fstab`. Instructions [here](https://confluence.jaytaala.com/display/TKB/Mount+drive+in+linux+and+set+auto-mount+at+boot).

## Boot failure

- [Boot repair](https://www.howtogeek.com/114884/how-to-repair-grub2-when-ubuntu-wont-boot/) fixes common problems.



