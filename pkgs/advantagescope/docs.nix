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
  npmDepsHash = "sha256-dBe0n8+eqWF2HacQpEBkroHtvuGfiPlBJANdSp0s2nY=";

  buildPhase = ''
    npm run build-embed
  '';

  installPhase = ''
    cp -r ./build $out
  '';
})
