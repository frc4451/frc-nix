#!/usr/bin/env bash
set -euo pipefail

# Auto-request package maintainer reviews for frc-nix PRs
# Usage: ./request-maintainer-reviews.sh <pr_number> <pr_author> <base_ref> [head_ref]

PR_NUMBER="${1:?Usage: $0 <pr_number> <pr_author> <base_ref> [head_ref]}"
PR_AUTHOR="${2:?Usage: $0 <pr_number> <pr_author> <base_ref> [head_ref]}"
BASE_REF="${3:?Usage: $0 <pr_number> <pr_author> <base_ref> [head_ref]}"
HEAD_REF="${4:-HEAD}"

range="origin/$BASE_REF...$HEAD_REF"

changed=$(git diff --name-only "$range" -- 'pkgs/' \
  | grep '\.nix$' \
  | grep -v -E '(buildBinTool|buildJavaTool|allwpilibSources|licenses|docs|tesseract-lang)\.nix$' || true)
if [ -z "$changed" ]; then
  echo "No package files changed, skipping."
  exit 0
fi

# Extract version changes from the diff
updates=""
while IFS= read -r file; do
  old_ver=$(git diff "$range" -- "$file" | grep '^-.*version\s*=' | head -1 | sed 's/.*=\s*"//;s/".*//' || true)
  new_ver=$(git diff "$range" -- "$file" | grep '^+.*version\s*=' | head -1 | sed 's/.*=\s*"//;s/".*//' || true)
  # Derive package name: pkgs/foo/package.nix -> foo, pkgs/wpilib/glass.nix -> wpilib/glass
  pkg_name=$(echo "$file" | sed 's|^pkgs/||; s|/package\.nix$||; s|\.nix$||')
  if [ -n "$old_ver" ] && [ -n "$new_ver" ] && [ "$old_ver" != "$new_ver" ]; then
    updates="${updates}- ${pkg_name}: \`${old_ver}\` -> \`${new_ver}\`\n"
  else
    updates="${updates}- ${pkg_name}\n"
  fi
done <<< "$changed"
updates=$(printf '%b' "$updates" | sort -u)

# The same names again, as a Nix list of attribute paths into the package set
paths_nix=$(echo "$changed" | sed 's|^pkgs/||; s|/package\.nix$||; s|\.nix$||' | sort -u | sed 's/.*/"&"/' | paste -sd' ' -)
reviewers_json=$(nix eval --impure --expr "
  let
    flake = builtins.getFlake (toString ./.);
    inherit (flake.inputs.nixpkgs) lib;
    lpkgs = flake.legacyPackages.x86_64-linux;

    getMaintainers = path:
      let pkg = lib.attrByPath (lib.splitString \"/\" path) null lpkgs;
      in
      lib.optionals (pkg != null && lib.isDerivation pkg) (
        map (m: m.github or null) (pkg.meta.maintainers or [ ])
      );

    handles = lib.concatMap getMaintainers [ $paths_nix ];
  in
  builtins.toJSON (lib.unique (lib.filter (h: h != null) handles))
" || echo '"[]"')

echo "Raw reviewer JSON: $reviewers_json"

reviewers=$(echo "$reviewers_json" | jq -r --arg author "$PR_AUTHOR" \
  'fromjson | [.[] | select(. != $author)] | unique')

count=$(echo "$reviewers" | jq 'length')
if [ "$count" -eq 0 ]; then
  echo "No maintainers to notify."
  exit 0
fi

mentions=$(echo "$reviewers" | jq -r '[.[] | "@" + .] | join(" ")')

echo "Notifying maintainers: $mentions"

existing=$(gh pr view "$PR_NUMBER" --json comments --jq \
  '[.comments[] | select(.body | startswith("### Packages touched"))] | length')
if [ "$existing" -gt 0 ]; then
  echo "Maintainer notification already posted, skipping."
  exit 0
fi

body=$(printf '### Packages touched\n\n%b\n\ncc maintainers: %s\n\n> [!NOTE]\n> You have been notified about this PR because you are listed as a maintainer in `meta.maintainers` in at least one of the affected packages.' "$updates" "$mentions")
gh pr comment "$PR_NUMBER" --body "$body"
