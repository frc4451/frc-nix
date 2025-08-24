{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  emscripten,
  electron,
  libGL,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  callPackage,
  isWPILibVersion ? false,
}:
let
  pname = "advantagescope";
  version = "main";

  src = fetchFromGitHub {
    owner = "Mechanical-Advantage";
    repo = "AdvantageScope";
    #tag = "v${version}";
    rev = "12793c3d7589ec7994c74f3a084a1f02afd5b92f";
    hash = "sha256-7HIwVZW9QX8kxAjQBX6rPut1ZJVG1GmpJrhP43FEcQE=";
  };

  fetchersAtters = {
    inherit
      version
      npmDepsHash
      src
      pname
      ;
  };

  docs = callPackage ./docs.nix fetchersAtters;
  licenses = callPackage ./licenses.nix fetchersAtters;
  tesseract = callPackage ./tesseract-lang.nix fetchersAtters;
  npmDepsHash = "sha256-p3FlsL4O+ylrxNJaHu2FuMZOndJ8/s5ygVL9yPFp/oI=";
in
buildNpmPackage (finalAttrs: {
  inherit
    version
    npmDepsHash
    src
    pname
    ;

  patches = [
    ./0001-change-build-targets.patch
    ./0001-fix-wasm-compile.patch
    ./0001-test.patch
  ];

  makeCacheWritable = true;
  npmFlags = [
    "--legacy-peer-deps"
    "--ignore-scripts"
  ];

  preBuild = ''
    cd $TMPDIR
    export EMSCRIPTENCACHE=$(mkdir emscriptencache)
    cd $./source
  '';

  buildPhase = ''
    export ASCOPE_DISTRIBUTION=${lib.optionalString isWPILibVersion "WPILIB"}
    cp ${licenses}/licenses.json ./src/
    npm run compile
    npm run wasm:compile
    cp -r ${docs} ./docs/build/
    cp ${tesseract}/eng.traineddata.gz ./
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist
    npx electron-builder build -l -c.electronDist=electron-dist -c.electronVersion=${electron.version}
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -r ./dist/linux-unpacked/. $out/bin/
    install -Dm444 "${src}"/icons/app/app-icons-linux/icon_512x512.png "$out"/share/pixmaps/${pname}.png

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/advantagescope \
    --set LD_LIBRARY_PATH ${
      lib.makeLibraryPath [
        libGL
      ]
    } \
    --append-flags "--no-sandbox"
  '';

  desktopItems = [
    (makeDesktopItem {
      desktopName = "AdvantageScope";
      name = pname;
      exec = "advantagescope";
      icon = pname;
      categories = [
        "Robotics"
        "Development"
      ];
      keywords = [
        "FRC"
        "Data"
        "Visualisation"
      ];
    })
  ];

  meta = {
    description = "AdvantageScope is a robot diagnostics, log review/analysis, and data visualization application for FIRST teams developed by Team 6328";
    homepage = "https://docs.advantagescope.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ me-it-is ];
  };

  nativeBuildInputs = [
    emscripten
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = [ makeWrapper ];
})
