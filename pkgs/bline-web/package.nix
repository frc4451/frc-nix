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
  version = "0.1.0-alpha.12";

  src = fetchFromGitHub {
    owner = "edanliahovetsky";
    repo = "BLine-Web";
    rev = "v${final.version}";
    hash = "sha256-pFNyin2kta7FNR8LbpgMClpDwexclMNDk679cXZpc9A=";
  };

  cargoHash = "sha256-Uzx/CkOogBYuIzykYmIbYfdbuFXk3lzJdFh4McwJOpc=";

  # Assuming our app's frontend uses `npm` as a package manager
  npmDeps = fetchNpmDeps {
    name = "${final.pname}-${final.version}-npm-deps";
    inherit (final) src;
    hash = "sha256-rq0OBhYW/RZWKAYKEhgAeYEnHHaUvYqsbqCzw1IwICM=";
  };

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
