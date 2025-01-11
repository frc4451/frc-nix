{ lib, stdenv, allwpilibSources, fetchurl, makeWrapper, copyDesktopItems, makeDesktopItem, temurin-jre-bin-17 }:

stdenv.mkDerivation rec {
  pname = "robotbuilder";
  inherit (allwpilibSources.java) version;

  src = fetchurl {
    url = "https://frcmaven.wpi.edu/artifactory/${allwpilibSources.branch}/edu/wpi/first/tools/RobotBuilder/${version}/RobotBuilder-${version}.jar";
    hash = "sha256-2G+vf49gqQYqkmTDl0GoQCYQdXo9OnzeJlWZ+unW7dA=";
  };

  dontUnpack = true;

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp $src $out/lib/RobotBuilder.jar
    makeWrapper ${temurin-jre-bin-17}/bin/java $out/bin/robotbuilder \
      --add-flags "-jar $out/lib/RobotBuilder.jar"

    install -Dm 555 ${./wpilib_logo.svg} $out/share/icons/hicolor/scalable/apps/RobotBuilder.svg

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem rec {
      name = "RobotBuilder";
      desktopName = name;
      exec = "robotbuilder";
      comment = meta.description or null;
      icon = name;
    })
  ];

  meta = with lib; {
    description = "An application which generates FRC robot code";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
