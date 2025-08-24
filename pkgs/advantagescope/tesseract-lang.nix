{
  buildNpmPackage,
  src,
  pname,
  version,
  nodejs,
  npmDepsHash,
  cacert,
  ...
}:
buildNpmPackage (finalAttrs: {
  pname = pname + "-tesseractLang";
  inherit version src npmDepsHash;

  makeCacheWritable = true;
  npmFlags = [ "--ignore-scripts" ];

  buildPhase = ''
    export NODE_EXTRA_CA_CERTS="${cacert}/etc/ssl/certs/ca-bundle.crt"
    node tesseractLangDownload.mjs
  '';

  installPhase = ''
    mkdir out
    mv ./eng.traineddata.gz ./out
    cp -r ./out $out
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "sha256-KqdFs9iN5TiWKVMjtw/tFryiLY+BmLEG8aT2S0aX444=";

  buildInputs = [ nodejs ];
})
