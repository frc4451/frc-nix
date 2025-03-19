{ lib, stdenv, fetchurl, appimageTools }:

let
  pname = "advantagescope";
  version = "4.1.5";

  src = {
    x86_64-linux = fetchurl {
      url = "https://github.com/Mechanical-Advantage/AdvantageScope/releases/download/v${version}/advantagescope-linux-x64-v${version}.AppImage";
      hash = "sha256-6gAeYxcRuWrZlW0TJcLYkApkgiqMkXuDZTYW+H2q62o=";
    };

    aarch64-linux = fetchurl {
      url = "https://github.com/Mechanical-Advantage/AdvantageScope/releases/download/v${version}/advantagescope-linux-arm64-v${version}.AppImage";
      hash = "sha256-4AcbZ0Fhj7LkBjjVG+E+4Z4ik1C+sr9HjQjoPNewKII=";
    };
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  icon = fetchurl {
    url = "https://raw.githubusercontent.com/Mechanical-Advantage/AdvantageScope/v${version}/icons/window-icon.png";
    hash = "sha256-gqcCqthqM2g4sylg9zictKwRggbaALQk9ln/NaFHxdY=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm 444 ${appimageContents}/${pname}.desktop "$out"/share/applications/${pname}.desktop
    install -Dm 444 ${icon} "$out"/share/pixmaps/advantagescope.png

    substituteInPlace "$out"/share/applications/${pname}.desktop \
      --replace "Exec=AppRun" "Exec=${pname}"
  '';

  meta = with lib; {
    description = "A robot diagnostics, log review/analysis, and data visualization application for FIRST Robotics Competition teams";
    homepage = "https://github.com/Mechanical-Advantage/AdvantageScope";
    license = licenses.mit;
    mainProgram = "advantagescope";
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
