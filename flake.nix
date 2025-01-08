{
  description = "Nix packages for the FIRST Robotics Competition, maintained by team 4451 (originally created by 3636).";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    nix-github-actions = {
      url = "github:nix-community/nix-github-actions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "armv7l-linux"
        "armv6l-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
    in
    {
      githubActions = inputs.nix-github-actions.lib.mkGithubMatrix {
        checks = inputs.nixpkgs.lib.getAttrs [ "x86_64-linux" ];
      };

      overlays.default = final: prev: {
        advantagescope = final.callPackage ./pkgs/advantagescope { };
        choreo = final.callPackage ./pkgs/choreo { };
        elastic-dashboard = final.callPackage ./pkgs/elastic-dashboard { };
        pathplanner = final.callPackage ./pkgs/pathplanner { };
        wpilib = final.recurseIntoAttrs (final.callPackage ./pkgs/wpilib { });

        vscode-extensions = prev.vscode-extensions // { wpilibsuite.vscode-wpilib = final.wpilib.vscode-wpilib; };
      };
    }
    //
    (inputs.flake-utils.lib.eachSystem supportedSystems
      (system:
        let
          pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [ inputs.self.overlays.default ];
          };
          inherit (pkgs) lib;
        in
        {
          # Packages exposed through flake outputs
          packages = lib.attrsets.filterAttrs
            (_: pkg: builtins.elem system pkg.meta.platforms)
            {
              inherit (pkgs)
                advantagescope
                choreo
                elastic-dashboard
                pathplanner
                ;
              inherit (pkgs.wpilib)
                datalogtool
                glass
                outlineviewer
                pathweaver
                roborioteamnumbersetter
                robotbuilder
                shuffleboard
                smartdashboard
                sysid
                wpical
                vscode-wpilib
                wpilib-utility
                ;
            };

          formatter = pkgs.nixpkgs-fmt;

          devShell = pkgs.mkShell {
            name = "frc-nix";
            packages = with pkgs; [
              nushell
            ];
          };
        }));
}
