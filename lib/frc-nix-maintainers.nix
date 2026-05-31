# Maintainers for frc-nix packages.
#
# If you are already listed in nixpkgs' maintainers list
# (https://github.com/NixOS/nixpkgs/blob/master/maintainers/maintainer-list.nix),
# use `inherit (lib.maintainers) yourhandle;` below.
# Otherwise, add a full attrset.
#
# To find a GitHub user ID:
#   gh api users/<username> --jq .id
#   Or, just visit: https://api.github.com/users/<username>
#
# Example entries:
#   inherit (lib.maintainers) alice;          # already in nixpkgs
#   bob = {                                    # not in nixpkgs
#     name = "Bob";
#     github = "bob";
#     githubId = 12345678;
#   };

{ lib }:

with lib.maintainers;

{
  inherit taciturnaxolotl;
}
