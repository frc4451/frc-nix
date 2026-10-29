# Limelight Hardware Manager

## Flashing

In order to flash devices over Raspberry Pi USB boot, you need the proper user permissions. On NixOS, this is done by installing the udev rules included in the package:

```nix
services.udev.packages = [ pkgs.limelight-hardware-manager ];
```

The udev rules can be found [here](../pkgs/limelight-hardware-manager/).

## Discovery

In order to properly discover and find devices on the network, your firewall must be configured. On NixOS, this can be done by adding this to your configuration:

```nix
# Open the ports necessary for Limelight discovery
networking.firewall.allowedUDPPorts = [ 5808 5809 ];

# Configure firewall to allow connections from the source port 5808. Required for Limelight discovery V2
networking.firewall.extraCommands = ''
    iptables --append nixos-fw --protocol udp --source-port 5808 --jump nixos-fw-accept
'';
```

If you are using the nftables firewall backend, `extraCommands` is ignored. Keep the `allowedUDPPorts` line above and replace `extraCommands` with:
```nix
networking.firewall.extraInputRules = ''
  udp sport 5808 accept
'';
```