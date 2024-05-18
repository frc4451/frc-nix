{ lib, fetchurl, appimageTools }:

let
  pname = "choreo";
  version = "2024.2.2";

  src = fetchurl {
    url = "https://github.com/SleipnirGroup/Choreo/releases/download/v${version}/Choreo-v${version}-Linux-x86_64.AppImage";
    hash = "sha256-z3IdlmKWubuzSnqok7HVXnVlmLAx6JJbdxww9rk93uw=";
  };

  icon = fetchurl {
    url = "https://raw.githubusercontent.com/SleipnirGroup/Choreo/v${version}/icon/icon.svg";
    hash = "sha256-HKCzFijS08MKwsMsfTW9ohxWDqyqhRpLhuBjwVWWKPE=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -D ${icon} $out/share/pixmaps/choreo.svg
    install -D ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace "Exec=AppRun" "Exec=${pname}"
  '';

  meta = with lib; {
    description = "A graphical tool for planning time-optimized trajectories for autonomous mobile robots in the FIRST Robotics Competition";
    homepage = "https://sleipnirgroup.github.io/Choreo/";
    license = licenses.bsd3;
    mainProgram = "choreo";
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ max-niederman ];
  };
}
