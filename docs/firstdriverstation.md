# FIRST Driver Station (NixOS)

## App permissions

To use the FIRST Driver Station you need your user to be in the input group:

```nix
users.users.alice.extraGroups = [ "input" ];
```

This allows it to access the keyboard for global input and E-Stop functionality.

You can also install the udev rules from the documentation like so:

```nix
{
  services.udev.packages = [ pkgs.wpilib.firstdriverstation ];
}
```

However, it's currently unclear whether these udev rules are actually required, as the DS appears to work fine without them.

## App Scaling

The Driver Station uses the Avalonia framework, and runs through XWayland. On wayland with a HiDPI screen this might cause the app to be too small to be readable. The scaling of the app can be controlled by the `AVALONIA_GLOBAL_SCALE_FACTOR` variable:

```nix
environment.sessionVariables.AVALONIA_GLOBAL_SCALE_FACTOR = 2;
```
