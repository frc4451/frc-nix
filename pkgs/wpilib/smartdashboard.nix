{ buildJavaTool }:

buildJavaTool {
  pname = "smartdashboard";

  name = "SmartDashboard";

  artifactHashes = {
    linuxx64 = "sha256-waZ07PCT6LVCqEGNGTRldD6WHXzybDkTSsOAtj1qGGw=";
    macx64 = "sha256-ImBQV/aUKTTgvDsybH4FgmrDYrCK7KQaHQiHAmbyIgw=";
  };

  iconSvg = ./wpilib_logo.svg;

  meta = {
    description = "A simple and resource-efficient FRC dashboard";
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
