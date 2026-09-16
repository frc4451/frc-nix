{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchNpmDeps,
  cargo-tauri,
  glib-networking,
  # can't find a specific nodejs version so let's just pin
  # to the latest in nixpkgs to hopefully minimize future breakage
  nodejs_26,
  npmHooks,
  openssl,
  pkg-config,
  webkitgtk_4_1,
  wrapGAppsHook4,
}:

rustPlatform.buildRustPackage (final: {
  pname = "bline-web";
  version = "1.0.0-beta.3";

  src = fetchFromGitHub {
    owner = "edanliahovetsky";
    repo = "BLine-Web";
    rev = "v${final.version}";
    hash = "sha256-5//GrPC2p0oS8btpoz8YwaqyQ07LWE6zmIxW6Ci5TEc=";
  };

  # Assuming our app's frontend uses `npm` as a package manager
  npmDeps = fetchNpmDeps {
    name = "${final.pname}-${final.version}-npm-deps";
    inherit (final) src;
    hash = "sha256-TBaUjlgV5FhVTE3z/CsGQpSwZJjU7ejo3aICfOnIJTA=";
  };

  cargoHash = "sha256-MLfgwaJTUCb2hV7zgK0QtzdmZLb1AzYwg42Hl6vkA/s=";

  nativeBuildInputs = [
    # Pull in our main hook
    cargo-tauri.hook

    # Setup npm
    nodejs_26
    npmHooks.npmConfigHook

    # Make sure we can find our libraries
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ wrapGAppsHook4 ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    # Most Tauri apps need networking,
    # not sure bline does but just in case
    glib-networking

    openssl
    webkitgtk_4_1
  ];

  # Set our Tauri source directory
  cargoRoot = "src-tauri";
  # And make sure we build there too
  buildAndTestSubdir = final.cargoRoot;

  meta = with lib; {
    description = "Web and desktop editor for creating, tuning, and previewing rapid point-to-point autonomous paths for FIRST Robotics Competition";
    homepage = "https://bline-docs.pages.dev";
    license = licenses.bsd3;
    maintainers = with frc-nix-maintainers; [ artixbtw ];
    platforms = [ "x86_64-linux" ];
  };
})
