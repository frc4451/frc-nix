{ pkgs, lib, fetchFromGitHub }:

lib.makeScope pkgs.newScope (self: with self; {
  allwpilibSources = fetchFromGitHub rec {
    passthru = {
      branch = "release";
      version = "2026.1.1-beta-1";
      java.version = "2026.1.1-beta-1";
      native.version = "2026.1.1-beta-1";
    };

    owner = "wpilibsuite";
    repo = "allwpilib";
    rev = "v${passthru.version}";
    hash = "sha256-x7yVWIS8c0cB5l4eHS+l3M77N0WKcJTiXBJgmmbjK4Y=";
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
  wpical = callPackage ./wpical.nix { };

  wpilib-utility = callPackage ./utility.nix { };
  vscode-wpilib = callPackage ./vscode-extension.nix { };
})
