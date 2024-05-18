{ stdenv
, lib
, allwpilibSources
, fetchurl
, autoPatchelfHook
, makeBinaryWrapper
, wrapGAppsHook3
, ffmpeg
, mesa
, nss
, systemd
, wayland
, xdg-utils
}:
stdenv.mkDerivation rec {
  pname = "wpilib-utility";
  inherit (allwpilibSources) version;

  src =
    if stdenv.hostPlatform.isLinux then
      fetchurl
        {
          url = "https://github.com/wpilibsuite/vscode-wpilib/releases/download/v${version}/wpilibutility-linux.tar.gz";
          hash = "sha256-Yhk9wXt/4Z05IyAntg9iixlV38w9KxuLyRIW6D+GW88=";
        }
    else
      fetchurl {
        url = "https://github.com/wpilibsuite/vscode-wpilib/releases/download/v${version}/wpilibutility-mac.tar.gz";
        hash = "sha256-puPcE1snS3ip4zgMtx5gJt7Z2+ucOs+f8pVWNHN9DFE=";
      };

  nativeBuildInputs = [ autoPatchelfHook makeBinaryWrapper wrapGAppsHook3 ];

  buildInputs = [
    ffmpeg
    mesa # for libgbm
    nss
    wayland
  ] ++ lib.optionals stdenv.isLinux [ systemd ];

  sourceRoot = ".";
  unpackCmd = "tar xzf \"$src\"";

  installPhase = ''
    runHook preInstall

    # make the needed directories
    mkdir -p "$out"/bin
    mkdir -p "$out"/opt/wpilib-utility

    # copy over program files
    cp -r ./* "$out"/opt/wpilib-utility

    chmod +x "$out"/opt/wpilib-utility/wpilibutility

    makeBinaryWrapper "$out"/opt/wpilib-utility/wpilibutility "$out"/bin/${pname} \
      --add-flags --disable-gpu-sandbox \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}" \
      --suffix PATH : ${lib.makeBinPath [xdg-utils]} \

    runHook postInstall
  '';

  meta = with lib; {
    mainProgram = "wpilib-utility";
    description = "WPILib VSCode Utility (Standalone)";
    homepage = "https://github.com/wpilibsuite/vscode-wpilib/tree/main/wpilib-utility-standalone";
    license = licenses.bsd3;
    maintainers = with maintainers; [ max-niederman ];
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" "aarch64-linux" "armv7l-linux" ];
  };
}
