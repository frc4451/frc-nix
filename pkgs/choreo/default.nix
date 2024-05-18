{ lib, fetchurl, appimageTools, makeDesktopItem }:

let
  pname = "choreo";
  version = "2024.2.1";

  desktopItem = makeDesktopItem {
    type = "Application";
    name = "Choreo";
    desktopName = "Choreo";
    comment = "A graphical tool for planning time-optimized trajectories for autonomous mobile robots in the FIRST Robotics Competition.";
    icon = "choreo";
    exec = "choreo %u";
  };

  icon = fetchurl {
    url = "https://raw.githubusercontent.com/SleipnirGroup/Choreo/v${version}/icon/icon.svg";
    hash = "sha256-HKCzFijS08MKwsMsfTW9ohxWDqyqhRpLhuBjwVWWKPE=";
  };
in
appimageTools.wrapType2 {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/SleipnirGroup/Choreo/releases/download/v${version}/Choreo-v${version}-Linux-x86_64.AppImage";
    hash = "sha256-PMBmzLKLsCIbdZjsHUyFjBm7l2nuSGRztA+gB7BLNik=";
  };

  extraInstallCommands = ''
    install -D "${desktopItem}/share/applications/"* -t $out/share/applications/
    install -D ${icon} $out/share/pixmaps/choreo.svg
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
