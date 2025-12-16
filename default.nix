{
  pkgs ? import <nixpkgs>,
  prev ? pkgs,
}:
rec {
  advantagescope = pkgs.callPackage ./pkgs/advantagescope { };
  choreo = pkgs.callPackage ./pkgs/choreo { };
  elastic-dashboard = pkgs.callPackage ./pkgs/elastic-dashboard { };
  pathplanner = pkgs.callPackage ./pkgs/pathplanner { };
  wpilib = pkgs.lib.recurseIntoAttrs (pkgs.callPackage ./pkgs/wpilib { });
  frc-nix-update = pkgs.callPackage ./pkgs/frc-nix-update { };

  vscode-extensions = prev.vscode-extensions // {
    wpilibsuite = { inherit (wpilib) vscode-wpilib; };
  };
}
