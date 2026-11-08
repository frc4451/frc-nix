# REV Hardware Client 2 (NixOS)

Upstream Documentation: <https://docs.revrobotics.com/rev-hardware-client-2>

## Permissions

To allow the REV Hardware Client to connect and manage REV devices, you must install the udev rules provided by the package:

```nix
services.udev.packages = [ pkgs.rev-hardware-client-2 ];
```

Alternatively, you can add your user to the `dialout` and `plugdev` groups:

```nix
users.users.alice.extraGroups = [
  "dialout" # For configuring REV devices over USB
  "plugdev" # For flashing REV devices in recovery mode
];
```
