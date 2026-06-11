final: prev:
let
  pkgs' = import ./default.nix { pkgs = prev; };
in
# packagesFromDirectoryRecursive uses makeScope when newScope is provided, which injects
# callPackage/newScope/overrideScope/packages/recurseForDerivations into the result.
# Strip these so the overlay doesn't clobber nixpkgs' own callPackage and newScope.
(builtins.removeAttrs pkgs' [
  "callPackage"
  "newScope"
  "overrideScope"
  "packages"
  "recurseForDerivations"
])
// {
  vscode-extensions = prev.vscode-extensions // {
    wpilibsuite = {
      inherit (pkgs'.wpilib) vscode-wpilib;
    };
  };
}
