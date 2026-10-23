{
  lib,
  frc-nix-maintainers,
  stdenv,
  appimageTools,
  fetchurl,
  unzip,
}:
let
  pname = "limelight-hardware-manager";
  version = "2.0.13";

  system = stdenv.hostPlatform.system;
  arch = lib.removeSuffix "-linux" system;
  fileName = "LimelightHardwareManager-${arch}_${lib.strings.replaceString "." "_" version}.AppImage";

  hashes = {
    "x86_64-linux" = "sha256-TpwDo/n4I4PCgX3ptKxZYZV7Cd/NeDOtMqLiZ1wOlqk=";
    "aarch64-linux" = "sha256-uOoIU26v9HcjSloQiivFesTLxHjiUiW8oRy0/XVMmKI=";
  };
in
appimageTools.wrapType2 (finalAttrs: {
  inherit pname version;

  src = fetchurl {
    url = "https://downloads.limelightvision.io/software/${fileName}.zip";
    hash = hashes.${system};

    downloadToTemp = true;
    recursiveHash = true;
    nativeBuildInputs = [ unzip ];
    postFetch = ''
      unzip $downloadedFile
      install -Dm755 *.AppImage $out
    '';
  };

  appimageContents = appimageTools.extract {
    inherit (finalAttrs) pname version src;
  };

  extraInstallCommands = ''
    # Install udev rule for rpiboot permissions, activate with udev.packages
    install -Dm644 ${./99-limelight-rpiboot.rules} $out/etc/udev/rules.d/99-limelight-rpiboot.rules

    # Install and modify desktop entry
    install -Dm444 ${finalAttrs.appimageContents}/limelight-hardware-manager.desktop -t $out/share/applications
    install -Dm444 ${finalAttrs.appimageContents}/limelight-hardware-manager.png -t $out/share/pixmaps

    substituteInPlace $out/share/applications/limelight-hardware-manager.desktop \
      --replace-fail 'Exec=/usr/bin/limelight-hardware-manager' 'Exec=${finalAttrs.meta.mainProgram}'
  '';

  extraPkgs = pkgs: [ pkgs.icu ];

  # Allow the package to see the udev rules installed (for the green indicator)
  extraBwrapArgs = [ "--ro-bind-try /etc/udev /etc/udev" ];

  meta = {
    mainProgram = "limelight-hardware-manager";
    description = "Hardware management utility for Limelight devices";
    homepage = "https://docs.limelightvision.io";
    license = lib.licenses.unfree;
    maintainers = with frc-nix-maintainers; [ blaze-developer ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
