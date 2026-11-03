# AdvantageScope XR

In order to use AdvantageScope XR, TCP port 56328 needs to be opened. This can be done on NixOS like this:

```nix
networking.firewall.allowedTCPPorts = [ 56328 ];
```