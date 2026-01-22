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
    { self
    , nixpkgs
    , nix-github-actions
    ,
    }:
    let
      inherit (nixpkgs) lib;

      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "armv7l-linux"
        "armv6l-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forEachPkgs = f: lib.genAttrs supportedSystems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      githubActions = nix-github-actions.lib.mkGithubMatrix {
        checks = lib.getAttrs [ "x86_64-linux" ] self.packages;
      };

      overlays.default =
        final: prev:
        import ./. {
          pkgs = final;
          inherit prev;
        };

      packages = forEachPkgs (
        pkgs:
        let
          packages = import ./. { inherit pkgs; };
        in
        lib.attrsets.filterAttrs
          (_: pkg:
            builtins.elem pkgs.stdenv.hostPlatform.system pkg.meta.platforms
            && !(pkg.meta.broken or false)
          )
          {
            inherit (packages)
              advantagescope
              choreo
              elastic-dashboard
              pathplanner
              frc-nix-update
              ;
            inherit (packages.wpilib)
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

      formatter = forEachPkgs (pkgs: pkgs.nixfmt-tree);

      devShells = forEachPkgs (pkgs: {
        default = pkgs.mkShell {
          name = "frc-nix";
          packages = [
            pkgs.nushell
            self.packages.${pkgs.stdenv.hostPlatform.system}.frc-nix-update
          ];
        };
      });
    };
}
