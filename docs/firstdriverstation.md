# FIRST Driver Station (NixOS)

To use the FIRST Driver Station you need your user to be in the input group and to enable the module for udev rules and a security wrapper around the package.

```nix
{
  imports = [ frc-nix.nixosModules.firstdriverstation ];
  programs.firstdriverstation.enable = true;
}
```
