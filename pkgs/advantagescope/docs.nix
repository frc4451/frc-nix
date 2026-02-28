{
  buildNpmPackage,
  src,
  pname,
  version,
  ...
}:
buildNpmPackage (finalAttrs: {
  pname = pname + "-docs";
  inherit version src;

  sourceRoot = "${finalAttrs.src.name}/docs";
  npmDepsHash = "sha256-ncKPBgbTMMJfxfWw1vfIHgwSOXKMCFc/AkdhMFheSQU=";

  buildPhase = ''
    npm run build-embed
  '';

  installPhase = ''
    cp -r ./build $out
  '';
})
