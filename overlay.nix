final: prev:
let
  pkgs' = import ./default.nix { pkgs = prev; };
in
pkgs'
// {
  vscode-extensions = prev.vscode-extensions // {
    wpilibsuite = {
      inherit (pkgs'.wpilib) vscode-wpilib;
    };
  };
}
