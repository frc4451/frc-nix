{ lib, stdenv, fetchurl, appimageTools }:

let
  pname = "advantagescope";
  version = "3.2.1";

  src = {
    x86_64-linux = fetchurl {
      url = "https://github.com/Mechanical-Advantage/AdvantageScope/releases/download/v${version}/advantagescope-linux-x64-v${version}.AppImage";
      hash = "sha256-s9JcUApkAa5V5AYT+4ZqlvsiB0b/P3rptTDHo160P3U=";
    };

    aarch64-linux = fetchurl {
      url = "https://github.com/Mechanical-Advantage/AdvantageScope/releases/download/v${version}/advantagescope-linux-arm64-v${version}.AppImage";
      hash = "sha256-MgPCiOv8Fpvlg8V8H+3Oe+IpyY6jwi6W49yLzwmSeKI=";
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
    maintainers = with maintainers; [ max-niederman ];
  };
}
