{ stdenv
, fetchurl
, autoPatchelfHook
, wrapGAppsHook3
, lib
, unzip
,
}:
stdenv.mkDerivation rec {
  pname = "elastic-dashboard";
  version = "2025.0.1";

  src = fetchurl {
    url = "https://github.com/Gold872/elastic-dashboard/releases/download/v${version}/Elastic-Linux.zip";
    hash = "sha256-891++x9dS3/DAbCWq1mT3AE6Rsnqy6ZqFGMAgcDP7uI=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook3
    unzip
  ];

  sourceRoot = ".";
  unpackCmd = ''unzip "$src"'';

  installPhase = ''
    runHook preInstall

    # make the needed directories
    mkdir -p "$out"/bin
    mkdir -p "$out"/opt/${pname}

    # copy over program files
    cp -r ./* "$out"/opt/${pname}

    chmod +x "$out"/opt/${pname}/elastic_dashboard

    ln -s "$out"/opt/${pname}/elastic_dashboard "$out"/bin/elastic_dashboard

    runHook postInstall
  '';

  meta = with lib; {
    mainProgram = "elastic_dashboard";
    description = "A simple and modern dashboard for FRC";
    homepage = "https://github.com/Gold872/elastic-dashboard";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
