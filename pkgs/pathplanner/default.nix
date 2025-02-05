{ lib
, flutter326
, fetchFromGitHub
, copyDesktopItems
, stdenv
, libuuid
, makeDesktopItem
}:
flutter326.buildFlutterApplication rec {
  pname = "pathplanner";
  version = "2025.2.2";

  src = fetchFromGitHub {
    owner = "mjansen4857";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-RTLesH7j3R9JbvNr46Tk8bHbCeMm0daeTaxSOibkPjM=";
  };

  autoPubspecLock = src + "/pubspec.lock";

  nativeBuildInputs = [ copyDesktopItems ];

  # libblkid on Linux
  buildInputs = lib.optionals stdenv.isLinux [ libuuid ];

  postUnpack = ''
    # Make the version shown in the GUI match the actual version instead of "0.0.0"
    substituteInPlace source/pubspec.yaml \
      --replace-fail "version: 0.0.0+1" "version: ${version}"
  '';

  postInstall = ''
    install -Dm444 "${src}"/images/icon.png "$out"/share/pixmaps/${pname}.png
  '';

  desktopItems = [
    (makeDesktopItem {
      desktopName = "PathPlanner";
      name = pname;
      exec = pname;
      icon = pname;
      comment = meta.description;
      categories = [ "Development" ];
      keywords = [ "FRC" "Motion Profile" "Path Planning" ];
    })
  ];

  meta = with lib; {
    mainProgram = pname;
    description = "A simple yet powerful motion profile generator for FRC robots";
    homepage = "https://pathplanner.dev";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
