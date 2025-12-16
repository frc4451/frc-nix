{
  description = "Nix packages for the FIRST Robotics Competition, maintained by team 4451 (originally created by 3636).";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-github-actions = {
      url = "github:nix-community/nix-github-actions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      inherit (inputs.nixpkgs) lib;

      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "armv7l-linux"
        "armv6l-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forEachPkgs =
        f:
        lib.genAttrs supportedSystems (
          system:
          f (
            import inputs.nixpkgs {
              inherit system;
              overlays = [ inputs.self.overlays.default ];
            }
          )
        );
    in
    {
      githubActions = inputs.nix-github-actions.lib.mkGithubMatrix {
        checks = lib.getAttrs [ "x86_64-linux" ] inputs.self.packages;
      };

      overlays.default = final: prev: {
        advantagescope = final.callPackage ./pkgs/advantagescope { };
        choreo = final.callPackage ./pkgs/choreo { };
        elastic-dashboard = final.callPackage ./pkgs/elastic-dashboard { };
        pathplanner = final.callPackage ./pkgs/pathplanner { };
        wpilib = final.lib.recurseIntoAttrs (final.callPackage ./pkgs/wpilib { });
        frc-nix-update = final.callPackage ./pkgs/frc-nix-update { };

        vscode-extensions = prev.vscode-extensions // { wpilibsuite.vscode-wpilib = final.wpilib.vscode-wpilib; };
      };

      packages = forEachPkgs (
        pkgs:
        lib.attrsets.filterAttrs (_: pkg: builtins.elem pkgs.stdenv.hostPlatform.system pkg.meta.platforms)
          {
            inherit (pkgs)
              advantagescope
              choreo
              elastic-dashboard
              pathplanner
              frc-nix-update
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
          }
      );

      formatter = forEachPkgs (pkgs: pkgs.nixpkgs-fmt);

      devShell = forEachPkgs (pkgs: {
        default = pkgs.mkShell {
          name = "frc-nix";
          packages = with pkgs; [
            nushell
            frc-nix-update
          ];
        };
      });
    };
}
