# Contributing to frc-nix

This document covers how to contribute to frc-nix. Changes are proposed via [pull requests](https://docs.github.com/pull-requests) to this repository.

A GitHub account is required. This document assumes you are already comfortable with Git and Nix basics.

## How to create pull requests

1. [Fork](https://docs.github.com/en/get-started/quickstart/fork-a-repo#forking-a-repository) and clone this repository.

2. Create a new branch for your change:

   ```sh
   git switch --create my-change
   ```

3. Make your changes, adhering to the [code conventions](#code-conventions) and [commit conventions](#commit-conventions) below.

4. Push and [open a pull request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request) targeting `season/2026`, the current development branch.

5. Respond to review feedback. Keep the PR in a mergeable state throughout.

## Commit conventions

### Package version updates

For version bumps, use the nixpkgs style:

```
package-name: old-version -> new-version
```

Examples:

```
wpilib: 2024.3.1 -> 2024.3.2
pathplanner: 2024.2.1 -> 2024.2.2
```

### Other changes

For non-version changes, use [Conventional Commits](https://www.conventionalcommits.org/) with these types:

- `feat:` — new feature or package
- `fix:` — bug fix
- `chore:` — maintenance tasks (non-version)
- `docs:` — documentation changes
- `ci:` — CI/CD changes
- `refactor:` — code refactoring

Examples:

```
feat: add glass package
fix: wpilib build on aarch64-linux
docs: add simulation guide
ci: allow unfree packages for the ds
refactor: simplify buildBinTool helper
```

### General rules

- No period at the end of the summary line.
- Each commit should represent one logical change. Squash fixup commits before merging (`git rebase -i`).
- Write in the imperative mood: "fix", "add", "update", not "fixed", "added", "updated".

## Code conventions

### Formatting

All Nix files must be formatted with [nixfmt](https://github.com/NixOS/nixfmt) via `treefmt` before submitting.

```sh
nix fmt
```

CI will reject PRs with unformatted files, so run this before pushing.

### Nix style

- Use `lowerCamelCase` for local variable names.
- For **packages**, list function arguments explicitly rather than using `...` unless the function is genuinely variadic.

  ```nix
  # good
  { stdenv, fetchurl, jdk }:

  # avoid
  { stdenv, fetchurl, jdk, ... }:
  ```

  For **modules**, use `...` to avoid breaking when new options are added.

- Avoid unnecessary string interpolation:

  ```nix
  # good
  { tag = version; }

  # avoid
  { tag = "${version}"; }
  ```

- Use `lib.optional` / `lib.optionals` for conditional list entries rather than `if ... then [...] else []`.

### Adding a new package

- Follow the structure of existing packages in the repository.
- Use `buildBinTool` or `buildJavaTool` where applicable.
- Set `meta` fields: at minimum `description`, `homepage`, `license`, `platforms`, and `maintainers`.
- Add yourself to the `maintainers` field. Packages are given `frc-nix-maintainers` as a `callPackage` argument, so take it in the argument set:

  ```nix
  { stdenv, frc-nix-maintainers }:
  # ...
  meta.maintainers = with frc-nix-maintainers; [ your-github-handle ];
  ```

  If you are not yet listed, add yourself to [`lib/frc-nix-maintainers.nix`](lib/frc-nix-maintainers.nix) first.
  Use `inherit (lib.maintainers) yourhandle;` if you're already in nixpkgs, or a full attrset otherwise.
- Verify the package builds before opening a PR:

  ```sh
  nix build .#package-name
  ```

### Updating an existing package

- Update the version and any hashes. `nix build` will report the correct hash on a mismatch.
- Verify the package still runs after updating:

  ```sh
  nix run .#package-name -- --version
  ```

- If the upstream release has a changelog, link to it in the PR description.

### Auto-updates

Many packages are updated automatically by a daily GitHub Actions workflow. Before manually updating a package, check whether an auto-update PR is already open.

## Review guidelines

- Keep reviews focused on the proposed changes. Unrelated improvements belong in follow-up PRs.
- Blocking concerns must be explicitly marked as such. Everything else is a non-blocking suggestion.
- Reviewers should aim to respond in a timely manner. PRs that sit too long accumulate merge conflicts.
- Be constructive. The goal is to get good changes merged.

## Questions?

Open an issue or start a discussion on the repository.
