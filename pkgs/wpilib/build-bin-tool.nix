{ lib
, allwpilibSources
, stdenv
, runCommand
, fetchurl
, unzip
, autoPatchelfHook
, copyDesktopItems
, makeDesktopItem
, libGL
, xorg
, gnome
}:

{ name
, pname ? lib.strings.toLower name
, artifactHashes
, iconPng ? null
, iconSvg ? null
, extraLibs ? [ ]
, meta ? { }
, ...
} @ args:
let
  inherit (allwpilibSources) version;

  wpilibSystem =
    let
      linuxarm32 = {
        os = "linux";
        arch = "arm32";
      };
      linuxarm64 = {
        os = "linux";
        arch = "arm64";
      };
      linuxx86-64 = {
        os = "linux";
        arch = "x86-64";
      };
      osxuniversal = {
        os = "osx";
        arch = "universal";
      };
    in
      {
        x86_64-linux = linuxx86-64;
        aarch64-linux = linuxarm64;
        armv7l-linux = linuxarm32;
        armv6l-linux = linuxarm32;
        x86_64-darwin = osxuniversal;
        aarch64-darwin = osxuniversal;
      }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  libraries = [
    stdenv.cc.cc
    libGL
    xorg.libX11
  ] ++ extraLibs;

  mainProgram = args.meta.mainProgram or pname;
in
stdenv.mkDerivation ({
  inherit version;

  src = fetchurl {
    url = "https://frcmaven.wpi.edu/artifactory/release/edu/wpi/first/tools/${name}/${version}/${name}-${version}-${wpilibSystem.os}${wpilibSystem.arch}.zip";
    hash = artifactHashes."${wpilibSystem.os}${wpilibSystem.arch}" or (throw "No hash for ${wpilibSystem.os}${wpilibSystem.arch}");
  };

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    unzip
  ];

  buildInputs = libraries;
  runtimeDependencies = libraries;

  unpackPhase = ''
    runHook preUnpack

    unzip $src

    runHook postUnpack
  '';

  installPhase = with lib.strings; ''
    runHook preInstall

    install -Dm 755 ${wpilibSystem.os}/${wpilibSystem.arch}/${mainProgram} $out/bin/${mainProgram}

    ${optionalString (iconPng != null) "install -Dm 555 ${iconPng} $out/share/pixmaps/${name}.png"}
    ${optionalString (iconSvg != null) "install -Dm 555 ${iconSvg} $out/share/icons/hicolor/scalable/apps/${name}.svg"}

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      inherit name;
      desktopName = name;
      exec = mainProgram;
      comment = meta.description or null;
      icon = if iconPng != null || iconSvg != null then name else null;
    })
  ];

  meta = (with lib; {
    platforms = [ "x86_64-linux" "aarch64-linux" "armv7l-linux" "armv6l-linux" "x86_64-darwin" ];
    license = licenses.bsd3;
    maintainers = with maintainers; [ max-niederman ];
  } // meta);
} // removeAttrs args [ "name" "artifactHashes" "extraLibs" "meta" ])
