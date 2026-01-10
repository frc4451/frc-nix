{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, copyDesktopItems
, unzip
, wrapGAppsHook3
, webkitgtk_4_0
, makeDesktopItem
}:
let
  pname = "choreo";
  version = "2025.0.3";

  src = fetchurl {
    url = "https://github.com/SleipnirGroup/Choreo/releases/download/v${version}/Choreo-v${version}-Linux-x86_64-standalone.zip";
    hash = "sha256-sB7en5sPEJfDRBL8CYLCLeTXYp46n3K6qXG4w/w1aZI=";
  };

  icon = fetchurl {
    url = "https://raw.githubusercontent.com/SleipnirGroup/Choreo/v${version}/src-tauri/icons/icon.svg";
    hash = "sha256-HKCzFijS08MKwsMsfTW9ohxWDqyqhRpLhuBjwVWWKPE=";
  };
in
stdenv.mkDerivation {
  inherit pname;
  inherit version;

  inherit src;

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    unzip
    wrapGAppsHook3
  ];

  buildInputs = [
    webkitgtk_4_0
  ];

  sourceRoot = ".";
  unpackCmd = "unzip \"$src\"";

  installPhase = ''
    runHook preInstall

    install -Dm555 ${pname} "$out"/bin/${pname}
    install -Dm555 ${pname}-cli "$out"/bin/${pname}-cli

    install -Dm444 ${icon} "$out"/share/pixmaps/${pname}.svg

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      desktopName = "Choreo";
      name = pname;
      exec = pname;
      icon = pname;
      comment = "A graphical tool for planning time-optimized trajectories for autonomous mobile robots in the FIRST Robotics Competition";
      categories = [ "Development" ];
      keywords = [ "FRC" "Motion Profile" "Path Planning" ];
    })
  ];

  meta = with lib; {
    description = "A graphical tool for planning time-optimized trajectories for autonomous mobile robots in the FIRST Robotics Competition";
    homepage = "https://sleipnirgroup.github.io/Choreo/";
    license = licenses.bsd3;
    mainProgram = "choreo";
    platforms = [ "x86_64-linux" ];
    broken = true;
  };
}
