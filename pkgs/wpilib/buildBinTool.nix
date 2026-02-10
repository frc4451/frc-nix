{
  lib,
  allwpilibSources,
  stdenv,
  fetchurl,
  unzip,
  autoPatchelfHook,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,
  libGL,
  libx11,
  zenity,
}:
lib.extendMkDerivation {
  constructDrv = stdenv.mkDerivation;
  excludeDrvArgNames = [
    "humanName"
    "artifactHashes"
    "fileDialogPackage"
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
      fileDialogPackage ? zenity,
      meta ? { },
      ...
    }@args:
    let
      inherit (allwpilibSources) branch;
      inherit (allwpilibSources.native) version;

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
        }
        .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

      libraries = [
        stdenv.cc.cc
        libGL
        libx11
      ]
      ++ extraLibs;

      mainProgram = args.meta.mainProgram or pname;
    in
    {
      inherit pname version;

      src = fetchurl {
        url = "https://frcmaven.wpi.edu/artifactory/${branch}/edu/wpi/first/tools/${humanName}/${version}/${humanName}-${version}-${wpilibSystem.os}${wpilibSystem.arch}.zip";
        hash =
          artifactHashes."${wpilibSystem.os}${wpilibSystem.arch}"
            or (throw "No hash for ${wpilibSystem.os}${wpilibSystem.arch}");
      };

      nativeBuildInputs = [
        copyDesktopItems
        makeWrapper
        unzip
      ]
      ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
        autoPatchelfHook
      ];

      buildInputs = libraries;
      runtimeDependencies = libraries;

      unpackPhase =
        args.unpackPhase or ''
          runHook preUnpack

          unzip $src

          runHook postUnpack
        '';

      installPhase = ''
        runHook preInstall

        ${
          if stdenv.hostPlatform.isDarwin then
            ''
              # macOS ships as .app bundles
              if [ -d ${wpilibSystem.os}/${wpilibSystem.arch}/${humanName}.app ]; then
                mkdir -p $out/Applications
                cp -r ${wpilibSystem.os}/${wpilibSystem.arch}/${humanName}.app $out/Applications/

                mkdir -p $out/bin
                cat > $out/bin/${mainProgram} << 'WRAPPER_EOF'
              #!/bin/sh
              exec "$out/Applications/${humanName}.app/Contents/MacOS/${mainProgram}" "$@"
              WRAPPER_EOF
                chmod +x $out/bin/${mainProgram}
              else
                # Fallback to plain binary if .app doesn't exist
                install -Dm 755 ${wpilibSystem.os}/${wpilibSystem.arch}/${mainProgram} $out/bin/${mainProgram}
              fi
            ''
          else
            ''
              install -Dm 755 ${wpilibSystem.os}/${wpilibSystem.arch}/${mainProgram} $out/bin/${mainProgram}
            ''
        }

        ${lib.optionalString (
          iconPng != null
        ) "install -Dm 555 ${iconPng} $out/share/pixmaps/${humanName}.png"}
        ${lib.optionalString (
          iconSvg != null
        ) "install -Dm 555 ${iconSvg} $out/share/icons/hicolor/scalable/apps/${humanName}.svg"}

        runHook postInstall
      '';

      postFixup = lib.optionalString (fileDialogPackage != null) ''
        wrapProgram $out/bin/${mainProgram} \
          --prefix PATH : ${lib.makeBinPath [ fileDialogPackage ]}
      '';

      desktopItems = [
        (makeDesktopItem {
          name = humanName;
          desktopName = humanName;
          exec = mainProgram;
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
