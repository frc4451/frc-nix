# FIRST Driver Station (NixOS)

## Permissions

### Input

Currently, in order to use the FIRST Driver Station on NixOS, you need your user to be in the input group:

```nix
users.users.alice.extraGroups = [ "input" ];
```

This allows it access to the keyboard for global input and E-Stop functionality.

### hidraw

Some controllers require your user to have access to `/dev/hidraw*` in order to use their full functionality. (e.g. the touchpad on a PS5 DualSense controller.) In this case, you will need to install the udev rules which give the active user read access to `/dev/hidraw*`:

```nix
services.udev.packages = [ pkgs.wpilib.firstdriverstation ];
```

## Scaling

The Driver Station uses the Avalonia framework, and runs through XWayland. On Wayland with a HiDPI screen this might cause the app to be too small to be readable. The scaling of the app can be controlled by the `AVALONIA_GLOBAL_SCALE_FACTOR` variable:

```nix
environment.sessionVariables.AVALONIA_GLOBAL_SCALE_FACTOR = 2;
```

## Dashboards

You will need to configure a custom dashboard override for the driver station in order to use the elastic dashboard provided by frc-nix.

First, add the elastic dashboard to your system packages:

```nix
environment.systemPackages = with pkgs; [ pkgs.elastic-dashboard ];
```

Then, create a file at `~/.firstds/DriverStationDashboardSettings.json` with the following content:

```json
{
  "CustomDashboards": [
    { "Name": "Elastic (NixOS)", "Executable": "/run/current-system/sw/bin/elastic_dashboard" }
  ]
}
```

Alternatively, this can also be done with Home Manager:

```nix
home.file.".firstds/DriverStationDashboardSettings.json".text = ''
  {
    "CustomDashboards": [
      { "Name": "Elastic (NixOS)", "Executable": "${lib.getExe pkgs.elastic-dashboard}" }
    ]
  }
'';
```

[Dashboard Settings Documentation](https://github.com/wpilibsuite/FirstDriverStation-Public/blob/main/docs/DashboardSettings.md)
