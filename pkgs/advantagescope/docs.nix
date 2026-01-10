{ buildNpmPackage
, src
, pname
, version
, ...
}:
buildNpmPackage (finalAttrs: {
  pname = pname + "-docs";
  inherit version src;

  sourceRoot = "${finalAttrs.src.name}/docs";
  npmDepsHash = "sha256-HQW8MXBRnVATMKwmhZQbaOb1Img/q0BUXOR4A3BlMDE=";

  buildPhase = ''
    npm run build-embed
  '';

  installPhase = ''
    cp -r ./build $out
  '';
})
