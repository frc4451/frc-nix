# Limelight Hardware Manager (NixOS)

## Permissions

In order to flash devices over Raspberry Pi USB boot, you need the proper user permissions. This is done by installing the udev rules included in the package:

```nix
services.udev.packages = [ pkgs.limelight-hardware-manager ];
```