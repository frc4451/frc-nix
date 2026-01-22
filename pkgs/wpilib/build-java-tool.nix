{
  lib,
  allwpilibSources,
  stdenv,
  fetchurl,
  makeWrapper,
  temurin-jre-bin-17,
  libGL,
  xorg,
  gtk2,
  copyDesktopItems,
  makeDesktopItem,
}:

lib.extendMkDerivation {
  constructDrv = stdenv.mkDerivation;
  excludeDrvArgNames = [
    "humanName"
    "artifactHashes"
    "extraLibs"
  ];
  extendDrvArgs =
    finalAttrs:
    {
      humanName,
      pname ? lib.strings.toLower humanName,
      artifactHashes,
      iconPng ? null,
      iconSvg ? null,
      extraLibs ? [ ],
      meta ? { },
      ...
    }:
    let
      inherit (allwpilibSources) branch;
      inherit (allwpilibSources.java) version;

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
          linuxx64 = {
            os = "linux";
            arch = "x64";
          };
          macarm64 = {
            os = "mac";
            arch = "arm64";
          };
          macx64 = {
            os = "mac";
            arch = "x64";
          };
        in
        {
          x86_64-linux = linuxx64;
          aarch64-linux = linuxarm64;
          armv7l-linux = linuxarm32;
          armv6l-linux = linuxarm32;
          x86_64-darwin = macx64;
          aarch64-darwin = macarm64;
        }
        .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

      libraryPath = lib.makeLibraryPath (
        [
          stdenv.cc.cc
          libGL
          xorg.libX11
          xorg.libXtst
          gtk2
        ]
        ++ extraLibs
      );
    in
    {
      inherit version pname;

      src = fetchurl {
        url = "https://frcmaven.wpi.edu/artifactory/${branch}/edu/wpi/first/tools/${humanName}/${version}/${humanName}-${version}-${wpilibSystem.os}${wpilibSystem.arch}.jar";
        hash =
          artifactHashes."${wpilibSystem.os}${wpilibSystem.arch}"
            or (throw "No hash for ${wpilibSystem.os}${wpilibSystem.arch}");
      };

      dontUnpack = true;

      nativeBuildInputs = [
        makeWrapper
        copyDesktopItems
      ];

      installPhase = ''
        runHook preInstall

        mkdir -p $out/lib
        cp $src $out/lib/${pname}.jar
        makeWrapper ${temurin-jre-bin-17}/bin/java $out/bin/${pname} \
          --prefix LD_LIBRARY_PATH : "${libraryPath}" \
          --add-flags "-jar $out/lib/${pname}.jar"

        ${lib.optionalString (
          iconPng != null
        ) "install -Dm 555 ${iconPng} $out/share/pixmaps/${humanName}.png"}
        ${lib.optionalString (
          iconSvg != null
        ) "install -Dm 555 ${iconSvg} $out/share/icons/hicolor/scalable/apps/${humanName}.svg"}

        runHook postInstall
      '';

      desktopItems = [
        (makeDesktopItem {
          name = humanName;
          desktopName = humanName;
          exec = pname;
          comment = meta.description or null;
          icon = if iconPng != null || iconSvg != null then humanName else null;
        })
      ];

      meta = {
        platforms = [
          "x86_64-linux"
          "aarch64-linux"
          "armv7l-linux"
          "armv6l-linux"
          "x86_64-darwin"
          "aarch64-darwin"
        ];
        license = lib.licenses.bsd3;
      }
      // meta;
    };
}
