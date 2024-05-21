{ lib
, flutter319
, fetchFromGitHub
, copyDesktopItems
, stdenv
, libuuid
, makeDesktopItem
,
}:
flutter319.buildFlutterApplication rec {
  pname = "pathplanner";
  version = "2024.1.7";

  src = fetchFromGitHub {
    owner = "mjansen4857";
    repo = pname;
    rev = version;
    hash = "sha256-A8HGBpkO4xmUoWS5+Fz5IO81/G0NKI0pIemDgUFN9SY=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  nativeBuildInputs = [ copyDesktopItems ];

  # libblkid on Linux
  buildInputs = lib.optionals stdenv.isLinux [ libuuid ];

  postUnpack = ''
    # Make the version shown in the GUI match the actual version instead of "0.0.0"
    substituteInPlace source/pubspec.yaml \
      --replace "version: 0.0.0+1" "version: ${version}"
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
    maintainers = with maintainers; [ max-niederman ];
  };
}
