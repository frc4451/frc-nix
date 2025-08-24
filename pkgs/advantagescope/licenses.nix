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
  pname = pname + "-licenses";
  inherit version src npmDepsHash;

  makeCacheWritable = true;
  npmFlags = [ "--ignore-scripts" ];

  buildPhase = ''
    export NODE_EXTRA_CA_CERTS="${cacert}/etc/ssl/certs/ca-bundle.crt"
    node getLicenses.mjs
  '';

  installPhase = ''
    mkdir out
    mv ./src/licenses.json ./out
    cp -r ./out $out
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "sha256-53Mq7sSmTf9iQkLU5qugzGn9WF6yE665vSusTT7X+hU=";

  buildInputs = [ nodejs ];
})
