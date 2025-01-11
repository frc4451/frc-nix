{ stdenv
, fetchurl
, autoPatchelfHook
, wrapGAppsHook3
, lib
, unzip
, makeDesktopItem
, copyDesktopItems
}:
stdenv.mkDerivation rec {
  pname = "elastic-dashboard";
  version = "2025.0.2";

  src = fetchurl {
    url = "https://github.com/Gold872/elastic-dashboard/releases/download/v${version}/Elastic-Linux.zip";
    hash = "sha256-6bZO9BqAS2aVLYYI+qEgX11ee89GT6lpw4GHZpDukTE=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook3
    copyDesktopItems
    unzip
  ];

  sourceRoot = ".";
  unpackCmd = ''unzip "$src"'';

  installPhase = ''
    runHook preInstall

    # make the needed directories
    mkdir -p "$out"/bin
    mkdir -p "$out"/opt/${pname}

    install -Dm444 data/flutter_assets/assets/logos/logo.png "$out"/share/pixmaps/${pname}.png

    # copy over program files
    cp -r ./* "$out"/opt/${pname}

    chmod +x "$out"/opt/${pname}/elastic_dashboard

    ln -s "$out"/opt/${pname}/elastic_dashboard "$out"/bin/elastic_dashboard

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      desktopName = "Elastic";
      name = pname;
      exec = "elastic_dashboard";
      icon = pname;
      comment = meta.description;
      categories = [ "Development" ];
      keywords = [ "FRC" "Dashboard" ];
    })
  ];

  meta = with lib; {
    mainProgram = "elastic_dashboard";
    description = "A simple and modern dashboard for FRC";
    homepage = "https://github.com/Gold872/elastic-dashboard";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
