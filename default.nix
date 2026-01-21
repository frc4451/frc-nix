{
  pkgs ? import <nixpkgs>,
}:
/**
  https://github.com/NixOS/nixpkgs/blob/0726f235730331846135184e71d1d1bc3a4b49ad/lib/filesystem.nix#L235-L361

  Transform a directory tree containing package files suitable for
  `callPackage` into a matching nested attribute set of derivations.

  For a directory tree like this:

  my-packages
  ├── a.nix
  ├── b
  │  ├── my-extra-feature.patch
  │  ├── package.nix
  │  └── support-definitions.nix
  └── my-namespace
   ├── c.nix
   └── d
      └── package.nix

  `packagesFromDirectoryRecursive` will produce an attribute set like this:

  {
    a = pkgs.callPackage ./my-packages/a.nix { };
    b = pkgs.callPackage ./my-packages/b/package.nix { };
    my-namespace = {
      c = pkgs.callPackage ./my-packages/my-namespace/c.nix { };
      d = pkgs.callPackage ./my-packages/my-namespace/d/package.nix { };
    };
  }
*/
pkgs.lib.packagesFromDirectoryRecursive {
  inherit (pkgs) callPackage newScope;
  directory = ./pkgs;
}
