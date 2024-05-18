{ buildJavaTool }:

buildJavaTool {
  pname = "smartdashboard";

  name = "SmartDashboard";

  artifactHashes = {
    linuxx64 = "sha256-kbeQXTMS8Z0GKiH7bD7bj8FsX4Sm7FxoibF22rhO5hs=";
    macx64 = "sha256-BefE5tBkv0pN2rv+gcXAz4wINryK4fAI12vNUBKSrmA=";
  };

  iconSvg = ./wpilib_logo.svg;

  meta = {
    description = "A simple and resource-efficient FRC dashboard";
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
