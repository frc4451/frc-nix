# A NixOS Distribution for FRC

> [!WARNING]
> If you are having problems with choreo building make sure that you haven't overwritten the nixpkgs input and that you are using the version from this repo. For more info see [`#11`](https://github.com/frc4451/frc-nix/issues/11)

This repository contains Nix packages for use in the FIRST Robotics Competition.

Try it out by running a development tool

```sh
nix run github:frc4451/frc-nix#sysid # or glass, pathplanner, datalogtool, etc.
```

## Package Updates

This repository includes automated package updates:

- **Auto-updates**: GitHub Actions runs daily to check for package updates
- **Manual updates**: `nix run .#frc-nix-update` (updates to latest versions + formats files)
- **Dry run**: `nix run .#frc-nix-update -- --dry-run` (preview updates)

# Why doesn't my Simulation GUI work?

The simgui in WPILib is kinda weird. For Java a couple prerequisites must be met for it to launch:

## 1) Proper JDK

You must be using the proper JDK which is normally the JDK that comes in the WPILib installer, sadly it is not currently packaged by this project. Once you have it installed, set `$JAVA_HOME` to it's location, from your shell `export JAVA_HOME="$HOME"/wpilib/2025/jdk/` should normally suffice.

## 2) Simgui Enabled

- `$HALSIM_EXTENSIONS` must be set to a valid `libhalsim_gui.so`.
- One can be found in the `build/` folder of your repository.
- Alternatively add `wpi.sim.addGui().defaultEnabled = true` to your `build.gradle`

## 3) Env Setup

You can either set these up in your shell by sourcing a script similar to the one below (this script assumes that you are in the root of your project directory when being ran) or mak

```sh
export HALSIM_EXTENSIONS="$PWD"/build/jni/release/libhalsim_gui.so # if not setting up build.gradle
export JAVA_HOME="$HOME"/wpilib/2025/jdk/
```

## 4) 🎉

`./gradlew simulateJava`

## 5) Troubleshooting

If you get `GLFW Error 65542: GLX: Failed to load GLX` when trying to open the simgui you may need to LibGL to nix-ld.

```nix
programs.nix-ld = {
  enable = true;
  libraries = with pkgs; [
    ...,
    libGL,
  ];
};
```
