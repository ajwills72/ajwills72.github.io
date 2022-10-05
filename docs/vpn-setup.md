# Connecting to the VPN

On 12th September 2022, TIS switched over to two-factor authentication for the VPN, breaking all [previous solutions](/assets/pdf/vpn-setup-now-broken.pdf) documented on this site. So far, we've been able to get it working via a non-pay desktop app. Anyone who can work out a CLI solution, let Andy Wills know!

## Desktop app solution

1. Download the non-pay version of FortiClient for Linux, from [FortiNet](https://links.fortinet.com/forticlient/deb/vpnagent)

1. Install the .deb file you have just downloaded , e.g.: `sudo dpkg -i ~/Downloads/forticlient_vpn_7.0.0.0018_amd64.deb`

1. It's not a great package so if you get an unmet dependencies error, try `sudo apt --fix-broken install` and the do the above step again.

1. Once installed, run forticlient from the desktop.

1. Agree that you won't ask for support (tick box)

1. Configure VPN. The info needed is:

    - Connection name: Plymouth University

    - Remote Gateway:  `vpn.plymouth.ac.uk`

    - Tick "Enable single sign-on" and "Save"

1. Now go through the normal SAML login process, which will include an authentication step (I use SMS, but other options are available I believe)

## Command-line solution

Not sure there is one - let me know if you know different!
