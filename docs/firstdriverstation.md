# FIRST Driver Station (NixOS)

To use the FIRST Driver Station you need your user to be in the input group and to add the package to the udev packages list.

```nix
{
  services.udev.packages = [ pkgs.wpilib.firstdriverstation ];
}
```
