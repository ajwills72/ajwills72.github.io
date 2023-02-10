---
layout: page
title: Linux - Networks 
subtitle: Cheat sheet for networks under Linux (tested on Ubuntu)
---

## Performance monitoring

| command      | availability | Explanation                                 |
| ------------ | ------------ | ------------------------------------------- |
| `ping <URL>` | base system  | Measure connection latency and reliability  |
| `speedtest`   | apt install speedtest-cli  | Get connection's upload and download speed  |

## SSH

| command | Explanation |
| ------ | ----------- |
| `ssh -vT`    | Get a bunch of diagnostics for a connection that isn't working |
| "eval `ssh-agent -s`" then `ssh-add`    | Add SSH passphrase, so you are not repeatedly asked for it. |

**Renabling RSA** Some old servers require this deprecated protocol. Re-enable it on a host-by-host basis by adding this to `~/.ssh/config`

```
Host willslab.org.uk
    User andy
    PubkeyAcceptedAlgorithms +ssh-rsa
    HostkeyAlgorithms +ssh-rsa
```

