# A NixOS Distribution for FRC

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

## Docs

- [Why doesn't my Simulation GUI work?](/docs/simulation-gui.md)

