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
  npmDepsHash = "sha256-2gxkW6GX62mOKlvsdZhpSo9UEwEZcXucXrmRLUxnQNk=";

  buildPhase = ''
    npm run build-embed
  '';

  installPhase = ''
    cp -r ./build $out
  '';
})
