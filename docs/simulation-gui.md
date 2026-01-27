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
