{ pkgs, lib, fetchFromGitHub }:

lib.makeScope pkgs.newScope (self: with self; {
  allwpilibSources = fetchFromGitHub rec {
    passthru.version = "2024.3.1";

    owner = "wpilibsuite";
    repo = "allwpilib";
    rev = "v${passthru.version}";
    hash = "sha256-H/dMLI2wOiJ+/Z8//Q7QzAFc51dZ3L16evLJI1UaS8c=";
  };

  buildBinTool = callPackage ./build-bin-tool.nix { };
  buildJavaTool = callPackage ./build-java-tool.nix { };

  datalogtool = callPackage ./datalogtool.nix { };
  glass = callPackage ./glass.nix { };
  outlineviewer = callPackage ./outlineviewer.nix { };
  pathweaver = callPackage ./pathweaver.nix { };
  roborioteamnumbersetter = callPackage ./roborioteamnumbersetter.nix { };
  robotbuilder = callPackage ./robotbuilder.nix { };
  shuffleboard = callPackage ./shuffleboard.nix { };
  smartdashboard = callPackage ./smartdashboard.nix { };
  sysid = callPackage ./sysid.nix { };

  wpilib-utility = callPackage ./utility.nix { };
  vscode-wpilib = callPackage ./vscode-extension.nix { };
})
